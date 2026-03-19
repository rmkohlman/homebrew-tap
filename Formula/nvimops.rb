# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.57.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.57.1/nvp_0.57.1_darwin_arm64.tar.gz"
      sha256 "9d5ad05fe0b24331a440c99c0723aa70b9840c496f6dc58249c68c34f6839f99"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.57.1/nvp_0.57.1_darwin_amd64.tar.gz"
      sha256 "9193d0c4f7e029746971f55e848a335c4fe16311f3df242003a94f2fb0324a84"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.57.1/nvp_0.57.1_linux_arm64.tar.gz"
      sha256 "e27d2882180f535c0031f157264ce96a9987fad426338bd0d44cd9a525b0fee2"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.57.1/nvp_0.57.1_linux_amd64.tar.gz"
      sha256 "dbcfa36c87d063dac3f3da200d4a01a0ab39bbc7c5d7d861d5bacaf84c53c4e1"
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
