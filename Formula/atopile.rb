class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.12.4"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/b6/25/e08655fd73f9271d94f24817309f1e438789b92db0d76798466bab75104f/atopile-0.12.4-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "0bbac3acfcbfcf88e0fc813c5043c1dc6f44b05136e6eb13d09c7e7a769cbc98"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.12.4-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/9f/e5/575cd95e181463e3a98883fb4fecfed79d1619255999340507b57a957b32/atopile-0.12.4-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "c0a01d7f346c092531419e4d20b3130bb7665a5e3d4855df98484bcbebda92a5"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.12.4-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/aa/6f/8ff56738ffb1f1f8970ac75f65769eb5946f3a58fccd4dc8770d2caa68b4/atopile-0.12.4-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "8b74e0c4908d28046ec8c07ac3d1e0051c99ecaa83c57b65ce8e1d89b73d4cb1"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.12.4-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
