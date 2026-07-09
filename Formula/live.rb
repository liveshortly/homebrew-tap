class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://liveshortly.com"
  version "1.0.1"

  # Prebuilt binaries from the public live-dist repo. Building from source here
  # would fail for anyone without access to the private liveshortly/live repo.
  on_macos do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v1.0.1/live-v1.0.1-darwin-arm64.gz"
      sha256 "dac7abd61ac1790e4e1e45a1a53a1f4cce5a4fe5cf585b1033dbc8fa7746e7e1"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v1.0.1/live-v1.0.1-darwin-amd64.gz"
      sha256 "ab73fc6644b1b03fef9fb1a7cecb937a2ce9f5f2fc4330efdb36f1e59c821f87"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/liveshortly/live-dist/releases/download/v1.0.1/live-v1.0.1-linux-arm64.gz"
      sha256 "fcdff344b6af9ce2cd1cb9d856b8d812fe622049fb256f20c07ea109c5e1aec7"
    end
    on_intel do
      url "https://github.com/liveshortly/live-dist/releases/download/v1.0.1/live-v1.0.1-linux-amd64.gz"
      sha256 "246cace18ba2c6329e29c8b27a9b72354052e27d03197692df48a479147c3e03"
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
