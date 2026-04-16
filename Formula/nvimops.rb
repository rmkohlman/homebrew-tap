# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.101.3"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.3/nvp_0.101.3_darwin_arm64.tar.gz"
      sha256 "07f63742066431f9ec8d8deab650e2e2d7ca87bbc4ac328f04579ac90b6c44ae"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.3/nvp_0.101.3_darwin_amd64.tar.gz"
      sha256 "f4783dfa86506d8e65b55abab15f5761044e08422c6dd569212b1ea1134c3b0b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.3/nvp_0.101.3_linux_arm64.tar.gz"
      sha256 "0d812ac9b0a3c534060a1d41d727d629016935ea2820501567d73d2fd1329a99"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.101.3/nvp_0.101.3_linux_amd64.tar.gz"
      sha256 "8dc85f82f82c613afe406e2a988279a782ebda8b5d659658851f61ff1297130b"
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
