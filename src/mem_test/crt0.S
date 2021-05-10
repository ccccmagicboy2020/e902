#include <memory_ld.h>

  .section ".text.init"
  .globl Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
	# enable MXSTATUS.THEADISAEE bit[22]
	li t0,  0x400000
	csrs mxstatus, t0
#ifdef CONFIG_ICACHE
	# icache enable
	li t1,  1
	csrw mhcr, t1

	# invalid icache
	ICACHE.IALL
#else
	# icache enable
	csrw mhcr, zero
#endif
.option push
.option norelax
    la      gp, __global_pointer$
.option pop

    la      sp, __stack
    csrw    mscratch, sp

    /* Load data section */
    la      a0, __erodata
    la      a1, __data_start__
    la      a2, __data_end__
    bgeu    a1, a2, 2f
1:
    lw      t0, (a0)
    sw      t0, (a1)
    addi    a0, a0, 4
    addi    a1, a1, 4
    bltu    a1, a2, 1b
2:

    jal     main

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit

.globl __bkpt_label
.section ".text"
.align 2
.type __bkpt_label, %function
__bkpt_label:
    ebreak
    ret
