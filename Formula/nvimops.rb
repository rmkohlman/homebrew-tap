# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.102.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.102.0/nvp_0.102.0_darwin_arm64.tar.gz"
      sha256 "8c80c5460ca7287ca856b152a058295823c03e0f23861ec1640b7b593105d82a"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.102.0/nvp_0.102.0_darwin_amd64.tar.gz"
      sha256 "96be2289707de8c285a16dbee291cfa288e8370750c62d8410b52fbf859f734c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.102.0/nvp_0.102.0_linux_arm64.tar.gz"
      sha256 "f9356bfe7343be26c9de55701c5981b3d6287e1f14f1b41636d5720642dcab34"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.102.0/nvp_0.102.0_linux_amd64.tar.gz"
      sha256 "670168f5b8e584f1b7f0710fc51f618e0195a2b2696a66187438cc59256ebe5a"
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
