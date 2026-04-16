# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.99.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.2/nvp_0.99.2_darwin_arm64.tar.gz"
      sha256 "759933142cb400e76b6e7567a912d6a06867623d9bac30a8dca324fb80cc9838"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.2/nvp_0.99.2_darwin_amd64.tar.gz"
      sha256 "d9993e4150f9f1f4c06ca09e0c67ef4a7f5c5c227a46c37c2b68a8b392f4958d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.2/nvp_0.99.2_linux_arm64.tar.gz"
      sha256 "f24a47a25b451cbe6b1cc3000371a7e6b7e6b48c52a1a5d7e6e57754262bd924"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.2/nvp_0.99.2_linux_amd64.tar.gz"
      sha256 "06641f91838f945ee6ac5671f5b11526f17a912dc9f8c2ca5c236efc52f2c849"
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
