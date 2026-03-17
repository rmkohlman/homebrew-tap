# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.45.3"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.45.3/nvp_0.45.3_darwin_arm64.tar.gz"
      sha256 "239bde0a122fb77dbb440096345f8c1f7b50f4fc05c9adefaf26c5b260cd40fb"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.45.3/nvp_0.45.3_darwin_amd64.tar.gz"
      sha256 "4cea4244c4dbf6b86014fda49a1ec1e0c1298a7ecd824cfd3b539e927b35677d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.45.3/nvp_0.45.3_linux_arm64.tar.gz"
      sha256 "528f0c4318a211389a4f0d34f6fc17e72fc4a034b34439d30ade639a5d555682"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.45.3/nvp_0.45.3_linux_amd64.tar.gz"
      sha256 "28a54feec7b05a18b9529baa333bfbe8d6222d76d8c3b82520220b4b10bd1010"
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
