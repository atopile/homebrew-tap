class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.10.9"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/69/18/c30d3845c1e7773f1de0e60fffcff0a473e7878d1764ca3bad69f2af9c4b/atopile-0.10.9-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "c56a9b19970cd2f4e33ae2b9d2c1354511f8fed05dfbec3937dcfa58a5a665b1"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.9-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/8e/05/6801ba5ba106b0b55bb045cbab6eaa8e4f5c5c0365c9e423c0905c59382e/atopile-0.10.9-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "26ed8a4ca632905ad36bc81acf3cb43a1b4378bdc0c089afc93740b8d4d31d58"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.9-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/0d/4b/6c344e489360b53f9210de2d2438fede1c1de6b2c2f94aeadd6928279efd/atopile-0.10.9-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "d0d44573c5c65b29a9f6b8b87461ec86ffaddba8de6096e84fde81db52568f31"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.9-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
