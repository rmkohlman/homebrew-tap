# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.105.3"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.105.3/nvp_0.105.3_darwin_arm64.tar.gz"
      sha256 "a39c9b5015cad9e987a6fd6a67cc8a276e076a90a00c58c11a54915f142b5629"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.105.3/nvp_0.105.3_darwin_amd64.tar.gz"
      sha256 "30d8cd1b6f37b5a2a3b3aada94c11303d3e0c261bcd8c696b42d01f6a871e0ec"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.105.3/nvp_0.105.3_linux_arm64.tar.gz"
      sha256 "6b22d5dd809f89c1e427f8d59258f5f13b158dc3159b0ed2beb2a54100eb9c64"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.105.3/nvp_0.105.3_linux_amd64.tar.gz"
      sha256 "8f9432db41565e64a89dde69d3c3266b324d50a466e7b95aa98cd10b522aba73"
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
