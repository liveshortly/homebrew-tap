class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://github.com/liveshortly/live"
  version "2.4.2"

  # Prebuilt binaries from live-dist; no local Go toolchain is needed.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.2/live-v2.4.2-darwin-arm64.gz"
      sha256 "b10020b4a44be1892b4d135a473cb83c638508a454ccce9d117514a573930658"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.2/live-v2.4.2-darwin-amd64.gz"
      sha256 "45f01455051a32ed1b19f3535b2046531441ab6257c5bdc84bff3ef94ce0717f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.2/live-v2.4.2-linux-arm64.gz"
      sha256 "5cf7cff071aa2923cd735ffa59ddf55933006c950291d1a2e0b5fd33d089ceae"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.4.2/live-v2.4.2-linux-amd64.gz"
      sha256 "3812c59ccc785d97f8f420155dc50a29d5b7db10c2b1cf528cae35ef6cc7fa1e"
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
