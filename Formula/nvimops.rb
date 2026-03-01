# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.21.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.21.0/nvp_0.21.0_darwin_arm64.tar.gz"
      sha256 "84e755f3f365809eb92006f920bb95cdba35e249c08b41724726d7b36bd04257"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.21.0/nvp_0.21.0_darwin_amd64.tar.gz"
      sha256 "f1442e00ed4ee43700415f35e75cf6241042ac59c26933c8ea9457e245396d23"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.21.0/nvp_0.21.0_linux_arm64.tar.gz"
      sha256 "aaadee226221aca7b94aa59999f9526c7263ea9f59b9672d749145bdec20cdff"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.21.0/nvp_0.21.0_linux_amd64.tar.gz"
      sha256 "212afe664f87a15b96a7dc2f60646d393bf817027b2b384319951e3ab13fe346"
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
