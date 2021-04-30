
.//Obj/i2c_slave_test.elf:     file format elf32-littleriscv


Disassembly of section .text:

01000000 <Reset_Handler>:
  .section ".text.init"
  .globl Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
	# enable MXSTATUS.THEADISAEE bit[22]
	li t0,  0x400000
 1000000:	004002b7          	lui	t0,0x400
	csrs mxstatus, t0
 1000004:	7c02a073          	csrs	mxstatus,t0

.option push
.option norelax
    la      gp, __global_pointer$
 1000008:	00000197          	auipc	gp,0x0
 100000c:	36818193          	addi	gp,gp,872 # 1000370 <__etext>
.option pop

    la      a0, Default_Handler
 1000010:	00000517          	auipc	a0,0x0
 1000014:	1f050513          	addi	a0,a0,496 # 1000200 <Default_Handler>
    ori     a0, a0, 3
 1000018:	00356513          	ori	a0,a0,3
    csrw    mtvec, a0
 100001c:	30551073          	csrw	mtvec,a0

    la      a0, __Vectors
 1000020:	cd018513          	addi	a0,gp,-816 # 1000040 <__Vectors>
    csrw    mtvt, a0
 1000024:	30751073          	csrw	mtvt,a0

    la      sp, __initial_sp
 1000028:	20418113          	addi	sp,gp,516 # 1000574 <__initial_sp>
    csrw    mscratch, sp
 100002c:	34011073          	csrw	mscratch,sp

    jal     main
 1000030:	1f6000ef          	jal	ra,1000226 <main>

01000034 <__exit>:

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit
 1000034:	a001                	j	1000034 <__exit>
	...

01000040 <__Vectors>:
 1000040:	0200 0100 0200 0100 0200 0100 0200 0100     ................
 1000050:	0200 0100 0200 0100 0200 0100 0100 0100     ................
 1000060:	0200 0100 0200 0100 0200 0100 0200 0100     ................
 1000070:	0200 0100 0200 0100 0200 0100 0200 0100     ................
 1000080:	0100 0100 0100 0100 0100 0100 0100 0100     ................
 1000090:	0100 0100 0100 0100 0100 0100 0100 0100     ................
 10000a0:	0100 0100 0100 0100 0100 0100 0100 0100     ................
 10000b0:	0100 0100 0100 0100 0100 0100 0100 0100     ................
 10000c0:	0100 0100 0100 0100 0100 0100 0100 0100     ................
 10000d0:	0100 0100 0100 0100 0100 0100 0100 0100     ................
 10000e0:	0100 0100 0100 0100 0100 0100 0100 0100     ................
 10000f0:	0100 0100 0100 0100 0100 0100 0100 0100     ................

01000100 <Default_IRQHandler>:
    .align  2
    .global Default_IRQHandler
    .weak   Default_IRQHandler
    .type   Default_IRQHandler, %function
Default_IRQHandler:
    addi    sp, sp, -48
 1000100:	7179                	addi	sp,sp,-48
    sw      t0, 4(sp)
 1000102:	c216                	sw	t0,4(sp)
    sw      t1, 8(sp)
 1000104:	c41a                	sw	t1,8(sp)
    csrr    t0, mepc
 1000106:	341022f3          	csrr	t0,mepc
    csrr    t1, mcause
 100010a:	34202373          	csrr	t1,mcause
    sw      t1, 40(sp)
 100010e:	d41a                	sw	t1,40(sp)
    sw      t0, 44(sp)
 1000110:	d616                	sw	t0,44(sp)
    csrs    mstatus, 8
 1000112:	30046073          	csrsi	mstatus,8

    sw      ra, 0(sp)
 1000116:	c006                	sw	ra,0(sp)
    sw      t2, 12(sp)
 1000118:	c61e                	sw	t2,12(sp)
    sw      a0, 16(sp)
 100011a:	c82a                	sw	a0,16(sp)
    sw      a1, 20(sp)
 100011c:	ca2e                	sw	a1,20(sp)
    sw      a2, 24(sp)
 100011e:	cc32                	sw	a2,24(sp)
    sw      a3, 28(sp)
 1000120:	ce36                	sw	a3,28(sp)
    sw      a4, 32(sp)
 1000122:	d03a                	sw	a4,32(sp)
    sw      a5, 36(sp)
 1000124:	d23e                	sw	a5,36(sp)

    andi    a0, t1, 0x3FF
 1000126:	3ff37513          	andi	a0,t1,1023
    jal    handle_irq
 100012a:	142000ef          	jal	ra,100026c <handle_irq>

    csrc    mstatus, 8
 100012e:	30047073          	csrci	mstatus,8

    lw      a1, 40(sp)
 1000132:	55a2                	lw	a1,40(sp)
    andi    a0, a1, 0x3FF
 1000134:	3ff5f513          	andi	a0,a1,1023

    /* clear pending */
    li      a2, 0xE000E100
 1000138:	e000e637          	lui	a2,0xe000e
 100013c:	10060613          	addi	a2,a2,256 # e000e100 <__bss_end__+0xdf00d870>
    add     a2, a2, a0
 1000140:	962a                	add	a2,a2,a0
    lb      a3, 0(a2)
 1000142:	00060683          	lb	a3,0(a2)
    li      a4, 1
 1000146:	4705                	li	a4,1
    not     a4, a4
 1000148:	fff74713          	not	a4,a4
    and     a5, a4, a3
 100014c:	00d777b3          	and	a5,a4,a3
    sb      a5, 0(a2)
 1000150:	00f60023          	sb	a5,0(a2)

    li      t0, MSTATUS_PRV1
 1000154:	000022b7          	lui	t0,0x2
 1000158:	88028293          	addi	t0,t0,-1920 # 1880 <Reset_Handler-0xffe780>
    csrs    mstatus, t0
 100015c:	3002a073          	csrs	mstatus,t0
    csrw    mcause, a1
 1000160:	34259073          	csrw	mcause,a1
    lw      t0, 44(sp)
 1000164:	52b2                	lw	t0,44(sp)
    csrw    mepc, t0
 1000166:	34129073          	csrw	mepc,t0
    lw      ra, 0(sp)
 100016a:	4082                	lw	ra,0(sp)
    lw      t0, 4(sp)
 100016c:	4292                	lw	t0,4(sp)
    lw      t1, 8(sp)
 100016e:	4322                	lw	t1,8(sp)
    lw      t2, 12(sp)
 1000170:	43b2                	lw	t2,12(sp)
    lw      a0, 16(sp)
 1000172:	4542                	lw	a0,16(sp)
    lw      a1, 20(sp)
 1000174:	45d2                	lw	a1,20(sp)
    lw      a2, 24(sp)
 1000176:	4662                	lw	a2,24(sp)
    lw      a3, 28(sp)
 1000178:	46f2                	lw	a3,28(sp)
    lw      a4, 32(sp)
 100017a:	5702                	lw	a4,32(sp)
    lw      a5, 36(sp)
 100017c:	5792                	lw	a5,36(sp)

    addi    sp, sp, 48
 100017e:	6145                	addi	sp,sp,48
    mret
 1000180:	30200073          	mret

01000184 <ExceptionHandler>:
    .align  2
    .global ExceptionHandler
    .type   ExceptionHandler, %function
ExceptionHandler:
    /* Check for interrupt */
    addi    sp, sp, -4
 1000184:	1171                	addi	sp,sp,-4
    sw      t0, 0x0(sp)
 1000186:	c016                	sw	t0,0(sp)
    csrr    t0, mcause
 1000188:	342022f3          	csrr	t0,mcause

    blt     t0, x0, .Lirq
 100018c:	0602c163          	bltz	t0,10001ee <trap+0x2>

    addi    sp, sp, 4
 1000190:	0111                	addi	sp,sp,4

    la      t0, g_trap_sp
 1000192:	40418293          	addi	t0,gp,1028 # 1000774 <g_trap_sp>
    addi    t0, t0, -68
 1000196:	fbc28293          	addi	t0,t0,-68
    sw      x1, 0(t0)
 100019a:	0012a023          	sw	ra,0(t0)
    sw      x2, 4(t0)
 100019e:	0022a223          	sw	sp,4(t0)
    sw      x3, 8(t0)
 10001a2:	0032a423          	sw	gp,8(t0)
    sw      x4, 12(t0)
 10001a6:	0042a623          	sw	tp,12(t0)
    sw      x6, 20(t0)
 10001aa:	0062aa23          	sw	t1,20(t0)
    sw      x7, 24(t0)
 10001ae:	0072ac23          	sw	t2,24(t0)
    sw      x8, 28(t0)
 10001b2:	0082ae23          	sw	s0,28(t0)
    sw      x9, 32(t0)
 10001b6:	0292a023          	sw	s1,32(t0)
    sw      x10, 36(t0)
 10001ba:	02a2a223          	sw	a0,36(t0)
    sw      x11, 40(t0)
 10001be:	02b2a423          	sw	a1,40(t0)
    sw      x12, 44(t0)
 10001c2:	02c2a623          	sw	a2,44(t0)
    sw      x13, 48(t0)
 10001c6:	02d2a823          	sw	a3,48(t0)
    sw      x14, 52(t0)
 10001ca:	02e2aa23          	sw	a4,52(t0)
    sw      x15, 56(t0)
 10001ce:	02f2ac23          	sw	a5,56(t0)
    csrr    a0, mepc
 10001d2:	34102573          	csrr	a0,mepc
    sw      a0, 60(t0)
 10001d6:	02a2ae23          	sw	a0,60(t0)
    csrr    a0, mstatus
 10001da:	30002573          	csrr	a0,mstatus
    sw      a0, 64(t0)
 10001de:	04a2a023          	sw	a0,64(t0)

    mv      a0, t0
 10001e2:	8516                	mv	a0,t0
    lw      t0, -4(sp)
 10001e4:	ffc12283          	lw	t0,-4(sp)
    mv      sp, a0
 10001e8:	812a                	mv	sp,a0
    sw      t0, 16(sp)
 10001ea:	c816                	sw	t0,16(sp)

010001ec <trap>:
trap:
    j     trap
 10001ec:	a001                	j	10001ec <trap>


.Lirq:
    lw      t0, 0x0(sp)
 10001ee:	4282                	lw	t0,0(sp)
    addi    sp, sp, 4
 10001f0:	0111                	addi	sp,sp,4
    j       Default_IRQHandler
 10001f2:	f0fff06f          	j	1000100 <Default_IRQHandler>
 10001f6:	00000013          	nop
 10001fa:	00000013          	nop
 10001fe:	0001                	nop

01000200 <Default_Handler>:
    .align  6
    .weak   Default_Handler
    .global Default_Handler
    .type   Default_Handler, %function
Default_Handler:
    j       ExceptionHandler
 1000200:	b751                	j	1000184 <ExceptionHandler>
	...

01000204 <i2c_slave_init>:
//}

void i2c_slave_init(void)
{
	//
	SLAVEDEV = 0x0000000CUL;
 1000204:	1f0407b7          	lui	a5,0x1f040
 1000208:	4731                	li	a4,12
 100020a:	c398                	sw	a4,0(a5)
	EN_SLAVEB = 0x00000001UL;
 100020c:	4705                	li	a4,1
 100020e:	c3d8                	sw	a4,4(a5)
  \details Enable a device-specific interrupt in the VIC interrupt controller.
  \param [in]      IRQn  External interrupt number. Value cannot be negative.
 */
__STATIC_INLINE void csi_vic_enable_irq(int32_t IRQn)
{
    CLIC->CLICINT[IRQn].IE |= CLIC_INTIE_IE_Msk;
 1000210:	e0801737          	lui	a4,0xe0801
 1000214:	05d74783          	lbu	a5,93(a4) # e080105d <__bss_end__+0xdf8007cd>
 1000218:	0ff7f793          	andi	a5,a5,255
 100021c:	0017e793          	ori	a5,a5,1
 1000220:	04f70ea3          	sb	a5,93(a4)
	csi_vic_enable_irq(I2C_SLAVE_IRQn);
}
 1000224:	8082                	ret

01000226 <main>:

int main() {
 1000226:	1151                	addi	sp,sp,-12
 1000228:	c406                	sw	ra,8(sp)
  \details Enables IRQ interrupts by setting the IE-bit in the PSR.
           Can only be executed in Privileged modes.
 */
__ALWAYS_STATIC_INLINE void __enable_irq(void)
{
    __ASM volatile("csrs mstatus, 8");
 100022a:	30046073          	csrsi	mstatus,8
    __enable_excp_irq();

	//uart_init();
	//_puts("-- UartIRQ test "__DATE__" "__TIME__" --\n");
	
	i2c_slave_init();
 100022e:	3fd9                	jal	1000204 <i2c_slave_init>
	
	while(1) 
 1000230:	a001                	j	1000230 <main+0xa>

01000232 <uart_init>:

uint8_t rp, wp;
void uart_init(void) {
	uint32_t divisor;

	rp = wp = 0;
 1000232:	50018a23          	sb	zero,1300(gp) # 1000884 <wp>
 1000236:	50018aa3          	sb	zero,1301(gp) # 1000885 <rp>
	XBR820_UART->enable = 0;
 100023a:	1f0507b7          	lui	a5,0x1f050
 100023e:	0007a023          	sw	zero,0(a5) # 1f050000 <__bss_end__+0x1e04f770>
	XBR820_UART->config = UART_CONFIG;
 1000242:	470d                	li	a4,3
 1000244:	c3d8                	sw	a4,4(a5)
	divisor = (SYSTEM_CLOCK + UART_BAUDRATE/2) / UART_BAUDRATE - 1;
	XBR820_UART->baud_high = (divisor >> 8) & 0xff;
 1000246:	4705                	li	a4,1
 1000248:	cf98                	sw	a4,24(a5)
	XBR820_UART->baud_low = divisor & 0xff;
 100024a:	4755                	li	a4,21
 100024c:	cfd8                	sw	a4,28(a5)
	XBR820_UART->enable |= 0xb0; // enable user define buadrate
 100024e:	4398                	lw	a4,0(a5)
 1000250:	0b076713          	ori	a4,a4,176
 1000254:	c398                	sw	a4,0(a5)
 1000256:	e0801737          	lui	a4,0xe0801
 100025a:	04974783          	lbu	a5,73(a4) # e0801049 <__bss_end__+0xdf8007b9>
 100025e:	0ff7f793          	andi	a5,a5,255
 1000262:	0017e793          	ori	a5,a5,1
 1000266:	04f704a3          	sb	a5,73(a4)
	csi_vic_enable_irq(UART_RX_IRQn);
}
 100026a:	8082                	ret

0100026c <handle_irq>:

void handle_irq(uint32_t vec) {
	static unsigned char pos = 0;
	
	
	if (I2C_SLAVE_IRQn == vec)
 100026c:	47dd                	li	a5,23
 100026e:	00f50363          	beq	a0,a5,1000274 <handle_irq+0x8>
				pos = 0;
				SLAVEB_CLEAR &= 0xFFFFFFF7;
			}
		}
	}
}
 1000272:	8082                	ret
		if (0x00000008 & SLAVEB_STATUS)		//addr
 1000274:	1f0407b7          	lui	a5,0x1f040
 1000278:	4b9c                	lw	a5,16(a5)
 100027a:	8ba1                	andi	a5,a5,8
 100027c:	cf91                	beqz	a5,1000298 <handle_irq+0x2c>
			SLAVEB_CLEAR |= 0x00000008;
 100027e:	1f0407b7          	lui	a5,0x1f040
 1000282:	4bd8                	lw	a4,20(a5)
 1000284:	00876713          	ori	a4,a4,8
 1000288:	cbd8                	sw	a4,20(a5)
			i2c_slave_buffer[0] = (SLAVEB_DATA >> 8) & 0x000000FF;
 100028a:	479c                	lw	a5,8(a5)
 100028c:	87a1                	srai	a5,a5,0x8
 100028e:	40f18623          	sb	a5,1036(gp) # 100077c <i2c_slave_buffer>
			pos = 1;
 1000292:	4705                	li	a4,1
 1000294:	00e18023          	sb	a4,0(gp) # 1000370 <__etext>
		if (0x00000001 & SLAVEB_STATUS)		//rw int
 1000298:	1f0407b7          	lui	a5,0x1f040
 100029c:	4b9c                	lw	a5,16(a5)
 100029e:	8b85                	andi	a5,a5,1
 10002a0:	cf85                	beqz	a5,10002d8 <handle_irq+0x6c>
			SLAVEB_CLEAR |= 0x00000001;
 10002a2:	1f0407b7          	lui	a5,0x1f040
 10002a6:	4bd8                	lw	a4,20(a5)
 10002a8:	00176713          	ori	a4,a4,1
 10002ac:	cbd8                	sw	a4,20(a5)
			SLAVEB_CLEAR &= 0xFFFFFFFE;			
 10002ae:	4bd8                	lw	a4,20(a5)
 10002b0:	9b79                	andi	a4,a4,-2
 10002b2:	cbd8                	sw	a4,20(a5)
			if (0x00000010 & SLAVEB_STATUS)
 10002b4:	4b9c                	lw	a5,16(a5)
 10002b6:	8bc1                	andi	a5,a5,16
 10002b8:	e385                	bnez	a5,10002d8 <handle_irq+0x6c>
				i2c_slave_buffer[pos] = (SLAVEB_DATA) & 0x000000FF;
 10002ba:	1f0407b7          	lui	a5,0x1f040
 10002be:	4790                	lw	a2,8(a5)
 10002c0:	00018713          	mv	a4,gp
 10002c4:	00074683          	lbu	a3,0(a4)
 10002c8:	40c18793          	addi	a5,gp,1036 # 100077c <i2c_slave_buffer>
 10002cc:	97b6                	add	a5,a5,a3
 10002ce:	00c78023          	sb	a2,0(a5) # 1f040000 <__bss_end__+0x1e03f770>
				pos++;
 10002d2:	0685                	addi	a3,a3,1
 10002d4:	00d70023          	sb	a3,0(a4)
		if (0x00000004 & SLAVEB_STATUS)		//stop
 10002d8:	1f0407b7          	lui	a5,0x1f040
 10002dc:	4b9c                	lw	a5,16(a5)
 10002de:	8b91                	andi	a5,a5,4
 10002e0:	dbc9                	beqz	a5,1000272 <handle_irq+0x6>
			SLAVEB_CLEAR |= 0x00000004;
 10002e2:	1f0407b7          	lui	a5,0x1f040
 10002e6:	4bd8                	lw	a4,20(a5)
 10002e8:	00476713          	ori	a4,a4,4
 10002ec:	cbd8                	sw	a4,20(a5)
			SLAVEB_CLEAR &= 0xFFFFFFFB;			
 10002ee:	4bd8                	lw	a4,20(a5)
 10002f0:	9b6d                	andi	a4,a4,-5
 10002f2:	cbd8                	sw	a4,20(a5)
			if (0x00000010 & SLAVEB_STATUS)
 10002f4:	4b9c                	lw	a5,16(a5)
 10002f6:	8bc1                	andi	a5,a5,16
 10002f8:	ffad                	bnez	a5,1000272 <handle_irq+0x6>
				pos = 0;
 10002fa:	00018023          	sb	zero,0(gp) # 1000370 <__etext>
				SLAVEB_CLEAR &= 0xFFFFFFF7;
 10002fe:	1f040737          	lui	a4,0x1f040
 1000302:	4b5c                	lw	a5,20(a4)
 1000304:	9bdd                	andi	a5,a5,-9
 1000306:	cb5c                	sw	a5,20(a4)
}
 1000308:	b7ad                	j	1000272 <handle_irq+0x6>

0100030a <getchar>:
	XBR820_UART->int_err |= 0x02;
	XBR820_UART->tx_data = ch;
}

int getchar(void) {
	if (rp == wp)
 100030a:	5151c783          	lbu	a5,1301(gp) # 1000885 <rp>
 100030e:	5141c703          	lbu	a4,1300(gp) # 1000884 <wp>
 1000312:	00e78c63          	beq	a5,a4,100032a <getchar+0x20>
		return -1;
	return (int)fifo[rp++];
 1000316:	00178693          	addi	a3,a5,1 # 1f040001 <__bss_end__+0x1e03f771>
 100031a:	50d18aa3          	sb	a3,1301(gp) # 1000885 <rp>
 100031e:	41418713          	addi	a4,gp,1044 # 1000784 <fifo>
 1000322:	97ba                	add	a5,a5,a4
 1000324:	0007c503          	lbu	a0,0(a5)
 1000328:	8082                	ret
		return -1;
 100032a:	557d                	li	a0,-1
}
 100032c:	8082                	ret

0100032e <_putchar>:

void _putchar(int ch) {
	if (ch == '\n') {
 100032e:	47a9                	li	a5,10
 1000330:	00f50f63          	beq	a0,a5,100034e <_putchar+0x20>
	while (XBR820_UART->state & 0x07); // TX not idle
 1000334:	1f0507b7          	lui	a5,0x1f050
 1000338:	4bdc                	lw	a5,20(a5)
 100033a:	8b9d                	andi	a5,a5,7
 100033c:	ffe5                	bnez	a5,1000334 <_putchar+0x6>
	XBR820_UART->int_err |= 0x02;
 100033e:	1f0507b7          	lui	a5,0x1f050
 1000342:	4b98                	lw	a4,16(a5)
 1000344:	00276713          	ori	a4,a4,2
 1000348:	cb98                	sw	a4,16(a5)
	XBR820_UART->tx_data = ch;
 100034a:	c7c8                	sw	a0,12(a5)
		_putc('\r');
	}
	_putc(ch);
}
 100034c:	8082                	ret
	while (XBR820_UART->state & 0x07); // TX not idle
 100034e:	1f0507b7          	lui	a5,0x1f050
 1000352:	4bdc                	lw	a5,20(a5)
 1000354:	8b9d                	andi	a5,a5,7
 1000356:	ffe5                	bnez	a5,100034e <_putchar+0x20>
	XBR820_UART->int_err |= 0x02;
 1000358:	1f0507b7          	lui	a5,0x1f050
 100035c:	4b98                	lw	a4,16(a5)
 100035e:	00276713          	ori	a4,a4,2
 1000362:	cb98                	sw	a4,16(a5)
	XBR820_UART->tx_data = ch;
 1000364:	4735                	li	a4,13
 1000366:	c7d8                	sw	a4,12(a5)
	while (XBR820_UART->state & 0x07); // TX not idle
 1000368:	b7f1                	j	1000334 <_putchar+0x6>
 100036a:	0000                	unimp
 100036c:	0000                	unimp
	...
