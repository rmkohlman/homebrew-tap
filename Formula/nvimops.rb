# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.105.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.105.0/nvp_0.105.0_darwin_arm64.tar.gz"
      sha256 "24e0b69282ea124a9a07d0c2d58175f280ad5bfee3c66c7ea8db20af138f04de"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.105.0/nvp_0.105.0_darwin_amd64.tar.gz"
      sha256 "8aab573d059b11b1269b2fa5420f5e5a4f68f8e3cb098e3c67a69c8e620c3993"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.105.0/nvp_0.105.0_linux_arm64.tar.gz"
      sha256 "99290545d4f3071154b5125e99b766d9d29d797d969ab8fb42147dbf13b901bf"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.105.0/nvp_0.105.0_linux_amd64.tar.gz"
      sha256 "1e11a699b7f39296bdc39468fcec2d7c02678987a73a0f3be3c296d588333c10"
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
