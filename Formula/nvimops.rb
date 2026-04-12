# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.85.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.85.2/nvp_0.85.2_darwin_arm64.tar.gz"
      sha256 "28d43ed8224258814db1aa9fc7c29c626291788a50daf6d2d9d6bbba4c912935"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.85.2/nvp_0.85.2_darwin_amd64.tar.gz"
      sha256 "a484fdbad57acc27325c3345a507a9193811df4fab6fab101db0562493c114ee"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.85.2/nvp_0.85.2_linux_arm64.tar.gz"
      sha256 "d005fed32123982da4e726baf86660c7d45d913b2acca1d7dd7811e3f14f575a"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.85.2/nvp_0.85.2_linux_amd64.tar.gz"
      sha256 "0005da91fb5192b03ddffe808aa326c44e0f076ceaab426398534ea867b4b3d6"
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
