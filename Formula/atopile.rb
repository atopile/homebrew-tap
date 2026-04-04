class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.15.0"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/0b/32/9bb8480abde53f7afdfeb8512430cb92a4af6d2fc5b33c36d9ac6e9d067b/atopile-0.15.0-cp314-cp314-macosx_11_0_arm64.whl"
      sha256 "a6263b6c1ffff83a7a5924e7507ae8c01045470c3ec359d2a89e3ef50a2d45d8"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.0-cp314-cp314-macosx_11_0_arm64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/88/aa/68235d6c59f0b667079983b5c4cea1e9b6393164a9de78ced76259237b85/atopile-0.15.0-cp314-cp314-macosx_10_15_x86_64.whl"
      sha256 "2e483bedb0f4ad84897789a63de8b484defa77026383b1d45d8964799ae1d67d"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.0-cp314-cp314-macosx_10_15_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/ae/06/5842dd02c8ebdcf74b800a9687f686dffa08b2f456cbc879065863154cc0/atopile-0.15.0-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "a31c1e09bfc989771b500fe8d5e95c110f1c0191f7bfb324f2a7a427233db6fc"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.0-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
