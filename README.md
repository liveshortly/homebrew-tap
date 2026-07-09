# LiveShortly/homebrew-tap

Homebrew tap for [`live`](https://github.com/LiveShortly/live) — stream any
coding-agent session to LiveShortly.

The formula installs a **prebuilt binary** from the public
[`live-dist`](https://github.com/LiveShortly/live-dist) releases. It does not
compile from source, so you do not need Go, and you do not need access to the
private source repo.

```bash
# this tap repo is still private, so tap it over SSH:
brew tap liveshortly/tap git@github.com:LiveShortly/homebrew-tap.git
brew install liveshortly/tap/live

# once this repo is public:
brew tap liveshortly/tap
brew install live
```

Upgrade with `brew upgrade liveshortly/tap/live`.

`brew install --HEAD liveshortly/tap/live` builds from `main` instead. That one
*does* need Go and read access to the private source repo.

## Releasing a new version

The binaries are published by CI in `LiveShortly/live`; this tap only points at
them.

1. In `LiveShortly/live`: update `CHANGELOG.md`, commit, `git tag -a vX.Y.Z`, push with `--tags`.
   CI builds the four platform binaries and uploads them to `live-dist`.
2. Here: bump `version` and all four `url` + `sha256` pairs in `Formula/live.rb`.

Homebrew checksums the **downloaded `.gz`**, while the `.sha256` files published
alongside each release are checksums of the **extracted binary**. They are not
interchangeable. Get the values Homebrew wants with:

```bash
V=vX.Y.Z
for p in darwin-arm64 darwin-amd64 linux-arm64 linux-amd64; do
  curl -sL "https://github.com/LiveShortly/live-dist/releases/download/$V/live-$V-$p.gz" \
    | shasum -a 256 | awk -v p="$p" '{print p, $1}'
done
```
