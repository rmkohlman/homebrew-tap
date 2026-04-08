# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.71.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.71.0/nvp_0.71.0_darwin_arm64.tar.gz"
      sha256 "c93c132606dfb9e53c0d00524327e62c93f1155edc256e35075469419337de54"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.71.0/nvp_0.71.0_darwin_amd64.tar.gz"
      sha256 "4e6a8671c3a756c01af85ea4a61296de4e771ec01ea4a59a85117d1817009907"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.71.0/nvp_0.71.0_linux_arm64.tar.gz"
      sha256 "38ff4bbcb55f86c32571fd7450d28b790900fe0a4de5ea3d6b3b9177151c15bf"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.71.0/nvp_0.71.0_linux_amd64.tar.gz"
      sha256 "ff77e113d8b9f38dcfd624cc42797f18baf35ccd002b3d46b313d76e35381d0b"
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
