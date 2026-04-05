class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.15.2"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/c0/9c/a33b0ef74ce66f79f2b4c8fd320c0f63570c9d6158b1ef4a62d5bca54e15/atopile-0.15.2-cp314-cp314-macosx_11_0_arm64.whl"
      sha256 "f8e00247d807a80f85c978419e0a0790b57d9f5cc9728dc4f7f3de392639066e"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.2-cp314-cp314-macosx_11_0_arm64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/6d/6e/1d5191a658490fa19cc87dc29465e16ce392c98f6a9786dce1fc5cbad25d/atopile-0.15.2-cp314-cp314-macosx_10_15_x86_64.whl"
      sha256 "879b7e15b3b3fa5a87636b0880857dd39c96089228aafc79ff0fca6abd7c9336"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.2-cp314-cp314-macosx_10_15_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/ad/64/d92cf18e08725ece1252dd6df111c7c333fce30afa0f58f337b2db712c87/atopile-0.15.2-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "cb790806e3663106eb125b3ee73298e45d6f0a7e0b6c30b1bf6d41d002a27e27"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.2-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
