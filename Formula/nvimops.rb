# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.81.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.81.2/nvp_0.81.2_darwin_arm64.tar.gz"
      sha256 "ed81772eca0950c521cc69884cb3f9fb64802f931b612dfd978fe5a903304c9a"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.81.2/nvp_0.81.2_darwin_amd64.tar.gz"
      sha256 "455bf05183544aef565b882445607ee8f7c28e390bbf3602acf4cf84d28fccab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.81.2/nvp_0.81.2_linux_arm64.tar.gz"
      sha256 "b3c5db4d22d984c962be73cbe55deff6e0e9b74f0c646fa2a6af6b7e9469dbcc"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.81.2/nvp_0.81.2_linux_amd64.tar.gz"
      sha256 "6017ed7ac810d0b46eb54f5820b7f53630ff41ca6b7a4fbacb2d36b972cdc27c"
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
