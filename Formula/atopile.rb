class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.10.16"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/eb/f4/1a79f1b181cdcdc83e1864d08226476726ff4e83cc5f0c4408c6f7970915/atopile-0.10.16-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "ec7b81b31650f31d1224e78f7f495ce9748933c00fa4f81305656d8dacd97dc7"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.16-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/0d/47/7bfa811a3e56e66b9286caefa6ac54bc482b833a114c7b976faf0e7c5ca5/atopile-0.10.16-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "aeccf5734f3714381d45e37aefd7abfeee38d4ba32e6cc0919e43f94c4346fc2"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.16-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/04/89/e2230de111dfd98483d78bdb86cd0c8f64a2e3746452b5637e913a1e6e7d/atopile-0.10.16-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "68004022c1356943e1d013c3edcccd0d558174834f6b6fb68930014f86c58449"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.16-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
