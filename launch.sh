#!/bin/bash


qemu-system-aarch64 \
    -M raspi3b \
    -cpu cortex-a72 \
    -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 autologin=pi dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1" \
    -dtb custom.dtb \
    -sd 2024-03-12-raspios-bullseye-armhf-lite.img \
    -kernel kernel8.img \
    -serial stdio \
    -m 1G -smp 4 \
    -usb -device usb-mouse -device usb-kbd \
	-device usb-net,netdev=net0 \
	-netdev user,id=net0,hostfwd=tcp::5555-:22 \
