MAKEFILE_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

HD_MEDIA_URL := https://ftp.debian.org/debian/dists/Debian11.5/main/installer-armhf/current/images/hd-media/hd-media.tar.gz

TOOLCHAIN := gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf

# Make sure that U-boot build system will be able to find our ARM
# toolchain
PATH := $(MAKEFILE_DIR)/$(TOOLCHAIN)/bin:$(PATH)

PROCESSES := $(shell nproc)

.PHONY: all clean

all: images/sdcard-bootloader-only.img

$(TOOLCHAIN).tar.xz:
	wget https://developer.arm.com/-/media/Files/downloads/gnu-a/10.3-2021.07/binrel/$@

$(TOOLCHAIN)/: $(TOOLCHAIN).tar.xz
	tar -xf $< \
	&& touch $@

u-boot/:
	git clone https://source.denx.de/u-boot/u-boot.git --depth 1 --branch v2022.07

u-boot/.config: u-boot/ $(TOOLCHAIN)/
	$(MAKE) -C u-boot/ CROSS_COMPILE=arm-none-linux-gnueabihf- orangepi_one_defconfig

u-boot/u-boot-sunxi-with-spl.bin: u-boot/.config $(TOOLCHAIN)/
	$(MAKE) -C u-boot/ CROSS_COMPILE=arm-none-linux-gnueabihf-

genimage/:
	git clone https://github.com/pengutronix/genimage.git \
	&& git -C genimage checkout be093f4

genimage/genimage: genimage/
	cd genimage/ \
	&& ./autogen.sh \
	&& ./configure \
	&& $(MAKE)

images/:
	mkdir $@

hd-media.tar.gz:
	wget $(HD_MEDIA_URL)

hd-media/:
	mkdir $@ \
	&& touch $@

hd-media/boot.scr: hd-media.tar.gz hd-media/
	tar -C hd-media/ -xf $< \
	&& touch $@

images/sdcard-hdmedia-only.img: images/ u-boot/u-boot-sunxi-with-spl.bin genimage/genimage sdcard-hdmedia-only.cfg hd-media/boot.scr
	genimage/genimage --config sdcard-hdmedia-only.cfg --input u-boot/

images/sdcard-bootloader-only.img: images/ u-boot/u-boot-sunxi-with-spl.bin genimage/genimage sdcard-bootloader-only.cfg
	genimage/genimage --config sdcard-bootloader-only.cfg --input u-boot/

clean:
	rm -rf \
		$(TOOLCHAIN)/ \
		$(TOOLCHAIN).tar.xz \
		u-boot/ \
		genimage/ \
		images/ \
		tmp/ \
		hd-media.tar.gz \
		hd-media/
