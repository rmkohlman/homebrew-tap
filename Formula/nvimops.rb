# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.36.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.36.0/nvp_0.36.0_darwin_arm64.tar.gz"
      sha256 "777572a96dc3a0a7ec09bd2085815ec52fb91101a2c8e4e8adfb233055281784"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.36.0/nvp_0.36.0_darwin_amd64.tar.gz"
      sha256 "5b1e2a64f41748e5ad1e8bd50a9731221246e5ae0abb9bb5b7595ca187a055ac"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.36.0/nvp_0.36.0_linux_arm64.tar.gz"
      sha256 "97f36dea99f0af4b658de04054748f93453a6c901c8e6a6a1bbec4ec70d66deb"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.36.0/nvp_0.36.0_linux_amd64.tar.gz"
      sha256 "b368a4c04ae3068a09a00c8e875b9f3bfe72dbf1a03aa5ef89f503e957030163"
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
