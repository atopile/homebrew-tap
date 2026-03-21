class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.14.1006"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/75/ed/4bd961370a5cb37051b3271b2c603b13bafda4992d4410649e27b9386f5f/atopile-0.14.1006-cp314-cp314-macosx_11_0_arm64.whl"
      sha256 "2fe7cc5a43120563f4b7b49facccfce28888feadab6288cf71f6f848a14b8c98"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1006-cp314-cp314-macosx_11_0_arm64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/1e/fb/2cca55ab5b62c785b071d860a3c7f2267ba27bed4011002c24295d6b9d05/atopile-0.14.1006-cp314-cp314-macosx_10_15_x86_64.whl"
      sha256 "8a7810c1fe2685e49fc716739be45e4c8013ab4e9fa90744a8c5affc3e714068"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1006-cp314-cp314-macosx_10_15_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/93/9e/d6e03a9970c6122319e83210a6129860032ecbf47baf2843751be9a61aa2/atopile-0.14.1006-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "ef6eec444c919a421e934d48bd2af2aa44b5088f13118a91d24b2d9e587302c2"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1006-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
