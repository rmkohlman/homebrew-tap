# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.33.3"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.33.3/nvp_0.33.3_darwin_arm64.tar.gz"
      sha256 "f132cf45de7b210e6ddc118d450470c0521a8a1433b499a2f9e5152655332a6b"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.33.3/nvp_0.33.3_darwin_amd64.tar.gz"
      sha256 "b5f831ecb8d9a3c591b44aa82c503f8ad3b8b3b973fdb631060c1c5afacdb9a2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.33.3/nvp_0.33.3_linux_arm64.tar.gz"
      sha256 "9a931120894f89e6eeb2ced6875a0151804605fe61bbd07af94c8a9df5d40526"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.33.3/nvp_0.33.3_linux_amd64.tar.gz"
      sha256 "5998027facb03ddc600df339a1040539851f125e17a7c3eb52607738b552094d"
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
