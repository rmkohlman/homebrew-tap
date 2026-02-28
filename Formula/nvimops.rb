# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.20.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.20.0/nvp_0.20.0_darwin_arm64.tar.gz"
      sha256 "daebd781216f7ee7d99868a4c77bcffc23f819039128eab59dcf3e4c38313e94"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.20.0/nvp_0.20.0_darwin_amd64.tar.gz"
      sha256 "291e6a3dd72e99c1ec12c08747daa812e9c89d97b9cac5b0a7ff87c6b5cfb4da"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.20.0/nvp_0.20.0_linux_arm64.tar.gz"
      sha256 "28cd2c31b92e42acbd065e1490dd7b6370026f3844c1ff6b41bdcc7c4d5b3e20"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.20.0/nvp_0.20.0_linux_amd64.tar.gz"
      sha256 "fdf2014198722a2e3705a514dd0d07779b146876c3fcd83d93138d825b660095"
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
