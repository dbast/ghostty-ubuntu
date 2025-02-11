ARG DISTRO_VERSION="24.10"
ARG DISTRO="ubuntu"
FROM ${DISTRO}:${DISTRO_VERSION}

# Install Dependencies
RUN DEBIAN_FRONTEND="noninteractive" apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install \
    # Build Tools
    build-essential \
    libbz2-dev \
    libonig-dev \
    lintian \
    lsb-release \
    minisign \
    pandoc \
    wget \
    # Ghostty Dependencies
    libadwaita-1-dev \
    libgtk-4-dev && \
    # Clean up for better caching
    rm -rf /var/lib/apt/lists/*

# Install zig
# https://ziglang.org/download/
ARG ZIG_VERSION="0.13.0"
RUN UNAME_M="$(uname -m)" && \
    ZIG_ARCH="$UNAME_M" && \
    if [ "${UNAME_M}" = "ppc64le" ]; then \
        ZIG_ARCH="powerpc64le"; \
    fi && \
    wget -q "https://ziglang.org/download/$ZIG_VERSION/zig-linux-${ZIG_ARCH}-$ZIG_VERSION.tar.xz" && \
    wget -q "https://ziglang.org/download/$ZIG_VERSION/zig-linux-${ZIG_ARCH}-$ZIG_VERSION.tar.xz.minisig" && \
    minisign -Vm "zig-linux-${ZIG_ARCH}-$ZIG_VERSION.tar.xz" -P "RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U" && \
    tar -xf "zig-linux-${ZIG_ARCH}-$ZIG_VERSION.tar.xz" -C /opt && \
    rm zig-linux-* && \
    ln -s "/opt/zig-linux-${ZIG_ARCH}-$ZIG_VERSION/zig" /usr/local/bin/zig
