# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.32.7"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.7/nvp_0.32.7_darwin_arm64.tar.gz"
      sha256 "c67e4b80833a63379eca52792ded8d688995a567accfcfb9000a75e5366ddf05"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.7/nvp_0.32.7_darwin_amd64.tar.gz"
      sha256 "2fa13a5cae7c005b2cdfa4b1632b3089ff734869e11c5a8ce59d286fdc52c3e8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.7/nvp_0.32.7_linux_arm64.tar.gz"
      sha256 "e75febb31735cf3ef4713f4021e3cc2b02c3d0c12ea2fe070322f1b4295d1a07"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.7/nvp_0.32.7_linux_amd64.tar.gz"
      sha256 "7e36e84a34e0c1ab18180f7b7cfdc74d1f97099559dcd9820885c843c52b0350"
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
