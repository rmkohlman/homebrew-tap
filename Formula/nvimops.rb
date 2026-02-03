# typed: false
# frozen_string_literal: true

# NvimOps - DevOps-style Neovim plugin and theme manager
# Install with: brew install rmkohlman/tap/nvimops
# Binary name: nvp

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.5.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.5.1/nvp_0.5.1_darwin_arm64.tar.gz"
      sha256 "f14a477d10cff333d657565368fd730a9e45eeacc765bf778f57525995e89c15"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.5.1/nvp_0.5.1_darwin_amd64.tar.gz"
      sha256 "9e3889cb463d3b8839ab6e38d0d109b5ce30ca7d4c50b07e82b48afb03a7df59"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.5.1/nvp_0.5.1_linux_arm64.tar.gz"
      sha256 "4a4ac75e25824cce34cc5920529e8511a93e11369e41bbb18b8b109bf4ec89ae"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.5.1/nvp_0.5.1_linux_amd64.tar.gz"
      sha256 "229e268895b653b533444580b01b2093746ada3acc83373ab279c464f8b4b607"
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
      # Install binary from archive
      bin.install "nvp"

      # Install pre-generated completions from archive
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
        nvp library list                # Browse 16+ available plugins
        nvp library install telescope   # Install from library
        nvp theme library list          # Browse 8 available themes
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
