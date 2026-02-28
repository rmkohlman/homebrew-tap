# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.18.25"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.25/nvp_0.18.25_darwin_arm64.tar.gz"
      sha256 "9d90afd415c9756aaeaa386695270bca8493f2ea2c4a0c6c6f9f0ebc0b2e9702"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.25/nvp_0.18.25_darwin_amd64.tar.gz"
      sha256 "0103ee406e9eef863d22d1724b8499f24598688a9a7dc8fa849cc91e80a88703"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.25/nvp_0.18.25_linux_arm64.tar.gz"
      sha256 "2d2e9d706af66ebb193e801645a9145667327d98581ca7638dea258f69493b7b"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.25/nvp_0.18.25_linux_amd64.tar.gz"
      sha256 "5cf23a6eba8c1ff3c6238677077ea0750ffdc3de93fabbcca13b4c2355b9ea11"
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
