# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.99.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.1/nvp_0.99.1_darwin_arm64.tar.gz"
      sha256 "76c82ef24e07bf3515dc96f0368ccf8746c2f913d24bb8deec8acdc3cc9eb300"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.1/nvp_0.99.1_darwin_amd64.tar.gz"
      sha256 "2a19cd979933b985a51e5bb3c694439f9c4691fd55505904372556fd8cdfd1d2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.1/nvp_0.99.1_linux_arm64.tar.gz"
      sha256 "97664cb6d1e11cd8268650a367f4c00a92859ac88e8a17d603b97dfd89d91e55"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.1/nvp_0.99.1_linux_amd64.tar.gz"
      sha256 "d6feaf9a17cbea64e5bc8af1397435c899e679b74789e792611f63f2c2466210"
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
