class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.12.2"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/07/dc/a1e6b3c2134ae9a13895c482c59d047fdfe5bebf4eda4370391b183309d1/atopile-0.12.2-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "d26de364bb801a3e351d7f8c2a4ebd53fd82d3e075db02382be3c7e71a787e1a"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.12.2-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/1d/6b/d29c13bd17ca28bef2555d09fa9c2efdcd7406b1364a988895005bff28ed/atopile-0.12.2-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "829bc3381ac8f327b7d63c079a3df7b4bf580a5da2027abdd0ab272e5a7745a2"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.12.2-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/4d/5c/4363e98c92a7d25dacd3722badd182a9fa34872d800fc2a4948787786029/atopile-0.12.2-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "a6c28f589d2cf6121d11ef86e294ee8d91a2098c3cf5e1831d041c9d2ddc0bcc"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.12.2-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
