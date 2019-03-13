FROM ubuntu:18.04
LABEL maintainer "Pheoxy"

RUN apt-get update && \
    apt-get install -y build-essential libncurses5-dev python unzip gawk wget sudo git ccache && \
    apt-get clean

RUN useradd -m openwrt && \
    echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt

WORKDIR /home/openwrt

VOLUME /home/openwrt

USER openwrt
