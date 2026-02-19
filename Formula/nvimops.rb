# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.12.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.12.2/nvp_0.12.2_darwin_arm64.tar.gz"
      sha256 "f80fcdcef970cfc7f355d0fb37f5cc9174ca2d8528af6f0f18f58fc5b1585003"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.12.2/nvp_0.12.2_darwin_amd64.tar.gz"
      sha256 "02823aa9f9349122b2fc87fbb591a3444a6f98a624aa833297e5991880d321b4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.12.2/nvp_0.12.2_linux_arm64.tar.gz"
      sha256 "c8310ad204a2a29870e02d94a42df3d5c7f6c6e72996714cbbf79c0ffebd8439"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.12.2/nvp_0.12.2_linux_amd64.tar.gz"
      sha256 "466b58da4062e35be74e6ca77fca0c0fd0bf1c6cc7c8d9d1d50353baf977ac2e"
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
