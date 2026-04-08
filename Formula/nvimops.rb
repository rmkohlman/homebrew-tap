# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.72.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.72.0/nvp_0.72.0_darwin_arm64.tar.gz"
      sha256 "b15edfdc5aab8baafa283ec1f41d071c4c83d528ad2eb96ebda105dacbde3315"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.72.0/nvp_0.72.0_darwin_amd64.tar.gz"
      sha256 "913b6ba8655fd1549bbb1fa85cd4b00ab33b2d2272673f3277e9a67c0b790b7f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.72.0/nvp_0.72.0_linux_arm64.tar.gz"
      sha256 "bad8790a55db3baefb49af568d309300a9fa7f5c00411674c1733ad2998f3150"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.72.0/nvp_0.72.0_linux_amd64.tar.gz"
      sha256 "2397301bef147dc7bfad09f7e31cc63df161c924cb3cba3217b062452da776e9"
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
