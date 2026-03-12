# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.36.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.36.1/nvp_0.36.1_darwin_arm64.tar.gz"
      sha256 "d097f584b4263887db849488f341df86344ea1d88fef81f91687647f77f809de"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.36.1/nvp_0.36.1_darwin_amd64.tar.gz"
      sha256 "d6f4c67e2002b107e2abefc6dab437da1e49cb3d58e29f9f94daea063bc3d9d3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.36.1/nvp_0.36.1_linux_arm64.tar.gz"
      sha256 "0929db59cbf70e3746e8289da2d739d2b496a5caa577d356680904d67f6b6ead"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.36.1/nvp_0.36.1_linux_amd64.tar.gz"
      sha256 "1a177f18bbbad471ae7b2e024b184b0e98a4856d2b6476636098c08844496d96"
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
