
.//Obj/irq_test.elf:     file format elf32-littleriscv


Disassembly of section .text:

01000000 <__Vectors>:
 1000000:	e8 01 00 01 e8 01 00 01 e8 01 00 01 e8 01 00 01     ................
 1000010:	e8 01 00 01 e8 01 00 01 e8 01 00 01 e8 01 00 01     ................
 1000020:	e8 01 00 01 e8 01 00 01 e8 01 00 01 e8 01 00 01     ................
 1000030:	e8 01 00 01 e8 01 00 01 e8 01 00 01 e8 01 00 01     ................
 1000040:	e8 01 00 01 e8 01 00 01 e8 01 00 01 e8 01 00 01     ................
 1000050:	e8 01 00 01 e8 01 00 01 e8 01 00 01 e8 01 00 01     ................
 1000060:	e8 01 00 01 e8 01 00 01 e8 01 00 01 e8 01 00 01     ................
 1000070:	e8 01 00 01 e8 01 00 01 e8 01 00 01 e8 01 00 01     ................
 1000080:	e8 01 00 01 e8 01 00 01 e8 01 00 01 e8 01 00 01     ................
 1000090:	e8 01 00 01 e8 01 00 01 e8 01 00 01 e8 01 00 01     ................
 10000a0:	e8 01 00 01 e8 01 00 01 e8 01 00 01 e8 01 00 01     ................
 10000b0:	e8 01 00 01 e8 01 00 01 e8 01 00 01 e8 01 00 01     ................

010000c0 <main>:

#include <xbr820.h>

extern void uart_init(void);
int main() {
 10000c0:	1151                	addi	sp,sp,-12
 10000c2:	c406                	sw	ra,8(sp)
    /* get interrupt level from info */
    CLIC->CLICCFG = (((CLIC->CLICINFO & CLIC_INFO_CLICINTCTLBITS_Msk) >> CLIC_INFO_CLICINTCTLBITS_Pos) << CLIC_CLICCFG_NLBIT_Pos);
 10000c4:	e0800737          	lui	a4,0xe0800
 10000c8:	435c                	lw	a5,4(a4)
 10000ca:	83d5                	srli	a5,a5,0x15
 10000cc:	0786                	slli	a5,a5,0x1
 10000ce:	8bf9                	andi	a5,a5,30
 10000d0:	00f70023          	sb	a5,0(a4) # e0800000 <__end+0xdf7ffaa0>

     for (int i = 0; i < 64; i++) {
 10000d4:	4701                	li	a4,0
 10000d6:	a831                	j	10000f2 <main+0x32>
        CLIC->CLICINT[i].IP = 0;
 10000d8:	40070793          	addi	a5,a4,1024
 10000dc:	00279693          	slli	a3,a5,0x2
 10000e0:	e08007b7          	lui	a5,0xe0800
 10000e4:	97b6                	add	a5,a5,a3
 10000e6:	00078023          	sb	zero,0(a5) # e0800000 <__end+0xdf7ffaa0>
        CLIC->CLICINT[i].ATTR = 1; /* use vector interrupt */
 10000ea:	4685                	li	a3,1
 10000ec:	00d78123          	sb	a3,2(a5)
     for (int i = 0; i < 64; i++) {
 10000f0:	0705                	addi	a4,a4,1
 10000f2:	03f00793          	li	a5,63
 10000f6:	fee7d1e3          	bge	a5,a4,10000d8 <main+0x18>
    }
    for (int i = GPIO_IRQn; i < IRQ_NUMS; i++) {
 10000fa:	47c1                	li	a5,16
 10000fc:	a821                	j	1000114 <main+0x54>
        CLIC->CLICINT[i].ATTR = 5; /* use positive level vector interrupt */
 10000fe:	40078713          	addi	a4,a5,1024
 1000102:	00271693          	slli	a3,a4,0x2
 1000106:	e0800737          	lui	a4,0xe0800
 100010a:	9736                	add	a4,a4,a3
 100010c:	4695                	li	a3,5
 100010e:	00d70123          	sb	a3,2(a4) # e0800002 <__end+0xdf7ffaa2>
    for (int i = GPIO_IRQn; i < IRQ_NUMS; i++) {
 1000112:	0785                	addi	a5,a5,1
 1000114:	4775                	li	a4,29
 1000116:	fef754e3          	bge	a4,a5,10000fe <main+0x3e>
  \details Enables IRQ interrupts by setting the IE-bit in the PSR.
           Can only be executed in Privileged modes.
 */
__ALWAYS_STATIC_INLINE void __enable_irq(void)
{
    __ASM volatile("csrs mstatus, 8");
 100011a:	30046073          	csrsi	mstatus,8
    }
    __enable_excp_irq();

	uart_init();
 100011e:	2011                	jal	1000122 <uart_init>

	while(1);
 1000120:	a001                	j	1000120 <main+0x60>

01000122 <uart_init>:
int uart_buf_pos;
char uart_buffer[256];
void uart_init(void) {
	uint32_t divisor;

	uart_buf_pos = 0;
 1000122:	1001a023          	sw	zero,256(gp) # 1000350 <uart_buf_pos>
	uart_buffer[0] = 0;
 1000126:	00018023          	sb	zero,0(gp) # 1000250 <__etext>
	XBR820_UART0->enable = 0;
 100012a:	1f0507b7          	lui	a5,0x1f050
 100012e:	0007a023          	sw	zero,0(a5) # 1f050000 <__end+0x1e04faa0>
	XBR820_UART0->config = UART_CONFIG;
 1000132:	470d                	li	a4,3
 1000134:	c3d8                	sw	a4,4(a5)
	divisor = (SYSTEM_CLOCK + UART_BAUDRATE/2) / UART_BAUDRATE - 1;
	XBR820_UART0->baud_high = (divisor >> 8) & 0xff;
 1000136:	4705                	li	a4,1
 1000138:	cf98                	sw	a4,24(a5)
	XBR820_UART0->baud_low = divisor & 0xff;
 100013a:	4755                	li	a4,21
 100013c:	cfd8                	sw	a4,28(a5)
	XBR820_UART0->enable |= 0xb0; // enable user define buadrate
 100013e:	4398                	lw	a4,0(a5)
 1000140:	0b076713          	ori	a4,a4,176
 1000144:	c398                	sw	a4,0(a5)
  \details Enable a device-specific interrupt in the VIC interrupt controller.
  \param [in]      IRQn  External interrupt number. Value cannot be negative.
 */
__STATIC_INLINE void csi_vic_enable_irq(int32_t IRQn)
{
    CLIC->CLICINT[IRQn].IE |= CLIC_INTIE_IE_Msk;
 1000146:	e0801737          	lui	a4,0xe0801
 100014a:	04974783          	lbu	a5,73(a4) # e0801049 <__end+0xdf800ae9>
 100014e:	0ff7f793          	andi	a5,a5,255
 1000152:	0017e793          	ori	a5,a5,1
 1000156:	04f704a3          	sb	a5,73(a4)
	csi_vic_enable_irq(UART0_RX_IRQn);
}
 100015a:	8082                	ret

0100015c <handle_trap>:

void handle_trap(uint32_t cause, uint32_t mpc) {
	uint32_t iflag;
	
	for (iflag = XBR820_UART0->int_err; iflag & 0x10; iflag = XBR820_UART0->int_err) {
 100015c:	1f0507b7          	lui	a5,0x1f050
 1000160:	4b9c                	lw	a5,16(a5)
 1000162:	a039                	j	1000170 <handle_trap+0x14>
				data = XBR820_UART0->rx_data;
				uart_buffer[uart_buf_pos++] = (char)data;
				uart_buffer[uart_buf_pos] = 0;
			}
		}
		XBR820_UART0->int_err &= ~0x08;
 1000164:	1f0507b7          	lui	a5,0x1f050
 1000168:	4b98                	lw	a4,16(a5)
 100016a:	9b5d                	andi	a4,a4,-9
 100016c:	cb98                	sw	a4,16(a5)
	for (iflag = XBR820_UART0->int_err; iflag & 0x10; iflag = XBR820_UART0->int_err) {
 100016e:	4b9c                	lw	a5,16(a5)
 1000170:	0107f713          	andi	a4,a5,16
 1000174:	cf0d                	beqz	a4,10001ae <handle_trap+0x52>
		if (0 == (iflag & 0x60)) {
 1000176:	0607f793          	andi	a5,a5,96
 100017a:	f7ed                	bnez	a5,1000164 <handle_trap+0x8>
			while (UART_RFIFO_MASK & XBR820_UART0->rfifo) {
 100017c:	1f0507b7          	lui	a5,0x1f050
 1000180:	539c                	lw	a5,32(a5)
 1000182:	8bbd                	andi	a5,a5,15
 1000184:	d3e5                	beqz	a5,1000164 <handle_trap+0x8>
				XBR820_UART0->rfifo = UART_RFIFO_GET;
 1000186:	1f0507b7          	lui	a5,0x1f050
 100018a:	4741                	li	a4,16
 100018c:	d398                	sw	a4,32(a5)
				data = XBR820_UART0->rx_data;
 100018e:	4790                	lw	a2,8(a5)
				uart_buffer[uart_buf_pos++] = (char)data;
 1000190:	1001a683          	lw	a3,256(gp) # 1000350 <uart_buf_pos>
 1000194:	00168793          	addi	a5,a3,1
 1000198:	10f1a023          	sw	a5,256(gp) # 1000350 <uart_buf_pos>
 100019c:	00018713          	mv	a4,gp
 10001a0:	96ba                	add	a3,a3,a4
 10001a2:	00c68023          	sb	a2,0(a3)
				uart_buffer[uart_buf_pos] = 0;
 10001a6:	97ba                	add	a5,a5,a4
 10001a8:	00078023          	sb	zero,0(a5) # 1f050000 <__end+0x1e04faa0>
 10001ac:	bfc1                	j	100017c <handle_trap+0x20>
	}
	
 10001ae:	8082                	ret

010001b0 <Reset_Handler>:
  .section ".text.init"
  .globl Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
	# enable MXSTATUS.THEADISAEE bit[22]
	li t0,  0x400000
 10001b0:	004002b7          	lui	t0,0x400
	csrs mxstatus, t0
 10001b4:	7c02a073          	csrs	mxstatus,t0

.option push
.option norelax
    la      gp, __global_pointer$
 10001b8:	00000197          	auipc	gp,0x0
 10001bc:	09818193          	addi	gp,gp,152 # 1000250 <__etext>
.option pop

    la      a0, Default_Handler
 10001c0:	00000517          	auipc	a0,0x0
 10001c4:	02850513          	addi	a0,a0,40 # 10001e8 <Default_Handler>
    ori     a0, a0, 3
 10001c8:	00356513          	ori	a0,a0,3
    csrw    mtvec, a0
 10001cc:	30551073          	csrw	mtvec,a0

    la      a0, __Vectors
 10001d0:	db018513          	addi	a0,gp,-592 # 1000000 <__Vectors>
    csrw    mtvt, a0
 10001d4:	30751073          	csrw	mtvt,a0

    la      sp, __initial_sp
 10001d8:	31018113          	addi	sp,gp,784 # 1000560 <__end>
    csrw    mscratch, sp
 10001dc:	34011073          	csrw	mscratch,sp

    jal     main
 10001e0:	ee1ff0ef          	jal	ra,10000c0 <main>

010001e4 <__exit>:

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit
 10001e4:	a001                	j	10001e4 <__exit>
 10001e6:	0001                	nop

010001e8 <Default_Handler>:

	

  .align 2
Default_Handler:
  addi sp, sp, -(16*REGBYTES)
 10001e8:	7139                	addi	sp,sp,-64

  SREG x1, 1*REGBYTES(sp)
 10001ea:	c206                	sw	ra,4(sp)
  SREG x2, 2*REGBYTES(sp)
 10001ec:	c40a                	sw	sp,8(sp)
  SREG x3, 3*REGBYTES(sp)
 10001ee:	c60e                	sw	gp,12(sp)
  SREG x4, 4*REGBYTES(sp)
 10001f0:	c812                	sw	tp,16(sp)
  SREG x5, 5*REGBYTES(sp)
 10001f2:	ca16                	sw	t0,20(sp)
  SREG x6, 6*REGBYTES(sp)
 10001f4:	cc1a                	sw	t1,24(sp)
  SREG x7, 7*REGBYTES(sp)
 10001f6:	ce1e                	sw	t2,28(sp)
  SREG x8, 8*REGBYTES(sp)
 10001f8:	d022                	sw	s0,32(sp)
  SREG x9, 9*REGBYTES(sp)
 10001fa:	d226                	sw	s1,36(sp)
  SREG x10, 10*REGBYTES(sp)
 10001fc:	d42a                	sw	a0,40(sp)
  SREG x11, 11*REGBYTES(sp)
 10001fe:	d62e                	sw	a1,44(sp)
  SREG x12, 12*REGBYTES(sp)
 1000200:	d832                	sw	a2,48(sp)
  SREG x13, 13*REGBYTES(sp)
 1000202:	da36                	sw	a3,52(sp)
  SREG x14, 14*REGBYTES(sp)
 1000204:	dc3a                	sw	a4,56(sp)
  SREG x15, 15*REGBYTES(sp)
 1000206:	de3e                	sw	a5,60(sp)

  csrr a0, mcause
 1000208:	34202573          	csrr	a0,mcause
  csrr a1, mepc
 100020c:	341025f3          	csrr	a1,mepc
  mv a2, sp
 1000210:	860a                	mv	a2,sp
  jal handle_trap
 1000212:	f4bff0ef          	jal	ra,100015c <handle_trap>
  csrw mepc, a0
 1000216:	34151073          	csrw	mepc,a0

  # Remain in M-mode after eret
  li t0, 0x00001800
 100021a:	000022b7          	lui	t0,0x2
 100021e:	80028293          	addi	t0,t0,-2048 # 1800 <__Vectors-0xffe800>
  csrs mstatus, t0
 1000222:	3002a073          	csrs	mstatus,t0

  LREG x1, 1*REGBYTES(sp)
 1000226:	4092                	lw	ra,4(sp)
  LREG x2, 2*REGBYTES(sp)
 1000228:	4122                	lw	sp,8(sp)
  LREG x3, 3*REGBYTES(sp)
 100022a:	41b2                	lw	gp,12(sp)
  LREG x4, 4*REGBYTES(sp)
 100022c:	4242                	lw	tp,16(sp)
  LREG x5, 5*REGBYTES(sp)
 100022e:	42d2                	lw	t0,20(sp)
  LREG x6, 6*REGBYTES(sp)
 1000230:	4362                	lw	t1,24(sp)
  LREG x7, 7*REGBYTES(sp)
 1000232:	43f2                	lw	t2,28(sp)
  LREG x8, 8*REGBYTES(sp)
 1000234:	5402                	lw	s0,32(sp)
  LREG x9, 9*REGBYTES(sp)
 1000236:	5492                	lw	s1,36(sp)
  LREG x10, 10*REGBYTES(sp)
 1000238:	5522                	lw	a0,40(sp)
  LREG x11, 11*REGBYTES(sp)
 100023a:	55b2                	lw	a1,44(sp)
  LREG x12, 12*REGBYTES(sp)
 100023c:	5642                	lw	a2,48(sp)
  LREG x13, 13*REGBYTES(sp)
 100023e:	56d2                	lw	a3,52(sp)
  LREG x14, 14*REGBYTES(sp)
 1000240:	5762                	lw	a4,56(sp)
  LREG x15, 15*REGBYTES(sp)
 1000242:	57f2                	lw	a5,60(sp)

  addi sp, sp, (16*REGBYTES)
 1000244:	6121                	addi	sp,sp,64
  mret
 1000246:	30200073          	mret
 100024a:	0000                	unimp
 100024c:	0000                	unimp
	...
