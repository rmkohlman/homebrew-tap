# typed: false
# frozen_string_literal: true

class Terminalops < Formula
  desc "TerminalOps (dvt) - DevOps-style terminal configuration management"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.105.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.105.2/terminalops_0.105.2_darwin_arm64.tar.gz"
      sha256 "fd237f1d87e324e5f144d8ea46a82df08b399091a7426a6399841c6d122fd46e"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.105.2/terminalops_0.105.2_darwin_amd64.tar.gz"
      sha256 "e85005852abcd2dc681cddd8eeabacd354ea6f77c9533177db389609e7829dec"
    end
  end

  head "https://github.com/rmkohlman/devopsmaestro.git", branch: "main"

  depends_on "go" => :build if build.head?

  def install
    if build.head?
    # Sync migrations for dvt and nvp embedding before building
    system "sh", "-c", "if [ -d cmd/dvt/migrations ]; then rm -rf cmd/dvt/migrations; fi"
    system "cp", "-r", "db/migrations", "cmd/dvt/migrations"
    system "sh", "-c", "if [ -d cmd/nvp/migrations ]; then rm -rf cmd/nvp/migrations; fi"
    system "cp", "-r", "db/migrations", "cmd/nvp/migrations"
      system "go", "build",
             "-ldflags", "-s -w -X main.Version=HEAD -X main.Commit=#{`git rev-parse --short HEAD`.strip} -X main.BuildTime=#{Time.now.utc.iso8601}",
             "-o", bin/"dvt",
             "./cmd/dvt/"
      generate_completions_from_executable(bin/"dvt", "completion")
    else
      bin.install "dvt"
      bash_completion.install "completions/dvt.bash" => "dvt"
      zsh_completion.install "completions/_dvt"
      fish_completion.install "completions/dvt.fish"
    end
  end

  def caveats
    <<~EOS
      TerminalOps (dvt) - DevOps-style terminal configuration management

      Quick Start:
        dvt init                        # Initialize configuration directory
        dvt prompt library list         # Browse available prompts
        dvt prompt library install starship-default
        dvt plugin library list         # Browse available plugins
        dvt plugin library install zsh-autosuggestions zsh-syntax-highlighting
        dvt profile preset install default  # Install complete profile
        dvt profile generate default    # Generate config files

      Configuration stored in: ~/.dvt/
      Generated files written to stdout by default

      Documentation: https://github.com/rmkohlman/devopsmaestro#terminalops

      Shell completions have been installed for bash, zsh, and fish.
      Restart your shell or source your profile to enable them.
    EOS
  end

  test do
    assert_match "dvt", shell_output("#{bin}/dvt --help")
    assert_match version.to_s, shell_output("#{bin}/dvt version")
  end
end
