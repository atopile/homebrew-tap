class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.12.1"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/69/8c/71d676f8ed0dcc77cae2c8c0eb809136eb4d9cad2da9a06a1ef2af95b2a0/atopile-0.12.1-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "46b4da805eac1bc13cc44eebeaf66f1f5eef1960b47140f4902eae9a618ce634"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.12.1-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/80/9e/f63de39ec9f34619deeecfe90d37c6fc25a5d8c79c77254404dc5d91b477/atopile-0.12.1-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "d28764d3cafd71d9af8a63217c2ddf168e3d60772eaeb6e3f80f8be190df52a8"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.12.1-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/a6/16/60bebd2e8eab1f4c56884c9daf033f53183697fe9ad5248f312f2a593f0d/atopile-0.12.1-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "26eff42ba2b961ea774e75ab72ed58ab339fbdb1674888f38740831dc9986cd2"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.12.1-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
