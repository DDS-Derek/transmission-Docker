FROM alpine:3.17

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
    cp -r /usr/share/transmission/web/* /transmission-web-control && \
    mv /transmission-web-control/index.html /transmission-web-control/index.original.html && \
    mkdir /tmp/transmission-web-control && \
    curl \
        -sL https://github.com/transmission-web-control/transmission-web-control/releases/latest/download/dist.tar.gz | \
        tar xzvpf - --strip-components=1 -C /tmp/transmission-web-control && \
    cp -r /tmp/transmission-web-control/dist/* /transmission-web-control && \
    # Clear
    rm -rf \
        /var/cache/apk/* \
        /tmp/*

COPY --chmod=755 ./rootfs /

ENTRYPOINT [ "/init" ]
