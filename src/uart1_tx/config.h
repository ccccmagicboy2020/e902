#ifndef __TIRQ_TEST_CONFIG_H__
#define __TIRQ_TEST_CONFIG_H__

#ifndef CONFIG_HAVE_VIC
 #define CONFIG_HAVE_VIC 1
#endif
//#define CONFIG_SBUS_LOAD

#define CONFIG_ARCH_RV32 1
#define CONFIG_CPU_E902 1

#define __NO_ICACHE
#define CONFIG_STACKSIZE 512
#endif
