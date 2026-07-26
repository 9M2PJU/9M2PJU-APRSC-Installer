
aprsc - an APRS-IS server in C
==============================

![Build Status](https://github.com/hessu/aprsc/actions/workflows/tests.yml/badge.svg)
![Package Status](https://github.com/9M2PJU/aprsc/actions/workflows/release.yml/badge.svg)


You're looking at the source code of aprsc, an open-source APRS-IS
server. This is the **9M2PJU fork**, which builds on the upstream
[hessu/aprsc](https://github.com/hessu/aprsc) and adds pre-built
packaging, broader platform support, and a one-liner installer.

For more information, please refer to the following resources:

* [Home page](http://he.fi/aprsc/)
* [Installation instructions](http://he.fi/aprsc/INSTALLING.html)
* [Source code downloads](http://he.fi/aprsc/down/)
* [Conference paper, Digital Communications Conference 2012, Atlanta, GA](http://he.fi/aprsc/dcc-2012-aprsc.pdf)
* [Contributing to the aprsc project](http://he.fi/aprsc/CONTRIBUTING.html)


Improvements over upstream
--------------------------

This fork adds the following on top of upstream hessu/aprsc:

### Pre-built binary packages (CI)

A [packaging workflow](.github/workflows/release.yml) builds `.deb`,
`.rpm` and `.snap` packages for **amd64 and arm64** on every push to
`main` and on pull requests.  Arm64 builds use QEMU `binfmt_misc`
emulation on standard GitHub runners.  Pushing a tag matching `v*`
(e.g. `v2.1.21`) publishes a [GitHub Release](../../releases) with all
packages attached.

| Format | Targets | Architectures |
|--------|---------|---------------|
| `.deb` | Debian 12 (bookworm) | amd64, arm64 |
| `.rpm` | Fedora 40, 42, 43; Alma/Rocky Linux 9 (EL9) | amd64, arm64 |
| `.snap` | Snapcraft `core22` base | amd64, arm64 |

### One-liner installer

A helper script auto-detects the operating system and architecture and
either installs a binary package (Debian, Ubuntu, Fedora on x86_64) or
builds aprsc from source (all other Linux, FreeBSD, macOS, and any
Linux on arm64):

    curl -fsSL https://raw.githubusercontent.com/9M2PJU/aprsc/main/tools/install.sh | sudo sh

See [INSTALLING](doc/INSTALLING.md) for details.

### AUR packages (Arch Linux)

Two AUR packages are maintained:

| Package | Description |
|---------|-------------|
| [`aprsc-9m2pju-git`](https://aur.archlinux.org/packages/aprsc-9m2pju-git) | Builds from the latest git HEAD of this fork |
| [`aprsc-9m2pju-bin`](https://aur.archlinux.org/packages/aprsc-9m2pju-bin) | Pre-built binary from the latest GitHub Release `.deb` |

Install with your preferred AUR helper, e.g.:

    yay -S aprsc-9m2pju-bin

Both packages install aprsc under `/opt/aprsc/`, ship the upstream
systemd units (`aprsc.service`, `aprsc@.service`, `aprsc-chroot.service`),
the AppArmor profile, and the man page.

### Snap

The snap runs aprsc as a `daemon: simple` service under strict
confinement.  Runtime paths under `/opt/aprsc/{etc,logs,data,web}` are
remapped via the snap `layout:` to `$SNAP_DATA` / `$SNAP_COMMON` so the
unmodified binary works inside the confinement.  The snap version is
derived at build time from `src/VERSION` plus the `git describe` suffix,
matching the scheme used by `src/Makefile.in` (`DISTVERSION`).

### Documentation updates

The documentation under `doc/` has been refreshed to reflect the
current state of the project:

* Tested-platforms list in `doc/BUILDING.md` updated to cover the
  distributions that actually receive binary packages (Debian, Ubuntu,
  Fedora), with FreeBSD, macOS, Solaris, Raspberry Pi and Windows
  moved to a "known to work historically" section.
* Outdated CentOS references replaced with Fedora (CentOS is EOL; the
  fork ships Fedora packages) across `doc/HOME.md`, `doc/README.md`,
  `doc/CONFIGURATION.md`, `doc/TRANSLATING.md` and `doc/DEBUGGING.md`.
* Fixed the "Mac OS X 10.8 (Snow Leopard)" mislabel (10.8 is Mountain
  Lion, 10.6 is Snow Leopard) in `doc/BUILDING.md`.
* Added a "Quick install (one-liner)" section to `doc/INSTALLING.md`.


Syncing with upstream
---------------------

This fork tracks [hessu/aprsc](https://github.com/hessu/aprsc).  To sync
with upstream:

    git remote add upstream https://github.com/hessu/aprsc.git  # if not already added
    git fetch upstream
    git merge upstream/main

The following upstream files are modified in this fork and may need
manual conflict resolution on sync (keep both the upstream changes and
the fork-specific edits):

* `README.md` (this file)
* `doc/BUILDING.md`, `doc/HOME.md`, `doc/README.md`, `doc/CONFIGURATION.md`,
  `doc/TRANSLATING.md`, `doc/DEBUGGING.md`, `doc/INSTALLING.md`

All other fork-specific files are **new files** that do not exist
upstream, so they will never conflict:

* `.github/workflows/release.yml` — the packaging workflow
* `snap/snapcraft.yaml` — snap manifest
* `tools/install.sh` — one-liner installer

The RPM spec (`src/rpm/aprsc.spec.in`) is **not** modified in this fork.
Missing `BuildRequires` are patched at build time by the workflow via
`sed`, so the file stays identical to upstream and won't conflict on
sync.

After syncing, push to `main` to trigger a build.  If the build
succeeds, tag a new release:

    git tag -a v<version> -m "aprsc v<version>"
    git push origin v<version>

This creates a GitHub Release with all pre-built packages attached.

Have fun!

- Hessu, OH7LZB
- 9M2PJU (fork maintainer)
