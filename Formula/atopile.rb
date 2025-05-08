class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.7.0"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/d6/9f/656e9090e75945b60ac6f5d2299987e6e42b4277627770822399ebb0bf36/atopile-0.7.0-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "705b30cfd48f3d56e2058880afd484e57ee8f719526826d67e617968f2d712c0"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.7.0-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/4f/08/667b030374ec59f803fff0587117416d9a4fb2227a2ae594c33b1261cb75/atopile-0.7.0-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "379ed867f9535d7d36adf786d9ead90d3f127307d13837a2c92e2f32f21767a8"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.7.0-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/30/0c/29233f6c5ed330d555f907b224e7381eacab0a4ccff35fdab9fab2dfc71e/atopile-0.7.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "7d6b74c2017ee9d093e9e4e2f41eeddeb0befbdc0df8a8bcd06dd4f04760cd52"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.7.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
