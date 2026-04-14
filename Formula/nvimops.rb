# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.94.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.94.0/nvp_0.94.0_darwin_arm64.tar.gz"
      sha256 "64e07486e263ac3a76e563bf08165de92699eeeeee8adffdd9ba2c18c2612405"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.94.0/nvp_0.94.0_darwin_amd64.tar.gz"
      sha256 "145143d1f8478a8590f63de26567dcd65aad707a08e630e6a0671874bd1d4923"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.94.0/nvp_0.94.0_linux_arm64.tar.gz"
      sha256 "6c4266488531338a727e9a765cdc130224309ce928ca0ee171b67b985292f73b"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.94.0/nvp_0.94.0_linux_amd64.tar.gz"
      sha256 "b972312dc7882da23774ed894f80cb8ff2f14be076f0ac7302338ad995f62b4a"
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
