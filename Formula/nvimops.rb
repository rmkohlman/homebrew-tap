# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.101.8"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.8/nvp_0.101.8_darwin_arm64.tar.gz"
      sha256 "c23720ab0e52d90950346b5812bf33013984e0b79971c9e90fbbd8a1c8faa575"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.8/nvp_0.101.8_darwin_amd64.tar.gz"
      sha256 "a3c3396f89e4c7edbba582f4f6373a60e88e4ae6483f419e7f04c66c866af78b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.8/nvp_0.101.8_linux_arm64.tar.gz"
      sha256 "9f90e93a62b4ab3ec0cb2add836c96fb1b0024b7b82f6a292479ce5f46b7a346"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.8/nvp_0.101.8_linux_amd64.tar.gz"
      sha256 "7be06838ed9f8d6b7346f887aa0055a12e3543843b44e43587abca0bea58f921"
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
