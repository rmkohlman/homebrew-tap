# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.15.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.15.1/nvp_0.15.1_darwin_arm64.tar.gz"
      sha256 "1d6f5fbbcae3c44b62fa959ac70b5d781f25fefee90e483536ed544773720038"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.15.1/nvp_0.15.1_darwin_amd64.tar.gz"
      sha256 "a193390f2cab3a306e7119cf71e7461e943ef0b2265a630e1d6ef29c945a0736"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.15.1/nvp_0.15.1_linux_arm64.tar.gz"
      sha256 "23deee9d3ef108095855457e68eba4c641c8aba9796655e718c045cc8f31e555"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.15.1/nvp_0.15.1_linux_amd64.tar.gz"
      sha256 "2376da570daa34b7b4096b75b7e3dd6f47caebdc08086072939dadbf07df1362"
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
