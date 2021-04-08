
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
  10:	0a000513          	li	a0,160
    la      a1, __data_start__
  14:	00018593          	mv	a1,gp
    la      a2, __data_end__
  18:	00018613          	mv	a2,gp
    bgeu    a1, a2, 2f
  1c:	00c5fa63          	bgeu	a1,a2,30 <Reset_Handler+0x30>
1:
    lw      t0, (a0)
  20:	00052283          	lw	t0,0(a0)
    sw      t0, (a1)
  24:	0055a023          	sw	t0,0(a1)
    addi    a0, a0, 4
  28:	0511                	addi	a0,a0,4
    addi    a1, a1, 4
  2a:	0591                	addi	a1,a1,4
    bltu    a1, a2, 1b
  2c:	fec5eae3          	bltu	a1,a2,20 <Reset_Handler+0x20>
    addi    a0, a0, 4
    bltu    a0, a1, 1b
2:
#endif

    jal     SystemInit
  30:	010000ef          	jal	ra,40 <SystemInit>

    jal     board_init
  34:	00e000ef          	jal	ra,42 <board_init>

    jal     main
  38:	00c000ef          	jal	ra,44 <main>

0000003c <__exit>:

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit
  3c:	a001                	j	3c <__exit>
	...

00000040 <SystemInit>:
#include "xbr820.h"

void SystemInit(void)
{
}
  40:	8082                	ret

00000042 <board_init>:

void board_init(void)
{
}
  42:	8082                	ret

00000044 <main>:

#define TEST_ADDR	(XBR820_SRAM_BASE + XBR820_SRAM_SIZE / 2)

int __attribute__((weak)) main(void) {
	uint8_t *data = (uint8_t *)TEST_ADDR;
	if (*data) {
  44:	004017b7          	lui	a5,0x401
  48:	8007c783          	lbu	a5,-2048(a5) # 400800 <__min_heap_size+0x400600>
  4c:	cf95                	beqz	a5,88 <main+0x44>
		for (uint16_t i = 0; i < 256; i++)
  4e:	4781                	li	a5,0
  50:	a819                	j	66 <main+0x22>
			data[i] = (uint8_t)i;
  52:	00401737          	lui	a4,0x401
  56:	80070713          	addi	a4,a4,-2048 # 400800 <__min_heap_size+0x400600>
  5a:	973e                	add	a4,a4,a5
  5c:	00f70023          	sb	a5,0(a4)
		for (uint16_t i = 0; i < 256; i++)
  60:	0785                	addi	a5,a5,1
  62:	07c2                	slli	a5,a5,0x10
  64:	83c1                	srli	a5,a5,0x10
  66:	0ff00713          	li	a4,255
  6a:	fef774e3          	bgeu	a4,a5,52 <main+0xe>
	}
	else {
		for (uint16_t i = 0; i < 256; i++)
			data[i] = (uint8_t)~i;
	}
	while (1);
  6e:	a001                	j	6e <main+0x2a>
			data[i] = (uint8_t)~i;
  70:	00401737          	lui	a4,0x401
  74:	80070713          	addi	a4,a4,-2048 # 400800 <__min_heap_size+0x400600>
  78:	973e                	add	a4,a4,a5
  7a:	fff7c693          	not	a3,a5
  7e:	00d70023          	sb	a3,0(a4)
		for (uint16_t i = 0; i < 256; i++)
  82:	0785                	addi	a5,a5,1
  84:	07c2                	slli	a5,a5,0x10
  86:	83c1                	srli	a5,a5,0x10
  88:	0ff00713          	li	a4,255
  8c:	fef772e3          	bgeu	a4,a5,70 <main+0x2c>
  90:	bff9                	j	6e <main+0x2a>
	...
