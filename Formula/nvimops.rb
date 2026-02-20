# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.17.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.17.1/nvp_0.17.1_darwin_arm64.tar.gz"
      sha256 "a2f906c9af3d2888dd07b187fc48ad6b4708fade8a61e360724b5ca9098e9be5"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.17.1/nvp_0.17.1_darwin_amd64.tar.gz"
      sha256 "6cdb5c63b7e81fb0890fe96aff2123bb6b388e22cea484ae696cc3222897b2bb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.17.1/nvp_0.17.1_linux_arm64.tar.gz"
      sha256 "4fc0875015ee0a2bcb9557afe4f9cce0a8072ec72ab7c1b5dd7755df58157520"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.17.1/nvp_0.17.1_linux_amd64.tar.gz"
      sha256 "fe5d87bce38d83ce2a4bb51eed9e2068e00a449329e0d166cb4e391bccef0247"
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
