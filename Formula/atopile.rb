class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.8.2"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/96/d6/e24398406af2e8b8867846431328f4b420c4c305dacf2e3f5e76a9b4da17/atopile-0.8.2-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "de6fcd117cd8c73048e0bc2618e2de8922c40a6cb67908139999f65e21938e09"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.8.2-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/f9/53/a17477ff0b7315fcf2e43c58a0e536902ab392a9b514667964014e68b1ac/atopile-0.8.2-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "5bf6e273963631d2827701b690b8a1d09ed209e0980d1f9826850a2e362c3040"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.8.2-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/dc/6d/f7a6a1f42122ad2735c24da27d7fed6105b2fcfc468f98e2ba9012942a62/atopile-0.8.2-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "8702fb3340058b991e37349d22b16eee99c97441076b8d23225c8d32763ed238"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.8.2-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
