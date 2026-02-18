# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.9.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.9.0/nvp_0.9.0_darwin_arm64.tar.gz"
      sha256 "56e701058a4eb0b630d2e0769c7334ee6fb108f862376a4ff12cfe96083d519e"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.9.0/nvp_0.9.0_darwin_amd64.tar.gz"
      sha256 "4f490e1fc0ba5831e6694ee8da00a35fd2058cee5dc9658022f69dc8340fe700"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.9.0/nvp_0.9.0_linux_arm64.tar.gz"
      sha256 "feaa7e6f9c796a521eef4d5f2523378b970fd2a0f06cf04dec5df61a9b8ba337"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.9.0/nvp_0.9.0_linux_amd64.tar.gz"
      sha256 "4cf66bb70ec550798aebfff0ff59bfb69baaa29400bfb00c485820c8e41c1cc9"
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
