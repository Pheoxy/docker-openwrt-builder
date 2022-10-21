# Inherit from github actions base image.
FROM ghcr.io/pheoxy/openwrt-builder:main AS openwrt-builder-base

# Set source location enviroment variable.
ENV openwrtSrc /home/openwrt-builder/source

# This is an alternative to mounting our source code and configs as a volume.
RUN git clone https://github.com/openwrt/openwrt.git --depth 1 --branch openwrt-22.03 ${openwrtSrc}

# Update and install feeds.
RUN ${openwrtSrc}/scripts/feeds update -a
RUN ${openwrtSrc}/scripts/feeds install -a

# Add files builder.
ADD --chown=openwrt-builder:openwrt-builder config build ${openwrtSrc}/

# Our output volume
VOLUME /output

# Start build script.
CMD [ "/bin/bash" ]