class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.8.1"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/e5/21/2581c680b2aad2aa94a7c006ce86a8be49d8835c9a90212e1464f1889d78/atopile-0.8.1-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "563ef27a33383012c692ec2234b53f5eddd2b7d478a9f05ce307b215ea90ad6c"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.8.1-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/2e/6c/e4fa88e524ff265fac76b4bac43667daffd6196eea59a86ca9571a454c95/atopile-0.8.1-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "0c7e816362bd38ac6b350727f24cb3258fb945c199278be73b77d4791b87fbd7"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.8.1-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/65/71/fa74f51936fa854d883b07055af7d97bc77e9cdb08ad12e2e12a47110cdb/atopile-0.8.1-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "c64a41203abdbba01b5fd2cb72f6bda88d9d736ee649ccb679c45662566ae3b4"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.8.1-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
