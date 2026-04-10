# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.82.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.82.2/nvp_0.82.2_darwin_arm64.tar.gz"
      sha256 "a6f4727dc33ba9c8f280daa78829fec1e7893a032db905a673c18895efa0f0e1"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.82.2/nvp_0.82.2_darwin_amd64.tar.gz"
      sha256 "dcae5c90790cbd57f031599ff9602f2e9bd3c708516c9d822a8b1840970ecc7a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.82.2/nvp_0.82.2_linux_arm64.tar.gz"
      sha256 "58c0894140c48522f4c95063873b14d9ba085e6a13d6a10a38de07ec1c757ace"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.82.2/nvp_0.82.2_linux_amd64.tar.gz"
      sha256 "c0f28a6a1b10b757a4a3abcaf18e6d7e6bd34ce13c0e8d588716f9ac64236d92"
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
