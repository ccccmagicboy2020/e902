
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
 100000c:	42818193          	addi	gp,gp,1064 # 1000430 <__etext>
.option pop

    la      a0, Default_Handler
 1000010:	00000517          	auipc	a0,0x0
 1000014:	1b050513          	addi	a0,a0,432 # 10001c0 <Default_Handler>
    ori     a0, a0, 3
 1000018:	00356513          	ori	a0,a0,3
    csrw    mtvec, a0
 100001c:	30551073          	csrw	mtvec,a0

    la      a0, __Vectors
 1000020:	c1018513          	addi	a0,gp,-1008 # 1000040 <__Vectors>
    csrw    mtvt, a0
 1000024:	30751073          	csrw	mtvt,a0

    la      sp, __initial_sp
 1000028:	20018113          	addi	sp,gp,512 # 1000630 <__initial_sp>
    csrw    mscratch, sp
 100002c:	34011073          	csrw	mscratch,sp

    jal     main
 1000030:	344000ef          	jal	ra,1000374 <main>

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
 100012e:	264000ef          	jal	ra,1000392 <handle_irq>

    csrc    mstatus, 8
 1000132:	30047073          	csrci	mstatus,8

    lw      a1, 40(sp)
 1000136:	55a2                	lw	a1,40(sp)
    andi    a0, a1, 0x3FF
 1000138:	3ff5f513          	andi	a0,a1,1023

    /* clear pending */
    li      a2, 0xE000E100
 100013c:	e000e637          	lui	a2,0xe000e
 1000140:	10060613          	addi	a2,a2,256 # e000e100 <__bss_end__+0xdf00d730>
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
 10001ce:	40018293          	addi	t0,gp,1024 # 1000830 <g_trap_sp>
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
	
	MAST_MISC = 0x00000002UL;		//enable last ack
 1000244:	4709                	li	a4,2
 1000246:	cb98                	sw	a4,16(a5)
  \details Enable a device-specific interrupt in the VIC interrupt controller.
  \param [in]      IRQn  External interrupt number. Value cannot be negative.
 */
__STATIC_INLINE void csi_vic_enable_irq(int32_t IRQn)
{
    CLIC->CLICINT[IRQn].IE |= CLIC_INTIE_IE_Msk;
 1000248:	e0801737          	lui	a4,0xe0801
 100024c:	05974783          	lbu	a5,89(a4) # e0801059 <__bss_end__+0xdf800689>
 1000250:	0ff7f793          	andi	a5,a5,255
 1000254:	0017e793          	ori	a5,a5,1
 1000258:	04f70ca3          	sb	a5,89(a4)
	
	csi_vic_enable_irq(I2C_MASTER_IRQn);
	
	i2c_master_send_buffer[0] = 0x12;
 100025c:	4749                	li	a4,18
 100025e:	40e18423          	sb	a4,1032(gp) # 1000838 <i2c_master_send_buffer>
	i2c_master_send_buffer[1] = 0x55;
 1000262:	40818793          	addi	a5,gp,1032 # 1000838 <i2c_master_send_buffer>
 1000266:	05500713          	li	a4,85
 100026a:	00e780a3          	sb	a4,1(a5) # 1f030001 <__bss_end__+0x1e02f631>
	i2c_master_send_buffer[2] = 0xAA;
 100026e:	faa00713          	li	a4,-86
 1000272:	00e78123          	sb	a4,2(a5)
	i2c_master_send_buffer[3] = 0xEB;
 1000276:	572d                	li	a4,-21
 1000278:	00e781a3          	sb	a4,3(a5)
	i2c_master_send_buffer[4] = 0x90;
 100027c:	f9000713          	li	a4,-112
 1000280:	00e78223          	sb	a4,4(a5)
	i2c_master_send_buffer[5] = 0x99;
 1000284:	f9900713          	li	a4,-103
 1000288:	00e782a3          	sb	a4,5(a5)
	i2c_master_send_buffer[6] = 0x2A;
 100028c:	02a00713          	li	a4,42
 1000290:	00e78323          	sb	a4,6(a5)
	i2c_master_send_buffer[7] = 0xBE;
 1000294:	fbe00713          	li	a4,-66
 1000298:	00e783a3          	sb	a4,7(a5)
	
	for (i = 8;i<200;i++)
 100029c:	4721                	li	a4,8
 100029e:	0c700793          	li	a5,199
 10002a2:	00e7e963          	bltu	a5,a4,10002b4 <i2c_master_init+0x80>
	{
		i2c_master_send_buffer[i] = i;
 10002a6:	40818793          	addi	a5,gp,1032 # 1000838 <i2c_master_send_buffer>
 10002aa:	97ba                	add	a5,a5,a4
 10002ac:	00e78023          	sb	a4,0(a5)
	for (i = 8;i<200;i++)
 10002b0:	0705                	addi	a4,a4,1
 10002b2:	b7f5                	j	100029e <i2c_master_init+0x6a>
	}
}
 10002b4:	8082                	ret

010002b6 <timer0_init>:

void timer0_init(unsigned int init_val)
{
	tm_count = 0;
 10002b6:	5801ac23          	sw	zero,1432(gp) # 10009c8 <tm_count>
	TIMER0_REG = init_val;	//load the initial value
 10002ba:	1f0207b7          	lui	a5,0x1f020
 10002be:	c788                	sw	a0,8(a5)
	TIMER_CR |= 0x00000010;//enable timer0
 10002c0:	4398                	lw	a4,0(a5)
 10002c2:	01076713          	ori	a4,a4,16
 10002c6:	c398                	sw	a4,0(a5)
	MAST_INT_EN |= 0x0000000f;//enable int source
 10002c8:	1f030737          	lui	a4,0x1f030
 10002cc:	575c                	lw	a5,44(a4)
 10002ce:	00f7e793          	ori	a5,a5,15
 10002d2:	d75c                	sw	a5,44(a4)
 10002d4:	e0801737          	lui	a4,0xe0801
 10002d8:	06974783          	lbu	a5,105(a4) # e0801069 <__bss_end__+0xdf800699>
 10002dc:	0ff7f793          	andi	a5,a5,255
 10002e0:	0017e793          	ori	a5,a5,1
 10002e4:	06f704a3          	sb	a5,105(a4)
	
	csi_vic_enable_irq(TIM0_IRQn);
}
 10002e8:	8082                	ret

010002ea <i2c_master_transmit>:

void i2c_master_transmit()
{
	NWORD = 0x00000009UL;	//send 10 bytes
 10002ea:	1f030737          	lui	a4,0x1f030
 10002ee:	47a5                	li	a5,9
 10002f0:	c35c                	sw	a5,4(a4)
	DATA_2_IICM0 = (i2c_master_send_buffer[3] << 24) | (i2c_master_send_buffer[2] << 16) | (i2c_master_send_buffer[1] << 8) | (i2c_master_send_buffer[0]);
 10002f2:	40818693          	addi	a3,gp,1032 # 1000838 <i2c_master_send_buffer>
 10002f6:	0036c783          	lbu	a5,3(a3)
 10002fa:	07e2                	slli	a5,a5,0x18
 10002fc:	0026c603          	lbu	a2,2(a3)
 1000300:	0642                	slli	a2,a2,0x10
 1000302:	8fd1                	or	a5,a5,a2
 1000304:	0016c603          	lbu	a2,1(a3)
 1000308:	0622                	slli	a2,a2,0x8
 100030a:	8fd1                	or	a5,a5,a2
 100030c:	4081c603          	lbu	a2,1032(gp) # 1000838 <i2c_master_send_buffer>
 1000310:	8fd1                	or	a5,a5,a2
 1000312:	cf1c                	sw	a5,24(a4)
	DATA_2_IICM1 = (i2c_master_send_buffer[7] << 24) | (i2c_master_send_buffer[6] << 16) | (i2c_master_send_buffer[5] << 8) | (i2c_master_send_buffer[4]);
 1000314:	0076c783          	lbu	a5,7(a3)
 1000318:	07e2                	slli	a5,a5,0x18
 100031a:	0066c603          	lbu	a2,6(a3)
 100031e:	0642                	slli	a2,a2,0x10
 1000320:	8fd1                	or	a5,a5,a2
 1000322:	0056c603          	lbu	a2,5(a3)
 1000326:	0622                	slli	a2,a2,0x8
 1000328:	8fd1                	or	a5,a5,a2
 100032a:	0046c683          	lbu	a3,4(a3)
 100032e:	8fd5                	or	a5,a5,a3
 1000330:	cf5c                	sw	a5,28(a4)
	MASTER_CPU_CMD = 0x00000011UL;
 1000332:	47c5                	li	a5,17
 1000334:	c71c                	sw	a5,8(a4)
}
 1000336:	8082                	ret

01000338 <i2c_master_rev>:

void i2c_master_rev()
{
	NWORD = 0x00000009UL;	//rev 10 bytes
 1000338:	1f0307b7          	lui	a5,0x1f030
 100033c:	4725                	li	a4,9
 100033e:	c3d8                	sw	a4,4(a5)
	MASTER_CPU_CMD = 0x00000012UL;
 1000340:	4749                	li	a4,18
 1000342:	c798                	sw	a4,8(a5)
}
 1000344:	8082                	ret

01000346 <i2c_master_restart_rev1>:

void i2c_master_restart_rev1(unsigned char address)
{
	MAST_READ_ADDR = address;
 1000346:	1f0307b7          	lui	a5,0x1f030
 100034a:	cbc8                	sw	a0,20(a5)
	NWORD = 0x00000009UL;	//rev 10 bytes
 100034c:	4725                	li	a4,9
 100034e:	c3d8                	sw	a4,4(a5)
	MASTER_CPU_CMD = 0x00000017UL;
 1000350:	475d                	li	a4,23
 1000352:	c798                	sw	a4,8(a5)
}
 1000354:	8082                	ret

01000356 <i2c_master_restart_rev2>:

void i2c_master_restart_rev2(unsigned short address)
{
	MAST_READ_ADDR = address;
 1000356:	1f0307b7          	lui	a5,0x1f030
 100035a:	cbc8                	sw	a0,20(a5)
	NWORD = 0x00000009UL;	//rev 10 bytes
 100035c:	4725                	li	a4,9
 100035e:	c3d8                	sw	a4,4(a5)
	MASTER_CPU_CMD = 0x0000001FUL;
 1000360:	477d                	li	a4,31
 1000362:	c798                	sw	a4,8(a5)
}
 1000364:	8082                	ret

01000366 <delay>:

void delay(unsigned int val)
{
	tm_count = 0;
 1000366:	5801ac23          	sw	zero,1432(gp) # 10009c8 <tm_count>
	while(tm_count < val)
 100036a:	5981a783          	lw	a5,1432(gp) # 10009c8 <tm_count>
 100036e:	fea7eee3          	bltu	a5,a0,100036a <delay+0x4>
	{
		//
	}	
}
 1000372:	8082                	ret

01000374 <main>:

int main() 
{
 1000374:	1151                	addi	sp,sp,-12
 1000376:	c406                	sw	ra,8(sp)
  \details Enables IRQ interrupts by setting the IE-bit in the PSR.
           Can only be executed in Privileged modes.
 */
__ALWAYS_STATIC_INLINE void __enable_irq(void)
{
    __ASM volatile("csrs mstatus, 8");
 1000378:	30046073          	csrsi	mstatus,8
    __enable_excp_irq();
	
	i2c_master_init();
 100037c:	3d65                	jal	1000234 <i2c_master_init>
	timer0_init(16000);
 100037e:	6511                	lui	a0,0x4
 1000380:	e8050513          	addi	a0,a0,-384 # 3e80 <Reset_Handler-0xffc180>
 1000384:	3f0d                	jal	10002b6 <timer0_init>
	while(1)
	{
		if (1)
		{
			//transmit
			i2c_master_transmit();
 1000386:	3795                	jal	10002ea <i2c_master_transmit>
			delay(5000);			
 1000388:	6505                	lui	a0,0x1
 100038a:	38850513          	addi	a0,a0,904 # 1388 <Reset_Handler-0xffec78>
 100038e:	3fe1                	jal	1000366 <delay>
		}
		
		if (0)
 1000390:	bfdd                	j	1000386 <main+0x12>

01000392 <handle_irq>:
volatile uint8_t data_num;

void handle_irq(uint32_t vec) 
{	
	
	if (I2C_MASTER_IRQn == vec)
 1000392:	47d9                	li	a5,22
 1000394:	00f50663          	beq	a0,a5,10003a0 <handle_irq+0xe>
		}
		
		data_num = (0x0000ff00 & MAST_STATUS) >> 8;
	}
	
	if (TIM0_IRQn == vec)
 1000398:	47e9                	li	a5,26
 100039a:	06f50e63          	beq	a0,a5,1000416 <handle_irq+0x84>
	{
		tm_count++;
		TIMER_CR |= 0x00000100;
	}
}
 100039e:	8082                	ret
		MAST_CLEAR |= 0x00000010;
 10003a0:	1f0307b7          	lui	a5,0x1f030
 10003a4:	5b98                	lw	a4,48(a5)
 10003a6:	01076713          	ori	a4,a4,16
 10003aa:	db98                	sw	a4,48(a5)
		MAST_CLEAR &= 0xffffffef;
 10003ac:	5b98                	lw	a4,48(a5)
 10003ae:	9b3d                	andi	a4,a4,-17
 10003b0:	db98                	sw	a4,48(a5)
		if (0x00000008 & MAST_STATUS)//idle
 10003b2:	5798                	lw	a4,40(a5)
		if (0x00000004 & MAST_STATUS)//timeout
 10003b4:	579c                	lw	a5,40(a5)
 10003b6:	8b91                	andi	a5,a5,4
 10003b8:	cb91                	beqz	a5,10003cc <handle_irq+0x3a>
			MAST_CLEAR |= 0x00000004;
 10003ba:	1f0307b7          	lui	a5,0x1f030
 10003be:	5b98                	lw	a4,48(a5)
 10003c0:	00476713          	ori	a4,a4,4
 10003c4:	db98                	sw	a4,48(a5)
			MAST_CLEAR &= 0xfffffffb;
 10003c6:	5b98                	lw	a4,48(a5)
 10003c8:	9b6d                	andi	a4,a4,-5
 10003ca:	db98                	sw	a4,48(a5)
		if (0x00000002 & MAST_STATUS)//no stop
 10003cc:	1f0307b7          	lui	a5,0x1f030
 10003d0:	579c                	lw	a5,40(a5)
 10003d2:	8b89                	andi	a5,a5,2
 10003d4:	cb91                	beqz	a5,10003e8 <handle_irq+0x56>
			MAST_CLEAR |= 0x00000002;
 10003d6:	1f0307b7          	lui	a5,0x1f030
 10003da:	5b98                	lw	a4,48(a5)
 10003dc:	00276713          	ori	a4,a4,2
 10003e0:	db98                	sw	a4,48(a5)
			MAST_CLEAR &= 0xfffffffd;
 10003e2:	5b98                	lw	a4,48(a5)
 10003e4:	9b75                	andi	a4,a4,-3
 10003e6:	db98                	sw	a4,48(a5)
		if (0x00000001 & MAST_STATUS)//no ack
 10003e8:	1f0307b7          	lui	a5,0x1f030
 10003ec:	579c                	lw	a5,40(a5)
 10003ee:	8b85                	andi	a5,a5,1
 10003f0:	cb91                	beqz	a5,1000404 <handle_irq+0x72>
			MAST_CLEAR |= 0x00000001;
 10003f2:	1f0307b7          	lui	a5,0x1f030
 10003f6:	5b98                	lw	a4,48(a5)
 10003f8:	00176713          	ori	a4,a4,1
 10003fc:	db98                	sw	a4,48(a5)
			MAST_CLEAR &= 0xfffffffe;
 10003fe:	5b98                	lw	a4,48(a5)
 1000400:	9b79                	andi	a4,a4,-2
 1000402:	db98                	sw	a4,48(a5)
		data_num = (0x0000ff00 & MAST_STATUS) >> 8;
 1000404:	1f0307b7          	lui	a5,0x1f030
 1000408:	579c                	lw	a5,40(a5)
 100040a:	87a1                	srai	a5,a5,0x8
 100040c:	0ff7f793          	andi	a5,a5,255
 1000410:	58f18e23          	sb	a5,1436(gp) # 10009cc <data_num>
 1000414:	b751                	j	1000398 <handle_irq+0x6>
		tm_count++;
 1000416:	5981a783          	lw	a5,1432(gp) # 10009c8 <tm_count>
 100041a:	0785                	addi	a5,a5,1
 100041c:	58f1ac23          	sw	a5,1432(gp) # 10009c8 <tm_count>
		TIMER_CR |= 0x00000100;
 1000420:	1f020737          	lui	a4,0x1f020
 1000424:	431c                	lw	a5,0(a4)
 1000426:	1007e793          	ori	a5,a5,256
 100042a:	c31c                	sw	a5,0(a4)
}
 100042c:	bf8d                	j	100039e <handle_irq+0xc>
	...
