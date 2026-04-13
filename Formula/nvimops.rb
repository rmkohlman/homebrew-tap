# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.87.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.87.1/nvp_0.87.1_darwin_arm64.tar.gz"
      sha256 "b04770de1a2af8ea978a2e39d30be02c6522822680a45a9cdd4b07c10cb710de"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.87.1/nvp_0.87.1_darwin_amd64.tar.gz"
      sha256 "aa86b8997b688856977228597d131acd7da7eeb2b8c7dbfc1d830c17260e8887"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.87.1/nvp_0.87.1_linux_arm64.tar.gz"
      sha256 "3fddb2b319dd9dad7e3b61987abc368ae994f10366116c0c843b6074a22648f7"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.87.1/nvp_0.87.1_linux_amd64.tar.gz"
      sha256 "97168e168cde38e4b23a287aabe971821949358ff845c15e77a2afd0bf58f12b"
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
