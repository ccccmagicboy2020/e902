
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
 1000008:	00001197          	auipc	gp,0x1
 100000c:	89818193          	addi	gp,gp,-1896 # 10008a0 <__etext>
.option pop

    la      a0, Default_Handler
 1000010:	00000517          	auipc	a0,0x0
 1000014:	1b050513          	addi	a0,a0,432 # 10001c0 <Default_Handler>
    ori     a0, a0, 3
 1000018:	00356513          	ori	a0,a0,3
    csrw    mtvec, a0
 100001c:	30551073          	csrw	mtvec,a0

    la      a0, __Vectors
 1000020:	00000517          	auipc	a0,0x0
 1000024:	02050513          	addi	a0,a0,32 # 1000040 <__Vectors>
    csrw    mtvt, a0
 1000028:	30751073          	csrw	mtvt,a0

    la      sp, __initial_sp
 100002c:	22818113          	addi	sp,gp,552 # 1000ac8 <__initial_sp>
    csrw    mscratch, sp
 1000030:	34011073          	csrw	mscratch,sp

    jal     main
 1000034:	362000ef          	jal	ra,1000396 <main>

01000038 <__exit>:

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit
 1000038:	a001                	j	1000038 <__exit>
 100003a:	0000                	unimp
 100003c:	0000                	unimp
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
 100012e:	3fa000ef          	jal	ra,1000528 <handle_irq>

    csrc    mstatus, 8
 1000132:	30047073          	csrci	mstatus,8

    lw      a1, 40(sp)
 1000136:	55a2                	lw	a1,40(sp)
    andi    a0, a1, 0x3FF
 1000138:	3ff5f513          	andi	a0,a1,1023

    /* clear pending */
    li      a2, 0xE000E100
 100013c:	e000e637          	lui	a2,0xe000e
 1000140:	10060613          	addi	a2,a2,256 # e000e100 <__bss_end__+0xdf00d100>
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
 10001ce:	42818293          	addi	t0,gp,1064 # 1000cc8 <g_trap_sp>
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
 1000244:	05d74783          	lbu	a5,93(a4) # e080105d <__bss_end__+0xdf80005d>
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
	
	//MAST_MISC = 0x00000002UL;		//enable last ack
	
	//MAST_INT_EN |= 0x0000000f;//enable int source
	//MAST_INT_EN |= 0x00000008;//enable int source
	MAST_INT_EN |= 0x0000000A;  //enable int source most use this: byte and stop
 1000266:	57d8                	lw	a4,44(a5)
 1000268:	00a76713          	ori	a4,a4,10
 100026c:	d7d8                	sw	a4,44(a5)
 100026e:	e0801737          	lui	a4,0xe0801
 1000272:	05974783          	lbu	a5,89(a4) # e0801059 <__bss_end__+0xdf800059>
 1000276:	0ff7f793          	andi	a5,a5,255
 100027a:	0017e793          	ori	a5,a5,1
 100027e:	04f70ca3          	sb	a5,89(a4)
	//MAST_INT_EN |= 0x00000002;  //only stop int source
	//MAST_INT_EN |= 0x00000000;  //disable all int source
	
	csi_vic_enable_irq(I2C_MASTER_IRQn);
	
	i2c_master_send_buffer[0] = 0x12;
 1000282:	4749                	li	a4,18
 1000284:	42e18823          	sb	a4,1072(gp) # 1000cd0 <i2c_master_send_buffer>
	i2c_master_send_buffer[1] = 0x55;
 1000288:	43018793          	addi	a5,gp,1072 # 1000cd0 <i2c_master_send_buffer>
 100028c:	05500713          	li	a4,85
 1000290:	00e780a3          	sb	a4,1(a5) # 1f030001 <__bss_end__+0x1e02f001>
	i2c_master_send_buffer[2] = 0xAA;
 1000294:	faa00713          	li	a4,-86
 1000298:	00e78123          	sb	a4,2(a5)
	i2c_master_send_buffer[3] = 0xEB;
 100029c:	572d                	li	a4,-21
 100029e:	00e781a3          	sb	a4,3(a5)
	i2c_master_send_buffer[4] = 0x90;
 10002a2:	f9000713          	li	a4,-112
 10002a6:	00e78223          	sb	a4,4(a5)
	i2c_master_send_buffer[5] = 0x99;
 10002aa:	f9900713          	li	a4,-103
 10002ae:	00e782a3          	sb	a4,5(a5)
	i2c_master_send_buffer[6] = 0x2A;
 10002b2:	02a00713          	li	a4,42
 10002b6:	00e78323          	sb	a4,6(a5)
	i2c_master_send_buffer[7] = 0xBE;
 10002ba:	fbe00713          	li	a4,-66
 10002be:	00e783a3          	sb	a4,7(a5)
	
	for (i = 8;i<200;i++)
 10002c2:	4721                	li	a4,8
 10002c4:	0c700793          	li	a5,199
 10002c8:	00e7eb63          	bltu	a5,a4,10002de <i2c_master_init+0x88>
	{
		i2c_master_send_buffer[i] = i;
 10002cc:	0ff77693          	andi	a3,a4,255
 10002d0:	43018793          	addi	a5,gp,1072 # 1000cd0 <i2c_master_send_buffer>
 10002d4:	97ba                	add	a5,a5,a4
 10002d6:	00d78023          	sb	a3,0(a5)
	for (i = 8;i<200;i++)
 10002da:	0705                	addi	a4,a4,1
 10002dc:	b7e5                	j	10002c4 <i2c_master_init+0x6e>
	}
}
 10002de:	8082                	ret

010002e0 <timer0_init>:

void timer0_init(unsigned int init_val)
{
	tm_count = 0;
 10002e0:	7401a823          	sw	zero,1872(gp) # 1000ff0 <tm_count>
	TIMER0_REG = init_val;	//load the initial value
 10002e4:	1f0207b7          	lui	a5,0x1f020
 10002e8:	c788                	sw	a0,8(a5)
	TIMER_CR |= 0x00000010;//enable timer0
 10002ea:	4398                	lw	a4,0(a5)
 10002ec:	01076713          	ori	a4,a4,16
 10002f0:	c398                	sw	a4,0(a5)
 10002f2:	e0801737          	lui	a4,0xe0801
 10002f6:	06974783          	lbu	a5,105(a4) # e0801069 <__bss_end__+0xdf800069>
 10002fa:	0ff7f793          	andi	a5,a5,255
 10002fe:	0017e793          	ori	a5,a5,1
 1000302:	06f704a3          	sb	a5,105(a4)
	
	csi_vic_enable_irq(TIM0_IRQn);
}
 1000306:	8082                	ret

01000308 <i2c_master_transmit>:

void i2c_master_transmit(unsigned int trans_num)
{
	rw_flag = 0;
 1000308:	0001a023          	sw	zero,0(gp) # 10008a0 <__etext>
	NWORD = trans_num - 1;
 100030c:	157d                	addi	a0,a0,-1
 100030e:	1f0306b7          	lui	a3,0x1f030
 1000312:	c2c8                	sw	a0,4(a3)
	DATA_2_IICM0 = (i2c_master_send_buffer[3] << 24) | (i2c_master_send_buffer[2] << 16) | (i2c_master_send_buffer[1] << 8) | (i2c_master_send_buffer[0]);
 1000314:	43018593          	addi	a1,gp,1072 # 1000cd0 <i2c_master_send_buffer>
 1000318:	0035c783          	lbu	a5,3(a1)
 100031c:	07e2                	slli	a5,a5,0x18
 100031e:	0025c703          	lbu	a4,2(a1)
 1000322:	0ff77713          	andi	a4,a4,255
 1000326:	0742                	slli	a4,a4,0x10
 1000328:	8fd9                	or	a5,a5,a4
 100032a:	0015c703          	lbu	a4,1(a1)
 100032e:	0ff77713          	andi	a4,a4,255
 1000332:	0722                	slli	a4,a4,0x8
 1000334:	8fd9                	or	a5,a5,a4
 1000336:	4301c703          	lbu	a4,1072(gp) # 1000cd0 <i2c_master_send_buffer>
 100033a:	0ff77713          	andi	a4,a4,255
 100033e:	8fd9                	or	a5,a5,a4
 1000340:	ce9c                	sw	a5,24(a3)
	MASTER_CPU_CMD = 0x00000011UL;
 1000342:	47c5                	li	a5,17
 1000344:	c69c                	sw	a5,8(a3)
}
 1000346:	8082                	ret

01000348 <i2c_master_rev>:

void i2c_master_rev(unsigned int rev_num)
{
	rw_flag = 1;
 1000348:	4705                	li	a4,1
 100034a:	00e1a023          	sw	a4,0(gp) # 10008a0 <__etext>
	NWORD = rev_num - 1;	
 100034e:	157d                	addi	a0,a0,-1
 1000350:	1f0307b7          	lui	a5,0x1f030
 1000354:	c3c8                	sw	a0,4(a5)
	MASTER_CPU_CMD = 0x00000012UL;
 1000356:	4749                	li	a4,18
 1000358:	c798                	sw	a4,8(a5)
}
 100035a:	8082                	ret

0100035c <i2c_master_restart_rev1>:

void i2c_master_restart_rev1(unsigned char address, unsigned int rev_num)
{
	rw_flag = 1;
 100035c:	4705                	li	a4,1
 100035e:	00e1a023          	sw	a4,0(gp) # 10008a0 <__etext>
	MAST_READ_ADDR = address;
 1000362:	1f0307b7          	lui	a5,0x1f030
 1000366:	cbc8                	sw	a0,20(a5)
	NWORD = rev_num - 1;
 1000368:	15fd                	addi	a1,a1,-1
 100036a:	c3cc                	sw	a1,4(a5)
	MASTER_CPU_CMD = 0x00000017UL;
 100036c:	475d                	li	a4,23
 100036e:	c798                	sw	a4,8(a5)
}
 1000370:	8082                	ret

01000372 <i2c_master_restart_rev2>:

void i2c_master_restart_rev2(unsigned short address, unsigned int rev_num)
{
	rw_flag = 1;
 1000372:	4705                	li	a4,1
 1000374:	00e1a023          	sw	a4,0(gp) # 10008a0 <__etext>
	MAST_READ_ADDR = address;
 1000378:	1f0307b7          	lui	a5,0x1f030
 100037c:	cbc8                	sw	a0,20(a5)
	NWORD = rev_num - 1;
 100037e:	15fd                	addi	a1,a1,-1
 1000380:	c3cc                	sw	a1,4(a5)
	MASTER_CPU_CMD = 0x0000001FUL;
 1000382:	477d                	li	a4,31
 1000384:	c798                	sw	a4,8(a5)
}
 1000386:	8082                	ret

01000388 <delay>:

void delay(unsigned int val)
{
	tm_count = 0;
 1000388:	7401a823          	sw	zero,1872(gp) # 1000ff0 <tm_count>
	while(tm_count < val)
 100038c:	7501a783          	lw	a5,1872(gp) # 1000ff0 <tm_count>
 1000390:	fea7eee3          	bltu	a5,a0,100038c <delay+0x4>
	{
		//
	}	
}
 1000394:	8082                	ret

01000396 <main>:

int main() 
{	
 1000396:	1151                	addi	sp,sp,-12
 1000398:	c406                	sw	ra,8(sp)
 100039a:	c222                	sw	s0,4(sp)
	unsigned int i = 0;
	
	i2c_slave_init();
 100039c:	3d61                	jal	1000234 <i2c_slave_init>
	i2c_master_init();
 100039e:	3d65                	jal	1000256 <i2c_master_init>
	timer0_init(16000);//1ms
 10003a0:	6511                	lui	a0,0x4
 10003a2:	e8050513          	addi	a0,a0,-384 # 3e80 <Reset_Handler-0xffc180>
 10003a6:	3f2d                	jal	10002e0 <timer0_init>
	
	ii = 0;
 10003a8:	0201a223          	sw	zero,36(gp) # 10008c4 <ii>
	ii2 = 0;
 10003ac:	0001a823          	sw	zero,16(gp) # 10008b0 <ii2>
	master_work_flag = 0;
 10003b0:	00018793          	mv	a5,gp
 10003b4:	00078223          	sb	zero,4(a5) # 1f030004 <__bss_end__+0x1e02f004>
	buffer_pointer = 0;
 10003b8:	0001ac23          	sw	zero,24(gp) # 10008b8 <buffer_pointer>
	buffer_cycle = 0;
 10003bc:	0001ae23          	sw	zero,28(gp) # 10008bc <buffer_cycle>
	
	buffer_pointer2 = 0;
 10003c0:	0001aa23          	sw	zero,20(gp) # 10008b4 <buffer_pointer2>
	buffer_cycle2 = 0;
 10003c4:	0201a023          	sw	zero,32(gp) # 10008c0 <buffer_cycle2>
	
	rw_flag = 0;
 10003c8:	0007a023          	sw	zero,0(a5)
	
	slave_buffer_pointer = 0;
 10003cc:	0007a423          	sw	zero,8(a5)
  \details Enables IRQ interrupts by setting the IE-bit in the PSR.
           Can only be executed in Privileged modes.
 */
__ALWAYS_STATIC_INLINE void __enable_irq(void)
{
    __ASM volatile("csrs mstatus, 8");
 10003d0:	30046073          	csrsi	mstatus,8

			delay(5000);
			buffer_cycle = 0;			
		}
		
		for (i=0;i<200;i++)
 10003d4:	4701                	li	a4,0
 10003d6:	0c700793          	li	a5,199
 10003da:	00e7e963          	bltu	a5,a4,10003ec <main+0x56>
		{
			i2c_slave_buffer[i] = 0x00;
 10003de:	68818793          	addi	a5,gp,1672 # 1000f28 <i2c_slave_buffer>
 10003e2:	97ba                	add	a5,a5,a4
 10003e4:	00078023          	sb	zero,0(a5)
		for (i=0;i<200;i++)
 10003e8:	0705                	addi	a4,a4,1
 10003ea:	b7f5                	j	10003d6 <main+0x40>
		}
		
		if (1)
		{
			for (i=0;i<200;i++)//generate slave transmit buffer
 10003ec:	4701                	li	a4,0
 10003ee:	0c700793          	li	a5,199
 10003f2:	00e7ed63          	bltu	a5,a4,100040c <main+0x76>
			{
				i2c_slave_buffer2[i] = i + 1;
 10003f6:	00170693          	addi	a3,a4,1
 10003fa:	0ff6f693          	andi	a3,a3,255
 10003fe:	5c018793          	addi	a5,gp,1472 # 1000e60 <i2c_slave_buffer2>
 1000402:	97ba                	add	a5,a5,a4
 1000404:	00d78023          	sb	a3,0(a5)
			for (i=0;i<200;i++)//generate slave transmit buffer
 1000408:	0705                	addi	a4,a4,1
 100040a:	b7d5                	j	10003ee <main+0x58>
			}
			pos = 0;
 100040c:	00018623          	sb	zero,12(gp) # 10008ac <pos>
			slave_buffer_pointer = 0;
 1000410:	00018793          	mv	a5,gp
 1000414:	0007a423          	sw	zero,8(a5)
			
			i2c_master_restart_rev1(0x55, 16 + 2);//first two dummy bytes
 1000418:	45c9                	li	a1,18
 100041a:	05500513          	li	a0,85
 100041e:	3f3d                	jal	100035c <i2c_master_restart_rev1>
			
			while(master_work_flag==0)
 1000420:	00018793          	mv	a5,gp
 1000424:	0047c783          	lbu	a5,4(a5)
 1000428:	dfe5                	beqz	a5,1000420 <main+0x8a>
			{
				//
			}
			master_work_flag = 0;
 100042a:	00018793          	mv	a5,gp
 100042e:	00078223          	sb	zero,4(a5)
			i2c_master_rev_buffer[4+(buffer_cycle2-1)*8] = IICM_2_DATA1 & 0x000000ff;
 1000432:	1f0306b7          	lui	a3,0x1f030
 1000436:	52cc                	lw	a1,36(a3)
 1000438:	0201a703          	lw	a4,32(gp) # 10008c0 <buffer_cycle2>
 100043c:	20000637          	lui	a2,0x20000
 1000440:	167d                	addi	a2,a2,-1
 1000442:	9732                	add	a4,a4,a2
 1000444:	070e                	slli	a4,a4,0x3
 1000446:	0711                	addi	a4,a4,4
 1000448:	0ff5f593          	andi	a1,a1,255
 100044c:	4f818793          	addi	a5,gp,1272 # 1000d98 <i2c_master_rev_buffer>
 1000450:	973e                	add	a4,a4,a5
 1000452:	00b70023          	sb	a1,0(a4)
			i2c_master_rev_buffer[5+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x0000ff00) >> 8;
 1000456:	52cc                	lw	a1,36(a3)
 1000458:	85a1                	srai	a1,a1,0x8
 100045a:	0201a703          	lw	a4,32(gp) # 10008c0 <buffer_cycle2>
 100045e:	9732                	add	a4,a4,a2
 1000460:	070e                	slli	a4,a4,0x3
 1000462:	0715                	addi	a4,a4,5
 1000464:	0ff5f593          	andi	a1,a1,255
 1000468:	973e                	add	a4,a4,a5
 100046a:	00b70023          	sb	a1,0(a4)
			i2c_master_rev_buffer[6+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x00ff0000) >> 16;
 100046e:	52cc                	lw	a1,36(a3)
 1000470:	85c1                	srai	a1,a1,0x10
 1000472:	0201a703          	lw	a4,32(gp) # 10008c0 <buffer_cycle2>
 1000476:	9732                	add	a4,a4,a2
 1000478:	070e                	slli	a4,a4,0x3
 100047a:	0719                	addi	a4,a4,6
 100047c:	0ff5f593          	andi	a1,a1,255
 1000480:	973e                	add	a4,a4,a5
 1000482:	00b70023          	sb	a1,0(a4)
			i2c_master_rev_buffer[7+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0xff000000) >> 24;
 1000486:	52cc                	lw	a1,36(a3)
 1000488:	0201a703          	lw	a4,32(gp) # 10008c0 <buffer_cycle2>
 100048c:	9732                	add	a4,a4,a2
 100048e:	070e                	slli	a4,a4,0x3
 1000490:	071d                	addi	a4,a4,7
 1000492:	0185d613          	srli	a2,a1,0x18
 1000496:	973e                	add	a4,a4,a5
 1000498:	00c70023          	sb	a2,0(a4)
			i2c_master_rev_buffer[0+buffer_cycle2*8] = IICM_2_DATA0 & 0x000000ff;
 100049c:	5290                	lw	a2,32(a3)
 100049e:	0201a703          	lw	a4,32(gp) # 10008c0 <buffer_cycle2>
 10004a2:	070e                	slli	a4,a4,0x3
 10004a4:	0ff67613          	andi	a2,a2,255
 10004a8:	973e                	add	a4,a4,a5
 10004aa:	00c70023          	sb	a2,0(a4)
			i2c_master_rev_buffer[1+buffer_cycle2*8] = (IICM_2_DATA0 & 0x0000ff00) >> 8;
 10004ae:	5290                	lw	a2,32(a3)
 10004b0:	8621                	srai	a2,a2,0x8
 10004b2:	0201a703          	lw	a4,32(gp) # 10008c0 <buffer_cycle2>
 10004b6:	070e                	slli	a4,a4,0x3
 10004b8:	0705                	addi	a4,a4,1
 10004ba:	0ff67613          	andi	a2,a2,255
 10004be:	973e                	add	a4,a4,a5
 10004c0:	00c70023          	sb	a2,0(a4)
			i2c_master_rev_buffer[2+buffer_cycle2*8] = (IICM_2_DATA0 & 0x00ff0000) >> 16;
 10004c4:	5290                	lw	a2,32(a3)
 10004c6:	8641                	srai	a2,a2,0x10
 10004c8:	0201a703          	lw	a4,32(gp) # 10008c0 <buffer_cycle2>
 10004cc:	070e                	slli	a4,a4,0x3
 10004ce:	0709                	addi	a4,a4,2
 10004d0:	0ff67613          	andi	a2,a2,255
 10004d4:	973e                	add	a4,a4,a5
 10004d6:	00c70023          	sb	a2,0(a4)
			i2c_master_rev_buffer[3+buffer_cycle2*8] = (IICM_2_DATA0 & 0xff000000) >> 24;		
 10004da:	5294                	lw	a3,32(a3)
 10004dc:	0201a703          	lw	a4,32(gp) # 10008c0 <buffer_cycle2>
 10004e0:	070e                	slli	a4,a4,0x3
 10004e2:	070d                	addi	a4,a4,3
 10004e4:	82e1                	srli	a3,a3,0x18
 10004e6:	97ba                	add	a5,a5,a4
 10004e8:	00d78023          	sb	a3,0(a5)
		
			delay(5000);
 10004ec:	6505                	lui	a0,0x1
 10004ee:	38850513          	addi	a0,a0,904 # 1388 <Reset_Handler-0xffec78>
 10004f2:	3d59                	jal	1000388 <delay>
			
			buffer_cycle2 = 0;
 10004f4:	0201a023          	sw	zero,32(gp) # 10008c0 <buffer_cycle2>
			for (i=0;i<200;i++)
 10004f8:	4701                	li	a4,0
 10004fa:	0c700793          	li	a5,199
 10004fe:	00e7e963          	bltu	a5,a4,1000510 <main+0x17a>
			{
				i2c_master_rev_buffer[i] = 0x00;
 1000502:	4f818793          	addi	a5,gp,1272 # 1000d98 <i2c_master_rev_buffer>
 1000506:	97ba                	add	a5,a5,a4
 1000508:	00078023          	sb	zero,0(a5)
			for (i=0;i<200;i++)
 100050c:	0705                	addi	a4,a4,1
 100050e:	b7f5                	j	10004fa <main+0x164>
			}				
		}
		
		for (i=0;i<200;i++)//clear slave rev buffer
 1000510:	4701                	li	a4,0
 1000512:	0c700793          	li	a5,199
 1000516:	eae7efe3          	bltu	a5,a4,10003d4 <main+0x3e>
		{
			i2c_slave_buffer[i] = 0x00;
 100051a:	68818793          	addi	a5,gp,1672 # 1000f28 <i2c_slave_buffer>
 100051e:	97ba                	add	a5,a5,a4
 1000520:	00078023          	sb	zero,0(a5)
		for (i=0;i<200;i++)//clear slave rev buffer
 1000524:	0705                	addi	a4,a4,1
 1000526:	b7f5                	j	1000512 <main+0x17c>

01000528 <handle_irq>:
extern volatile unsigned int slave_buffer_pointer;
volatile unsigned char pos = 0;

void handle_irq(uint32_t vec) 
{	
	if (I2C_SLAVE_IRQn == vec)
 1000528:	47dd                	li	a5,23
 100052a:	00f50963          	beq	a0,a5,100053c <handle_irq+0x14>
				//rev
			}
		}
	}	
	
	if (I2C_MASTER_IRQn == vec)
 100052e:	47d9                	li	a5,22
 1000530:	0cf50f63          	beq	a0,a5,100060e <handle_irq+0xe6>
		{
			MAST_CLEAR |= 0x00000001;
		}
	}
	
	if (TIM0_IRQn == vec)
 1000534:	47e9                	li	a5,26
 1000536:	34f50263          	beq	a0,a5,100087a <handle_irq+0x352>
	{
		tm_count++;
		TIMER_CR |= 0x00000100;
	}
}
 100053a:	8082                	ret
		SLAVEB_CLEAR |= 0x00000010;
 100053c:	1f0407b7          	lui	a5,0x1f040
 1000540:	4bd8                	lw	a4,20(a5)
 1000542:	01076713          	ori	a4,a4,16
 1000546:	cbd8                	sw	a4,20(a5)
		if (0x00000008 & SLAVEB_STATUS)		//addr
 1000548:	4b9c                	lw	a5,16(a5)
 100054a:	8ba1                	andi	a5,a5,8
 100054c:	c385                	beqz	a5,100056c <handle_irq+0x44>
			SLAVEB_CLEAR |= 0x00000008;		
 100054e:	1f0407b7          	lui	a5,0x1f040
 1000552:	4bd8                	lw	a4,20(a5)
 1000554:	00876713          	ori	a4,a4,8
 1000558:	cbd8                	sw	a4,20(a5)
			i2c_slave_buffer[0] = (SLAVEB_DATA >> 8) & 0x000000FF;
 100055a:	479c                	lw	a5,8(a5)
 100055c:	87a1                	srai	a5,a5,0x8
 100055e:	0ff7f793          	andi	a5,a5,255
 1000562:	68f18423          	sb	a5,1672(gp) # 1000f28 <i2c_slave_buffer>
			pos = 1;
 1000566:	4705                	li	a4,1
 1000568:	00e18623          	sb	a4,12(gp) # 10008ac <pos>
		if (0x00000001 & SLAVEB_STATUS)		//rw int
 100056c:	1f0407b7          	lui	a5,0x1f040
 1000570:	4b9c                	lw	a5,16(a5)
 1000572:	8b85                	andi	a5,a5,1
 1000574:	cb9d                	beqz	a5,10005aa <handle_irq+0x82>
			SLAVEB_CLEAR |= 0x00000001;			
 1000576:	1f0407b7          	lui	a5,0x1f040
 100057a:	4bd8                	lw	a4,20(a5)
 100057c:	00176713          	ori	a4,a4,1
 1000580:	cbd8                	sw	a4,20(a5)
			if (0x00000010 & SLAVEB_STATUS)
 1000582:	4b9c                	lw	a5,16(a5)
 1000584:	8bc1                	andi	a5,a5,16
 1000586:	cbb1                	beqz	a5,10005da <handle_irq+0xb2>
				SLAVEB_DATA_2_IIC = i2c_slave_buffer2[slave_buffer_pointer];
 1000588:	0081a703          	lw	a4,8(gp) # 10008a8 <slave_buffer_pointer>
 100058c:	5c018693          	addi	a3,gp,1472 # 1000e60 <i2c_slave_buffer2>
 1000590:	9736                	add	a4,a4,a3
 1000592:	00074703          	lbu	a4,0(a4)
 1000596:	0ff77713          	andi	a4,a4,255
 100059a:	1f0406b7          	lui	a3,0x1f040
 100059e:	c6d8                	sw	a4,12(a3)
				slave_buffer_pointer++;
 10005a0:	0081a703          	lw	a4,8(gp) # 10008a8 <slave_buffer_pointer>
 10005a4:	0705                	addi	a4,a4,1
 10005a6:	00e1a423          	sw	a4,8(gp) # 10008a8 <slave_buffer_pointer>
		if (0x00000002 & SLAVEB_STATUS)		//nack
 10005aa:	1f0407b7          	lui	a5,0x1f040
 10005ae:	4b9c                	lw	a5,16(a5)
 10005b0:	8b89                	andi	a5,a5,2
 10005b2:	c799                	beqz	a5,10005c0 <handle_irq+0x98>
			SLAVEB_CLEAR |= 0x00000002;
 10005b4:	1f040737          	lui	a4,0x1f040
 10005b8:	4b5c                	lw	a5,20(a4)
 10005ba:	0027e793          	ori	a5,a5,2
 10005be:	cb5c                	sw	a5,20(a4)
		if (0x00000004 & SLAVEB_STATUS)		//stop
 10005c0:	1f0407b7          	lui	a5,0x1f040
 10005c4:	4b9c                	lw	a5,16(a5)
 10005c6:	8b91                	andi	a5,a5,4
 10005c8:	d3bd                	beqz	a5,100052e <handle_irq+0x6>
			SLAVEB_CLEAR |= 0x00000004;		
 10005ca:	1f0407b7          	lui	a5,0x1f040
 10005ce:	4bd8                	lw	a4,20(a5)
 10005d0:	00476713          	ori	a4,a4,4
 10005d4:	cbd8                	sw	a4,20(a5)
			if (0x00000010 & SLAVEB_STATUS)
 10005d6:	4b9c                	lw	a5,16(a5)
 10005d8:	bf99                	j	100052e <handle_irq+0x6>
				i2c_slave_buffer[pos] = (SLAVEB_DATA) & 0x000000FF;
 10005da:	1f0407b7          	lui	a5,0x1f040
 10005de:	4794                	lw	a3,8(a5)
 10005e0:	00c18713          	addi	a4,gp,12 # 10008ac <pos>
 10005e4:	00074783          	lbu	a5,0(a4) # 1f040000 <__bss_end__+0x1e03f000>
 10005e8:	0ff7f793          	andi	a5,a5,255
 10005ec:	0ff6f693          	andi	a3,a3,255
 10005f0:	68818613          	addi	a2,gp,1672 # 1000f28 <i2c_slave_buffer>
 10005f4:	97b2                	add	a5,a5,a2
 10005f6:	00d78023          	sb	a3,0(a5) # 1f040000 <__bss_end__+0x1e03f000>
				pos++;
 10005fa:	00074783          	lbu	a5,0(a4)
 10005fe:	0ff7f793          	andi	a5,a5,255
 1000602:	0785                	addi	a5,a5,1
 1000604:	0ff7f793          	andi	a5,a5,255
 1000608:	00f70023          	sb	a5,0(a4)
 100060c:	bf79                	j	10005aa <handle_irq+0x82>
		ii2++;
 100060e:	00c18793          	addi	a5,gp,12 # 10008ac <pos>
 1000612:	43d8                	lw	a4,4(a5)
 1000614:	0705                	addi	a4,a4,1
 1000616:	c3d8                	sw	a4,4(a5)
		if (0x00000010 & MAST_STATUS) // byte done
 1000618:	1f0307b7          	lui	a5,0x1f030
 100061c:	579c                	lw	a5,40(a5)
 100061e:	8bc1                	andi	a5,a5,16
 1000620:	c3ad                	beqz	a5,1000682 <handle_irq+0x15a>
			MAST_CLEAR |= 0x00000008;
 1000622:	1f030737          	lui	a4,0x1f030
 1000626:	5b1c                	lw	a5,48(a4)
 1000628:	0087e793          	ori	a5,a5,8
 100062c:	db1c                	sw	a5,48(a4)
			if (rw_flag)
 100062e:	0001a783          	lw	a5,0(gp) # 10008a0 <__etext>
 1000632:	cfd9                	beqz	a5,10006d0 <handle_irq+0x1a8>
				buffer_pointer2 = (0x0000ff00 & MAST_STATUS) >> 8;
 1000634:	1f0307b7          	lui	a5,0x1f030
 1000638:	579c                	lw	a5,40(a5)
 100063a:	87a1                	srai	a5,a5,0x8
 100063c:	0ff7f793          	andi	a5,a5,255
 1000640:	00c18713          	addi	a4,gp,12 # 10008ac <pos>
 1000644:	c71c                	sw	a5,8(a4)
				buffer_pointer = 0;
 1000646:	00072623          	sw	zero,12(a4) # 1f03000c <__bss_end__+0x1e02f00c>
			if (buffer_pointer % 8 == 1)//发送
 100064a:	00c18793          	addi	a5,gp,12 # 10008ac <pos>
 100064e:	47dc                	lw	a5,12(a5)
 1000650:	8b9d                	andi	a5,a5,7
 1000652:	4705                	li	a4,1
 1000654:	08e78a63          	beq	a5,a4,10006e8 <handle_irq+0x1c0>
			else if (buffer_pointer % 8 == 4)
 1000658:	00c18793          	addi	a5,gp,12 # 10008ac <pos>
 100065c:	47dc                	lw	a5,12(a5)
 100065e:	8b9d                	andi	a5,a5,7
 1000660:	4711                	li	a4,4
 1000662:	0ee78263          	beq	a5,a4,1000746 <handle_irq+0x21e>
			if (buffer_pointer2 % 8 == 1)//接收
 1000666:	00c18793          	addi	a5,gp,12 # 10008ac <pos>
 100066a:	479c                	lw	a5,8(a5)
 100066c:	8b9d                	andi	a5,a5,7
 100066e:	4705                	li	a4,1
 1000670:	12e78663          	beq	a5,a4,100079c <handle_irq+0x274>
			else if (buffer_pointer2 % 8 == 5)
 1000674:	00c18793          	addi	a5,gp,12 # 10008ac <pos>
 1000678:	479c                	lw	a5,8(a5)
 100067a:	8b9d                	andi	a5,a5,7
 100067c:	4715                	li	a4,5
 100067e:	18e78d63          	beq	a5,a4,1000818 <handle_irq+0x2f0>
		if (0x00000008 & MAST_STATUS)//idle
 1000682:	1f0307b7          	lui	a5,0x1f030
 1000686:	5798                	lw	a4,40(a5)
		if (0x00000004 & MAST_STATUS)//timeout
 1000688:	579c                	lw	a5,40(a5)
 100068a:	8b91                	andi	a5,a5,4
 100068c:	c799                	beqz	a5,100069a <handle_irq+0x172>
			MAST_CLEAR |= 0x00000004;
 100068e:	1f030737          	lui	a4,0x1f030
 1000692:	5b1c                	lw	a5,48(a4)
 1000694:	0047e793          	ori	a5,a5,4
 1000698:	db1c                	sw	a5,48(a4)
		if (0x00000002 & MAST_STATUS)//after stop
 100069a:	1f0307b7          	lui	a5,0x1f030
 100069e:	579c                	lw	a5,40(a5)
 10006a0:	8b89                	andi	a5,a5,2
 10006a2:	cb91                	beqz	a5,10006b6 <handle_irq+0x18e>
			MAST_CLEAR |= 0x00000002;
 10006a4:	1f030737          	lui	a4,0x1f030
 10006a8:	5b1c                	lw	a5,48(a4)
 10006aa:	0027e793          	ori	a5,a5,2
 10006ae:	db1c                	sw	a5,48(a4)
			master_work_flag = 1;
 10006b0:	4705                	li	a4,1
 10006b2:	00e18223          	sb	a4,4(gp) # 10008a4 <master_work_flag>
		if (0x00000001 & MAST_STATUS)//no ack
 10006b6:	1f0307b7          	lui	a5,0x1f030
 10006ba:	579c                	lw	a5,40(a5)
 10006bc:	8b85                	andi	a5,a5,1
 10006be:	e6078be3          	beqz	a5,1000534 <handle_irq+0xc>
			MAST_CLEAR |= 0x00000001;
 10006c2:	1f030737          	lui	a4,0x1f030
 10006c6:	5b1c                	lw	a5,48(a4)
 10006c8:	0017e793          	ori	a5,a5,1
 10006cc:	db1c                	sw	a5,48(a4)
 10006ce:	b59d                	j	1000534 <handle_irq+0xc>
				buffer_pointer = (0x0000ff00 & MAST_STATUS) >> 8;
 10006d0:	1f0307b7          	lui	a5,0x1f030
 10006d4:	579c                	lw	a5,40(a5)
 10006d6:	87a1                	srai	a5,a5,0x8
 10006d8:	0ff7f793          	andi	a5,a5,255
 10006dc:	00c18713          	addi	a4,gp,12 # 10008ac <pos>
 10006e0:	c75c                	sw	a5,12(a4)
				buffer_pointer2 = 0;
 10006e2:	00072423          	sw	zero,8(a4) # 1f030008 <__bss_end__+0x1e02f008>
 10006e6:	b795                	j	100064a <handle_irq+0x122>
				DATA_2_IICM1 = (i2c_master_send_buffer[7+buffer_cycle*8] << 24) | (i2c_master_send_buffer[6+buffer_cycle*8] << 16) | (i2c_master_send_buffer[5+buffer_cycle*8] << 8) | (i2c_master_send_buffer[4+buffer_cycle*8]);				
 10006e8:	00c18713          	addi	a4,gp,12 # 10008ac <pos>
 10006ec:	4b1c                	lw	a5,16(a4)
 10006ee:	078e                	slli	a5,a5,0x3
 10006f0:	079d                	addi	a5,a5,7
 10006f2:	43018593          	addi	a1,gp,1072 # 1000cd0 <i2c_master_send_buffer>
 10006f6:	97ae                	add	a5,a5,a1
 10006f8:	0007c783          	lbu	a5,0(a5) # 1f030000 <__bss_end__+0x1e02f000>
 10006fc:	07e2                	slli	a5,a5,0x18
 10006fe:	4b14                	lw	a3,16(a4)
 1000700:	068e                	slli	a3,a3,0x3
 1000702:	0699                	addi	a3,a3,6
 1000704:	96ae                	add	a3,a3,a1
 1000706:	0006c683          	lbu	a3,0(a3) # 1f040000 <__bss_end__+0x1e03f000>
 100070a:	0ff6f693          	andi	a3,a3,255
 100070e:	06c2                	slli	a3,a3,0x10
 1000710:	8fd5                	or	a5,a5,a3
 1000712:	4b10                	lw	a2,16(a4)
 1000714:	060e                	slli	a2,a2,0x3
 1000716:	0615                	addi	a2,a2,5
 1000718:	962e                	add	a2,a2,a1
 100071a:	00064683          	lbu	a3,0(a2) # 20000000 <__bss_end__+0x1efff000>
 100071e:	0ff6f693          	andi	a3,a3,255
 1000722:	06a2                	slli	a3,a3,0x8
 1000724:	8fd5                	or	a5,a5,a3
 1000726:	4b14                	lw	a3,16(a4)
 1000728:	068e                	slli	a3,a3,0x3
 100072a:	0691                	addi	a3,a3,4
 100072c:	96ae                	add	a3,a3,a1
 100072e:	0006c683          	lbu	a3,0(a3)
 1000732:	0ff6f693          	andi	a3,a3,255
 1000736:	8fd5                	or	a5,a5,a3
 1000738:	1f0306b7          	lui	a3,0x1f030
 100073c:	cedc                	sw	a5,28(a3)
				buffer_cycle++;
 100073e:	4b1c                	lw	a5,16(a4)
 1000740:	0785                	addi	a5,a5,1
 1000742:	cb1c                	sw	a5,16(a4)
 1000744:	b70d                	j	1000666 <handle_irq+0x13e>
				DATA_2_IICM0 = (i2c_master_send_buffer[3+buffer_cycle*8] << 24) | (i2c_master_send_buffer[2+buffer_cycle*8] << 16) | (i2c_master_send_buffer[1+buffer_cycle*8] << 8) | (i2c_master_send_buffer[0+buffer_cycle*8]);
 1000746:	00c18613          	addi	a2,gp,12 # 10008ac <pos>
 100074a:	4a1c                	lw	a5,16(a2)
 100074c:	078e                	slli	a5,a5,0x3
 100074e:	078d                	addi	a5,a5,3
 1000750:	43018693          	addi	a3,gp,1072 # 1000cd0 <i2c_master_send_buffer>
 1000754:	97b6                	add	a5,a5,a3
 1000756:	0007c783          	lbu	a5,0(a5)
 100075a:	07e2                	slli	a5,a5,0x18
 100075c:	4a18                	lw	a4,16(a2)
 100075e:	070e                	slli	a4,a4,0x3
 1000760:	0709                	addi	a4,a4,2
 1000762:	9736                	add	a4,a4,a3
 1000764:	00074703          	lbu	a4,0(a4)
 1000768:	0ff77713          	andi	a4,a4,255
 100076c:	0742                	slli	a4,a4,0x10
 100076e:	8fd9                	or	a5,a5,a4
 1000770:	4a18                	lw	a4,16(a2)
 1000772:	070e                	slli	a4,a4,0x3
 1000774:	0705                	addi	a4,a4,1
 1000776:	9736                	add	a4,a4,a3
 1000778:	00074703          	lbu	a4,0(a4)
 100077c:	0ff77713          	andi	a4,a4,255
 1000780:	0722                	slli	a4,a4,0x8
 1000782:	8fd9                	or	a5,a5,a4
 1000784:	4a18                	lw	a4,16(a2)
 1000786:	070e                	slli	a4,a4,0x3
 1000788:	96ba                	add	a3,a3,a4
 100078a:	0006c703          	lbu	a4,0(a3) # 1f030000 <__bss_end__+0x1e02f000>
 100078e:	0ff77713          	andi	a4,a4,255
 1000792:	8fd9                	or	a5,a5,a4
 1000794:	1f030737          	lui	a4,0x1f030
 1000798:	cf1c                	sw	a5,24(a4)
 100079a:	b5f1                	j	1000666 <handle_irq+0x13e>
				if (buffer_cycle2 != 0)
 100079c:	00c18793          	addi	a5,gp,12 # 10008ac <pos>
 10007a0:	4bdc                	lw	a5,20(a5)
 10007a2:	ee0780e3          	beqz	a5,1000682 <handle_irq+0x15a>
					i2c_master_rev_buffer[4+(buffer_cycle2-1)*8] = IICM_2_DATA1 & 0x000000ff;
 10007a6:	1f030337          	lui	t1,0x1f030
 10007aa:	02432283          	lw	t0,36(t1) # 1f030024 <__bss_end__+0x1e02f024>
 10007ae:	00c18593          	addi	a1,gp,12 # 10008ac <pos>
 10007b2:	49dc                	lw	a5,20(a1)
 10007b4:	20000637          	lui	a2,0x20000
 10007b8:	167d                	addi	a2,a2,-1
 10007ba:	97b2                	add	a5,a5,a2
 10007bc:	078e                	slli	a5,a5,0x3
 10007be:	00478713          	addi	a4,a5,4
 10007c2:	0ff2f293          	andi	t0,t0,255
 10007c6:	4f818693          	addi	a3,gp,1272 # 1000d98 <i2c_master_rev_buffer>
 10007ca:	00d707b3          	add	a5,a4,a3
 10007ce:	00578023          	sb	t0,0(a5)
					i2c_master_rev_buffer[5+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x0000ff00) >> 8;
 10007d2:	02432783          	lw	a5,36(t1)
 10007d6:	87a1                	srai	a5,a5,0x8
 10007d8:	49d8                	lw	a4,20(a1)
 10007da:	9732                	add	a4,a4,a2
 10007dc:	070e                	slli	a4,a4,0x3
 10007de:	0715                	addi	a4,a4,5
 10007e0:	0ff7f793          	andi	a5,a5,255
 10007e4:	9736                	add	a4,a4,a3
 10007e6:	00f70023          	sb	a5,0(a4) # 1f030000 <__bss_end__+0x1e02f000>
					i2c_master_rev_buffer[6+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x00ff0000) >> 16;
 10007ea:	02432783          	lw	a5,36(t1)
 10007ee:	87c1                	srai	a5,a5,0x10
 10007f0:	49d8                	lw	a4,20(a1)
 10007f2:	9732                	add	a4,a4,a2
 10007f4:	070e                	slli	a4,a4,0x3
 10007f6:	0719                	addi	a4,a4,6
 10007f8:	0ff7f793          	andi	a5,a5,255
 10007fc:	9736                	add	a4,a4,a3
 10007fe:	00f70023          	sb	a5,0(a4)
					i2c_master_rev_buffer[7+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0xff000000) >> 24;					
 1000802:	02432703          	lw	a4,36(t1)
 1000806:	49dc                	lw	a5,20(a1)
 1000808:	97b2                	add	a5,a5,a2
 100080a:	078e                	slli	a5,a5,0x3
 100080c:	079d                	addi	a5,a5,7
 100080e:	8361                	srli	a4,a4,0x18
 1000810:	97b6                	add	a5,a5,a3
 1000812:	00e78023          	sb	a4,0(a5)
 1000816:	b5b5                	j	1000682 <handle_irq+0x15a>
				i2c_master_rev_buffer[0+buffer_cycle2*8] = IICM_2_DATA0 & 0x000000ff;
 1000818:	1f0305b7          	lui	a1,0x1f030
 100081c:	0205a303          	lw	t1,32(a1) # 1f030020 <__bss_end__+0x1e02f020>
 1000820:	00c18793          	addi	a5,gp,12 # 10008ac <pos>
 1000824:	4bd8                	lw	a4,20(a5)
 1000826:	00371693          	slli	a3,a4,0x3
 100082a:	0ff37313          	andi	t1,t1,255
 100082e:	4f818613          	addi	a2,gp,1272 # 1000d98 <i2c_master_rev_buffer>
 1000832:	00c68733          	add	a4,a3,a2
 1000836:	00670023          	sb	t1,0(a4)
				i2c_master_rev_buffer[1+buffer_cycle2*8] = (IICM_2_DATA0 & 0x0000ff00) >> 8;
 100083a:	5198                	lw	a4,32(a1)
 100083c:	8721                	srai	a4,a4,0x8
 100083e:	4bd4                	lw	a3,20(a5)
 1000840:	068e                	slli	a3,a3,0x3
 1000842:	0685                	addi	a3,a3,1
 1000844:	0ff77713          	andi	a4,a4,255
 1000848:	96b2                	add	a3,a3,a2
 100084a:	00e68023          	sb	a4,0(a3)
				i2c_master_rev_buffer[2+buffer_cycle2*8] = (IICM_2_DATA0 & 0x00ff0000) >> 16;
 100084e:	5198                	lw	a4,32(a1)
 1000850:	8741                	srai	a4,a4,0x10
 1000852:	4bd4                	lw	a3,20(a5)
 1000854:	068e                	slli	a3,a3,0x3
 1000856:	0689                	addi	a3,a3,2
 1000858:	0ff77713          	andi	a4,a4,255
 100085c:	96b2                	add	a3,a3,a2
 100085e:	00e68023          	sb	a4,0(a3)
				i2c_master_rev_buffer[3+buffer_cycle2*8] = (IICM_2_DATA0 & 0xff000000) >> 24;
 1000862:	5194                	lw	a3,32(a1)
 1000864:	4bd8                	lw	a4,20(a5)
 1000866:	070e                	slli	a4,a4,0x3
 1000868:	070d                	addi	a4,a4,3
 100086a:	82e1                	srli	a3,a3,0x18
 100086c:	9732                	add	a4,a4,a2
 100086e:	00d70023          	sb	a3,0(a4)
				buffer_cycle2++;
 1000872:	4bd8                	lw	a4,20(a5)
 1000874:	0705                	addi	a4,a4,1
 1000876:	cbd8                	sw	a4,20(a5)
 1000878:	b529                	j	1000682 <handle_irq+0x15a>
		tm_count++;
 100087a:	7501a783          	lw	a5,1872(gp) # 1000ff0 <tm_count>
 100087e:	0785                	addi	a5,a5,1
 1000880:	74f1a823          	sw	a5,1872(gp) # 1000ff0 <tm_count>
		TIMER_CR |= 0x00000100;
 1000884:	1f020737          	lui	a4,0x1f020
 1000888:	431c                	lw	a5,0(a4)
 100088a:	1007e793          	ori	a5,a5,256
 100088e:	c31c                	sw	a5,0(a4)
}
 1000890:	b16d                	j	100053a <handle_irq+0x12>
	...
