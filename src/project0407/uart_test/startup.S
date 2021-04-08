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

    .text
    .align  2
_start:
    .text
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

    jal     SystemInit

    jal     board_init

    jal     main

    .size   Reset_Handler, . - Reset_Handler

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
    addi    sp, sp, -48
    sw      t0, 4(sp)
    sw      t1, 8(sp)
    csrr    t0, mepc
    csrr    t1, mcause
    sw      t1, 40(sp)
    sw      t0, 44(sp)
    csrs    mstatus, 8

    sw      ra, 0(sp)
    sw      t2, 12(sp)
    sw      a0, 16(sp)
    sw      a1, 20(sp)
    sw      a2, 24(sp)
    sw      a3, 28(sp)
    sw      a4, 32(sp)
    sw      a5, 36(sp)

    andi    t1, t1, 0x3FF
    slli    t1, t1, 2

    la      t0, irqvector
    add     t0, t0, t1
    lw      t2, (t0)
    jalr    t2

    csrc    mstatus, 8

    lw      a1, 40(sp)
    andi    a0, a1, 0x3FF

    /* clear pending */
    li      a2, 0xE000E100
    add     a2, a2, a0
    lb      a3, 0(a2)
    li      a4, 1
    not     a4, a4
    and     a5, a4, a3
    sb      a5, 0(a2)

    li      t0, MSTATUS_PRV1
    csrs    mstatus, t0
    csrw    mcause, a1
    lw      t0, 44(sp)
    csrw    mepc, t0
    lw      ra, 0(sp)
    lw      t0, 4(sp)
    lw      t1, 8(sp)
    lw      t2, 12(sp)
    lw      a0, 16(sp)
    lw      a1, 20(sp)
    lw      a2, 24(sp)
    lw      a3, 28(sp)
    lw      a4, 32(sp)
    lw      a5, 36(sp)

    addi    sp, sp, 48
    mret

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
