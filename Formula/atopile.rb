class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.15.3"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/c8/1e/e705367816eff8a65e8444e9c6f0c482a4270a8718c146d61fedd8e5e4a2/atopile-0.15.3-cp314-cp314-macosx_11_0_arm64.whl"
      sha256 "08e7a169a394afcf9a1c3daadd2565ece007ed68fa11ebef658664341d0bc624"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.3-cp314-cp314-macosx_11_0_arm64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/8c/26/5c7f3c8cfaed2f9bd78433a6ce413005013da1429794de1d824f452a11b7/atopile-0.15.3-cp314-cp314-macosx_10_15_x86_64.whl"
      sha256 "c8d327c7bbfd6c1d339bf069718987e71f8743c4c42ec17da5e46ed0ca04ddda"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.3-cp314-cp314-macosx_10_15_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/79/bd/c8a62a15ea5acbf68dfdff2b8275a7fea5d957155bd819859d7eeddcd7a3/atopile-0.15.3-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "d09d33131b7304e016804dc1d2ade9337fe1dca129232b9887b68eb746c72704"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.3-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
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
