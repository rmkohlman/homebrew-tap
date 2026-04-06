# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.59.19"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.19/nvp_0.59.19_darwin_arm64.tar.gz"
      sha256 "d2d114fb5cb2b48704f32507278e1b6d3d988722a2583a03fe1daa915654116f"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.19/nvp_0.59.19_darwin_amd64.tar.gz"
      sha256 "1ad18b80f31de828e2bb36b0b06dacac46ee2e772f43ade978ace0d01f5b0a77"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.19/nvp_0.59.19_linux_arm64.tar.gz"
      sha256 "a62f74b2e812b84a559005c6cb8a3273ad1c838e94a828b0ba51cec694308d3a"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.19/nvp_0.59.19_linux_amd64.tar.gz"
      sha256 "93a5cd2d2e236221100d3def2f7fae99ff94e3330d0d4519ff27b49b8d1eea5c"
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
