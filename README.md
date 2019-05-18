[appurl]: https://openwrt.org/
[hub]: https://hub.docker.com/r/pheoxy/openwrt-builder/

# pheoxy/openwrt-builder

![OpenWrt Project](https://openwrt.org/lib/tpl/openwrt/images/logo.png)

The OpenWrt Project is a Linux operating system targeting embedded devices. Instead of trying to create a single, static firmware, OpenWrt provides a fully writable filesystem with package management. This frees you from the application selection and configuration provided by the vendor and allows you to customize the device through the use of packages to suit any application. For developers, OpenWrt is the framework to build an application without having to build a complete firmware around it; for users this means the ability for full customization, to use the device in ways never envisioned.

## Usage

```
docker run \
-itd \
--name=openwrt-builder \
-e PUID=<UID> -e PGID=<GID> \
-v /etc/localtime:/etc/localtime:ro \
-v </path/to/config>:/home/openwrt \
pheoxy/openwrt-builder
```

## Building

You will need to get shell access so that you can start building.
```
docker exec -it openwrt-builder /bin/bash
```

Now just download the openwrt source now that the build envrioment is setup, commands are:

```
git clone https://git.openwrt.org/openwrt/openwrt.git/
cd openwrt

./scripts/feeds update -a
./scripts/feeds install -a

make menuconfig
make
```

## Parameters

* `-e PGID=` for for GroupID - see below for explanation
* `-e PUID=` for for UserID - see below for explanation
* `-v /etc/localtime:/etc/localtime:ro` - for timezone information from host
* `-v /home/openwrt` - openwrt-builder Source Location. *This can grow very large, 1G+ is likely for a large collection.*

## Setup ccache (**_Recommended_**)
Update symlinks within docker container:

```
sudo /usr/sbin/update-ccache-symlinks
```

Set ccache into the enviroment `PATH`

```
echo 'export PATH="/usr/lib/ccache:$PATH"' | tee -a ~/.bashrc
```

Set source `bashrc` to test the new `PATH`

```
source ~/.bashrc && echo $PATH
```

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" <sup>TM</sup>.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Info

* Shell access whilst the container is running: `docker exec -it openwrt-builder /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f openwrt-builder`

## Versions
+ **19.05.19:** Upgrade base to Ubuntu 19.04 for gcc 8.3.0 and binutils 2.32
+ **13.03.19:** Fixes for build environment and add ccache
+ **15.09.18:** Initial Build.
