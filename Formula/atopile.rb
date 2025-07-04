class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.10.6"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/16/ed/49732eeffe9ccc3fb4643f8238ef98bec00d9285d1c7403fc8ccb4e658b3/atopile-0.10.6-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "7a6ec984038b53ef772ce85fa310d9b4466d2a60de44422a9e96d96de5f3bf82"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.6-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/b4/1d/99ada374feeee0148b75f3b86f3ad55d2a46e067780551a41a8b26afb2f0/atopile-0.10.6-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "fb77bbc2bc57eb97d5763824db4ead4dd2a8e7b76e7a00ba18b674441b8a69b2"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.6-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/9e/18/c33d3c7954e800436ec07b9656c96d948c70d5347c4b3b7bbbf7699bc0c4/atopile-0.10.6-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "6fcc168e41231665a8d86e1b149b085a5e4828f34796291cae0dacff17d4935e"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.6-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
