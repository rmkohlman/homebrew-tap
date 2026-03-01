# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.27.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.27.0/nvp_0.27.0_darwin_arm64.tar.gz"
      sha256 "a718a68d60614d3db32f8532d48fe37e41b0e2f83951044fc7d1e58cd9a985af"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.27.0/nvp_0.27.0_darwin_amd64.tar.gz"
      sha256 "3259f43b556712d7ad6657bd41ca0986a07792429bc4ade27f07043985630185"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.27.0/nvp_0.27.0_linux_arm64.tar.gz"
      sha256 "b5314265e31d77719f173bcd0a5b1fc8dcea9ab8da94c4a188c323bf9bc9b663"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.27.0/nvp_0.27.0_linux_amd64.tar.gz"
      sha256 "3d9c9c1691e75a13e0f66d2ad01114535c575e54bf9cffa86000ee4261b2f467"
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
