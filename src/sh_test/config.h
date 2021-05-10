#ifndef __SH_TEST_CONFIG_H__
#define __SH_TEST_CONFIG_H__
#define CONFIG_ARCH_RV32 1
#define CONFIG_CPU_E902 1
#define CONFIG_HAVE_VIC 0
#define CONFIG_ARCH_INTERRUPTSTACK 192
#if CONFIG_HAVE_VIC
 #define CONFIG_ARCH_TRAPSTACK 96
#else
 #define CONFIG_BOOT_HEAD
#endif
//#define CONFIG_BSS_INIT
#define CONFIG_CONSOLE_HANDLE	1
#if CONFIG_HAVE_VIC
 #define CONFIG_CONSOLE_RXSIZE	64
 //#define CONFIG_CONSOLE_TXSIZE	32
#endif
//#define CONFIG_PRINTF
#define CONFIG_SHELL
#ifdef CONFIG_SHELL
 //#define CONFIG_CMD_READ
 //#define CONFIG_CMD_WRITE
 #define CONFIG_CMD_LW
 #define CONFIG_CMD_SW
#endif
#endif
