class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://github.com/liveshortly/live"
  version "2.3.7"

  # Prebuilt binaries from live-dist; no local Go toolchain is needed.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.7/live-v2.3.7-darwin-arm64.gz"
      sha256 "26ef15fb242739e73d023abadc4b1cd93a8b8d0f7622aef9f7fd34995a6eb424"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.7/live-v2.3.7-darwin-amd64.gz"
      sha256 "2f76f30638eb49aed77924b8008d27eed27b7488c5e31434be9b067abb7a613a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.7/live-v2.3.7-linux-arm64.gz"
      sha256 "e9a1f03bfc76d95c27fceeef5f37cf70d4372f709394c1ade90899dd95ecd9ca"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.7/live-v2.3.7-linux-amd64.gz"
      sha256 "f3b32af56d7521d28b86e8b10fc08d943b4662ddb60d0fbc34175d9e35402af4"
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
