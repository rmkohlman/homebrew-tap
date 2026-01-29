# typed: false
# frozen_string_literal: true

class Dvm < Formula
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

  depends_on "go" => :build if build.head?

  def install
    if build.head?
      system "go", "build",
             "-ldflags", "-s -w -X main.Version=HEAD -X main.Commit=#{`git rev-parse --short HEAD`.strip} -X main.BuildTime=#{Time.now.utc.iso8601}",
             "-o", bin/"dvm",
             "."
    else
      if OS.mac?
        bin.install Hardware::CPU.arm? ? "dvm-darwin-arm64" => "dvm" : "dvm-darwin-amd64" => "dvm"
      elsif OS.linux?
        bin.install Hardware::CPU.arm? ? "dvm-linux-arm64" => "dvm" : "dvm-linux-amd64" => "dvm"
      end
    end

    generate_completions_from_executable(bin/"dvm", "completion")
  end

  def caveats
    <<~EOS
      To get started:
        dvm admin init
        dvm create project myproject --from-cwd

      Shell completions have been installed.
    EOS
  end

  test do
    assert_match "dvm", shell_output("#{bin}/dvm --help")
  end
end
