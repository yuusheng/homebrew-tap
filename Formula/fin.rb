class Fin < Formula
  desc "A fast, lightweight plugin manager for Fish shell"
  homepage "https://github.com/yuusheng/fin"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yuusheng/fin/releases/download/v0.0.1/fin-aarch64-apple-darwin.tar.xz"
      sha256 "8a86d6118fe3dff18532a9bb1acff0a358d74f8bb9015b83a2700ca72a16abe7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yuusheng/fin/releases/download/v0.0.1/fin-x86_64-apple-darwin.tar.xz"
      sha256 "0ba4c86de0245722b7a2eaaccd926ae74ff466be5c1212876ec47555eacafa85"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/yuusheng/fin/releases/download/v0.0.1/fin-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ac4fd07b7da86114353fbed95cfc4848b843da8bee580740b29613c4de7eefa8"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
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
    bin.install "fin" if OS.mac? && Hardware::CPU.arm?
    bin.install "fin" if OS.mac? && Hardware::CPU.intel?
    bin.install "fin" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
