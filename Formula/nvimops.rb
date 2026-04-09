# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.73.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.73.0/nvp_0.73.0_darwin_arm64.tar.gz"
      sha256 "bc137e8e5adf51d84e5907eeb19848edc49aa38181f8bb05321e5e9bc4c4a0c9"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.73.0/nvp_0.73.0_darwin_amd64.tar.gz"
      sha256 "ea09375ae487dd45ff124c8383a9a9ca39ed99530a9696a689cda633aa8ed225"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.73.0/nvp_0.73.0_linux_arm64.tar.gz"
      sha256 "14fdd91a47a4ccad6bfc2380135e34285c779f898402083fb149a4cfd9660187"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.73.0/nvp_0.73.0_linux_amd64.tar.gz"
      sha256 "1847e44da0719c1213a1212925d265a3b797f89fc39f7c4f0dad330619ec0af4"
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
