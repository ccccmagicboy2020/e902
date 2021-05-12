#ifndef __MEMORY_LD_H__
#define __MEMORY_LD_H__
#include <config.h>
#ifdef CONFIG_SBUS_SRAM
 #define XBR820_SRAM_BASE	0x1f080000
 #define CONFIG_IBUS2SBUS_OFFSET	0
#else
 #define XBR820_SRAM_BASE	0x01000000
 #define CONFIG_IBUS2SBUS_OFFSET	0x1e080000	/* 0x1f080000-0x01000000 */
#endif
#define XBR820_SRAM_SIZE	0x00001000
#endif
