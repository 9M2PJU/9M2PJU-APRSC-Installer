
aprsc - an APRS-IS server in C
==============================

![Build Status](https://github.com/hessu/aprsc/actions/workflows/tests.yml/badge.svg)
![Package Status](https://github.com/9M2PJU/aprsc/actions/workflows/release.yml/badge.svg)


You're looking at the source code of aprsc, an open-source APRS-IS
server. This is the 9M2PJU fork, which adds pre-built packaging via
GitHub Actions (deb, rpm, snap) and AUR packages.

For more information, please refer to the following resources:

* [Home page](http://he.fi/aprsc/)
* [Installation instructions](http://he.fi/aprsc/INSTALLING.html)
* [Source code downloads](http://he.fi/aprsc/down/)
* [Conference paper, Digital Communications Conference 2012, Atlanta, GA](http://he.fi/aprsc/dcc-2012-aprsc.pdf)
* [Contributing to the aprsc project](http://he.fi/aprsc/CONTRIBUTING.html)

Packaging
---------

Pre-built packages are produced by the [Packaging workflow](.github/workflows/release.yml)
for **amd64** and **arm64**. Arm64 builds use QEMU binfmt emulation on
standard GitHub runners.

| Format | Targets | Architectures |
|--------|---------|---------------|
| `.deb` | Debian 12 (bookworm) | amd64, arm64 |
| `.rpm` | Fedora 40, 42, 43; Alma/Rocky Linux 9 (EL9) | amd64, arm64 |
| `.snap` | Snapcraft `core22` base | amd64, arm64 |

The workflow runs on every push to `main` and on pull requests; the
resulting packages are uploaded as workflow artifacts downloadable from
the Actions run. Pushing a tag matching `v*` (e.g. `v2.1.21`) also
publishes a [GitHub Release](../../releases) with all packages attached.

### AUR (Arch Linux)

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
confinement. Runtime paths under `/opt/aprsc/{etc,logs,data,web}` are
remapped via the snap `layout:` to `$SNAP_DATA` / `$SNAP_COMMON` so the
unmodified binary works inside the confinement. The snap version is
derived at build time from `src/VERSION` plus the `git describe` suffix,
matching the scheme used by `src/Makefile.in` (`DISTVERSION`).

Syncing with upstream
---------------------

This fork tracks [hessu/aprsc](https://github.com/hessu/aprsc). To sync
with upstream:

    git remote add upstream https://github.com/hessu/aprsc.git  # if not already added
    git fetch upstream
    git merge upstream/main

Only one upstream file is modified in this fork: `README.md` (this file).
If a merge conflict occurs here, resolve it by keeping both the upstream
changes and the sections below the `Packaging` heading.

All other fork-specific files are **new files** that do not exist
upstream, so they will never conflict:

* `.github/workflows/release.yml` — the packaging workflow
* `snap/snapcraft.yaml` — snap manifest

The RPM spec (`src/rpm/aprsc.spec.in`) is **not** modified in this fork.
Missing `BuildRequires` are patched at build time by the workflow via
`sed`, so the file stays identical to upstream and won't conflict on sync.

After syncing, push to `main` to trigger a build. If the build succeeds,
tag a new release:

    git tag -a v<version> -m "aprsc v<version>"
    git push origin v<version>

This creates a GitHub Release with all pre-built packages attached.

Have fun!

- Hessu, OH7LZB
