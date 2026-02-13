# typed: false
# frozen_string_literal: true

# NvimOps - DevOps-style Neovim plugin and theme manager
# Install with: brew install rmkohlman/tap/nvimops
# Binary name: nvp

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.8.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.8.2/nvp_0.8.2_darwin_arm64.tar.gz"
      sha256 "68b00ac65264fc012881a4707fdfb9a337ed2cd67939a2a5557a2362ccd00230"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.8.2/nvp_0.8.2_darwin_amd64.tar.gz"
      sha256 "d747e8152090af117dc882ed0d922d9900d3197300f66f687eedc4baf9328f9e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.8.2/nvp_0.8.2_linux_arm64.tar.gz"
      sha256 "b3ab3d627cdb0198f0856e7bbb8165027002e96dadec087ac6093e49dd42a688"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.8.2/nvp_0.8.2_linux_amd64.tar.gz"
      sha256 "603b1e8b3880878ed3ff95009adb304c6afed9097342d1d13850b67c54b5bf52"
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
