# Shinobi ZimaOS Image

Auto-builds a fresh Shinobi Docker image for ZimaOS Custom App installs.

The workflow builds from Shinobi's official Docker recipe:

- Docker recipe: https://gitlab.com/Shinobi-Systems/ShinobiDocker
- Shinobi branch: `dev`
- Published image: `ghcr.io/kaanaldemir/shinobi-zimaos:latest`

Use the published image in ZimaOS instead of the stale upstream prebuilt image when you want the same source freshness as Shinobi's official shell installer, while still letting ZimaOS manage the app lifecycle.