<div align="center">

# aprsc

**An open-source APRS-IS core server in C**

High-performance, lean APRS-IS server for core, hub and Tier-2 APRS-IS
infrastructure. Built for Linux, FreeBSD and macOS.

[![Build Status](https://github.com/hessu/aprsc/actions/workflows/tests.yml/badge.svg)](https://github.com/9M2PJU/aprsc/actions/workflows/tests.yml)
[![Package Status](https://github.com/9M2PJU/aprsc/actions/workflows/release.yml/badge.svg)](https://github.com/9M2PJU/aprsc/actions/workflows/release.yml)
[![Latest Release](https://img.shields.io/github/v/release/9M2PJU/aprsc?sort=date&display_name=release&label=Latest%20Release)](https://github.com/9M2PJU/aprsc/releases)
[![License](https://img.shields.io/github/license/9M2PJU/aprsc?label=License)](https://github.com/9M2PJU/aprsc/blob/main/doc/LICENSE)
[![Languages](https://img.shields.io/github/languages/top/9M2PJU/aprsc?label=C)](https://github.com/9M2PJU/aprsc)
[![Repo Size](https://img.shields.io/github/repo-size/9M2PJU/aprsc?label=Repo%20Size)](https://github.com/9M2PJU/aprsc)
[![Commits](https://img.shields.io/github/commits-since/9M2PJU/aprsc/latest?label=Commits%20Since%20Latest)](https://github.com/9M2PJU/aprsc/commits/main)
[![Last Commit](https://img.shields.io/github/last-commit/9M2PJU/aprsc?label=Last%20Commit)](https://github.com/9M2PJU/aprsc/commits/main)
[![GitHub Stars](https://img.shields.io/github/stars/9M2PJU/aprsc?style=social)](https://github.com/9M2PJU/aprsc/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/9M2PJU/aprsc?style=social)](https://github.com/9M2PJU/aprsc/forks)
[![GitHub Issues](https://img.shields.io/github/issues/9M2PJU/aprsc?label=Issues)](https://github.com/9M2PJU/aprsc/issues)
[![GitHub PRs](https://img.shields.io/github/issues-pr/9M2PJU/aprsc?label=Open%20PRs)](https://github.com/9M2PJU/aprsc/pulls)
[![AUR aprsc-9m2pju-bin](https://img.shields.io/aur/version/aprsc-9m2pju-bin?label=AUR%20bin)](https://aur.archlinux.org/packages/aprsc-9m2pju-bin)
[![AUR aprsc-9m2pju-git](https://img.shields.io/aur/version/aprsc-9m2pju-git?label=AUR%20git)](https://aur.archlinux.org/packages/aprsc-9m2pju-git)
[![Snap](https://snapcraft.io/aprsc/badge.svg)](https://snapcraft.io/aprsc)
[![Discussions](https://img.shields.io/github/discussions/9M2PJU/aprsc?label=Discussions)](https://github.com/9M2PJU/aprsc/discussions)
[![Mailing List](https://img.shields.io/badge/Mailing%20List-aprsc-blue.svg)](https://groups.google.com/forum/#!forum/aprsc)

</div>

---

> **This is the 9M2PJU fork** of [hessu/aprsc](https://github.com/hessu/aprsc),
> adding pre-built binary packages (`.deb` / `.rpm` / `.snap` for `amd64` +
> `arm64`), an AUR presence, a one-liner installer, refreshed docs, and
> broader platform support. It tracks upstream and is kept sync-safe.

---

## Table of Contents

- [Overview](#overview)
- [Improvements over upstream](#improvements-over-upstream)
- [Quick install](#quick-install)
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
| **One-liner installer** | `tools/install.sh` auto-detects OS/arch and installs a binary package or builds from source. |
| **AUR packages** | `aprsc-9m2pju-git` and `aprsc-9m2pju-bin` published on the AUR. |
| **Snap** | `snap/snapcraft.yaml` ships aprsc under strict confinement with `layout:` remapping of `/opt/aprsc/*`. |
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
curl -fsSL https://raw.githubusercontent.com/9M2PJU/aprsc/main/tools/install.sh | sudo sh
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
- `snap/snapcraft.yaml` — snap manifest
- `tools/install.sh` — one-liner installer
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
