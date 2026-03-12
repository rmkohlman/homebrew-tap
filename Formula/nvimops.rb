# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.35.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.35.2/nvp_0.35.2_darwin_arm64.tar.gz"
      sha256 "f4ba9057b99111f97f7a90002617c6a27361c11670ff504abff0439420db8143"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.35.2/nvp_0.35.2_darwin_amd64.tar.gz"
      sha256 "9ada31ac0c2143513635f152d958b8e1bf870fc3d96b5ec9e978b32d927aec82"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.35.2/nvp_0.35.2_linux_arm64.tar.gz"
      sha256 "71b4a4fdf8c40e6ba2084effea18b6d830dee3da4e1ef0b956033629c49cb748"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.35.2/nvp_0.35.2_linux_amd64.tar.gz"
      sha256 "fbdc5443d2bcfe84793cb92b5a474d848c83d24f3871bed5fb0bc67f46fd3f66"
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
