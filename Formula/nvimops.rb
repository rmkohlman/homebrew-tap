# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.96.3"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.96.3/nvp_0.96.3_darwin_arm64.tar.gz"
      sha256 "a29d7d376dde4464753db628a2ba7a4706a896bd11b98732ade89dc7850b8b16"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.96.3/nvp_0.96.3_darwin_amd64.tar.gz"
      sha256 "24a338341969cb68f4579f538536dafc252bf778d707ab29f444e15d32d0f7c2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.96.3/nvp_0.96.3_linux_arm64.tar.gz"
      sha256 "621b7d436e708fef7f81a07bd30615536f833e8434b2b0f9eed8213fde73d5ae"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.96.3/nvp_0.96.3_linux_amd64.tar.gz"
      sha256 "32fbda3889a62f9a113846e910173702271fde1ffdf346e48be3efd84b2390f5"
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
