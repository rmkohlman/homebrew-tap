# typed: false
# frozen_string_literal: true

class Nvp < Formula
  desc "nvp (NvimOps) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.5.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.5.0/nvp_0.5.0_darwin_arm64.tar.gz"
      sha256 "1e2a0edb36d24136de7395897816f62db78e94549005d6bdcc953a1ce7012d37"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.5.0/nvp_0.5.0_darwin_amd64.tar.gz"
      sha256 "542a5d3dc38badde8ae000b90023c66f558edc07e79b69eec06a63007a93c1e9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.5.0/nvp_0.5.0_linux_arm64.tar.gz"
      sha256 "52a2dc0a9ab71cfd602851b7ca4f9e6da15440b829db02874ad8e9cbcb908aa4"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.5.0/nvp_0.5.0_linux_amd64.tar.gz"
      sha256 "f6081acc47193cb29353c1afa1739f38cedd2ccd4d99919119423b29ec7ab964"
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
      # Install binary from archive
      bin.install "nvp"

      # Install pre-generated completions from archive
      bash_completion.install "completions/nvp.bash" => "nvp"
      zsh_completion.install "completions/_nvp"
      fish_completion.install "completions/nvp.fish"
    end
  end

  def caveats
    <<~EOS
      nvp (NvimOps) - DevOps-style Neovim plugin and theme manager

      To get started:
        nvp init                        # Initialize plugin store
        nvp library list                # Browse available plugins
        nvp library install telescope   # Install from library
        nvp theme library list          # Browse available themes
        nvp theme library install tokyonight-night --use
        nvp generate                    # Generate Lua files

      Generated files go to: ~/.config/nvim/lua/plugins/nvp/

      Shell completions have been installed for bash, zsh, and fish.
      Restart your shell or source your profile to enable them.
    EOS
  end

  test do
    assert_match "nvp", shell_output("#{bin}/nvp --help")
    assert_match version.to_s, shell_output("#{bin}/nvp version")
  end
end
