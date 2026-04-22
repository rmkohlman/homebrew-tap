# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.104.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.104.1/nvp_0.104.1_darwin_arm64.tar.gz"
      sha256 "035d1f49230413e02f618aca95c90e2cee925ec3d4e3e0cb152cc897d22c7f81"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.104.1/nvp_0.104.1_darwin_amd64.tar.gz"
      sha256 "77c0f3016eb9d0303c406c4a6104aa68261c2eb66d6a0f9e9db78c3e027a766a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.104.1/nvp_0.104.1_linux_arm64.tar.gz"
      sha256 "98e643b5f7a4b36f07925070fe2830dfb93d66c47c6c6253c73c97b763885e84"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.104.1/nvp_0.104.1_linux_amd64.tar.gz"
      sha256 "dfc130aaa0ea99a250b896ada1ab3eb4e22457ac5046d75935351de66b8658f7"
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
