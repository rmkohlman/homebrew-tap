# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.99.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.0/nvp_0.99.0_darwin_arm64.tar.gz"
      sha256 "718971df301bee8d2b0cb5e210b3a2c9cae5c2e0320678039b0d023beeb3a4ee"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.0/nvp_0.99.0_darwin_amd64.tar.gz"
      sha256 "be73f6220880347c68675827c9d2c3214924531266a5cc44a887ee8f44a19202"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.0/nvp_0.99.0_linux_arm64.tar.gz"
      sha256 "8c132d0d787a87f3d4c76e51d37e6e42b7f6f0799572bbb5e8a776ac331ee200"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.0/nvp_0.99.0_linux_amd64.tar.gz"
      sha256 "ad29efb2f54d54a46758ab73462d3c374d04f2f7fd94ded87e2498c35f2e9cbc"
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
