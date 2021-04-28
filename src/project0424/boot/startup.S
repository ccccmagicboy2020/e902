 /******************************************************************************
 * @file     startup.S
 * @brief    startup file. Should use with
 *           GCC for CSKY Embedded Processors
 * @version  V1.0
 * @date     10. April 2021
 ******************************************************************************/

    .text
    .align  2
_start:
    .text
    .align  2
    .globl  Reset_Handler
    .type   Reset_Handler, %function
Reset_Handler:
	# enable MXSTATUS.THEADISAEE bit[22]
	li t0,  0x400000
	csrs mxstatus, t0

	la      sp, __stack_top
    csrw    mscratch, sp

    j       boot

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit
