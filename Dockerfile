FROM debian:12 AS builder

ARG S6_OVERLAY_VERSION=3.2.2.0
ARG TARGETARCH

RUN apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    git \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/xlxd
COPY src/ /opt/xlxd/src/
COPY config/ /opt/xlxd/config/

WORKDIR /opt/xlxd/src
RUN make clean || true
RUN make
RUN make install

FROM debian:12

ARG S6_OVERLAY_VERSION=3.2.2.0
ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive
ENV APACHE_PORT=80

RUN apt-get update && apt-get install -y \
    apache2 \
    ca-certificates \
    curl \
    libapache2-mod-php \
    php \
    php-xml \
    procps \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/xlxd
COPY --from=builder /xlxd/ /xlxd/
COPY config/ /opt/xlxd/config/
COPY dashboard1/ /var/www/dashboard1/
COPY dashboard2/ /var/www/dashboard2/

# s6-overlay install
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp/
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz

RUN case "${TARGETARCH}" in \
      amd64) S6_ARCH="x86_64" ;; \
      arm64) S6_ARCH="aarch64" ;; \
      *) echo "Unsupported TARGETARCH: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    curl -fsSL -o /tmp/s6-overlay-arch.tar.xz \
      "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" && \
    tar -C / -Jxpf /tmp/s6-overlay-arch.tar.xz && \
    rm -f /tmp/s6-overlay-*.tar.xz

COPY rootfs/ /
RUN chmod +x /healthcheck.sh
RUN chmod +x /etc/s6-overlay/s6-rc.d/xlxd/run
RUN chmod +x /etc/s6-overlay/s6-rc.d/apache2/run
RUN a2dissite 000-default.conf

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 CMD ["/healthcheck.sh"]

EXPOSE 80

ENTRYPOINT ["/init"]
