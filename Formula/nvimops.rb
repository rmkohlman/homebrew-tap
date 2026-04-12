# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.85.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.85.0/nvp_0.85.0_darwin_arm64.tar.gz"
      sha256 "98d1c35c8eb166a4493442a5aec1a2d768b4186743114b8f494da7a8b7218fe3"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.85.0/nvp_0.85.0_darwin_amd64.tar.gz"
      sha256 "956bb69dc3c541031e776dbed8afadcf8abc4a6ce8c1c833720c612111b5095a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.85.0/nvp_0.85.0_linux_arm64.tar.gz"
      sha256 "e49cefd257fb9b82be13c9cb46fed9a60f957cf440e01caf18483d72eb8189a4"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.85.0/nvp_0.85.0_linux_amd64.tar.gz"
      sha256 "7e1f56e8ef7a07a22344fa93d72599b272efea62a566fb891fc76ab694bcd5b7"
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
