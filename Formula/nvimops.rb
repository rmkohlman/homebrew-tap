# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.23.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.23.0/nvp_0.23.0_darwin_arm64.tar.gz"
      sha256 "c4257be000b086495d655efb460d26aef4f0d5c3d3d4466fb9e91b7c031fa953"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.23.0/nvp_0.23.0_darwin_amd64.tar.gz"
      sha256 "7e3f09685498319246c70bc38e61f25a96492b9009b3145be837bc6dff583f34"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.23.0/nvp_0.23.0_linux_arm64.tar.gz"
      sha256 "882ffd2f3af344cc43278866045d7b9576c9f34b940f68ebeaf4f0d0683ef424"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.23.0/nvp_0.23.0_linux_amd64.tar.gz"
      sha256 "618efecce971934d87f607bb6abb406da144a56aef791dcbc1977d6e74f8c911"
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
