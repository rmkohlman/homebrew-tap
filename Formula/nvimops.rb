# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.70.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.70.0/nvp_0.70.0_darwin_arm64.tar.gz"
      sha256 "ab42f341e497cb6183f9d8e8ebaa6d9d5dabd781987d8ab7a299b5eb5aa4921e"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.70.0/nvp_0.70.0_darwin_amd64.tar.gz"
      sha256 "7ce3648b1660a7f5c8824b98157f5218c974fc7b9357aeb013422b460032e774"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.70.0/nvp_0.70.0_linux_arm64.tar.gz"
      sha256 "21966f94fa8bce987cf92c5e67c02b7ef363ec2c12376c60c88d4eed06a4042c"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.70.0/nvp_0.70.0_linux_amd64.tar.gz"
      sha256 "5b3ca5d419c8d242f904e188dc1bd656c661eb8cd9015f3ee90b8d5a034decd3"
    end
  end

  head "https://github.com/rmkohlman/devopsmaestro.git", branch: "main"

  depends_on "go" => :build if build.head?

  def install
    if build.head?
      system "go", "build",
             "-ldflags", "-s -w -X main.Version=HEAD -X main.Commit=#{`git rev-parse --short HEAD`.strip} -X main.BuildTime=#{Time.now.utc.iso8601}",
             "-o", bin/"nvp",
             "./cmd/nvp/"
      generate_completions_from_executable(bin/"nvp", "completion")
    else
      bin.install "nvp"
      bash_completion.install "completions/nvp.bash" => "nvp"
      zsh_completion.install "completions/_nvp"
      fish_completion.install "completions/nvp.fish"
    end
  end

  def caveats
    <<~EOS
      NvimOps (nvp) - DevOps-style Neovim plugin and theme manager

      Quick Start:
        nvp init                        # Initialize plugin store
        nvp library list                # Browse available plugins
        nvp library install telescope   # Install from library
        nvp theme library list          # Browse available themes
        nvp theme library install tokyonight-night --use
        nvp generate                    # Generate Lua files

      Generated files: ~/.config/nvim/lua/plugins/nvp/
      Theme files:     ~/.config/nvim/lua/theme/

      Documentation: https://github.com/rmkohlman/devopsmaestro#nvimops

      Shell completions have been installed for bash, zsh, and fish.
      Restart your shell or source your profile to enable them.
    EOS
  end

  test do
    assert_match "nvp", shell_output("#{bin}/nvp --help")
    assert_match version.to_s, shell_output("#{bin}/nvp version")
  end
end
