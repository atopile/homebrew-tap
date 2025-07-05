class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.10.7"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/95/14/573bf97a0ca173b4b72d81f0c19eacd51a01098aee1bad47cfdfe76bcf44/atopile-0.10.7-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "12cee68d5dc631a10198e903c61197d80dbc519ebe3dc98347fbad048d7925a4"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.7-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/13/bf/d533dd99bea3750d21e055dbb7b3e35bb06b64c407a18909fce17bd24728/atopile-0.10.7-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "3ffb8d27b0c0643791a8fd1c444df6b022368b92d8004f077136dbfd09730df1"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.7-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/0d/69/dd9e475939d1516bf421da0ae7bc2a5d4dc78c4bb20aeafee2d81174820f/atopile-0.10.7-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "ddcda5a5733edb011eac4cd39c133a3ad2bb124ff2d65f2ce9490885edfbe781"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.7-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
