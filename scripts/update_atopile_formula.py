#!/usr/bin/env python3
# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "requests",
# ]
# ///

from dataclasses import dataclass
from enum import Enum
from pathlib import Path
import re
from typing import Any
import requests
import os

TARGET_VERSION = os.environ.get("TARGET_VERSION")

PYPI_JSON_URL = "https://pypi.org/pypi/atopile/json"
FORMULA_PATH = Path("Formula/atopile.rb")
PACKAGE_NAME = "atopile"
PYTHON_VERSION = "cp313-cp313"
SEMVER_RE = re.compile(
    r"^(?P<major>\d+)\.(?P<minor>\d+)\.(?P<patch>\d+)(?:\.(?P<prerelease>.*))?$"
)

UrlInfo = dict[str, Any]


def semver_max(version: str) -> tuple[int, ...]:
    if (match := SEMVER_RE.match(version)) is None:
        raise ValueError(f"Invalid version: {version}")

    parts = (match.group("major"), match.group("minor"), match.group("patch"))
    return tuple(map(int, parts))


def is_release(version: str) -> bool:
    if (match := SEMVER_RE.match(version)) is None:
        raise ValueError(f"Invalid version: {version}")

    return match.group("prerelease") is None


def get_latest_version() -> tuple[str, list[UrlInfo]]:
    with requests.get(PYPI_JSON_URL) as response:
        data = response.json()

    if TARGET_VERSION:
        try:
            return TARGET_VERSION, data["releases"][TARGET_VERSION]
        except KeyError as e:
            raise ValueError(
                f"Version {TARGET_VERSION} not found in PyPI releases"
            ) from e

    latest_version = max(filter(is_release, data["releases"].keys()), key=semver_max)
    return latest_version, data["releases"][latest_version]


class WheelType(Enum):
    MACOS_ARM = "macos_arm"
    MACOS_INTEL = "macos_intel"
    LINUX_X86_64 = "linux_x86_64"
    MUSL_LINUX_X86_64 = "musl_linux_x86_64"
    WINDOWS_AMD64 = "windows_amd64"


@dataclass
class WheelInfo:
    url: str
    filename: str
    digest: str

    def get_type(self) -> WheelType:
        if re.search(r"macosx_\d+_\d+_arm64", self.filename):
            return WheelType.MACOS_ARM
        elif re.search(r"macosx_\d+_\d+_x86_64", self.filename):
            return WheelType.MACOS_INTEL
        elif re.search(r"manylinux.*_x86_64", self.filename):
            return WheelType.LINUX_X86_64
        elif re.search(r"musllinux.*_x86_64", self.filename):
            return WheelType.MUSL_LINUX_X86_64
        elif re.search(r"win_amd64", self.filename):
            return WheelType.WINDOWS_AMD64
        else:
            raise ValueError(f"Unknown wheel type: {self.filename}")


def get_wheel_info(release_info: list[UrlInfo]) -> list[WheelInfo]:
    wheels = [
        WheelInfo(
            url=url_info["url"],
            filename=url_info["filename"],
            digest=url_info["digests"]["sha256"],
        )
        for url_info in release_info
        if url_info["packagetype"] == "bdist_wheel"
    ]
    wheel_types = [wheel.get_type() for wheel in wheels]

    assert WheelType.MACOS_ARM in wheel_types
    assert WheelType.MACOS_INTEL in wheel_types
    assert WheelType.LINUX_X86_64 in wheel_types
    assert WheelType.MUSL_LINUX_X86_64 in wheel_types
    assert WheelType.WINDOWS_AMD64 in wheel_types
    assert len(wheels) == 5

    return wheels


def update_formula(version: str, wheels: list[WheelInfo]) -> None:
    with FORMULA_PATH.open("r") as f:
        content = f.read()

        content = re.sub(r'version "[^"]+"', f'version "{version}"', content)

        for wheel in wheels:
            match wheel.get_type():
                case WheelType.MACOS_ARM:
                    url, sha, filename = wheel.url, wheel.digest, wheel.filename
                    content = re.sub(
                        r'(if Hardware::CPU\.arm\?\n\s+)url "[^"]+"\n\s+sha256 "[^"]+"',
                        f'\\1url "{url}"\n      sha256 "{sha}"',
                        content,
                    )
                    content = re.sub(
                        rf"{PACKAGE_NAME}-[^-]+-{PYTHON_VERSION}-macosx_11_\d+_arm64\.whl",
                        filename,
                        content,
                    )
                case WheelType.MACOS_INTEL:
                    url, sha, filename = wheel.url, wheel.digest, wheel.filename
                    content = re.sub(
                        r'(if Hardware::CPU\.intel\?\n\s+)url "[^"]+"\n\s+sha256 "[^"]+"',
                        f'\\1url "{url}"\n      sha256 "{sha}"',
                        content,
                    )
                    content = re.sub(
                        rf"{PACKAGE_NAME}-[^-]+-{PYTHON_VERSION}-macosx_10_\d+_x86_64\.whl",
                        filename,
                        content,
                    )
                case WheelType.LINUX_X86_64:
                    url, sha, filename = wheel.url, wheel.digest, wheel.filename
                    content = re.sub(
                        r'(if Hardware::CPU\.is_64_bit\?\n\s+)url "[^"]+"\n\s+sha256 "[^"]+"',
                        f'\\1url "{url}"\n      sha256 "{sha}"',
                        content,
                    )
                    content = re.sub(
                        rf"{PACKAGE_NAME}-[^-]+-{PYTHON_VERSION}-manylinux_\d+_\d+_x86_64\.manylinux_\d+_\d+_x86_64\.whl",
                        filename,
                        content,
                    )
                case WheelType.MUSL_LINUX_X86_64 | WheelType.WINDOWS_AMD64:
                    pass

    with FORMULA_PATH.open("w") as f:
        f.write(content)


def main():
    version, release_info = get_latest_version()
    print(f"version={version}")
    wheels = get_wheel_info(release_info)
    update_formula(version, wheels)


if __name__ == "__main__":
    main()
