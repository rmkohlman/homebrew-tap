# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.24.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.24.0/nvp_0.24.0_darwin_arm64.tar.gz"
      sha256 "fb7b0926a33b6032e5bf0441d5f1fc51925593c7de45dad80c569287422943b6"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.24.0/nvp_0.24.0_darwin_amd64.tar.gz"
      sha256 "0774198d6123f1bb90cf2d3ff0b1396cf84448d9205d2c1e4c55bb41630e6258"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.24.0/nvp_0.24.0_linux_arm64.tar.gz"
      sha256 "30689be1e9f8a0480bc3d8b68cf3560bae6d7ef93cf58c5fe36de6d2309f6e87"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.24.0/nvp_0.24.0_linux_amd64.tar.gz"
      sha256 "2a7045bf8a53ea8668c1d36c61d4b6ddbe22a93715c57f8f80cef135e5b3c9c0"
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
