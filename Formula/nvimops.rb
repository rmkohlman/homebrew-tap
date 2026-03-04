# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.32.5"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.5/nvp_0.32.5_darwin_arm64.tar.gz"
      sha256 "d9f8b9c4a7d32eab9e5bf5c2c260ab32652212818f4acebd24e14ee1e99c8d44"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.5/nvp_0.32.5_darwin_amd64.tar.gz"
      sha256 "ca31a081201f3dad69af0cb217bc7490764a22d8fa7bdb2613b34f81789ea29b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.5/nvp_0.32.5_linux_arm64.tar.gz"
      sha256 "c3baeb510dbf774db8a7d1e476d580896037754d527d054e1297715def491e55"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.5/nvp_0.32.5_linux_amd64.tar.gz"
      sha256 "4724f0d75b45764a1aa083a09dad51d63b52751e8fcd25929d3f9381c0808633"
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
