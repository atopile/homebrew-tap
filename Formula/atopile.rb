class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.15.7"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/e5/75/f43e8fe0899a79c500bbda15dcaaf3d02001e4c259c94264bbdd4f3fe2df/atopile-0.15.7-cp314-cp314-macosx_11_0_arm64.whl"
      sha256 "f883fb766b56c7a61d2462c4e313eb43707e530baf7e8846c0629e3ce8a28010"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.7-cp314-cp314-macosx_11_0_arm64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/24/34/c2e8860b65df528ff9ee8a7310536163b317c21a8924851ab1ae0891a01c/atopile-0.15.7-cp314-cp314-macosx_10_15_x86_64.whl"
      sha256 "8d0a0afa55c07455205524a2c5561927407aeab1d581815c64ea3c277cd973b7"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.7-cp314-cp314-macosx_10_15_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/9a/19/f92d7ab0c1a611b207dc41d41d8a7e7973e57079ebebdc4a7386938e597c/atopile-0.15.7-cp314-cp314-manylinux_2_28_x86_64.whl"
      sha256 "0630b245b78661be2a5b95047b7bd5c793fd68f056a3f36f772b8974c0ee08f4"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.7-cp314-cp314-manylinux_2_28_x86_64.whl"
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
