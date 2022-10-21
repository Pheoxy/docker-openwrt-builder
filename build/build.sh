#!/usr/bin/env bash

SOURCE_PATH="/home/openwrt-builder/source"
OUTPUT_PATH="/home/openwrt-builder/output"

# Move to source directory.
cd $SOURCE_PATH

prepare() {
    if [ "$OLD_CONFIG" = y ]; then
        echo -e "using old .config..."
        cp "$SOURCE_PATH"/"$BUILD_TARGET"/.config "$SOURCE_PATH"/.config
    fi

    if [ "$EXTRA_CONFIG" = y ]; then
        echo -e "add extra options..."
        cat "$SOURCE_PATH"/extra.config >>"$SOURCE_PATH"/.config
    fi

    # Always run defconfig to fix .config and allow using seeds.
    make defconfig

    if [ "$MENU_CONFIG" = y ]; then
        echo -e "starting menu config..."
        make menuconfig
    fi
}

build() {
    # Make output folders
    echo -e "$LIGHT_CYAN--> Starting compile... $NC"
    mkdir -p "$OUTPUT_PATH"/"$BUILD_TARGET"
    ./scripts/diffconfig.sh >"$OUTPUT_PATH"/"$BUILD_TARGET"/config.builddiff

    # Check for debug and compile
    if [ "$DEBUG" = y ]; then
        echo -e "running with debug enabled"
        # time ionice -c 3 nice -n 20 make -j1 V=s 2>&1 | tee $OUTPUT_PATH/make.log | grep -i error
        time ionice -c 3 nice -n 20 make -j1 V=s 2>&1 | tee "$OUTPUT_PATH"/"$BUILD_TARGET"/make.log
    else
        make download
        time ionice -c 3 nice -n 19 make -j"$CORES"
    fi
}

package() {
    # Copying to output folder
    echo -e "$LIGHT_CYAN--> Copying files to output folder $OUTPUT_PATH/$BUILD_TARGET $NC"
    cp -r "$SOURCE_PATH"/bin/targets/* "$OUTPUT_PATH"/"$BUILD_TARGET"/
    # sed -i '/^#/d' $SOURCE_PATH/output/$(date +%Y%m%d%H%M)/generic/config.seed
}

prepare
build
package

exit 0
