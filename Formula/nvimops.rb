# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.13.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.13.0/nvp_0.13.0_darwin_arm64.tar.gz"
      sha256 "6680a71019f7a6abe7144bc2161e1d8c55c26afaa97f3b66cd7aa1fabd26baa6"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.13.0/nvp_0.13.0_darwin_amd64.tar.gz"
      sha256 "de39dcd07642d720b93bfc75c95da688a1210cec8f928208a1e4cc9f26559a73"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.13.0/nvp_0.13.0_linux_arm64.tar.gz"
      sha256 "f95d3fdaa571039e79ec12d22cc4c48f868b38652e78dcec9a44818d36bf8d24"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.13.0/nvp_0.13.0_linux_amd64.tar.gz"
      sha256 "9cbdf65ec33e53b1cba3340d4a698a049cec41f1cae43b0ed0c097ec18b63d42"
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
