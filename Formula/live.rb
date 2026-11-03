class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://github.com/liveshortly/live"
  version "2.3.4"

  # Prebuilt binaries from live-dist; no local Go toolchain is needed.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.4/live-v2.3.4-darwin-arm64.gz"
      sha256 "7fa03e9aec447d51bb2502f88dbe53e62a09e57347943269d032f75ef8886368"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.4/live-v2.3.4-darwin-amd64.gz"
      sha256 "363dd5a49d890f599fe87c51e0db70f926a8682045dad826a61abc16314b8f1f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.4/live-v2.3.4-linux-arm64.gz"
      sha256 "3808aec2d9c3a922320bce336a869c95a20dfbaec36fd2b7fd36b9565c88831c"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.4/live-v2.3.4-linux-amd64.gz"
      sha256 "24fc2ee5a621fbe183bc0bf191611e63d559d76c4769108a5582d695c8069acf"
    end
  end

  head do
    url "https://github.com/liveshortly/live.git", branch: "main", using: :git
    depends_on "go" => :build
  end

  def install
    if build.head?
      system "go", "build", "-ldflags", "-X main.version=head", "-o", bin/"live", "./cmd/live"
    else
      # A bare .gz unpacks to the archive name minus the extension.
      bin.install Dir["live-*"].first => "live"
    end
  end

  def caveats
    <<~EOS
      Configure your self-hosted server before signing in:
        https://github.com/liveshortly/live#choose-your-server
        live login
      Then stream an agent to that server:
        live claude
    EOS
  end

  test do
    # The binary stamps a leading "v": `live v1.0.1`.
    assert_match "live v#{version}", shell_output("#{bin}/live version")
  end
end
