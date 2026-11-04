class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://github.com/liveshortly/live"
  version "2.3.9"

  # Prebuilt binaries from live-dist; no local Go toolchain is needed.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.9/live-v2.3.9-darwin-arm64.gz"
      sha256 "92ba870aa023e8793d7216ad35feb5467cf3a20c8e3aba55f41b29033a446ac7"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.9/live-v2.3.9-darwin-amd64.gz"
      sha256 "1dc9f7abe355c67822c349bbfe76f4e9022c32105e0f7bfbcc66f04b869561d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.9/live-v2.3.9-linux-arm64.gz"
      sha256 "6bbac24c90b8396e861192fa9eb1cc27f89caec2f663025acf3b07f5d6c6f2c4"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.9/live-v2.3.9-linux-amd64.gz"
      sha256 "548d989c299a3efa02436c0bb652da75397ace223c2fbe111890f3b8a7673293"
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
