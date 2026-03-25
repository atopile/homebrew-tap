class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.14.1007"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/fc/69/24a101e7fe85d571a43df7802345c26259d39d87fa2b9cf6e8e8b3949c41/atopile-0.14.1007-cp314-cp314-macosx_11_0_arm64.whl"
      sha256 "80cc25ffff85078a71bf9bdd66a3db387aa33d849d417a3466786ce2e85c7aec"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1007-cp314-cp314-macosx_11_0_arm64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/52/b0/e59988d682597c61c80a9fed97869a0861f6b0a9c25a9221636bfcdd4f06/atopile-0.14.1007-cp314-cp314-macosx_10_15_x86_64.whl"
      sha256 "642e8d11ba0ac8fdc5fe5b9f7d936a6a66107bb5ebda6c3282ba78a8d2d683b7"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1007-cp314-cp314-macosx_10_15_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/d2/db/a2cb5cfe90c97330ae00272c02d7466d9e49b4f60f889ad9125ff5e80fb4/atopile-0.14.1007-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "90440689a93fdf6dfb6af9c8880fa5699c6155419ca3c43df92029735692aa5c"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1007-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
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
