The Orange Pi One cannot boot from anything other than the SD card. Therefore, we will need to atleast burn an initial bootloader to the SD card, which can then load the next stage bootloader (or installer) from either a local partition on the SD card, or from an external USB drive (or indeed from over the network.)

This project simply automates the SD card image creation process, for the purpose of documentation and repeatability.

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
