class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.10.11"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/b5/26/fac101709a732f3980e3637c5785665f32e4e4b70b09baef1fe45ca5c626/atopile-0.10.11-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "3f08f1d0ba1b467dd8858953168a884267a25689420f48f3977c91d808cb6bce"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.11-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/49/e9/8cfc9cbe21bf320cf7bd5fd102f4c85e0a196bcb6dd8ab6d683b2fa00072/atopile-0.10.11-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "ef389ffeee4996d2bb401d3aa199016f7f498adbd286ac0415bb8eefd7e7b2a7"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.11-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/ff/bd/75c47c91def8168f1f3685359dec46f8eaa2734c447e8c568463ec303491/atopile-0.10.11-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "f3d4172ff6a6babb8e120943522cfa65967378e309ff20587f5993f7485c5489"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.11-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
