class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.9.5"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/98/e6/d1c512f279bd2226b2b59116ccabeb9478ec93fb711bc8feda85618c9c5b/atopile-0.9.5-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "981b43aa1b6826bd3f386f29f968fbef7ce17bfb108c9a65dffeaca1a4b6c2f7"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.5-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/5b/f3/227ffb15b00e20e4a644c2ac9033b203fae138d25dbae6e7bc97b349d014/atopile-0.9.5-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "87a9ae18c508a3b29a0739e58a9cd2c5f615b2a9a5a7e5a063c40276da621cf7"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.5-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/ce/e4/7f7666dbf2c6651c823b3c08f8b49885bf68c0f65a2bc8dd9c124e61c4f6/atopile-0.9.5-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "40f7120f8769ab0168d18f4752f1a494d6549cb00a31e685f71a673076783e22"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.5-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
