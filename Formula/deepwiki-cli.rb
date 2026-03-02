class DeepwikiCli < Formula
  desc "CLI for DeepWiki — query GitHub repo wikis without MCP overhead"
  homepage "https://github.com/hamsurang/deepwiki-cli"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hamsurang/deepwiki-cli/releases/download/v0.1.1/deepwiki-cli-aarch64-apple-darwin.tar.xz"
      sha256 "27f3a020860d36f1cbfe972f1b688300c9575d10d450d23c97c3f7c94837d5a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hamsurang/deepwiki-cli/releases/download/v0.1.1/deepwiki-cli-x86_64-apple-darwin.tar.xz"
      sha256 "53493402d48062f5bbcbc07444eded941c47f2cf38a20220fb7c07055817369b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/hamsurang/deepwiki-cli/releases/download/v0.1.1/deepwiki-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "042f8d14b3deadf3877782aa5d0db1b59146f9ff299efc46c189ce7af7f67022"
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
    bin.install "deepwiki-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "deepwiki-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "deepwiki-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
