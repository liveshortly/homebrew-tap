class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://liveshortly.com"
  version "1.1.0"

  # Prebuilt binaries from the public live-dist repo. Building from source here
  # would fail for anyone without access to the private liveshortly/live repo.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v1.1.0/live-v1.1.0-darwin-arm64.gz"
      sha256 "f1c98eeb1e2af02ccfb216d2f3668e42f7abe9b9a1c4ff6b0ea616ff0813e0a2"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v1.1.0/live-v1.1.0-darwin-amd64.gz"
      sha256 "67ce86513932dedfbd4c70b963e28d1242f6849dfc23dd63e4a50ac2005e1a31"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v1.1.0/live-v1.1.0-linux-arm64.gz"
      sha256 "31779034a0755c26840b5ad63b4a93493b4e1d0a01291efa9879c83eb5d31cf2"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v1.1.0/live-v1.1.0-linux-amd64.gz"
      sha256 "da59fea91f64ddb2c1ec21471c694acb86d4ccfd6d8375ba73aa3c2151dcf31e"
    end
  end

  head do
    url "git@github.com:liveshortly/live.git", branch: "main", using: :git
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
      Sign in before your first session:
        live login
      Then stream any agent:
        live claude
    EOS
  end

  test do
    # The binary stamps a leading "v": `live v1.0.1`.
    assert_match "live v#{version}", shell_output("#{bin}/live version")
  end
end
