class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.3.13.dev0"
  license "MIT"

  depends_on "python@3.13"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/b9/07/266661406e9ded88065ac2434955db1121dacab2bd7e442f2ff483220172/atopile-0.3.13.dev0-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "2e636615e62a63033ffce12fe44a27054b965a8311899f0116bfb19baf3b2b77"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.13.dev0-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/2a/f2/eb5125c78f08854367bb16b56751682bdc5af36f5c1af151af5767028db7/atopile-0.3.13.dev0-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "510a36b3e8a8e989c22450d23f7afc6bd56587909e0242b02637ae740c2283a8"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.13.dev0-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/4f/c3/61b7d996c8f75007b805de442f6d0c3f1f2956a7f3d77129fecd8f2abf77/atopile-0.3.13.dev0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "f5501eb5ddd06ae78a364180dd671e355a7ece6505acd9acbedd066bd3ab77d6"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.13.dev0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
    assert_predicate testpath/"standalone/default/default.kicad_pcb", :exist?
  end
end
