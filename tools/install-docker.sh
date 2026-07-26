#!/bin/sh
# aprsc Docker/Podman one-liner installer.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-APRSC-Installer/main/tools/install-docker.sh | sudo sh
#
# Detects the OS and container runtime:
#   - Linux:  uses Docker (installs it if missing), pulls the multi-arch
#             image from ghcr.io/9m2pju/aprsc:latest
#   - FreeBSD: uses Podman (installs it if missing), builds the FreeBSD
#             image locally from Dockerfile.freebsd (no FreeBSD CI build
#             exists since GitHub Actions has no native FreeBSD runners)
#
# After install, edit /opt/aprsc/etc/aprsc.conf on the host (or whichever
# path you mounted) and the container will pick it up. The container runs
# in the foreground via the image entrypoint; this script starts it in
# the background with -d.
#
# Container image: ghcr.io/9m2pju/aprsc:latest  (Linux)
#                  locally built                (FreeBSD)

set -eu

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

log() {
	printf '[aprsc-docker] %s\n' "$*"
}

err() {
	printf '[aprsc-docker] ERROR: %s\n' "$*" >&2
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
	*) ARCH="$ARCH_RAW" ;;
esac

log "detected OS=$OS ARCH=$ARCH"

# Image name on GHCR (Linux only - FreeBSD builds locally).
IMAGE_LINUX="ghcr.io/9m2pju/aprsc:latest"
CONTAINER_NAME="aprsc"
CONF_DIR="/opt/aprsc/etc"
LOG_DIR="/opt/aprsc/logs"
DATA_DIR="/opt/aprsc/data"

# ---------------------------------------------------------------------------
# Linux: Docker
# ---------------------------------------------------------------------------

install_docker_debian() {
	log "installing Docker via apt"
	apt-get update -qq
	apt-get install -y -qq ca-certificates curl gnupg
	install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
	chmod a+r /etc/apt/keyrings/docker.asc
	. /etc/os-release 2>/dev/null || err "cannot read /etc/os-release"
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian ${VERSION_CODENAME} stable" \
		> /etc/apt/sources.list.d/docker.list
	apt-get update -qq
	apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

install_docker_fedora() {
	log "installing Docker via dnf"
	dnf install -y dnf-plugins-core
	dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

install_docker_arch() {
	log "installing Docker via pacman"
	pacman -Sy --noconfirm docker
}

ensure_docker() {
	if have docker; then
		log "Docker already installed"
		return
	fi

	if have apt-get; then
		install_docker_debian
	elif have dnf; then
		install_docker_fedora
	elif have pacman; then
		install_docker_arch
	else
		err "no supported package manager found to install Docker - please install Docker manually and re-run"
	fi

	# Start and enable Docker.
	systemctl enable --now docker 2>/dev/null || true
}

run_linux() {
	ensure_docker

	# Prepare host directories for the bind mounts. The container
	# reads aprsc.conf from /opt/aprsc/etc and writes logs to
	# /opt/aprsc/logs. Users edit /opt/aprsc/etc/aprsc.conf on the host.
	mkdir -p "$CONF_DIR" "$LOG_DIR" "$DATA_DIR"

	# Seed aprsc.conf from the example if it does not exist yet.
	if [ ! -f "$CONF_DIR/aprsc.conf" ]; then
		log "seeding $CONF_DIR/aprsc.conf from example"
		# Try to copy the example from the repo if available,
		# otherwise pull a default out of the image.
		if [ -f /usr/share/doc/aprsc/aprsc.conf.example ]; then
			cp /usr/share/doc/aprsc/aprsc.conf.example "$CONF_DIR/aprsc.conf"
		else
			docker run --rm --entrypoint cat "$IMAGE_LINUX" /opt/aprsc/etc/aprsc.conf \
				> "$CONF_DIR/aprsc.conf" 2>/dev/null || \
				log "WARNING: could not seed aprsc.conf - please create $CONF_DIR/aprsc.conf manually"
		fi
		# Comment out MagicBadness - it's an "operator attention" gate
		# that prevents aprsc from starting until the operator edits
		# the config. We've already seeded it, so disable the gate.
		sed -i 's/^MagicBadness/#MagicBadness/' "$CONF_DIR/aprsc.conf" 2>/dev/null || true
		log "edit $CONF_DIR/aprsc.conf (ServerId, PassCode, MyAdmin, MyEmail, Uplink) before starting"
	fi

	# Stop any existing container.
	docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

	log "pulling $IMAGE_LINUX"
	docker pull "$IMAGE_LINUX"

	log "starting container $CONTAINER_NAME"
	docker run -d \
		--name "$CONTAINER_NAME" \
		--restart unless-stopped \
		--cap-add=CAP_NET_BIND_SERVICE \
		--cap-add=CAP_SETUID \
		--cap-add=CAP_SETGID \
		--cap-add=CAP_SYS_CHROOT \
		--cap-add=CAP_SYS_RESOURCE \
		-p 14580:14580/tcp -p 14580:14580/udp \
		-p 10152:10152/tcp -p 10152:10152/udp \
		-p 8080:8080/udp \
		-p 14501:14501/tcp \
		-v "$CONF_DIR:/opt/aprsc/etc:ro" \
		-v "$LOG_DIR:/opt/aprsc/logs" \
		-v "$DATA_DIR:/opt/aprsc/data" \
		"$IMAGE_LINUX"

	log
	log "aprsc container started. Next steps:"
	log "  1. Edit $CONF_DIR/aprsc.conf (ServerId, PassCode, MyAdmin, MyEmail, Uplink)"
	log "  2. Restart the container: docker restart $CONTAINER_NAME"
	log "  3. Check logs: docker logs -f $CONTAINER_NAME"
	log "  4. Status page: http://localhost:14501/"
}

# ---------------------------------------------------------------------------
# FreeBSD: Podman
# ---------------------------------------------------------------------------

ensure_podman() {
	if have podman; then
		log "Podman already installed"
		return
	fi

	if have pkg; then
		log "installing Podman via pkg"
		pkg install -y podman
	else
		err "pkg(8) not found - please install ports/pkg and Podman manually, then re-run"
	fi

	# Enable jail-related services Podman needs on FreeBSD.
	sysrc podman_enable="YES" 2>/dev/null || true
}

run_freebsd() {
	ensure_podman

	# Prepare host directories for the bind mounts.
	mkdir -p "$CONF_DIR" "$LOG_DIR" "$DATA_DIR"

	# Seed aprsc.conf from the example if it does not exist yet.
	if [ ! -f "$CONF_DIR/aprsc.conf" ]; then
		log "seeding $CONF_DIR/aprsc.conf from example"
		if [ -f ./src/aprsc.conf ]; then
			cp ./src/aprsc.conf "$CONF_DIR/aprsc.conf"
		else
			log "WARNING: please create $CONF_DIR/aprsc.conf manually (no example found)"
		fi
		# Comment out MagicBadness - it's an "operator attention" gate
		# that prevents aprsc from starting until the operator edits
		# the config. We've already seeded it, so disable the gate.
		sed -i '' 's/^MagicBadness/#MagicBadness/' "$CONF_DIR/aprsc.conf" 2>/dev/null || \
			sed -i  's/^MagicBadness/#MagicBadness/' "$CONF_DIR/aprsc.conf" 2>/dev/null || true
	fi

	# FreeBSD image is not published to a registry (no FreeBSD CI runners).
	# Build it locally from Dockerfile.freebsd. We need the repo source
	# for the build - clone it if we are not already inside a checkout.
	if [ ! -f Dockerfile.freebsd ]; then
		log "cloning repo for FreeBSD image build"
		if have git; then
			git clone --depth 1 https://github.com/9M2PJU/9M2PJU-APRSC-Installer.git /tmp/aprsc-build
			cd /tmp/aprsc-build
		else
			err "git is required to build the FreeBSD image - please install git and re-run"
		fi
	fi

	IMAGE_LOCAL="aprsc-freebsd:latest"

	log "building FreeBSD image (this takes a few minutes)"
	podman build -f Dockerfile.freebsd -t "$IMAGE_LOCAL" .

	# Stop any existing container.
	podman rm -f "$CONTAINER_NAME" 2>/dev/null || true

	log "starting container $CONTAINER_NAME"
	podman run -d \
		--name "$CONTAINER_NAME" \
		--restart unless-stopped \
		--cap-add=CAP_NET_BIND_SERVICE \
		--cap-add=CAP_SETUID \
		--cap-add=CAP_SETGID \
		--cap-add=CAP_SYS_CHROOT \
		--cap-add=CAP_SYS_RESOURCE \
		-p 14580:14580/tcp -p 14580:14580/udp \
		-p 10152:10152/tcp -p 10152:10152/udp \
		-p 8080:8080/udp \
		-p 14501:14501/tcp \
		-v "$CONF_DIR:/opt/aprsc/etc:ro" \
		-v "$LOG_DIR:/opt/aprsc/logs" \
		-v "$DATA_DIR:/opt/aprsc/data" \
		"$IMAGE_LOCAL"

	log
	log "aprsc container started. Next steps:"
	log "  1. Edit $CONF_DIR/aprsc.conf (ServerId, PassCode, MyAdmin, MyEmail, Uplink)"
	log "  2. Restart the container: podman restart $CONTAINER_NAME"
	log "  3. Check logs: podman logs -f $CONTAINER_NAME"
	log "  4. Status page: http://localhost:14501/"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

need_root

case "$OS" in
	Linux)   run_linux ;;
	FreeBSD) run_freebsd ;;
	*)       err "unsupported OS '$OS' (supported: Linux, FreeBSD)" ;;
esac

log "done."
