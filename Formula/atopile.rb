class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.11.1"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/fb/c4/c5706a8fffb337e22b57e91ce404bfc68934f8ceccbf1aad266cd40e4577/atopile-0.11.1-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "f91bbe5e371135e5f0890e18304fb7cb005443cc36ecb962ad4341d3d351f8ff"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.11.1-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/84/bf/dc6b62e932250d3ce5eb85a11dce1d941d2b0376dbca37add58b1f6f1d90/atopile-0.11.1-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "4d3af69591973bc692652025984ad824cc88608be0ced1dd9f696d53ad6bb81c"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.11.1-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/e1/11/9edb8a86dfce172a75d72dd791420555505489da7893f3d7f144c19a04e1/atopile-0.11.1-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "f12ae8f014f11ee7a072d395b5b8b437aa6586e097363aaa310bf73ee05d5ffc"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.11.1-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
