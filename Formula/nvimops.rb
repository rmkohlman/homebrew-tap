# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.32.3"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.3/nvp_0.32.3_darwin_arm64.tar.gz"
      sha256 "bcb8de9cac4e3f1700299092176f515c70d04544783e1614600505f5762c313f"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.3/nvp_0.32.3_darwin_amd64.tar.gz"
      sha256 "1011ab4fd06ae86810fb455cac5ba48aae640f308ced2df269dd4772b3d71567"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.3/nvp_0.32.3_linux_arm64.tar.gz"
      sha256 "d9462a37e89819fad4f7c4677089de4d0e23f66b462886d26518ed445c71ab2a"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.3/nvp_0.32.3_linux_amd64.tar.gz"
      sha256 "3792aad965f794ffc9e15063adce61205eefc0ab8af3b41489d08447cc6a175f"
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
