 /******************************************************************************
 * @file     startup.S
 * @brief    startup file.
 * @version  V1.0
 * @date     15. March 2021
 ******************************************************************************/
#include <memory_ld.h>

.section .vectors, "aw", @progbits
    .align  6
    .globl  __Vectors
    .type   __Vectors, @object
__Vectors:
#if CONFIG_HAVE_VIC
	#ifdef CONFIG_ROM
    .long   Default_Handler
    .long   Default_Handler
	#else
    .long   (__edata - __stext)
    .long   Reset_Handler
	#endif
    .long   Default_Handler
    .long   Default_Handler
    .long   Default_Handler
    .long   Default_Handler
    .long   Default_Handler
    .long   Default_IRQHandler
    .long   Default_Handler
    .long   Default_Handler
    .long   Default_Handler
    .long   Default_Handler
    .long   Default_Handler
    .long   Default_Handler
    .long   Default_Handler
    .long   Default_Handler

    /* External interrupts */
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
    .long   Default_IRQHandler
#else
    .long   0
#endif

    .text
    .align  2
#ifdef CONFIG_BOOT_HEAD
    .long   (__edata - __stext)
    .long   Reset_Handler
#endif
_start:
    .text
    .align  2
    .globl  Reset_Handler
    .type   Reset_Handler, %function
Reset_Handler:
	# enable MXSTATUS.THEADISAEE bit[22]
	li t0,  0x400000
	csrs mxstatus, t0
#ifndef __NO_ICACHE
	# icache enable
	li t1,  1
	csrw mhcr, t1

	# invalid icache
	ICACHE.IALL
#else
	# icache disable
	csrw mhcr, zero
#endif
#ifdef CONFIG_SBUS_LOAD
      la      t0, 0x1f010058
      li      t1, 0x12	# boot from flash & SRAM used for data buffer
      sw      t1, (t0)
#endif
#ifdef CONFIG_ROM
    /* Load data section */
    la      a0, __erodata
    la      a1, __code_start__ + CONFIG_IBUS2SBUS_OFFSET
    la      a2, __data_end__ + CONFIG_IBUS2SBUS_OFFSET
    bgeu    a1, a2, 2f
1:
    lw      t0, (a0)
    sw      t0, (a1)
    addi    a0, a0, 4
    addi    a1, a1, 4
    bltu    a1, a2, 1b
2:
#endif
#ifdef CONFIG_BSS_INIT
    /* Clear bss section */
    la      a0, __bss_start__ + CONFIG_IBUS2SBUS_OFFSET
    la      a1, __bss_end__ + CONFIG_IBUS2SBUS_OFFSET
    bgeu    a0, a1, 2f
1:
    sw      zero, (a0)
    addi    a0, a0, 4
    bltu    a0, a1, 1b
2:
#endif
#ifdef CONFIG_SBUS_LOAD
      la      t0, 0x1f010058
      li      t1, 0x10
      sw      t1, (t0)
#endif
.option push
.option norelax
    la      gp, __global_pointer$
.option pop
    la      sp, g_top_irqstack
    csrw    mscratch, sp
#if CONFIG_HAVE_VIC
    la      a0, Default_Handler
    ori     a0, a0, 3
    csrw    mtvec, a0

    la      a0, __Vectors
    csrw    mtvt, a0
#endif

#ifndef __NO_SYSTEM_INIT
    jal     SystemInit
#endif

#ifndef __NO_BOARD_INIT
    jal     board_init
#endif

    jal     main

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit

.section .bss.app_stack

    .align  3
    .global g_base_irqstack
    .global g_top_irqstack
g_base_irqstack:
    .space CONFIG_ARCH_INTERRUPTSTACK
g_top_irqstack:
