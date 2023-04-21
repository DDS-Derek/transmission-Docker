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
    wget \
        https://github.com/ronggang/transmission-web-control/archive/refs/heads/master.zip \
        -O /tmp/master.zip && \
    unzip -d /tmp/tr_web /tmp/master.zip && \
    mv /usr/share/transmission/web/index.html /usr/share/transmission/web/index.original.html && \
    cp -r /tmp/tr_web/transmission-web-control-master/src/* /usr/share/transmission/web && \
    # Clear
    rm -rf \
        /var/cache/apk/* \
        /tmp/*

COPY --chmod=755 ./rootfs /

ENTRYPOINT [ "/init" ]
