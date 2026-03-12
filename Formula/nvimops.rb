# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.39.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.39.0/nvp_0.39.0_darwin_arm64.tar.gz"
      sha256 "48b0f8c9e60e84457195fc0499fceb9471eab4bc3539a99761eeac5d59ac0b91"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.39.0/nvp_0.39.0_darwin_amd64.tar.gz"
      sha256 "a446489815a4265c3a0d127a725dbba9abeb24b28278a8008bb68ec0075713fa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.39.0/nvp_0.39.0_linux_arm64.tar.gz"
      sha256 "8e8a57c6b8d278818b8135ad0f8c6c82762bb9c5a6fbda98ba5207447ce676f6"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.39.0/nvp_0.39.0_linux_amd64.tar.gz"
      sha256 "9e816d231166d4245a1b02ff3d2cbff53aa95f53f501eaf8cd2089d0fa303e13"
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
