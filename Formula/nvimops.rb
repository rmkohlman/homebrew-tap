# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.101.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.1/nvp_0.101.1_darwin_arm64.tar.gz"
      sha256 "12f0554622c12033ea638cef079703e5cb9a6a4cebf749fabfda1483fe417481"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.1/nvp_0.101.1_darwin_amd64.tar.gz"
      sha256 "0508320a186dcc7c4ee4977cc1c1e78044fbbbfabecdf058b825bf634bdbf2c2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.1/nvp_0.101.1_linux_arm64.tar.gz"
      sha256 "17e57d093885e6083ed205a44a45bf4b826a52fcf1a6ffc2e409bf25e9806f49"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.1/nvp_0.101.1_linux_amd64.tar.gz"
      sha256 "14f85553ce78cf3a53535fe2686dd4865b52cea351a694715d63fb51faaa01ce"
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
