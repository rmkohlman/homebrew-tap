# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.16.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.16.0/nvp_0.16.0_darwin_arm64.tar.gz"
      sha256 "98cb690b4ecf4ed9dffe1aeda702e7a0b8a18ffe03c86073678ce06fccf52c00"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.16.0/nvp_0.16.0_darwin_amd64.tar.gz"
      sha256 "cf57b16710f7765578b6f5ea77e348d424e62c8c91f02c9d5e8d2087a5a7e8de"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.16.0/nvp_0.16.0_linux_arm64.tar.gz"
      sha256 "23150003deb5cd74629e488459ab16f7b436ebc2876efd1c488321b3c13572bf"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.16.0/nvp_0.16.0_linux_amd64.tar.gz"
      sha256 "c4469316668f5e55dbbb3cb9e77a86ed1c71f16c14da8fe92a4ff5b655261483"
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
