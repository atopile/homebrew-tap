class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.15.4"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/d2/8d/5b08afcebf852c7e5f43c2bd18d0d410cb550741b1f1d64dc9ce25dfec62/atopile-0.15.4-cp314-cp314-macosx_11_0_arm64.whl"
      sha256 "78092460e80bb47163af3c41313acd9da9195a409caae8d58ad68598ff7a7b4b"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.4-cp314-cp314-macosx_11_0_arm64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/5f/27/550f99bc20f72d21c4a12f77dc3df9b927abfb47e858f18eb51cae472e9b/atopile-0.15.4-cp314-cp314-macosx_10_15_x86_64.whl"
      sha256 "af818229247f23b134236ba195056f73c8857d1433c170345f175934ca569273"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.4-cp314-cp314-macosx_10_15_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/91/7a/85a351bfc511e8ac833c90082c85ac8c3e5e56c9983ce6fe7689b30e766b/atopile-0.15.4-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "12be5f091467b5cfb536550d06fe4cde8b8274c375bd23a4c0b0a8b88b1a7ae4"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.4-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
