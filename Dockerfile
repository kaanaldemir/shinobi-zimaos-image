ARG BASE_IMAGE=node:22-bookworm-slim
FROM ${BASE_IMAGE} AS ffmpeg-builder

ENV DEBIAN_FRONTEND=noninteractive

ARG FFMPEG_VERSION=n7.1.1

RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    curl \
    git \
    libdrm-dev \
    libfreetype6-dev \
    libgnutls28-dev \
    libnuma-dev \
    libva-dev \
    libvpl-dev \
    libx264-dev \
    libx265-dev \
    nasm \
    pkg-config \
    yasm \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch "${FFMPEG_VERSION}" https://git.ffmpeg.org/ffmpeg.git /tmp/ffmpeg

WORKDIR /tmp/ffmpeg
RUN ./configure \
    --prefix=/opt/ffmpeg \
    --disable-debug \
    --disable-doc \
    --enable-gpl \
    --enable-version3 \
    --enable-gnutls \
    --enable-libdrm \
    --enable-libfreetype \
    --enable-libvpl \
    --enable-libx264 \
    --enable-libx265 \
    --enable-shared \
    && make -j"$(nproc)" \
    && make install

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive
ENV LIBVA_DRIVER_NAME=iHD
ENV PATH=/opt/ffmpeg/bin:${PATH}
ENV LD_LIBRARY_PATH=/opt/ffmpeg/lib

ARG SHINOBI_BRANCH=dev
ARG SHINOBI_COMMIT=

RUN apt-get update && apt-get install -y \
    curl \
    default-mysql-client \
    git \
    i965-va-driver \
    intel-media-va-driver \
    libmfx1 \
    libdrm2 \
    libfreetype6 \
    libgnutls30 \
    libva-drm2 \
    libva2 \
    libvpl2 \
    libx264-164 \
    libx265-199 \
    mesa-va-drivers \
    onevpl-tools \
    procps \
    vainfo \
    libnuma1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ffmpeg-builder /opt/ffmpeg /opt/ffmpeg
RUN echo /opt/ffmpeg/lib > /etc/ld.so.conf.d/ffmpeg.conf \
    && ldconfig \
    && ln -sf /opt/ffmpeg/bin/ffmpeg /usr/local/bin/ffmpeg \
    && ln -sf /opt/ffmpeg/bin/ffprobe /usr/local/bin/ffprobe

RUN git clone --branch "${SHINOBI_BRANCH}" https://gitlab.com/Shinobi-Systems/Shinobi.git /opt/shinobi \
    && if [ -n "${SHINOBI_COMMIT}" ]; then \
        cd /opt/shinobi && git checkout "${SHINOBI_COMMIT}"; \
    fi

WORKDIR /opt/shinobi
RUN npm install && npm install pm2 -g

WORKDIR /home/Shinobi

COPY entrypoint.sh /entrypoint.sh
COPY scripts/ /scripts/
RUN chmod +x /entrypoint.sh /scripts/*.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
