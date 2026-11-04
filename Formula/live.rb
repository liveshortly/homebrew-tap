class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://github.com/liveshortly/live"
  version "2.3.8"

  # Prebuilt binaries from live-dist; no local Go toolchain is needed.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.8/live-v2.3.8-darwin-arm64.gz"
      sha256 "b35962f0dd0a372d506e1c391cb26e23337761e167cadb4d64651e4f789b0f3f"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.8/live-v2.3.8-darwin-amd64.gz"
      sha256 "697af9317df2a88ed6dbe749922eabc4fa4f77bfeb8588d80d510a7f8ca1ecbf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.8/live-v2.3.8-linux-arm64.gz"
      sha256 "3e209269ca96049b7d03e05147936202355f39a56a7ed528ec1345cb8f747e50"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.8/live-v2.3.8-linux-amd64.gz"
      sha256 "64de1086017c6836e2995cf4efd6bcceebe5cdff55839a8e3c659f238da8d84a"
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
