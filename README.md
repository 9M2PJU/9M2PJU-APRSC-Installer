<div align="center">

# aprsc

**An open-source APRS-IS core server in C**

High-performance, lean APRS-IS server for core, hub and Tier-2 APRS-IS
infrastructure. Built for Linux, FreeBSD and macOS.

[![Build Status](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/actions/workflows/tests.yml/badge.svg)](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/actions/workflows/tests.yml)
[![Package Status](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/actions/workflows/release.yml/badge.svg)](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/actions/workflows/release.yml)
[![Docker Status](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/actions/workflows/docker.yml/badge.svg)](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/actions/workflows/docker.yml)
[![Latest Release](https://img.shields.io/github/v/release/9M2PJU/9M2PJU-APRSC-Installer?sort=date&display_name=release&label=Latest%20Release)](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/releases)
[![License](https://img.shields.io/github/license/9M2PJU/9M2PJU-APRSC-Installer?label=License)](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/blob/main/doc/LICENSE)
[![Languages](https://img.shields.io/github/languages/top/9M2PJU/9M2PJU-APRSC-Installer?label=C)](https://github.com/9M2PJU/9M2PJU-APRSC-Installer)
[![Repo Size](https://img.shields.io/github/repo-size/9M2PJU/9M2PJU-APRSC-Installer?label=Repo%20Size)](https://github.com/9M2PJU/9M2PJU-APRSC-Installer)
[![Commits](https://img.shields.io/github/commits-since/9M2PJU/9M2PJU-APRSC-Installer/latest?label=Commits%20Since%20Latest)](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/commits/main)
[![Last Commit](https://img.shields.io/github/last-commit/9M2PJU/9M2PJU-APRSC-Installer?label=Last%20Commit)](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/commits/main)
[![GitHub Stars](https://img.shields.io/github/stars/9M2PJU/9M2PJU-APRSC-Installer?style=social)](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/9M2PJU/9M2PJU-APRSC-Installer?style=social)](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/forks)
[![GitHub Issues](https://img.shields.io/github/issues/9M2PJU/9M2PJU-APRSC-Installer?label=Issues)](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/issues)
[![GitHub PRs](https://img.shields.io/github/issues-pr/9M2PJU/9M2PJU-APRSC-Installer?label=Open%20PRs)](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/pulls)
[![AUR aprsc-9m2pju-bin](https://img.shields.io/aur/version/aprsc-9m2pju-bin?label=AUR%20bin)](https://aur.archlinux.org/packages/aprsc-9m2pju-bin)
[![AUR aprsc-9m2pju-git](https://img.shields.io/aur/version/aprsc-9m2pju-git?label=AUR%20git)](https://aur.archlinux.org/packages/aprsc-9m2pju-git)
[![Snap](https://snapcraft.io/aprsc/badge.svg)](https://snapcraft.io/aprsc)
[![Docker](https://img.shields.io/badge/ghcr.io-9m2pju%2Faprsc-blue)](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/pkgs/container/aprsc)
[![Docker Hub](https://img.shields.io/docker/pulls/9m2pju/aprsc?label=Docker%20Hub%20pulls)](https://hub.docker.com/r/9m2pju/aprsc)
[![Discussions](https://img.shields.io/github/discussions/9M2PJU/9M2PJU-APRSC-Installer?label=Discussions)](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/discussions)
[![Mailing List](https://img.shields.io/badge/Mailing%20List-aprsc-blue.svg)](https://groups.google.com/forum/#!forum/aprsc)

</div>

---

> **This is the 9M2PJU fork** of [hessu/aprsc](https://github.com/hessu/aprsc),
> adding pre-built binary packages (`.deb` / `.rpm` / `.snap` for `amd64` +
> `arm64`), Docker / Podman container images (Linux + FreeBSD), an AUR
> presence, a one-liner installer, refreshed docs, and broader platform
> support. It tracks upstream and is kept sync-safe.

---

## Table of Contents

- [Overview](#overview)
- [Improvements over upstream](#improvements-over-upstream)
- [Quick install](#quick-install)
- [Docker / Podman](#docker--podman)
- [Pre-built packages](#pre-built-packages)
- [AUR packages (Arch Linux)](#aur-packages-arch-linux)
- [Snap](#snap)
- [Building from source](#building-from-source)
- [Supported platforms](#supported-platforms)
- [Features](#features)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [Syncing with upstream](#syncing-with-upstream)
- [License](#license)
- [Credits](#credits)

---

## Overview

`aprsc` (pronounced *a-purrs-c*) is a plain APRS-IS server written in C,
intended for the core and Tier-2 APRS-IS servers. It is lean, fast and
stable, and has been in continuous production use on a large percentage of
APRS-IS servers since 2012.

It is **not** an igate, digipeater, or radio-interfacing tool — those
belong in dedicated software such as `aprx` or `aprs4r`.

---

## Improvements over upstream

This fork adds the following on top of upstream `hessu/aprsc`:

| Area | What changed |
|------|--------------|
| **CI packaging** | New [release workflow](.github/workflows/release.yml) builds `.deb`, `.rpm` and `.snap` for `amd64` + `arm64` on every push and publishes GitHub Releases on `v*` tags. |
| **Docker / Podman** | Multi-arch Docker image (`amd64` + `arm64`) published to [GHCR](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/pkgs/container/aprsc). Separate `Dockerfile.freebsd` for Podman on FreeBSD. One-liner installer auto-detects OS and uses Docker (Linux) or Podman (FreeBSD). |
| **One-liner installer** | `tools/install.sh` auto-detects OS/arch and installs a binary package or builds from source. `tools/install-docker.sh` does the same for container deployments. |
| **AUR packages** | `aprsc-9m2pju-git` and `aprsc-9m2pju-bin` published on the AUR. |
| **Snap** | `snap/snapcraft.yaml` ships aprsc under strict confinement with `layout:` remapping of `/opt/aprsc/*`. |
| **Fork identification** | Version string customized to `aprsc 2.1.21-9M2PJU` via `src/version_branch.h` for easy identification in CLI, login banners, and status pages. |
| **Documentation refresh** | Tested-platforms list updated, CentOS → Fedora, macOS version mislabel fixed, one-liner install section added. |
| **Sync-safe fork** | Only `README.md` and `doc/*.md` are modified upstream files; all other fork additions are new files that cannot conflict. The RPM spec is patched at build time via `sed`. |

---

## Quick install

The recommended way to install aprsc is the **one-liner installer**
([`tools/install.sh`](tools/install.sh)), which lives in this repository.
It auto-detects your operating system and architecture, then either
installs a binary package (Debian, Ubuntu, Fedora on `x86_64`) or builds
aprsc from source (all other Linux, FreeBSD, macOS, and any Linux on
`arm64`).

```bash
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-APRSC-Installer/main/tools/install.sh | sudo sh
```

**Supported by the one-liner:**

| Platform | Arch | Method |
|----------|------|--------|
| Debian / Ubuntu | `x86_64`, `i386` | apt repo + binary package |
| Fedora | `x86_64` | dnf repo + binary package |
| Other Linux | `amd64`, `arm64`, others | source build (auto-detects apt/dnf/apk/pacman for deps) |
| FreeBSD | `amd64`, `arm64` | source build (libevent2 from pkg/ports) |
| macOS | `amd64` (Intel), `arm64` (Apple Silicon) | source build (Homebrew or MacPorts) |

After the install finishes, edit `/opt/aprsc/etc/aprsc.conf` and start
aprsc:

```bash
sudo systemctl enable --now aprsc
# Edit /opt/aprsc/etc/aprsc.conf to taste, then:
sudo systemctl reload aprsc
```

<details>
<summary><b>Prefer manual setup? (apt / dnf)</b></summary>

If you'd rather configure the package repository by hand instead of using
the one-liner, here are the per-distro steps.

**Debian / Ubuntu (apt):**

```bash
# Pick your codename: noble | jammy | focal | trixie | bookworm | bullseye
CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"
echo "deb http://aprsc-dist.he.fi/aprsc/apt $CODENAME main" \
  | sudo tee /etc/apt/sources.list.d/aprsc.list

# Import signing key (rsa4096 for noble/trixie, legacy key otherwise)
case "$CODENAME" in
  noble|trixie) KEY=D43AD4708A2DA1139F250B3294E40E5320D8AE3C ;;
  *)            KEY=C51AA22389B5B74C3896EF3CA72A581E657A2B8D ;;
esac
gpg --keyserver keyserver.ubuntu.com --recv "$KEY"
sudo gpg --export "$KEY" > /etc/apt/trusted.gpg.d/aprsc.key.gpg

sudo apt-get update
sudo apt-get install aprsc
```

**Fedora (dnf):**

```bash
sudo dnf install curl
sudo curl -o /etc/yum.repos.d/aprsc.repo http://he.fi/aprsc/down/aprsc-fedora.repo
sudo dnf install aprsc
```

See [`doc/INSTALLING.md`](doc/INSTALLING.md) for the full manual walk-through.

</details>

See [`doc/CONFIGURATION.md`](doc/CONFIGURATION.md) for configuration details.

---

## Docker / Podman

aprsc is available as a container image on both
[Docker Hub](https://hub.docker.com/r/9m2pju/aprsc) and the
[GitHub Container Registry](https://github.com/9M2PJU/9M2PJU-APRSC-Installer/pkgs/container/aprsc).
Both registries carry identical multi-arch images.

### One-liner install

```bash
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-APRSC-Installer/main/tools/install-docker.sh | sudo sh
```

The script auto-detects the OS:

| Platform | Container runtime | Image | Source |
|----------|-------------------|-------|--------|
| **Linux** | Docker | `docker.io/9m2pju/aprsc:latest` | pulled from Docker Hub (pre-built, multi-arch) |
| **FreeBSD** | Podman | `aprsc-freebsd:latest` | built locally from `Dockerfile.freebsd` |

On Linux, the script installs Docker if missing, pulls the pre-built
multi-arch image from Docker Hub, seeds `/opt/aprsc/etc/aprsc.conf` from
the example (with `MagicBadness` commented out), and starts the container
with the required capabilities and port mappings.

On FreeBSD, Docker does not run natively (the old `docker-freebsd` port
was deleted in 2020 — Docker depends on Linux kernel features like
cgroups and namespaces that FreeBSD doesn't provide). The script
installs Podman instead, clones the repo, builds the FreeBSD image
locally from `Dockerfile.freebsd` using the official
`ghcr.io/freebsd/freebsd-runtime:14.3` base, and starts it.

### Manual Docker run

```bash
docker pull docker.io/9m2pju/aprsc:latest
# or: docker pull ghcr.io/9m2pju/aprsc:latest

mkdir -p /opt/aprsc/{etc,logs,data}
# Seed config from the example in the image
docker run --rm --entrypoint cat docker.io/9m2pju/aprsc:latest \
  /opt/aprsc/etc/aprsc.conf > /opt/aprsc/etc/aprsc.conf
# Comment out MagicBadness (operator attention gate)
sed -i 's/^MagicBadness/#MagicBadness/' /opt/aprsc/etc/aprsc.conf
# Edit ServerId, PassCode, MyAdmin, MyEmail, Uplink in the config

docker run -d --name aprsc \
  --restart unless-stopped \
  --cap-add=CAP_NET_BIND_SERVICE \
  --cap-add=CAP_SETUID --cap-add=CAP_SETGID \
  --cap-add=CAP_SYS_CHROOT --cap-add=CAP_SYS_RESOURCE \
  -p 14580:14580/tcp -p 14580:14580/udp \
  -p 10152:10152/tcp -p 10152:10152/udp \
  -p 8080:8080/udp \
  -p 14501:14501/tcp \
  -v /opt/aprsc/etc:/opt/aprsc/etc:ro \
  -v /opt/aprsc/logs:/opt/aprsc/logs \
  -v /opt/aprsc/data:/opt/aprsc/data \
  docker.io/9m2pju/aprsc:latest
```

### Image tags

Both registries carry the same tags. Docker Hub is shown below; replace
`docker.io` with `ghcr.io` for GHCR.

| Tag | Meaning |
|-----|---------|
| `docker.io/9m2pju/aprsc:latest` | Latest release (on `v*` tags) |
| `docker.io/9m2pju/aprsc:main` | Latest push to `main` branch |
| `docker.io/9m2pju/aprsc:2.1.21` | Specific version (on `v2.1.21` tag) |
| `docker.io/9m2pju/aprsc:2.1.21-9M2PJU` | Specific fork version |

Multi-arch: `linux/amd64` + `linux/arm64`. Image size ~83MB.

### Configuration

Configuration is done via config file mounts only (no environment
variables). Mount your `aprsc.conf` at `/opt/aprsc/etc/aprsc.conf`:

```
/opt/aprsc/etc/    ← aprsc.conf (read-only mount)
/opt/aprsc/logs/   ← log files
/opt/aprsc/data/   ← persistent state
```

The container runs aprsc in the foreground (no `-f` daemonize flag),
chrooted to `/opt/aprsc`, dropping privileges to an `aprsc` user.
The following capabilities are required:

- `CAP_NET_BIND_SERVICE` — bind to ports < 1024 (14501, 14580, 10152)
- `CAP_SETUID` / `CAP_SETGID` — drop privileges to the `aprsc` user
- `CAP_SYS_CHROOT` — enter the `/opt/aprsc` chroot
- `CAP_SYS_RESOURCE` — raise file descriptor limits

### Building the FreeBSD image manually

```bash
git clone https://github.com/9M2PJU/9M2PJU-APRSC-Installer.git
cd 9M2PJU-APRSC-Installer
podman build -f Dockerfile.freebsd -t aprsc-freebsd:latest .
```

### Why no FreeBSD image on GHCR?

GitHub Actions has no native FreeBSD runners, so the FreeBSD image
cannot be built in CI. It must be built locally on a FreeBSD host
using Podman and `Dockerfile.freebsd`. The Linux image is pre-built
and published to GHCR for both `amd64` and `arm64`.

---

## Pre-built packages

The [Packaging workflow](.github/workflows/release.yml) produces the
following artifacts on every push to `main` and on pull requests. Pushing
a `v*` tag (e.g. `v2.1.21`) publishes a
[GitHub Release](../../releases) with all packages attached.

| Format | Targets | Architectures |
|--------|---------|---------------|
| `.deb` | Debian 12 (bookworm) | `amd64`, `arm64` |
| `.rpm` | Fedora 40, 42, 43; Alma/Rocky Linux 9 (EL9) | `amd64`, `arm64` |
| `.snap` | Snapcraft `core22` base | `amd64`, `arm64` |

Arm64 builds use QEMU `binfmt_misc` emulation on standard GitHub runners —
correct but slower than native builds.

---

## AUR packages (Arch Linux)

| Package | Description |
|---------|-------------|
| [`aprsc-9m2pju-git`](https://aur.archlinux.org/packages/aprsc-9m2pju-git) | Builds from the latest git HEAD of this fork |
| [`aprsc-9m2pju-bin`](https://aur.archlinux.org/packages/aprsc-9m2pju-bin) | Pre-built binary from the latest GitHub Release `.deb` |

Install with your preferred AUR helper:

```bash
yay -S aprsc-9m2pju-bin
```

Both packages install under `/opt/aprsc/`, ship the upstream systemd units
(`aprsc.service`, `aprsc@.service`, `aprsc-chroot.service`), the AppArmor
profile, and the man page.

---

## Snap

The snap runs aprsc as a `daemon: simple` service under strict confinement.
Runtime paths under `/opt/aprsc/{etc,logs,data,web}` are remapped via the
snap `layout:` to `$SNAP_DATA` / `$SNAP_COMMON` so the unmodified binary
works inside the confinement. The snap version is derived at build time
from `src/VERSION` plus the `git describe` suffix, matching the scheme used
by `src/Makefile.in` (`DISTVERSION`).

```bash
sudo snap install aprsc
```

---

## Building from source

aprsc uses the classic `./configure && make && make install` flow and
requires `libevent2` (and OpenSSL for TLS support).

```bash
cd src
./configure
make -j"$(nproc)"
sudo make install
```

Platform-specific notes:

<details>
<summary><b>FreeBSD</b> (libevent2 from ports)</summary>

```bash
CFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib/event2 ./configure
gmake -j"$(sysctl -n hw.ncpu)"
sudo gmake install
```
</details>

<details>
<summary><b>macOS</b> (libevent2 from Homebrew / MacPorts)</summary>

```bash
# Homebrew (auto-detects /opt/homebrew vs /usr/local)
brew install libevent openssl@3
BREW_PREFIX="$(brew --prefix)"
CFLAGS="-I${BREW_PREFIX}/include" LDFLAGS="-L${BREW_PREFIX}/lib" ./configure

# MacPorts
sudo port install libevent2 openssl3
CFLAGS=-I/opt/local/include LDFLAGS=-L/opt/local/lib ./configure
```
</details>

See [`doc/BUILDING.md`](doc/BUILDING.md) for full prerequisites and
platform notes.

---

## Supported platforms

**Actively tested** (binary packages available):

| Distribution | Arch | Package |
|--------------|------|---------|
| Debian 11 (bullseye) | `i386`, `x86_64` | `.deb` |
| Debian 12 (bookworm) | `x86_64` | `.deb` |
| Debian 13 (trixie) | `x86_64` | `.deb` |
| Ubuntu 20.04 / 22.04 / 24.04 LTS | `x86_64` | `.deb` |
| Fedora 42, 43 | `x86_64` | `.rpm` |
| Arch Linux | any | AUR |

**Known to build and work historically** (not regularly tested; patches
welcome):

- macOS (`x86_`, Apple Silicon) — libevent2 from Homebrew/MacPorts
- FreeBSD on `amd64` and `i386` — libevent2 from ports
- Solaris 11 (SunOS 5.11 i86pc)
- Raspberry Pi (Raspbian/Debian) — ARM
- Windows under Cygwin — see [`doc/WINDOWS.md`](doc/WINDOWS.md)

For best-effort support, pick Debian, Ubuntu or Fedora.

---

## Features

aprsc is designed strictly for APRS-IS core, hub and Tier-2 servers.

**Core functionality:**

- Duplicate packet filtering
- Q construct processing
- Client-defined filters
- APRS packet parsing as necessary to support filtering
- i-gate client support
- Messaging support
- UDP client support
- UDP core peer links
- Uplink server support
- Passcode validation
- Web status page + machine-readable JSON status over HTTP
- Localization support for the status web
- HTTP position upload using `POST`
- Full IPv4 and IPv6 support
- Configurable access lists on client ports
- Logging to syslog, file or stderr
- Built-in log rotation when logging to a file
- Runs in a chroot

**Operational sugar:**

- Online reconfiguration of almost all settings without restarting
- Live upgrade — software can usually be upgraded without disconnecting clients
- Munin plugin for statistics graphs

**Explicitly out of scope:** igating, digipeating, radio interfacing,
D-PRS, object generation. Use dedicated software for those.

---

## Documentation

| Document | Contents |
|----------|---------|
| [`doc/HOME.md`](doc/HOME.md) | Project home / overview |
| [`doc/INSTALLING.md`](doc/INSTALLING.md) | Installation (apt, dnf, one-liner) |
| [`doc/BUILDING.md`](doc/BUILDING.md) | Building from source |
| [`doc/CONFIGURATION.md`](doc/CONFIGURATION.md) | `aprsc.conf` reference |
| [`doc/MONITORING.md`](doc/MONITORING.md) | Munin graphs, nagios alarms |
| [`doc/MULTIPLE.md`](doc/MULTIPLE.md) | Running multiple instances |
| [`doc/DEBUGGING.md`](doc/DEBUGGING.md) | Debug logging, core dumps |
| [`doc/DESIGN.md`](doc/DESIGN.md) | Architecture overview |
| [`doc/IGATE-HINTS.md`](doc/IGATE-HINTS.md) | Notes for iGate developers |
| [`doc/TRANSLATING.md`](doc/TRANSLATING.md) | Localizing the status page |
| [`doc/TIPS.md`](doc/TIPS.md) | Tips & tricks (low ports, NAT) |
| [`doc/WINDOWS.md`](doc/WINDOWS.md) | Cygwin/Windows notes |
| [`doc/CONTRIBUTING.md`](doc/CONTRIBUTING.md) | How to contribute |
| [`doc/LICENSE`](doc/LICENSE) | BSD license |

External resources:

- [Home page](http://he.fi/aprsc/)
- [Source code downloads](http://he.fi/aprsc/down/)
- [DCC 2012 paper (Atlanta, GA)](http://he.fi/aprsc/dcc-2012-aprsc.pdf)
- [aprsc discussion group / mailing list](https://groups.google.com/forum/#!forum/aprsc)

---

## Contributing

Contributions are welcome!  Please read
[`doc/CONTRIBUTING.md`](doc/CONTRIBUTING.md) first — it covers source code
style, the test-driven workflow, and how to submit pull requests.

All new feature commits **must** come with a test case in the test suite
under `tests/`. Run the suite with `make test` from the `tests/`
subdirectory before connecting modified code to the live APRS-IS.

---

## Syncing with upstream

This fork tracks [hessu/aprsc](https://github.com/hessu/aprsc).

```bash
git remote add upstream https://github.com/hessu/aprsc.git  # if not already added
git fetch upstream
git merge upstream/main
```

**Modified upstream files** (may need manual conflict resolution on sync —
keep both the upstream changes and the fork-specific edits):

- `README.md` (this file)
- `doc/BUILDING.md`, `doc/HOME.md`, `doc/README.md`, `doc/CONFIGURATION.md`,
  `doc/TRANSLATING.md`, `doc/DEBUGGING.md`, `doc/INSTALLING.md`

**Fork-only new files** (will never conflict):

- `.github/workflows/release.yml` — packaging workflow
- `.github/workflows/docker.yml` — Docker image build & push workflow
- `Dockerfile` — Linux Docker image (multi-stage build on debian:12-slim)
- `Dockerfile.freebsd` — FreeBSD Podman image (freebsd-runtime:14.3 base)
- `.dockerignore` — Docker build context exclusions
- `snap/snapcraft.yaml` — snap manifest
- `tools/install.sh` — one-liner installer (native packages / source build)
- `tools/install-docker.sh` — one-liner installer (Docker / Podman)
- `src/version_branch.h` — fork version suffix (`9M2PJU`)
- `AGENTS.md` — agent conventions

The RPM spec (`src/rpm/aprsc.spec.in`) is **not** modified in this fork.
Missing `BuildRequires` are patched at build time by the workflow via
`sed`, so the file stays identical to upstream and won't conflict on sync.

After syncing, push to `main` to trigger a build. If the build succeeds,
tag a new release:

```bash
git tag -a v<version> -m "aprsc v<version>"
git push origin v<version>
```

This creates a GitHub Release with all pre-built packages attached.

---

## License

aprsc is open source software licensed under the
[BSD license](doc/LICENSE) — © Matti Aarnio, OH2MQK, and Heikki
Hannikainen, OH7LZB. The BSD license permits reuse in any form, amateur or
non-amateur, commercial or non-commercial.

---

## Credits

- **Matti Aarnio, OH2MQK** — original author
- **Heikki Hannikainen, OH7LZB** — original author
- **9M2PJU** — fork maintainer (packaging, installer, docs, broader
  platform support)

Have fun!
