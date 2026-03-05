# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.33.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.33.1/nvp_0.33.1_darwin_arm64.tar.gz"
      sha256 "aa51dd33b4651a06b4a75b903f661ce9eb11da92a6ac7f04df3e80c6e532ee3d"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.33.1/nvp_0.33.1_darwin_amd64.tar.gz"
      sha256 "d0a0afd62d8a6a93c184f6254e92ce73686b1e113652dacad03c68aa86c463c5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.33.1/nvp_0.33.1_linux_arm64.tar.gz"
      sha256 "c8a7adc2fdd2296e590afc708b39a14052415f3531b17cc154625e62d9879d88"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.33.1/nvp_0.33.1_linux_amd64.tar.gz"
      sha256 "7c729db451a52ce6aa3959d4f9e977482a2f4c9ae02ed0f9f4adae39342a5e21"
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
