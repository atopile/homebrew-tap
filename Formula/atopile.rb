class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.15.5"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/c5/2b/7f2207f47c51e0f5ac91f8ea3f33687aca242b504ddce5876039027bd3ca/atopile-0.15.5-cp314-cp314-macosx_11_0_arm64.whl"
      sha256 "9cfc604869c88f11ce22c111b590be673062f6462feb8c37746739a8ee146077"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.5-cp314-cp314-macosx_11_0_arm64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/b6/38/57effc5cdd109b26523d58ba929010c80cdfafe09c276e3e7c5f5a56e383/atopile-0.15.5-cp314-cp314-macosx_10_15_x86_64.whl"
      sha256 "e79c10246a0712eda775801ebcbdaed675c2092757823a9478d1f8f5f670dd8b"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.5-cp314-cp314-macosx_10_15_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/38/1b/e3448177015f520ad9fd012ec19351036b82e8b906d49f14390a515e2a7a/atopile-0.15.5-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "7d471d62f0d5fc54630d0c194d3f14ece1d4dbda2b3c1f5169b6f86bfb8fe09c"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.5-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  test do
    system "#{bin}/ato", "--version"
  end

  test do
    (testpath/"example.ato").write <<~EOS
      module Example:
          signal a
          signal b
    EOS

    output = shell_output("#{bin}/ato --non-interactive build --standalone example.ato:Example 2>&1", 0)
    assert_match "Build successful! 🚀", output
    assert_path_exists testpath/"standalone/default/default.kicad_pcb"
  end
end
