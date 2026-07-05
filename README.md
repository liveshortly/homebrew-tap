# resapce/homebrew-tap

Homebrew tap for [`live`](https://github.com/resapce/live) — stream any
coding-agent session to LiveShortly.

```bash
# while the repos are private, tap over SSH:
brew tap resapce/tap git@github.com:resapce/homebrew-tap.git
brew install resapce/tap/live

# once public:
brew tap resapce/tap
brew install live
```

Upgrade: `brew upgrade resapce/tap/live` (picks up new tagged releases).
Latest from main: `brew install --HEAD resapce/tap/live`.

## Releasing a new version

1. In `resapce/live`: update `CHANGELOG.md`, commit, `git tag -a vX.Y.Z -m "..."`, push with `--tags`.
2. Here: bump `tag:` and `version` in `Formula/live.rb`, commit, push.
