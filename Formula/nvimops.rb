# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.85.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.85.1/nvp_0.85.1_darwin_arm64.tar.gz"
      sha256 "7a2f4232a4f727b416b6613a0a4a97246d5d779d8dba8a0639c9235ce3464d32"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.85.1/nvp_0.85.1_darwin_amd64.tar.gz"
      sha256 "ea12f78d894f733a6961def79713486ec5b37487fabed51e4ced041d1e051e6b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.85.1/nvp_0.85.1_linux_arm64.tar.gz"
      sha256 "9939bce68dc08de72d8531f74cc495aaa0bb1c01e49006946adea57476808774"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.85.1/nvp_0.85.1_linux_amd64.tar.gz"
      sha256 "88c77dfabc3dad1bbbec659e9755dd603845a9f0341a738a57f76f12ffbbeb79"
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
