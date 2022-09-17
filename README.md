The Orange Pi One cannot boot from anything other than the SD card. Therefore, we will need to atleast burn an initial bootloader to the SD card, which can then load the next stage bootloader (or installer) from either a local partition on the SD card, or from an external USB drive (or indeed from over the network.)

This project simply automates the SD card image creation process, for the purpose of documentation and repeatability.

## Preqrequisites

* For building `genimage`:

    ```shell
    $ sudo apt install -y libconfuse-dev
    ```

* For U-boot, please consult the official docs [here](https://u-boot.readthedocs.io/en/latest/build/gcc.html).

## Installing Debian from external USB installation media

1) Build the `sdcard-bootloader-only.img` disk image:

    ```
    $ make -j $(nproc) images/sdcard-bootloader-only.img
    ```

2) You should now see the newly created file `images/sdcard-bootloader-only.img`.

    Copy this image directly to the SD card using `dd`.

3) Using [Rufus](https://rufus.ie) in ISO mode, burn the Debian [DVD](https://cdimage.debian.org/debian-cd/current/armhf/iso-dvd/) (or [CD](https://cdimage.debian.org/debian-cd/current/armhf/iso-cd/)) installation `.iso` file to an external thumb drive as you would do normally for a typical PC install.

4) Plug in the SD card into the Orange Pi One, and the USB thumb drive through a USB hub to the Orange Pi's USB port (since you will also need a keyboard for the installation process, and the Orange Pi One only has 1 USB port.)

5) U-boot should automatically detect the USB thumb drive and boot from it.

## Potential problems

```shell
git clone https://source.denx.de/u-boot/u-boot.git --depth 1 --branch v2022.07
Cloning into 'u-boot'...
fatal: unable to access 'https://source.denx.de/u-boot/u-boot.git/': server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
Makefile:25: recipe for target 'u-boot/' failed
make: *** [u-boot/] Error 128
```

I had this issue when trying to build the SD card image from an Ubuntu 16.04 installation. A simple workaround is the following:

```shell
$ export GIT_SSL_NO_VERIFY=true
```

*Source: [stackoverflow](https://stackoverflow.com/a/21407163)*

## Note regarding terminology

In Debian-land, two terms appear frequently "near" one another: "hd-media", and "netboot". As [this](https://askubuntu.com/a/422280) answer explains, "hd-media" refers to a booting mode when the installation media is located locally to the PC, whereas netboot is referred to the case when the installation media is located remotely, e.g. over tftp.

Note that in both cases though, the *installer* is available and presumed to have been booted into already. In this project, if you want to install the installer to the SD card and provide the `.iso` file on a separate thumb drive, you can invoke

```shell
$ make images/sdcard-hdmedia-only.img
```
