class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.10.18"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/e1/a3/a132e4f5ba3449522cddc26c89d08acbe846f903fc91d99119159456657a/atopile-0.10.18-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "9ad2d461fb106afc9db0c6d45cee34630397a31253ff223df3e7a3a0f77f2c35"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.18-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/69/2d/2b2298a2e41c6ee48cb85f68f883ee41bcc6acec9023df8ba78f1437040d/atopile-0.10.18-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "dfa1cd332c82c52548f713eea6e06a863285c1079d6f40c60b57480a45405599"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.18-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/9c/35/87c8c09034922278bc4d6798e9577583cccd372a426e0368e0a09d377dc8/atopile-0.10.18-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "a8aa8a9e2ce388dccdb8565f69956b8201b79372cebd4dda16ec2c417bd252fc"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.18-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
