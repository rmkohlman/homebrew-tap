# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.95.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.95.0/nvp_0.95.0_darwin_arm64.tar.gz"
      sha256 "815ec589a940aaca3406a01469afe55761f9411d8224aa65b55cc1b5cbe18578"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.95.0/nvp_0.95.0_darwin_amd64.tar.gz"
      sha256 "53d4468003c38c76f079e59da9b18f1f5f7ed9ef53643fd34910d6ee0f761e80"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.95.0/nvp_0.95.0_linux_arm64.tar.gz"
      sha256 "113df4ae05814a2de1632311af5a2b9e837db48d13c6c9ecb1b2393bb9cbfa75"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.95.0/nvp_0.95.0_linux_amd64.tar.gz"
      sha256 "7a693c027070414c6e246072568e4bcff2b8c35028dbfb32f9e5fb13116d3d65"
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
