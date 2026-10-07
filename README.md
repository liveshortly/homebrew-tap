# liveshortly/homebrew-tap

Homebrew tap for [`live`](https://github.com/liveshortly/live) — stream any
coding-agent session to LiveShortly.

The formula installs a **prebuilt binary** from the public
[`live-dist`](https://github.com/liveshortly/live-dist) releases. It does not
compile from source, so you do not need Go.

```bash
brew tap liveshortly/tap
brew install liveshortly/tap/live
```

Configure your own server using the [setup instructions](https://github.com/liveshortly/live#choose-your-server).
For browser sessions, configure `host.json` and run `live login`. For pocket.ai,
run `live daemon --server` with a key; no hosted login is needed.

Upgrade with `brew upgrade liveshortly/tap/live`.
`brew install --HEAD liveshortly/tap/live` builds the source on `main` and needs Go.
The tap and source repositories must be public before unauthenticated users can
follow these commands. Publishing the repositories is separate from installation.

## Releasing a new version

The binaries are published by CI in `liveshortly/live`; this tap only points at
them.

1. In `liveshortly/live`, update `VERSION` and `CHANGELOG.md`, then push to `main`.
   CI tests, tags the new version, and publishes four platform binaries to `live-dist`.
2. CI updates this formula’s version, URLs and checksums using `RELEASE_TOKEN`.
   No website mirror or hosted-service deployment is involved.

Homebrew checksums the **downloaded `.gz`**, while the `.sha256` files published
alongside each release are checksums of the **extracted binary**. They are not
interchangeable. Get the values Homebrew wants with:

```bash
V=vX.Y.Z
for p in darwin-arm64 darwin-amd64 linux-arm64 linux-amd64; do
  curl -sL "https://github.com/liveshortly/live-dist/releases/download/$V/live-$V-$p.gz" \
    | shasum -a 256 | awk -v p="$p" '{print p, $1}'
done
```
