# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.59.3"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.3/nvp_0.59.3_darwin_arm64.tar.gz"
      sha256 "a431cbacbe95fb550b93b378001bdfbdef56401ce2423dca9c00e354fe4d05fe"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.3/nvp_0.59.3_darwin_amd64.tar.gz"
      sha256 "298671811a70740d1f5364849c7b0b11cb1e1041f1b5e6b9f93be6560f7719de"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.3/nvp_0.59.3_linux_arm64.tar.gz"
      sha256 "e927a45a3095ad3e5ca493d3b6884fd5312e41433caf5723ce25edd5b59b27a8"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.3/nvp_0.59.3_linux_amd64.tar.gz"
      sha256 "0a9314e1ab1292e6cb2ee3c8e0419f429c94a1da0fe320c4eae5872524ba1363"
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
