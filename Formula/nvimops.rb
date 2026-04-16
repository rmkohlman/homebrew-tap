# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.100.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.0/nvp_0.100.0_darwin_arm64.tar.gz"
      sha256 "45d53cf485d980c87bda30139f6d6ce06b6a3c1c49ff323c8919c60ca72c36fc"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.0/nvp_0.100.0_darwin_amd64.tar.gz"
      sha256 "515fbdadfd5335d63edcab24ca67e6649877c1a599e3db35396824762543e2eb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.0/nvp_0.100.0_linux_arm64.tar.gz"
      sha256 "ce58e3cc87b719887419ba0f5265abb62b1f9f649743058dbfc7c39fc464ce10"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.100.0/nvp_0.100.0_linux_amd64.tar.gz"
      sha256 "097e7299d481bf7607a3e88ac912db849786bc5889e90c18ab91c889b70b5435"
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
