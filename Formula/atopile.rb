class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.10.5"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/59/b2/a3a28422ceaa9e94639b36158d2573dd71b9e2432b8918bb983206b504ca/atopile-0.10.5-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "c45730791aa449b81a88923761ed23d71838e963fc3e5b4c9385e4371d91270a"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.5-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/81/66/272c94b3d8764d1d52efce2f25dfa16f6e5f316fa3cb1fa13ebabbdace2f/atopile-0.10.5-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "b5ea5fb2994c97524b17a0f33cad8de7467482b19d0738929457c87fe824e58a"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.5-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/34/6a/9fa41b8519410c2aaaf58f34ecb72edd466fa7998a700f50ba8487a6b4c1/atopile-0.10.5-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "26f9be88022012cebbd1e1f3216ad3c3b4030f69b218ca915744780c3fe8f3cb"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.5-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
