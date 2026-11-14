class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://github.com/liveshortly/live"
  version "2.4.4"

  # Prebuilt binaries from live-dist; no local Go toolchain is needed.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.4/live-v2.4.4-darwin-arm64.gz"
      sha256 "c63c6477cc1d7fc2e63360d3ab3fc94304b614fc2f0b78edf1b8a0b16da8d408"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.4/live-v2.4.4-darwin-amd64.gz"
      sha256 "469bbcf7de01827f405fcdf316ecf6efaec2d49c1534f792eb80c1419150c2b1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.4/live-v2.4.4-linux-arm64.gz"
      sha256 "0fe4d678d02236dcbb668e1d1d4a0b6f8bcf7005b85e0d0eaf7a11cdc8c4bf65"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.4/live-v2.4.4-linux-amd64.gz"
      sha256 "8f304fb8c8ff7fb828e2f6731e1ebda5b3f2b9bf5d4d14ccb76f633ee0783c27"
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
