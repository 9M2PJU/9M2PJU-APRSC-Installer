
aprsc - an APRS-IS server in C
==============================

![Build Status](https://github.com/hessu/aprsc/actions/workflows/tests.yml/badge.svg)
![Package Status](https://github.com/hessu/aprsc/actions/workflows/release.yml/badge.svg)


You're looking at the source code of aprsc, an open-source APRS-IS
server.

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

Package sources live in:

* `src/debian/` — Debian packaging (`control`, `rules`, systemd units, …)
* `src/rpm/aprsc.spec.in` — RPM spec template (processed by `make dist`
  or by the workflow via `sed`)
* `snap/snapcraft.yaml` — Snap manifest. The snap version is derived at
  build time from `src/VERSION` plus the `git describe` suffix, matching
  the scheme used by `src/Makefile.in` (`DISTVERSION`), so it tracks the
  upstream version automatically.

The snap runs aprsc as a `daemon: simple` service under strict
confinement. Runtime paths under `/opt/aprsc/{etc,logs,data,web}` are
remapped via the snap `layout:` to `$SNAP_DATA` / `$SNAP_COMMON` so the
unmodified binary works inside the confinement.

Have fun!

- Hessu, OH7LZB

