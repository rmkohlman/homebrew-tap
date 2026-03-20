# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.59.4"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.4/nvp_0.59.4_darwin_arm64.tar.gz"
      sha256 "a855f5069bf8c4480aaa287aaafdc0a5825b26c1fc38fa95505baf211ea69c15"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.4/nvp_0.59.4_darwin_amd64.tar.gz"
      sha256 "472dc89bc9ea893980909d0ed27fe874ab78347f015e08722be1038a9aa4a25f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.4/nvp_0.59.4_linux_arm64.tar.gz"
      sha256 "f50cdca931d391c6c3d0d4d7ea0908069cb1f093f3c69397370e0fb1c998f50b"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.4/nvp_0.59.4_linux_amd64.tar.gz"
      sha256 "b37596f25958a4d24aa599d5458bb26c508c04fc2fb3809866c636cc743fb412"
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
