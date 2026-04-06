# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.59.21"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.21/nvp_0.59.21_darwin_arm64.tar.gz"
      sha256 "002cbc6aead77907c0e29f09155a0d9ee7218b803090e35d0116681d48491da0"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.21/nvp_0.59.21_darwin_amd64.tar.gz"
      sha256 "6ea11861c9abc6489ab063a75d5f4e7732acde5c1b8237c105dd45cb25598ebf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.21/nvp_0.59.21_linux_arm64.tar.gz"
      sha256 "bbe4fc95aaa417f69541a48b107ef6d7bd3429d5bea8fa5181ef59ced84c5305"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.59.21/nvp_0.59.21_linux_amd64.tar.gz"
      sha256 "d95f8c3c90814bf4e40a4266ead81a4773fcdf78838c5d76b545c9089e138112"
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
