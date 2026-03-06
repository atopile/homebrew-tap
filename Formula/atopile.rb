class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.14.1004"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/93/74/73bf05e7a219094611320afecf2a2cd7a2c1aca7f43e27ea027d2585d45d/atopile-0.14.1004-cp314-cp314-macosx_11_0_arm64.whl"
      sha256 "514c718572226a575883a52c5b96e9449cfdaefbfb70e192d8db66ffa21b8761"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.14.1004-cp314-cp314-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/11/ec/d637189cd57985e230700b8f79e8fb51851b804964976ea0e577bb3adc34/atopile-0.14.1004-cp314-cp314-macosx_10_15_x86_64.whl"
      sha256 "d6e7055fa44e89b4a17c090ef77a0416d387ad3b14d681a9d61a1f109adda799"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.14.1004-cp314-cp314-macosx_10_15_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/ca/b4/0364abda81157549c50aee23e21fd4796b3f50e25bcdb16e350ea32f02f4/atopile-0.14.1004-cp314-cp314-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "bfceef4dc4a55af52722dca0ebfb6e250af0037e691c4ed848d8409d628cad5d"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.14.1004-cp314-cp314-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl"
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
