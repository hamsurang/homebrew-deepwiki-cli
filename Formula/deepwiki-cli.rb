class DeepwikiCli < Formula
  desc "CLI for DeepWiki — query GitHub repo wikis without MCP overhead"
  homepage "https://github.com/hamsurang/deepwiki-cli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hamsurang/deepwiki-cli/releases/download/v0.1.0/deepwiki-cli-aarch64-apple-darwin.tar.xz"
      sha256 "78907a0a2328241db0b10268bd65104efa43e7ce4748914b1f5c308f9cc04970"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hamsurang/deepwiki-cli/releases/download/v0.1.0/deepwiki-cli-x86_64-apple-darwin.tar.xz"
      sha256 "be803d5fdebf164ea1d7a10a8a3f9024ca444a7948949a73d3da336d4377f558"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/hamsurang/deepwiki-cli/releases/download/v0.1.0/deepwiki-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c753effabe9c48585435e7e6d53d782a30914a54434caf3aa263ae95e14dac0e"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "deepwiki" if OS.mac? && Hardware::CPU.arm?
    bin.install "deepwiki" if OS.mac? && Hardware::CPU.intel?
    bin.install "deepwiki" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
