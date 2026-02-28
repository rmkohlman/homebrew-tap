# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.19.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.19.0/nvp_0.19.0_darwin_arm64.tar.gz"
      sha256 "3eb1767deda685be2c8eca7cddc736498f3450b786a6e0e34b899fa416d124b6"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.19.0/nvp_0.19.0_darwin_amd64.tar.gz"
      sha256 "07b95d589801247e951f0b9c61b98589f3229e497e586d4cef5684a20619e867"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.19.0/nvp_0.19.0_linux_arm64.tar.gz"
      sha256 "d05261aa15759ed6b4ed4ff70e6263274fe14f2fe272e8ed121cd49878bbbd34"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.19.0/nvp_0.19.0_linux_amd64.tar.gz"
      sha256 "1f20155049ed60462218395e3c820a5eb60a4acb7a05f2eb3461e220a848bb8a"
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
