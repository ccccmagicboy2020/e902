
.//Obj/test1.elf:     file format elf32-littleriscv


Disassembly of section .text:

00400000 <__Vectors>:
  400000:	20 01 40 00 20 01 40 00 20 01 40 00 20 01 40 00      .@. .@. .@. .@.
  400010:	20 01 40 00 20 01 40 00 20 01 40 00 20 01 40 00      .@. .@. .@. .@.
  400020:	20 01 40 00 20 01 40 00 20 01 40 00 20 01 40 00      .@. .@. .@. .@.
  400030:	20 01 40 00 20 01 40 00 20 01 40 00 20 01 40 00      .@. .@. .@. .@.
  400040:	20 01 40 00 20 01 40 00 20 01 40 00 20 01 40 00      .@. .@. .@. .@.
  400050:	20 01 40 00 20 01 40 00 20 01 40 00 20 01 40 00      .@. .@. .@. .@.
  400060:	20 01 40 00 20 01 40 00 20 01 40 00 20 01 40 00      .@. .@. .@. .@.
  400070:	20 01 40 00 20 01 40 00 20 01 40 00 20 01 40 00      .@. .@. .@. .@.
  400080:	20 01 40 00 20 01 40 00 20 01 40 00 20 01 40 00      .@. .@. .@. .@.
  400090:	20 01 40 00 20 01 40 00 20 01 40 00 20 01 40 00      .@. .@. .@. .@.
  4000a0:	20 01 40 00 20 01 40 00 20 01 40 00 20 01 40 00      .@. .@. .@. .@.
  4000b0:	20 01 40 00 20 01 40 00 20 01 40 00 20 01 40 00      .@. .@. .@. .@.

004000c0 <main>:
 *
 * @return For MCU application, it's better to loop here
 */
int main()
{
    reg32_write(TEST_ADDR, 0x5aa5a55a);
  4000c0:	000417b7          	lui	a5,0x41
  4000c4:	5aa5a737          	lui	a4,0x5aa5a
  4000c8:	55a70713          	addi	a4,a4,1370 # 5aa5a55a <__end+0x5a65a32a>
  4000cc:	80e7a023          	sw	a4,-2048(a5) # 40800 <__Vectors-0x3bf800>
     reg16_write(TEST_ADDR + 6, 0x5aa5);
  4000d0:	6719                	lui	a4,0x6
  4000d2:	aa570713          	addi	a4,a4,-1371 # 5aa5 <__Vectors-0x3fa55b>
  4000d6:	80e79323          	sh	a4,-2042(a5)
     reg8_write(TEST_ADDR + 11, 0xa5);
  4000da:	fa500713          	li	a4,-91
  4000de:	80e785a3          	sb	a4,-2037(a5)
	 while(1);
  4000e2:	a001                	j	4000e2 <main+0x22>

004000e4 <Reset_Handler>:
  .section ".text.init"
  .globl Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
	# enable FPU and accelerator if present
	li t0, MSTATUS_FS | MSTATUS_XS
  4000e4:	62f9                	lui	t0,0x1e
	csrs mstatus, t0
  4000e6:	3002a073          	csrs	mstatus,t0
  
	# enable MXSTATUS.THEADISAEE bit[22]
	li t0,  0x400000
  4000ea:	004002b7          	lui	t0,0x400
	csrs mxstatus, t0
  4000ee:	7c02a073          	csrs	mxstatus,t0

    la      a0, Default_Handler
  4000f2:	00000517          	auipc	a0,0x0
  4000f6:	02e50513          	addi	a0,a0,46 # 400120 <Default_Handler>
    ori     a0, a0, 3
  4000fa:	00356513          	ori	a0,a0,3
    csrw    mtvec, a0
  4000fe:	30551073          	csrw	mtvec,a0

    la      a0, __Vectors
  400102:	00000517          	auipc	a0,0x0
  400106:	efe50513          	addi	a0,a0,-258 # 400000 <__Vectors>
    csrw    mtvt, a0
  40010a:	30751073          	csrw	mtvt,a0

    la      sp, __initial_sp
  40010e:	00000117          	auipc	sp,0x0
  400112:	12210113          	addi	sp,sp,290 # 400230 <__end>
    csrw    mscratch, sp
  400116:	34011073          	csrw	mscratch,sp

    jal     main
  40011a:	fa7ff0ef          	jal	ra,4000c0 <main>

0040011e <__exit>:

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit
  40011e:	a001                	j	40011e <__exit>

00400120 <Default_Handler>:
	

  .align 2
Default_Handler:
    j      Default_Handler
  400120:	a001                	j	400120 <Default_Handler>
	...
