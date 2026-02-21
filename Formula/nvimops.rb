# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.18.15"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.15/nvp_0.18.15_darwin_arm64.tar.gz"
      sha256 "7d04d762e9a941203664f3630c1e0f9c032309b7e1c30f5e60c48d104ef26aeb"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.15/nvp_0.18.15_darwin_amd64.tar.gz"
      sha256 "d23f82d55838820201637e5e8584e634205a214b207d1be283a1e67ec37ad3ed"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.15/nvp_0.18.15_linux_arm64.tar.gz"
      sha256 "43d77a5a27626c2d069c10e702f94acc998752c22ba5f20bd8dc9a828a1843a2"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.15/nvp_0.18.15_linux_amd64.tar.gz"
      sha256 "12581e8379fd7929a7f5879e653d7875cc949251d3ba2b5d002be1166097692f"
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
