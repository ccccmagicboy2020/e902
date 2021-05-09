#ifndef __FLASH_CONFIG_H__
#define __FLASH_CONFIG_H__
#include "config.h"

/**
 * b23 ~ b16 : manufacturer ID
 * b15 ~ b08 : memory type
 * b07 ~ b00 : memory density
 */
#define XT25F02E_JEDEC_ID	(0x000B4012)
#define XT25F02E_SIZE		(0x40000)
#define XT25F04B_JEDEC_ID	(0x000B4013)
#define XT25F04B_SIZE		(0x80000)
#define P25Q05_JEDEC_ID		(0x00856010)
#define P25Q05_SIZE			(0x10000)
#define P25Q10_JEDEC_ID		(0x00856011)
#define P25Q10_SIZE			(0x20000)
#define P25Q20_JEDEC_ID		(0x00856012)
#define P25Q20_SIZE			(0x40000)
#define P25Q40_JEDEC_ID		(0x00856013)
#define P25Q40_SIZE			(0x80000)
#define GD25D05C_JEDEC_ID	(0x00C84010)
#define GD25D05C_SIZE		(0x10000)
#define GD25D10C_JEDEC_ID	(0x00C84011)
#define GD25D10C_SIZE		(0x20000)

#ifndef CONFIG_SF_CHIP_ALL
 #define SF_ID(n)			n##_JEDEC_ID
 #define SF_SIZE(n)			n##_SIZE
// #define SF_CHIP_NAME		"xbr820_gd25d10c"
// #define SF_CHIP_ID			SF_ID(GD25D10C)
// #define SF_CHIP_SIZE		SF_SIZE(GD25D10C)
 #define SF_CHIP_NAME		"xbr820_xt25f04b"
 #define SF_CHIP_ID			SF_ID(XT25F04B)
 #define SF_CHIP_SIZE		SF_SIZE(XT25F04B)
// #define SF_CHIP_NAME		"xbr820_p25q10"
// #define SF_CHIP_ID			SF_ID(P25Q10)
// #define SF_CHIP_SIZE		SF_SIZE(P25Q10)
// #define SF_CHIP_NAME		"xbr820_p25q20"
// #define SF_CHIP_ID			SF_ID(P25Q20)
// #define SF_CHIP_SIZE		SF_SIZE(P25Q20)
#endif

#ifndef SF_CHIP_NAME
 #define SF_CHIP_NAME		"xbr820_spiflash"
#endif

#ifndef SF_CHIP_ID
 #define SF_CHIP_ID			(0x21063030)
#endif

#ifndef SF_CHIP_SIZE
 #define SF_CHIP_SIZE		(1 << 18)	// 256KB
#endif

#ifndef SF_SECT_SIZE
 #define SF_SECT_SIZE		(1 << 11)	// 2KB
#endif

#ifndef SF_BLOCK_SIZE
 #define SF_BLOCK_SIZE		(1 << 16)	// 64KB
#endif

#ifndef SF_PAGE_SIZE
 #define SF_PAGE_SIZE		(1 << 8)
#endif


#define COMMON_INS_WRSR		0x01	/* Common write status instruction */
#define COMMON_INS_PP		0x02	/* Common page program instruction */
#define COMMON_INS_READ		0x03	/* Common read instruction */
#define COMMON_INS_WRDI		0x04	/* Common write disable instruction */
#define COMMON_INS_RDSR		0x05	/* Common read status instruction */
#define COMMON_INS_WREN		0x06	/* Common write enable instruction */
#define COMMON_INS_FARD		0x0B	/* Common fast read instruction */
#define COMMON_INS_RES		0xAB	/* Common release from deep power-down & read device id instruction */
#define COMMON_INS_DP		0xB9	/* Common deep power-down instruction */
#define COMMON_INS_BE		0xC7	/* Common bulk erase instruction */
#define COMMON_INS_SE		0xD8	/* Common sector erase instruction */
#define COMMON_INS_FARDD	0x3B	/* Common fast read dual-output instruction */
#define COMMON_INS_RDID		0x90	/* Common read ID instruction */
#define COMMON_INS_JEDEC	0x9F	/* Common read JEDEC ID instruction */

#define COMMON_INS_EN4B		0xB7	/* Common enter 4byte mode instruction */
#define COMMON_INS_EX4B		0xE9	/* Common exit 4byte mode instruction */

#ifndef SF_CMD_READ
 #define SF_CMD_READ		COMMON_INS_FARDD
#endif

#endif // __FLASH_CONFIG_H__
