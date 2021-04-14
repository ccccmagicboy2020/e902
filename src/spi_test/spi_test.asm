
.//Obj/spi_test.elf:     file format elf32-littleriscv


Disassembly of section .text:

01000000 <main>:

int main() {
	BHW_t id = { .w = 0};

	/* Enable SFLASH module */
	reg32_write(SPI_CR, 0);
 1000000:	4781                	li	a5,0
 1000002:	0007a023          	sw	zero,0(a5)
	reg32_write(SPI_CR, SPI_CR_SPIEN | SPI_CR_STOP);
 1000006:	4731                	li	a4,12
 1000008:	c398                	sw	a4,0(a5)
	reg32_write(SPI_CM, 0x000000B4 | (0x9F << 8));
 100000a:	6729                	lui	a4,0xa
 100000c:	fb470713          	addi	a4,a4,-76 # 9fb4 <main-0xff604c>
 1000010:	00e02223          	sw	a4,4(zero) # 4 <main-0xfffffc>
	id.w = reg32_read(SPI_CR);
 1000014:	4398                	lw	a4,0(a5)
	swap(id.b[0], id.b[2], id.b[3]);
 1000016:	0ff77613          	andi	a2,a4,255
 100001a:	01861593          	slli	a1,a2,0x18
 100001e:	010007b7          	lui	a5,0x1000
 1000022:	fff78693          	addi	a3,a5,-1 # ffffff <main-0x1>
 1000026:	00d777b3          	and	a5,a4,a3
 100002a:	8fcd                	or	a5,a5,a1
 100002c:	8341                	srli	a4,a4,0x10
 100002e:	0ff77713          	andi	a4,a4,255
 1000032:	f007f793          	andi	a5,a5,-256
 1000036:	8fd9                	or	a5,a5,a4
 1000038:	0642                	slli	a2,a2,0x10
 100003a:	ff010737          	lui	a4,0xff010
 100003e:	177d                	addi	a4,a4,-1
 1000040:	8ff9                	and	a5,a5,a4
 1000042:	8fd1                	or	a5,a5,a2
	flash_id = id.w & 0x00FFFFFF;
 1000044:	8ff5                	and	a5,a5,a3
 1000046:	00f1a023          	sw	a5,0(gp) # 1000070 <__etext>
	while(1);
 100004a:	a001                	j	100004a <main+0x4a>

0100004c <Reset_Handler>:
  .globl Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
.option push
.option norelax
    la      gp, __global_pointer$
 100004c:	00000197          	auipc	gp,0x0
 1000050:	02418193          	addi	gp,gp,36 # 1000070 <__etext>
.option pop
    la      sp, __stack_top
 1000054:	00001117          	auipc	sp,0x1
 1000058:	fac10113          	addi	sp,sp,-84 # 1001000 <__stack_top>
    csrw    mscratch, sp
 100005c:	34011073          	csrw	mscratch,sp

    jal     main
 1000060:	fa1ff0ef          	jal	ra,1000000 <main>

01000064 <__exit>:

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit
 1000064:	a001                	j	1000064 <__exit>
	...
