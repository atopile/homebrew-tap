class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.9.1"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/b1/73/f65b713cb21785a60a2e78d0c93e31d83b5a795bb81521fc7f3b5ddf14e1/atopile-0.9.1-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "fd1549663a1ff6bbc331159799a209e9f95a5ac562ae8a7037464e05963c6c61"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.1-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/0c/50/bd9a3de5a8fbb3e7ee060fd4953606b06b843afab9ae7107a61b93950432/atopile-0.9.1-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "1b39f52a9d894b604b6f816d8cd7517e92711d020de0b2eaa87ce2c46431eb05"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.1-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/30/a8/0f5da08a1426614b53975882d398222ed8da6c35008ccc65ed28d65d940d/atopile-0.9.1-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "549f9f6bb36900c9e86b7fea66cd390510d7382a94a73f5b5b6a272f3be5d399"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.1-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
