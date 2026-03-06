# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.34.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.34.0/nvp_0.34.0_darwin_arm64.tar.gz"
      sha256 "0e8d1a2e107e239c071e87b9ae1e630512c02d06ea4dd91d84bfbdcdb746d6e9"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.34.0/nvp_0.34.0_darwin_amd64.tar.gz"
      sha256 "bb4288fb17deafc7a550c8bc0b2fa5972943db9892654a4fc2a644bc6f855d21"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.34.0/nvp_0.34.0_linux_arm64.tar.gz"
      sha256 "105a7de1ce372ee1d964d9b6c9df1e34d102bc796e60214e501837084c796972"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.34.0/nvp_0.34.0_linux_amd64.tar.gz"
      sha256 "2e7fa2729ae9afb42a0a7a3eec120776ddbca383eca5db7031348244374ae546"
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
