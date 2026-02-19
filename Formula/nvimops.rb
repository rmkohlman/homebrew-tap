# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.12.3"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.12.3/nvp_0.12.3_darwin_arm64.tar.gz"
      sha256 "0b3ee3ebcf885ae702a7d78d7423814aa0213a8cb91090c27dc4c6b585d32841"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.12.3/nvp_0.12.3_darwin_amd64.tar.gz"
      sha256 "80e7c0fea418400cfcb97558f416c2c0039a3b9a03aeb1c158ab72aa6cd4cb02"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.12.3/nvp_0.12.3_linux_arm64.tar.gz"
      sha256 "1bcf802464fb7e3a482089e46bf7bb833c6846fcc813a496a7755c4d57225cfc"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.12.3/nvp_0.12.3_linux_amd64.tar.gz"
      sha256 "400f70bb2ce9f07fbb6979d0eba5bf5b49a05845968dcce527b5a115eb9c605c"
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
