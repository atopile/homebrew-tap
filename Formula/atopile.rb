class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.11.6"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/31/21/8bf39d4d9c575c5cf1eb7a5cf33def6e7a9a94921853684d498d999ff9eb/atopile-0.11.6-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "74e823a915015db60413b0f4af033febe507c5af554aa719bda836ac3078d793"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.11.6-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/55/b6/e0ce42dd8377660d161e2a109092bd5f311a28f0baac73cf44541c60b4c3/atopile-0.11.6-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "854a7c4f1adca715c76cd9f0ec0e2de5afff1b6d02197035102d80f02935a2f3"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.11.6-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/03/05/6e68ffcfd3227d475c74ff3316eb7a635e34acc92860db19e860a2fee000/atopile-0.11.6-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "519d6e8627e53580070d424be4b41d7408f34cde75c5d81f4aa98d841ad8a203"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.11.6-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
