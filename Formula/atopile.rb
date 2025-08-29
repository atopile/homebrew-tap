class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.12.0"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/43/f7/9500c0ad210003c747a364b71c37adf293966b276c676aca2cf3672c46ec/atopile-0.12.0-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "0168c3d6682d6adfb1221222c006c34c2d5664a45defe71335fd64c064efe51f"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.12.0-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/14/45/55de56a8d42bdd17234f4a1df200a0ac9ccd12c8f3c73a4c92bcd1ecef85/atopile-0.12.0-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "d8bfab895a5ae2015ac6d8fcf2d0c491aefdce384775d31d8adfdcb753898191"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.12.0-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/2f/18/1d7b47c700c3c85675096bea4d54a54d46b12a603c7bb2264bddfd0cefb3/atopile-0.12.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "e837bf91a2fd0b7b6437bc740bf6b6cdb9a8149813bf3875aff6e5470a727b67"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.12.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
