class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.3.16"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/83/eb/d2f79ed43f936f7d2ab7345e5db13bdc88d038985fa6732d686e57f74117/atopile-0.3.16-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "ee839dd18cbf651de4489f150f697dc204e0628f05613a0fcf5d9ffb0a88fc76"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.16-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/43/97/4295363ab4eb35a9c4c0a90ccde5c7746190751ce7e982eeacb4641e7f96/atopile-0.3.16-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "5a744eafe8abcd57a45931b4ee5304f91d3262197d08feec9ebe14e4935f836d"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.16-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/10/3f/0573aded9774f622fcd3f18c06e42a215eabef229ca04f442ccdb630f206/atopile-0.3.16-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "430e9538a984377eb73981c14d3c314b90d4595558318534e5b46ee0c66f6469"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.16-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
