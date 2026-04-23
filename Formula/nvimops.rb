# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.104.8"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.104.8/nvp_0.104.8_darwin_arm64.tar.gz"
      sha256 "bbdc677264eee33f3242681f1ee72360d058152ab148eb1e82c4e157f84f30f3"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.104.8/nvp_0.104.8_darwin_amd64.tar.gz"
      sha256 "6cbe650ca51f21d63f294f788aba96c15cd314b157e77afbbfef9f4e9465e0e0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.104.8/nvp_0.104.8_linux_arm64.tar.gz"
      sha256 "8b3dd1f7b0483ec7b9e30b50a46078f07443ee7e9ce6483cd98d85380f65f6ea"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.104.8/nvp_0.104.8_linux_amd64.tar.gz"
      sha256 "892368251cb2d74997f3ad862537a475e88356ba0f6816847774fca558d47d16"
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
