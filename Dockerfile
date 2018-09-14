FROM ubuntu:18.04
LABEL maintainer "Daniel Hancock <pheoxy@gmail.com>"

RUN \
    echo "**** Install build dependencies ****" && \
    apt-get update &&\
    apt-get install -y sudo time git-core subversion build-essential gcc-multilib libssl-dev\
                       libncurses5-dev zlib1g-dev gawk flex gettext wget unzip python &&\
    apt-get clean

RUN useradd -m openwrt &&\
    echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt

USER openwrt
WORKDIR /home/openwrt

# add build files
COPY build/ /home/openwrt

VOLUME /home/openwrt