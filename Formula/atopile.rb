class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.14.1008"
  license "MIT"

  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/ef/74/fb4ae3c0d35ed00fe0af19b5f71095471dc73bf04f621e2a56029f5b3385/atopile-0.14.1008-cp314-cp314-macosx_11_0_arm64.whl"
      sha256 "b721baf9708c8a4ac4471c5c1aa9fcd9adde97ba245b8efeae392660f2e61e09"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1008-cp314-cp314-macosx_11_0_arm64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/78/77/3854df91e649b578bfa4ba6d612ea9b1bc51a665027e7d8e8d6024319689/atopile-0.14.1008-cp314-cp314-macosx_10_15_x86_64.whl"
      sha256 "82b350b1142ff327656999e69659cefee0a6a52d3d84ef5e3691849faf630641"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1008-cp314-cp314-macosx_10_15_x86_64.whl"
        system "#{libexec}/bin/python", "-m", "pip", "install",
          "#{buildpath}/#{whl}"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/23/b6/1bb45dca2865240d0be922245d1fa464292287ba0a2a4ee235107572f560/atopile-0.14.1008-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "0ff07e5016d413ea9a313ccd2dc08a6da70f93b886a9126c07e95c264ad4fb91"

      define_method(:install) do
        virtualenv_create(libexec, "python3")
        whl = "atopile-0.14.1008-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
