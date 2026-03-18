# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.52.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.52.0/nvp_0.52.0_darwin_arm64.tar.gz"
      sha256 "c4af0ffa9531a6f8a35eb2eb3269bcfbb74c71ca48abf2b811b7e005f70ed96d"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.52.0/nvp_0.52.0_darwin_amd64.tar.gz"
      sha256 "c022c04cb2daa7c6d38bafbf89f243dbafbea59077b4e639337046cfd061743e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.52.0/nvp_0.52.0_linux_arm64.tar.gz"
      sha256 "1ad65dde373f4604fffc7efd270515b90218d2459782e8e287908e3abf112d33"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.52.0/nvp_0.52.0_linux_amd64.tar.gz"
      sha256 "1ea2c04f7990a067186ec40f25d7165f13521841f46a1ab0c504116dd846b595"
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
