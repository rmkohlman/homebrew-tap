# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.83.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.83.0/nvp_0.83.0_darwin_arm64.tar.gz"
      sha256 "421fa738956ce6e78dd4defdc0da191516fa6ad370d98e838e4ff2c298741fce"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.83.0/nvp_0.83.0_darwin_amd64.tar.gz"
      sha256 "a4ebeb329cc4389e6dd3c4b70cedbc3f6fb069652fc2eab23795da9163e8b378"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.83.0/nvp_0.83.0_linux_arm64.tar.gz"
      sha256 "dafc81dd6c5503fd57ab2449100cc4b27c28381a36ba0ec42d34d41fdcf1a9aa"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.83.0/nvp_0.83.0_linux_amd64.tar.gz"
      sha256 "b7238a3055136696182507a7f007fb90d34e0703f2feb53cb35b4cb8ab52fd7c"
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
