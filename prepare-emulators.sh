#!/bin/bash

IMAGE_FILE="2024-03-15-raspios-bookworm-armhf-lite.img"
DTB_FILE="bcm2710-rpi-3-b.dtb"
KERNEL_FILE="kernel8.img"
BASE_DIR=$(pwd)
MOUNT_BASE="/mnt/image"
NUM_OF_EMULATORS=4
PI_PASSWORD="pi"

# Create pi directories and mount points

echo "Creating mount points..."
for i in {1..4}
do
	mkdir -p "pi$i"
	sudo mkdir -p "${MOUNT_BASE}/pi$i"
done
echo "Done!"

# Process each directory
echo "Processing each directory"
for i in {1..4}
do
	cd "pi$i"

	# copy .img file
	echo "Copying neccessary files..."
	cp "${BASE_DIR}/${IMAGE_FILE}" .
	cp "${BASE_DIR}/${DTB_FILE}" .
	cp "${BASE_DIR}/${KERNEL_FILE}" .
	
	# default sector size
	OFFSET=$(($((8192 * 512))))

	# mount the image to the previously created mount point
	echo "Mounting image..."
	sudo mount -o loop,offset=${OFFSET} "${IMAGE_FILE}" "${MOUNT_BASE}/pi$i/"

	# setup ssh password
	echo "Setting up default pass..."
	ENCRYPTED_PASS=$(echo "$PI_PASSWORD" | openssl passwd -6 -stdin)
	echo "pi:${ENCRYPTED_PASS}" | sudo tee "${MOUNT_BASE}/pi$i/userconf"
	sudo touch "${MOUNT_BASE}/pi$i/ssh"


	# resize the image file
	echo "Resizing image..."
	qemu-img resize "${IMAGE_FILE}" 8G

	# recompile the Device Tree Blob to fix usbnet error
	echo "Compiling custom DTB..."
	cp "${DTB_FILE}" custom.dtb
	dtmerge custom.dtb merged.dtb - uart0=on
	mv merged.dtb custom.dtb
	dtmerge custom.dtb merged.dtb "${MOUNT_BASE}/pi$i/overlays/disable-bt.dtbo"
	mv merged.dtb custom.dtb

	cd "${BASE_DIR}"
done

echo "Setup completed for "${NUM_OF_EMULATORS}" emulators."
	
