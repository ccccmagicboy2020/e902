
.//Obj/top_test.elf:     file format elf32-littleriscv


Disassembly of section .text:

00400000 <__Vectors>:
  400000:	10 01 40 00 10 01 40 00 10 01 40 00 10 01 40 00     ..@...@...@...@.
  400010:	10 01 40 00 10 01 40 00 10 01 40 00 10 01 40 00     ..@...@...@...@.
  400020:	10 01 40 00 10 01 40 00 10 01 40 00 10 01 40 00     ..@...@...@...@.
  400030:	10 01 40 00 10 01 40 00 10 01 40 00 10 01 40 00     ..@...@...@...@.
  400040:	10 01 40 00 10 01 40 00 10 01 40 00 10 01 40 00     ..@...@...@...@.
  400050:	10 01 40 00 10 01 40 00 10 01 40 00 10 01 40 00     ..@...@...@...@.
  400060:	10 01 40 00 10 01 40 00 10 01 40 00 10 01 40 00     ..@...@...@...@.
  400070:	10 01 40 00 10 01 40 00 10 01 40 00 10 01 40 00     ..@...@...@...@.
  400080:	10 01 40 00 10 01 40 00 10 01 40 00 10 01 40 00     ..@...@...@...@.
  400090:	10 01 40 00 10 01 40 00 10 01 40 00 10 01 40 00     ..@...@...@...@.
  4000a0:	10 01 40 00 10 01 40 00 10 01 40 00 10 01 40 00     ..@...@...@...@.
  4000b0:	10 01 40 00 10 01 40 00 10 01 40 00 10 01 40 00     ..@...@...@...@.

004000c0 <main>:
 * @return For MCU application, it's better to loop here
 */
 uint32_t reg_data;
int main()
{
	reg_data = reg32_read(XBR820_TOP_BASE);
  4000c0:	1f0007b7          	lui	a5,0x1f000
  4000c4:	4398                	lw	a4,0(a5)
  4000c6:	004006b7          	lui	a3,0x400
  4000ca:	12e6a023          	sw	a4,288(a3) # 400120 <__etext>
	reg32_write(XBR820_TOP_BASE + 0xC0, reg_data);
  4000ce:	0ce7a023          	sw	a4,192(a5) # 1f0000c0 <__end+0x1ebffe90>
	while(1);
  4000d2:	a001                	j	4000d2 <main+0x12>

004000d4 <Reset_Handler>:
  .section ".text.init"
  .globl Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
	# enable FPU and accelerator if present
	li t0, MSTATUS_FS | MSTATUS_XS
  4000d4:	62f9                	lui	t0,0x1e
	csrs mstatus, t0
  4000d6:	3002a073          	csrs	mstatus,t0
  
	# enable MXSTATUS.THEADISAEE bit[22]
	li t0,  0x400000
  4000da:	004002b7          	lui	t0,0x400
	csrs mxstatus, t0
  4000de:	7c02a073          	csrs	mxstatus,t0

    la      a0, Default_Handler
  4000e2:	00000517          	auipc	a0,0x0
  4000e6:	02e50513          	addi	a0,a0,46 # 400110 <Default_Handler>
    ori     a0, a0, 3
  4000ea:	00356513          	ori	a0,a0,3
    csrw    mtvec, a0
  4000ee:	30551073          	csrw	mtvec,a0

    la      a0, __Vectors
  4000f2:	00000517          	auipc	a0,0x0
  4000f6:	f0e50513          	addi	a0,a0,-242 # 400000 <__Vectors>
    csrw    mtvt, a0
  4000fa:	30751073          	csrw	mtvt,a0

    la      sp, __initial_sp
  4000fe:	00000117          	auipc	sp,0x0
  400102:	13210113          	addi	sp,sp,306 # 400230 <__end>
    csrw    mscratch, sp
  400106:	34011073          	csrw	mscratch,sp

    jal     main
  40010a:	fb7ff0ef          	jal	ra,4000c0 <main>

0040010e <__exit>:

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit
  40010e:	a001                	j	40010e <__exit>

00400110 <Default_Handler>:
	

  .align 2
Default_Handler:
    j      Default_Handler
  400110:	a001                	j	400110 <Default_Handler>
	...
