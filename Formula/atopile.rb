class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.9.7"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/2f/a4/21ad6b43a611f80069ee1103eabd4a7f5dc00ab7bb0ea47b06b24aa0916f/atopile-0.9.7-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "5264104c0ad7a749cbf99915ce685f52abfe034b0f81c7e39bc46d08c1d0fb31"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.7-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/17/6b/e38ce1cb8624997d7b1b539c4e788fcf0a7dceee2931cb50e21855535d9b/atopile-0.9.7-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "31c52a7f2333c0d715f1830ab7c586beb806da241dde9501de6ae4d17292ae85"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.7-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/73/ac/5e85112411b05d6aacf5d4961ffbc7ddd3193b6cac80d97f4339eb104e75/atopile-0.9.7-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "0f3dbba7c152e0a31a3859c55320807287687878a5e2aa38b8f55a6b48d9a265"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.7-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
