class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.14.1009"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/61/cf/0562cc835fa1d21bdf81fb9ea48ab18fe2c12c4d8ad5a0239a0c22a9cd03/atopile-0.14.1009-cp314-cp314-macosx_11_0_arm64.whl"
      sha256 "20db0cec00ef8a430f1689f9fc794fcfff85da9ace0b765299cbcce2eae32782"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1009-cp314-cp314-macosx_11_0_arm64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/b5/f1/fa0f0435378416f4eccaa15441d9afc593dc28260f1d13b09d6eb89df835/atopile-0.14.1009-cp314-cp314-macosx_10_15_x86_64.whl"
      sha256 "35c18dd20f35c286064c98702e3071273feea0f7e0bed3b7e471535461d60e3e"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1009-cp314-cp314-macosx_10_15_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/28/29/0dc3271cc51d90f9db637dc755867632f56a607974bc01b1368cddb0933a/atopile-0.14.1009-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "7459ad9a03ec269ddb5dd0ec51a0f87e85fec9f001a8dc1e9ee2add0ba4171dd"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1009-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
