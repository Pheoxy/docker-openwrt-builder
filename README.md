# pheoxy/docker-openwrt-builder

[![GitHub Stars](https://img.shields.io/github/stars/pheoxy/docker-openwrt-builder.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/pheoxy/docker-openwrt-builder)
[![GitHub Package Repository](https://img.shields.io/static/v1.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=pheoxy&message=GitHub%20Package&logo=github)](https://github.com/pheoxy/docker-openwrt-builder/packages)

![OpenWrt Project](https://openwrt.org/lib/tpl/openwrt/images/logo.png)

The OpenWrt Project is a Linux operating system targeting embedded devices. Instead of trying to create a single, static firmware, OpenWrt provides a fully writable filesystem with package management. This frees you from the application selection and configuration provided by the vendor and allows you to customize the device through the use of packages to suit any application. For developers, OpenWrt is the framework to build an application without having to build a complete firmware around it; for users this means the ability for full customization, to use the device in ways never envisioned.

## Usage

```bash
docker run \
--name=openwrt-builder \
-v ./output:/output \
ghcr.io/pheoxy/docker-openwrt-builder
```

## Building

You will need to get shell access so that you can start building.

```bash
docker exec -it openwrt-builder /bin/sh
```

Now just run the build commands:

```bash
make menuconfig
make
```

## Parameters

* `-v ./output:/output` - openwrt-builder image output location.

## Info

* Shell access whilst the container is running: `docker exec -it openwrt-builder /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f openwrt-builder`

## Versions

* **1.03.24:** Initial Build
