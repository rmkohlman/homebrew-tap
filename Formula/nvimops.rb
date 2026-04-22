# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.102.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.102.1/nvp_0.102.1_darwin_arm64.tar.gz"
      sha256 "384b8fed70605881ff921ccd12e7c5523b6abe7039999a93a20034c40986a4ed"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.102.1/nvp_0.102.1_darwin_amd64.tar.gz"
      sha256 "c4a9fa1c5a0e221458000fae91ccb6373f65ef3149ef8b643551825e1984643c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.102.1/nvp_0.102.1_linux_arm64.tar.gz"
      sha256 "fabcf01f93abcad92cfb46bcfd5948c7a265f7c2771af5ee101f17d5afd1d2ad"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.102.1/nvp_0.102.1_linux_amd64.tar.gz"
      sha256 "4321608c6e403da91b5f86da39b22c24c8ff1192b1d4de2d59774ad0b6c00a18"
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
