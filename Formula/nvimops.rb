# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.34.3"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.34.3/nvp_0.34.3_darwin_arm64.tar.gz"
      sha256 "960ca1c2126713f2e8b072f3cc3f4205702cea7b9d59675d4c1d76eb167da965"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.34.3/nvp_0.34.3_darwin_amd64.tar.gz"
      sha256 "40b009f4ade8a17526ace8988e547e77a9a47e73f2d0aa3441f20a971185c3d0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.34.3/nvp_0.34.3_linux_arm64.tar.gz"
      sha256 "df114b060558c2b256bf676dc0a8875733a4b2ca013ae3361410766456b082f9"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.34.3/nvp_0.34.3_linux_amd64.tar.gz"
      sha256 "79c82de3ab981362f11b30d8484c7db14fe9f4762bb85f4d1fa101777ed30068"
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
