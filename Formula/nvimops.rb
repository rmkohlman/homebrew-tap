# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.105.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.105.2/nvp_0.105.2_darwin_arm64.tar.gz"
      sha256 "5caf58883ab65c83359e2b3d0846b69847e41b8cbbc1190a32458cf20c11bf82"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.105.2/nvp_0.105.2_darwin_amd64.tar.gz"
      sha256 "8914c863294eb5a4045b78345bb327ab2115cb9fc4a8a5a8f8df52812b07d79c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.105.2/nvp_0.105.2_linux_arm64.tar.gz"
      sha256 "60b64ec9800eabb9eb590010277b5bf12e70a300f9a8a536bc30db49e8ccde20"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.105.2/nvp_0.105.2_linux_amd64.tar.gz"
      sha256 "9b5f6e1aacc40e1de81b4a81b7476ec2cdc7b8e7bcded6aa1bca77e149669a5e"
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
