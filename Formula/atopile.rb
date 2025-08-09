class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.11.2"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/d0/a1/08c08b59b62abed452c54342f9ddd3babb504dc853d94c481cdfd0b4fa51/atopile-0.11.2-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "65d1d6ca970b93648e81fb647bc6687d1ab4f46b9bd9ff8eff595364ff089b77"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.11.2-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/80/63/f8233b77313c46923e55a35e3301424ed92b557d3a1b86d0ac5208a737e2/atopile-0.11.2-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "86bb4cd4931f8d0fecd94bdbd6cce3b822e89cb828a42c01bcc826d106551395"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.11.2-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/e0/e2/22b12fb6bad4daf8438c267bb69c88ae8248d4c9c838dd4181b1d7bded3d/atopile-0.11.2-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "f541dc502644014662b2f16108bf0e78eeca0cb46451f2de7ce9a985778916c0"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.11.2-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
