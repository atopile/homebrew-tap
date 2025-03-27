class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.3.22"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/11/37/fc41928bf3861dea67fe01bb28399419b4a715dda2bce744558cde430fcd/atopile-0.3.22-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "40a41b23b35016d014c0b0a18d3d790427bc40e287115dcedcd40adde16d769f"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.22-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/00/e4/57c75a1788cdf2c6c5695dc18fd88280d1ffa620915c55a6e9d3f2a8d7d9/atopile-0.3.22-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "7f228a12f9f940a2c4e24458e7e809b97bda0631f1d7052da5c5c7ac3ac27b73"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.22-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/20/4f/e978e9c2f3bff5b2d5defec56f2f8a7227c110134663db19b0bbb3149187/atopile-0.3.22-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "e2ff4b139a76595f403cc9ba66997627cfdc7a04846c0e83c0106a701aa66a04"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.3.22-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
