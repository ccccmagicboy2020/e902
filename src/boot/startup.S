 /******************************************************************************
 * @file     startup.S
 * @brief    startup file.
 * @version  V1.0
 * @date     8. May 2021
 ******************************************************************************/
#include <memory_ld.h>

      .text
      .align  2
_start:
      .text
      .align  2
      .globl  Reset_Handler
      .type   Reset_Handler, %function
Reset_Handler:
#ifdef CONFIG_ICACHE
      # enable MXSTATUS.THEADISAEE bit[22]
      li t0,  0x400000
      csrs mxstatus, t0

      # icache enable
      li t1,  1
      csrw mhcr, t1

      # invalid icache
      ICACHE.IALL
#endif

#ifdef CONFIG_SBUS_LOAD
      la      t0, 0x1f010058
      li      t1, 0x12	# boot from flash & SRAM used for data buffer
      sw      t1, (t0)
#endif
      /* Load data section */
      la      a0, __erodata
      lw      t1, (a0)
      lw      t2, 4(a0)
      la      a1, XBR820_SRAM_BASE
      add   a2, a1, t1
1:
      lw      t0, (a0)
      sw      t0, (a1)
      addi    a0, a0, 4
      addi    a1, a1, 4
      bltu    a1, a2, 1b
2:

#ifdef CONFIG_SBUS_LOAD
      la      t0, 0x1f010058
      li      t1, 0x10
      sw      t1, (t0)
#endif
      jalr    t0, t2

      .size   Reset_Handler, . - Reset_Handler

__exit:
      j      __exit
