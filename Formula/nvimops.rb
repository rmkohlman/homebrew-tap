# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.22.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.22.0/nvp_0.22.0_darwin_arm64.tar.gz"
      sha256 "88aee9053b0f388308af8f50c852aefd5dcffab8e0099400301df41d9172125f"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.22.0/nvp_0.22.0_darwin_amd64.tar.gz"
      sha256 "89865a7c28732eec9f44f68bdfe9714706a2a61f3eaac9cde8256de0a6337cec"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.22.0/nvp_0.22.0_linux_arm64.tar.gz"
      sha256 "9a1a4e931e951c26e0645dc23ac06f06a80fd0a3fe4c7d1e566b6f6613ddd986"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.22.0/nvp_0.22.0_linux_amd64.tar.gz"
      sha256 "ca63c02c93b36e4b86d6e2dd591047907a6637dcaf225fea1bc78de18f54944b"
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
