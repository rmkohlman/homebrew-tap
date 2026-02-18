# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.9.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.9.2/nvp_0.9.2_darwin_arm64.tar.gz"
      sha256 "d64180c95cdc783bb8b782c035235a6c400389dd0946bf5abe5cda6134589e82"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.9.2/nvp_0.9.2_darwin_amd64.tar.gz"
      sha256 "5a469f6484787a0a746a565e22f26e02ac5b6791cd95270bcc458043c30da50e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.9.2/nvp_0.9.2_linux_arm64.tar.gz"
      sha256 "d287c93a63211ba23d52300893baef8a0697155a94f023508205023ff789eeba"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.9.2/nvp_0.9.2_linux_amd64.tar.gz"
      sha256 "51b02012536138a6d5cd3ae6e713670768272048171b901af1399934088db036"
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
