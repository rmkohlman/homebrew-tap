# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.32.8"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.8/nvp_0.32.8_darwin_arm64.tar.gz"
      sha256 "913501875fab8876ff9f4b922d4f9b2cbf7bbc7956c529cb19697f7c544e500e"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.8/nvp_0.32.8_darwin_amd64.tar.gz"
      sha256 "990a89a921f4a905eb21e86590c3cf25c730f4842389852e541878d6abdd140d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.8/nvp_0.32.8_linux_arm64.tar.gz"
      sha256 "2e8a56b511da6e3939602ec0cee822b54eaa023f64d099988392323fdea2c4e4"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.8/nvp_0.32.8_linux_amd64.tar.gz"
      sha256 "13f563a4530f6b6c0dae6efdc6b898f0c7f4ec2b10f52a6d716548ba8cfcc473"
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
