# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.104.5"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.104.5/nvp_0.104.5_darwin_arm64.tar.gz"
      sha256 "846cdf20eb7905b7fadbc26a9211ab2a3bdaae6ef6662ad13a13f810521425b5"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.104.5/nvp_0.104.5_darwin_amd64.tar.gz"
      sha256 "e6e9590c7904a42a76f2e8deb0677e236b4fa7e5a21bea006317ad15fd4cacd8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.104.5/nvp_0.104.5_linux_arm64.tar.gz"
      sha256 "c82ba30897e3d05c66bccb473b3e99ad4538335a53a9184b289d40fceb837c17"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.104.5/nvp_0.104.5_linux_amd64.tar.gz"
      sha256 "fae2e6494afc682f735d89741f45e129021f2b3e03461c746346d528e2a6143e"
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
