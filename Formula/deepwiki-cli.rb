class DeepwikiCli < Formula
  desc "CLI for DeepWiki — query GitHub repo wikis without MCP overhead"
  homepage "https://github.com/hamsurang/deepwiki-cli"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hamsurang/deepwiki-cli/releases/download/v0.2.0/deepwiki-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1e004f5df296484582724e24df59467e5e5714dcdedceaf65766319753653eb9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hamsurang/deepwiki-cli/releases/download/v0.2.0/deepwiki-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0331e6c55569a771efd595668808a49e489aeec757a295f1f357d91aab353dee"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/hamsurang/deepwiki-cli/releases/download/v0.2.0/deepwiki-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aa19e316e626a300ce0e26bf3ee065565e86427a10189b6bdf5c1edea8c622fb"
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
