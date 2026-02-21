# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.18.7"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.7/nvp_0.18.7_darwin_arm64.tar.gz"
      sha256 "466d0a2ecc0e5072541712eca0884e2dbd88e136b19f859478124b31c0af9967"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.7/nvp_0.18.7_darwin_amd64.tar.gz"
      sha256 "6a1ec59c75fcec22093b43d09abde1e710e64444aad8880d973d8cff7df9f595"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.7/nvp_0.18.7_linux_arm64.tar.gz"
      sha256 "899553afc30368e0adaf21ecd906098cdfee8f1580d1cc7dc352ddae2c6da454"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.7/nvp_0.18.7_linux_amd64.tar.gz"
      sha256 "801eaf5d271854cb553ca333811ef15fbe3910d54291aafc543ef5efa3cc3e13"
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
