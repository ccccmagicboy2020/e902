/*
 * Copyright (C) 2017-2019 Alibaba Group Holding Limited
 */

 /******************************************************************************
 * @file     startup.S
 * @brief    startup file. Should use with
 *           GCC for CSKY Embedded Processors
 * @version  V1.0
 * @date     15. March 2021
 ******************************************************************************/

#include "config.h"

.section    .text.init
    .align  2
    .globl  Reset_Handler
    .type   Reset_Handler, %function
Reset_Handler:
.option push
.option norelax
    la      gp, __global_pointer$
.option pop
#if CONFIG_HAVE_VECTORS
    la      a0, Default_Handler
    ori     a0, a0, 3
    csrw    mtvec, a0

    la      a0, __Vectors
    csrw    mtvt, a0
#endif
    la      sp, g_top_irqstack
    csrw    mscratch, sp

#if CONFIG_BSS_INIT
    /* Clear bss section */
    la      a0, __bss_start__
    la      a1, __bss_end__
    bgeu    a0, a1, 2f
1:
    sw      zero, (a0)
    addi    a0, a0, 4
    bltu    a0, a1, 1b
2:
#endif

    jal     main

    .size   Reset_Handler, . - Reset_Handler

    .text
    .align  2
__exit:
    j      __exit

#if CONFIG_HAVE_VECTORS
    .align  2
    .global Default_Handler
    .weak   Default_Handler
    .type   Default_Handler, %function
Default_Handler:
	j		Default_Handler

    .align  2
    .global Default_IRQHandler
    .weak   Default_IRQHandler
    .type   Default_IRQHandler, %function
Default_IRQHandler:
	j		Default_IRQHandler

.section .vectors, "aw", @progbits
    .align  6
    .globl  __Vectors
    .type   __Vectors, @object
__Vectors:
    .long   Default_Handler
    .long   Default_Handler
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
#endif

.section .app_stack,"aw",@nobits
    .align  3
    .global g_base_irqstack
    .global g_top_irqstack
g_base_irqstack:
    .space	CONFIG_ARCH_INTERRUPTSTACK
g_top_irqstack:
