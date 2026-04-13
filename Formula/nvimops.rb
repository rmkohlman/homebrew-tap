# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.87.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.87.0/nvp_0.87.0_darwin_arm64.tar.gz"
      sha256 "5cb2abda54f22d625d7f07e1566bea9424b5981a2966a607156675cf32ef35bb"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.87.0/nvp_0.87.0_darwin_amd64.tar.gz"
      sha256 "5fe3d77432951e5bd9639e8fe2c9724f948955f2afc7ed1cd016f30799158c31"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.87.0/nvp_0.87.0_linux_arm64.tar.gz"
      sha256 "60a28d43b236a915cdb2e9aa2fa67f08522cf79e9370b3d9002c19894558ae55"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.87.0/nvp_0.87.0_linux_amd64.tar.gz"
      sha256 "ffa16438bff8870fa612dc7ac6de55b3a1fb67e937dfa7794c68f225a345887b"
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
