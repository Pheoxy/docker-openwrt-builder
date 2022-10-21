# Inherit from github actions base image.
FROM ghcr.io/pheoxy/openwrt-builder:master AS openwrt-builder-base

# This is an alternative to mounting our source code and configs as a volume.
RUN git clone https://github.com/openwrt/openwrt.git --depth 1 --branch openwrt-22.03 /source

# Update and install feeds.
RUN ./scripts/feeds update -a
RUN ./scripts/feeds install -a

# Add BUILD_TARGET .configs to builder.
ADD --chown=${GITHUB_ACTOR}:${BGITHUB_ACTOR} config build /source/

# Our output volume
VOLUME /output

# Start build script.
CMD [ "/source/build.sh" ]
