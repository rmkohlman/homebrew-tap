# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.18.18"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.18/nvp_0.18.18_darwin_arm64.tar.gz"
      sha256 "ad7ff126857e45478d2b904d4fd71816ade2b5b3e2786910a3518337e06c26e7"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.18/nvp_0.18.18_darwin_amd64.tar.gz"
      sha256 "1035cc149b46ed9578a7f9f299c5d1873589864a799e6b3c41a8fefc21111200"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.18/nvp_0.18.18_linux_arm64.tar.gz"
      sha256 "c2a3604123aa2056b32c9559ad12d28aba599cceb49325ca5f2d4f423411f7da"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.18.18/nvp_0.18.18_linux_amd64.tar.gz"
      sha256 "dab691804ff467db309147435bbe547720918478644f20d72c09f0d79f351279"
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
