class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.6.0"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/2f/98/a8702551368b735a18150eaab43fff98e79175c46f29e4be78dac5672440/atopile-0.6.0-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "c3931b393edc655f2983eed9681e96fbb0bfc1255936333f25f2903e08b5ae0a"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.6.0-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/9e/d8/1a1d6731d56ee564f242c39880d6001fede84092bcc2342e973e364ad87c/atopile-0.6.0-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "46e343e42d4909f455ee952e4336cb1816d1ab0c6cc0541ed86587c94e80a6c9"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.6.0-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/72/6e/6b2f9372f133c703ac7324929d93ea010b400600dc29c86b1dae1452febf/atopile-0.6.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "e7fbedc8881b28f48a69c3c2a4df5b0c6e52840852f9dd422a8985f98c7b905d"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.6.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
