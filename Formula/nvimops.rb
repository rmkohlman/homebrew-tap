# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.37.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.37.1/nvp_0.37.1_darwin_arm64.tar.gz"
      sha256 "4b862fb8e4297cdca87b7e2ad862e407f76a6d7939e59fe937bdbadfe03590eb"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.37.1/nvp_0.37.1_darwin_amd64.tar.gz"
      sha256 "85df434cc4afc3043efced390854e595a1ca3a95ee7a69c6f7343b3c795d6e9f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.37.1/nvp_0.37.1_linux_arm64.tar.gz"
      sha256 "5f60625a137c94346b013259263819cb162239f4223eec29e6dd34c2e6ef12e1"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.37.1/nvp_0.37.1_linux_amd64.tar.gz"
      sha256 "e3d6fe82461f11c5f7d4c9c75ab1e36aaa35754c638f70847af45a1172dd16a9"
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
