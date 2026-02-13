# typed: false
# frozen_string_literal: true

# NvimOps - DevOps-style Neovim plugin and theme manager
# Install with: brew install rmkohlman/tap/nvimops
# Binary name: nvp

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.8.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.8.1/nvp_0.8.1_darwin_arm64.tar.gz"
      sha256 "4c052f50945486e6270ac12622affa92b94d518609d0c3db3c963386e0384e52"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.8.1/nvp_0.8.1_darwin_amd64.tar.gz"
      sha256 "f43be4a5c7987ca49532503ea814274b4c343fc38a3f71a6c218b5ce0de142ae"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.8.1/nvp_0.8.1_linux_arm64.tar.gz"
      sha256 "6357bb851835ecd86dd0e8fcc923ccdab65d6dfbd1c801715bb4a0af1fa237f0"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.8.1/nvp_0.8.1_linux_amd64.tar.gz"
      sha256 "5c76d4680cb519ce432bd402bb1338369b1f29b74220a7f5ae73b22d006c2929"
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
