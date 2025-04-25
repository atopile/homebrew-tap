class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.5.1"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/2c/01/8b8f835b66ba7f6c3bc7219bdd05a988f54bd79b6a7d6b0202278ee70b83/atopile-0.5.1-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "e01f5569b4c4e8a2554d2d6b99516011b387558f84f7d96f130fd51865123db1"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.5.1-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/b3/77/d84d05a291faa9d625cab235fb11ad727628a1d751ddabc7fb5665d36923/atopile-0.5.1-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "70b1b5b820d88b557b752b2fc85bf596f23d946f9b7e592c10f003f0b5fdf6c4"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.5.1-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/6e/19/139718e6b326e534a6aad55589333cf34192aaee55becd55c3a1659b1eda/atopile-0.5.1-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "be13edb929145bfdaaaf8900e66d0946fd237d34c9e3d88b159cadf248b60511"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.5.1-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
