class Atopile < Formula
  include Language::Python::Virtualenv

  desc "Design circuit boards with code"
  homepage "https://atopile.io"
  version "0.9.8"
  license "MIT"

  depends_on "python@3.13"
  uses_from_macos "zlib"

  on_macos do
    if Hardware::CPU.arm?
      url "https://files.pythonhosted.org/packages/db/77/7cf7a5e75322fb1b74a7d006cc279ef359945a453ff65d82e15d5f59f44a/atopile-0.9.8-cp313-cp313-macosx_11_0_arm64.whl"
      sha256 "92f40ad6d56f9cee78da622e4c4c31135e7cc93fdfd1b89edd3f6fe9f91584c3"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.8-cp313-cp313-macosx_11_0_arm64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
    if Hardware::CPU.intel?
      url "https://files.pythonhosted.org/packages/97/74/2213d6dd8976fccafb1064a202888a7b29c67cd1db5dea7fcbfcb8c56c54/atopile-0.9.8-cp313-cp313-macosx_10_13_x86_64.whl"
      sha256 "dfef7e1e5a571d8ab633095c46a5b2da6f9a131184844700fffa52b01716665f"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.8-cp313-cp313-macosx_10_13_x86_64.whl"
        bin.install "#{libexec}/bin/ato"
      end
    end
  end

  on_linux do
    if Hardware::CPU.is_64_bit?
      url "https://files.pythonhosted.org/packages/b3/64/35f34ff73254efcb0a3b788833589f60cd89ce5f00004f73ddf8c13d0114/atopile-0.9.8-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
      sha256 "8b45e54594d1753cde4ac9dda847dd1a85d7a36b440d8cdd3dfb73a1fbd5e574"

      def install
        virtualenv_create(libexec, "python3")
        system "#{libexec}/bin/python", "-m", "pip", "install", \
          "#{buildpath}/atopile-0.9.8-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
