# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.49.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.49.0/nvp_0.49.0_darwin_arm64.tar.gz"
      sha256 "834ca7d3b33354dd469fe169d1d72b4fc29f31bdb4b16fb13f4708f9ea971124"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.49.0/nvp_0.49.0_darwin_amd64.tar.gz"
      sha256 "6918bd6cb4069144d1adb079919fc55658f76b9ec07f052d8201cadc9d08132e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.49.0/nvp_0.49.0_linux_arm64.tar.gz"
      sha256 "e94acf162dbc0255e12b7f139f6c4e2bd2dbb563478e33d5842f39f4a1aeb047"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.49.0/nvp_0.49.0_linux_amd64.tar.gz"
      sha256 "c5054bcacbf2facba21fff9633efc71c35dafaffe33089b5b06240240fbe8979"
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
