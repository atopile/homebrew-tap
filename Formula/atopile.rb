class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.3.17"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/83/22/41ccee76c31e9507e0ced0ac5048d9ccfee9b6e7101edfcfec5664661f5d/atopile-0.3.17-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "007061c72a5efaf4f311703d5db66c55f9541c4a55debf856a13f0eb441f28c5"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.17-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/36/c5/8afe8f7b18d5f32bb0a0bf3a5089388666341714991d232bb641b473c6f7/atopile-0.3.17-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "d6d03e40440867b68343dde45fb1b48c5a641dedd232b3fc873f96b8ba6c111d"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.17-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/68/b1/ae24d8ca04afd47ee9dcef7156ee276367e32fe0919ba83948d74c83b35e/atopile-0.3.17-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "adbedf78ae4216acc8654e28b92914c3932ab1f6ecbf7c3ba53d715aceb76817"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.17-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
