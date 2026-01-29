# typed: false
# frozen_string_literal: true

class Dvm < Formula
  desc "DevOpsMaestro (dvm) - CLI tool for managing development workspaces"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.3.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.3.1/dvm-darwin-arm64"
      sha256 "b71cf34080b07a532d8c5d9fc754911e7c3e1a0a1bcd0f7e2f8d0b525005e60f"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.3.1/dvm-darwin-amd64"
      sha256 "c49566ee75a83b1e99551c205a47098f72da0ddf960f5cbc9bd21c0dfa62ed17"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.3.1/dvm-linux-arm64"
      sha256 "1e73a7446c44d4ed446865bf95e8ca367fad4501b4cf0e7a4c14da8d954fe386"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.3.1/dvm-linux-amd64"
      sha256 "cc64d8c39528ae87b5c2c23a5483b1874f4c901aed3c42bbdf143727bfe64ed2"
    end
  end

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "dvm-darwin-arm64" => "dvm"
      else
        bin.install "dvm-darwin-amd64" => "dvm"
      end
    elsif OS.linux?
      if Hardware::CPU.arm?
        bin.install "dvm-linux-arm64" => "dvm"
      else
        bin.install "dvm-linux-amd64" => "dvm"
      end
    end

    # Generate shell completions
    generate_completions_from_executable(bin/"dvm", "completion")
  end

  test do
    system "#{bin}/dvm", "version"
  end
end
