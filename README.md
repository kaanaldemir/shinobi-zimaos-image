# Shinobi ZimaOS Image

Auto-builds a fresh Shinobi Docker image for ZimaOS while keeping the image definition in this repository.

This repository now does three separate things:

- watches upstream `Shinobi` `dev` for changes
- builds a local `Dockerfile` instead of blindly rebuilding remote `ShinobiDocker`
- smoke-tests Intel acceleration support before publishing

Published image:

- `ghcr.io/kaanaldemir/shinobi-zimaos:latest`

Build model:

- upstream source repo: `Shinobi-Systems/Shinobi`
- upstream branch watched: `dev`
- upstream commit is pinned into each image build with `SHINOBI_COMMIT`
- image recipe lives in this repo: [Dockerfile](./Dockerfile)

Why this exists:

- ZimaOS only needs a Docker image and `/dev/dri` device mapping
- Intel acceleration support depends on the container runtime, not just Shinobi UI settings
- this repo gives a place to pin packages, add tests, and debug Intel runtime behavior without losing upstream Shinobi freshness

Included validation:

- static smoke test in CI: [`scripts/smoke-test.sh`](./scripts/smoke-test.sh)
- host-side Intel runtime test for `/dev/dri` environments: [`scripts/test-intel-runtime.sh`](./scripts/test-intel-runtime.sh)

Important limitation:

- GitHub-hosted Actions runners do not expose your Intel GPU
- CI can prove that the image contains `qsv`/`vaapi` support and packages
- CI cannot prove that real `QSV` transcode works on your Zima box
- real `QSV` validation must still be done on hardware with `/dev/dri`

Use with ZimaOS:

- map `/dev/dri:/dev/dri`
- keep recording in Shinobi as `copy`
- prefer `VAAPI` for browser live-view transcode unless `QSV` has been runtime-tested successfully on the target host
