# typed: false
# frozen_string_literal: true

class Devopsmaestro < Formula
  desc "DevOpsMaestro (dvm) - kubectl-style CLI for containerized dev environments"
  homepage "https://github.com/rmkohlman/devopsmaestro"
  version "0.87.4"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.87.4/devopsmaestro_0.87.4_darwin_arm64.tar.gz"
      sha256 "45934702842f4e91243eb2a0f29b42f8d8d10be043b2925a081335a20fbbda3a"
    end
    on_intel do
      url "https://github.com/rmkohlman/devopsmaestro/releases/download/v0.87.4/devopsmaestro_0.87.4_darwin_amd64.tar.gz"
      sha256 "104e595e682f0896076921bee153c01a90aa7d5ee8c367a9107a6508c34e8e92"
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
