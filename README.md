# Shinobi ZimaOS Image

Auto-builds a fresh Shinobi Docker image for ZimaOS Custom App installs.

The workflow builds from Shinobi's official Docker recipe:

- Docker recipe: https://gitlab.com/Shinobi-Systems/ShinobiDocker
- Shinobi branch: `dev`
- Published image: `ghcr.io/kaanaldemir/shinobi-zimaos:latest`

Schedule:

- Runs weekly on Sunday at 03:00 UTC / 06:00 Istanbul.
- Checks the current upstream Shinobi `dev` commit before building.
- Rebuilds only when the upstream commit changed, or when manually dispatched with `force=true`.

Use the published image in ZimaOS instead of the stale upstream prebuilt image when you want the same source freshness as Shinobi's official shell installer, while still letting ZimaOS manage the app lifecycle.