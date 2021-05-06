#include <config.h>

# define LREG lw
# define SREG sw
# define REGBYTES 4
// <<< Use Configuration Wizard in Context Menu >>>

.global __initial_sp

.section .bss.app_stack,"aw",@nobits
.align 2
Stack_Mem:
.space CONFIG_STACKSIZE
__initial_sp:


.section .exp_table, "aw", @progbits
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



/*
 * For importing variable or functions from other c or assemble files.
 */
.global main
.global handle_trap

  .section ".text.init"
  .globl Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
	# enable MXSTATUS.THEADISAEE bit[22]
	li t0,  0x400000
	csrs mxstatus, t0

.option push
.option norelax
    la      gp, __global_pointer$
.option pop

    la      a0, Default_Handler
    ori     a0, a0, 3
    csrw    mtvec, a0

    la      a0, __Vectors
    csrw    mtvt, a0

    la      sp, __initial_sp
    csrw    mscratch, sp

    jal     main

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit

	
.section .bss.trap_stack
    .align  2
    .globl  g_trapstackalloc
    .global g_trapstackbase
    .global g_top_trapstack
g_trapstackalloc:
g_trapstackbase:
    .space 512
g_top_trapstack:

    .align 2
    .globl g_trap_sp
    .type  g_trap_sp, object
g_trap_sp:
    .long 0
    .size g_trap_sp, .-g_trap_sp

irq_nested_level:
.long 0

#define MSTATUS_PRV1 0x1880

.text

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

    andi    a0, t1, 0x3FF
    jal    handle_irq

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


    .align  6
    .weak   Default_Handler
    .global Default_Handler
    .type   Default_Handler, %function
Default_Handler:
    /* Check for interrupt */
    addi    sp, sp, -4
    sw      t0, 0x0(sp)
    csrr    t0, mcause

    blt     t0, x0, .Lirq

    addi    sp, sp, 4

    la      t0, g_trap_sp
    addi    t0, t0, -68
    sw      x1, 0(t0)
    sw      x2, 4(t0)
    sw      x3, 8(t0)
    sw      x4, 12(t0)
    sw      x6, 20(t0)
    sw      x7, 24(t0)
    sw      x8, 28(t0)
    sw      x9, 32(t0)
    sw      x10, 36(t0)
    sw      x11, 40(t0)
    sw      x12, 44(t0)
    sw      x13, 48(t0)
    sw      x14, 52(t0)
    sw      x15, 56(t0)
    csrr    a0, mepc
    sw      a0, 60(t0)
    csrr    a0, mstatus
    sw      a0, 64(t0)

    mv      a0, t0
    lw      t0, -4(sp)
    mv      sp, a0
    sw      t0, 16(sp)
trap:
    j     trap


.Lirq:
    lw      t0, 0x0(sp)
    addi    sp, sp, 4
    j       Default_IRQHandler
    .size   Default_Handler, . - Default_Handler
