#!/bin/bash
# Build an updated Archer C7 V2 Openwrt Image

# Enviroment
BUILDDIR=~/Development/openwrt-archer-c7-v2-builder
MAKECORES=6
GIT_BRANCH=master

# Stop on error
set -e

# Git clone openwrt source
if [ ! -d source/ ]
then
    git clone https://git.openwrt.org/openwrt/openwrt.git source -b $GIT_BRANCH
    cd $BUILDDIR/source

    ./scripts/feeds update -a
    ./scripts/feeds install -a
else
    echo "Found source/ directory from previous git clone"
    echo "Skipping..."
    echo "Pulling updates from git and cleaning source/"

    cd $BUILDDIR/source
    rm -rf feeds/*
    rm -rf package/*

    git fetch origin
    git reset --hard origin/$GIT_BRANCH
    git clean -f -d
    git pull

    make distclean

    ./scripts/feeds update -a
    ./scripts/feeds install -a

fi

#cp -r ../files ./

# Copy old config
cp $BUILDDIR/config.seed $BUILDDIR/source/.config

# Patch & customize
#for patchfile in `ls ../patches`; do
#    echo "Applying patch: $patchfile"
#    patch -p1 < ../patches/$patchfile
#done

# Compile
./scripts/diffconfig.sh > diffconfig
cp diffconfig .config # write changes to .config
make defconfig;make oldconfig
make menuconfig
make download
make -j$MAKECORES V=s > ../output/make.log

# Cleaning up for git
mkdir -p $BUILDDIR/output
#rm -rf $BUILDDIR/openwrt-archer-c7-v2/files/*
#rm -f $BUILDDIR/openwrt-archer-c7-v2/patches/*
#cp $BUILDDIR/patches/* $BUILDDIR/openwrt-archer-c7-v2/patches/
#cp -r $BUILDDIR/files/* $BUILDDIR/openwrt-archer-c7-v2/files/
cp $BUILDDIR/source/.config $BUILDDIR/output/config.seed.new
cp $BUILDDIR/source/bin/targets/ath79/generic/* $BUILDDIR/output/

echo "Copied files to $BUILDDIR/openwrt-archer-c7-v2"
echo "Build Success!"

exit 0
