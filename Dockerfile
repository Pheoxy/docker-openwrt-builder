# Use Alpine Linux 3.19 as the base image
FROM alpine:3.19

ARG OPENWRT_SOURCE_BRANCH

LABEL maintainer="Pheoxy"
LABEL org.opencontainers.image.source=https://github.com/Pheoxy/docker-openwrt-builder

ENV GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

RUN apk add --no-cache \
    'argp-standalone' \
    'asciidoc' \
    'bash' \
    'bc' \
    'binutils' \
    'bzip2' \
    'cdrkit' \
    'coreutils' \
    'diffutils' \
    'elfutils-dev' \
    'findutils' \
    'flex' \
    'g++' \
    'gawk' \
    'gcc' \
    'gettext' \
    'git' \
    'grep' \
    'gzip' \
    'intltool' \
    'libxslt' \
    'linux-headers' \
    'make' \
    'musl-fts-dev' \
    'musl-libintl' \
    'musl-obstack-dev' \
    'ncurses-dev' \
    'openssl-dev' \
    'patch' \
    'perl' \
    'python3-dev' \
    'rsync' \
    'tar' \
    'unzip' \
    'util-linux' \
    'wget' \
    'zlib-dev' \
  && \
  ln -s '/usr/lib/libncurses.so' '/usr/lib/libtinfo.so' && \
  addgroup 'builder' && \
  adduser -s '/bin/bash' -G 'builder' -D 'builder'

RUN mkdir /source /build /config /output
RUN chown builder:builder /source /build /config /output

USER builder

WORKDIR /source

RUN git clone https://github.com/openwrt/openwrt.git -b ${OPENWRT_SOURCE_BRANCH} /source

RUN ./scripts/feeds update -a
RUN ./scripts/feeds install -a

ENTRYPOINT [ "entrypoint.sh" ]