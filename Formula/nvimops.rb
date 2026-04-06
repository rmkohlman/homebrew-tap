# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.59.16"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.16/nvp_0.59.16_darwin_arm64.tar.gz"
      sha256 "b0c6ef58b001620bf71639cf7564c29d06383b96224f3165044b42e90d670799"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.16/nvp_0.59.16_darwin_amd64.tar.gz"
      sha256 "a49932dcb45a574e755c6ee76596ab6ee82f4597b84afee4b9882657a65dc8e5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.16/nvp_0.59.16_linux_arm64.tar.gz"
      sha256 "8f5ba5d26fce821130a0969bab453e9819c0deddbae3f668857e011fc6a7ffd0"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.16/nvp_0.59.16_linux_amd64.tar.gz"
      sha256 "9194c6b964d042d1250a40afd6a21f87195d91c0fdc63556a70925e6371ce353"
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
