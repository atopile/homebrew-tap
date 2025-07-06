class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.10.8"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/51/41/82c7e27f264e1261b834d87ffacf2b45583ad0b996f11c6d817ff90ea041/atopile-0.10.8-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "bcb3147797845a3c6448e0b35052271349291ff86378db0fc08cddf704b699dc"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.8-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/89/0a/f7191140dd87418e026253ad2b7d87864fdd84be2db8b3568ec6e6b49fe8/atopile-0.10.8-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "a496b03e2e641481eced3029e1f2a6f3b5673878b411bb97b6d010c2034179f3"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.8-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/23/e7/4fd9febecbb732fafb6b0ab5ad2a6b84be06c7d29fd30df71f706cf86cdf/atopile-0.10.8-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "8c37b8c36aa4840e3f918c9cb69f062a442f94537eba23ec1aac589fbaf21d77"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.10.8-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
