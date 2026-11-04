class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://github.com/liveshortly/live"
  version "2.4.0"

  # Prebuilt binaries from live-dist; no local Go toolchain is needed.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.0/live-v2.4.0-darwin-arm64.gz"
      sha256 "b416df7248a9f77b1f39425fc33093a93f56ae47ac923e24379975a3fa309a52"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.0/live-v2.4.0-darwin-amd64.gz"
      sha256 "40f3a3becf3cbca13b9449b8736742aaa1e3bb8576ee9fd19c00b16efdbbe211"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.0/live-v2.4.0-linux-arm64.gz"
      sha256 "ed3fdeca242c4b578643b304de3995b3bd75e9c0b8eaa3687456b107345c7aa9"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.0/live-v2.4.0-linux-amd64.gz"
      sha256 "5dc5102f8f5e29bb97e3dfefe142a69b63623db5ddb8963778b758f36ff581d0"
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
