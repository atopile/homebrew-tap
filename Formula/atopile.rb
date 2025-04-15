class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.4.1"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/82/fb/1b4a7ecad983c122a7cce7b7a9bd34abc6988646dd803b319377a6ee28b1/atopile-0.4.1-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "5b5c106053e2ec805d6273af95810568b9fdab5c6d1a039c023fce770d35194a"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.4.1-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/15/00/f6839639f613b7fc64c2e8ebe9dccc6edae4cca1ad6aa4796dc5674e8568/atopile-0.4.1-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "4d4309b9feb5aefb7695a4713ba84f63ab9feaafd30d36390f58bbd0b1e93c9c"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.4.1-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/7c/40/1181134e5e6abd88dcfd7a84ad9f298fdbaaa57bdb6115960c17c50428dc/atopile-0.4.1-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "c29da3df759b6905f7ebffb92a429e2473adf4454889c497aff322efadb9e939"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.4.1-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
