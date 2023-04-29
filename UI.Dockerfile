FROM alpine:edge

ARG TRANSMISSION_VERSION

ENV PS1="\[\e[32m\][\[\e[m\]\[\e[36m\]\u \[\e[m\]\[\e[37m\]@ \[\e[m\]\[\e[34m\]\h\[\e[m\]\[\e[32m\]]\[\e[m\] \[\e[37;35m\]in\[\e[m\] \[\e[33m\]\w\[\e[m\] \[\e[32m\][\[\e[m\]\[\e[37m\]\d\[\e[m\] \[\e[m\]\[\e[37m\]\t\[\e[m\]\[\e[32m\]]\[\e[m\] \n\[\e[1;31m\]$ \[\e[0m\]" \
    S6_SERVICES_GRACETIME=30000 \
    S6_KILL_GRACETIME=60000 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_SYNC_DISKS=1 \
    TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=1000 \
    LANG=zh_CN.UTF-8

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
    mkdir -p /transmission-web-control/ && \
    cp -r /usr/share/transmission/public_html/* /transmission-web-control && \
    mv /transmission-web-control/index.html /transmission-web-control/index.original.html && \
    mkdir /tmp/transmission-web-control && \
    curl \
        -sL https://github.com/transmission-web-control/transmission-web-control/releases/latest/download/dist.tar.gz | \
        tar xzvpf - --strip-components=1 -C /tmp/transmission-web-control && \
    cp -r /tmp/transmission-web-control/dist/* /transmission-web-control && \
    # Install transmissionic
    TRANSMISSIONIC_VERSION=$(curl -s "https://api.github.com/repos/6c65726f79/Transmissionic/releases/latest" | jq -r .tag_name) && \
    curl -sL "https://github.com/6c65726f79/Transmissionic/releases/download/${TRANSMISSIONIC_VERSION}/Transmissionic-webui-${TRANSMISSIONIC_VERSION}.zip" | busybox unzip -d /tmp - && \
    mv /tmp/web /transmissionic && \
    # Install combustion
    curl -sL "https://github.com/Secretmapper/combustion/archive/release.zip" | busybox unzip -d / - && \
    mv /combustion-release /combustion && \
    # Install kettu
    mkdir /kettu && \
    curl -sL "https://github.com/endor/kettu/archive/master.tar.gz" | tar xzvpf - --strip-components=1 -C /kettu && \
    # Install flood
    mkdir /flood && \
    curl -sL "https://github.com/johman10/flood-for-transmission/releases/download/latest/flood-for-transmission.tar.gz" | tar xzvpf - --strip-components=1 -C /flood && \
    # Clear
    rm -rf \
        /var/cache/apk/* \
        /tmp/*

COPY --chmod=755 ./rootfs /

ENTRYPOINT [ "/init" ]
