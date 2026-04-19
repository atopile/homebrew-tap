class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.15.6"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/32/86/335a618520326f06df56a61a4cc60e77ff83c116333a6d064a4affbceca0/atopile-0.15.6-cp314-cp314-macosx_11_0_arm64.whl"
      sha256 "b891bc27476d88e972f6317e268aadb483feeb991dab42e69f73b5b026afa088"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.6-cp314-cp314-macosx_11_0_arm64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/c5/ef/5f0bb87fa5e2ca9eb7088d134494ca58cd4ac96c08d22532ddef1fdc3e79/atopile-0.15.6-cp314-cp314-macosx_10_15_x86_64.whl"
      sha256 "50d58495b38e96ef21de029bf5309683e5e5cc67d19d63fa7c63a24140c289d1"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.6-cp314-cp314-macosx_10_15_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/ce/4f/51f5fcfc9718fe2b061bdbf55a63bb0a38cdc1ed661f05623486b9c2376b/atopile-0.15.6-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "677bffadda60baa9c3c55731bcbd0217d68ac7d09368a79f969be922a74e2f49"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.15.6-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
