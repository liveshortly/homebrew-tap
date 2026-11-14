class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://github.com/liveshortly/live"
  version "2.4.1"

  # Prebuilt binaries from live-dist; no local Go toolchain is needed.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.1/live-v2.4.1-darwin-arm64.gz"
      sha256 "11241f86cbff1de864df679e8c835849c2855f1888ff005caa25658b41ead0e0"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.1/live-v2.4.1-darwin-amd64.gz"
      sha256 "a8c5e9a40ff24244893d943ca240275c86dea4f95c2e495a264c8cd2f7be8737"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.1/live-v2.4.1-linux-arm64.gz"
      sha256 "7e63bf46bc4cc0b2ccf3dce3a4960757b5e98120394004c10499885618726186"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.1/live-v2.4.1-linux-amd64.gz"
      sha256 "66fa1b1aa920c9e9f4d3057fc4860f29ad67c675744e3168b737f0bee2cad688"
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
