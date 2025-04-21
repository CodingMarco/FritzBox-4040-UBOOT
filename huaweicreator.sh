#!/bin/bash -xe

BOARDNAME=$1

if [ -z "$BOARDNAME" ];
then
	echo "Usage: huaweicreator.sh <BOARDNAME>"
	exit 1
fi

UBOOT_BIN="u-boot.bin"
UBOOT_BIN_RAMBOOT="u-boot_ramboot.bin"
UBOOT_HUAWEI="uboot-${BOARDNAME}.bin"
UIMAGE_OUT="uImage"
UIMAGE_RAMBOOT_OUT="uImageRamboot"
UBOOT_LOADADDR=0x84000000
UBOOT_ENTRYADDR=0x84000040
UBOOT_LOADADDR_RAMBOOT=0x84000020
UBOOT_ENTRYADDR_RAMBOOT=0x84000060

rm -f "$UBOOT_HUAWEI" "$UIMAGE_OUT"

cat "$UBOOT_BIN" >> "$UBOOT_HUAWEI"

mkimage -A arm -C none -T kernel -a "$UBOOT_LOADADDR" -e "$UBOOT_ENTRYADDR" -d "$UBOOT_BIN" "$UIMAGE_OUT"
mkimage -A arm -C none -T kernel -a "$UBOOT_LOADADDR_RAMBOOT" -e "$UBOOT_ENTRYADDR_RAMBOOT" -d "$UBOOT_BIN_RAMBOOT" "$UIMAGE_RAMBOOT_OUT.tmp"

# Pad 0x20 extra bytes before ramboot image
dd if=/dev/zero of="$UIMAGE_RAMBOOT_OUT" bs=1 count=$((0x20))
cat "$UIMAGE_RAMBOOT_OUT.tmp" >> "$UIMAGE_RAMBOOT_OUT"
rm -f "$UIMAGE_RAMBOOT_OUT.tmp"

# Pad uImage file to 512kB zeros (otherwise u-boot will halt at something something hashtable)
dd if=/dev/zero of="$UIMAGE_OUT" bs=1 count=0 seek=512k

echo "Done."
