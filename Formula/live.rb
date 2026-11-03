class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://github.com/liveshortly/live"
  version "2.3.3"

  # Prebuilt binaries from live-dist; no local Go toolchain is needed.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.3/live-v2.3.3-darwin-arm64.gz"
      sha256 "caba23d5ed2e593dedbcd710914ca38939c91b23b8e072dde3f38e40e4e22035"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.3/live-v2.3.3-darwin-amd64.gz"
      sha256 "c2deca455e40df547485d6ae91e6370cfed51a472f6b7b28bdb07f556c784e35"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.3/live-v2.3.3-linux-arm64.gz"
      sha256 "75f744af13b5c00f52211d1184e6e79158c1e88b6170d57b734879accb50eac1"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v2.3.3/live-v2.3.3-linux-amd64.gz"
      sha256 "64d9a5890a38e59cd139ac49164c9230588e06b28ab12a02a9e7225e6967fe34"
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
