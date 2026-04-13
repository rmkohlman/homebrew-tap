# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.86.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.86.1/nvp_0.86.1_darwin_arm64.tar.gz"
      sha256 "c41b741943277d96a84ba63705fac3619590270c997cc21206e1428ca2470201"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.86.1/nvp_0.86.1_darwin_amd64.tar.gz"
      sha256 "8541e369192b95ebe1b76f95015cecc27fdac6938d9535bcc1839db9bc2452eb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.86.1/nvp_0.86.1_linux_arm64.tar.gz"
      sha256 "e3bc80598644e2d73ac7cf46b7ca617bcf8cb3b3cbd4b469bc39e131625ac963"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.86.1/nvp_0.86.1_linux_amd64.tar.gz"
      sha256 "fc029978479b2090c00c67f01b1bd5b28b671e0d6e2f85251cfde7db4b167b6e"
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
