#!/bin/bash
# Build openwrt in docker container

# Enviroment
BUILDDIR=~/
GIT_BRANCH=openwrt-18.06

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

# Make output folders
mkdir -p $BUILDDIR/output

# Copy old config
cp $BUILDDIR/config.seed $BUILDDIR/source/.config

# Compile
./scripts/diffconfig.sh > diffconfig
cp diffconfig .config # write changes to .config
make defconfig;make oldconfig
make menuconfig
make download
make V=s > ../output/make.log

# Cleaning up for git
cp $BUILDDIR/source/.config $BUILDDIR/output/config.seed.new
cp $BUILDDIR/source/bin/targets/* $BUILDDIR/output/

echo "Build Success!"

exit 0
