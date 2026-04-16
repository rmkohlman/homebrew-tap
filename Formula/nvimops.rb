# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.99.4"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.4/nvp_0.99.4_darwin_arm64.tar.gz"
      sha256 "1e52fe2c40cee4a948517a82a8d8423d229bc247ec4811e41d273fcbfaf1b5d7"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.4/nvp_0.99.4_darwin_amd64.tar.gz"
      sha256 "fe62b9ef7d4313ca7fbb22f378cda1542fcee981cdc7ca3c970b313f60037399"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.4/nvp_0.99.4_linux_arm64.tar.gz"
      sha256 "359d908f359d37169c74d0c2516286c20d4b8c20cb40ef1656dc09c68fc31e38"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.99.4/nvp_0.99.4_linux_amd64.tar.gz"
      sha256 "e3dd81f7bb4980a994a3fbe938f51c7591fdb7c20022364f7a08796a1dec4942"
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
