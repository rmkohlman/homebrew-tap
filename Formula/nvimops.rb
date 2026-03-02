# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.29.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.29.0/nvp_0.29.0_darwin_arm64.tar.gz"
      sha256 "0ceb09c0b7fdddf87d50b72d1b7e300658e2354a1fa66cd23a9aad5be24bb82f"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.29.0/nvp_0.29.0_darwin_amd64.tar.gz"
      sha256 "353a88ee6b9791fab294ea36e4e66befac784767719af1bc7dbf20b7ee3b3d8a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.29.0/nvp_0.29.0_linux_arm64.tar.gz"
      sha256 "7a487f598a0a84d06d853b1a6aa66bdf5ac4c501007eea9a7f01bedbef894fe1"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.29.0/nvp_0.29.0_linux_amd64.tar.gz"
      sha256 "5cf3e71e4c9aa49e35cfa81517d73bc7a0bb0470058ac3359e2d5ca6d32ac25c"
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
