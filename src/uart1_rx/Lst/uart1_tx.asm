
.//Obj/uart1_tx.elf:     file format elf32-littleriscv


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
 100000c:	6d818193          	addi	gp,gp,1752 # 10006e0 <__etext>
.option pop

    la      a0, Default_Handler
 1000010:	00000517          	auipc	a0,0x0
 1000014:	1b050513          	addi	a0,a0,432 # 10001c0 <Default_Handler>
    ori     a0, a0, 3
 1000018:	00356513          	ori	a0,a0,3
    csrw    mtvec, a0
 100001c:	30551073          	csrw	mtvec,a0

    la      a0, __Vectors
 1000020:	96018513          	addi	a0,gp,-1696 # 1000040 <__Vectors>
    csrw    mtvt, a0
 1000024:	30751073          	csrw	mtvt,a0

    la      sp, __initial_sp
 1000028:	21c18113          	addi	sp,gp,540 # 10008fc <__initial_sp>
    csrw    mscratch, sp
 100002c:	34011073          	csrw	mscratch,sp

    jal     main
 1000030:	334000ef          	jal	ra,1000364 <main>

01000034 <__exit>:

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit
 1000034:	a001                	j	1000034 <__exit>
	...

01000040 <__Vectors>:
 1000040:	01c0 0100 01c0 0100 01c0 0100 01c0 0100     ................
 1000050:	01c0 0100 01c0 0100 01c0 0100 0104 0100     ................
 1000060:	01c0 0100 01c0 0100 01c0 0100 01c0 0100     ................
 1000070:	01c0 0100 01c0 0100 01c0 0100 01c0 0100     ................
 1000080:	0104 0100 0104 0100 0104 0100 0104 0100     ................
 1000090:	0104 0100 0104 0100 0104 0100 0104 0100     ................
 10000a0:	0104 0100 0104 0100 0104 0100 0104 0100     ................
 10000b0:	0104 0100 0104 0100 0104 0100 0104 0100     ................
 10000c0:	0104 0100 0104 0100 0104 0100 0104 0100     ................
 10000d0:	0104 0100 0104 0100 0104 0100 0104 0100     ................
 10000e0:	0104 0100 0104 0100 0104 0100 0104 0100     ................
 10000f0:	0104 0100 0104 0100 0104 0100 0104 0100     ................

01000100 <__bkpt_label>:
    ebreak
 1000100:	9002                	ebreak
 1000102:	0001                	nop

01000104 <Default_IRQHandler>:
    .align  2
    .global Default_IRQHandler
    .weak   Default_IRQHandler
    .type   Default_IRQHandler, %function
Default_IRQHandler:
    addi    sp, sp, -48
 1000104:	7179                	addi	sp,sp,-48
    sw      t0, 4(sp)
 1000106:	c216                	sw	t0,4(sp)
    sw      t1, 8(sp)
 1000108:	c41a                	sw	t1,8(sp)
    csrr    t0, mepc
 100010a:	341022f3          	csrr	t0,mepc
    csrr    t1, mcause
 100010e:	34202373          	csrr	t1,mcause
    sw      t1, 40(sp)
 1000112:	d41a                	sw	t1,40(sp)
    sw      t0, 44(sp)
 1000114:	d616                	sw	t0,44(sp)
    csrs    mstatus, 8
 1000116:	30046073          	csrsi	mstatus,8

    sw      ra, 0(sp)
 100011a:	c006                	sw	ra,0(sp)
    sw      t2, 12(sp)
 100011c:	c61e                	sw	t2,12(sp)
    sw      a0, 16(sp)
 100011e:	c82a                	sw	a0,16(sp)
    sw      a1, 20(sp)
 1000120:	ca2e                	sw	a1,20(sp)
    sw      a2, 24(sp)
 1000122:	cc32                	sw	a2,24(sp)
    sw      a3, 28(sp)
 1000124:	ce36                	sw	a3,28(sp)
    sw      a4, 32(sp)
 1000126:	d03a                	sw	a4,32(sp)
    sw      a5, 36(sp)
 1000128:	d23e                	sw	a5,36(sp)

    andi    a0, t1, 0x3FF
 100012a:	3ff37513          	andi	a0,t1,1023
    jal    handle_irq
 100012e:	308000ef          	jal	ra,1000436 <handle_irq>

    csrc    mstatus, 8
 1000132:	30047073          	csrci	mstatus,8

    lw      a1, 40(sp)
 1000136:	55a2                	lw	a1,40(sp)
    andi    a0, a1, 0x3FF
 1000138:	3ff5f513          	andi	a0,a1,1023

    /* clear pending */
    li      a2, 0xE000E100
 100013c:	e000e637          	lui	a2,0xe000e
 1000140:	10060613          	addi	a2,a2,256 # e000e100 <__bss_end__+0xdf00d450>
    add     a2, a2, a0
 1000144:	962a                	add	a2,a2,a0
    lb      a3, 0(a2)
 1000146:	00060683          	lb	a3,0(a2)
    li      a4, 1
 100014a:	4705                	li	a4,1
    not     a4, a4
 100014c:	fff74713          	not	a4,a4
    and     a5, a4, a3
 1000150:	00d777b3          	and	a5,a4,a3
    sb      a5, 0(a2)
 1000154:	00f60023          	sb	a5,0(a2)

    li      t0, MSTATUS_PRV1
 1000158:	000022b7          	lui	t0,0x2
 100015c:	88028293          	addi	t0,t0,-1920 # 1880 <Reset_Handler-0xffe780>
    csrs    mstatus, t0
 1000160:	3002a073          	csrs	mstatus,t0
    csrw    mcause, a1
 1000164:	34259073          	csrw	mcause,a1
    lw      t0, 44(sp)
 1000168:	52b2                	lw	t0,44(sp)
    csrw    mepc, t0
 100016a:	34129073          	csrw	mepc,t0
    lw      ra, 0(sp)
 100016e:	4082                	lw	ra,0(sp)
    lw      t0, 4(sp)
 1000170:	4292                	lw	t0,4(sp)
    lw      t1, 8(sp)
 1000172:	4322                	lw	t1,8(sp)
    lw      t2, 12(sp)
 1000174:	43b2                	lw	t2,12(sp)
    lw      a0, 16(sp)
 1000176:	4542                	lw	a0,16(sp)
    lw      a1, 20(sp)
 1000178:	45d2                	lw	a1,20(sp)
    lw      a2, 24(sp)
 100017a:	4662                	lw	a2,24(sp)
    lw      a3, 28(sp)
 100017c:	46f2                	lw	a3,28(sp)
    lw      a4, 32(sp)
 100017e:	5702                	lw	a4,32(sp)
    lw      a5, 36(sp)
 1000180:	5792                	lw	a5,36(sp)

    addi    sp, sp, 48
 1000182:	6145                	addi	sp,sp,48
    mret
 1000184:	30200073          	mret
 1000188:	00000013          	nop
 100018c:	00000013          	nop
 1000190:	00000013          	nop
 1000194:	00000013          	nop
 1000198:	00000013          	nop
 100019c:	00000013          	nop
 10001a0:	00000013          	nop
 10001a4:	00000013          	nop
 10001a8:	00000013          	nop
 10001ac:	00000013          	nop
 10001b0:	00000013          	nop
 10001b4:	00000013          	nop
 10001b8:	00000013          	nop
 10001bc:	00000013          	nop

010001c0 <Default_Handler>:
    .weak   Default_Handler
    .global Default_Handler
    .type   Default_Handler, %function
Default_Handler:
    /* Check for interrupt */
    addi    sp, sp, -4
 10001c0:	1171                	addi	sp,sp,-4
    sw      t0, 0x0(sp)
 10001c2:	c016                	sw	t0,0(sp)
    csrr    t0, mcause
 10001c4:	342022f3          	csrr	t0,mcause

    blt     t0, x0, .Lirq
 10001c8:	0602c163          	bltz	t0,100022a <trap+0x2>

    addi    sp, sp, 4
 10001cc:	0111                	addi	sp,sp,4

    la      t0, g_trap_sp
 10001ce:	41c18293          	addi	t0,gp,1052 # 1000afc <g_trap_sp>
    addi    t0, t0, -68
 10001d2:	fbc28293          	addi	t0,t0,-68
    sw      x1, 0(t0)
 10001d6:	0012a023          	sw	ra,0(t0)
    sw      x2, 4(t0)
 10001da:	0022a223          	sw	sp,4(t0)
    sw      x3, 8(t0)
 10001de:	0032a423          	sw	gp,8(t0)
    sw      x4, 12(t0)
 10001e2:	0042a623          	sw	tp,12(t0)
    sw      x6, 20(t0)
 10001e6:	0062aa23          	sw	t1,20(t0)
    sw      x7, 24(t0)
 10001ea:	0072ac23          	sw	t2,24(t0)
    sw      x8, 28(t0)
 10001ee:	0082ae23          	sw	s0,28(t0)
    sw      x9, 32(t0)
 10001f2:	0292a023          	sw	s1,32(t0)
    sw      x10, 36(t0)
 10001f6:	02a2a223          	sw	a0,36(t0)
    sw      x11, 40(t0)
 10001fa:	02b2a423          	sw	a1,40(t0)
    sw      x12, 44(t0)
 10001fe:	02c2a623          	sw	a2,44(t0)
    sw      x13, 48(t0)
 1000202:	02d2a823          	sw	a3,48(t0)
    sw      x14, 52(t0)
 1000206:	02e2aa23          	sw	a4,52(t0)
    sw      x15, 56(t0)
 100020a:	02f2ac23          	sw	a5,56(t0)
    csrr    a0, mepc
 100020e:	34102573          	csrr	a0,mepc
    sw      a0, 60(t0)
 1000212:	02a2ae23          	sw	a0,60(t0)
    csrr    a0, mstatus
 1000216:	30002573          	csrr	a0,mstatus
    sw      a0, 64(t0)
 100021a:	04a2a023          	sw	a0,64(t0)

    mv      a0, t0
 100021e:	8516                	mv	a0,t0
    lw      t0, -4(sp)
 1000220:	ffc12283          	lw	t0,-4(sp)
    mv      sp, a0
 1000224:	812a                	mv	sp,a0
    sw      t0, 16(sp)
 1000226:	c816                	sw	t0,16(sp)

01000228 <trap>:
trap:
    j     trap
 1000228:	a001                	j	1000228 <trap>


.Lirq:
    lw      t0, 0x0(sp)
 100022a:	4282                	lw	t0,0(sp)
    addi    sp, sp, 4
 100022c:	0111                	addi	sp,sp,4
    j       Default_IRQHandler
 100022e:	ed7ff06f          	j	1000104 <Default_IRQHandler>
	...

01000234 <i2c_master_init>:

void i2c_master_init(void)
{
	unsigned int i = 0;   //index
	//
	SLAVE_ADDR = 0x0000000AUL;	//stm32 slave
 1000234:	1f0307b7          	lui	a5,0x1f030
 1000238:	4729                	li	a4,10
 100023a:	c398                	sw	a4,0(a5)
	
	MAST_CLK = 0x00000020UL;		//I2C CLK: 16000000/32/8 = 62.5K  pass!
 100023c:	02000713          	li	a4,32
 1000240:	dbd8                	sw	a4,52(a5)
	//MAST_CLK = 0x00000010UL;		//I2C CLK: 16000000/16/8 = 125K  pass!
	//MAST_CLK = 0x00000008UL;		//I2C CLK: 16000000/8/8 = 250K  not ok!
	
	MAST_EN = 0x00000001UL;			//enable master clock
 1000242:	4705                	li	a4,1
 1000244:	df98                	sw	a4,56(a5)
	
	MAST_MISC = 0x00000002UL;		//enable last ack
 1000246:	4709                	li	a4,2
 1000248:	cb98                	sw	a4,16(a5)
	
	//MAST_INT_EN |= 0x0000000f;//enable int source
	//MAST_INT_EN |= 0x00000008;//enable int source
	MAST_INT_EN |= 0x0000000A;  //enable int source
 100024a:	57d8                	lw	a4,44(a5)
 100024c:	00a76713          	ori	a4,a4,10
 1000250:	d7d8                	sw	a4,44(a5)
  \details Enable a device-specific interrupt in the VIC interrupt controller.
  \param [in]      IRQn  External interrupt number. Value cannot be negative.
 */
__STATIC_INLINE void csi_vic_enable_irq(int32_t IRQn)
{
    CLIC->CLICINT[IRQn].IE |= CLIC_INTIE_IE_Msk;
 1000252:	e0801737          	lui	a4,0xe0801
 1000256:	05974783          	lbu	a5,89(a4) # e0801059 <__bss_end__+0xdf8003a9>
 100025a:	0ff7f793          	andi	a5,a5,255
 100025e:	0017e793          	ori	a5,a5,1
 1000262:	04f70ca3          	sb	a5,89(a4)
	
	csi_vic_enable_irq(I2C_MASTER_IRQn);
	
	i2c_master_send_buffer[0] = 0x12;
 1000266:	4749                	li	a4,18
 1000268:	42e18223          	sb	a4,1060(gp) # 1000b04 <i2c_master_send_buffer>
	i2c_master_send_buffer[1] = 0x55;
 100026c:	42418793          	addi	a5,gp,1060 # 1000b04 <i2c_master_send_buffer>
 1000270:	05500713          	li	a4,85
 1000274:	00e780a3          	sb	a4,1(a5) # 1f030001 <__bss_end__+0x1e02f351>
	i2c_master_send_buffer[2] = 0xAA;
 1000278:	faa00713          	li	a4,-86
 100027c:	00e78123          	sb	a4,2(a5)
	i2c_master_send_buffer[3] = 0xEB;
 1000280:	572d                	li	a4,-21
 1000282:	00e781a3          	sb	a4,3(a5)
	i2c_master_send_buffer[4] = 0x90;
 1000286:	f9000713          	li	a4,-112
 100028a:	00e78223          	sb	a4,4(a5)
	i2c_master_send_buffer[5] = 0x99;
 100028e:	f9900713          	li	a4,-103
 1000292:	00e782a3          	sb	a4,5(a5)
	i2c_master_send_buffer[6] = 0x2A;
 1000296:	02a00713          	li	a4,42
 100029a:	00e78323          	sb	a4,6(a5)
	i2c_master_send_buffer[7] = 0xBE;
 100029e:	fbe00713          	li	a4,-66
 10002a2:	00e783a3          	sb	a4,7(a5)
	
	for (i = 8;i<200;i++)
 10002a6:	4721                	li	a4,8
 10002a8:	0c700793          	li	a5,199
 10002ac:	00e7eb63          	bltu	a5,a4,10002c2 <i2c_master_init+0x8e>
	{
		i2c_master_send_buffer[i] = i;
 10002b0:	0ff77693          	andi	a3,a4,255
 10002b4:	42418793          	addi	a5,gp,1060 # 1000b04 <i2c_master_send_buffer>
 10002b8:	97ba                	add	a5,a5,a4
 10002ba:	00d78023          	sb	a3,0(a5)
	for (i = 8;i<200;i++)
 10002be:	0705                	addi	a4,a4,1
 10002c0:	b7e5                	j	10002a8 <i2c_master_init+0x74>
	}
}
 10002c2:	8082                	ret

010002c4 <timer0_init>:

void timer0_init(unsigned int init_val)
{
	tm_count = 0;
 10002c4:	5c01a223          	sw	zero,1476(gp) # 1000ca4 <tm_count>
	TIMER0_REG = init_val;	//load the initial value
 10002c8:	1f0207b7          	lui	a5,0x1f020
 10002cc:	c788                	sw	a0,8(a5)
	TIMER_CR |= 0x00000010;//enable timer0
 10002ce:	4398                	lw	a4,0(a5)
 10002d0:	01076713          	ori	a4,a4,16
 10002d4:	c398                	sw	a4,0(a5)
 10002d6:	e0801737          	lui	a4,0xe0801
 10002da:	06974783          	lbu	a5,105(a4) # e0801069 <__bss_end__+0xdf8003b9>
 10002de:	0ff7f793          	andi	a5,a5,255
 10002e2:	0017e793          	ori	a5,a5,1
 10002e6:	06f704a3          	sb	a5,105(a4)
	
	csi_vic_enable_irq(TIM0_IRQn);
}
 10002ea:	8082                	ret

010002ec <i2c_master_transmit>:

void i2c_master_transmit(unsigned int trans_num)
{
	NWORD = trans_num - 1;
 10002ec:	157d                	addi	a0,a0,-1
 10002ee:	1f0306b7          	lui	a3,0x1f030
 10002f2:	c2c8                	sw	a0,4(a3)
	DATA_2_IICM0 = (i2c_master_send_buffer[3] << 24) | (i2c_master_send_buffer[2] << 16) | (i2c_master_send_buffer[1] << 8) | (i2c_master_send_buffer[0]);
 10002f4:	42418593          	addi	a1,gp,1060 # 1000b04 <i2c_master_send_buffer>
 10002f8:	0035c783          	lbu	a5,3(a1)
 10002fc:	07e2                	slli	a5,a5,0x18
 10002fe:	0025c703          	lbu	a4,2(a1)
 1000302:	0ff77713          	andi	a4,a4,255
 1000306:	0742                	slli	a4,a4,0x10
 1000308:	8fd9                	or	a5,a5,a4
 100030a:	0015c703          	lbu	a4,1(a1)
 100030e:	0ff77713          	andi	a4,a4,255
 1000312:	0722                	slli	a4,a4,0x8
 1000314:	8fd9                	or	a5,a5,a4
 1000316:	4241c703          	lbu	a4,1060(gp) # 1000b04 <i2c_master_send_buffer>
 100031a:	0ff77713          	andi	a4,a4,255
 100031e:	8fd9                	or	a5,a5,a4
 1000320:	ce9c                	sw	a5,24(a3)
	MASTER_CPU_CMD = 0x00000011UL;
 1000322:	47c5                	li	a5,17
 1000324:	c69c                	sw	a5,8(a3)
}
 1000326:	8082                	ret

01000328 <i2c_master_rev>:

void i2c_master_rev(unsigned int rev_num)
{
	NWORD = rev_num - 1;	
 1000328:	157d                	addi	a0,a0,-1
 100032a:	1f0307b7          	lui	a5,0x1f030
 100032e:	c3c8                	sw	a0,4(a5)
	MASTER_CPU_CMD = 0x00000012UL;
 1000330:	4749                	li	a4,18
 1000332:	c798                	sw	a4,8(a5)
}
 1000334:	8082                	ret

01000336 <i2c_master_restart_rev1>:

void i2c_master_restart_rev1(unsigned char address, unsigned int rev_num)
{
	MAST_READ_ADDR = address;
 1000336:	1f0307b7          	lui	a5,0x1f030
 100033a:	cbc8                	sw	a0,20(a5)
	NWORD = rev_num - 1;
 100033c:	15fd                	addi	a1,a1,-1
 100033e:	c3cc                	sw	a1,4(a5)
	MASTER_CPU_CMD = 0x00000017UL;
 1000340:	475d                	li	a4,23
 1000342:	c798                	sw	a4,8(a5)
}
 1000344:	8082                	ret

01000346 <i2c_master_restart_rev2>:

void i2c_master_restart_rev2(unsigned short address, unsigned int rev_num)
{
	MAST_READ_ADDR = address;
 1000346:	1f0307b7          	lui	a5,0x1f030
 100034a:	cbc8                	sw	a0,20(a5)
	NWORD = rev_num - 1;
 100034c:	15fd                	addi	a1,a1,-1
 100034e:	c3cc                	sw	a1,4(a5)
	MASTER_CPU_CMD = 0x0000001FUL;
 1000350:	477d                	li	a4,31
 1000352:	c798                	sw	a4,8(a5)
}
 1000354:	8082                	ret

01000356 <delay>:

void delay(unsigned int val)
{
	tm_count = 0;
 1000356:	5c01a223          	sw	zero,1476(gp) # 1000ca4 <tm_count>
	while(tm_count < val)
 100035a:	5c41a783          	lw	a5,1476(gp) # 1000ca4 <tm_count>
 100035e:	fea7eee3          	bltu	a5,a0,100035a <delay+0x4>
	{
		//
	}	
}
 1000362:	8082                	ret

01000364 <main>:

int main() 
{	
 1000364:	1151                	addi	sp,sp,-12
 1000366:	c406                	sw	ra,8(sp)
 1000368:	c222                	sw	s0,4(sp)
	unsigned int i = 0;
	i2c_master_init();
 100036a:	35e9                	jal	1000234 <i2c_master_init>
	timer0_init(16000);	
 100036c:	6511                	lui	a0,0x4
 100036e:	e8050513          	addi	a0,a0,-384 # 3e80 <Reset_Handler-0xffc180>
 1000372:	3f89                	jal	10002c4 <timer0_init>
	ii = 0;
 1000374:	0001a823          	sw	zero,16(gp) # 10006f0 <ii>
	ii2 = 0;
 1000378:	0001a223          	sw	zero,4(gp) # 10006e4 <ii2>
	master_work_flag = 0;
 100037c:	00018023          	sb	zero,0(gp) # 10006e0 <__etext>
	buffer_pointer = 0;
 1000380:	0001a423          	sw	zero,8(gp) # 10006e8 <buffer_pointer>
	buffer_cycle = 0;
 1000384:	0001aa23          	sw	zero,20(gp) # 10006f4 <buffer_cycle>
	
	buffer_pointer2 = 0;
 1000388:	0001a623          	sw	zero,12(gp) # 10006ec <buffer_pointer2>
	buffer_cycle2 = 0;	
 100038c:	0001ac23          	sw	zero,24(gp) # 10006f8 <buffer_cycle2>
  \details Enables IRQ interrupts by setting the IE-bit in the PSR.
           Can only be executed in Privileged modes.
 */
__ALWAYS_STATIC_INLINE void __enable_irq(void)
{
    __ASM volatile("csrs mstatus, 8");
 1000390:	30046073          	csrsi	mstatus,8
		}
		
		if (1)
		{
			//restart rev mode1
			i2c_master_restart_rev1(0x55, 128);
 1000394:	08000593          	li	a1,128
 1000398:	05500513          	li	a0,85
 100039c:	3f69                	jal	1000336 <i2c_master_restart_rev1>
			
			while(master_work_flag==0)
 100039e:	0001c783          	lbu	a5,0(gp) # 10006e0 <__etext>
 10003a2:	dff5                	beqz	a5,100039e <main+0x3a>
			{
				//
			}
			master_work_flag = 0;
 10003a4:	00018023          	sb	zero,0(gp) # 10006e0 <__etext>
			i2c_master_rev_buffer[4+(buffer_cycle2-1)*8] = IICM_2_DATA1 & 0x000000ff;
 10003a8:	1f030637          	lui	a2,0x1f030
 10003ac:	524c                	lw	a1,36(a2)
 10003ae:	0181a783          	lw	a5,24(gp) # 10006f8 <buffer_cycle2>
 10003b2:	200006b7          	lui	a3,0x20000
 10003b6:	16fd                	addi	a3,a3,-1
 10003b8:	97b6                	add	a5,a5,a3
 10003ba:	078e                	slli	a5,a5,0x3
 10003bc:	0791                	addi	a5,a5,4
 10003be:	0ff5f593          	andi	a1,a1,255
 10003c2:	4ec18713          	addi	a4,gp,1260 # 1000bcc <i2c_master_rev_buffer>
 10003c6:	97ba                	add	a5,a5,a4
 10003c8:	00b78023          	sb	a1,0(a5) # 1f030000 <__bss_end__+0x1e02f350>
			i2c_master_rev_buffer[5+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x0000ff00) >> 8;
 10003cc:	524c                	lw	a1,36(a2)
 10003ce:	85a1                	srai	a1,a1,0x8
 10003d0:	0181a783          	lw	a5,24(gp) # 10006f8 <buffer_cycle2>
 10003d4:	97b6                	add	a5,a5,a3
 10003d6:	078e                	slli	a5,a5,0x3
 10003d8:	0795                	addi	a5,a5,5
 10003da:	0ff5f593          	andi	a1,a1,255
 10003de:	97ba                	add	a5,a5,a4
 10003e0:	00b78023          	sb	a1,0(a5)
			i2c_master_rev_buffer[6+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x00ff0000) >> 16;
 10003e4:	524c                	lw	a1,36(a2)
 10003e6:	85c1                	srai	a1,a1,0x10
 10003e8:	0181a783          	lw	a5,24(gp) # 10006f8 <buffer_cycle2>
 10003ec:	97b6                	add	a5,a5,a3
 10003ee:	078e                	slli	a5,a5,0x3
 10003f0:	0799                	addi	a5,a5,6
 10003f2:	0ff5f593          	andi	a1,a1,255
 10003f6:	97ba                	add	a5,a5,a4
 10003f8:	00b78023          	sb	a1,0(a5)
			i2c_master_rev_buffer[7+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0xff000000) >> 24;				
 10003fc:	5250                	lw	a2,36(a2)
 10003fe:	0181a783          	lw	a5,24(gp) # 10006f8 <buffer_cycle2>
 1000402:	97b6                	add	a5,a5,a3
 1000404:	078e                	slli	a5,a5,0x3
 1000406:	079d                	addi	a5,a5,7
 1000408:	01865693          	srli	a3,a2,0x18
 100040c:	97ba                	add	a5,a5,a4
 100040e:	00d78023          	sb	a3,0(a5)
		
			delay(5000);	
 1000412:	6505                	lui	a0,0x1
 1000414:	38850513          	addi	a0,a0,904 # 1388 <Reset_Handler-0xffec78>
 1000418:	3f3d                	jal	1000356 <delay>
			buffer_cycle2 = 0;	
 100041a:	0001ac23          	sw	zero,24(gp) # 10006f8 <buffer_cycle2>
			
			for (i=0;i<200;i++)
 100041e:	4701                	li	a4,0
 1000420:	0c700793          	li	a5,199
 1000424:	f6e7e8e3          	bltu	a5,a4,1000394 <main+0x30>
			{
				i2c_master_rev_buffer[i] = 0x00;
 1000428:	4ec18793          	addi	a5,gp,1260 # 1000bcc <i2c_master_rev_buffer>
 100042c:	97ba                	add	a5,a5,a4
 100042e:	00078023          	sb	zero,0(a5)
			for (i=0;i<200;i++)
 1000432:	0705                	addi	a4,a4,1
 1000434:	b7f5                	j	1000420 <main+0xbc>

01000436 <handle_irq>:
volatile unsigned int buffer_cycle2 = 0;

void handle_irq(uint32_t vec) 
{	
	
	if (I2C_MASTER_IRQn == vec)
 1000436:	47d9                	li	a5,22
 1000438:	00f50663          	beq	a0,a5,1000444 <handle_irq+0xe>
		{
			MAST_CLEAR |= 0x00000001;
		}
	}
	
	if (TIM0_IRQn == vec)
 100043c:	47e9                	li	a5,26
 100043e:	28f50063          	beq	a0,a5,10006be <handle_irq+0x288>
	{
		tm_count++;
		TIMER_CR |= 0x00000100;
	}
}
 1000442:	8082                	ret
		ii2++;
 1000444:	00418793          	addi	a5,gp,4 # 10006e4 <ii2>
 1000448:	4398                	lw	a4,0(a5)
 100044a:	0705                	addi	a4,a4,1
 100044c:	c398                	sw	a4,0(a5)
		if (0x00000010 & MAST_STATUS) // byte done
 100044e:	1f0307b7          	lui	a5,0x1f030
 1000452:	579c                	lw	a5,40(a5)
 1000454:	8bc1                	andi	a5,a5,16
 1000456:	c7c1                	beqz	a5,10004de <handle_irq+0xa8>
			MAST_CLEAR |= 0x00000008;
 1000458:	1f030737          	lui	a4,0x1f030
 100045c:	5b1c                	lw	a5,48(a4)
 100045e:	0087e793          	ori	a5,a5,8
 1000462:	db1c                	sw	a5,48(a4)
			buffer_pointer = (0x0000ff00 & MAST_STATUS) >> 8;
 1000464:	5714                	lw	a3,40(a4)
 1000466:	86a1                	srai	a3,a3,0x8
 1000468:	0ff6f693          	andi	a3,a3,255
 100046c:	00418793          	addi	a5,gp,4 # 10006e4 <ii2>
 1000470:	c3d4                	sw	a3,4(a5)
			buffer_pointer2 = (0x0000ff00 & MAST_STATUS) >> 8;
 1000472:	5714                	lw	a3,40(a4)
 1000474:	86a1                	srai	a3,a3,0x8
 1000476:	0ff6f693          	andi	a3,a3,255
 100047a:	c794                	sw	a3,8(a5)
			i2c_master_sended_buffer[ii] = (0x0000ff00 & MAST_STATUS) >> 8;
 100047c:	5718                	lw	a4,40(a4)
 100047e:	8721                	srai	a4,a4,0x8
 1000480:	47d4                	lw	a3,12(a5)
 1000482:	0ff77713          	andi	a4,a4,255
 1000486:	5b418613          	addi	a2,gp,1460 # 1000c94 <i2c_master_sended_buffer>
 100048a:	96b2                	add	a3,a3,a2
 100048c:	00e68023          	sb	a4,0(a3) # 20000000 <__bss_end__+0x1efff350>
			ii++;
 1000490:	47d8                	lw	a4,12(a5)
 1000492:	0705                	addi	a4,a4,1
 1000494:	c7d8                	sw	a4,12(a5)
			if (16 <= ii)
 1000496:	47d8                	lw	a4,12(a5)
 1000498:	47bd                	li	a5,15
 100049a:	00e7f663          	bgeu	a5,a4,10004a6 <handle_irq+0x70>
				ii = 0;
 100049e:	00418793          	addi	a5,gp,4 # 10006e4 <ii2>
 10004a2:	0007a623          	sw	zero,12(a5) # 1f03000c <__bss_end__+0x1e02f35c>
			if (buffer_pointer % 8 == 1)
 10004a6:	00418793          	addi	a5,gp,4 # 10006e4 <ii2>
 10004aa:	43dc                	lw	a5,4(a5)
 10004ac:	8b9d                	andi	a5,a5,7
 10004ae:	4705                	li	a4,1
 10004b0:	06e78e63          	beq	a5,a4,100052c <handle_irq+0xf6>
			else if (buffer_pointer % 8 == 4)
 10004b4:	00418793          	addi	a5,gp,4 # 10006e4 <ii2>
 10004b8:	43dc                	lw	a5,4(a5)
 10004ba:	8b9d                	andi	a5,a5,7
 10004bc:	4711                	li	a4,4
 10004be:	0ce78663          	beq	a5,a4,100058a <handle_irq+0x154>
			if (buffer_pointer2 % 8 == 1)
 10004c2:	00418793          	addi	a5,gp,4 # 10006e4 <ii2>
 10004c6:	479c                	lw	a5,8(a5)
 10004c8:	8b9d                	andi	a5,a5,7
 10004ca:	4705                	li	a4,1
 10004cc:	10e78a63          	beq	a5,a4,10005e0 <handle_irq+0x1aa>
			else if (buffer_pointer2 % 8 == 5)
 10004d0:	00418793          	addi	a5,gp,4 # 10006e4 <ii2>
 10004d4:	479c                	lw	a5,8(a5)
 10004d6:	8b9d                	andi	a5,a5,7
 10004d8:	4715                	li	a4,5
 10004da:	18e78163          	beq	a5,a4,100065c <handle_irq+0x226>
		if (0x00000008 & MAST_STATUS)//idle
 10004de:	1f0307b7          	lui	a5,0x1f030
 10004e2:	5798                	lw	a4,40(a5)
		if (0x00000004 & MAST_STATUS)//timeout
 10004e4:	579c                	lw	a5,40(a5)
 10004e6:	8b91                	andi	a5,a5,4
 10004e8:	c799                	beqz	a5,10004f6 <handle_irq+0xc0>
			MAST_CLEAR |= 0x00000004;
 10004ea:	1f030737          	lui	a4,0x1f030
 10004ee:	5b1c                	lw	a5,48(a4)
 10004f0:	0047e793          	ori	a5,a5,4
 10004f4:	db1c                	sw	a5,48(a4)
		if (0x00000002 & MAST_STATUS)//after stop
 10004f6:	1f0307b7          	lui	a5,0x1f030
 10004fa:	579c                	lw	a5,40(a5)
 10004fc:	8b89                	andi	a5,a5,2
 10004fe:	cb91                	beqz	a5,1000512 <handle_irq+0xdc>
			MAST_CLEAR |= 0x00000002;
 1000500:	1f030737          	lui	a4,0x1f030
 1000504:	5b1c                	lw	a5,48(a4)
 1000506:	0027e793          	ori	a5,a5,2
 100050a:	db1c                	sw	a5,48(a4)
			master_work_flag = 1;
 100050c:	4705                	li	a4,1
 100050e:	00e18023          	sb	a4,0(gp) # 10006e0 <__etext>
		if (0x00000001 & MAST_STATUS)//no ack
 1000512:	1f0307b7          	lui	a5,0x1f030
 1000516:	579c                	lw	a5,40(a5)
 1000518:	8b85                	andi	a5,a5,1
 100051a:	f20781e3          	beqz	a5,100043c <handle_irq+0x6>
			MAST_CLEAR |= 0x00000001;
 100051e:	1f030737          	lui	a4,0x1f030
 1000522:	5b1c                	lw	a5,48(a4)
 1000524:	0017e793          	ori	a5,a5,1
 1000528:	db1c                	sw	a5,48(a4)
 100052a:	bf09                	j	100043c <handle_irq+0x6>
				DATA_2_IICM1 = (i2c_master_send_buffer[7+buffer_cycle*8] << 24) | (i2c_master_send_buffer[6+buffer_cycle*8] << 16) | (i2c_master_send_buffer[5+buffer_cycle*8] << 8) | (i2c_master_send_buffer[4+buffer_cycle*8]);				
 100052c:	00418713          	addi	a4,gp,4 # 10006e4 <ii2>
 1000530:	4b1c                	lw	a5,16(a4)
 1000532:	078e                	slli	a5,a5,0x3
 1000534:	079d                	addi	a5,a5,7
 1000536:	42418593          	addi	a1,gp,1060 # 1000b04 <i2c_master_send_buffer>
 100053a:	97ae                	add	a5,a5,a1
 100053c:	0007c783          	lbu	a5,0(a5) # 1f030000 <__bss_end__+0x1e02f350>
 1000540:	07e2                	slli	a5,a5,0x18
 1000542:	4b14                	lw	a3,16(a4)
 1000544:	068e                	slli	a3,a3,0x3
 1000546:	0699                	addi	a3,a3,6
 1000548:	96ae                	add	a3,a3,a1
 100054a:	0006c683          	lbu	a3,0(a3)
 100054e:	0ff6f693          	andi	a3,a3,255
 1000552:	06c2                	slli	a3,a3,0x10
 1000554:	8fd5                	or	a5,a5,a3
 1000556:	4b10                	lw	a2,16(a4)
 1000558:	060e                	slli	a2,a2,0x3
 100055a:	0615                	addi	a2,a2,5
 100055c:	962e                	add	a2,a2,a1
 100055e:	00064683          	lbu	a3,0(a2) # 1f030000 <__bss_end__+0x1e02f350>
 1000562:	0ff6f693          	andi	a3,a3,255
 1000566:	06a2                	slli	a3,a3,0x8
 1000568:	8fd5                	or	a5,a5,a3
 100056a:	4b14                	lw	a3,16(a4)
 100056c:	068e                	slli	a3,a3,0x3
 100056e:	0691                	addi	a3,a3,4
 1000570:	96ae                	add	a3,a3,a1
 1000572:	0006c683          	lbu	a3,0(a3)
 1000576:	0ff6f693          	andi	a3,a3,255
 100057a:	8fd5                	or	a5,a5,a3
 100057c:	1f0306b7          	lui	a3,0x1f030
 1000580:	cedc                	sw	a5,28(a3)
				buffer_cycle++;
 1000582:	4b1c                	lw	a5,16(a4)
 1000584:	0785                	addi	a5,a5,1
 1000586:	cb1c                	sw	a5,16(a4)
 1000588:	bf2d                	j	10004c2 <handle_irq+0x8c>
				DATA_2_IICM0 = (i2c_master_send_buffer[3+buffer_cycle*8] << 24) | (i2c_master_send_buffer[2+buffer_cycle*8] << 16) | (i2c_master_send_buffer[1+buffer_cycle*8] << 8) | (i2c_master_send_buffer[0+buffer_cycle*8]);
 100058a:	00418613          	addi	a2,gp,4 # 10006e4 <ii2>
 100058e:	4a1c                	lw	a5,16(a2)
 1000590:	078e                	slli	a5,a5,0x3
 1000592:	078d                	addi	a5,a5,3
 1000594:	42418693          	addi	a3,gp,1060 # 1000b04 <i2c_master_send_buffer>
 1000598:	97b6                	add	a5,a5,a3
 100059a:	0007c783          	lbu	a5,0(a5)
 100059e:	07e2                	slli	a5,a5,0x18
 10005a0:	4a18                	lw	a4,16(a2)
 10005a2:	070e                	slli	a4,a4,0x3
 10005a4:	0709                	addi	a4,a4,2
 10005a6:	9736                	add	a4,a4,a3
 10005a8:	00074703          	lbu	a4,0(a4) # 1f030000 <__bss_end__+0x1e02f350>
 10005ac:	0ff77713          	andi	a4,a4,255
 10005b0:	0742                	slli	a4,a4,0x10
 10005b2:	8fd9                	or	a5,a5,a4
 10005b4:	4a18                	lw	a4,16(a2)
 10005b6:	070e                	slli	a4,a4,0x3
 10005b8:	0705                	addi	a4,a4,1
 10005ba:	9736                	add	a4,a4,a3
 10005bc:	00074703          	lbu	a4,0(a4)
 10005c0:	0ff77713          	andi	a4,a4,255
 10005c4:	0722                	slli	a4,a4,0x8
 10005c6:	8fd9                	or	a5,a5,a4
 10005c8:	4a18                	lw	a4,16(a2)
 10005ca:	070e                	slli	a4,a4,0x3
 10005cc:	96ba                	add	a3,a3,a4
 10005ce:	0006c703          	lbu	a4,0(a3) # 1f030000 <__bss_end__+0x1e02f350>
 10005d2:	0ff77713          	andi	a4,a4,255
 10005d6:	8fd9                	or	a5,a5,a4
 10005d8:	1f030737          	lui	a4,0x1f030
 10005dc:	cf1c                	sw	a5,24(a4)
 10005de:	b5d5                	j	10004c2 <handle_irq+0x8c>
				if (buffer_cycle2 != 0)
 10005e0:	00418793          	addi	a5,gp,4 # 10006e4 <ii2>
 10005e4:	4bdc                	lw	a5,20(a5)
 10005e6:	ee078ce3          	beqz	a5,10004de <handle_irq+0xa8>
					i2c_master_rev_buffer[4+(buffer_cycle2-1)*8] = IICM_2_DATA1 & 0x000000ff;
 10005ea:	1f030337          	lui	t1,0x1f030
 10005ee:	02432283          	lw	t0,36(t1) # 1f030024 <__bss_end__+0x1e02f374>
 10005f2:	00418593          	addi	a1,gp,4 # 10006e4 <ii2>
 10005f6:	49dc                	lw	a5,20(a1)
 10005f8:	20000637          	lui	a2,0x20000
 10005fc:	167d                	addi	a2,a2,-1
 10005fe:	97b2                	add	a5,a5,a2
 1000600:	078e                	slli	a5,a5,0x3
 1000602:	00478713          	addi	a4,a5,4
 1000606:	0ff2f293          	andi	t0,t0,255
 100060a:	4ec18693          	addi	a3,gp,1260 # 1000bcc <i2c_master_rev_buffer>
 100060e:	00d707b3          	add	a5,a4,a3
 1000612:	00578023          	sb	t0,0(a5)
					i2c_master_rev_buffer[5+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x0000ff00) >> 8;
 1000616:	02432783          	lw	a5,36(t1)
 100061a:	87a1                	srai	a5,a5,0x8
 100061c:	49d8                	lw	a4,20(a1)
 100061e:	9732                	add	a4,a4,a2
 1000620:	070e                	slli	a4,a4,0x3
 1000622:	0715                	addi	a4,a4,5
 1000624:	0ff7f793          	andi	a5,a5,255
 1000628:	9736                	add	a4,a4,a3
 100062a:	00f70023          	sb	a5,0(a4) # 1f030000 <__bss_end__+0x1e02f350>
					i2c_master_rev_buffer[6+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x00ff0000) >> 16;
 100062e:	02432783          	lw	a5,36(t1)
 1000632:	87c1                	srai	a5,a5,0x10
 1000634:	49d8                	lw	a4,20(a1)
 1000636:	9732                	add	a4,a4,a2
 1000638:	070e                	slli	a4,a4,0x3
 100063a:	0719                	addi	a4,a4,6
 100063c:	0ff7f793          	andi	a5,a5,255
 1000640:	9736                	add	a4,a4,a3
 1000642:	00f70023          	sb	a5,0(a4)
					i2c_master_rev_buffer[7+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0xff000000) >> 24;					
 1000646:	02432703          	lw	a4,36(t1)
 100064a:	49dc                	lw	a5,20(a1)
 100064c:	97b2                	add	a5,a5,a2
 100064e:	078e                	slli	a5,a5,0x3
 1000650:	079d                	addi	a5,a5,7
 1000652:	8361                	srli	a4,a4,0x18
 1000654:	97b6                	add	a5,a5,a3
 1000656:	00e78023          	sb	a4,0(a5)
 100065a:	b551                	j	10004de <handle_irq+0xa8>
				i2c_master_rev_buffer[0+buffer_cycle2*8] = IICM_2_DATA0 & 0x000000ff;
 100065c:	1f0305b7          	lui	a1,0x1f030
 1000660:	0205a303          	lw	t1,32(a1) # 1f030020 <__bss_end__+0x1e02f370>
 1000664:	00418793          	addi	a5,gp,4 # 10006e4 <ii2>
 1000668:	4bd8                	lw	a4,20(a5)
 100066a:	00371693          	slli	a3,a4,0x3
 100066e:	0ff37313          	andi	t1,t1,255
 1000672:	4ec18613          	addi	a2,gp,1260 # 1000bcc <i2c_master_rev_buffer>
 1000676:	00c68733          	add	a4,a3,a2
 100067a:	00670023          	sb	t1,0(a4)
				i2c_master_rev_buffer[1+buffer_cycle2*8] = (IICM_2_DATA0 & 0x0000ff00) >> 8;
 100067e:	5198                	lw	a4,32(a1)
 1000680:	8721                	srai	a4,a4,0x8
 1000682:	4bd4                	lw	a3,20(a5)
 1000684:	068e                	slli	a3,a3,0x3
 1000686:	0685                	addi	a3,a3,1
 1000688:	0ff77713          	andi	a4,a4,255
 100068c:	96b2                	add	a3,a3,a2
 100068e:	00e68023          	sb	a4,0(a3)
				i2c_master_rev_buffer[2+buffer_cycle2*8] = (IICM_2_DATA0 & 0x00ff0000) >> 16;
 1000692:	5198                	lw	a4,32(a1)
 1000694:	8741                	srai	a4,a4,0x10
 1000696:	4bd4                	lw	a3,20(a5)
 1000698:	068e                	slli	a3,a3,0x3
 100069a:	0689                	addi	a3,a3,2
 100069c:	0ff77713          	andi	a4,a4,255
 10006a0:	96b2                	add	a3,a3,a2
 10006a2:	00e68023          	sb	a4,0(a3)
				i2c_master_rev_buffer[3+buffer_cycle2*8] = (IICM_2_DATA0 & 0xff000000) >> 24;
 10006a6:	5194                	lw	a3,32(a1)
 10006a8:	4bd8                	lw	a4,20(a5)
 10006aa:	070e                	slli	a4,a4,0x3
 10006ac:	070d                	addi	a4,a4,3
 10006ae:	82e1                	srli	a3,a3,0x18
 10006b0:	9732                	add	a4,a4,a2
 10006b2:	00d70023          	sb	a3,0(a4)
				buffer_cycle2++;
 10006b6:	4bd8                	lw	a4,20(a5)
 10006b8:	0705                	addi	a4,a4,1
 10006ba:	cbd8                	sw	a4,20(a5)
 10006bc:	b50d                	j	10004de <handle_irq+0xa8>
		tm_count++;
 10006be:	5c41a783          	lw	a5,1476(gp) # 1000ca4 <tm_count>
 10006c2:	0785                	addi	a5,a5,1
 10006c4:	5cf1a223          	sw	a5,1476(gp) # 1000ca4 <tm_count>
		TIMER_CR |= 0x00000100;
 10006c8:	1f020737          	lui	a4,0x1f020
 10006cc:	431c                	lw	a5,0(a4)
 10006ce:	1007e793          	ori	a5,a5,256
 10006d2:	c31c                	sw	a5,0(a4)
}
 10006d4:	b3bd                	j	1000442 <handle_irq+0xc>
	...
