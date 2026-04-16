# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.100.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.2/nvp_0.100.2_darwin_arm64.tar.gz"
      sha256 "0dd89b6031c79c71ea68995f8de02f64a6643ec825ba052a2608ef7ec6616293"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.2/nvp_0.100.2_darwin_amd64.tar.gz"
      sha256 "ff639e6507aef50b14d85e72ba5b7bd34629b1633d464440c773401c73c2b209"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.2/nvp_0.100.2_linux_arm64.tar.gz"
      sha256 "cfc50cbf7f4ede95313d9ad670fc356b7edae0232fec1516731d26bda3319f68"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.2/nvp_0.100.2_linux_amd64.tar.gz"
      sha256 "f0bd5584e1a46bdcf2c185193b1dedec7350e5e3bf54cee4e5591eaa2ccd9c81"
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
