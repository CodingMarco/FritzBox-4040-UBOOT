/*
 * Configuration for the AVM Fritz!Repeater 1200
 */

#ifndef __CONFIG_H
#define __CONFIG_H

#include <configs/ipq40xx_cdp.h>

#define CONFIG_MODEL_HUAWEI_AP4050DN
#define CONFIG_MODEL		"AP4050DN"
#define MTDIDS_DEFAULT		"nand0=nand0" // TODO
#define MTDPARTS_DEFAULT	"mtdparts=nand0:256k(0:SBL1),256k(0:MIBIB),512k(0:QSEE),256k(0:CDT),256k(0:DDRPARAMS),1024k(0:APPSBL),256k(0:ART),256k(0:APPSBLENV),512k(ResultA),2560k(configA),1024k(bootimageA),25600k(SysImageA),256k(1:SBL1),256k(1:MIBIB),512k(1:QSEE),256k(1:CDT),256k(1:DDRPARAMS),1024k(1:APPSBL),512k(Reservel),512k(ResultB),2560k(configB),1024k(bootimageB),25600k(SysImageB)"

#undef CONFIG_BOOTDELAY
#define CONFIG_BOOTDELAY 3

#undef CONFIG_BOOTCOMMAND
#define CONFIG_BOOTCOMMAND		"run huaweiboot" // TODO

#define CONFIG_MAC_PARTITION "ResultA"  // TODO: ???

#define CONFIG_EXTRA_ENV_SETTINGS				\
	"mtdids=" MTDIDS_DEFAULT "\0"				\
	"mtdparts=" MTDPARTS_DEFAULT "\0"			\
	"tftpboot=tftpboot && bootm; sleep 5; run tftpboot\0"	\
	"nandboot=nboot SysImageA && bootm\0"			\
	"huaweiboot=run nandboot;\0"		\
	"bootargs=console=ttyMSM0,115200n8 root=/dev/mtdblock24 rootfstype=squashfs\0"		\

#undef V_PROMPT
#define V_PROMPT		"(" CONFIG_MODEL ") # "

#define CONFIG_SERVERIP         192.168.1.10
#define CONFIG_NETMASK          255.255.255.0
#define CONFIG_BOOTFILE         CONFIG_MODEL ".bin"
#define CONFIG_LZO
#define CONFIG_LZMA
#define CONFIG_SYS_LONGHELP

#define CONFIG_CMD_MISC
#define CONFIG_CMD_ELF
#define CONFIG_CMD_IMI
#define CONFIG_CMD_LOADB
#define CONFIG_CMD_SPI
#define CONFIG_CMD_TFTPSRV

#undef CONFIG_SYS_LOAD_ADDR
#define CONFIG_SYS_LOAD_ADDR    0x88000000

#undef CONFIG_SYS_TEXT_BASE
#define CONFIG_SYS_TEXT_BASE	0x84000040

#define DEBUG

#endif
