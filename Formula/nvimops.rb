# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.60.6"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.60.6/nvp_0.60.6_darwin_arm64.tar.gz"
      sha256 "db25c1ff1b5f723041b8b519d717d3124112540539cfd74de4db3424eeb9da39"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.60.6/nvp_0.60.6_darwin_amd64.tar.gz"
      sha256 "904311ac26cedb84239710e9eb2a90267a063ee5f9d4932693adb8e057e80c07"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.60.6/nvp_0.60.6_linux_arm64.tar.gz"
      sha256 "b710c6e3c8164d78fbe5b90035879fa8c5b751d00e338e02b20cd0ac485f12ba"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.60.6/nvp_0.60.6_linux_amd64.tar.gz"
      sha256 "bb16144c6522bf03dcac65066665ec24d77546f6dc92562930888d611d50192a"
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
