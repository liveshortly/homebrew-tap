class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://github.com/liveshortly/live"
  version "2.3.5"

  # Prebuilt binaries from live-dist; no local Go toolchain is needed.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.5/live-v2.3.5-darwin-arm64.gz"
      sha256 "ab436367348a6f6330a5f5bf2159fcc4375082fc9901fc917ec45e4d56f39e8c"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.5/live-v2.3.5-darwin-amd64.gz"
      sha256 "0d99fb0b657d6b78a5c770f5d42069749db1986ef04424a2015c45671e1c4a0f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.5/live-v2.3.5-linux-arm64.gz"
      sha256 "83e35ac91f38368845c6b15766bbd7ba5083cbc799b0bf2f32a421caab8c65b0"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.5/live-v2.3.5-linux-amd64.gz"
      sha256 "5996f5f0e209e34086a14dfac65632e4064128fdab623699f7df47c2ccc9c5c8"
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
