# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.100.3"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.3/nvp_0.100.3_darwin_arm64.tar.gz"
      sha256 "ea001a612d6028f163fb4bbf49ffd306f5956d7e8cb6e41cb6251962fb010f19"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.3/nvp_0.100.3_darwin_amd64.tar.gz"
      sha256 "46bf63911cde6c721b2d5fbe21b8dec400650b52046884339a7c3e88a06d138a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.3/nvp_0.100.3_linux_arm64.tar.gz"
      sha256 "6cb93c668a8a6eda625c6cc98fdac39661f5696c842c445a027d39f6b2b463c2"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.3/nvp_0.100.3_linux_amd64.tar.gz"
      sha256 "7ec1f3fe41cbf5875f9fbf9ab7fa6f320377c37ceffcac874672b090e336de0e"
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
