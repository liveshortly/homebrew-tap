class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://github.com/liveshortly/live"
  version "2.4.3"

  # Prebuilt binaries from live-dist; no local Go toolchain is needed.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.3/live-v2.4.3-darwin-arm64.gz"
      sha256 "09cb5da3b833c0996e3a6214a4e155ec7a42a2116e32a416d5153a0c7413e65f"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.3/live-v2.4.3-darwin-amd64.gz"
      sha256 "51b1fb9f60e429702137110de62c9d1aee9953b5e10e45a1aac0c0a56521d505"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.3/live-v2.4.3-linux-arm64.gz"
      sha256 "e0322254d38fdadf228ff33c162851475c5c7bc62366ba2ff310c759a533fbc8"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.3/live-v2.4.3-linux-amd64.gz"
      sha256 "a356bd808498639257bd3cae1d6c1d0fcea6e616b8c9e97d60b249fb6e3f637d"
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
