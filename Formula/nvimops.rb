# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.15.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.15.0/nvp_0.15.0_darwin_arm64.tar.gz"
      sha256 "d5a6dcde4eeeade3fb5063370563fecad19fe436e043a40f7444314d900e8695"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.15.0/nvp_0.15.0_darwin_amd64.tar.gz"
      sha256 "02ddf8011e826ab18db7ca45537463e4e72275c0c2084421f6e4a5c6d006aac1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.15.0/nvp_0.15.0_linux_arm64.tar.gz"
      sha256 "b51b68de168783b494036ced166eb623011cba7986bbc1db35cfa3fb11825e1d"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.15.0/nvp_0.15.0_linux_amd64.tar.gz"
      sha256 "f6d08fdacd6833a5f27ed3762d96389fb43c1b5089514dc0b64bec9bdd068a89"
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
