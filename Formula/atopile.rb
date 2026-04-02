class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.14.1010"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/fe/fb/97d4ea961489b7032ebd13510f335c4fed277d44d2e1a885d90a1de0e236/atopile-0.14.1010-cp314-cp314-macosx_11_0_arm64.whl"
      sha256 "677eb2ad6fad4f9e6496157db1183d765e93bf26936be2b18b783a4320f2f7cc"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1010-cp314-cp314-macosx_11_0_arm64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/6d/31/df71973113e4ddf7863b6efba69c0a559d49a529a35aa1b58d4e51228580/atopile-0.14.1010-cp314-cp314-macosx_10_15_x86_64.whl"
      sha256 "e8c0f0870be1ca5286dd4b1b77ce165803a7b78df3582db7edc3f1dd60957694"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1010-cp314-cp314-macosx_10_15_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/35/9c/567e90f34ae436f9fff1eeb1b915f5e39e8568f7037f411a252474a53422/atopile-0.14.1010-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "41f727420988fbb662619012ccdd6e07292fd260fc4deaf4649bdf9ae0004ba3"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1010-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
