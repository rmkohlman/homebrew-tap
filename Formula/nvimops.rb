# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.9.3"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.9.3/nvp_0.9.3_darwin_arm64.tar.gz"
      sha256 "b3dcfa88d498a1d6c6aef4291846b9fca10e63ba6e82527b7c6f6b5ee05cf1bc"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.9.3/nvp_0.9.3_darwin_amd64.tar.gz"
      sha256 "fc3e866036c726f2610a2fc015092b8c24107ae16b1e8da0fb4a3212680e4526"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.9.3/nvp_0.9.3_linux_arm64.tar.gz"
      sha256 "d8a658bfda7e21cbb4854a90ac2246b42a36f21cfe3b1121649b6749926be2d3"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.9.3/nvp_0.9.3_linux_amd64.tar.gz"
      sha256 "2ca7c28926d3d7ba5a5fbf1f009a25cc2acab030c2369d2be98fa4ef06639c39"
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
