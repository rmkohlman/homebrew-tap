# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.101.7"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.7/nvp_0.101.7_darwin_arm64.tar.gz"
      sha256 "f0403c76476ded5aa24cc65dc371135bc516bd84aa8b2bbb4cb7220aa93e9506"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.7/nvp_0.101.7_darwin_amd64.tar.gz"
      sha256 "43e5204fc5981e014deee14a5d14aeb1833baaf41520e7b5cf53fbe33c4d9e8d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.7/nvp_0.101.7_linux_arm64.tar.gz"
      sha256 "2834a4fcf8ce8bf253d7438604c704cd2bd53a641b1b0ca5da9a833bbd3f3197"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.7/nvp_0.101.7_linux_amd64.tar.gz"
      sha256 "e7c893a091170bf9905dc6e5b412b85531c30447e29b0061c0ecd5a19cf6fad8"
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
