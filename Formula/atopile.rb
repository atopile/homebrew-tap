class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.10.0"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/cd/1b/0564bcef0ce76ea8a399ed5eacde86ae87002ebf1bba231d0b03c942b19e/atopile-0.10.0-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "3285dab5b9ae9860cf4d3e41f399864c57242a5bab84548d2045a5c865268a58"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.0-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/d4/12/53e58cc93fda651dd339908aa7e7f21c00e64cdf14603615e3d5fd04a11e/atopile-0.10.0-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "f1cdda3715eb7fe26ffe1403ee98e1b02ccf15d23da04adec99e68e94e057aae"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.0-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/da/eb/0bdb7fc2a4d91cf18eef179827d0028696210085b2070d8a32568134b8e9/atopile-0.10.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "bca7c3ceb3c4a9e1ece0fc3f179c2eee449e68e9b9665e5ceddfbd9ae3ad48be"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
