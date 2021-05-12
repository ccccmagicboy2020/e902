#ifndef __MEMORY_LD_H__
#define __MEMORY_LD_H__
#include <config.h>
#ifdef CONFIG_SBUS_SRAM
 #define XBR820_SRAM_BASE	0x1f080000
#else
 #define XBR820_SRAM_BASE	0x01000000
 #ifdef CONFIG_SBUS_LOAD
  #define CONFIG_IBUS2SBUS_OFFSET	0x1e080000	/* 0x1f080000-0x01000000 */
 #endif
#endif
#ifndef CONFIG_IBUS2SBUS_OFFSET
 #define CONFIG_IBUS2SBUS_OFFSET	0
#endif
#define XBR820_SRAM_SIZE	0x00001000
#endif
