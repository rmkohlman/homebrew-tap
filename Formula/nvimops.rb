# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.26.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.26.0/nvp_0.26.0_darwin_arm64.tar.gz"
      sha256 "a47c0bc194ca4e906541728a97e45e2cbe4aca25993346c901f6b3017666e22d"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.26.0/nvp_0.26.0_darwin_amd64.tar.gz"
      sha256 "f87cc316c9637f6d1499ce2a677f78d83fb894be810e737b741cd81bbf2e7b61"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.26.0/nvp_0.26.0_linux_arm64.tar.gz"
      sha256 "09e37fa1e593a782eb1ad9dece65ad67c303a3045ff952ac6567d7fa58e037c1"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.26.0/nvp_0.26.0_linux_amd64.tar.gz"
      sha256 "7a6254752d29ef1352e359845de06ef255c4fb63d583cee4e09e7c81d8b0d5e2"
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
