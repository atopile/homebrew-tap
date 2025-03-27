class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.3.23"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/f9/be/7b31b64c5af584b077c5e032d6b10a276d68637f0a6717484c96b856bcca/atopile-0.3.23-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "13884b3c6c498e9841ee2bc110e6da3de1078a8b4f5a4ab9f251db55ed7beb06"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.23-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/af/3f/f276193f149d3f8c7859d92691ecf41a1c645a765d737ddbbdcd713a3256/atopile-0.3.23-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "20286ab0b314d6f1b73d4beca840e99c352a730f1f5c46d016da99f07f445505"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.23-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/aa/35/4295dd9050165a5a2159ccb77eda704b928f7311e2190d88a1ee4159fec6/atopile-0.3.23-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "0faf57f9617f461b4b5097240a031ae6da25bf80175c05dd30dfb91c601be44e"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.23-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
