# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.83.4"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.83.4/nvp_0.83.4_darwin_arm64.tar.gz"
      sha256 "afd46d5060b206b6c46afee63551c018b1da37cbeb75292c916bc6c7d44729ed"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.83.4/nvp_0.83.4_darwin_amd64.tar.gz"
      sha256 "6bf0b45fe9cbd874671008a59db524e7952f99ff197d770dcdf6f174e85af5b7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.83.4/nvp_0.83.4_linux_arm64.tar.gz"
      sha256 "0a6a2a65f6e44f25a8924646b41438e9a41458f471af4a8febba51d7cb993c43"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.83.4/nvp_0.83.4_linux_amd64.tar.gz"
      sha256 "76d4c7599a50a305afb4ec0bd9b839b6304b06fcfee5a7005a4b9fba0402648c"
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
