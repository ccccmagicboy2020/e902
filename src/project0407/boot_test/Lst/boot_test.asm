
.//Obj/boot_test.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <Reset_Handler>:
    .globl  Reset_Handler
    .type   Reset_Handler, %function
Reset_Handler:
.option push
.option norelax
    la      gp, __global_pointer$
   0:	01000197          	auipc	gp,0x1000
   4:	00018193          	mv	gp,gp

    la      a0, __Vectors
    csrw    mtvt, a0
#endif

    la      sp, g_top_irqstack
   8:	10018113          	addi	sp,gp,256 # 1000100 <__bss_end__>
    csrw    mscratch, sp
   c:	34011073          	csrw	mscratch,sp

    /* Load data section */
    la      a0, __erodata
  10:	0c000513          	li	a0,192
    la      a1, __data_start__
  14:	00018593          	mv	a1,gp
    la      a2, __data_end__
  18:	00018613          	mv	a2,gp
    bgeu    a1, a2, 2f
  1c:	00c5fc63          	bgeu	a1,a2,34 <Reset_Handler+0x34>
1:
    lw      t0, (a0)
  20:	00052283          	lw	t0,0(a0)
    sw      t0, (a1)
  24:	0055a023          	sw	t0,0(a1)
    addi    a0, a0, 4
  28:	00450513          	addi	a0,a0,4
    addi    a1, a1, 4
  2c:	00458593          	addi	a1,a1,4
    bltu    a1, a2, 1b
  30:	fec5e8e3          	bltu	a1,a2,20 <Reset_Handler+0x20>
    addi    a0, a0, 4
    bltu    a0, a1, 1b
2:
#endif

    jal     SystemInit
  34:	010000ef          	jal	ra,44 <SystemInit>

    jal     board_init
  38:	010000ef          	jal	ra,48 <board_init>

    jal     main
  3c:	010000ef          	jal	ra,4c <main>

00000040 <__exit>:

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit
  40:	0000006f          	j	40 <__exit>

00000044 <SystemInit>:
#include "xbr820.h"

void SystemInit(void)
{
}
  44:	00008067          	ret

00000048 <board_init>:

void board_init(void)
{
}
  48:	00008067          	ret

0000004c <main>:

#define TEST_ADDR	(XBR820_SRAM_BASE + XBR820_SRAM_SIZE / 2)

int __attribute__((weak)) main(void) {
	uint8_t *data = (uint8_t *)TEST_ADDR;
	if (*data) {
  4c:	004017b7          	lui	a5,0x401
  50:	8007c783          	lbu	a5,-2048(a5) # 400800 <__min_heap_size+0x400600>
  54:	04078a63          	beqz	a5,a8 <main+0x5c>
		for (uint16_t i = 0; i < 256; i++)
  58:	00000793          	li	a5,0
  5c:	0200006f          	j	7c <main+0x30>
			data[i] = (uint8_t)i;
  60:	00401737          	lui	a4,0x401
  64:	80070713          	addi	a4,a4,-2048 # 400800 <__min_heap_size+0x400600>
  68:	00e78733          	add	a4,a5,a4
  6c:	00f70023          	sb	a5,0(a4)
		for (uint16_t i = 0; i < 256; i++)
  70:	00178793          	addi	a5,a5,1
  74:	01079793          	slli	a5,a5,0x10
  78:	0107d793          	srli	a5,a5,0x10
  7c:	0ff00713          	li	a4,255
  80:	fef770e3          	bgeu	a4,a5,60 <main+0x14>
	}
	else {
		for (uint16_t i = 0; i < 256; i++)
			data[i] = (uint8_t)~i;
	}
	while (1);
  84:	0000006f          	j	84 <main+0x38>
			data[i] = (uint8_t)~i;
  88:	00401737          	lui	a4,0x401
  8c:	80070713          	addi	a4,a4,-2048 # 400800 <__min_heap_size+0x400600>
  90:	00e78733          	add	a4,a5,a4
  94:	fff7c693          	not	a3,a5
  98:	00d70023          	sb	a3,0(a4)
		for (uint16_t i = 0; i < 256; i++)
  9c:	00178793          	addi	a5,a5,1
  a0:	01079793          	slli	a5,a5,0x10
  a4:	0107d793          	srli	a5,a5,0x10
  a8:	0ff00713          	li	a4,255
  ac:	fcf77ee3          	bgeu	a4,a5,88 <main+0x3c>
  b0:	fd5ff06f          	j	84 <main+0x38>
	...
