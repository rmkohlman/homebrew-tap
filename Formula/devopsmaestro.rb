# typed: false
# frozen_string_literal: true

class Devopsmaestro < Formula
  desc "DevOpsMaestro (dvm) - kubectl-style CLI for containerized dev environments"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.32.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.0/devopsmaestro_0.32.0_darwin_arm64.tar.gz"
      sha256 "728c015e9c153972cf0c9873b20d5b3f1d3bc9d0c51893b98b6d24f020dd6d13"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.32.0/devopsmaestro_0.32.0_darwin_amd64.tar.gz"
      sha256 "c8cf46b1dd59a737c6da37355050f42948baa753f156d44f73fc01bec1052902"
    end
  end

  head "https://github.com/rmkohlman/devopsmaestro.git", branch: "main"

  conflicts_with "dvm", because: "both install the dvm binary"

  depends_on "go" => :build if build.head?

  def install
    if build.head?
      system "go", "build",
             "-ldflags", "-s -w -X main.Version=HEAD -X main.Commit=#{`git rev-parse --short HEAD`.strip} -X main.BuildTime=#{Time.now.utc.iso8601}",
             "-o", bin/"dvm",
             "."
      generate_completions_from_executable(bin/"dvm", "completion")
    else
      bin.install "dvm"
      bash_completion.install "completions/dvm.bash" => "dvm"
      zsh_completion.install "completions/_dvm"
      fish_completion.install "completions/dvm.fish"
    end
  end

  def caveats
    <<~EOS
      To get started:
        dvm admin init
        dvm create app myapp --from-cwd

      Shell completions have been installed automatically for bash, zsh, and fish.
      Restart your shell or source your profile to enable them.
    EOS
  end

  test do
    assert_match "dvm", shell_output("#{bin}/dvm --help")
    assert_match version.to_s, shell_output("#{bin}/dvm version")
  end
end
