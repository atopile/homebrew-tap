class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.3.18"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/1a/5f/d818dda309caafdad8a88500445ccefbd5f5b28d33ec2891c327609bfaf8/atopile-0.3.18-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "16f97c5f9e4e697c4cddb82be19beb46590bb672be6c389dab4181dfe795b05d"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.18-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/df/88/1d9c28ee815dd880ea528131e52bd4fafc711fa413ca0836b42e30ad8320/atopile-0.3.18-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "5c497a7779af0a843e2950633a9aa78e3ff22f33abc892116ee7d24d3a8537ff"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.18-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/1d/b9/833b0564349c41c15c32316b885dfc69b5cfe272a8179a078bc886ef9dd3/atopile-0.3.18-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "5966d3ea82c768a79bcd9c6540ae20635f3b983ad503b5b196c4bbdfc306ff89"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.18-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
