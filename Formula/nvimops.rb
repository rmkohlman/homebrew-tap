# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.62.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.62.0/nvp_0.62.0_darwin_arm64.tar.gz"
      sha256 "9c13ce49274a992992019eed1c8205e32ba1b99d0a852ce86b66a70efd204ce4"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.62.0/nvp_0.62.0_darwin_amd64.tar.gz"
      sha256 "8dd7254be7f8966d6e35c83a2a0c45d141ba39f7d8c423438365631eb7efa89b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.62.0/nvp_0.62.0_linux_arm64.tar.gz"
      sha256 "f4f8652f499c873e2f1f0949f84ee5e788833bb8787055af6c373b4e807a64e6"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.62.0/nvp_0.62.0_linux_amd64.tar.gz"
      sha256 "cfe7f07b5368dfe203f5fdf7b976485c73ae52f1eabf124d3c543f49ac9fb0ed"
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
