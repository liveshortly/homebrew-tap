class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://github.com/liveshortly/live"
  version "1.2.0"

  # Prebuilt binaries from live-dist; no local Go toolchain is needed.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v1.2.0/live-v1.2.0-darwin-arm64.gz"
      sha256 "e1351552e5666ed210ebdd10b0786aac58d3947b4bb78d4ed34ed89e9e02bc5b"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v1.2.0/live-v1.2.0-darwin-amd64.gz"
      sha256 "8bbb69c0ffe933460025dc93a84038a4e46f31792f40092a333f201399a5b78f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v1.2.0/live-v1.2.0-linux-arm64.gz"
      sha256 "0e56db25e4cd6ed27819d0189cedba54180ce16b04f3c407c8b3cf9557db910f"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v1.2.0/live-v1.2.0-linux-amd64.gz"
      sha256 "fd5bf892969b7ba401426944f8d66455ce7766616b165402c045c8789c2dae61"
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
