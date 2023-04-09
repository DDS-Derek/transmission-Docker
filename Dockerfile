FROM alpine:3.17 AS build

ARG TRANSMISSION_VERSION

RUN apk add --no-cache --upgrade \
        build-base \
        python3 \
        gcc \
        linux-headers \
        g++ \
        make \
        git \
        make \
        gettext-dev \
        curl-dev \
        cmake \
        python3 \
        openssl-dev
RUN mkdir -p /rootfs/usr
RUN git clone -b ${TRANSMISSION_VERSION} https://github.com/transmission/transmission /build
WORKDIR /build
RUN git submodule update --init --recursive
WORKDIR /build/build
RUN cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX="/rootfs/usr" ..
RUN make
RUN make install
RUN rm -rf \
        /rootfs/usr/bin/transmission-create \
        /rootfs/usr/bin/transmission-edit \
        /rootfs/usr/bin/transmission-show

FROM alpine:3.17 AS APP

COPY --from=Build /rootfs/ /

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
