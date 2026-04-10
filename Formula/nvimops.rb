# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.82.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.82.0/nvp_0.82.0_darwin_arm64.tar.gz"
      sha256 "2a6c306749c943d7938145a730cfcdce34b09d6268db792de82a81e0cae3af22"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.82.0/nvp_0.82.0_darwin_amd64.tar.gz"
      sha256 "6144947d96fda0ca8b12be98683d86302dc5f28a7a5b4dcd811f102ca9bfc9dc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.82.0/nvp_0.82.0_linux_arm64.tar.gz"
      sha256 "9885e70c1238c19b4186fbe39c77c9b3ffce379b3d322aa8079ecf0a71cf12fe"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.82.0/nvp_0.82.0_linux_amd64.tar.gz"
      sha256 "c0ba3336daccbccc7432a897b043b4a50b5985604107070362a3bb1f1c9f5c55"
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
