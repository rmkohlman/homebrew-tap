# typed: false
# frozen_string_literal: true

class Nvimops < Formula
  desc "NvimOps (nvp) - DevOps-style Neovim plugin and theme manager"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.88.1"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.88.1/nvp_0.88.1_darwin_arm64.tar.gz"
      sha256 "8bcd058a7afd91a7181a9e9e93c16138ae875d412a3823dd523f0316fc4f1c47"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.88.1/nvp_0.88.1_darwin_amd64.tar.gz"
      sha256 "ee0d5b9610919f3d9f8fb56b014d959550333ef59cac73250ece30b30d922676"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.88.1/nvp_0.88.1_linux_arm64.tar.gz"
      sha256 "01fd1d7d9f86d52e10d5a9911573db97067eb02fdad9267ec32c5f6ef2a7283c"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.88.1/nvp_0.88.1_linux_amd64.tar.gz"
      sha256 "052c7b3db1745d790f5e31d367497542bb26720a2cb883d300bcf0c0536b0e6c"
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
