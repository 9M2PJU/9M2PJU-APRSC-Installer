# Multi-arch Docker image for aprsc (9M2PJU fork).
#
# Builds aprsc from source on debian:12-slim in a builder stage, then
# copies only the install tree into a minimal runtime image with the
# shared libraries aprsc links against.
#
# Users mount their own aprsc.conf at /opt/aprsc/etc/aprsc.conf.

# ---------- builder ----------
FROM debian:12-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc make autoconf automake libtool \
        libevent-dev libssl-dev libcap-dev zlib1g-dev libsctp-dev \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . /src/

# Build aprsc. The install tree lands under /out/opt/aprsc.
RUN cd src \
    && ./configure \
    && make -j"$(nproc)" \
    && make DESTDIR=/out install

# ---------- runtime ----------
FROM debian:12-slim AS runtime

# Runtime shared libraries aprsc links against.
RUN apt-get update && apt-get install -y --no-install-recommends \
        libevent-2.1-7 \
        libssl3 \
        libcap2 \
        zlib1g \
        libsctp1 \
    && rm -rf /var/lib/apt/lists/*

# Copy the built install tree.
COPY --from=builder /out/opt/aprsc /opt/aprsc

# Create runtime directories and a non-root user. aprsc requires -u
# <user> when using -t (chroot) - the two are paired security features.
RUN set -e \
    && mkdir -p /opt/aprsc/etc /opt/aprsc/logs /opt/aprsc/data \
    && useradd --system --no-create-home --shell /usr/sbin/nologin aprsc \
    && chown -R aprsc:aprsc /opt/aprsc/etc /opt/aprsc/logs /opt/aprsc/data

# APRS-IS ports:
#   14580  TCP/UDP  client/igate port (user-specified filters)
#   10152  TCP/UDP  full feed
#   8080   UDP      packet submission
#   14501  TCP      HTTP status page
EXPOSE 14580/udp 14580/tcp 10152/udp 10152/tcp 8080/udp 14501/tcp

VOLUME ["/opt/aprsc/etc", "/opt/aprsc/logs", "/opt/aprsc/data"]

# Run aprsc in the foreground (no -f flag = don't daemonize), chrooted
# to /opt/aprsc, dropping privileges to the aprsc user. Logs go to
# /opt/aprsc/logs (relative to the chroot, so -r logs resolves to
# /opt/aprsc/logs).
#
# aprsc tries to set POSIX capabilities (CAP_NET_BIND_SERVICE,
# CAP_SETUID, CAP_SETGID, CAP_SYS_CHROOT) at startup. Inside an
# unprivileged container this fails with "Operation not permitted",
# but aprsc treats it as a non-fatal warning. The container must be
# run with --cap-add=CAP_NET_BIND_SERVICE to bind ports < 1024.
ENTRYPOINT ["/opt/aprsc/sbin/aprsc", "-u", "aprsc", "-t", "/opt/aprsc", \
            "-e", "info", "-o", "file", "-r", "logs", \
            "-c", "etc/aprsc.conf"]
