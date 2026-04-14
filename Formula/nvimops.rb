# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.90.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.90.1/nvp_0.90.1_darwin_arm64.tar.gz"
      sha256 "9b2910394b839850e64fe05d5c9f146eecf031579ee255c47fb98757afaaf2df"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.90.1/nvp_0.90.1_darwin_amd64.tar.gz"
      sha256 "13f438547c3e33aab9231a0ae94ffc7ab9873e5deaa98f32e5fae6e281300fd7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.90.1/nvp_0.90.1_linux_arm64.tar.gz"
      sha256 "721f87c80088409d90bc0913bd5beea7ab62a877c78786cf9599fa6370e1f77f"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.90.1/nvp_0.90.1_linux_amd64.tar.gz"
      sha256 "1392036fb9fa2f95ca6923ac7387dfc62b7f70d748668770bfa764757a52f666"
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
