class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.5.0"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/f9/66/6247c2c163321416db6dac404efcffb91ed9a595df1fab42b746a53dab13/atopile-0.5.0-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "87f11af6bb3ee7c1a38753f00487305b156cffa0103b71dfbe2d4dd11c1f9a25"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.5.0-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/cd/3b/d81715c110bb71adf33df676628c72a0db4e8c9bf68bf639fb7b9af015c7/atopile-0.5.0-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "bd201c7fba73a7e2793a6785c2fb596829c57556a759eee22d4c36e1da5568c4"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.5.0-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/18/d5/ca694dc2a80fcf49199bfff17d0d5d1f7be3895fa2e11ec94780be274793/atopile-0.5.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "d924359faaa3f9ad3025e0e9e888d96f77348b11f11c9eff431b2369bbcb0639"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.5.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
