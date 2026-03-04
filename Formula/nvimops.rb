# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.30.4"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.30.4/nvp_0.30.4_darwin_arm64.tar.gz"
      sha256 "9c4bace0007902f204cb2454e337dd3e7025a6ae6f863b1a03d0063b85b02378"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.30.4/nvp_0.30.4_darwin_amd64.tar.gz"
      sha256 "19f56bf9ffc9cbda7536971cb0aff3f4817a46f6a10685821e4ecc782572d76e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.30.4/nvp_0.30.4_linux_arm64.tar.gz"
      sha256 "fc891af8bb347a80005e9be3bae75139fe5f3c6afa6abe40b8cfff54a111899e"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.30.4/nvp_0.30.4_linux_amd64.tar.gz"
      sha256 "2d51ea53282351468bf2f1518b3bfc7f7570da741c8768237233cff1491a61dc"
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
