# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.32.6"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.6/nvp_0.32.6_darwin_arm64.tar.gz"
      sha256 "90f33e29ccc28cedf6cf089b91740ae03d3335216d1bae1333d07f7b761423f0"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.6/nvp_0.32.6_darwin_amd64.tar.gz"
      sha256 "f2736858c3148f0ae5a885ffd8247093ebd294ca2f1cebf9e990064524ab5605"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.6/nvp_0.32.6_linux_arm64.tar.gz"
      sha256 "88146bb6822a70d7f82bbfb43f3a6a0e3e727aee021acd9e3809b218e9049f4c"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.6/nvp_0.32.6_linux_amd64.tar.gz"
      sha256 "6fb012f559a57163f6f9caf197e6ed38b2b8b3e2194e17610ae66298978563bf"
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
