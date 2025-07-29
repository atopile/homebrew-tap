class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.10.20"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/ab/4d/cbe8fc4d303765711caec6eb358eca95ff13852ebf249f1abd0eae3ce573/atopile-0.10.20-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "1b9b2d7a8d44d09e78c0c1a8685fc634bd945361bbeaf7cb4a3873ed5b44e511"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.20-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/8d/7b/cd38f23bc2ef6b5aed06e0fd152e73966f35a91096cf17521a7552262de4/atopile-0.10.20-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "b1ff2b4d27922493cb4582054a783f4f4cfdf72e4b3b929d9a0022a41207a997"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.20-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/ae/b1/0d7396aa9996476b65bbecc5f82ee00e002c2b1ffdb0e005fa70da5f3eea/atopile-0.10.20-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "8935ce5032ecd5ccf6afda74968a3547ac1eb5abea9a8c248802b8b7eff9ab5a"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.20-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
