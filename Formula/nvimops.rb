# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.60.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.60.2/nvp_0.60.2_darwin_arm64.tar.gz"
      sha256 "ca62b083a9269cee3d671fc8403583b471113c0fc7305a0c8a86f4c08945d8f8"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.60.2/nvp_0.60.2_darwin_amd64.tar.gz"
      sha256 "370de78bc360f9dc6620f257d433276e014b42d3db1f6dcacdecd124f0e47943"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.60.2/nvp_0.60.2_linux_arm64.tar.gz"
      sha256 "f56b105cc243e68b9a4ed827cd21c7410ad97c8803e4157f9d9fed5ef0e3c921"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.60.2/nvp_0.60.2_linux_amd64.tar.gz"
      sha256 "7b42d99577a07fd3ef959184e8ba23ac1597f3e9cbbccbaecce2b24464f760aa"
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
