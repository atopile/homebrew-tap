class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.10.21"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/17/de/d5b401634b7b59e214e6aff4f66308ec1232268c09cfa37db7371a9f9c63/atopile-0.10.21-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "cc5923f6f205d233d9976a0bd1891e17bfcd9bcf5c0453d23ff0b1e843fc083f"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.21-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/ca/90/3a9c4b29f23deff85614c5496de1cca6f923751762d824be23101f7e55fb/atopile-0.10.21-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "be1bf2c0943c2d923ef235b06c304ae46aa3b2b9fff822b625d8ddf7cab8aa5d"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.21-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/b5/60/3dc6440f3e078cc52a21b2019a3745454b2d379cc1f5e0f77ab5cb64da65/atopile-0.10.21-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "fea05228036e2e6e95168d26bafc6446e59a161561667fdd8fe841b88b2ce475"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.21-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
