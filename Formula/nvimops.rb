# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.47.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.47.0/nvp_0.47.0_darwin_arm64.tar.gz"
      sha256 "e692a6ffe245c59e6766f59cdead8b47cf3c9ae92fcd5b1e81f3b851602fbb57"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.47.0/nvp_0.47.0_darwin_amd64.tar.gz"
      sha256 "1b45faeeccf98013a652881b5fa4be8843bf015571ded5d2e065c8d625d1eadd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.47.0/nvp_0.47.0_linux_arm64.tar.gz"
      sha256 "89b8732b9c59238b3f270a5b78584d0d506076ecfbb073f6a2b7bf8a0a91fbca"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.47.0/nvp_0.47.0_linux_amd64.tar.gz"
      sha256 "e7d2c7bea724f42477e5dd7d966de4f7ed70427a857e7584791e7c99c9d12e0a"
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
