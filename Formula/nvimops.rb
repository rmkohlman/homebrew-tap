# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.100.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.1/nvp_0.100.1_darwin_arm64.tar.gz"
      sha256 "bfb69c4160e0f9501e973395fcf1a3c2df230ed1448df38d926d25e221c0f806"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.1/nvp_0.100.1_darwin_amd64.tar.gz"
      sha256 "8ed57b1b9072ea50391743ec95b11a575470b53f0ad04c5e0a310eee2adb8834"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.1/nvp_0.100.1_linux_arm64.tar.gz"
      sha256 "2abf48a2e9d80e951242a8861621297eb0c0e3403254721ba1f9091dc91909af"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.1/nvp_0.100.1_linux_amd64.tar.gz"
      sha256 "5ba3b683ab9ecb632747fe46c4c36fa7138e355ad460b00274340caaae55f06c"
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
