# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.45.5"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.45.5/nvp_0.45.5_darwin_arm64.tar.gz"
      sha256 "551207c9cc45e8884a1ae46a7dd042256494b88177197ed145ab0cdac09c95bd"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.45.5/nvp_0.45.5_darwin_amd64.tar.gz"
      sha256 "1d707fbecc40c7b72c3010bf9c8406b053048679a8c987b24a62c587335d8d14"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.45.5/nvp_0.45.5_linux_arm64.tar.gz"
      sha256 "648d28017957fc15744961ff20741b67592124f30c97a09693ab7ec7563f5d49"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.45.5/nvp_0.45.5_linux_amd64.tar.gz"
      sha256 "d5b3e2d8a66513bf90e9be350734b403a4decba5a5b2169eaccb45463ea3647b"
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
