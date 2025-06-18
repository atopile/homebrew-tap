class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.9.2"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/db/46/0990fdf15c13923a10909c464ff1d7471522b9e4e1d9a7adffba607467c1/atopile-0.9.2-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "8b4fab994b629966b0438462d3c3cb1ec7d4dc16d01cf41167fa8e7474b91c96"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.2-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/cc/80/aa02837fc4b7ef986c53b032ef5e98c02738d767d3b312290e21eb6bd780/atopile-0.9.2-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "f9da00d7325f4c7bfb27a75364aa04e22219a097978574b46b53cd35120f3725"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.2-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/54/aa/aac0ea1467624fe10a13aeb29bdc51d1e7b85a9c7a5ac9462eef8d5de354/atopile-0.9.2-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "fca5bf283e2bb52de7068f5d8222c11bbe45f7247b271f8b644db6582f5b9cec"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.2-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
