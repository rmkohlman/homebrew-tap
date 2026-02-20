# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.18.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.0/nvp_0.18.0_darwin_arm64.tar.gz"
      sha256 "4fddb9b3baead9ba2674e61d73c04b35b5a09f8012da4769dd4705c675bf9faf"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.0/nvp_0.18.0_darwin_amd64.tar.gz"
      sha256 "98d05cd0a8b106a2a403a0b167688e55ce042e1eb18883b06db78b5ff313cc92"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.0/nvp_0.18.0_linux_arm64.tar.gz"
      sha256 "424674f17d7a451f0f904dedba3be20a9a46c2ee6eec083c0bb73cafc45dbb08"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.0/nvp_0.18.0_linux_amd64.tar.gz"
      sha256 "22b361f47addb48e4cd9c893b5393a5cc511adac43737970b62913a80d22208d"
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
