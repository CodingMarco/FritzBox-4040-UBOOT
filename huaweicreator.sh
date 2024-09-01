#!/bin/bash -xe

BOARDNAME=$1

if [ -z "$BOARDNAME" ];
then
	echo "Usage: huaweicreator.sh <BOARDNAME>"
	exit 1
fi

UBOOT_ELF="u-boot"
UBOOT_ELF_FLASH="appsbl.bin"
UBOOT_BIN="u-boot.bin"
UBOOT_HUAWEI="uboot-${BOARDNAME}.bin"
UIMAGE_OUT="uImage"
HUAWEI_DTS="board/huawei/${BOARDNAME}.dts"
HUAWEI_DTB="${BOARDNAME}.dtb"
UBOOT_LOADADDR=0x84000000
UBOOT_ENTRYADDR=0x84000040
DTC="${DTC:-dtc}"

rm -f "$UBOOT_HUAWEI" "$UIMAGE_OUT"

cat "$UBOOT_BIN" >> "$UBOOT_HUAWEI"

# Compile DTS
$DTC "$HUAWEI_DTS" -o "$HUAWEI_DTB" --space 49152

# Append the compiled DTBs
cat "$HUAWEI_DTB" "$HUAWEI_DTB" "$HUAWEI_DTB" "$HUAWEI_DTB" >> $UBOOT_HUAWEI
rm -f "$HUAWEI_DTB"

mkimage -A arm -C none -T kernel -a "$UBOOT_LOADADDR" -e "$UBOOT_ENTRYADDR" -d "$UBOOT_BIN" "$UIMAGE_OUT"

# Strip symbols from u-boot ELF
arm-openwrt-linux-strip -s "$UBOOT_ELF"

cp "$UBOOT_ELF" "$UBOOT_ELF_FLASH"

# Pad ELF to partition size of 1MB to make it flashable with flashrom
dd if=/dev/zero of="$UBOOT_ELF_FLASH" bs=1 count=0 seek=1M

echo "Done."
