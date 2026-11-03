class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://github.com/liveshortly/live"
  version "2.3.6"

  # Prebuilt binaries from live-dist; no local Go toolchain is needed.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.6/live-v2.3.6-darwin-arm64.gz"
      sha256 "4d12bf7a50b5122340c1549fc77579db8c6452ace83fd112b02bc4713c4c0adc"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.6/live-v2.3.6-darwin-amd64.gz"
      sha256 "ca44a87dc38187abb793d9b6ff0ba3ccf63cce4d40336fb6dfc6af8613a22ae0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.6/live-v2.3.6-linux-arm64.gz"
      sha256 "d0d4518f23a2d8431fe532f48ec0ef33cb9ed3754b249633f51150d87b0f7d0a"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.6/live-v2.3.6-linux-amd64.gz"
      sha256 "8dab381e34a3bc6d045cedcaba0286a31a110e2f791e1d1586b9693137af2302"
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
