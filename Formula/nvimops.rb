# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.20.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.20.0/nvp_0.20.0_darwin_arm64.tar.gz"
      sha256 "208536425df41d53b218a05b4d118ee5dfabda99c1b4fbaf183188f3bef77438"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.20.0/nvp_0.20.0_darwin_amd64.tar.gz"
      sha256 "ea9bb28c391081a199f303cd9624a5a9d397c837ec86771b2134dc4b40df3605"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.20.0/nvp_0.20.0_linux_arm64.tar.gz"
      sha256 "1eb88254cbb8130d42ccd5807f560d364839cf3add88038948171e48db7f66b4"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.20.0/nvp_0.20.0_linux_amd64.tar.gz"
      sha256 "95719b94def8ed90fddedb474dafdae502c3778e85c6ccea9dd99ef5c7946b5d"
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
