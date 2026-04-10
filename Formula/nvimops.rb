# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.79.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.79.1/nvp_0.79.1_darwin_arm64.tar.gz"
      sha256 "e4eab182595c5599c7b3863033cb6a661a846f7c8e638d0a726d4c0704a7cab9"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.79.1/nvp_0.79.1_darwin_amd64.tar.gz"
      sha256 "92a8c902a76248787f3e95e865359d6397d645f5e1630448a46dea19376e2bbe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.79.1/nvp_0.79.1_linux_arm64.tar.gz"
      sha256 "ffebe18d9a59f58de8104d347339beff0a1a68dc0351bb42db5b72fc67e2d2b8"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.79.1/nvp_0.79.1_linux_amd64.tar.gz"
      sha256 "41ce5f296677d3300f7fafc0d48d728a2fe908be1bd4c021e5ae3dba96ec4ced"
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
