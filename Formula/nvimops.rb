# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.60.3"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.60.3/nvp_0.60.3_darwin_arm64.tar.gz"
      sha256 "5eb1fd1973c853bfaac8a9ebefa606bd9b11521bab48d697adbfc3850eb54b70"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.60.3/nvp_0.60.3_darwin_amd64.tar.gz"
      sha256 "a52bed7772082e83f950bccb21c9383de7dc655636d49228eabd491539949f1e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.60.3/nvp_0.60.3_linux_arm64.tar.gz"
      sha256 "f8cced3c4084c18ef412f17a7604205aeeb25295f000e901175adafe116abff9"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.60.3/nvp_0.60.3_linux_amd64.tar.gz"
      sha256 "e6bb28af2ff49247c07bcdc3d1391e2136d78c831d8ad8bd0c6991c146c58919"
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
