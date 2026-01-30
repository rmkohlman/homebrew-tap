# typed: false
# frozen_string_literal: true

class Devopsmaestro < Formula
  desc "DevOpsMaestro (dvm) - kubectl-style CLI for containerized dev environments"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.3.3"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.3.3/devopsmaestro_0.3.3_darwin_arm64.tar.gz"
      sha256 "b9d5117c5ab4cdff2e777907fd0f240e155a43c0e1b02d9767d934e5515f3a13"
    end
    # Note: darwin/amd64 not currently built - requires cross-compilation
    # on_intel do
    #   url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.3.3/devopsmaestro_0.3.3_darwin_amd64.tar.gz"
    #   sha256 "PLACEHOLDER_DARWIN_AMD64"
    # end
  end

  # Note: Linux builds not currently available - requires cross-compilation toolchains
  # on_linux do
  #   on_arm do
  #     url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.3.3/devopsmaestro_0.3.3_linux_arm64.tar.gz"
  #     sha256 "PLACEHOLDER_LINUX_ARM64"
  #   end
  #   on_intel do
  #     url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.3.3/devopsmaestro_0.3.3_linux_amd64.tar.gz"
  #     sha256 "PLACEHOLDER_LINUX_AMD64"
  #   end
  # end

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
      # Install binary from archive
      bin.install "dvm"

      # Install pre-generated completions from archive
      bash_completion.install "completions/dvm.bash" => "dvm"
      zsh_completion.install "completions/_dvm"
      fish_completion.install "completions/dvm.fish"
    end
  end

  def caveats
    <<~EOS
      To get started:
        dvm admin init
        dvm create project myproject --from-cwd

      Shell completions have been installed automatically for bash, zsh, and fish.
      Restart your shell or source your profile to enable them.
    EOS
  end

  test do
    assert_match "dvm", shell_output("#{bin}/dvm --help")
    assert_match version.to_s, shell_output("#{bin}/dvm version")
  end
end
