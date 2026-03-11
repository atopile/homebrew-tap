class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.14.1005"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/dc/b0/c8ea145269178e933fe1bdf38cd50eade91d6f910a984ca559ec02bd57b2/atopile-0.14.1005-cp314-cp314-macosx_11_0_arm64.whl"
      sha256 "3a59491a17674830935abfa7d73657d616e3f48ecbae3b7d75d5723538234a48"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1005-cp314-cp314-macosx_11_0_arm64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/b2/ff/c7f608775d9f46fcba1394c1f047797a7bc76640c72db286cf10762e8f62/atopile-0.14.1005-cp314-cp314-macosx_10_15_x86_64.whl"
      sha256 "fece3d4fe65b1ae4d849529587dda2182b2555d0d9b08bd011616635d11bd600"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1005-cp314-cp314-macosx_10_15_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/4b/20/74fcad5724e5a4b2ef0e6b492d7c42ef01954b3c25795de54a8a2ba6f462/atopile-0.14.1005-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "1c00b91e3fc15816950b5b75400234803b33145feaf1079d68b88dcc0926373a"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1005-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
