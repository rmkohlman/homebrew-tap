# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.12.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.12.1/nvp_0.12.1_darwin_arm64.tar.gz"
      sha256 "5855a1706a060869085aa854a6c330666b629b00a9b91f5dc8c65a1f9b758991"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.12.1/nvp_0.12.1_darwin_amd64.tar.gz"
      sha256 "de02ae19a9a3a5fa67f58dc79c9470ef907b8743c1237dc95bc88e8f7723448d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.12.1/nvp_0.12.1_linux_arm64.tar.gz"
      sha256 "b92919752a15a3b0c8f1d4b82948a216d6eeb25954c414a4df4d63a50e355c8c"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.12.1/nvp_0.12.1_linux_amd64.tar.gz"
      sha256 "6b5a80f9d3bbd53b84a5bdfe03ef2a7ebe6ebb1ab626aadae9bdada48d3b30d8"
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
