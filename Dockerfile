ARG BASE_IMAGE=node:22-bookworm-slim
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive
ENV LIBVA_DRIVER_NAME=iHD

ARG SHINOBI_BRANCH=dev
ARG SHINOBI_COMMIT=

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    default-mysql-client \
    ffmpeg \
    git \
    i965-va-driver \
    intel-media-va-driver \
    libmfx1 \
    libva-drm2 \
    libva2 \
    mesa-va-drivers \
    procps \
    vainfo \
    && rm -rf /var/lib/apt/lists/*

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
