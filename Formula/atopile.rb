class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.11.4"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/e4/81/4edc6fc10b43a36144f1bab9a83070214216f9d55218675c18a0d8feccf9/atopile-0.11.4-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "c1f7a18d89f907d2663cbeb61c9e7ed950446cc2c4ae3cc77f346626ed531ac6"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.11.4-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/49/b0/2b9ce4985426536199d15eabc7f10f6ba4e349a5835eb5b0039d0b70a788/atopile-0.11.4-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "f238ba74179f4a9b5682a03f388601a7a634d752b4a804022d1a76da9f4d2256"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.11.4-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/82/c0/9701e93501d9a7f92164fe866de0a70d576bac8219b459714e4b1deecbf0/atopile-0.11.4-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "199368595712a3b8fabe9c39ab2c177f85ea0e1d91b42dff1eef7c2acb36afd4"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.11.4-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
