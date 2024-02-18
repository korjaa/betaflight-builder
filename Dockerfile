FROM ubuntu:22.04
ARG DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y build-essential git curl && apt-get autoclean
RUN git config --global --add safe.directory '*'

ARG PROJ_DIR=/tmp/betaflight
RUN mkdir "$PROJ_DIR"
ADD "betaflight/mk/tools.mk" "$PROJ_DIR/"
ADD "betaflight/src/main/build/version.h" "$PROJ_DIR/src/main/build/"

ENV TOOLS_DIR=/usr/share
RUN OSFAMILY=linux \
	DL_DIR=/tmp \
	make -C "$PROJ_DIR" -f tools.mk arm_sdk_install \
	&& rm /tmp/*.tar.bz2

RUN mkdir -p /mnt/data/betaflight
WORKDIR /mnt/data/betaflight
