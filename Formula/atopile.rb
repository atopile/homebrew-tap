class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.10.23"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/5f/77/3069137ec0fd69c5f0cada43fbfd28049ca11a77e9ee118d3cab8399221f/atopile-0.10.23-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "f52fdf5938b9fb3a6b621e4807cf4919ba64f78bf0ad3a0d8b11e2c2feaadad9"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.23-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/0b/f0/8152a2b120c2f29d81ab58a6a5cac847fbd41004af3756d7321a947e0a37/atopile-0.10.23-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "d3f2b62444bff3d886844589ff130157e2663c802a7a1c382343c8c071fea254"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.23-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/ff/12/57a73b954a96fffc6426a4fe38f3fd73aeec481ee18c72118356892bd188/atopile-0.10.23-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "92e49cd127574bfdac2c81e7cd94cd713d2c7505df624f78b4acf4930c1787be"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.23-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
