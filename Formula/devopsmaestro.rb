# typed: false
# frozen_string_literal: true

class Devopsmaestro < Formula
  desc "DevOpsMaestro (dvm) - kubectl-style CLI for containerized dev environments"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.3.2"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.3.2/dvm-darwin-arm64"
      sha256 "69ff95ecad57ae0f30ea48291caa7df627824fe01c26516e043f7edd62ad08f8"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.3.2/dvm-darwin-amd64"
      sha256 "61c84b28926f83125a9fb435874511f64e1254157b32ef9d580508636357892e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.3.2/dvm-linux-arm64"
      sha256 "1b71d9800e40b17989055f316dad5ddad4ee7d3e7f142d9252242f293934f2ca"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.3.2/dvm-linux-amd64"
      sha256 "e70869cfae8f77ebe2bf43920fd12354927ac13db2decb57c7a3cb31d779f27f"
    end
  end

  head "https://github.com/rmkohlman/devopsmaestro.git", branch: "main"

  # Both formulas install the same 'dvm' binary
  conflicts_with "dvm", because: "both install the dvm binary"

  depends_on "go" => :build if build.head?

  def install
    if build.head?
      system "go", "build",
             "-ldflags", "-s -w -X main.Version=HEAD -X main.Commit=#{`git rev-parse --short HEAD`.strip} -X main.BuildTime=#{Time.now.utc.iso8601}",
             "-o", bin/"dvm",
             "."
      # Generate completions when building from source (not sandboxed)
      generate_completions_from_executable(bin/"dvm", "completion")
    else
      if OS.mac?
        if Hardware::CPU.arm?
          bin.install "dvm-darwin-arm64" => "dvm"
        else
          bin.install "dvm-darwin-amd64" => "dvm"
        end
      elsif OS.linux?
        if Hardware::CPU.arm?
          bin.install "dvm-linux-arm64" => "dvm"
        else
          bin.install "dvm-linux-amd64" => "dvm"
        end
      end
      # Note: Shell completions cannot be auto-generated for pre-built binaries
      # due to macOS sandbox restrictions. Users should generate them manually.
    end
  end

  def caveats
    <<~EOS
      To get started:
        dvm admin init
        dvm create project myproject --from-cwd

      Shell completions (recommended):
        # Zsh (add to ~/.zshrc or run once)
        dvm completion zsh > #{HOMEBREW_PREFIX}/share/zsh/site-functions/_dvm

        # Bash
        dvm completion bash > #{HOMEBREW_PREFIX}/etc/bash_completion.d/dvm

        # Fish
        dvm completion fish > ~/.config/fish/completions/dvm.fish
    EOS
  end

  test do
    assert_match "dvm", shell_output("#{bin}/dvm --help")
    assert_match version.to_s, shell_output("#{bin}/dvm version")
  end
end
