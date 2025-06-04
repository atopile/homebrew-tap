class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.9.0"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/0b/9e/2f411791cc9c15ed590d397411faa12adccdd106698db9addb98e52c702b/atopile-0.9.0-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "69093ccb11691418a60e8876ae2be9e2847d2f2537c5cb3707e89b8e146ad1b6"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.0-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/0a/04/61d8c485caf863ab9ff62defc7933eb5f245efe9c2aa94b867e039d361c4/atopile-0.9.0-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "a0c8be6ecd3dff7e4c9f589c0c66247ab331b47935c7442cedeccf2f12879331"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.0-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/1e/a0/7c141d967c8a45fe1be492431f1707debdd84a9e5ae8ebff174e91beee2e/atopile-0.9.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "21f8e40bee22e0dc4ae8d1c10597e33a3a02fc8cf92c269d29f3db257a435167"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
