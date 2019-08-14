FROM ubuntu:19.04
LABEL maintainer "Pheoxy"

RUN apt update && \
    apt install -y build-essential libncurses5-dev python unzip gawk wget sudo git ccache && \
    apt clean

RUN useradd -m openwrt && \
    echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt

WORKDIR /home/openwrt
VOLUME /home/openwrt
USER openwrt
