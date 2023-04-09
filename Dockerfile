FROM alpine:edge

ARG TRANSMISSION_VERSION

RUN set -ex && \
    apk add --no-cache \
        tzdata \
        bash \
        s6-overlay \
        findutils \
        p7zip \
        unzip \
        ca-certificates \
        coreutils \
        curl \
        jq \
        procps \
        shadow && \
    # Install transmission
    apk add --no-cache \
        transmission-cli==${TRANSMISSION_VERSION} \
        transmission-daemon==${TRANSMISSION_VERSION} && \
    # Add user
    mkdir /tr && \
    addgroup -S tr -g 911 && \
    adduser -S tr -G tr -h /tr -u 911 -s /bin/bash tr && \
    # Install transmission-web-control
    wget \
        https://github.com/ronggang/transmission-web-control/archive/refs/heads/master.zip \
        -O /tmp/master.zip && \
    unzip -d /tmp/tr_web /tmp/master.zip && \
    mv /usr/share/transmission/public_html/index.html /usr/share/transmission/public_html/index.original.html && \
    cp -r /tmp/tr_web/transmission-web-control-master/src/* /usr/share/transmission/public_html && \
    # Clear
    rm -rf \
        /var/cache/apk/* \
        /tmp/*

COPY --chmod=755 ./rootfs /

ENTRYPOINT [ "/init" ]
