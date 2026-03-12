# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.39.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.39.1/nvp_0.39.1_darwin_arm64.tar.gz"
      sha256 "0b5dc3fc40f218f0729d5588faf0df7ce43ae19218e0ac2c87f1f82f7c43ae96"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.39.1/nvp_0.39.1_darwin_amd64.tar.gz"
      sha256 "98646db2e94bc4f11a4ce1de807c9328cc608b2ce2ac317820c10ac14bdb12da"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.39.1/nvp_0.39.1_linux_arm64.tar.gz"
      sha256 "6be5ca6e3d78b44df7857ab45c1a110ea9a3964a8ada2caaeb668179ab447c75"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.39.1/nvp_0.39.1_linux_amd64.tar.gz"
      sha256 "5eba66b2a519a0c24da5dfd1c2161e10a9c19894e2cefa99a6e78fb8562bdc3b"
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
