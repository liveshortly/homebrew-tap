class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://github.com/liveshortly/live"
  version "2.4.5"

  # Prebuilt binaries from live-dist; no local Go toolchain is needed.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.5/live-v2.4.5-darwin-arm64.gz"
      sha256 "564ae33253a6786ddf3841de196167ca4a38e3c495976759247f16c954411dfc"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.5/live-v2.4.5-darwin-amd64.gz"
      sha256 "2be4e6f82cf63b024f44fdf4d8daa523451aee3184432896f2f91d20bb2b9584"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.5/live-v2.4.5-linux-arm64.gz"
      sha256 "543f5cd055a7021c4a567af1826b40cf3e0f7b20dacf8a3d068ad3acb1e6227d"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.5/live-v2.4.5-linux-amd64.gz"
      sha256 "3c3b38fa8503fbf3a6e94ec1a1c573e4bbab7f2302087804d778748e6c2c1db6"
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
