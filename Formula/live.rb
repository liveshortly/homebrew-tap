class Live < Formula
  desc "Stream any coding-agent session to LiveShortly (live claude / live anything)"
  homepage "https://liveshortly.com"
  url "git@github.com:resapce/live.git",
      tag:   "v0.1.0",
      using: :git
  version "0.1.0"
  head "git@github.com:resapce/live.git", branch: "main", using: :git

  depends_on "go" => :build

  def install
    system "go", "build",
           "-ldflags", "-X main.version=#{version}",
           "-o", bin/"live", "./cmd/live"
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
    assert_match "live #{version}", shell_output("#{bin}/live version")
  end
end
