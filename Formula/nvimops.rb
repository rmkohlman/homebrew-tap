# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.81.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.81.0/nvp_0.81.0_darwin_arm64.tar.gz"
      sha256 "71051aa3409e157c5a5584f0ac8bbd6be77b4f07a504fc77917518e467b9ecd2"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.81.0/nvp_0.81.0_darwin_amd64.tar.gz"
      sha256 "82ab95682f6919f864ac443e522b7b846602f891beacc4aa97c7401c46c71f95"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.81.0/nvp_0.81.0_linux_arm64.tar.gz"
      sha256 "2e47a435554fdad50ad32469f34234ef43d407ecace4a74ee76f01daf08ee541"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.81.0/nvp_0.81.0_linux_amd64.tar.gz"
      sha256 "d4ce94dbd50446cf95acf62893949afa241d48585268c534324aebce801e08ec"
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
