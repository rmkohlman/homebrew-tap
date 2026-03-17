# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.48.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.48.0/nvp_0.48.0_darwin_arm64.tar.gz"
      sha256 "7c0881074c3e6bae95b4c62e168175b75794bb11bbe0bcbaff7e788a6d10e7fe"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.48.0/nvp_0.48.0_darwin_amd64.tar.gz"
      sha256 "11e59cc4bcfb020185ddad1aca1b75f9327620cb5ff33faea7a27bc87d5b931f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.48.0/nvp_0.48.0_linux_arm64.tar.gz"
      sha256 "9293dee2d6c5d83fc5811e2cf30d874d8f6ba2994982c9928f05081de1dbdb73"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.48.0/nvp_0.48.0_linux_amd64.tar.gz"
      sha256 "6030190e2fff5f88e139ced088733f13efa30cc18d3a20b19b4989d2cf57a39d"
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
