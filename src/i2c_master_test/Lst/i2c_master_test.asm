
.//Obj/i2c_master_test.elf:     file format elf32-littleriscv


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
 100000c:	45818193          	addi	gp,gp,1112 # 1000460 <__etext>
.option pop

    la      a0, Default_Handler
 1000010:	00000517          	auipc	a0,0x0
 1000014:	1b050513          	addi	a0,a0,432 # 10001c0 <Default_Handler>
    ori     a0, a0, 3
 1000018:	00356513          	ori	a0,a0,3
    csrw    mtvec, a0
 100001c:	30551073          	csrw	mtvec,a0

    la      a0, __Vectors
 1000020:	be018513          	addi	a0,gp,-1056 # 1000040 <__Vectors>
    csrw    mtvt, a0
 1000024:	30751073          	csrw	mtvt,a0

    la      sp, __initial_sp
 1000028:	20818113          	addi	sp,gp,520 # 1000668 <__initial_sp>
    csrw    mscratch, sp
 100002c:	34011073          	csrw	mscratch,sp

    jal     main
 1000030:	33c000ef          	jal	ra,100036c <main>

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
 100012e:	26a000ef          	jal	ra,1000398 <handle_irq>

    csrc    mstatus, 8
 1000132:	30047073          	csrci	mstatus,8

    lw      a1, 40(sp)
 1000136:	55a2                	lw	a1,40(sp)
    andi    a0, a1, 0x3FF
 1000138:	3ff5f513          	andi	a0,a1,1023

    /* clear pending */
    li      a2, 0xE000E100
 100013c:	e000e637          	lui	a2,0xe000e
 1000140:	10060613          	addi	a2,a2,256 # e000e100 <__bss_end__+0xdf00d6e0>
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
 10001ce:	40818293          	addi	t0,gp,1032 # 1000868 <g_trap_sp>
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
	
	//MAST_CLK = 0x00000020UL;		//I2C CLK: 16000000/32/8 = 62.5K  pass!
	MAST_CLK = 0x00000010UL;		//I2C CLK: 16000000/16/8 = 125K  pass!
 100023c:	4741                	li	a4,16
 100023e:	dbd8                	sw	a4,52(a5)
	//MAST_CLK = 0x00000008UL;		//I2C CLK: 16000000/8/8 = 250K  not ok!
	
	MAST_EN = 0x00000001UL;			//enable master clock
 1000240:	4705                	li	a4,1
 1000242:	df98                	sw	a4,56(a5)
	
	//MAST_MISC = 0x00000002UL;		//enable last ack
	
	MAST_INT_EN |= 0x0000000f;//enable int source
 1000244:	57d8                	lw	a4,44(a5)
 1000246:	00f76713          	ori	a4,a4,15
 100024a:	d7d8                	sw	a4,44(a5)
  \details Enable a device-specific interrupt in the VIC interrupt controller.
  \param [in]      IRQn  External interrupt number. Value cannot be negative.
 */
__STATIC_INLINE void csi_vic_enable_irq(int32_t IRQn)
{
    CLIC->CLICINT[IRQn].IE |= CLIC_INTIE_IE_Msk;
 100024c:	e0801737          	lui	a4,0xe0801
 1000250:	05974783          	lbu	a5,89(a4) # e0801059 <__bss_end__+0xdf800639>
 1000254:	0ff7f793          	andi	a5,a5,255
 1000258:	0017e793          	ori	a5,a5,1
 100025c:	04f70ca3          	sb	a5,89(a4)
	//MAST_INT_EN |= 0x00000008;//enable int source	
	
	csi_vic_enable_irq(I2C_MASTER_IRQn);
	
	i2c_master_send_buffer[0] = 0x12;
 1000260:	4749                	li	a4,18
 1000262:	40e18823          	sb	a4,1040(gp) # 1000870 <i2c_master_send_buffer>
	i2c_master_send_buffer[1] = 0x55;
 1000266:	41018793          	addi	a5,gp,1040 # 1000870 <i2c_master_send_buffer>
 100026a:	05500713          	li	a4,85
 100026e:	00e780a3          	sb	a4,1(a5) # 1f030001 <__bss_end__+0x1e02f5e1>
	i2c_master_send_buffer[2] = 0xAA;
 1000272:	faa00713          	li	a4,-86
 1000276:	00e78123          	sb	a4,2(a5)
	i2c_master_send_buffer[3] = 0xEB;
 100027a:	572d                	li	a4,-21
 100027c:	00e781a3          	sb	a4,3(a5)
	i2c_master_send_buffer[4] = 0x90;
 1000280:	f9000713          	li	a4,-112
 1000284:	00e78223          	sb	a4,4(a5)
	i2c_master_send_buffer[5] = 0x99;
 1000288:	f9900713          	li	a4,-103
 100028c:	00e782a3          	sb	a4,5(a5)
	i2c_master_send_buffer[6] = 0x2A;
 1000290:	02a00713          	li	a4,42
 1000294:	00e78323          	sb	a4,6(a5)
	i2c_master_send_buffer[7] = 0xBE;
 1000298:	fbe00713          	li	a4,-66
 100029c:	00e783a3          	sb	a4,7(a5)
	
	for (i = 8;i<200;i++)
 10002a0:	4721                	li	a4,8
 10002a2:	0c700793          	li	a5,199
 10002a6:	00e7e963          	bltu	a5,a4,10002b8 <i2c_master_init+0x84>
	{
		i2c_master_send_buffer[i] = i;
 10002aa:	41018793          	addi	a5,gp,1040 # 1000870 <i2c_master_send_buffer>
 10002ae:	97ba                	add	a5,a5,a4
 10002b0:	00e78023          	sb	a4,0(a5)
	for (i = 8;i<200;i++)
 10002b4:	0705                	addi	a4,a4,1
 10002b6:	b7f5                	j	10002a2 <i2c_master_init+0x6e>
	}
}
 10002b8:	8082                	ret

010002ba <timer0_init>:

void timer0_init(unsigned int init_val)
{
	tm_count = 0;
 10002ba:	5a01a823          	sw	zero,1456(gp) # 1000a10 <tm_count>
	TIMER0_REG = init_val;	//load the initial value
 10002be:	1f0207b7          	lui	a5,0x1f020
 10002c2:	c788                	sw	a0,8(a5)
	TIMER_CR |= 0x00000010;//enable timer0
 10002c4:	4398                	lw	a4,0(a5)
 10002c6:	01076713          	ori	a4,a4,16
 10002ca:	c398                	sw	a4,0(a5)
 10002cc:	e0801737          	lui	a4,0xe0801
 10002d0:	06974783          	lbu	a5,105(a4) # e0801069 <__bss_end__+0xdf800649>
 10002d4:	0ff7f793          	andi	a5,a5,255
 10002d8:	0017e793          	ori	a5,a5,1
 10002dc:	06f704a3          	sb	a5,105(a4)
	
	csi_vic_enable_irq(TIM0_IRQn);
}
 10002e0:	8082                	ret

010002e2 <i2c_master_transmit>:

void i2c_master_transmit()
{
	//WORD = 0x00000009UL;	//send 10 bytes
	NWORD = 0x00000007UL;	//send 8 bytes
 10002e2:	1f030737          	lui	a4,0x1f030
 10002e6:	479d                	li	a5,7
 10002e8:	c35c                	sw	a5,4(a4)
	DATA_2_IICM0 = (i2c_master_send_buffer[3] << 24) | (i2c_master_send_buffer[2] << 16) | (i2c_master_send_buffer[1] << 8) | (i2c_master_send_buffer[0]);
 10002ea:	41018693          	addi	a3,gp,1040 # 1000870 <i2c_master_send_buffer>
 10002ee:	0036c783          	lbu	a5,3(a3)
 10002f2:	07e2                	slli	a5,a5,0x18
 10002f4:	0026c603          	lbu	a2,2(a3)
 10002f8:	0642                	slli	a2,a2,0x10
 10002fa:	8fd1                	or	a5,a5,a2
 10002fc:	0016c603          	lbu	a2,1(a3)
 1000300:	0622                	slli	a2,a2,0x8
 1000302:	8fd1                	or	a5,a5,a2
 1000304:	4101c603          	lbu	a2,1040(gp) # 1000870 <i2c_master_send_buffer>
 1000308:	8fd1                	or	a5,a5,a2
 100030a:	cf1c                	sw	a5,24(a4)
	DATA_2_IICM1 = (i2c_master_send_buffer[7] << 24) | (i2c_master_send_buffer[6] << 16) | (i2c_master_send_buffer[5] << 8) | (i2c_master_send_buffer[4]);
 100030c:	0076c783          	lbu	a5,7(a3)
 1000310:	07e2                	slli	a5,a5,0x18
 1000312:	0066c603          	lbu	a2,6(a3)
 1000316:	0642                	slli	a2,a2,0x10
 1000318:	8fd1                	or	a5,a5,a2
 100031a:	0056c603          	lbu	a2,5(a3)
 100031e:	0622                	slli	a2,a2,0x8
 1000320:	8fd1                	or	a5,a5,a2
 1000322:	0046c683          	lbu	a3,4(a3)
 1000326:	8fd5                	or	a5,a5,a3
 1000328:	cf5c                	sw	a5,28(a4)
	MASTER_CPU_CMD = 0x00000011UL;
 100032a:	47c5                	li	a5,17
 100032c:	c71c                	sw	a5,8(a4)
}
 100032e:	8082                	ret

01000330 <i2c_master_rev>:

void i2c_master_rev()
{
	//NWORD = 0x00000009UL;	//rev 10 bytes
	NWORD = 0x00000007UL;	//send 8 bytes
 1000330:	1f0307b7          	lui	a5,0x1f030
 1000334:	471d                	li	a4,7
 1000336:	c3d8                	sw	a4,4(a5)
	MASTER_CPU_CMD = 0x00000012UL;
 1000338:	4749                	li	a4,18
 100033a:	c798                	sw	a4,8(a5)
}
 100033c:	8082                	ret

0100033e <i2c_master_restart_rev1>:

void i2c_master_restart_rev1(unsigned char address)
{
	MAST_READ_ADDR = address;
 100033e:	1f0307b7          	lui	a5,0x1f030
 1000342:	cbc8                	sw	a0,20(a5)
	//NWORD = 0x00000009UL;	//rev 10 bytes
	NWORD = 0x00000007UL;	//send 8 bytes
 1000344:	471d                	li	a4,7
 1000346:	c3d8                	sw	a4,4(a5)
	MASTER_CPU_CMD = 0x00000017UL;
 1000348:	475d                	li	a4,23
 100034a:	c798                	sw	a4,8(a5)
}
 100034c:	8082                	ret

0100034e <i2c_master_restart_rev2>:

void i2c_master_restart_rev2(unsigned short address)
{
	MAST_READ_ADDR = address;
 100034e:	1f0307b7          	lui	a5,0x1f030
 1000352:	cbc8                	sw	a0,20(a5)
	//NWORD = 0x00000009UL;	//rev 10 bytes
	NWORD = 0x00000007UL;	//send 8 bytes
 1000354:	471d                	li	a4,7
 1000356:	c3d8                	sw	a4,4(a5)
	MASTER_CPU_CMD = 0x0000001FUL;
 1000358:	477d                	li	a4,31
 100035a:	c798                	sw	a4,8(a5)
}
 100035c:	8082                	ret

0100035e <delay>:

void delay(unsigned int val)
{
	tm_count = 0;
 100035e:	5a01a823          	sw	zero,1456(gp) # 1000a10 <tm_count>
	while(tm_count < val)
 1000362:	5b01a783          	lw	a5,1456(gp) # 1000a10 <tm_count>
 1000366:	fea7eee3          	bltu	a5,a0,1000362 <delay+0x4>
	{
		//
	}	
}
 100036a:	8082                	ret

0100036c <main>:

int main() 
{	
 100036c:	1151                	addi	sp,sp,-12
 100036e:	c406                	sw	ra,8(sp)
	i2c_master_init();
 1000370:	35d1                	jal	1000234 <i2c_master_init>
	timer0_init(16000);	
 1000372:	6511                	lui	a0,0x4
 1000374:	e8050513          	addi	a0,a0,-384 # 3e80 <Reset_Handler-0xffc180>
 1000378:	3789                	jal	10002ba <timer0_init>
	ii = 0;
 100037a:	0001a223          	sw	zero,4(gp) # 1000464 <ii>
	ii2 = 0;
 100037e:	0001a023          	sw	zero,0(gp) # 1000460 <__etext>
  \details Enables IRQ interrupts by setting the IE-bit in the PSR.
           Can only be executed in Privileged modes.
 */
__ALWAYS_STATIC_INLINE void __enable_irq(void)
{
    __ASM volatile("csrs mstatus, 8");
 1000382:	30046073          	csrsi	mstatus,8
	while(1)
	{
		if (1)
		{
			//transmit
			i2c_master_transmit();
 1000386:	3fb1                	jal	10002e2 <i2c_master_transmit>
//					break;
//				}
//			}


			delay(1000);
 1000388:	3e800513          	li	a0,1000
 100038c:	3fc9                	jal	100035e <delay>
			delay(5000);
 100038e:	6505                	lui	a0,0x1
 1000390:	38850513          	addi	a0,a0,904 # 1388 <Reset_Handler-0xffec78>
 1000394:	37e9                	jal	100035e <delay>
		}
		
		if (0)
 1000396:	bfc5                	j	1000386 <main+0x1a>

01000398 <handle_irq>:
volatile unsigned int ii2 = 0;

void handle_irq(uint32_t vec) 
{	
	
	if (I2C_MASTER_IRQn == vec)
 1000398:	47d9                	li	a5,22
 100039a:	00f50663          	beq	a0,a5,10003a6 <handle_irq+0xe>
		{
			MAST_CLEAR |= 0x00000001;
		}
	}
	
	if (TIM0_IRQn == vec)
 100039e:	47e9                	li	a5,26
 10003a0:	08f50d63          	beq	a0,a5,100043a <handle_irq+0xa2>
	{
		tm_count++;
		TIMER_CR |= 0x00000100;
	}
}
 10003a4:	8082                	ret
		ii2++;
 10003a6:	00018793          	mv	a5,gp
 10003aa:	4398                	lw	a4,0(a5)
 10003ac:	0705                	addi	a4,a4,1
 10003ae:	c398                	sw	a4,0(a5)
		if (0x00000010 & MAST_STATUS) // byte done
 10003b0:	1f0307b7          	lui	a5,0x1f030
 10003b4:	579c                	lw	a5,40(a5)
 10003b6:	8bc1                	andi	a5,a5,16
 10003b8:	cf95                	beqz	a5,10003f4 <handle_irq+0x5c>
			MAST_CLEAR |= 0x00000008;
 10003ba:	1f0307b7          	lui	a5,0x1f030
 10003be:	5b98                	lw	a4,48(a5)
 10003c0:	00876713          	ori	a4,a4,8
 10003c4:	db98                	sw	a4,48(a5)
			i2c_master_sended_buffer[ii] = (0x0000ff00 & MAST_STATUS) >> 8;
 10003c6:	5798                	lw	a4,40(a5)
 10003c8:	8721                	srai	a4,a4,0x8
 10003ca:	00018793          	mv	a5,gp
 10003ce:	43d4                	lw	a3,4(a5)
 10003d0:	0ff77713          	andi	a4,a4,255
 10003d4:	5a018613          	addi	a2,gp,1440 # 1000a00 <i2c_master_sended_buffer>
 10003d8:	96b2                	add	a3,a3,a2
 10003da:	00e68023          	sb	a4,0(a3)
			ii++;
 10003de:	43d8                	lw	a4,4(a5)
 10003e0:	0705                	addi	a4,a4,1
 10003e2:	c3d8                	sw	a4,4(a5)
			if (16 <= ii)
 10003e4:	43d8                	lw	a4,4(a5)
 10003e6:	47bd                	li	a5,15
 10003e8:	00e7f663          	bgeu	a5,a4,10003f4 <handle_irq+0x5c>
				ii = 0;
 10003ec:	00018793          	mv	a5,gp
 10003f0:	0007a223          	sw	zero,4(a5) # 1f030004 <__bss_end__+0x1e02f5e4>
		if (0x00000008 & MAST_STATUS)//idle
 10003f4:	1f0307b7          	lui	a5,0x1f030
 10003f8:	5798                	lw	a4,40(a5)
		if (0x00000004 & MAST_STATUS)//timeout
 10003fa:	579c                	lw	a5,40(a5)
 10003fc:	8b91                	andi	a5,a5,4
 10003fe:	c799                	beqz	a5,100040c <handle_irq+0x74>
			MAST_CLEAR |= 0x00000004;
 1000400:	1f030737          	lui	a4,0x1f030
 1000404:	5b1c                	lw	a5,48(a4)
 1000406:	0047e793          	ori	a5,a5,4
 100040a:	db1c                	sw	a5,48(a4)
		if (0x00000002 & MAST_STATUS)//no stop
 100040c:	1f0307b7          	lui	a5,0x1f030
 1000410:	579c                	lw	a5,40(a5)
 1000412:	8b89                	andi	a5,a5,2
 1000414:	c799                	beqz	a5,1000422 <handle_irq+0x8a>
			MAST_CLEAR |= 0x00000002;
 1000416:	1f030737          	lui	a4,0x1f030
 100041a:	5b1c                	lw	a5,48(a4)
 100041c:	0027e793          	ori	a5,a5,2
 1000420:	db1c                	sw	a5,48(a4)
		if (0x00000001 & MAST_STATUS)//no ack
 1000422:	1f0307b7          	lui	a5,0x1f030
 1000426:	579c                	lw	a5,40(a5)
 1000428:	8b85                	andi	a5,a5,1
 100042a:	dbb5                	beqz	a5,100039e <handle_irq+0x6>
			MAST_CLEAR |= 0x00000001;
 100042c:	1f030737          	lui	a4,0x1f030
 1000430:	5b1c                	lw	a5,48(a4)
 1000432:	0017e793          	ori	a5,a5,1
 1000436:	db1c                	sw	a5,48(a4)
 1000438:	b79d                	j	100039e <handle_irq+0x6>
		tm_count++;
 100043a:	5b01a783          	lw	a5,1456(gp) # 1000a10 <tm_count>
 100043e:	0785                	addi	a5,a5,1
 1000440:	5af1a823          	sw	a5,1456(gp) # 1000a10 <tm_count>
		TIMER_CR |= 0x00000100;
 1000444:	1f020737          	lui	a4,0x1f020
 1000448:	431c                	lw	a5,0(a4)
 100044a:	1007e793          	ori	a5,a5,256
 100044e:	c31c                	sw	a5,0(a4)
}
 1000450:	bf91                	j	10003a4 <handle_irq+0xc>
	...
