# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.55.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.55.0/nvp_0.55.0_darwin_arm64.tar.gz"
      sha256 "610308f597039754de0f9561cefcab3089c736c92350a4395c3d75f6567a6e99"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.55.0/nvp_0.55.0_darwin_amd64.tar.gz"
      sha256 "939a3156fb8b4bb13c045023406eeb88c9b3b9aae5290b6c10b81a4c7fba601a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.55.0/nvp_0.55.0_linux_arm64.tar.gz"
      sha256 "ae36566314cb604f9715f20e43d9d76e1ad6c6687e160cd8c9c1352e0fda7869"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.55.0/nvp_0.55.0_linux_amd64.tar.gz"
      sha256 "98c9d6c82d7faea30ffd58416fedbf49bb4f6853e4f3dc30afd87ea0997c3b38"
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
