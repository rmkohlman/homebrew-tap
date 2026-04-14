# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.91.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.91.0/nvp_0.91.0_darwin_arm64.tar.gz"
      sha256 "aedb6e8569d45b756415fa150402ecadfcaec8c1ac548f9326b337155770a507"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.91.0/nvp_0.91.0_darwin_amd64.tar.gz"
      sha256 "b65e6aa710ef751754e39ae68bd3471680f79106ae92fb1420c58f224ee640b5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.91.0/nvp_0.91.0_linux_arm64.tar.gz"
      sha256 "72db7efb872aded55052fc06a25af3a72a8aa98d9979e17980d6edfdf2c37f15"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.91.0/nvp_0.91.0_linux_amd64.tar.gz"
      sha256 "29735bc6aaa1462149aa10b7fdee26c374d31cdbc9a27c187e0cbb3eea2bb8a4"
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
