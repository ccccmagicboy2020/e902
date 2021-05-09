
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
 100000c:	8c818193          	addi	gp,gp,-1848 # 10008d0 <__etext>
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
 100002c:	22018113          	addi	sp,gp,544 # 1000af0 <__initial_sp>
    csrw    mscratch, sp
 1000030:	34011073          	csrw	mscratch,sp

    jal     main
 1000034:	346000ef          	jal	ra,100037a <main>

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
 100012e:	4d6000ef          	jal	ra,1000604 <handle_irq>

    csrc    mstatus, 8
 1000132:	30047073          	csrci	mstatus,8

    lw      a1, 40(sp)
 1000136:	55a2                	lw	a1,40(sp)
    andi    a0, a1, 0x3FF
 1000138:	3ff5f513          	andi	a0,a1,1023

    /* clear pending */
    li      a2, 0xE000E100
 100013c:	e000e637          	lui	a2,0xe000e
 1000140:	10060613          	addi	a2,a2,256 # e000e100 <__bss_end__+0xdf00d260>
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
 10001ce:	42018293          	addi	t0,gp,1056 # 1000cf0 <g_trap_sp>
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
 1000256:	05974783          	lbu	a5,89(a4) # e0801059 <__bss_end__+0xdf8001b9>
 100025a:	0ff7f793          	andi	a5,a5,255
 100025e:	0017e793          	ori	a5,a5,1
 1000262:	04f70ca3          	sb	a5,89(a4)
	
	csi_vic_enable_irq(I2C_MASTER_IRQn);
	
	i2c_master_send_buffer[0] = 0x12;
 1000266:	4749                	li	a4,18
 1000268:	42e18423          	sb	a4,1064(gp) # 1000cf8 <i2c_master_send_buffer>
	i2c_master_send_buffer[1] = 0x55;
 100026c:	42818793          	addi	a5,gp,1064 # 1000cf8 <i2c_master_send_buffer>
 1000270:	05500713          	li	a4,85
 1000274:	00e780a3          	sb	a4,1(a5) # 1f030001 <__bss_end__+0x1e02f161>
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
 10002b4:	42818793          	addi	a5,gp,1064 # 1000cf8 <i2c_master_send_buffer>
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
 10002c4:	5c01a423          	sw	zero,1480(gp) # 1000e98 <tm_count>
	TIMER0_REG = init_val;	//load the initial value
 10002c8:	1f0207b7          	lui	a5,0x1f020
 10002cc:	c788                	sw	a0,8(a5)
	TIMER_CR |= 0x00000010;//enable timer0
 10002ce:	4398                	lw	a4,0(a5)
 10002d0:	01076713          	ori	a4,a4,16
 10002d4:	c398                	sw	a4,0(a5)
 10002d6:	e0801737          	lui	a4,0xe0801
 10002da:	06974783          	lbu	a5,105(a4) # e0801069 <__bss_end__+0xdf8001c9>
 10002de:	0ff7f793          	andi	a5,a5,255
 10002e2:	0017e793          	ori	a5,a5,1
 10002e6:	06f704a3          	sb	a5,105(a4)
	
	csi_vic_enable_irq(TIM0_IRQn);
}
 10002ea:	8082                	ret

010002ec <i2c_master_transmit>:

void i2c_master_transmit(unsigned int trans_num)
{
	rw_flag = 0;
 10002ec:	0001a023          	sw	zero,0(gp) # 10008d0 <__etext>
	NWORD = trans_num - 1;
 10002f0:	157d                	addi	a0,a0,-1
 10002f2:	1f0306b7          	lui	a3,0x1f030
 10002f6:	c2c8                	sw	a0,4(a3)
	DATA_2_IICM0 = (i2c_master_send_buffer[3] << 24) | (i2c_master_send_buffer[2] << 16) | (i2c_master_send_buffer[1] << 8) | (i2c_master_send_buffer[0]);
 10002f8:	42818593          	addi	a1,gp,1064 # 1000cf8 <i2c_master_send_buffer>
 10002fc:	0035c783          	lbu	a5,3(a1)
 1000300:	07e2                	slli	a5,a5,0x18
 1000302:	0025c703          	lbu	a4,2(a1)
 1000306:	0ff77713          	andi	a4,a4,255
 100030a:	0742                	slli	a4,a4,0x10
 100030c:	8fd9                	or	a5,a5,a4
 100030e:	0015c703          	lbu	a4,1(a1)
 1000312:	0ff77713          	andi	a4,a4,255
 1000316:	0722                	slli	a4,a4,0x8
 1000318:	8fd9                	or	a5,a5,a4
 100031a:	4281c703          	lbu	a4,1064(gp) # 1000cf8 <i2c_master_send_buffer>
 100031e:	0ff77713          	andi	a4,a4,255
 1000322:	8fd9                	or	a5,a5,a4
 1000324:	ce9c                	sw	a5,24(a3)
	MASTER_CPU_CMD = 0x00000011UL;
 1000326:	47c5                	li	a5,17
 1000328:	c69c                	sw	a5,8(a3)
}
 100032a:	8082                	ret

0100032c <i2c_master_rev>:

void i2c_master_rev(unsigned int rev_num)
{
	rw_flag = 1;
 100032c:	4705                	li	a4,1
 100032e:	00e1a023          	sw	a4,0(gp) # 10008d0 <__etext>
	NWORD = rev_num - 1;	
 1000332:	157d                	addi	a0,a0,-1
 1000334:	1f0307b7          	lui	a5,0x1f030
 1000338:	c3c8                	sw	a0,4(a5)
	MASTER_CPU_CMD = 0x00000012UL;
 100033a:	4749                	li	a4,18
 100033c:	c798                	sw	a4,8(a5)
}
 100033e:	8082                	ret

01000340 <i2c_master_restart_rev1>:

void i2c_master_restart_rev1(unsigned char address, unsigned int rev_num)
{
	rw_flag = 1;
 1000340:	4705                	li	a4,1
 1000342:	00e1a023          	sw	a4,0(gp) # 10008d0 <__etext>
	MAST_READ_ADDR = address;
 1000346:	1f0307b7          	lui	a5,0x1f030
 100034a:	cbc8                	sw	a0,20(a5)
	NWORD = rev_num - 1;
 100034c:	15fd                	addi	a1,a1,-1
 100034e:	c3cc                	sw	a1,4(a5)
	MASTER_CPU_CMD = 0x00000017UL;
 1000350:	475d                	li	a4,23
 1000352:	c798                	sw	a4,8(a5)
}
 1000354:	8082                	ret

01000356 <i2c_master_restart_rev2>:

void i2c_master_restart_rev2(unsigned short address, unsigned int rev_num)
{
	rw_flag = 1;
 1000356:	4705                	li	a4,1
 1000358:	00e1a023          	sw	a4,0(gp) # 10008d0 <__etext>
	MAST_READ_ADDR = address;
 100035c:	1f0307b7          	lui	a5,0x1f030
 1000360:	cbc8                	sw	a0,20(a5)
	NWORD = rev_num - 1;
 1000362:	15fd                	addi	a1,a1,-1
 1000364:	c3cc                	sw	a1,4(a5)
	MASTER_CPU_CMD = 0x0000001FUL;
 1000366:	477d                	li	a4,31
 1000368:	c798                	sw	a4,8(a5)
}
 100036a:	8082                	ret

0100036c <delay>:

void delay(unsigned int val)
{
	tm_count = 0;
 100036c:	5c01a423          	sw	zero,1480(gp) # 1000e98 <tm_count>
	while(tm_count < val)
 1000370:	5c81a783          	lw	a5,1480(gp) # 1000e98 <tm_count>
 1000374:	fea7eee3          	bltu	a5,a0,1000370 <delay+0x4>
	{
		//
	}	
}
 1000378:	8082                	ret

0100037a <main>:

int main() 
{	
 100037a:	1151                	addi	sp,sp,-12
 100037c:	c406                	sw	ra,8(sp)
 100037e:	c222                	sw	s0,4(sp)
	unsigned int i = 0;
	i2c_master_init();
 1000380:	3d55                	jal	1000234 <i2c_master_init>
	timer0_init(16000);	
 1000382:	6511                	lui	a0,0x4
 1000384:	e8050513          	addi	a0,a0,-384 # 3e80 <Reset_Handler-0xffc180>
 1000388:	3f35                	jal	10002c4 <timer0_init>
	ii = 0;
 100038a:	0001aa23          	sw	zero,20(gp) # 10008e4 <ii>
	ii2 = 0;
 100038e:	0001a423          	sw	zero,8(gp) # 10008d8 <ii2>
	master_work_flag = 0;
 1000392:	00018793          	mv	a5,gp
 1000396:	00078223          	sb	zero,4(a5) # 1f030004 <__bss_end__+0x1e02f164>
	buffer_pointer = 0;
 100039a:	0001a823          	sw	zero,16(gp) # 10008e0 <buffer_pointer>
	buffer_cycle = 0;
 100039e:	0001ac23          	sw	zero,24(gp) # 10008e8 <buffer_cycle>
	
	buffer_pointer2 = 0;
 10003a2:	0001a623          	sw	zero,12(gp) # 10008dc <buffer_pointer2>
	buffer_cycle2 = 0;
 10003a6:	0001ae23          	sw	zero,28(gp) # 10008ec <buffer_cycle2>
	
	rw_flag = 0;
 10003aa:	0007a023          	sw	zero,0(a5)
  \details Enables IRQ interrupts by setting the IE-bit in the PSR.
           Can only be executed in Privileged modes.
 */
__ALWAYS_STATIC_INLINE void __enable_irq(void)
{
    __ASM volatile("csrs mstatus, 8");
 10003ae:	30046073          	csrsi	mstatus,8
	while(1)
	{
		if (1)
		{
			//transmit
			i2c_master_transmit(128);
 10003b2:	08000513          	li	a0,128
 10003b6:	3f1d                	jal	10002ec <i2c_master_transmit>
			
			while(master_work_flag==0)
 10003b8:	00018793          	mv	a5,gp
 10003bc:	0047c783          	lbu	a5,4(a5)
 10003c0:	dfe5                	beqz	a5,10003b8 <main+0x3e>
			{
				//
			}
			master_work_flag = 0;
 10003c2:	00018793          	mv	a5,gp
 10003c6:	00078223          	sb	zero,4(a5)
			DATA_2_IICM0 = (i2c_master_send_buffer[3] << 24) | (i2c_master_send_buffer[2] << 16) | (i2c_master_send_buffer[1] << 8) | (i2c_master_send_buffer[0]);
 10003ca:	42818693          	addi	a3,gp,1064 # 1000cf8 <i2c_master_send_buffer>
 10003ce:	0036c783          	lbu	a5,3(a3) # 1f030003 <__bss_end__+0x1e02f163>
 10003d2:	07e2                	slli	a5,a5,0x18
 10003d4:	0026c703          	lbu	a4,2(a3)
 10003d8:	0ff77713          	andi	a4,a4,255
 10003dc:	0742                	slli	a4,a4,0x10
 10003de:	8fd9                	or	a5,a5,a4
 10003e0:	0016c703          	lbu	a4,1(a3)
 10003e4:	0ff77713          	andi	a4,a4,255
 10003e8:	0722                	slli	a4,a4,0x8
 10003ea:	8fd9                	or	a5,a5,a4
 10003ec:	4281c703          	lbu	a4,1064(gp) # 1000cf8 <i2c_master_send_buffer>
 10003f0:	0ff77713          	andi	a4,a4,255
 10003f4:	8fd9                	or	a5,a5,a4
 10003f6:	1f030737          	lui	a4,0x1f030
 10003fa:	cf1c                	sw	a5,24(a4)

			delay(5000);
 10003fc:	6505                	lui	a0,0x1
 10003fe:	38850513          	addi	a0,a0,904 # 1388 <Reset_Handler-0xffec78>
 1000402:	37ad                	jal	100036c <delay>
			buffer_cycle = 0;			
 1000404:	0001ac23          	sw	zero,24(gp) # 10008e8 <buffer_cycle>
		}
		
		if (1)
		{
			//rev
			i2c_master_rev(128);
 1000408:	08000513          	li	a0,128
 100040c:	3705                	jal	100032c <i2c_master_rev>
			
			while(master_work_flag==0)
 100040e:	00018793          	mv	a5,gp
 1000412:	0047c783          	lbu	a5,4(a5)
 1000416:	dfe5                	beqz	a5,100040e <main+0x94>
			{
				//
			}
			master_work_flag = 0;
 1000418:	00018793          	mv	a5,gp
 100041c:	00078223          	sb	zero,4(a5)
			i2c_master_rev_buffer[4+(buffer_cycle2-1)*8] = IICM_2_DATA1 & 0x000000ff;
 1000420:	1f030637          	lui	a2,0x1f030
 1000424:	524c                	lw	a1,36(a2)
 1000426:	01c1a783          	lw	a5,28(gp) # 10008ec <buffer_cycle2>
 100042a:	200006b7          	lui	a3,0x20000
 100042e:	16fd                	addi	a3,a3,-1
 1000430:	97b6                	add	a5,a5,a3
 1000432:	078e                	slli	a5,a5,0x3
 1000434:	0791                	addi	a5,a5,4
 1000436:	0ff5f593          	andi	a1,a1,255
 100043a:	4f018713          	addi	a4,gp,1264 # 1000dc0 <i2c_master_rev_buffer>
 100043e:	97ba                	add	a5,a5,a4
 1000440:	00b78023          	sb	a1,0(a5)
			i2c_master_rev_buffer[5+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x0000ff00) >> 8;
 1000444:	524c                	lw	a1,36(a2)
 1000446:	85a1                	srai	a1,a1,0x8
 1000448:	01c1a783          	lw	a5,28(gp) # 10008ec <buffer_cycle2>
 100044c:	97b6                	add	a5,a5,a3
 100044e:	078e                	slli	a5,a5,0x3
 1000450:	0795                	addi	a5,a5,5
 1000452:	0ff5f593          	andi	a1,a1,255
 1000456:	97ba                	add	a5,a5,a4
 1000458:	00b78023          	sb	a1,0(a5)
			i2c_master_rev_buffer[6+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x00ff0000) >> 16;
 100045c:	524c                	lw	a1,36(a2)
 100045e:	85c1                	srai	a1,a1,0x10
 1000460:	01c1a783          	lw	a5,28(gp) # 10008ec <buffer_cycle2>
 1000464:	97b6                	add	a5,a5,a3
 1000466:	078e                	slli	a5,a5,0x3
 1000468:	0799                	addi	a5,a5,6
 100046a:	0ff5f593          	andi	a1,a1,255
 100046e:	97ba                	add	a5,a5,a4
 1000470:	00b78023          	sb	a1,0(a5)
			i2c_master_rev_buffer[7+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0xff000000) >> 24;				
 1000474:	5250                	lw	a2,36(a2)
 1000476:	01c1a783          	lw	a5,28(gp) # 10008ec <buffer_cycle2>
 100047a:	97b6                	add	a5,a5,a3
 100047c:	078e                	slli	a5,a5,0x3
 100047e:	079d                	addi	a5,a5,7
 1000480:	01865693          	srli	a3,a2,0x18
 1000484:	97ba                	add	a5,a5,a4
 1000486:	00d78023          	sb	a3,0(a5)

			delay(5000);
 100048a:	6505                	lui	a0,0x1
 100048c:	38850513          	addi	a0,a0,904 # 1388 <Reset_Handler-0xffec78>
 1000490:	3df1                	jal	100036c <delay>
			buffer_cycle2 = 0;	
 1000492:	0001ae23          	sw	zero,28(gp) # 10008ec <buffer_cycle2>

			for (i=0;i<200;i++)
 1000496:	4701                	li	a4,0
 1000498:	0c700793          	li	a5,199
 100049c:	00e7e963          	bltu	a5,a4,10004ae <main+0x134>
			{
				i2c_master_rev_buffer[i] = 0x00;
 10004a0:	4f018793          	addi	a5,gp,1264 # 1000dc0 <i2c_master_rev_buffer>
 10004a4:	97ba                	add	a5,a5,a4
 10004a6:	00078023          	sb	zero,0(a5)
			for (i=0;i<200;i++)
 10004aa:	0705                	addi	a4,a4,1
 10004ac:	b7f5                	j	1000498 <main+0x11e>
		}
		
		if (1)
		{
			//restart rev mode1
			i2c_master_restart_rev1(0x55, 128);
 10004ae:	08000593          	li	a1,128
 10004b2:	05500513          	li	a0,85
 10004b6:	3569                	jal	1000340 <i2c_master_restart_rev1>
			
			while(master_work_flag==0)
 10004b8:	00018793          	mv	a5,gp
 10004bc:	0047c783          	lbu	a5,4(a5)
 10004c0:	dfe5                	beqz	a5,10004b8 <main+0x13e>
			{
				//
			}
			master_work_flag = 0;
 10004c2:	00018793          	mv	a5,gp
 10004c6:	00078223          	sb	zero,4(a5)
			i2c_master_rev_buffer[4+(buffer_cycle2-1)*8] = IICM_2_DATA1 & 0x000000ff;
 10004ca:	1f030637          	lui	a2,0x1f030
 10004ce:	524c                	lw	a1,36(a2)
 10004d0:	01c1a783          	lw	a5,28(gp) # 10008ec <buffer_cycle2>
 10004d4:	200006b7          	lui	a3,0x20000
 10004d8:	16fd                	addi	a3,a3,-1
 10004da:	97b6                	add	a5,a5,a3
 10004dc:	078e                	slli	a5,a5,0x3
 10004de:	0791                	addi	a5,a5,4
 10004e0:	0ff5f593          	andi	a1,a1,255
 10004e4:	4f018713          	addi	a4,gp,1264 # 1000dc0 <i2c_master_rev_buffer>
 10004e8:	97ba                	add	a5,a5,a4
 10004ea:	00b78023          	sb	a1,0(a5)
			i2c_master_rev_buffer[5+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x0000ff00) >> 8;
 10004ee:	524c                	lw	a1,36(a2)
 10004f0:	85a1                	srai	a1,a1,0x8
 10004f2:	01c1a783          	lw	a5,28(gp) # 10008ec <buffer_cycle2>
 10004f6:	97b6                	add	a5,a5,a3
 10004f8:	078e                	slli	a5,a5,0x3
 10004fa:	0795                	addi	a5,a5,5
 10004fc:	0ff5f593          	andi	a1,a1,255
 1000500:	97ba                	add	a5,a5,a4
 1000502:	00b78023          	sb	a1,0(a5)
			i2c_master_rev_buffer[6+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x00ff0000) >> 16;
 1000506:	524c                	lw	a1,36(a2)
 1000508:	85c1                	srai	a1,a1,0x10
 100050a:	01c1a783          	lw	a5,28(gp) # 10008ec <buffer_cycle2>
 100050e:	97b6                	add	a5,a5,a3
 1000510:	078e                	slli	a5,a5,0x3
 1000512:	0799                	addi	a5,a5,6
 1000514:	0ff5f593          	andi	a1,a1,255
 1000518:	97ba                	add	a5,a5,a4
 100051a:	00b78023          	sb	a1,0(a5)
			i2c_master_rev_buffer[7+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0xff000000) >> 24;				
 100051e:	5250                	lw	a2,36(a2)
 1000520:	01c1a783          	lw	a5,28(gp) # 10008ec <buffer_cycle2>
 1000524:	97b6                	add	a5,a5,a3
 1000526:	078e                	slli	a5,a5,0x3
 1000528:	079d                	addi	a5,a5,7
 100052a:	01865693          	srli	a3,a2,0x18
 100052e:	97ba                	add	a5,a5,a4
 1000530:	00d78023          	sb	a3,0(a5)
		
			delay(5000);	
 1000534:	6505                	lui	a0,0x1
 1000536:	38850513          	addi	a0,a0,904 # 1388 <Reset_Handler-0xffec78>
 100053a:	3d0d                	jal	100036c <delay>
			buffer_cycle2 = 0;	
 100053c:	0001ae23          	sw	zero,28(gp) # 10008ec <buffer_cycle2>
			
			for (i=0;i<200;i++)
 1000540:	4701                	li	a4,0
 1000542:	0c700793          	li	a5,199
 1000546:	00e7e963          	bltu	a5,a4,1000558 <main+0x1de>
			{
				i2c_master_rev_buffer[i] = 0x00;
 100054a:	4f018793          	addi	a5,gp,1264 # 1000dc0 <i2c_master_rev_buffer>
 100054e:	97ba                	add	a5,a5,a4
 1000550:	00078023          	sb	zero,0(a5)
			for (i=0;i<200;i++)
 1000554:	0705                	addi	a4,a4,1
 1000556:	b7f5                	j	1000542 <main+0x1c8>
		}
		
		if (1)
		{
			//restart rev mode2
			i2c_master_restart_rev2(0x5872, 128);
 1000558:	08000593          	li	a1,128
 100055c:	6519                	lui	a0,0x6
 100055e:	87250513          	addi	a0,a0,-1934 # 5872 <Reset_Handler-0xffa78e>
 1000562:	3bd5                	jal	1000356 <i2c_master_restart_rev2>
			
			while(master_work_flag==0)
 1000564:	00018793          	mv	a5,gp
 1000568:	0047c783          	lbu	a5,4(a5)
 100056c:	dfe5                	beqz	a5,1000564 <main+0x1ea>
			{
				//
			}
			master_work_flag = 0;
 100056e:	00018793          	mv	a5,gp
 1000572:	00078223          	sb	zero,4(a5)
			i2c_master_rev_buffer[4+(buffer_cycle2-1)*8] = IICM_2_DATA1 & 0x000000ff;
 1000576:	1f030637          	lui	a2,0x1f030
 100057a:	524c                	lw	a1,36(a2)
 100057c:	01c1a783          	lw	a5,28(gp) # 10008ec <buffer_cycle2>
 1000580:	200006b7          	lui	a3,0x20000
 1000584:	16fd                	addi	a3,a3,-1
 1000586:	97b6                	add	a5,a5,a3
 1000588:	078e                	slli	a5,a5,0x3
 100058a:	0791                	addi	a5,a5,4
 100058c:	0ff5f593          	andi	a1,a1,255
 1000590:	4f018713          	addi	a4,gp,1264 # 1000dc0 <i2c_master_rev_buffer>
 1000594:	97ba                	add	a5,a5,a4
 1000596:	00b78023          	sb	a1,0(a5)
			i2c_master_rev_buffer[5+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x0000ff00) >> 8;
 100059a:	524c                	lw	a1,36(a2)
 100059c:	85a1                	srai	a1,a1,0x8
 100059e:	01c1a783          	lw	a5,28(gp) # 10008ec <buffer_cycle2>
 10005a2:	97b6                	add	a5,a5,a3
 10005a4:	078e                	slli	a5,a5,0x3
 10005a6:	0795                	addi	a5,a5,5
 10005a8:	0ff5f593          	andi	a1,a1,255
 10005ac:	97ba                	add	a5,a5,a4
 10005ae:	00b78023          	sb	a1,0(a5)
			i2c_master_rev_buffer[6+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x00ff0000) >> 16;
 10005b2:	524c                	lw	a1,36(a2)
 10005b4:	85c1                	srai	a1,a1,0x10
 10005b6:	01c1a783          	lw	a5,28(gp) # 10008ec <buffer_cycle2>
 10005ba:	97b6                	add	a5,a5,a3
 10005bc:	078e                	slli	a5,a5,0x3
 10005be:	0799                	addi	a5,a5,6
 10005c0:	0ff5f593          	andi	a1,a1,255
 10005c4:	97ba                	add	a5,a5,a4
 10005c6:	00b78023          	sb	a1,0(a5)
			i2c_master_rev_buffer[7+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0xff000000) >> 24;				
 10005ca:	5250                	lw	a2,36(a2)
 10005cc:	01c1a783          	lw	a5,28(gp) # 10008ec <buffer_cycle2>
 10005d0:	97b6                	add	a5,a5,a3
 10005d2:	078e                	slli	a5,a5,0x3
 10005d4:	079d                	addi	a5,a5,7
 10005d6:	01865693          	srli	a3,a2,0x18
 10005da:	97ba                	add	a5,a5,a4
 10005dc:	00d78023          	sb	a3,0(a5)
		
			delay(5000);	
 10005e0:	6505                	lui	a0,0x1
 10005e2:	38850513          	addi	a0,a0,904 # 1388 <Reset_Handler-0xffec78>
 10005e6:	3359                	jal	100036c <delay>
			buffer_cycle2 = 0;	
 10005e8:	0001ae23          	sw	zero,28(gp) # 10008ec <buffer_cycle2>
			
			for (i=0;i<200;i++)
 10005ec:	4701                	li	a4,0
 10005ee:	0c700793          	li	a5,199
 10005f2:	dce7e0e3          	bltu	a5,a4,10003b2 <main+0x38>
			{
				i2c_master_rev_buffer[i] = 0x00;
 10005f6:	4f018793          	addi	a5,gp,1264 # 1000dc0 <i2c_master_rev_buffer>
 10005fa:	97ba                	add	a5,a5,a4
 10005fc:	00078023          	sb	zero,0(a5)
			for (i=0;i<200;i++)
 1000600:	0705                	addi	a4,a4,1
 1000602:	b7f5                	j	10005ee <main+0x274>

01000604 <handle_irq>:
extern volatile unsigned int rw_flag;

void handle_irq(uint32_t vec) 
{	
	
	if (I2C_MASTER_IRQn == vec)
 1000604:	47d9                	li	a5,22
 1000606:	00f50663          	beq	a0,a5,1000612 <handle_irq+0xe>
		{
			MAST_CLEAR |= 0x00000001;
		}
	}
	
	if (TIM0_IRQn == vec)
 100060a:	47e9                	li	a5,26
 100060c:	2af50263          	beq	a0,a5,10008b0 <handle_irq+0x2ac>
	{
		tm_count++;
		TIMER_CR |= 0x00000100;
	}
}
 1000610:	8082                	ret
		ii2++;
 1000612:	00818793          	addi	a5,gp,8 # 10008d8 <ii2>
 1000616:	4398                	lw	a4,0(a5)
 1000618:	0705                	addi	a4,a4,1
 100061a:	c398                	sw	a4,0(a5)
		if (0x00000010 & MAST_STATUS) // byte done
 100061c:	1f0307b7          	lui	a5,0x1f030
 1000620:	579c                	lw	a5,40(a5)
 1000622:	8bc1                	andi	a5,a5,16
 1000624:	cbd1                	beqz	a5,10006b8 <handle_irq+0xb4>
			MAST_CLEAR |= 0x00000008;
 1000626:	1f030737          	lui	a4,0x1f030
 100062a:	5b1c                	lw	a5,48(a4)
 100062c:	0087e793          	ori	a5,a5,8
 1000630:	db1c                	sw	a5,48(a4)
			if (rw_flag)
 1000632:	0001a783          	lw	a5,0(gp) # 10008d0 <__etext>
 1000636:	cbe1                	beqz	a5,1000706 <handle_irq+0x102>
				buffer_pointer2 = (0x0000ff00 & MAST_STATUS) >> 8;
 1000638:	1f0307b7          	lui	a5,0x1f030
 100063c:	579c                	lw	a5,40(a5)
 100063e:	87a1                	srai	a5,a5,0x8
 1000640:	0ff7f793          	andi	a5,a5,255
 1000644:	00818713          	addi	a4,gp,8 # 10008d8 <ii2>
 1000648:	c35c                	sw	a5,4(a4)
				buffer_pointer = 0;
 100064a:	00072423          	sw	zero,8(a4) # 1f030008 <__bss_end__+0x1e02f168>
			i2c_master_sended_buffer[ii] = (0x0000ff00 & MAST_STATUS) >> 8;
 100064e:	1f0307b7          	lui	a5,0x1f030
 1000652:	5798                	lw	a4,40(a5)
 1000654:	8721                	srai	a4,a4,0x8
 1000656:	00818793          	addi	a5,gp,8 # 10008d8 <ii2>
 100065a:	47d4                	lw	a3,12(a5)
 100065c:	0ff77713          	andi	a4,a4,255
 1000660:	5b818613          	addi	a2,gp,1464 # 1000e88 <i2c_master_sended_buffer>
 1000664:	96b2                	add	a3,a3,a2
 1000666:	00e68023          	sb	a4,0(a3) # 20000000 <__bss_end__+0x1efff160>
			ii++;
 100066a:	47d8                	lw	a4,12(a5)
 100066c:	0705                	addi	a4,a4,1
 100066e:	c7d8                	sw	a4,12(a5)
			if (16 <= ii)
 1000670:	47d8                	lw	a4,12(a5)
 1000672:	47bd                	li	a5,15
 1000674:	00e7f663          	bgeu	a5,a4,1000680 <handle_irq+0x7c>
				ii = 0;
 1000678:	00818793          	addi	a5,gp,8 # 10008d8 <ii2>
 100067c:	0007a623          	sw	zero,12(a5) # 1f03000c <__bss_end__+0x1e02f16c>
			if (buffer_pointer % 8 == 1)
 1000680:	00818793          	addi	a5,gp,8 # 10008d8 <ii2>
 1000684:	479c                	lw	a5,8(a5)
 1000686:	8b9d                	andi	a5,a5,7
 1000688:	4705                	li	a4,1
 100068a:	08e78a63          	beq	a5,a4,100071e <handle_irq+0x11a>
			else if (buffer_pointer % 8 == 4)
 100068e:	00818793          	addi	a5,gp,8 # 10008d8 <ii2>
 1000692:	479c                	lw	a5,8(a5)
 1000694:	8b9d                	andi	a5,a5,7
 1000696:	4711                	li	a4,4
 1000698:	0ee78263          	beq	a5,a4,100077c <handle_irq+0x178>
			if (buffer_pointer2 % 8 == 1)
 100069c:	00818793          	addi	a5,gp,8 # 10008d8 <ii2>
 10006a0:	43dc                	lw	a5,4(a5)
 10006a2:	8b9d                	andi	a5,a5,7
 10006a4:	4705                	li	a4,1
 10006a6:	12e78663          	beq	a5,a4,10007d2 <handle_irq+0x1ce>
			else if (buffer_pointer2 % 8 == 5)
 10006aa:	00818793          	addi	a5,gp,8 # 10008d8 <ii2>
 10006ae:	43dc                	lw	a5,4(a5)
 10006b0:	8b9d                	andi	a5,a5,7
 10006b2:	4715                	li	a4,5
 10006b4:	18e78d63          	beq	a5,a4,100084e <handle_irq+0x24a>
		if (0x00000008 & MAST_STATUS)//idle
 10006b8:	1f0307b7          	lui	a5,0x1f030
 10006bc:	5798                	lw	a4,40(a5)
		if (0x00000004 & MAST_STATUS)//timeout
 10006be:	579c                	lw	a5,40(a5)
 10006c0:	8b91                	andi	a5,a5,4
 10006c2:	c799                	beqz	a5,10006d0 <handle_irq+0xcc>
			MAST_CLEAR |= 0x00000004;
 10006c4:	1f030737          	lui	a4,0x1f030
 10006c8:	5b1c                	lw	a5,48(a4)
 10006ca:	0047e793          	ori	a5,a5,4
 10006ce:	db1c                	sw	a5,48(a4)
		if (0x00000002 & MAST_STATUS)//after stop
 10006d0:	1f0307b7          	lui	a5,0x1f030
 10006d4:	579c                	lw	a5,40(a5)
 10006d6:	8b89                	andi	a5,a5,2
 10006d8:	cb91                	beqz	a5,10006ec <handle_irq+0xe8>
			MAST_CLEAR |= 0x00000002;
 10006da:	1f030737          	lui	a4,0x1f030
 10006de:	5b1c                	lw	a5,48(a4)
 10006e0:	0027e793          	ori	a5,a5,2
 10006e4:	db1c                	sw	a5,48(a4)
			master_work_flag = 1;
 10006e6:	4705                	li	a4,1
 10006e8:	00e18223          	sb	a4,4(gp) # 10008d4 <master_work_flag>
		if (0x00000001 & MAST_STATUS)//no ack
 10006ec:	1f0307b7          	lui	a5,0x1f030
 10006f0:	579c                	lw	a5,40(a5)
 10006f2:	8b85                	andi	a5,a5,1
 10006f4:	f0078be3          	beqz	a5,100060a <handle_irq+0x6>
			MAST_CLEAR |= 0x00000001;
 10006f8:	1f030737          	lui	a4,0x1f030
 10006fc:	5b1c                	lw	a5,48(a4)
 10006fe:	0017e793          	ori	a5,a5,1
 1000702:	db1c                	sw	a5,48(a4)
 1000704:	b719                	j	100060a <handle_irq+0x6>
				buffer_pointer = (0x0000ff00 & MAST_STATUS) >> 8;
 1000706:	1f0307b7          	lui	a5,0x1f030
 100070a:	579c                	lw	a5,40(a5)
 100070c:	87a1                	srai	a5,a5,0x8
 100070e:	0ff7f793          	andi	a5,a5,255
 1000712:	00818713          	addi	a4,gp,8 # 10008d8 <ii2>
 1000716:	c71c                	sw	a5,8(a4)
				buffer_pointer2 = 0;
 1000718:	00072223          	sw	zero,4(a4) # 1f030004 <__bss_end__+0x1e02f164>
 100071c:	bf0d                	j	100064e <handle_irq+0x4a>
				DATA_2_IICM1 = (i2c_master_send_buffer[7+buffer_cycle*8] << 24) | (i2c_master_send_buffer[6+buffer_cycle*8] << 16) | (i2c_master_send_buffer[5+buffer_cycle*8] << 8) | (i2c_master_send_buffer[4+buffer_cycle*8]);				
 100071e:	00818713          	addi	a4,gp,8 # 10008d8 <ii2>
 1000722:	4b1c                	lw	a5,16(a4)
 1000724:	078e                	slli	a5,a5,0x3
 1000726:	079d                	addi	a5,a5,7
 1000728:	42818593          	addi	a1,gp,1064 # 1000cf8 <i2c_master_send_buffer>
 100072c:	97ae                	add	a5,a5,a1
 100072e:	0007c783          	lbu	a5,0(a5) # 1f030000 <__bss_end__+0x1e02f160>
 1000732:	07e2                	slli	a5,a5,0x18
 1000734:	4b14                	lw	a3,16(a4)
 1000736:	068e                	slli	a3,a3,0x3
 1000738:	0699                	addi	a3,a3,6
 100073a:	96ae                	add	a3,a3,a1
 100073c:	0006c683          	lbu	a3,0(a3)
 1000740:	0ff6f693          	andi	a3,a3,255
 1000744:	06c2                	slli	a3,a3,0x10
 1000746:	8fd5                	or	a5,a5,a3
 1000748:	4b10                	lw	a2,16(a4)
 100074a:	060e                	slli	a2,a2,0x3
 100074c:	0615                	addi	a2,a2,5
 100074e:	962e                	add	a2,a2,a1
 1000750:	00064683          	lbu	a3,0(a2) # 1f030000 <__bss_end__+0x1e02f160>
 1000754:	0ff6f693          	andi	a3,a3,255
 1000758:	06a2                	slli	a3,a3,0x8
 100075a:	8fd5                	or	a5,a5,a3
 100075c:	4b14                	lw	a3,16(a4)
 100075e:	068e                	slli	a3,a3,0x3
 1000760:	0691                	addi	a3,a3,4
 1000762:	96ae                	add	a3,a3,a1
 1000764:	0006c683          	lbu	a3,0(a3)
 1000768:	0ff6f693          	andi	a3,a3,255
 100076c:	8fd5                	or	a5,a5,a3
 100076e:	1f0306b7          	lui	a3,0x1f030
 1000772:	cedc                	sw	a5,28(a3)
				buffer_cycle++;
 1000774:	4b1c                	lw	a5,16(a4)
 1000776:	0785                	addi	a5,a5,1
 1000778:	cb1c                	sw	a5,16(a4)
 100077a:	b70d                	j	100069c <handle_irq+0x98>
				DATA_2_IICM0 = (i2c_master_send_buffer[3+buffer_cycle*8] << 24) | (i2c_master_send_buffer[2+buffer_cycle*8] << 16) | (i2c_master_send_buffer[1+buffer_cycle*8] << 8) | (i2c_master_send_buffer[0+buffer_cycle*8]);
 100077c:	00818613          	addi	a2,gp,8 # 10008d8 <ii2>
 1000780:	4a1c                	lw	a5,16(a2)
 1000782:	078e                	slli	a5,a5,0x3
 1000784:	078d                	addi	a5,a5,3
 1000786:	42818693          	addi	a3,gp,1064 # 1000cf8 <i2c_master_send_buffer>
 100078a:	97b6                	add	a5,a5,a3
 100078c:	0007c783          	lbu	a5,0(a5)
 1000790:	07e2                	slli	a5,a5,0x18
 1000792:	4a18                	lw	a4,16(a2)
 1000794:	070e                	slli	a4,a4,0x3
 1000796:	0709                	addi	a4,a4,2
 1000798:	9736                	add	a4,a4,a3
 100079a:	00074703          	lbu	a4,0(a4)
 100079e:	0ff77713          	andi	a4,a4,255
 10007a2:	0742                	slli	a4,a4,0x10
 10007a4:	8fd9                	or	a5,a5,a4
 10007a6:	4a18                	lw	a4,16(a2)
 10007a8:	070e                	slli	a4,a4,0x3
 10007aa:	0705                	addi	a4,a4,1
 10007ac:	9736                	add	a4,a4,a3
 10007ae:	00074703          	lbu	a4,0(a4)
 10007b2:	0ff77713          	andi	a4,a4,255
 10007b6:	0722                	slli	a4,a4,0x8
 10007b8:	8fd9                	or	a5,a5,a4
 10007ba:	4a18                	lw	a4,16(a2)
 10007bc:	070e                	slli	a4,a4,0x3
 10007be:	96ba                	add	a3,a3,a4
 10007c0:	0006c703          	lbu	a4,0(a3) # 1f030000 <__bss_end__+0x1e02f160>
 10007c4:	0ff77713          	andi	a4,a4,255
 10007c8:	8fd9                	or	a5,a5,a4
 10007ca:	1f030737          	lui	a4,0x1f030
 10007ce:	cf1c                	sw	a5,24(a4)
 10007d0:	b5f1                	j	100069c <handle_irq+0x98>
				if (buffer_cycle2 != 0)
 10007d2:	00818793          	addi	a5,gp,8 # 10008d8 <ii2>
 10007d6:	4bdc                	lw	a5,20(a5)
 10007d8:	ee0780e3          	beqz	a5,10006b8 <handle_irq+0xb4>
					i2c_master_rev_buffer[4+(buffer_cycle2-1)*8] = IICM_2_DATA1 & 0x000000ff;
 10007dc:	1f030337          	lui	t1,0x1f030
 10007e0:	02432283          	lw	t0,36(t1) # 1f030024 <__bss_end__+0x1e02f184>
 10007e4:	00818593          	addi	a1,gp,8 # 10008d8 <ii2>
 10007e8:	49dc                	lw	a5,20(a1)
 10007ea:	20000637          	lui	a2,0x20000
 10007ee:	167d                	addi	a2,a2,-1
 10007f0:	97b2                	add	a5,a5,a2
 10007f2:	078e                	slli	a5,a5,0x3
 10007f4:	00478713          	addi	a4,a5,4
 10007f8:	0ff2f293          	andi	t0,t0,255
 10007fc:	4f018693          	addi	a3,gp,1264 # 1000dc0 <i2c_master_rev_buffer>
 1000800:	00d707b3          	add	a5,a4,a3
 1000804:	00578023          	sb	t0,0(a5)
					i2c_master_rev_buffer[5+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x0000ff00) >> 8;
 1000808:	02432783          	lw	a5,36(t1)
 100080c:	87a1                	srai	a5,a5,0x8
 100080e:	49d8                	lw	a4,20(a1)
 1000810:	9732                	add	a4,a4,a2
 1000812:	070e                	slli	a4,a4,0x3
 1000814:	0715                	addi	a4,a4,5
 1000816:	0ff7f793          	andi	a5,a5,255
 100081a:	9736                	add	a4,a4,a3
 100081c:	00f70023          	sb	a5,0(a4) # 1f030000 <__bss_end__+0x1e02f160>
					i2c_master_rev_buffer[6+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x00ff0000) >> 16;
 1000820:	02432783          	lw	a5,36(t1)
 1000824:	87c1                	srai	a5,a5,0x10
 1000826:	49d8                	lw	a4,20(a1)
 1000828:	9732                	add	a4,a4,a2
 100082a:	070e                	slli	a4,a4,0x3
 100082c:	0719                	addi	a4,a4,6
 100082e:	0ff7f793          	andi	a5,a5,255
 1000832:	9736                	add	a4,a4,a3
 1000834:	00f70023          	sb	a5,0(a4)
					i2c_master_rev_buffer[7+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0xff000000) >> 24;					
 1000838:	02432703          	lw	a4,36(t1)
 100083c:	49dc                	lw	a5,20(a1)
 100083e:	97b2                	add	a5,a5,a2
 1000840:	078e                	slli	a5,a5,0x3
 1000842:	079d                	addi	a5,a5,7
 1000844:	8361                	srli	a4,a4,0x18
 1000846:	97b6                	add	a5,a5,a3
 1000848:	00e78023          	sb	a4,0(a5)
 100084c:	b5b5                	j	10006b8 <handle_irq+0xb4>
				i2c_master_rev_buffer[0+buffer_cycle2*8] = IICM_2_DATA0 & 0x000000ff;
 100084e:	1f0305b7          	lui	a1,0x1f030
 1000852:	0205a303          	lw	t1,32(a1) # 1f030020 <__bss_end__+0x1e02f180>
 1000856:	00818793          	addi	a5,gp,8 # 10008d8 <ii2>
 100085a:	4bd8                	lw	a4,20(a5)
 100085c:	00371693          	slli	a3,a4,0x3
 1000860:	0ff37313          	andi	t1,t1,255
 1000864:	4f018613          	addi	a2,gp,1264 # 1000dc0 <i2c_master_rev_buffer>
 1000868:	00c68733          	add	a4,a3,a2
 100086c:	00670023          	sb	t1,0(a4)
				i2c_master_rev_buffer[1+buffer_cycle2*8] = (IICM_2_DATA0 & 0x0000ff00) >> 8;
 1000870:	5198                	lw	a4,32(a1)
 1000872:	8721                	srai	a4,a4,0x8
 1000874:	4bd4                	lw	a3,20(a5)
 1000876:	068e                	slli	a3,a3,0x3
 1000878:	0685                	addi	a3,a3,1
 100087a:	0ff77713          	andi	a4,a4,255
 100087e:	96b2                	add	a3,a3,a2
 1000880:	00e68023          	sb	a4,0(a3)
				i2c_master_rev_buffer[2+buffer_cycle2*8] = (IICM_2_DATA0 & 0x00ff0000) >> 16;
 1000884:	5198                	lw	a4,32(a1)
 1000886:	8741                	srai	a4,a4,0x10
 1000888:	4bd4                	lw	a3,20(a5)
 100088a:	068e                	slli	a3,a3,0x3
 100088c:	0689                	addi	a3,a3,2
 100088e:	0ff77713          	andi	a4,a4,255
 1000892:	96b2                	add	a3,a3,a2
 1000894:	00e68023          	sb	a4,0(a3)
				i2c_master_rev_buffer[3+buffer_cycle2*8] = (IICM_2_DATA0 & 0xff000000) >> 24;
 1000898:	5194                	lw	a3,32(a1)
 100089a:	4bd8                	lw	a4,20(a5)
 100089c:	070e                	slli	a4,a4,0x3
 100089e:	070d                	addi	a4,a4,3
 10008a0:	82e1                	srli	a3,a3,0x18
 10008a2:	9732                	add	a4,a4,a2
 10008a4:	00d70023          	sb	a3,0(a4)
				buffer_cycle2++;
 10008a8:	4bd8                	lw	a4,20(a5)
 10008aa:	0705                	addi	a4,a4,1
 10008ac:	cbd8                	sw	a4,20(a5)
 10008ae:	b529                	j	10006b8 <handle_irq+0xb4>
		tm_count++;
 10008b0:	5c81a783          	lw	a5,1480(gp) # 1000e98 <tm_count>
 10008b4:	0785                	addi	a5,a5,1
 10008b6:	5cf1a423          	sw	a5,1480(gp) # 1000e98 <tm_count>
		TIMER_CR |= 0x00000100;
 10008ba:	1f020737          	lui	a4,0x1f020
 10008be:	431c                	lw	a5,0(a4)
 10008c0:	1007e793          	ori	a5,a5,256
 10008c4:	c31c                	sw	a5,0(a4)
}
 10008c6:	b3a9                	j	1000610 <handle_irq+0xc>
	...
