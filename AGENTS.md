# Project notes for Devin

## Git commit conventions

- Do **not** add the `Co-Authored-By: Devin` trailer to commit messages.
- Do **not** add the `Generated with [Devin]` line to commit messages.
- Match the existing commit style in this repo (subject + body).
- **Always** add the following trailer to every commit message:

  ```
  Co-Authored-By: 9M2PJU <9m2pju@hamradio.my>
  ```

## Docker / container support

- `Dockerfile` — Linux image (debian:12-slim, multi-stage, ~83MB)
- `Dockerfile.freebsd` — FreeBSD image (freebsd-runtime:14.3, built locally via Podman)
- `tools/install-docker.sh` — one-liner installer (auto-detects Linux/Docker vs FreeBSD/Podman)
- `.github/workflows/docker.yml` — CI builds and pushes to both Docker Hub and GHCR

### Container runtime requirements

aprsc requires these capabilities when run in a container:
- `CAP_NET_BIND_SERVICE` — bind ports < 1024 (14501, 14580, 10152)
- `CAP_SETUID` / `CAP_SETGID` — drop privileges to `aprsc` user
- `CAP_SYS_CHROOT` — enter the `/opt/aprsc` chroot
- `CAP_SYS_RESOURCE` — raise file descriptor limits

The entrypoint runs aprsc in the **foreground** (no `-f` daemonize flag),
chrooted to `/opt/aprsc`, with `-u aprsc` for privilege dropping.

### Config note: MagicBadness

`aprsc.conf` ships with a `MagicBadness 42.7` directive — an "operator
attention" gate that prevents aprsc from starting until the operator
edits the config. The installer comments it out automatically with
`sed -i 's/^MagicBadness/#MagicBadness/'`. If aprsc silently exits
with no log output, check that MagicBadness is commented out.

### Image registries

- Docker Hub: `docker.io/9m2pju/aprsc` (primary, used by installer)
- GHCR: `ghcr.io/9m2pju/aprsc` (mirror)
- Tags: `:latest`, `:main`, `:2.1.21`, `:2.1.21-9M2PJU`
- Multi-arch: `linux/amd64` + `linux/arm64`
- CI secrets: `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN` (set in repo)

### FreeBSD Docker note

Docker does **not** run natively on FreeBSD (the docker-freebsd port
was deleted in 2020 — Docker needs Linux cgroups/namespaces). FreeBSD
uses Podman with the official FreeBSD OCI base image
(`ghcr.io/freebsd/freebsd-runtime:14.3`). The FreeBSD image is built
locally by the installer (no FreeBSD CI runners exist). Linux users
cannot run FreeBSD Docker images — containers share the host kernel.

## Version string

`src/version_branch.h` sets `VERSION_BRANCH` to `"9M2PJU"`, producing
the version string `aprsc 2.1.21-9M2PJU` in CLI output, login banners,
and the HTTP status page.

## CI workflows

- `.github/workflows/tests.yml` — build tests
- `.github/workflows/release.yml` — .deb/.rpm/.snap packaging, GitHub Releases on v* tags
- `.github/workflows/docker.yml` — Docker/Podman image build & push (Docker Hub + GHCR)

## Release tagging

```bash
git tag -a v<version>-9M2PJU -m "aprsc <version>-9M2PJU — <summary>"
git push origin v<version>-9M2PJU
```

This triggers both the release workflow (packages) and the docker
workflow (container images). Current latest tag: `v2.1.21-9M2PJU`.
