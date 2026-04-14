# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.92.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.92.0/nvp_0.92.0_darwin_arm64.tar.gz"
      sha256 "97fedac4e2e1aab26a745dfebfe7b964789c14b27a1439eb5627bca5b6fa4b75"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.92.0/nvp_0.92.0_darwin_amd64.tar.gz"
      sha256 "95ef657f8b91e815b6557034ea9e78a6d54937f575a6c9cd37be26be7f51cd7f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.92.0/nvp_0.92.0_linux_arm64.tar.gz"
      sha256 "f1dca024845464a0e04f0b2b97023b22d27ff98bf023feae947b321966002001"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.92.0/nvp_0.92.0_linux_amd64.tar.gz"
      sha256 "c7fa8a2d2c82007ec5cfee9113f7ff158ff6aa2b25ddc5fcb0a80950f5f21cee"
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
