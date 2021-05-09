
.//Obj/i2c_master_self_loop_slave.elf:     file format elf32-littleriscv


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
 100000c:	7d818193          	addi	gp,gp,2008 # 10007e0 <__etext>
.option pop

    la      a0, Default_Handler
 1000010:	00000517          	auipc	a0,0x0
 1000014:	1b050513          	addi	a0,a0,432 # 10001c0 <Default_Handler>
    ori     a0, a0, 3
 1000018:	00356513          	ori	a0,a0,3
    csrw    mtvec, a0
 100001c:	30551073          	csrw	mtvec,a0

    la      a0, __Vectors
 1000020:	86018513          	addi	a0,gp,-1952 # 1000040 <__Vectors>
    csrw    mtvt, a0
 1000024:	30751073          	csrw	mtvt,a0

    la      sp, __initial_sp
 1000028:	22418113          	addi	sp,gp,548 # 1000a04 <__initial_sp>
    csrw    mscratch, sp
 100002c:	34011073          	csrw	mscratch,sp

    jal     main
 1000030:	36a000ef          	jal	ra,100039a <main>

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
 100012e:	312000ef          	jal	ra,1000440 <handle_irq>

    csrc    mstatus, 8
 1000132:	30047073          	csrci	mstatus,8

    lw      a1, 40(sp)
 1000136:	55a2                	lw	a1,40(sp)
    andi    a0, a1, 0x3FF
 1000138:	3ff5f513          	andi	a0,a1,1023

    /* clear pending */
    li      a2, 0xE000E100
 100013c:	e000e637          	lui	a2,0xe000e
 1000140:	10060613          	addi	a2,a2,256 # e000e100 <__bss_end__+0xdf00d280>
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
 10001ce:	42418293          	addi	t0,gp,1060 # 1000c04 <g_trap_sp>
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

01000234 <i2c_slave_init>:
void __bkpt_label();

void i2c_slave_init(void)
{
	//
	SLAVEDEV = 0x0000000CUL;
 1000234:	1f0407b7          	lui	a5,0x1f040
 1000238:	4731                	li	a4,12
 100023a:	c398                	sw	a4,0(a5)
	EN_SLAVEB = 0x00000001UL;
 100023c:	4705                	li	a4,1
 100023e:	c3d8                	sw	a4,4(a5)
  \details Enable a device-specific interrupt in the VIC interrupt controller.
  \param [in]      IRQn  External interrupt number. Value cannot be negative.
 */
__STATIC_INLINE void csi_vic_enable_irq(int32_t IRQn)
{
    CLIC->CLICINT[IRQn].IE |= CLIC_INTIE_IE_Msk;
 1000240:	e0801737          	lui	a4,0xe0801
 1000244:	05d74783          	lbu	a5,93(a4) # e080105d <__bss_end__+0xdf8001dd>
 1000248:	0ff7f793          	andi	a5,a5,255
 100024c:	0017e793          	ori	a5,a5,1
 1000250:	04f70ea3          	sb	a5,93(a4)
	csi_vic_enable_irq(I2C_SLAVE_IRQn);
}
 1000254:	8082                	ret

01000256 <i2c_master_init>:

void i2c_master_init(void)
{
	unsigned int i = 0;   //index
	//
	SLAVE_ADDR = 0x0000000CUL;	//xbr820 slave
 1000256:	1f0307b7          	lui	a5,0x1f030
 100025a:	4731                	li	a4,12
 100025c:	c398                	sw	a4,0(a5)
	
	//MAST_CLK = 0x00000020UL;		//I2C CLK: 16000000/32/8 = 62.5K  pass!
	MAST_CLK = 0x00000010UL;		//I2C CLK: 16000000/16/8 = 125K  pass!
 100025e:	4741                	li	a4,16
 1000260:	dbd8                	sw	a4,52(a5)
	//MAST_CLK = 0x0000000AUL;		//I2C CLK: 16000000/10/8 = 200K  not ok!
	//MAST_CLK = 0x00000008UL;		//I2C CLK: 16000000/8/8 = 250K  not ok!
	//MAST_CLK = 0x00000005UL;		//I2C CLK: 16000000/5/8 = 400K  not ok!
	
	MAST_EN = 0x00000001UL;			//enable master clock
 1000262:	4705                	li	a4,1
 1000264:	df98                	sw	a4,56(a5)
	
	MAST_MISC = 0x00000002UL;		//enable last ack
 1000266:	4709                	li	a4,2
 1000268:	cb98                	sw	a4,16(a5)
	
	//MAST_INT_EN |= 0x0000000f;//enable int source
	//MAST_INT_EN |= 0x00000008;//enable int source
	MAST_INT_EN |= 0x0000000A;  //enable int source most use this
 100026a:	57d8                	lw	a4,44(a5)
 100026c:	00a76713          	ori	a4,a4,10
 1000270:	d7d8                	sw	a4,44(a5)
 1000272:	e0801737          	lui	a4,0xe0801
 1000276:	05974783          	lbu	a5,89(a4) # e0801059 <__bss_end__+0xdf8001d9>
 100027a:	0ff7f793          	andi	a5,a5,255
 100027e:	0017e793          	ori	a5,a5,1
 1000282:	04f70ca3          	sb	a5,89(a4)
	//MAST_INT_EN |= 0x00000002;  //only stop int source
	//MAST_INT_EN |= 0x00000000;  //disable all int source
	
	csi_vic_enable_irq(I2C_MASTER_IRQn);
	
	i2c_master_send_buffer[0] = 0x12;
 1000286:	4749                	li	a4,18
 1000288:	42e18623          	sb	a4,1068(gp) # 1000c0c <i2c_master_send_buffer>
	i2c_master_send_buffer[1] = 0x55;
 100028c:	42c18793          	addi	a5,gp,1068 # 1000c0c <i2c_master_send_buffer>
 1000290:	05500713          	li	a4,85
 1000294:	00e780a3          	sb	a4,1(a5) # 1f030001 <__bss_end__+0x1e02f181>
	i2c_master_send_buffer[2] = 0xAA;
 1000298:	faa00713          	li	a4,-86
 100029c:	00e78123          	sb	a4,2(a5)
	i2c_master_send_buffer[3] = 0xEB;
 10002a0:	572d                	li	a4,-21
 10002a2:	00e781a3          	sb	a4,3(a5)
	i2c_master_send_buffer[4] = 0x90;
 10002a6:	f9000713          	li	a4,-112
 10002aa:	00e78223          	sb	a4,4(a5)
	i2c_master_send_buffer[5] = 0x99;
 10002ae:	f9900713          	li	a4,-103
 10002b2:	00e782a3          	sb	a4,5(a5)
	i2c_master_send_buffer[6] = 0x2A;
 10002b6:	02a00713          	li	a4,42
 10002ba:	00e78323          	sb	a4,6(a5)
	i2c_master_send_buffer[7] = 0xBE;
 10002be:	fbe00713          	li	a4,-66
 10002c2:	00e783a3          	sb	a4,7(a5)
	
	for (i = 8;i<200;i++)
 10002c6:	4721                	li	a4,8
 10002c8:	0c700793          	li	a5,199
 10002cc:	00e7eb63          	bltu	a5,a4,10002e2 <i2c_master_init+0x8c>
	{
		i2c_master_send_buffer[i] = i;
 10002d0:	0ff77693          	andi	a3,a4,255
 10002d4:	42c18793          	addi	a5,gp,1068 # 1000c0c <i2c_master_send_buffer>
 10002d8:	97ba                	add	a5,a5,a4
 10002da:	00d78023          	sb	a3,0(a5)
	for (i = 8;i<200;i++)
 10002de:	0705                	addi	a4,a4,1
 10002e0:	b7e5                	j	10002c8 <i2c_master_init+0x72>
	}
}
 10002e2:	8082                	ret

010002e4 <timer0_init>:

void timer0_init(unsigned int init_val)
{
	tm_count = 0;
 10002e4:	6801aa23          	sw	zero,1684(gp) # 1000e74 <tm_count>
	TIMER0_REG = init_val;	//load the initial value
 10002e8:	1f0207b7          	lui	a5,0x1f020
 10002ec:	c788                	sw	a0,8(a5)
	TIMER_CR |= 0x00000010;//enable timer0
 10002ee:	4398                	lw	a4,0(a5)
 10002f0:	01076713          	ori	a4,a4,16
 10002f4:	c398                	sw	a4,0(a5)
 10002f6:	e0801737          	lui	a4,0xe0801
 10002fa:	06974783          	lbu	a5,105(a4) # e0801069 <__bss_end__+0xdf8001e9>
 10002fe:	0ff7f793          	andi	a5,a5,255
 1000302:	0017e793          	ori	a5,a5,1
 1000306:	06f704a3          	sb	a5,105(a4)
	
	csi_vic_enable_irq(TIM0_IRQn);
}
 100030a:	8082                	ret

0100030c <i2c_master_transmit>:

void i2c_master_transmit(unsigned int trans_num)
{
	rw_flag = 0;
 100030c:	0001a023          	sw	zero,0(gp) # 10007e0 <__etext>
	NWORD = trans_num - 1;
 1000310:	157d                	addi	a0,a0,-1
 1000312:	1f0306b7          	lui	a3,0x1f030
 1000316:	c2c8                	sw	a0,4(a3)
	DATA_2_IICM0 = (i2c_master_send_buffer[3] << 24) | (i2c_master_send_buffer[2] << 16) | (i2c_master_send_buffer[1] << 8) | (i2c_master_send_buffer[0]);
 1000318:	42c18593          	addi	a1,gp,1068 # 1000c0c <i2c_master_send_buffer>
 100031c:	0035c783          	lbu	a5,3(a1)
 1000320:	07e2                	slli	a5,a5,0x18
 1000322:	0025c703          	lbu	a4,2(a1)
 1000326:	0ff77713          	andi	a4,a4,255
 100032a:	0742                	slli	a4,a4,0x10
 100032c:	8fd9                	or	a5,a5,a4
 100032e:	0015c703          	lbu	a4,1(a1)
 1000332:	0ff77713          	andi	a4,a4,255
 1000336:	0722                	slli	a4,a4,0x8
 1000338:	8fd9                	or	a5,a5,a4
 100033a:	42c1c703          	lbu	a4,1068(gp) # 1000c0c <i2c_master_send_buffer>
 100033e:	0ff77713          	andi	a4,a4,255
 1000342:	8fd9                	or	a5,a5,a4
 1000344:	ce9c                	sw	a5,24(a3)
	MASTER_CPU_CMD = 0x00000011UL;
 1000346:	47c5                	li	a5,17
 1000348:	c69c                	sw	a5,8(a3)
}
 100034a:	8082                	ret

0100034c <i2c_master_rev>:

void i2c_master_rev(unsigned int rev_num)
{
	rw_flag = 1;
 100034c:	4705                	li	a4,1
 100034e:	00e1a023          	sw	a4,0(gp) # 10007e0 <__etext>
	NWORD = rev_num - 1;	
 1000352:	157d                	addi	a0,a0,-1
 1000354:	1f0307b7          	lui	a5,0x1f030
 1000358:	c3c8                	sw	a0,4(a5)
	MASTER_CPU_CMD = 0x00000012UL;
 100035a:	4749                	li	a4,18
 100035c:	c798                	sw	a4,8(a5)
}
 100035e:	8082                	ret

01000360 <i2c_master_restart_rev1>:

void i2c_master_restart_rev1(unsigned char address, unsigned int rev_num)
{
	rw_flag = 1;
 1000360:	4705                	li	a4,1
 1000362:	00e1a023          	sw	a4,0(gp) # 10007e0 <__etext>
	MAST_READ_ADDR = address;
 1000366:	1f0307b7          	lui	a5,0x1f030
 100036a:	cbc8                	sw	a0,20(a5)
	NWORD = rev_num - 1;
 100036c:	15fd                	addi	a1,a1,-1
 100036e:	c3cc                	sw	a1,4(a5)
	MASTER_CPU_CMD = 0x00000017UL;
 1000370:	475d                	li	a4,23
 1000372:	c798                	sw	a4,8(a5)
}
 1000374:	8082                	ret

01000376 <i2c_master_restart_rev2>:

void i2c_master_restart_rev2(unsigned short address, unsigned int rev_num)
{
	rw_flag = 1;
 1000376:	4705                	li	a4,1
 1000378:	00e1a023          	sw	a4,0(gp) # 10007e0 <__etext>
	MAST_READ_ADDR = address;
 100037c:	1f0307b7          	lui	a5,0x1f030
 1000380:	cbc8                	sw	a0,20(a5)
	NWORD = rev_num - 1;
 1000382:	15fd                	addi	a1,a1,-1
 1000384:	c3cc                	sw	a1,4(a5)
	MASTER_CPU_CMD = 0x0000001FUL;
 1000386:	477d                	li	a4,31
 1000388:	c798                	sw	a4,8(a5)
}
 100038a:	8082                	ret

0100038c <delay>:

void delay(unsigned int val)
{
	tm_count = 0;
 100038c:	6801aa23          	sw	zero,1684(gp) # 1000e74 <tm_count>
	while(tm_count < val)
 1000390:	6941a783          	lw	a5,1684(gp) # 1000e74 <tm_count>
 1000394:	fea7eee3          	bltu	a5,a0,1000390 <delay+0x4>
	{
		//
	}	
}
 1000398:	8082                	ret

0100039a <main>:

int main() 
{	
 100039a:	1151                	addi	sp,sp,-12
 100039c:	c406                	sw	ra,8(sp)
	unsigned int i = 0;
	
	i2c_slave_init();
 100039e:	3d59                	jal	1000234 <i2c_slave_init>
	i2c_master_init();
 10003a0:	3d5d                	jal	1000256 <i2c_master_init>
	timer0_init(16000);//1ms
 10003a2:	6511                	lui	a0,0x4
 10003a4:	e8050513          	addi	a0,a0,-384 # 3e80 <Reset_Handler-0xffc180>
 10003a8:	3f35                	jal	10002e4 <timer0_init>
	
	ii = 0;
 10003aa:	0001ac23          	sw	zero,24(gp) # 10007f8 <ii>
	ii2 = 0;
 10003ae:	0001a623          	sw	zero,12(gp) # 10007ec <ii2>
	master_work_flag = 0;
 10003b2:	00018793          	mv	a5,gp
 10003b6:	00078223          	sb	zero,4(a5) # 1f030004 <__bss_end__+0x1e02f184>
	buffer_pointer = 0;
 10003ba:	0001aa23          	sw	zero,20(gp) # 10007f4 <buffer_pointer>
	buffer_cycle = 0;
 10003be:	0001ae23          	sw	zero,28(gp) # 10007fc <buffer_cycle>
	
	buffer_pointer2 = 0;
 10003c2:	0001a823          	sw	zero,16(gp) # 10007f0 <buffer_pointer2>
	buffer_cycle2 = 0;
 10003c6:	0201a023          	sw	zero,32(gp) # 1000800 <buffer_cycle2>
	
	rw_flag = 0;
 10003ca:	0007a023          	sw	zero,0(a5)
  \details Enables IRQ interrupts by setting the IE-bit in the PSR.
           Can only be executed in Privileged modes.
 */
__ALWAYS_STATIC_INLINE void __enable_irq(void)
{
    __ASM volatile("csrs mstatus, 8");
 10003ce:	30046073          	csrsi	mstatus,8
	while(1)
	{
		if (1)
		{
			//transmit
			i2c_master_transmit(128);
 10003d2:	08000513          	li	a0,128
 10003d6:	3f1d                	jal	100030c <i2c_master_transmit>
			
			while(master_work_flag==0)
 10003d8:	00018793          	mv	a5,gp
 10003dc:	0047c783          	lbu	a5,4(a5)
 10003e0:	dfe5                	beqz	a5,10003d8 <main+0x3e>
			{
				//
			}
			master_work_flag = 0;
 10003e2:	00018793          	mv	a5,gp
 10003e6:	00078223          	sb	zero,4(a5)
			DATA_2_IICM0 = (i2c_master_send_buffer[3] << 24) | (i2c_master_send_buffer[2] << 16) | (i2c_master_send_buffer[1] << 8) | (i2c_master_send_buffer[0]);
 10003ea:	42c18693          	addi	a3,gp,1068 # 1000c0c <i2c_master_send_buffer>
 10003ee:	0036c783          	lbu	a5,3(a3) # 1f030003 <__bss_end__+0x1e02f183>
 10003f2:	07e2                	slli	a5,a5,0x18
 10003f4:	0026c703          	lbu	a4,2(a3)
 10003f8:	0ff77713          	andi	a4,a4,255
 10003fc:	0742                	slli	a4,a4,0x10
 10003fe:	8fd9                	or	a5,a5,a4
 1000400:	0016c703          	lbu	a4,1(a3)
 1000404:	0ff77713          	andi	a4,a4,255
 1000408:	0722                	slli	a4,a4,0x8
 100040a:	8fd9                	or	a5,a5,a4
 100040c:	42c1c703          	lbu	a4,1068(gp) # 1000c0c <i2c_master_send_buffer>
 1000410:	0ff77713          	andi	a4,a4,255
 1000414:	8fd9                	or	a5,a5,a4
 1000416:	1f030737          	lui	a4,0x1f030
 100041a:	cf1c                	sw	a5,24(a4)

			delay(5000);
 100041c:	6505                	lui	a0,0x1
 100041e:	38850513          	addi	a0,a0,904 # 1388 <Reset_Handler-0xffec78>
 1000422:	37ad                	jal	100038c <delay>
			buffer_cycle = 0;			
 1000424:	0001ae23          	sw	zero,28(gp) # 10007fc <buffer_cycle>
		}
		
		for (i=0;i<200;i++)
 1000428:	4701                	li	a4,0
 100042a:	0c700793          	li	a5,199
 100042e:	fae7e2e3          	bltu	a5,a4,10003d2 <main+0x38>
		{
			i2c_slave_buffer[i] = 0x00;
 1000432:	5cc18793          	addi	a5,gp,1484 # 1000dac <i2c_slave_buffer>
 1000436:	97ba                	add	a5,a5,a4
 1000438:	00078023          	sb	zero,0(a5)
		for (i=0;i<200;i++)
 100043c:	0705                	addi	a4,a4,1
 100043e:	b7f5                	j	100042a <main+0x90>

01000440 <handle_irq>:

void handle_irq(uint32_t vec) 
{	
	static unsigned char pos = 0;
	
	if (I2C_SLAVE_IRQn == vec)
 1000440:	47dd                	li	a5,23
 1000442:	00f50963          	beq	a0,a5,1000454 <handle_irq+0x14>
				pos = 0;
			}
		}
	}	
	
	if (I2C_MASTER_IRQn == vec)
 1000446:	47d9                	li	a5,22
 1000448:	0cf50d63          	beq	a0,a5,1000522 <handle_irq+0xe2>
		{
			MAST_CLEAR |= 0x00000001;
		}
	}
	
	if (TIM0_IRQn == vec)
 100044c:	47e9                	li	a5,26
 100044e:	36f50963          	beq	a0,a5,10007c0 <handle_irq+0x380>
	{
		tm_count++;
		TIMER_CR |= 0x00000100;
	}
}
 1000452:	8082                	ret
		SLAVEB_CLEAR |= 0x00000010;
 1000454:	1f0407b7          	lui	a5,0x1f040
 1000458:	4bd8                	lw	a4,20(a5)
 100045a:	01076713          	ori	a4,a4,16
 100045e:	cbd8                	sw	a4,20(a5)
		if (0x00000008 & SLAVEB_STATUS)		//addr
 1000460:	4b9c                	lw	a5,16(a5)
 1000462:	8ba1                	andi	a5,a5,8
 1000464:	c385                	beqz	a5,1000484 <handle_irq+0x44>
			SLAVEB_CLEAR |= 0x00000008;		
 1000466:	1f0407b7          	lui	a5,0x1f040
 100046a:	4bd8                	lw	a4,20(a5)
 100046c:	00876713          	ori	a4,a4,8
 1000470:	cbd8                	sw	a4,20(a5)
			i2c_slave_buffer[0] = (SLAVEB_DATA >> 8) & 0x000000FF;
 1000472:	479c                	lw	a5,8(a5)
 1000474:	87a1                	srai	a5,a5,0x8
 1000476:	0ff7f793          	andi	a5,a5,255
 100047a:	5cf18623          	sb	a5,1484(gp) # 1000dac <i2c_slave_buffer>
			pos = 1;
 100047e:	4705                	li	a4,1
 1000480:	00e18423          	sb	a4,8(gp) # 10007e8 <pos.3277>
		if (0x00000001 & SLAVEB_STATUS)		//rw int
 1000484:	1f0407b7          	lui	a5,0x1f040
 1000488:	4b9c                	lw	a5,16(a5)
 100048a:	8b85                	andi	a5,a5,1
 100048c:	cf8d                	beqz	a5,10004c6 <handle_irq+0x86>
			SLAVEB_CLEAR |= 0x00000001;			
 100048e:	1f0407b7          	lui	a5,0x1f040
 1000492:	4bd8                	lw	a4,20(a5)
 1000494:	00176713          	ori	a4,a4,1
 1000498:	cbd8                	sw	a4,20(a5)
			if (0x00000010 & SLAVEB_STATUS)
 100049a:	4b9c                	lw	a5,16(a5)
 100049c:	8bc1                	andi	a5,a5,16
 100049e:	c3a5                	beqz	a5,10004fe <handle_irq+0xbe>
				SLAVEB_DATA_2_IIC = i2c_slave_buffer[pos];
 10004a0:	00818793          	addi	a5,gp,8 # 10007e8 <pos.3277>
 10004a4:	0007c703          	lbu	a4,0(a5) # 1f040000 <__bss_end__+0x1e03f180>
 10004a8:	5cc18693          	addi	a3,gp,1484 # 1000dac <i2c_slave_buffer>
 10004ac:	9736                	add	a4,a4,a3
 10004ae:	00074703          	lbu	a4,0(a4) # 1f030000 <__bss_end__+0x1e02f180>
 10004b2:	0ff77713          	andi	a4,a4,255
 10004b6:	1f0406b7          	lui	a3,0x1f040
 10004ba:	c6d8                	sw	a4,12(a3)
				pos++;
 10004bc:	0007c703          	lbu	a4,0(a5)
 10004c0:	0705                	addi	a4,a4,1
 10004c2:	00e78023          	sb	a4,0(a5)
		if (0x00000002 & SLAVEB_STATUS)		//nack
 10004c6:	1f0407b7          	lui	a5,0x1f040
 10004ca:	4b9c                	lw	a5,16(a5)
 10004cc:	8b89                	andi	a5,a5,2
 10004ce:	c799                	beqz	a5,10004dc <handle_irq+0x9c>
			SLAVEB_CLEAR |= 0x00000002;
 10004d0:	1f040737          	lui	a4,0x1f040
 10004d4:	4b5c                	lw	a5,20(a4)
 10004d6:	0027e793          	ori	a5,a5,2
 10004da:	cb5c                	sw	a5,20(a4)
		if (0x00000004 & SLAVEB_STATUS)		//stop
 10004dc:	1f0407b7          	lui	a5,0x1f040
 10004e0:	4b9c                	lw	a5,16(a5)
 10004e2:	8b91                	andi	a5,a5,4
 10004e4:	d3ad                	beqz	a5,1000446 <handle_irq+0x6>
			SLAVEB_CLEAR |= 0x00000004;		
 10004e6:	1f0407b7          	lui	a5,0x1f040
 10004ea:	4bd8                	lw	a4,20(a5)
 10004ec:	00476713          	ori	a4,a4,4
 10004f0:	cbd8                	sw	a4,20(a5)
			if (0x00000010 & SLAVEB_STATUS)
 10004f2:	4b9c                	lw	a5,16(a5)
 10004f4:	8bc1                	andi	a5,a5,16
 10004f6:	fba1                	bnez	a5,1000446 <handle_irq+0x6>
				pos = 0;
 10004f8:	00018423          	sb	zero,8(gp) # 10007e8 <pos.3277>
 10004fc:	b7a9                	j	1000446 <handle_irq+0x6>
				i2c_slave_buffer[pos] = (SLAVEB_DATA) & 0x000000FF;
 10004fe:	1f0407b7          	lui	a5,0x1f040
 1000502:	4790                	lw	a2,8(a5)
 1000504:	00818713          	addi	a4,gp,8 # 10007e8 <pos.3277>
 1000508:	00074683          	lbu	a3,0(a4) # 1f040000 <__bss_end__+0x1e03f180>
 100050c:	0ff67613          	andi	a2,a2,255
 1000510:	5cc18793          	addi	a5,gp,1484 # 1000dac <i2c_slave_buffer>
 1000514:	97b6                	add	a5,a5,a3
 1000516:	00c78023          	sb	a2,0(a5) # 1f040000 <__bss_end__+0x1e03f180>
				pos++;
 100051a:	0685                	addi	a3,a3,1
 100051c:	00d70023          	sb	a3,0(a4)
 1000520:	b75d                	j	10004c6 <handle_irq+0x86>
		ii2++;
 1000522:	00818793          	addi	a5,gp,8 # 10007e8 <pos.3277>
 1000526:	43d8                	lw	a4,4(a5)
 1000528:	0705                	addi	a4,a4,1
 100052a:	c3d8                	sw	a4,4(a5)
		if (0x00000010 & MAST_STATUS) // byte done
 100052c:	1f0307b7          	lui	a5,0x1f030
 1000530:	579c                	lw	a5,40(a5)
 1000532:	8bc1                	andi	a5,a5,16
 1000534:	cbd1                	beqz	a5,10005c8 <handle_irq+0x188>
			MAST_CLEAR |= 0x00000008;
 1000536:	1f030737          	lui	a4,0x1f030
 100053a:	5b1c                	lw	a5,48(a4)
 100053c:	0087e793          	ori	a5,a5,8
 1000540:	db1c                	sw	a5,48(a4)
			if (rw_flag)
 1000542:	0001a783          	lw	a5,0(gp) # 10007e0 <__etext>
 1000546:	cbe1                	beqz	a5,1000616 <handle_irq+0x1d6>
				buffer_pointer2 = (0x0000ff00 & MAST_STATUS) >> 8;
 1000548:	1f0307b7          	lui	a5,0x1f030
 100054c:	579c                	lw	a5,40(a5)
 100054e:	87a1                	srai	a5,a5,0x8
 1000550:	0ff7f793          	andi	a5,a5,255
 1000554:	00818713          	addi	a4,gp,8 # 10007e8 <pos.3277>
 1000558:	c71c                	sw	a5,8(a4)
				buffer_pointer = 0;
 100055a:	00072623          	sw	zero,12(a4) # 1f03000c <__bss_end__+0x1e02f18c>
			i2c_master_sended_buffer[ii] = (0x0000ff00 & MAST_STATUS) >> 8;
 100055e:	1f0307b7          	lui	a5,0x1f030
 1000562:	5798                	lw	a4,40(a5)
 1000564:	8721                	srai	a4,a4,0x8
 1000566:	00818793          	addi	a5,gp,8 # 10007e8 <pos.3277>
 100056a:	4b94                	lw	a3,16(a5)
 100056c:	0ff77713          	andi	a4,a4,255
 1000570:	5bc18613          	addi	a2,gp,1468 # 1000d9c <i2c_master_sended_buffer>
 1000574:	96b2                	add	a3,a3,a2
 1000576:	00e68023          	sb	a4,0(a3) # 1f040000 <__bss_end__+0x1e03f180>
			ii++;
 100057a:	4b98                	lw	a4,16(a5)
 100057c:	0705                	addi	a4,a4,1
 100057e:	cb98                	sw	a4,16(a5)
			if (16 <= ii)
 1000580:	4b98                	lw	a4,16(a5)
 1000582:	47bd                	li	a5,15
 1000584:	00e7f663          	bgeu	a5,a4,1000590 <handle_irq+0x150>
				ii = 0;
 1000588:	00818793          	addi	a5,gp,8 # 10007e8 <pos.3277>
 100058c:	0007a823          	sw	zero,16(a5) # 1f030010 <__bss_end__+0x1e02f190>
			if (buffer_pointer % 8 == 1)
 1000590:	00818793          	addi	a5,gp,8 # 10007e8 <pos.3277>
 1000594:	47dc                	lw	a5,12(a5)
 1000596:	8b9d                	andi	a5,a5,7
 1000598:	4705                	li	a4,1
 100059a:	08e78a63          	beq	a5,a4,100062e <handle_irq+0x1ee>
			else if (buffer_pointer % 8 == 4)
 100059e:	00818793          	addi	a5,gp,8 # 10007e8 <pos.3277>
 10005a2:	47dc                	lw	a5,12(a5)
 10005a4:	8b9d                	andi	a5,a5,7
 10005a6:	4711                	li	a4,4
 10005a8:	0ee78263          	beq	a5,a4,100068c <handle_irq+0x24c>
			if (buffer_pointer2 % 8 == 1)
 10005ac:	00818793          	addi	a5,gp,8 # 10007e8 <pos.3277>
 10005b0:	479c                	lw	a5,8(a5)
 10005b2:	8b9d                	andi	a5,a5,7
 10005b4:	4705                	li	a4,1
 10005b6:	12e78663          	beq	a5,a4,10006e2 <handle_irq+0x2a2>
			else if (buffer_pointer2 % 8 == 5)
 10005ba:	00818793          	addi	a5,gp,8 # 10007e8 <pos.3277>
 10005be:	479c                	lw	a5,8(a5)
 10005c0:	8b9d                	andi	a5,a5,7
 10005c2:	4715                	li	a4,5
 10005c4:	18e78d63          	beq	a5,a4,100075e <handle_irq+0x31e>
		if (0x00000008 & MAST_STATUS)//idle
 10005c8:	1f0307b7          	lui	a5,0x1f030
 10005cc:	5798                	lw	a4,40(a5)
		if (0x00000004 & MAST_STATUS)//timeout
 10005ce:	579c                	lw	a5,40(a5)
 10005d0:	8b91                	andi	a5,a5,4
 10005d2:	c799                	beqz	a5,10005e0 <handle_irq+0x1a0>
			MAST_CLEAR |= 0x00000004;
 10005d4:	1f030737          	lui	a4,0x1f030
 10005d8:	5b1c                	lw	a5,48(a4)
 10005da:	0047e793          	ori	a5,a5,4
 10005de:	db1c                	sw	a5,48(a4)
		if (0x00000002 & MAST_STATUS)//after stop
 10005e0:	1f0307b7          	lui	a5,0x1f030
 10005e4:	579c                	lw	a5,40(a5)
 10005e6:	8b89                	andi	a5,a5,2
 10005e8:	cb91                	beqz	a5,10005fc <handle_irq+0x1bc>
			MAST_CLEAR |= 0x00000002;
 10005ea:	1f030737          	lui	a4,0x1f030
 10005ee:	5b1c                	lw	a5,48(a4)
 10005f0:	0027e793          	ori	a5,a5,2
 10005f4:	db1c                	sw	a5,48(a4)
			master_work_flag = 1;
 10005f6:	4705                	li	a4,1
 10005f8:	00e18223          	sb	a4,4(gp) # 10007e4 <master_work_flag>
		if (0x00000001 & MAST_STATUS)//no ack
 10005fc:	1f0307b7          	lui	a5,0x1f030
 1000600:	579c                	lw	a5,40(a5)
 1000602:	8b85                	andi	a5,a5,1
 1000604:	e40784e3          	beqz	a5,100044c <handle_irq+0xc>
			MAST_CLEAR |= 0x00000001;
 1000608:	1f030737          	lui	a4,0x1f030
 100060c:	5b1c                	lw	a5,48(a4)
 100060e:	0017e793          	ori	a5,a5,1
 1000612:	db1c                	sw	a5,48(a4)
 1000614:	bd25                	j	100044c <handle_irq+0xc>
				buffer_pointer = (0x0000ff00 & MAST_STATUS) >> 8;
 1000616:	1f0307b7          	lui	a5,0x1f030
 100061a:	579c                	lw	a5,40(a5)
 100061c:	87a1                	srai	a5,a5,0x8
 100061e:	0ff7f793          	andi	a5,a5,255
 1000622:	00818713          	addi	a4,gp,8 # 10007e8 <pos.3277>
 1000626:	c75c                	sw	a5,12(a4)
				buffer_pointer2 = 0;
 1000628:	00072423          	sw	zero,8(a4) # 1f030008 <__bss_end__+0x1e02f188>
 100062c:	bf0d                	j	100055e <handle_irq+0x11e>
				DATA_2_IICM1 = (i2c_master_send_buffer[7+buffer_cycle*8] << 24) | (i2c_master_send_buffer[6+buffer_cycle*8] << 16) | (i2c_master_send_buffer[5+buffer_cycle*8] << 8) | (i2c_master_send_buffer[4+buffer_cycle*8]);				
 100062e:	00818713          	addi	a4,gp,8 # 10007e8 <pos.3277>
 1000632:	4b5c                	lw	a5,20(a4)
 1000634:	078e                	slli	a5,a5,0x3
 1000636:	079d                	addi	a5,a5,7
 1000638:	42c18593          	addi	a1,gp,1068 # 1000c0c <i2c_master_send_buffer>
 100063c:	97ae                	add	a5,a5,a1
 100063e:	0007c783          	lbu	a5,0(a5) # 1f030000 <__bss_end__+0x1e02f180>
 1000642:	07e2                	slli	a5,a5,0x18
 1000644:	4b54                	lw	a3,20(a4)
 1000646:	068e                	slli	a3,a3,0x3
 1000648:	0699                	addi	a3,a3,6
 100064a:	96ae                	add	a3,a3,a1
 100064c:	0006c683          	lbu	a3,0(a3)
 1000650:	0ff6f693          	andi	a3,a3,255
 1000654:	06c2                	slli	a3,a3,0x10
 1000656:	8fd5                	or	a5,a5,a3
 1000658:	4b50                	lw	a2,20(a4)
 100065a:	060e                	slli	a2,a2,0x3
 100065c:	0615                	addi	a2,a2,5
 100065e:	962e                	add	a2,a2,a1
 1000660:	00064683          	lbu	a3,0(a2)
 1000664:	0ff6f693          	andi	a3,a3,255
 1000668:	06a2                	slli	a3,a3,0x8
 100066a:	8fd5                	or	a5,a5,a3
 100066c:	4b54                	lw	a3,20(a4)
 100066e:	068e                	slli	a3,a3,0x3
 1000670:	0691                	addi	a3,a3,4
 1000672:	96ae                	add	a3,a3,a1
 1000674:	0006c683          	lbu	a3,0(a3)
 1000678:	0ff6f693          	andi	a3,a3,255
 100067c:	8fd5                	or	a5,a5,a3
 100067e:	1f0306b7          	lui	a3,0x1f030
 1000682:	cedc                	sw	a5,28(a3)
				buffer_cycle++;
 1000684:	4b5c                	lw	a5,20(a4)
 1000686:	0785                	addi	a5,a5,1
 1000688:	cb5c                	sw	a5,20(a4)
 100068a:	b70d                	j	10005ac <handle_irq+0x16c>
				DATA_2_IICM0 = (i2c_master_send_buffer[3+buffer_cycle*8] << 24) | (i2c_master_send_buffer[2+buffer_cycle*8] << 16) | (i2c_master_send_buffer[1+buffer_cycle*8] << 8) | (i2c_master_send_buffer[0+buffer_cycle*8]);
 100068c:	00818613          	addi	a2,gp,8 # 10007e8 <pos.3277>
 1000690:	4a5c                	lw	a5,20(a2)
 1000692:	078e                	slli	a5,a5,0x3
 1000694:	078d                	addi	a5,a5,3
 1000696:	42c18693          	addi	a3,gp,1068 # 1000c0c <i2c_master_send_buffer>
 100069a:	97b6                	add	a5,a5,a3
 100069c:	0007c783          	lbu	a5,0(a5)
 10006a0:	07e2                	slli	a5,a5,0x18
 10006a2:	4a58                	lw	a4,20(a2)
 10006a4:	070e                	slli	a4,a4,0x3
 10006a6:	0709                	addi	a4,a4,2
 10006a8:	9736                	add	a4,a4,a3
 10006aa:	00074703          	lbu	a4,0(a4)
 10006ae:	0ff77713          	andi	a4,a4,255
 10006b2:	0742                	slli	a4,a4,0x10
 10006b4:	8fd9                	or	a5,a5,a4
 10006b6:	4a58                	lw	a4,20(a2)
 10006b8:	070e                	slli	a4,a4,0x3
 10006ba:	0705                	addi	a4,a4,1
 10006bc:	9736                	add	a4,a4,a3
 10006be:	00074703          	lbu	a4,0(a4)
 10006c2:	0ff77713          	andi	a4,a4,255
 10006c6:	0722                	slli	a4,a4,0x8
 10006c8:	8fd9                	or	a5,a5,a4
 10006ca:	4a58                	lw	a4,20(a2)
 10006cc:	070e                	slli	a4,a4,0x3
 10006ce:	96ba                	add	a3,a3,a4
 10006d0:	0006c703          	lbu	a4,0(a3) # 1f030000 <__bss_end__+0x1e02f180>
 10006d4:	0ff77713          	andi	a4,a4,255
 10006d8:	8fd9                	or	a5,a5,a4
 10006da:	1f030737          	lui	a4,0x1f030
 10006de:	cf1c                	sw	a5,24(a4)
 10006e0:	b5f1                	j	10005ac <handle_irq+0x16c>
				if (buffer_cycle2 != 0)
 10006e2:	00818793          	addi	a5,gp,8 # 10007e8 <pos.3277>
 10006e6:	4f9c                	lw	a5,24(a5)
 10006e8:	ee0780e3          	beqz	a5,10005c8 <handle_irq+0x188>
					i2c_master_rev_buffer[4+(buffer_cycle2-1)*8] = IICM_2_DATA1 & 0x000000ff;
 10006ec:	1f030337          	lui	t1,0x1f030
 10006f0:	02432283          	lw	t0,36(t1) # 1f030024 <__bss_end__+0x1e02f1a4>
 10006f4:	00818593          	addi	a1,gp,8 # 10007e8 <pos.3277>
 10006f8:	4d9c                	lw	a5,24(a1)
 10006fa:	20000637          	lui	a2,0x20000
 10006fe:	167d                	addi	a2,a2,-1
 1000700:	97b2                	add	a5,a5,a2
 1000702:	078e                	slli	a5,a5,0x3
 1000704:	00478713          	addi	a4,a5,4
 1000708:	0ff2f293          	andi	t0,t0,255
 100070c:	4f418693          	addi	a3,gp,1268 # 1000cd4 <i2c_master_rev_buffer>
 1000710:	00d707b3          	add	a5,a4,a3
 1000714:	00578023          	sb	t0,0(a5)
					i2c_master_rev_buffer[5+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x0000ff00) >> 8;
 1000718:	02432783          	lw	a5,36(t1)
 100071c:	87a1                	srai	a5,a5,0x8
 100071e:	4d98                	lw	a4,24(a1)
 1000720:	9732                	add	a4,a4,a2
 1000722:	070e                	slli	a4,a4,0x3
 1000724:	0715                	addi	a4,a4,5
 1000726:	0ff7f793          	andi	a5,a5,255
 100072a:	9736                	add	a4,a4,a3
 100072c:	00f70023          	sb	a5,0(a4) # 1f030000 <__bss_end__+0x1e02f180>
					i2c_master_rev_buffer[6+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x00ff0000) >> 16;
 1000730:	02432783          	lw	a5,36(t1)
 1000734:	87c1                	srai	a5,a5,0x10
 1000736:	4d98                	lw	a4,24(a1)
 1000738:	9732                	add	a4,a4,a2
 100073a:	070e                	slli	a4,a4,0x3
 100073c:	0719                	addi	a4,a4,6
 100073e:	0ff7f793          	andi	a5,a5,255
 1000742:	9736                	add	a4,a4,a3
 1000744:	00f70023          	sb	a5,0(a4)
					i2c_master_rev_buffer[7+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0xff000000) >> 24;					
 1000748:	02432703          	lw	a4,36(t1)
 100074c:	4d9c                	lw	a5,24(a1)
 100074e:	97b2                	add	a5,a5,a2
 1000750:	078e                	slli	a5,a5,0x3
 1000752:	079d                	addi	a5,a5,7
 1000754:	8361                	srli	a4,a4,0x18
 1000756:	97b6                	add	a5,a5,a3
 1000758:	00e78023          	sb	a4,0(a5)
 100075c:	b5b5                	j	10005c8 <handle_irq+0x188>
				i2c_master_rev_buffer[0+buffer_cycle2*8] = IICM_2_DATA0 & 0x000000ff;
 100075e:	1f0305b7          	lui	a1,0x1f030
 1000762:	0205a303          	lw	t1,32(a1) # 1f030020 <__bss_end__+0x1e02f1a0>
 1000766:	00818793          	addi	a5,gp,8 # 10007e8 <pos.3277>
 100076a:	4f98                	lw	a4,24(a5)
 100076c:	00371693          	slli	a3,a4,0x3
 1000770:	0ff37313          	andi	t1,t1,255
 1000774:	4f418613          	addi	a2,gp,1268 # 1000cd4 <i2c_master_rev_buffer>
 1000778:	00c68733          	add	a4,a3,a2
 100077c:	00670023          	sb	t1,0(a4)
				i2c_master_rev_buffer[1+buffer_cycle2*8] = (IICM_2_DATA0 & 0x0000ff00) >> 8;
 1000780:	5198                	lw	a4,32(a1)
 1000782:	8721                	srai	a4,a4,0x8
 1000784:	4f94                	lw	a3,24(a5)
 1000786:	068e                	slli	a3,a3,0x3
 1000788:	0685                	addi	a3,a3,1
 100078a:	0ff77713          	andi	a4,a4,255
 100078e:	96b2                	add	a3,a3,a2
 1000790:	00e68023          	sb	a4,0(a3)
				i2c_master_rev_buffer[2+buffer_cycle2*8] = (IICM_2_DATA0 & 0x00ff0000) >> 16;
 1000794:	5198                	lw	a4,32(a1)
 1000796:	8741                	srai	a4,a4,0x10
 1000798:	4f94                	lw	a3,24(a5)
 100079a:	068e                	slli	a3,a3,0x3
 100079c:	0689                	addi	a3,a3,2
 100079e:	0ff77713          	andi	a4,a4,255
 10007a2:	96b2                	add	a3,a3,a2
 10007a4:	00e68023          	sb	a4,0(a3)
				i2c_master_rev_buffer[3+buffer_cycle2*8] = (IICM_2_DATA0 & 0xff000000) >> 24;
 10007a8:	5194                	lw	a3,32(a1)
 10007aa:	4f98                	lw	a4,24(a5)
 10007ac:	070e                	slli	a4,a4,0x3
 10007ae:	070d                	addi	a4,a4,3
 10007b0:	82e1                	srli	a3,a3,0x18
 10007b2:	9732                	add	a4,a4,a2
 10007b4:	00d70023          	sb	a3,0(a4)
				buffer_cycle2++;
 10007b8:	4f98                	lw	a4,24(a5)
 10007ba:	0705                	addi	a4,a4,1
 10007bc:	cf98                	sw	a4,24(a5)
 10007be:	b529                	j	10005c8 <handle_irq+0x188>
		tm_count++;
 10007c0:	6941a783          	lw	a5,1684(gp) # 1000e74 <tm_count>
 10007c4:	0785                	addi	a5,a5,1
 10007c6:	68f1aa23          	sw	a5,1684(gp) # 1000e74 <tm_count>
		TIMER_CR |= 0x00000100;
 10007ca:	1f020737          	lui	a4,0x1f020
 10007ce:	431c                	lw	a5,0(a4)
 10007d0:	1007e793          	ori	a5,a5,256
 10007d4:	c31c                	sw	a5,0(a4)
}
 10007d6:	b9b5                	j	1000452 <handle_irq+0x12>
	...
