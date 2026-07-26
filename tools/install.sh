#!/bin/sh
# aprsc one-liner installer.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/9M2PJU/aprsc/main/tools/install.sh | sudo sh
#
# Supports:
#   - Debian/Ubuntu (x86_64, i386): apt repository + binary package
#   - Fedora (x86_64): dnf repository + binary package
#   - Other Linux (amd64, arm64): build from source
#   - FreeBSD (amd64, arm64): build from source
#   - macOS (amd64, arm64): build from source
#
# After install, the binary lives in /opt/aprsc/sbin/aprsc and the
# example config in /opt/aprsc/etc/aprsc.conf.  See doc/INSTALLING.md
# and doc/CONFIGURATION.md for next steps.

set -eu

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

log() {
	printf '[aprsc] %s\n' "$*"
}

err() {
	printf '[aprsc] ERROR: %s\n' "$*" >&2
	exit 1
}

need_root() {
	if [ "$(id -u)" -ne 0 ]; then
		err "this script must be run as root (try: curl ... | sudo sh)"
	fi
}

have() {
	command -v "$1" >/dev/null 2>&1
}

# ---------------------------------------------------------------------------
# Platform detection
# ---------------------------------------------------------------------------

OS="$(uname -s)"
ARCH_RAW="$(uname -m)"

case "$ARCH_RAW" in
	x86_64|amd64) ARCH=amd64 ;;
	aarch64|arm64) ARCH=arm64 ;;
	i386|i486|i586|i686) ARCH=i386 ;;
	armv7l|armv6l) ARCH=armhf ;;
	*)
		# Unknown arch - keep the raw value, fall through to source build.
		ARCH="$ARCH_RAW" ;;
esac

log "detected OS=$OS ARCH=$ARCH"

# ---------------------------------------------------------------------------
# apt-based install (Debian / Ubuntu) - binary packages for x86_64 and i386
# ---------------------------------------------------------------------------

install_apt() {
	# Map distro + codename to the aprsc apt repo codename.
	. /etc/os-release 2>/dev/null || err "cannot read /etc/os-release"

	# ID is "debian" or "ubuntu"; VERSION_CODENAME is e.g. "noble", "bookworm".
	CODENAME="${VERSION_CODENAME:-}"
	[ -n "$CODENAME" ] || err "cannot determine distribution codename from /etc/os-release"

	case "$ID" in
		debian|ubuntu) ;;
		*) err "apt-based install only supports Debian/Ubuntu, got ID=$ID" ;;
	esac

	# Supported codenames per doc/INSTALLING.md.
	case "$CODENAME" in
		noble|jammy|focal|trixie|bookworm|bullseye) ;;
		*) err "unsupported $ID codename '$CODENAME' - please build from source instead" ;;
	esac

	case "$ARCH" in
		amd64|i386) ;;
		*) err "no apt binary packages for ARCH=$ARCH - please build from source instead" ;;
	esac

	log "installing aprsc apt package for $ID $CODENAME ($ARCH)"

	# GPG key: newer distros use the rsa4096 key, older ones the legacy key.
	case "$CODENAME" in
		noble|trixie)
			KEYID=D43AD4708A2DA1139F250B3294E40E5320D8AE3C ;;
		*)
			KEYID=C51AA22389B5B74C3896EF3CA72A581E657A2B8D ;;
	esac

	# Configure the apt source.
	APTLIST=/etc/apt/sources.list.d/aprsc.list
	cat > "$APTLIST" <<EOF
deb http://aprsc-dist.he.fi/aprsc/apt $CODENAME main
EOF

	# Import the signing key.  Prefer the modern signed-by approach, but
	# fall back to apt-key for very old distributions.
	if have gpg; then
		gpg --keyserver keyserver.ubuntu.com --recv "$KEYID" 2>/dev/null || true
		gpg --export "$KEYID" > /etc/apt/trusted.gpg.d/aprsc.key.gpg 2>/dev/null || true
	else
		apt-get update -qq 2>/dev/null || true
		apt-get install -y -qq gnupg 2>/dev/null || true
		gpg --keyserver keyserver.ubuntu.com --recv "$KEYID" 2>/dev/null || true
		gpg --export "$KEYID" > /etc/apt/trusted.gpg.d/aprsc.key.gpg 2>/dev/null || true
	fi

	apt-get update -qq
	apt-get install -y aprsc

	log "apt install complete. Edit /opt/aprsc/etc/aprsc.conf then:"
	log "  sudo systemctl enable aprsc && sudo systemctl start aprsc"
}

# ---------------------------------------------------------------------------
# dnf-based install (Fedora) - binary packages for x86_64
# ---------------------------------------------------------------------------

install_dnf() {
	case "$ARCH" in
		amd64) ;;
		*) err "no dnf binary packages for ARCH=$ARCH - please build from source instead" ;;
	esac

	log "installing aprsc dnf package for Fedora ($ARCH)"

	have curl || dnf install -y curl

	curl -fsSLo /etc/yum.repos.d/aprsc.repo http://he.fi/aprsc/down/aprsc-fedora.repo

	dnf install -y aprsc

	log "dnf install complete. Edit /opt/aprsc/etc/aprsc.conf then:"
	log "  sudo systemctl enable aprsc && sudo systemctl start aprsc"
}

# ---------------------------------------------------------------------------
# Source build (fallback for all other platforms / arches)
# ---------------------------------------------------------------------------

install_source() {
	log "building aprsc from source on $OS $ARCH"

	# Pick a build directory.
	BUILDROOT="${APRSC_BUILD_ROOT:-/tmp/aprsc-build}"
	rm -rf "$BUILDROOT"
	mkdir -p "$BUILDROOT"
	cd "$BUILDROOT"

	# Acquire the source tree.
	if have git; then
		git clone --depth 1 https://github.com/9M2PJU/aprsc.git aprsc
	else
		err "git is required for the source build - please install git and re-run"
	fi

	cd aprsc/src

	case "$OS" in
		Linux)
			# Detect the package manager for build deps.
			if have apt-get; then
				apt-get update -qq
				DEBIAN_FRONTEND=noninteractive apt-get install -y \
					gcc make autoconf automake libtool \
					libevent-dev libssl-dev libcap-dev zlib1g-dev libsctp-dev
			elif have dnf; then
				dnf install -y \
					@development-tools gcc make autoconf automake libtool \
					libevent-devel openssl-devel libcap-devel zlib-devel \
					lksctp-tools-devel protobuf-c-compiler protobuf-c-devel
			elif have apk; then
				apk add --no-cache gcc g++ make autoconf automake libtool \
					libevent-dev openssl-dev libcap-dev zlib-dev
			elif have pacman; then
				pacman -Sy --noconfirm base-devel libevent openssl libcap zlib
			else
				err "no supported package manager found - please install build dependencies manually (gcc, make, autoconf, automake, libtool, libevent2, openssl, zlib) and re-run"
			fi
			;;
		FreeBSD)
			if have pkg; then
				pkg install -y gcc gmake autoconf automake libevent2 openssl
			else
				err "pkg(8) not found - please install ports/pkg and the build dependencies (gcc, gmake, autoconf, automake, libevent2, openssl) manually"
			fi
			# libevent2 from ports lives under /usr/local.
			export CFLAGS="-I/usr/local/include"
			export LDFLAGS="-L/usr/local/lib/event2"
			# FreeBSD make is not GNU make - prefer gmake if available.
			MAKE="${MAKE:-gmake}"
			;;
		Darwin)
			# macOS: need libevent2 + openssl from Homebrew or MacPorts.
			if have brew; then
				brew install libevent openssl@3
				# Homebrew installs into /opt/homebrew on Apple Silicon,
				# /usr/local on Intel.
				BREW_PREFIX="$(brew --prefix)"
				export CFLAGS="-I${BREW_PREFIX}/include"
				export LDFLAGS="-L${BREW_PREFIX}/lib"
			elif have port; then
				port install libevent2 openssl3
				export CFLAGS="-I/opt/local/include"
				export LDFLAGS="-L/opt/local/lib"
			else
				err "neither Homebrew (brew) nor MacPorts (port) was found - please install one of them and libevent2 + openssl, then re-run"
			fi
			MAKE="${MAKE:-make}"
			;;
		*)
			err "unsupported OS '$OS' for source build" ;;
	esac

	# Configure, build, install.
	./configure
	${MAKE:-make} -j"$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 2)"
	${MAKE:-make} install

	log "source install complete. Binary: /opt/aprsc/sbin/aprsc"
	log "Edit /opt/aprsc/etc/aprsc.conf, then start aprsc."
	case "$OS" in
		Linux) log "  sudo systemctl enable aprsc && sudo systemctl start aprsc" ;;
		*)     log "  /opt/aprsc/sbin/aprsc -u root -t /opt/aprsc -f -e info -o file -r logs -c etc/aprsc.conf" ;;
	esac
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

need_root

case "$OS" in
	Linux)
		if [ -f /etc/debian_version ] && have apt-get; then
			case "$ARCH" in
				amd64|i386) install_apt ;;
				*) install_source ;;
			esac
		elif [ -f /etc/fedora-release ] && have dnf; then
			case "$ARCH" in
				amd64) install_dnf ;;
				*) install_source ;;
			esac
		else
			install_source
		fi
		;;
	FreeBSD)
		install_source
		;;
	Darwin)
		install_source
		;;
	*)
		err "unsupported OS '$OS' (supported: Linux, FreeBSD, macOS)" ;;
esac

log "done."
