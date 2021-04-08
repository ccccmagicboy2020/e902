
.//Obj/uart_test.elf:     file format elf32-littleriscv


Disassembly of section .text:

01000000 <Reset_Handler>:
    .globl  Reset_Handler
    .type   Reset_Handler, %function
Reset_Handler:
.option push
.option norelax
    la      gp, __global_pointer$
 1000000:	00001197          	auipc	gp,0x1
 1000004:	c1018193          	addi	gp,gp,-1008 # 1000c10 <__erodata>
    csrw    mtvec, a0

    la      a0, __Vectors
    csrw    mtvt, a0
#endif
    la      sp, g_top_irqstack
 1000008:	1b018113          	addi	sp,gp,432 # 1000dc0 <uart_dev>
    csrw    mscratch, sp
 100000c:	34011073          	csrw	mscratch,sp
    addi    a0, a0, 4
    bltu    a0, a1, 1b
2:
#endif

    jal     SystemInit
 1000010:	728000ef          	jal	ra,1000738 <SystemInit>

    jal     board_init
 1000014:	7e8000ef          	jal	ra,10007fc <board_init>

    jal     main
 1000018:	008000ef          	jal	ra,1000020 <main>

0100001c <__exit>:

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit
 100001c:	a001                	j	100001c <__exit>
	...

01000020 <main>:
#include <driver.h>
#include <console.h>
#include <shell.h>


int __attribute__((weak)) main(void) {
 1000020:	1151                	addi	sp,sp,-12
 1000022:	c406                	sw	ra,8(sp)
	puts("--- Uart test "__DATE__" "__TIME__"---\n");
 1000024:	01001537          	lui	a0,0x1001
 1000028:	be050513          	addi	a0,a0,-1056 # 1000be0 <HEX_TABLE+0x14>
 100002c:	061000ef          	jal	ra,100088c <puts>
	while (EEXIT != sh_loop()) {
		// do other things
	}
	#else
	while(1) {
		int ch = getchar();
 1000030:	7ec000ef          	jal	ra,100081c <getchar>
		if (ch > 0)
 1000034:	fea05ee3          	blez	a0,1000030 <main+0x10>
			putchar(ch);
 1000038:	00b000ef          	jal	ra,1000842 <putchar>
 100003c:	bfd5                	j	1000030 <main+0x10>

0100003e <fifo_reset>:
  * \param  [in] fifo: The fifo to be emptied.
  * \return None.
  */
void fifo_reset(fifo_t *fifo)
{
    fifo->write = fifo->read = 0;
 100003e:	00051223          	sh	zero,4(a0)
 1000042:	00051123          	sh	zero,2(a0)
    fifo->len = 0;
 1000046:	00051323          	sh	zero,6(a0)
}
 100004a:	8082                	ret

0100004c <fifo_write>:
  * \note   This function copies at most @len bytes from the @in into
  *         the FIFO depending on the free space, and returns the number
  *         of bytes copied.
  */
FIFO_SIZE_t fifo_write(fifo_t *fifo, const void *datptr, FIFO_SIZE_t len)
{
 100004c:	1131                	addi	sp,sp,-20
 100004e:	c806                	sw	ra,16(sp)
 1000050:	c622                	sw	s0,12(sp)
 1000052:	c426                	sw	s1,8(sp)
    FIFO_SIZE_t writelen = 0, tmplen = 0;

    if(fifo_is_full(fifo))
 1000054:	00055483          	lhu	s1,0(a0)
 1000058:	00655783          	lhu	a5,6(a0)
 100005c:	0af48263          	beq	s1,a5,1000100 <fifo_write+0xb4>
        return 0;

    tmplen = fifo_avail(fifo);
 1000060:	40f487b3          	sub	a5,s1,a5
 1000064:	07c2                	slli	a5,a5,0x10
 1000066:	83c1                	srli	a5,a5,0x10
    writelen = tmplen > len ? len : tmplen;
 1000068:	873e                	mv	a4,a5
 100006a:	00f67363          	bgeu	a2,a5,1000070 <fifo_write+0x24>
 100006e:	8732                	mv	a4,a2
 1000070:	c22e                	sw	a1,4(sp)
 1000072:	842a                	mv	s0,a0
 1000074:	01071793          	slli	a5,a4,0x10
 1000078:	83c1                	srli	a5,a5,0x10
 100007a:	c03e                	sw	a5,0(sp)

    if(fifo->write < fifo->read) {
 100007c:	00255783          	lhu	a5,2(a0)
 1000080:	00455703          	lhu	a4,4(a0)
 1000084:	04e7e863          	bltu	a5,a4,10000d4 <fifo_write+0x88>
        memcpy((void*)&fifo->buffer[fifo->write], (void*)datptr, writelen);
    } else {
        tmplen = fifo_size(fifo) - fifo->write;
 1000088:	8c9d                	sub	s1,s1,a5
 100008a:	04c2                	slli	s1,s1,0x10
 100008c:	80c1                	srli	s1,s1,0x10
        if(writelen <= tmplen) {
 100008e:	4602                	lw	a2,0(sp)
 1000090:	04c4e863          	bltu	s1,a2,10000e0 <fifo_write+0x94>
            memcpy((void*)&fifo->buffer[fifo->write], (void*)datptr, writelen);
 1000094:	4508                	lw	a0,8(a0)
 1000096:	4592                	lw	a1,4(sp)
 1000098:	953e                	add	a0,a0,a5
 100009a:	15f000ef          	jal	ra,10009f8 <memcpy>
            memcpy((void*)&fifo->buffer[fifo->write], (void*)datptr, tmplen);
            memcpy((void*)fifo->buffer, (const uint8_t*)datptr + tmplen, writelen - tmplen);
        }
    }

	tmplen = fifo->write + writelen;
 100009e:	00245783          	lhu	a5,2(s0)
 10000a2:	4702                	lw	a4,0(sp)
 10000a4:	97ba                	add	a5,a5,a4
 10000a6:	07c2                	slli	a5,a5,0x10
 10000a8:	83c1                	srli	a5,a5,0x10
    fifo->write = tmplen > fifo_size(fifo) ? tmplen - fifo_size(fifo) : tmplen;
 10000aa:	00045703          	lhu	a4,0(s0)
 10000ae:	00f77563          	bgeu	a4,a5,10000b8 <fifo_write+0x6c>
 10000b2:	8f99                	sub	a5,a5,a4
 10000b4:	07c2                	slli	a5,a5,0x10
 10000b6:	83c1                	srli	a5,a5,0x10
 10000b8:	00f41123          	sh	a5,2(s0)
    fifo->len += writelen;
 10000bc:	00645783          	lhu	a5,6(s0)
 10000c0:	4702                	lw	a4,0(sp)
 10000c2:	97ba                	add	a5,a5,a4
 10000c4:	00f41323          	sh	a5,6(s0)

    return writelen;
}
 10000c8:	4502                	lw	a0,0(sp)
 10000ca:	40c2                	lw	ra,16(sp)
 10000cc:	4432                	lw	s0,12(sp)
 10000ce:	44a2                	lw	s1,8(sp)
 10000d0:	0151                	addi	sp,sp,20
 10000d2:	8082                	ret
        memcpy((void*)&fifo->buffer[fifo->write], (void*)datptr, writelen);
 10000d4:	4508                	lw	a0,8(a0)
 10000d6:	4602                	lw	a2,0(sp)
 10000d8:	953e                	add	a0,a0,a5
 10000da:	11f000ef          	jal	ra,10009f8 <memcpy>
 10000de:	b7c1                	j	100009e <fifo_write+0x52>
            memcpy((void*)&fifo->buffer[fifo->write], (void*)datptr, tmplen);
 10000e0:	4508                	lw	a0,8(a0)
 10000e2:	8626                	mv	a2,s1
 10000e4:	4592                	lw	a1,4(sp)
 10000e6:	953e                	add	a0,a0,a5
 10000e8:	111000ef          	jal	ra,10009f8 <memcpy>
            memcpy((void*)fifo->buffer, (const uint8_t*)datptr + tmplen, writelen - tmplen);
 10000ec:	4702                	lw	a4,0(sp)
 10000ee:	40970633          	sub	a2,a4,s1
 10000f2:	4792                	lw	a5,4(sp)
 10000f4:	009785b3          	add	a1,a5,s1
 10000f8:	4408                	lw	a0,8(s0)
 10000fa:	0ff000ef          	jal	ra,10009f8 <memcpy>
 10000fe:	b745                	j	100009e <fifo_write+0x52>
        return 0;
 1000100:	c002                	sw	zero,0(sp)
 1000102:	b7d9                	j	10000c8 <fifo_write+0x7c>

01000104 <fifo_read>:
  * \return The number of copied bytes.
  * \note   This function copies at most @len bytes from the FIFO into
  *         the @out and returns the number of copied bytes.
  */
FIFO_SIZE_t fifo_read(fifo_t *fifo, void *outbuf, FIFO_SIZE_t len)
{
 1000104:	1131                	addi	sp,sp,-20
 1000106:	c806                	sw	ra,16(sp)
 1000108:	c622                	sw	s0,12(sp)
 100010a:	c426                	sw	s1,8(sp)
    FIFO_SIZE_t readlen = 0, tmplen = 0;
    if(fifo_is_empty(fifo))
 100010c:	00655403          	lhu	s0,6(a0)
 1000110:	cc31                	beqz	s0,100016c <fifo_read+0x68>
        return 0;

    readlen = len > fifo->len ? fifo->len : len;
 1000112:	87a2                	mv	a5,s0
 1000114:	00867363          	bgeu	a2,s0,100011a <fifo_read+0x16>
 1000118:	87b2                	mv	a5,a2
 100011a:	c22e                	sw	a1,4(sp)
 100011c:	84aa                	mv	s1,a0
 100011e:	01079413          	slli	s0,a5,0x10
 1000122:	8041                	srli	s0,s0,0x10
    tmplen = fifo_size(fifo) - fifo->read;
 1000124:	00055703          	lhu	a4,0(a0)
 1000128:	00455783          	lhu	a5,4(a0)
 100012c:	8f1d                	sub	a4,a4,a5
 100012e:	0742                	slli	a4,a4,0x10
 1000130:	8341                	srli	a4,a4,0x10
 1000132:	c03a                	sw	a4,0(sp)

    if(NULL != outbuf) {
 1000134:	852e                	mv	a0,a1
 1000136:	c981                	beqz	a1,1000146 <fifo_read+0x42>
        if(readlen <= tmplen) {
 1000138:	04876063          	bltu	a4,s0,1000178 <fifo_read+0x74>
            memcpy((void*)outbuf, (void*)&fifo->buffer[fifo->read], readlen);
 100013c:	448c                	lw	a1,8(s1)
 100013e:	8622                	mv	a2,s0
 1000140:	95be                	add	a1,a1,a5
 1000142:	0b7000ef          	jal	ra,10009f8 <memcpy>
            memcpy((void*)outbuf,(void*)&fifo->buffer[fifo->read], tmplen);
            memcpy((uint8_t*)outbuf + tmplen,(void*)fifo->buffer,readlen - tmplen);
        }
    }

	tmplen = fifo->read + readlen;
 1000146:	0044d783          	lhu	a5,4(s1)
 100014a:	97a2                	add	a5,a5,s0
 100014c:	07c2                	slli	a5,a5,0x10
 100014e:	83c1                	srli	a5,a5,0x10
    fifo->read = tmplen > fifo_size(fifo) ? tmplen - fifo_size(fifo) : tmplen;
 1000150:	0004d703          	lhu	a4,0(s1)
 1000154:	00f77563          	bgeu	a4,a5,100015e <fifo_read+0x5a>
 1000158:	8f99                	sub	a5,a5,a4
 100015a:	07c2                	slli	a5,a5,0x10
 100015c:	83c1                	srli	a5,a5,0x10
 100015e:	00f49223          	sh	a5,4(s1)
    fifo->len -= readlen;
 1000162:	0064d783          	lhu	a5,6(s1)
 1000166:	8f81                	sub	a5,a5,s0
 1000168:	00f49323          	sh	a5,6(s1)

    return readlen;
}
 100016c:	8522                	mv	a0,s0
 100016e:	40c2                	lw	ra,16(sp)
 1000170:	4432                	lw	s0,12(sp)
 1000172:	44a2                	lw	s1,8(sp)
 1000174:	0151                	addi	sp,sp,20
 1000176:	8082                	ret
            memcpy((void*)outbuf,(void*)&fifo->buffer[fifo->read], tmplen);
 1000178:	448c                	lw	a1,8(s1)
 100017a:	4602                	lw	a2,0(sp)
 100017c:	95be                	add	a1,a1,a5
 100017e:	4512                	lw	a0,4(sp)
 1000180:	079000ef          	jal	ra,10009f8 <memcpy>
            memcpy((uint8_t*)outbuf + tmplen,(void*)fifo->buffer,readlen - tmplen);
 1000184:	4782                	lw	a5,0(sp)
 1000186:	40f40633          	sub	a2,s0,a5
 100018a:	448c                	lw	a1,8(s1)
 100018c:	4712                	lw	a4,4(sp)
 100018e:	00f70533          	add	a0,a4,a5
 1000192:	067000ef          	jal	ra,10009f8 <memcpy>
 1000196:	bf45                	j	1000146 <fifo_read+0x42>

01000198 <WDG_IRQHandler>:

static void tick_init(void);

void WDG_IRQHandler(void) {
	
}
 1000198:	8082                	ret

0100019a <timer_irqhandler>:

void timer_irqhandler(int index) {
	tm_count[index]++;
 100019a:	00251713          	slli	a4,a0,0x2
 100019e:	00018793          	mv	a5,gp
 10001a2:	97ba                	add	a5,a5,a4
 10001a4:	4398                	lw	a4,0(a5)
 10001a6:	0705                	addi	a4,a4,1
 10001a8:	c398                	sw	a4,0(a5)
	if (tm_cb[index])
 10001aa:	4b9c                	lw	a5,16(a5)
 10001ac:	c799                	beqz	a5,10001ba <timer_irqhandler+0x20>
void timer_irqhandler(int index) {
 10001ae:	1151                	addi	sp,sp,-12
 10001b0:	c406                	sw	ra,8(sp)
		tm_cb[index](index);
 10001b2:	9782                	jalr	a5
}
 10001b4:	40a2                	lw	ra,8(sp)
 10001b6:	0131                	addi	sp,sp,12
 10001b8:	8082                	ret
 10001ba:	8082                	ret

010001bc <timer_register>:
	}
	tick_init();
}

void timer_register(int index, timer_cb_t cb) {
	if (index >= CONFIG_TIMER_NUM)
 10001bc:	478d                	li	a5,3
 10001be:	00a7c763          	blt	a5,a0,10001cc <timer_register+0x10>
		return;
	tm_cb[index] = cb;
 10001c2:	050a                	slli	a0,a0,0x2
 10001c4:	00018793          	mv	a5,gp
 10001c8:	953e                	add	a0,a0,a5
 10001ca:	c90c                	sw	a1,16(a0)
}
 10001cc:	8082                	ret

010001ce <timer_enable>:

void timer_enable(int index, bool enable) {
	if (index >= CONFIG_TIMER_NUM)
 10001ce:	478d                	li	a5,3
 10001d0:	02a7c363          	blt	a5,a0,10001f6 <timer_enable+0x28>
		return;
	uint32_t mask = 0x10 << index;
 10001d4:	47c1                	li	a5,16
 10001d6:	00a797b3          	sll	a5,a5,a0

	if (enable)
 10001da:	c599                	beqz	a1,10001e8 <timer_enable+0x1a>
		reg32_set(STCCTL, mask);
 10001dc:	1f020737          	lui	a4,0x1f020
 10001e0:	4308                	lw	a0,0(a4)
 10001e2:	8fc9                	or	a5,a5,a0
 10001e4:	c31c                	sw	a5,0(a4)
 10001e6:	8082                	ret
	else
		reg32_clr(STCCTL, mask);
 10001e8:	1f020737          	lui	a4,0x1f020
 10001ec:	4308                	lw	a0,0(a4)
 10001ee:	fff7c793          	not	a5,a5
 10001f2:	8fe9                	and	a5,a5,a0
 10001f4:	c31c                	sw	a5,0(a4)
}
 10001f6:	8082                	ret

010001f8 <tick_init>:
	else
		reg32_clr(STCCTL, 0x02);
}

#define TIMCNT_MAX	UINT32_MAX
static void tick_init(void) {
 10001f8:	1151                	addi	sp,sp,-12
 10001fa:	c406                	sw	ra,8(sp)
	TIMINIT[CONFIG_TICK_TIMER] = TIMCNT_MAX;
 10001fc:	1f0207b7          	lui	a5,0x1f020
 1000200:	577d                	li	a4,-1
 1000202:	cbd8                	sw	a4,20(a5)
	timer_enable(CONFIG_TICK_TIMER, true);
 1000204:	4585                	li	a1,1
 1000206:	450d                	li	a0,3
 1000208:	37d9                	jal	10001ce <timer_enable>
}
 100020a:	40a2                	lw	ra,8(sp)
 100020c:	0131                	addi	sp,sp,12
 100020e:	8082                	ret

01000210 <stc_init>:
void stc_init(void) {
 1000210:	1151                	addi	sp,sp,-12
 1000212:	c406                	sw	ra,8(sp)
	for (int i = 0; i < CONFIG_TIMER_NUM; i++) {
 1000214:	4701                	li	a4,0
 1000216:	a819                	j	100022c <stc_init+0x1c>
		tm_count[i] = 0;
 1000218:	00271693          	slli	a3,a4,0x2
 100021c:	00018793          	mv	a5,gp
 1000220:	97b6                	add	a5,a5,a3
 1000222:	0007a023          	sw	zero,0(a5) # 1f020000 <uart_dev+0x1e01f240>
		tm_cb[i] = NULL;
 1000226:	0007a823          	sw	zero,16(a5)
	for (int i = 0; i < CONFIG_TIMER_NUM; i++) {
 100022a:	0705                	addi	a4,a4,1
 100022c:	478d                	li	a5,3
 100022e:	fee7d5e3          	bge	a5,a4,1000218 <stc_init+0x8>
	tick_init();
 1000232:	37d9                	jal	10001f8 <tick_init>
}
 1000234:	40a2                	lw	ra,8(sp)
 1000236:	0131                	addi	sp,sp,12
 1000238:	8082                	ret

0100023a <timer_count>:
	if (index < CONFIG_TIMER_NUM)
 100023a:	478d                	li	a5,3
 100023c:	00a7d463          	bge	a5,a0,1000244 <timer_count+0xa>
	return 0;
 1000240:	4501                	li	a0,0
}
 1000242:	8082                	ret
		return tm_count[index];
 1000244:	050a                	slli	a0,a0,0x2
 1000246:	00018793          	mv	a5,gp
 100024a:	953e                	add	a0,a0,a5
 100024c:	4108                	lw	a0,0(a0)
 100024e:	8082                	ret

01000250 <Watchdog_enable>:
	if (enable)
 1000250:	c901                	beqz	a0,1000260 <Watchdog_enable+0x10>
		reg32_set(STCCTL, 0x02);
 1000252:	1f020737          	lui	a4,0x1f020
 1000256:	431c                	lw	a5,0(a4)
 1000258:	0027e793          	ori	a5,a5,2
 100025c:	c31c                	sw	a5,0(a4)
 100025e:	8082                	ret
		reg32_clr(STCCTL, 0x02);
 1000260:	1f020737          	lui	a4,0x1f020
 1000264:	431c                	lw	a5,0(a4)
 1000266:	9bf5                	andi	a5,a5,-3
 1000268:	c31c                	sw	a5,0(a4)
}
 100026a:	8082                	ret

0100026c <tick_count>:

uint32_t tick_count(void) {
	return TIMCNT[CONFIG_TICK_TIMER];
 100026c:	1f0207b7          	lui	a5,0x1f020
 1000270:	47e8                	lw	a0,76(a5)
}
 1000272:	8082                	ret

01000274 <tick_diff>:

uint32_t tick_diff(uint32_t start) {
 1000274:	1151                	addi	sp,sp,-12
 1000276:	c406                	sw	ra,8(sp)
 1000278:	c222                	sw	s0,4(sp)
 100027a:	842a                	mv	s0,a0
	uint32_t diff;
	uint32_t cnt = tick_count();
 100027c:	3fc5                	jal	100026c <tick_count>
	if (cnt > start)
 100027e:	00a47963          	bgeu	s0,a0,1000290 <tick_diff+0x1c>
		diff = start + (TIMCNT_MAX - cnt);
 1000282:	40a40533          	sub	a0,s0,a0
 1000286:	157d                	addi	a0,a0,-1
	else
		diff = start - cnt;
	return diff;
}
 1000288:	40a2                	lw	ra,8(sp)
 100028a:	4412                	lw	s0,4(sp)
 100028c:	0131                	addi	sp,sp,12
 100028e:	8082                	ret
		diff = start - cnt;
 1000290:	40a40533          	sub	a0,s0,a0
	return diff;
 1000294:	bfd5                	j	1000288 <tick_diff+0x14>

01000296 <tick_diff_us>:

#define TIMCNT_MS	(SYSTEM_CLOCK / 1000)
#define TIMCNT_US	(TIMCNT_MS / 1000)

uint32_t tick_diff_us(uint32_t start) {
 1000296:	1151                	addi	sp,sp,-12
 1000298:	c406                	sw	ra,8(sp)
	uint32_t diff = tick_diff(start);
 100029a:	3fe9                	jal	1000274 <tick_diff>
	return (diff + 4) / TIMCNT_US;
 100029c:	0511                	addi	a0,a0,4
}
 100029e:	8111                	srli	a0,a0,0x4
 10002a0:	40a2                	lw	ra,8(sp)
 10002a2:	0131                	addi	sp,sp,12
 10002a4:	8082                	ret

010002a6 <tick_diff_ms>:

uint32_t tick_diff_ms(uint32_t start) {
 10002a6:	1151                	addi	sp,sp,-12
 10002a8:	c406                	sw	ra,8(sp)
	uint32_t diff = tick_diff(start);
 10002aa:	37e9                	jal	1000274 <tick_diff>
	return (diff + 4) / TIMCNT_MS;
 10002ac:	6591                	lui	a1,0x4
 10002ae:	e8058593          	addi	a1,a1,-384 # 3e80 <Reset_Handler-0xffc180>
 10002b2:	0511                	addi	a0,a0,4
 10002b4:	6cc000ef          	jal	ra,1000980 <__udivsi3>
}
 10002b8:	40a2                	lw	ra,8(sp)
 10002ba:	0131                	addi	sp,sp,12
 10002bc:	8082                	ret

010002be <delay_us>:

void delay_us(uint32_t us) {
 10002be:	1151                	addi	sp,sp,-12
 10002c0:	c406                	sw	ra,8(sp)
 10002c2:	c222                	sw	s0,4(sp)
 10002c4:	c026                	sw	s1,0(sp)
 10002c6:	842a                	mv	s0,a0
	uint32_t start = tick_count();
 10002c8:	3755                	jal	100026c <tick_count>
 10002ca:	84aa                	mv	s1,a0
	uint32_t period = us * TIMCNT_US;
 10002cc:	0412                	slli	s0,s0,0x4
	while (tick_diff(start) < period);
 10002ce:	8526                	mv	a0,s1
 10002d0:	3755                	jal	1000274 <tick_diff>
 10002d2:	fe856ee3          	bltu	a0,s0,10002ce <delay_us+0x10>
}
 10002d6:	40a2                	lw	ra,8(sp)
 10002d8:	4412                	lw	s0,4(sp)
 10002da:	4482                	lw	s1,0(sp)
 10002dc:	0131                	addi	sp,sp,12
 10002de:	8082                	ret

010002e0 <delay_ms>:

void delay_ms(uint32_t ms) {
 10002e0:	1151                	addi	sp,sp,-12
 10002e2:	c406                	sw	ra,8(sp)
 10002e4:	c222                	sw	s0,4(sp)
 10002e6:	c026                	sw	s1,0(sp)
 10002e8:	842a                	mv	s0,a0
	uint32_t start = tick_count();
 10002ea:	3749                	jal	100026c <tick_count>
 10002ec:	84aa                	mv	s1,a0
	uint32_t period = ms * TIMCNT_MS;
 10002ee:	00541793          	slli	a5,s0,0x5
 10002f2:	8f81                	sub	a5,a5,s0
 10002f4:	00279513          	slli	a0,a5,0x2
 10002f8:	9522                	add	a0,a0,s0
 10002fa:	00751413          	slli	s0,a0,0x7
	while (tick_diff(start) < period);
 10002fe:	8526                	mv	a0,s1
 1000300:	3f95                	jal	1000274 <tick_diff>
 1000302:	fe856ee3          	bltu	a0,s0,10002fe <delay_ms+0x1e>
}
 1000306:	40a2                	lw	ra,8(sp)
 1000308:	4412                	lw	s0,4(sp)
 100030a:	4482                	lw	s1,0(sp)
 100030c:	0131                	addi	sp,sp,12
 100030e:	8082                	ret

01000310 <uart_init>:
bool uart_init(int index, const uart_config_t* config) {
	uint8_t cfg = UART_CONFIG;
	uint8_t buad = UART_BAUD;
	uint32_t divisor;

	if (index >= CONFIG_UART_NUM)
 1000310:	4785                	li	a5,1
 1000312:	00a7d463          	bge	a5,a0,100031a <uart_init+0xa>
		return false;
 1000316:	4501                	li	a0,0
	uart_dev[index].reg->enable |= 0xb0; // enable user define buadrate
	if (uart_dev[index].rx_fifo.size) {
		csi_vic_enable_irq(uart_dev[index].irq);
	}
	return true;
}
 1000318:	8082                	ret
bool uart_init(int index, const uart_config_t* config) {
 100031a:	1151                	addi	sp,sp,-12
 100031c:	c406                	sw	ra,8(sp)
 100031e:	c222                	sw	s0,4(sp)
 1000320:	c026                	sw	s1,0(sp)
 1000322:	84ae                	mv	s1,a1
 1000324:	842a                	mv	s0,a0
	memset(&uart_dev[index], 0, sizeof(uart_dev[index]));
 1000326:	0516                	slli	a0,a0,0x5
 1000328:	02000613          	li	a2,32
 100032c:	4581                	li	a1,0
 100032e:	1b018793          	addi	a5,gp,432 # 1000dc0 <uart_dev>
 1000332:	953e                	add	a0,a0,a5
 1000334:	7a0000ef          	jal	ra,1000ad4 <memset>
	if (index) {
 1000338:	c049                	beqz	s0,10003ba <uart_init+0xaa>
		uart_dev[1].reg = XBR820_UART1;
 100033a:	1b018793          	addi	a5,gp,432 # 1000dc0 <uart_dev>
 100033e:	1f050737          	lui	a4,0x1f050
 1000342:	d398                	sw	a4,32(a5)
		uart_dev[1].irq = UART1_RX_IRQn;
 1000344:	475d                	li	a4,23
 1000346:	d3d8                	sw	a4,36(a5)
	uart_dev[index].reg->enable = 0;
 1000348:	00541793          	slli	a5,s0,0x5
 100034c:	1b018713          	addi	a4,gp,432 # 1000dc0 <uart_dev>
 1000350:	97ba                	add	a5,a5,a4
 1000352:	439c                	lw	a5,0(a5)
 1000354:	0007a023          	sw	zero,0(a5) # 1f020000 <uart_dev+0x1e01f240>
	if (config) {
 1000358:	cca5                	beqz	s1,10003d0 <uart_init+0xc0>
		if (config->buf) {
 100035a:	4094                	lw	a3,0(s1)
 100035c:	0e068963          	beqz	a3,100044e <uart_init+0x13e>
			if (config->rsize) {
 1000360:	0044c783          	lbu	a5,4(s1)
 1000364:	cb99                	beqz	a5,100037a <uart_init+0x6a>
				uart_dev[index].rx_fifo.buffer = (uint8_t *)config->buf;
 1000366:	00541793          	slli	a5,s0,0x5
 100036a:	1b018713          	addi	a4,gp,432 # 1000dc0 <uart_dev>
 100036e:	97ba                	add	a5,a5,a4
 1000370:	cb94                	sw	a3,16(a5)
				uart_dev[index].rx_fifo.size = config->rsize;
 1000372:	0044c703          	lbu	a4,4(s1)
 1000376:	00e79423          	sh	a4,8(a5)
			if (config->tsize) {
 100037a:	0054c783          	lbu	a5,5(s1)
 100037e:	cf99                	beqz	a5,100039c <uart_init+0x8c>
				uart_dev[index].tx_fifo.buffer = (uint8_t *)config->buf + config->rsize;
 1000380:	4094                	lw	a3,0(s1)
 1000382:	0044c783          	lbu	a5,4(s1)
 1000386:	96be                	add	a3,a3,a5
 1000388:	00541793          	slli	a5,s0,0x5
 100038c:	1b018713          	addi	a4,gp,432 # 1000dc0 <uart_dev>
 1000390:	97ba                	add	a5,a5,a4
 1000392:	cfd4                	sw	a3,28(a5)
				uart_dev[index].tx_fifo.size = config->tsize;
 1000394:	0054c703          	lbu	a4,5(s1)
 1000398:	00e79a23          	sh	a4,20(a5)
			if (UART_CFG_DEF != config->cfg)
 100039c:	0064c683          	lbu	a3,6(s1)
 10003a0:	0ff00793          	li	a5,255
 10003a4:	02f68463          	beq	a3,a5,10003cc <uart_init+0xbc>
				cfg = config->cfg & UART_CFG_MASK;
 10003a8:	0386f693          	andi	a3,a3,56
			if (config->buad <= BAUD_921600)
 10003ac:	0074c783          	lbu	a5,7(s1)
 10003b0:	4749                	li	a4,18
 10003b2:	02f77163          	bgeu	a4,a5,10003d4 <uart_init+0xc4>
	uint8_t buad = UART_BAUD;
 10003b6:	47bd                	li	a5,15
 10003b8:	a831                	j	10003d4 <uart_init+0xc4>
		uart_dev[0].reg = XBR820_UART0;
 10003ba:	1f050737          	lui	a4,0x1f050
 10003be:	1ae1a823          	sw	a4,432(gp) # 1000dc0 <uart_dev>
		uart_dev[0].irq = UART0_RX_IRQn;
 10003c2:	1b018793          	addi	a5,gp,432 # 1000dc0 <uart_dev>
 10003c6:	4755                	li	a4,21
 10003c8:	c3d8                	sw	a4,4(a5)
 10003ca:	bfbd                	j	1000348 <uart_init+0x38>
	uint8_t cfg = UART_CONFIG;
 10003cc:	468d                	li	a3,3
 10003ce:	bff9                	j	10003ac <uart_init+0x9c>
	uint8_t buad = UART_BAUD;
 10003d0:	47bd                	li	a5,15
	uint8_t cfg = UART_CONFIG;
 10003d2:	468d                	li	a3,3
	uart_dev[index].reg->config = cfg;
 10003d4:	00541493          	slli	s1,s0,0x5
 10003d8:	1b018713          	addi	a4,gp,432 # 1000dc0 <uart_dev>
 10003dc:	94ba                	add	s1,s1,a4
 10003de:	4098                	lw	a4,0(s1)
 10003e0:	c354                	sw	a3,4(a4)
	divisor = (SYSTEM_CLOCK + buad_rates[buad]/2) / buad_rates[buad] - 1;
 10003e2:	00279713          	slli	a4,a5,0x2
 10003e6:	f7018793          	addi	a5,gp,-144 # 1000b80 <__etext>
 10003ea:	97ba                	add	a5,a5,a4
 10003ec:	438c                	lw	a1,0(a5)
 10003ee:	0015d513          	srli	a0,a1,0x1
 10003f2:	00f427b7          	lui	a5,0xf42
 10003f6:	40078793          	addi	a5,a5,1024 # f42400 <Reset_Handler-0xbdc00>
 10003fa:	953e                	add	a0,a0,a5
 10003fc:	2351                	jal	1000980 <__udivsi3>
 10003fe:	157d                	addi	a0,a0,-1
	uart_dev[index].reg->baud_high = (divisor >> 8) & 0xff;
 1000400:	00855793          	srli	a5,a0,0x8
 1000404:	4098                	lw	a4,0(s1)
 1000406:	0ff7f793          	andi	a5,a5,255
 100040a:	cf1c                	sw	a5,24(a4)
	uart_dev[index].reg->baud_low = divisor & 0xff;
 100040c:	409c                	lw	a5,0(s1)
 100040e:	0ff57513          	andi	a0,a0,255
 1000412:	cfc8                	sw	a0,28(a5)
	uart_dev[index].reg->enable |= 0xb0; // enable user define buadrate
 1000414:	4098                	lw	a4,0(s1)
 1000416:	431c                	lw	a5,0(a4)
 1000418:	0b07e793          	ori	a5,a5,176
 100041c:	c31c                	sw	a5,0(a4)
	if (uart_dev[index].rx_fifo.size) {
 100041e:	0084d783          	lhu	a5,8(s1)
 1000422:	cb8d                	beqz	a5,1000454 <uart_init+0x144>
		csi_vic_enable_irq(uart_dev[index].irq);
 1000424:	40dc                	lw	a5,4(s1)
  \details Enable a device-specific interrupt in the VIC interrupt controller.
  \param [in]      IRQn  External interrupt number. Value cannot be negative.
 */
__STATIC_INLINE void csi_vic_enable_irq(int32_t IRQn)
{
    CLIC->CLICINT[IRQn].IE |= CLIC_INTIE_IE_Msk;
 1000426:	40078793          	addi	a5,a5,1024
 100042a:	078a                	slli	a5,a5,0x2
 100042c:	e0800737          	lui	a4,0xe0800
 1000430:	973e                	add	a4,a4,a5
 1000432:	00174783          	lbu	a5,1(a4) # e0800001 <uart_dev+0xdf7ff241>
 1000436:	0ff7f793          	andi	a5,a5,255
 100043a:	0017e793          	ori	a5,a5,1
 100043e:	00f700a3          	sb	a5,1(a4)
	return true;
 1000442:	4505                	li	a0,1
}
 1000444:	40a2                	lw	ra,8(sp)
 1000446:	4412                	lw	s0,4(sp)
 1000448:	4482                	lw	s1,0(sp)
 100044a:	0131                	addi	sp,sp,12
 100044c:	8082                	ret
	uint8_t buad = UART_BAUD;
 100044e:	47bd                	li	a5,15
	uint8_t cfg = UART_CONFIG;
 1000450:	468d                	li	a3,3
 1000452:	b749                	j	10003d4 <uart_init+0xc4>
	return true;
 1000454:	4505                	li	a0,1
 1000456:	b7fd                	j	1000444 <uart_init+0x134>

01000458 <uart_irqhandler>:

void uart_irqhandler(int index, int tx) {
 1000458:	1121                	addi	sp,sp,-24
 100045a:	ca06                	sw	ra,20(sp)
 100045c:	c822                	sw	s0,16(sp)
 100045e:	c626                	sw	s1,12(sp)
 1000460:	c22a                	sw	a0,4(sp)
	uint32_t iflag;
	uart_reg_t* uart = uart_dev[index].reg;
 1000462:	00551793          	slli	a5,a0,0x5
 1000466:	1b018713          	addi	a4,gp,432 # 1000dc0 <uart_dev>
 100046a:	97ba                	add	a5,a5,a4
 100046c:	439c                	lw	a5,0(a5)
 100046e:	c03e                	sw	a5,0(sp)
	
	for (iflag = uart->int_err; iflag & 0x11; iflag = uart->int_err) {
 1000470:	4b80                	lw	s0,16(a5)
 1000472:	a035                	j	100049e <uart_irqhandler+0x46>
		uint32_t iclear = 0x0a;
		
		if (iflag & 0x10) {
			iclear &= ~0x08;
			if (0 == (iflag & 0x60)) {
				uint32_t data = uart->rx_data;
 1000474:	4782                	lw	a5,0(sp)
 1000476:	479c                	lw	a5,8(a5)
 1000478:	c43e                	sw	a5,8(sp)
				fifo_putc(&(uart_dev[index].rx_fifo), data);
 100047a:	4792                	lw	a5,4(sp)
 100047c:	00579513          	slli	a0,a5,0x5
 1000480:	1b018793          	addi	a5,gp,432 # 1000dc0 <uart_dev>
 1000484:	953e                	add	a0,a0,a5
 1000486:	4605                	li	a2,1
 1000488:	002c                	addi	a1,sp,8
 100048a:	0521                	addi	a0,a0,8
 100048c:	36c1                	jal	100004c <fifo_write>
			iclear &= ~0x08;
 100048e:	4489                	li	s1,2
 1000490:	a011                	j	1000494 <uart_irqhandler+0x3c>
		uint32_t iclear = 0x0a;
 1000492:	44a9                	li	s1,10
			}
		}
		if (iflag & 0x01) {
 1000494:	8805                	andi	s0,s0,1
 1000496:	ec19                	bnez	s0,10004b4 <uart_irqhandler+0x5c>
			if (fifo_getc(&(uart_dev[index].tx_fifo), data) == 1)
				uart->tx_data = data;
			if (fifo_is_empty(&uart_dev[index].tx_fifo))
				csi_vic_disable_irq(uart_dev[index].irq + 1);	// Disable tx interrupt if no data 
		}
		uart->int_err = iclear;
 1000498:	4782                	lw	a5,0(sp)
 100049a:	cb84                	sw	s1,16(a5)
	for (iflag = uart->int_err; iflag & 0x11; iflag = uart->int_err) {
 100049c:	4b80                	lw	s0,16(a5)
 100049e:	01147793          	andi	a5,s0,17
 10004a2:	cba5                	beqz	a5,1000512 <uart_irqhandler+0xba>
		if (iflag & 0x10) {
 10004a4:	01047793          	andi	a5,s0,16
 10004a8:	d7ed                	beqz	a5,1000492 <uart_irqhandler+0x3a>
			if (0 == (iflag & 0x60)) {
 10004aa:	06047793          	andi	a5,s0,96
 10004ae:	d3f9                	beqz	a5,1000474 <uart_irqhandler+0x1c>
			iclear &= ~0x08;
 10004b0:	4489                	li	s1,2
 10004b2:	b7cd                	j	1000494 <uart_irqhandler+0x3c>
			iclear &= ~0x02;
 10004b4:	98f5                	andi	s1,s1,-3
			if (fifo_getc(&(uart_dev[index].tx_fifo), data) == 1)
 10004b6:	4792                	lw	a5,4(sp)
 10004b8:	00579513          	slli	a0,a5,0x5
 10004bc:	0541                	addi	a0,a0,16
 10004be:	1b018793          	addi	a5,gp,432 # 1000dc0 <uart_dev>
 10004c2:	953e                	add	a0,a0,a5
 10004c4:	4605                	li	a2,1
 10004c6:	002c                	addi	a1,sp,8
 10004c8:	0511                	addi	a0,a0,4
 10004ca:	392d                	jal	1000104 <fifo_read>
 10004cc:	4785                	li	a5,1
 10004ce:	02f50e63          	beq	a0,a5,100050a <uart_irqhandler+0xb2>
			if (fifo_is_empty(&uart_dev[index].tx_fifo))
 10004d2:	4692                	lw	a3,4(sp)
 10004d4:	00569793          	slli	a5,a3,0x5
 10004d8:	1b018713          	addi	a4,gp,432 # 1000dc0 <uart_dev>
 10004dc:	97ba                	add	a5,a5,a4
 10004de:	01a7d783          	lhu	a5,26(a5)
 10004e2:	fbdd                	bnez	a5,1000498 <uart_irqhandler+0x40>
				csi_vic_disable_irq(uart_dev[index].irq + 1);	// Disable tx interrupt if no data 
 10004e4:	00569793          	slli	a5,a3,0x5
 10004e8:	1b018713          	addi	a4,gp,432 # 1000dc0 <uart_dev>
 10004ec:	97ba                	add	a5,a5,a4
 10004ee:	43dc                	lw	a5,4(a5)
  \details Disable a device-specific interrupt in the VIC interrupt controller.
  \param [in]      IRQn  External interrupt number. Value cannot be negative.
 */
__STATIC_INLINE void csi_vic_disable_irq(int32_t IRQn)
{
    CLIC->CLICINT[IRQn].IE &= ~CLIC_INTIE_IE_Msk;
 10004f0:	40178793          	addi	a5,a5,1025
 10004f4:	078a                	slli	a5,a5,0x2
 10004f6:	e0800737          	lui	a4,0xe0800
 10004fa:	97ba                	add	a5,a5,a4
 10004fc:	0017c703          	lbu	a4,1(a5)
 1000500:	0fe77713          	andi	a4,a4,254
 1000504:	00e780a3          	sb	a4,1(a5)
 1000508:	bf41                	j	1000498 <uart_irqhandler+0x40>
				uart->tx_data = data;
 100050a:	47a2                	lw	a5,8(sp)
 100050c:	4702                	lw	a4,0(sp)
 100050e:	c75c                	sw	a5,12(a4)
 1000510:	b7c9                	j	10004d2 <uart_irqhandler+0x7a>
	}
}
 1000512:	40d2                	lw	ra,20(sp)
 1000514:	4442                	lw	s0,16(sp)
 1000516:	44b2                	lw	s1,12(sp)
 1000518:	0161                	addi	sp,sp,24
 100051a:	8082                	ret

0100051c <uart_send>:

FIFO_SIZE_t uart_send(int index, const void *data, FIFO_SIZE_t size, int timeout) {
 100051c:	fdc10113          	addi	sp,sp,-36
 1000520:	d006                	sw	ra,32(sp)
 1000522:	ce22                	sw	s0,28(sp)
 1000524:	cc26                	sw	s1,24(sp)
 1000526:	c42a                	sw	a0,8(sp)
 1000528:	c62e                	sw	a1,12(sp)
 100052a:	c032                	sw	a2,0(sp)
	uart_reg_t* uart;
	FIFO_SIZE_t cnt = 0;
	const uint8_t* ptr = (const uint8_t*)data;
	uint32_t start;

	if (index >= CONFIG_UART_NUM || !size)
 100052c:	4785                	li	a5,1
 100052e:	12a7cb63          	blt	a5,a0,1000664 <uart_send+0x148>
 1000532:	84aa                	mv	s1,a0
 1000534:	8436                	mv	s0,a3
 1000536:	e601                	bnez	a2,100053e <uart_send+0x22>
		return 0;
 1000538:	4782                	lw	a5,0(sp)
 100053a:	c23e                	sw	a5,4(sp)
 100053c:	a22d                	j	1000666 <uart_send+0x14a>
	start = tick_count();
 100053e:	333d                	jal	100026c <tick_count>
 1000540:	c82a                	sw	a0,16(sp)
	uart = uart_dev[index].reg;
 1000542:	00549793          	slli	a5,s1,0x5
 1000546:	1b018713          	addi	a4,gp,432 # 1000dc0 <uart_dev>
 100054a:	97ba                	add	a5,a5,a4
 100054c:	4384                	lw	s1,0(a5)
	if (fifo_size(&(uart_dev[index].tx_fifo))) {
 100054e:	0147d783          	lhu	a5,20(a5)
 1000552:	c23e                	sw	a5,4(sp)
 1000554:	e7cd                	bnez	a5,10005fe <uart_send+0xe2>
				cnt += filled;
			}
		}
	}
	else {
		while (size) {
 1000556:	4782                	lw	a5,0(sp)
 1000558:	ebc5                	bnez	a5,1000608 <uart_send+0xec>
 100055a:	a231                	j	1000666 <uart_send+0x14a>
				FIFO_SIZE_t filled = fifo_write(&(uart_dev[index].tx_fifo), ptr, size);
 100055c:	47a2                	lw	a5,8(sp)
 100055e:	0796                	slli	a5,a5,0x5
 1000560:	c83e                	sw	a5,16(sp)
 1000562:	01078513          	addi	a0,a5,16
 1000566:	1b018413          	addi	s0,gp,432 # 1000dc0 <uart_dev>
 100056a:	9522                	add	a0,a0,s0
 100056c:	4602                	lw	a2,0(sp)
 100056e:	45b2                	lw	a1,12(sp)
 1000570:	0511                	addi	a0,a0,4
 1000572:	3ce9                	jal	100004c <fifo_write>
				if (fifo_len(&(uart_dev[index].tx_fifo)))
 1000574:	47c2                	lw	a5,16(sp)
 1000576:	943e                	add	s0,s0,a5
 1000578:	01a45783          	lhu	a5,26(s0)
 100057c:	c78d                	beqz	a5,10005a6 <uart_send+0x8a>
					csi_vic_enable_irq(uart_dev[index].irq + 1);
 100057e:	47a2                	lw	a5,8(sp)
 1000580:	0796                	slli	a5,a5,0x5
 1000582:	1b018713          	addi	a4,gp,432 # 1000dc0 <uart_dev>
 1000586:	97ba                	add	a5,a5,a4
 1000588:	43dc                	lw	a5,4(a5)
    CLIC->CLICINT[IRQn].IE |= CLIC_INTIE_IE_Msk;
 100058a:	40178793          	addi	a5,a5,1025
 100058e:	078a                	slli	a5,a5,0x2
 1000590:	e0800737          	lui	a4,0xe0800
 1000594:	973e                	add	a4,a4,a5
 1000596:	00174783          	lbu	a5,1(a4) # e0800001 <uart_dev+0xdf7ff241>
 100059a:	0ff7f793          	andi	a5,a5,255
 100059e:	0017e793          	ori	a5,a5,1
 10005a2:	00f700a3          	sb	a5,1(a4)
				ptr += filled;
 10005a6:	47b2                	lw	a5,12(sp)
 10005a8:	97aa                	add	a5,a5,a0
 10005aa:	c63e                	sw	a5,12(sp)
				size -= filled;
 10005ac:	4782                	lw	a5,0(sp)
 10005ae:	8f89                	sub	a5,a5,a0
 10005b0:	07c2                	slli	a5,a5,0x10
 10005b2:	83c1                	srli	a5,a5,0x10
 10005b4:	c03e                	sw	a5,0(sp)
				cnt += filled;
 10005b6:	4792                	lw	a5,4(sp)
 10005b8:	953e                	add	a0,a0,a5
 10005ba:	01051793          	slli	a5,a0,0x10
 10005be:	83c1                	srli	a5,a5,0x10
 10005c0:	c23e                	sw	a5,4(sp)
		while (size) {
 10005c2:	4782                	lw	a5,0(sp)
 10005c4:	c3cd                	beqz	a5,1000666 <uart_send+0x14a>
			if (fifo_is_full(&(uart_dev[index].tx_fifo))) {
 10005c6:	47a2                	lw	a5,8(sp)
 10005c8:	0796                	slli	a5,a5,0x5
 10005ca:	1b018713          	addi	a4,gp,432 # 1000dc0 <uart_dev>
 10005ce:	97ba                	add	a5,a5,a4
 10005d0:	0147d703          	lhu	a4,20(a5)
 10005d4:	01a7d783          	lhu	a5,26(a5)
 10005d8:	f8f712e3          	bne	a4,a5,100055c <uart_send+0x40>
				if (0 == (uart->state & 0x07)) {
 10005dc:	48dc                	lw	a5,20(s1)
 10005de:	8b9d                	andi	a5,a5,7
 10005e0:	f3ed                	bnez	a5,10005c2 <uart_send+0xa6>
					fifo_getc(&(uart_dev[index].tx_fifo), tmp);
 10005e2:	47a2                	lw	a5,8(sp)
 10005e4:	00579513          	slli	a0,a5,0x5
 10005e8:	0541                	addi	a0,a0,16
 10005ea:	1b018793          	addi	a5,gp,432 # 1000dc0 <uart_dev>
 10005ee:	953e                	add	a0,a0,a5
 10005f0:	4605                	li	a2,1
 10005f2:	084c                	addi	a1,sp,20
 10005f4:	0511                	addi	a0,a0,4
 10005f6:	3639                	jal	1000104 <fifo_read>
					uart->tx_data = tmp;
 10005f8:	47d2                	lw	a5,20(sp)
 10005fa:	c4dc                	sw	a5,12(s1)
 10005fc:	b7d9                	j	10005c2 <uart_send+0xa6>
	FIFO_SIZE_t cnt = 0;
 10005fe:	c202                	sw	zero,4(sp)
 1000600:	b7c9                	j	10005c2 <uart_send+0xa6>
			do {
				if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
					goto end;
			} while (uart->state & 0x07); // TX not idle
 1000602:	48dc                	lw	a5,20(s1)
 1000604:	8b9d                	andi	a5,a5,7
 1000606:	cb81                	beqz	a5,1000616 <uart_send+0xfa>
				if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
 1000608:	fe044de3          	bltz	s0,1000602 <uart_send+0xe6>
 100060c:	4542                	lw	a0,16(sp)
 100060e:	3961                	jal	10002a6 <tick_diff_ms>
 1000610:	fe8549e3          	blt	a0,s0,1000602 <uart_send+0xe6>
 1000614:	a889                	j	1000666 <uart_send+0x14a>
			uart->int_err &= ~0x02;
 1000616:	489c                	lw	a5,16(s1)
 1000618:	9bf5                	andi	a5,a5,-3
 100061a:	c89c                	sw	a5,16(s1)
			uart->tx_data = *ptr++;
 100061c:	47b2                	lw	a5,12(sp)
 100061e:	00178713          	addi	a4,a5,1
 1000622:	c43a                	sw	a4,8(sp)
 1000624:	0007c783          	lbu	a5,0(a5)
 1000628:	c4dc                	sw	a5,12(s1)
			size--;
 100062a:	4782                	lw	a5,0(sp)
 100062c:	17fd                	addi	a5,a5,-1
 100062e:	07c2                	slli	a5,a5,0x10
 1000630:	83c1                	srli	a5,a5,0x10
 1000632:	c03e                	sw	a5,0(sp)
			cnt++;
 1000634:	4792                	lw	a5,4(sp)
 1000636:	00178513          	addi	a0,a5,1
 100063a:	01051793          	slli	a5,a0,0x10
 100063e:	83c1                	srli	a5,a5,0x10
 1000640:	c23e                	sw	a5,4(sp)
 1000642:	a021                	j	100064a <uart_send+0x12e>
			do {
				if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
					goto end;
			} while (uart->int_err & 0x01); // TX finished
 1000644:	489c                	lw	a5,16(s1)
 1000646:	8b85                	andi	a5,a5,1
 1000648:	cb81                	beqz	a5,1000658 <uart_send+0x13c>
				if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
 100064a:	fe044de3          	bltz	s0,1000644 <uart_send+0x128>
 100064e:	4542                	lw	a0,16(sp)
 1000650:	3999                	jal	10002a6 <tick_diff_ms>
 1000652:	fe8549e3          	blt	a0,s0,1000644 <uart_send+0x128>
 1000656:	a801                	j	1000666 <uart_send+0x14a>
			uart->int_err &= ~0x02;
 1000658:	489c                	lw	a5,16(s1)
 100065a:	9bf5                	andi	a5,a5,-3
 100065c:	c89c                	sw	a5,16(s1)
			uart->tx_data = *ptr++;
 100065e:	47a2                	lw	a5,8(sp)
 1000660:	c63e                	sw	a5,12(sp)
 1000662:	bdd5                	j	1000556 <uart_send+0x3a>
		return 0;
 1000664:	c202                	sw	zero,4(sp)
		}
	}
end:
	return cnt;
}
 1000666:	4512                	lw	a0,4(sp)
 1000668:	5082                	lw	ra,32(sp)
 100066a:	4472                	lw	s0,28(sp)
 100066c:	44e2                	lw	s1,24(sp)
 100066e:	02410113          	addi	sp,sp,36
 1000672:	8082                	ret

01000674 <uart_receive>:

FIFO_SIZE_t uart_receive(int index, void *data, FIFO_SIZE_t size, int timeout) {
 1000674:	1101                	addi	sp,sp,-32
 1000676:	ce06                	sw	ra,28(sp)
 1000678:	cc22                	sw	s0,24(sp)
 100067a:	ca26                	sw	s1,20(sp)
 100067c:	c236                	sw	a3,4(sp)
	uart_reg_t* uart;
	FIFO_SIZE_t cnt = 0;
	uint8_t* ptr = (uint8_t*)data;
	uint32_t start;

	if (index >= CONFIG_UART_NUM || !size)
 100067e:	4785                	li	a5,1
 1000680:	c42a                	sw	a0,8(sp)
 1000682:	0aa7c463          	blt	a5,a0,100072a <uart_receive+0xb6>
 1000686:	84ae                	mv	s1,a1
 1000688:	8432                	mv	s0,a2
 100068a:	e219                	bnez	a2,1000690 <uart_receive+0x1c>
		return 0;
 100068c:	c032                	sw	a2,0(sp)
 100068e:	a879                	j	100072c <uart_receive+0xb8>
	start = tick_count();
 1000690:	3ef1                	jal	100026c <tick_count>
 1000692:	c82a                	sw	a0,16(sp)
	uart = uart_dev[index].reg;
 1000694:	4722                	lw	a4,8(sp)
 1000696:	00571793          	slli	a5,a4,0x5
 100069a:	1b018713          	addi	a4,gp,432 # 1000dc0 <uart_dev>
 100069e:	97ba                	add	a5,a5,a4
 10006a0:	4398                	lw	a4,0(a5)
 10006a2:	c63a                	sw	a4,12(sp)
	if (fifo_size(&(uart_dev[index].rx_fifo))) {
 10006a4:	0087d783          	lhu	a5,8(a5)
 10006a8:	c03e                	sw	a5,0(sp)
 10006aa:	c3b9                	beqz	a5,10006f0 <uart_receive+0x7c>
	FIFO_SIZE_t cnt = 0;
 10006ac:	c002                	sw	zero,0(sp)
		while (size) {
 10006ae:	cc3d                	beqz	s0,100072c <uart_receive+0xb8>
			FIFO_SIZE_t read = fifo_read(&(uart_dev[index].rx_fifo), ptr, size);
 10006b0:	47a2                	lw	a5,8(sp)
 10006b2:	00579513          	slli	a0,a5,0x5
 10006b6:	1b018793          	addi	a5,gp,432 # 1000dc0 <uart_dev>
 10006ba:	953e                	add	a0,a0,a5
 10006bc:	8622                	mv	a2,s0
 10006be:	85a6                	mv	a1,s1
 10006c0:	0521                	addi	a0,a0,8
 10006c2:	3489                	jal	1000104 <fifo_read>
			ptr += read;
 10006c4:	94aa                	add	s1,s1,a0
			size -= read;
 10006c6:	8c09                	sub	s0,s0,a0
 10006c8:	0442                	slli	s0,s0,0x10
 10006ca:	8041                	srli	s0,s0,0x10
			cnt += read;
 10006cc:	4782                	lw	a5,0(sp)
 10006ce:	953e                	add	a0,a0,a5
 10006d0:	01051793          	slli	a5,a0,0x10
 10006d4:	83c1                	srli	a5,a5,0x10
 10006d6:	c03e                	sw	a5,0(sp)
			if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
 10006d8:	4792                	lw	a5,4(sp)
 10006da:	fc07cae3          	bltz	a5,10006ae <uart_receive+0x3a>
 10006de:	4542                	lw	a0,16(sp)
 10006e0:	36d9                	jal	10002a6 <tick_diff_ms>
 10006e2:	4792                	lw	a5,4(sp)
 10006e4:	fcf545e3          	blt	a0,a5,10006ae <uart_receive+0x3a>
 10006e8:	a091                	j	100072c <uart_receive+0xb8>
				*ptr++ = (uint8_t)uart->rx_data;
				uart->int_err &= ~0x10;
				size--;
				cnt++;
			}
			if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
 10006ea:	4792                	lw	a5,4(sp)
 10006ec:	0207d963          	bgez	a5,100071e <uart_receive+0xaa>
		while (size) {
 10006f0:	cc15                	beqz	s0,100072c <uart_receive+0xb8>
			if ((uart->int_err & 0x10) == 0x10) {
 10006f2:	4732                	lw	a4,12(sp)
 10006f4:	4b1c                	lw	a5,16(a4)
 10006f6:	8bc1                	andi	a5,a5,16
 10006f8:	dbed                	beqz	a5,10006ea <uart_receive+0x76>
				*ptr++ = (uint8_t)uart->rx_data;
 10006fa:	471c                	lw	a5,8(a4)
 10006fc:	00f48023          	sb	a5,0(s1)
				uart->int_err &= ~0x10;
 1000700:	4b1c                	lw	a5,16(a4)
 1000702:	9bbd                	andi	a5,a5,-17
 1000704:	cb1c                	sw	a5,16(a4)
				size--;
 1000706:	147d                	addi	s0,s0,-1
 1000708:	0442                	slli	s0,s0,0x10
 100070a:	8041                	srli	s0,s0,0x10
				cnt++;
 100070c:	4782                	lw	a5,0(sp)
 100070e:	00178513          	addi	a0,a5,1
 1000712:	01051793          	slli	a5,a0,0x10
 1000716:	83c1                	srli	a5,a5,0x10
 1000718:	c03e                	sw	a5,0(sp)
				*ptr++ = (uint8_t)uart->rx_data;
 100071a:	0485                	addi	s1,s1,1
 100071c:	b7f9                	j	10006ea <uart_receive+0x76>
			if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
 100071e:	4542                	lw	a0,16(sp)
 1000720:	3659                	jal	10002a6 <tick_diff_ms>
 1000722:	4792                	lw	a5,4(sp)
 1000724:	fcf546e3          	blt	a0,a5,10006f0 <uart_receive+0x7c>
 1000728:	a011                	j	100072c <uart_receive+0xb8>
		return 0;
 100072a:	c002                	sw	zero,0(sp)
				break;
		}
	}
	return cnt;
}
 100072c:	4502                	lw	a0,0(sp)
 100072e:	40f2                	lw	ra,28(sp)
 1000730:	4462                	lw	s0,24(sp)
 1000732:	44d2                	lw	s1,20(sp)
 1000734:	6105                	addi	sp,sp,32
 1000736:	8082                	ret

01000738 <SystemInit>:
  *         Initialize the psr and vbr.
  * @param  None
  * @return None
  */
void SystemInit(void)
{
 1000738:	1151                	addi	sp,sp,-12
 100073a:	c406                	sw	ra,8(sp)
 */
__ALWAYS_STATIC_INLINE uint32_t __get_MXSTATUS(void)
{
    uint32_t result;

    __ASM volatile("csrr %0, mxstatus" : "=r"(result));
 100073c:	7c0027f3          	csrr	a5,mxstatus
    /* enable mxstatus THEADISAEE */
    uint32_t mxstatus = __get_MXSTATUS();
    mxstatus |= (1 << 22);
 1000740:	00400737          	lui	a4,0x400
 1000744:	8fd9                	or	a5,a5,a4
  \details Writes the given value to the MXSTATUS Register.
  \param [in]    mxstatus  MXSTATUS Register value to set
 */
__ALWAYS_STATIC_INLINE void __set_MXSTATUS(uint32_t mxstatus)
{
    __ASM volatile("csrw mxstatus, %0" : : "r"(mxstatus));
 1000746:	7c079073          	csrw	mxstatus,a5
    __set_MXSTATUS(mxstatus);

    /* get interrupt level from info */
    CLIC->CLICCFG = (((CLIC->CLICINFO & CLIC_INFO_CLICINTCTLBITS_Msk) >> CLIC_INFO_CLICINTCTLBITS_Pos) << CLIC_CLICCFG_NLBIT_Pos);
 100074a:	e0800737          	lui	a4,0xe0800
 100074e:	435c                	lw	a5,4(a4)
 1000750:	83d5                	srli	a5,a5,0x15
 1000752:	0786                	slli	a5,a5,0x1
 1000754:	8bf9                	andi	a5,a5,30
 1000756:	00f70023          	sb	a5,0(a4) # e0800000 <uart_dev+0xdf7ff240>

    for (int i = 0; i < 64; i++) {
 100075a:	4701                	li	a4,0
 100075c:	03f00793          	li	a5,63
 1000760:	02e7c063          	blt	a5,a4,1000780 <SystemInit+0x48>
        CLIC->CLICINT[i].IP = 0;
 1000764:	40070793          	addi	a5,a4,1024
 1000768:	00279693          	slli	a3,a5,0x2
 100076c:	e08007b7          	lui	a5,0xe0800
 1000770:	97b6                	add	a5,a5,a3
 1000772:	00078023          	sb	zero,0(a5) # e0800000 <uart_dev+0xdf7ff240>
        CLIC->CLICINT[i].ATTR = 1; /* use vector interrupt */
 1000776:	4685                	li	a3,1
 1000778:	00d78123          	sb	a3,2(a5)
    for (int i = 0; i < 64; i++) {
 100077c:	0705                	addi	a4,a4,1
 100077e:	bff9                	j	100075c <SystemInit+0x24>
    }

    /* tspend use positive interrupt */
    CLIC->CLICINT[Machine_Software_IRQn].ATTR = 0x3;
 1000780:	e0801737          	lui	a4,0xe0801
 1000784:	478d                	li	a5,3
 1000786:	00f70723          	sb	a5,14(a4) # e080100e <uart_dev+0xdf80024e>
 100078a:	00d74783          	lbu	a5,13(a4)
 100078e:	0ff7f793          	andi	a5,a5,255
 1000792:	0017e793          	ori	a5,a5,1
 1000796:	00f706a3          	sb	a5,13(a4)

    //csi_icache_enable();
    csi_vic_enable_irq(Machine_Software_IRQn);
	
	stc_init();
 100079a:	3c9d                	jal	1000210 <stc_init>
           function <b>SysTick_Config</b> is not included. In this case, the file <b><i>device</i>.h</b>
           must contain a vendor-specific implementation of this function.
 */
__STATIC_INLINE void csi_coret_config(uint32_t ticks)
{
    if (CORET->MTIMECMP) {
 100079c:	e00047b7          	lui	a5,0xe0004
 10007a0:	4398                	lw	a4,0(a5)
 10007a2:	43dc                	lw	a5,4(a5)
 10007a4:	00f766b3          	or	a3,a4,a5
 10007a8:	c68d                	beqz	a3,10007d2 <SystemInit+0x9a>
        CORET->MTIMECMP = CORET->MTIMECMP + ticks;
 10007aa:	e0004737          	lui	a4,0xe0004
 10007ae:	00072303          	lw	t1,0(a4) # e0004000 <uart_dev+0xdf003240>
 10007b2:	00472383          	lw	t2,4(a4)
 10007b6:	000277b7          	lui	a5,0x27
 10007ba:	10078793          	addi	a5,a5,256 # 27100 <Reset_Handler-0xfd8f00>
 10007be:	979a                	add	a5,a5,t1
 10007c0:	0067b533          	sltu	a0,a5,t1
 10007c4:	007506b3          	add	a3,a0,t2
 10007c8:	c31c                	sw	a5,0(a4)
 10007ca:	c354                	sw	a3,4(a4)
#if CONFIG_HAVE_VIC
    __enable_excp_irq();
#endif
    csi_coret_config(SYSTEM_CLOCK / CONFIG_SYSTICK_HZ); 
}
 10007cc:	40a2                	lw	ra,8(sp)
 10007ce:	0131                	addi	sp,sp,12
 10007d0:	8082                	ret
    } else {
        CORET->MTIMECMP = CORET->MTIME + ticks;
 10007d2:	e000c7b7          	lui	a5,0xe000c
 10007d6:	ff87a503          	lw	a0,-8(a5) # e000bff8 <uart_dev+0xdf00b238>
 10007da:	ffc7a583          	lw	a1,-4(a5)
 10007de:	000277b7          	lui	a5,0x27
 10007e2:	10078793          	addi	a5,a5,256 # 27100 <Reset_Handler-0xfd8f00>
 10007e6:	97aa                	add	a5,a5,a0
 10007e8:	00a7b733          	sltu	a4,a5,a0
 10007ec:	863e                	mv	a2,a5
 10007ee:	00b706b3          	add	a3,a4,a1
 10007f2:	e00047b7          	lui	a5,0xe0004
 10007f6:	c390                	sw	a2,0(a5)
 10007f8:	c3d4                	sw	a3,4(a5)
 10007fa:	bfc9                	j	10007cc <SystemInit+0x94>

010007fc <board_init>:
#include "console.h"

void board_init(void)
{
 10007fc:	1151                	addi	sp,sp,-12
 10007fe:	c406                	sw	ra,8(sp)
    /* init the console*/
    console_init();
 1000800:	2021                	jal	1000808 <console_init>
}
 1000802:	40a2                	lw	ra,8(sp)
 1000804:	0131                	addi	sp,sp,12
 1000806:	8082                	ret

01000808 <console_init>:

static int console_handle;
#ifdef CONFIG_CONSOLE_RXSIZE
static uint8_t console_buffer[CONFIG_CONSOLE_RXSIZE + CONFIG_CONSOLE_TXSIZE];
#endif
void console_init(void) {
 1000808:	1151                	addi	sp,sp,-12
 100080a:	c406                	sw	ra,8(sp)
	config.tsize = CONFIG_CONSOLE_TXSIZE;
	config.cfg = UART_CONFIG;
	config.buad = UART_BAUD;
	uart_init(CONFIG_CONSOLE_HANDLE, &config);
#else
	uart_init(CONFIG_CONSOLE_HANDLE, 0);
 100080c:	4581                	li	a1,0
 100080e:	4501                	li	a0,0
 1000810:	3601                	jal	1000310 <uart_init>
#endif
	console_handle = CONFIG_CONSOLE_HANDLE;
 1000812:	0201a023          	sw	zero,32(gp) # 1000c30 <console_handle>
}
 1000816:	40a2                	lw	ra,8(sp)
 1000818:	0131                	addi	sp,sp,12
 100081a:	8082                	ret

0100081c <getchar>:
	if (uart_send(console_handle, &ch, 1, CONFIG_CONSOLE_TXTIMEOUT) != 1)
		return CONSOLE_EOF;
	return 1;
}

int getchar(void) {
 100081c:	1141                	addi	sp,sp,-16
 100081e:	c606                	sw	ra,12(sp)
	uint8_t ch;

	if (uart_receive(console_handle, &ch, 1, CONFIG_CONSOLE_RXTIMEOUT) != 1)
 1000820:	4685                	li	a3,1
 1000822:	4605                	li	a2,1
 1000824:	00310593          	addi	a1,sp,3
 1000828:	0201a503          	lw	a0,32(gp) # 1000c30 <console_handle>
 100082c:	35a1                	jal	1000674 <uart_receive>
 100082e:	4785                	li	a5,1
 1000830:	00f51763          	bne	a0,a5,100083e <getchar+0x22>
		return CONSOLE_EOF;
	return (int)ch;
 1000834:	00314503          	lbu	a0,3(sp)
}
 1000838:	40b2                	lw	ra,12(sp)
 100083a:	0141                	addi	sp,sp,16
 100083c:	8082                	ret
		return CONSOLE_EOF;
 100083e:	557d                	li	a0,-1
 1000840:	bfe5                	j	1000838 <getchar+0x1c>

01000842 <putchar>:

int putchar(int ch) {
 1000842:	1141                	addi	sp,sp,-16
 1000844:	c606                	sw	ra,12(sp)
 1000846:	c422                	sw	s0,8(sp)
 1000848:	842a                	mv	s0,a0
	if (ch == '\n') {
 100084a:	47a9                	li	a5,10
 100084c:	02f50163          	beq	a0,a5,100086e <putchar+0x2c>
		if (_putc('\r') != 1)
			return CONSOLE_EOF;
	}
	return _putc(ch);
 1000850:	c022                	sw	s0,0(sp)
	if (uart_send(console_handle, &ch, 1, CONFIG_CONSOLE_TXTIMEOUT) != 1)
 1000852:	4685                	li	a3,1
 1000854:	4605                	li	a2,1
 1000856:	858a                	mv	a1,sp
 1000858:	0201a503          	lw	a0,32(gp) # 1000c30 <console_handle>
 100085c:	31c1                	jal	100051c <uart_send>
 100085e:	4785                	li	a5,1
 1000860:	02f51463          	bne	a0,a5,1000888 <putchar+0x46>
	return 1;
 1000864:	4505                	li	a0,1
}
 1000866:	40b2                	lw	ra,12(sp)
 1000868:	4422                	lw	s0,8(sp)
 100086a:	0141                	addi	sp,sp,16
 100086c:	8082                	ret
		if (_putc('\r') != 1)
 100086e:	47b5                	li	a5,13
 1000870:	c03e                	sw	a5,0(sp)
	if (uart_send(console_handle, &ch, 1, CONFIG_CONSOLE_TXTIMEOUT) != 1)
 1000872:	4685                	li	a3,1
 1000874:	4605                	li	a2,1
 1000876:	858a                	mv	a1,sp
 1000878:	0201a503          	lw	a0,32(gp) # 1000c30 <console_handle>
 100087c:	3145                	jal	100051c <uart_send>
 100087e:	4785                	li	a5,1
 1000880:	fcf508e3          	beq	a0,a5,1000850 <putchar+0xe>
			return CONSOLE_EOF;
 1000884:	557d                	li	a0,-1
 1000886:	b7c5                	j	1000866 <putchar+0x24>
		return CONSOLE_EOF;
 1000888:	557d                	li	a0,-1
	return _putc(ch);
 100088a:	bff1                	j	1000866 <putchar+0x24>

0100088c <puts>:

int puts(const char * str) {
 100088c:	1151                	addi	sp,sp,-12
 100088e:	c406                	sw	ra,8(sp)
 1000890:	c222                	sw	s0,4(sp)
 1000892:	c026                	sw	s1,0(sp)
 1000894:	842a                	mv	s0,a0
	int cnt = 0;
 1000896:	4481                	li	s1,0
	while (*str) {
 1000898:	00044503          	lbu	a0,0(s0)
 100089c:	c901                	beqz	a0,10008ac <puts+0x20>
		if (putchar(*str++) != 1)
 100089e:	0405                	addi	s0,s0,1
 10008a0:	374d                	jal	1000842 <putchar>
 10008a2:	4785                	li	a5,1
 10008a4:	00f51463          	bne	a0,a5,10008ac <puts+0x20>
			break;
		cnt++;
 10008a8:	0485                	addi	s1,s1,1
 10008aa:	b7fd                	j	1000898 <puts+0xc>
	}
	return cnt;
}
 10008ac:	8526                	mv	a0,s1
 10008ae:	40a2                	lw	ra,8(sp)
 10008b0:	4412                	lw	s0,4(sp)
 10008b2:	4482                	lw	s1,0(sp)
 10008b4:	0131                	addi	sp,sp,12
 10008b6:	8082                	ret

010008b8 <put_h8>:
}

#else

static const char HEX_TABLE[] = {"0123456789ABCDEF"};
int put_h8(uint8_t byte) {
 10008b8:	1141                	addi	sp,sp,-16
 10008ba:	c606                	sw	ra,12(sp)
 10008bc:	c422                	sw	s0,8(sp)
 10008be:	842a                	mv	s0,a0
	if (_putc(HEX_TABLE[(byte >> 4) & 0x0F]) != 1)
 10008c0:	00455713          	srli	a4,a0,0x4
 10008c4:	fbc18793          	addi	a5,gp,-68 # 1000bcc <HEX_TABLE>
 10008c8:	97ba                	add	a5,a5,a4
 10008ca:	0007c783          	lbu	a5,0(a5) # e0004000 <uart_dev+0xdf003240>
 10008ce:	c03e                	sw	a5,0(sp)
	if (uart_send(console_handle, &ch, 1, CONFIG_CONSOLE_TXTIMEOUT) != 1)
 10008d0:	4685                	li	a3,1
 10008d2:	4605                	li	a2,1
 10008d4:	858a                	mv	a1,sp
 10008d6:	0201a503          	lw	a0,32(gp) # 1000c30 <console_handle>
 10008da:	3189                	jal	100051c <uart_send>
 10008dc:	4785                	li	a5,1
 10008de:	02f51463          	bne	a0,a5,1000906 <put_h8+0x4e>
		return CONSOLE_EOF;
	if (_putc(HEX_TABLE[byte & 0x0F]) != 1)
 10008e2:	883d                	andi	s0,s0,15
 10008e4:	fbc18793          	addi	a5,gp,-68 # 1000bcc <HEX_TABLE>
 10008e8:	943e                	add	s0,s0,a5
 10008ea:	00044783          	lbu	a5,0(s0)
 10008ee:	c03e                	sw	a5,0(sp)
	if (uart_send(console_handle, &ch, 1, CONFIG_CONSOLE_TXTIMEOUT) != 1)
 10008f0:	4685                	li	a3,1
 10008f2:	4605                	li	a2,1
 10008f4:	858a                	mv	a1,sp
 10008f6:	0201a503          	lw	a0,32(gp) # 1000c30 <console_handle>
 10008fa:	310d                	jal	100051c <uart_send>
 10008fc:	4785                	li	a5,1
 10008fe:	00f51963          	bne	a0,a5,1000910 <put_h8+0x58>
		return CONSOLE_EOF;
	return 2;
 1000902:	4509                	li	a0,2
 1000904:	a011                	j	1000908 <put_h8+0x50>
		return CONSOLE_EOF;
 1000906:	557d                	li	a0,-1
}
 1000908:	40b2                	lw	ra,12(sp)
 100090a:	4422                	lw	s0,8(sp)
 100090c:	0141                	addi	sp,sp,16
 100090e:	8082                	ret
		return CONSOLE_EOF;
 1000910:	557d                	li	a0,-1
 1000912:	bfdd                	j	1000908 <put_h8+0x50>

01000914 <put_h16>:

int put_h16(uint16_t word) {
 1000914:	1151                	addi	sp,sp,-12
 1000916:	c406                	sw	ra,8(sp)
 1000918:	c222                	sw	s0,4(sp)
 100091a:	842a                	mv	s0,a0
	if (put_h8(word >> 8) != 2)
 100091c:	8121                	srli	a0,a0,0x8
 100091e:	3f69                	jal	10008b8 <put_h8>
 1000920:	4789                	li	a5,2
 1000922:	00f51d63          	bne	a0,a5,100093c <put_h16+0x28>
		return CONSOLE_EOF;
	if (put_h8(word) != 2)
 1000926:	0ff47513          	andi	a0,s0,255
 100092a:	3779                	jal	10008b8 <put_h8>
 100092c:	4789                	li	a5,2
 100092e:	00f51963          	bne	a0,a5,1000940 <put_h16+0x2c>
		return CONSOLE_EOF;
	return 4;
 1000932:	4511                	li	a0,4
}
 1000934:	40a2                	lw	ra,8(sp)
 1000936:	4412                	lw	s0,4(sp)
 1000938:	0131                	addi	sp,sp,12
 100093a:	8082                	ret
		return CONSOLE_EOF;
 100093c:	557d                	li	a0,-1
 100093e:	bfdd                	j	1000934 <put_h16+0x20>
		return CONSOLE_EOF;
 1000940:	557d                	li	a0,-1
 1000942:	bfcd                	j	1000934 <put_h16+0x20>

01000944 <put_h32>:

int put_h32(uint32_t dword) {
 1000944:	1151                	addi	sp,sp,-12
 1000946:	c406                	sw	ra,8(sp)
 1000948:	c222                	sw	s0,4(sp)
 100094a:	842a                	mv	s0,a0
	if (put_h16(dword >> 16) != 4)
 100094c:	8141                	srli	a0,a0,0x10
 100094e:	37d9                	jal	1000914 <put_h16>
 1000950:	4791                	li	a5,4
 1000952:	00f51e63          	bne	a0,a5,100096e <put_h32+0x2a>
		return CONSOLE_EOF;
	if (put_h16(dword) != 4)
 1000956:	01041513          	slli	a0,s0,0x10
 100095a:	8141                	srli	a0,a0,0x10
 100095c:	3f65                	jal	1000914 <put_h16>
 100095e:	4791                	li	a5,4
 1000960:	00f51963          	bne	a0,a5,1000972 <put_h32+0x2e>
		return CONSOLE_EOF;
	return 8;
 1000964:	4521                	li	a0,8
}
 1000966:	40a2                	lw	ra,8(sp)
 1000968:	4412                	lw	s0,4(sp)
 100096a:	0131                	addi	sp,sp,12
 100096c:	8082                	ret
		return CONSOLE_EOF;
 100096e:	557d                	li	a0,-1
 1000970:	bfdd                	j	1000966 <put_h32+0x22>
		return CONSOLE_EOF;
 1000972:	557d                	li	a0,-1
 1000974:	bfcd                	j	1000966 <put_h32+0x22>
	...

01000978 <__divsi3>:
 1000978:	02054e63          	bltz	a0,10009b4 <__umodsi3+0x8>
 100097c:	0405c363          	bltz	a1,10009c2 <__umodsi3+0x16>

01000980 <__udivsi3>:
 1000980:	862e                	mv	a2,a1
 1000982:	85aa                	mv	a1,a0
 1000984:	557d                	li	a0,-1
 1000986:	c215                	beqz	a2,10009aa <__udivsi3+0x2a>
 1000988:	4685                	li	a3,1
 100098a:	00b67863          	bgeu	a2,a1,100099a <__udivsi3+0x1a>
 100098e:	00c05663          	blez	a2,100099a <__udivsi3+0x1a>
 1000992:	0606                	slli	a2,a2,0x1
 1000994:	0686                	slli	a3,a3,0x1
 1000996:	feb66ce3          	bltu	a2,a1,100098e <__udivsi3+0xe>
 100099a:	4501                	li	a0,0
 100099c:	00c5e463          	bltu	a1,a2,10009a4 <__udivsi3+0x24>
 10009a0:	8d91                	sub	a1,a1,a2
 10009a2:	8d55                	or	a0,a0,a3
 10009a4:	8285                	srli	a3,a3,0x1
 10009a6:	8205                	srli	a2,a2,0x1
 10009a8:	faf5                	bnez	a3,100099c <__udivsi3+0x1c>
 10009aa:	8082                	ret

010009ac <__umodsi3>:
 10009ac:	8286                	mv	t0,ra
 10009ae:	3fc9                	jal	1000980 <__udivsi3>
 10009b0:	852e                	mv	a0,a1
 10009b2:	8282                	jr	t0
 10009b4:	40a00533          	neg	a0,a0
 10009b8:	0005d763          	bgez	a1,10009c6 <__umodsi3+0x1a>
 10009bc:	40b005b3          	neg	a1,a1
 10009c0:	b7c1                	j	1000980 <__udivsi3>
 10009c2:	40b005b3          	neg	a1,a1
 10009c6:	8286                	mv	t0,ra
 10009c8:	3f65                	jal	1000980 <__udivsi3>
 10009ca:	40a00533          	neg	a0,a0
 10009ce:	8282                	jr	t0

010009d0 <__modsi3>:
 10009d0:	8286                	mv	t0,ra
 10009d2:	0005c763          	bltz	a1,10009e0 <__modsi3+0x10>
 10009d6:	00054963          	bltz	a0,10009e8 <__modsi3+0x18>
 10009da:	375d                	jal	1000980 <__udivsi3>
 10009dc:	852e                	mv	a0,a1
 10009de:	8282                	jr	t0
 10009e0:	40b005b3          	neg	a1,a1
 10009e4:	fe055be3          	bgez	a0,10009da <__modsi3+0xa>
 10009e8:	40a00533          	neg	a0,a0
 10009ec:	3f51                	jal	1000980 <__udivsi3>
 10009ee:	40b00533          	neg	a0,a1
 10009f2:	8282                	jr	t0
 10009f4:	0000                	unimp
	...

010009f8 <memcpy>:
 10009f8:	00a5c7b3          	xor	a5,a1,a0
 10009fc:	8b8d                	andi	a5,a5,3
 10009fe:	00c50733          	add	a4,a0,a2
 1000a02:	e781                	bnez	a5,1000a0a <memcpy+0x12>
 1000a04:	478d                	li	a5,3
 1000a06:	02c7e963          	bltu	a5,a2,1000a38 <memcpy+0x40>
 1000a0a:	87aa                	mv	a5,a0
 1000a0c:	0ce57163          	bgeu	a0,a4,1000ace <memcpy+0xd6>
 1000a10:	0005c683          	lbu	a3,0(a1)
 1000a14:	0785                	addi	a5,a5,1
 1000a16:	0585                	addi	a1,a1,1
 1000a18:	fed78fa3          	sb	a3,-1(a5)
 1000a1c:	fee7eae3          	bltu	a5,a4,1000a10 <memcpy+0x18>
 1000a20:	8082                	ret
 1000a22:	0005c683          	lbu	a3,0(a1)
 1000a26:	0785                	addi	a5,a5,1
 1000a28:	0585                	addi	a1,a1,1
 1000a2a:	fed78fa3          	sb	a3,-1(a5)
 1000a2e:	fee7eae3          	bltu	a5,a4,1000a22 <memcpy+0x2a>
 1000a32:	4402                	lw	s0,0(sp)
 1000a34:	0111                	addi	sp,sp,4
 1000a36:	8082                	ret
 1000a38:	00357693          	andi	a3,a0,3
 1000a3c:	87aa                	mv	a5,a0
 1000a3e:	ca91                	beqz	a3,1000a52 <memcpy+0x5a>
 1000a40:	0005c683          	lbu	a3,0(a1)
 1000a44:	0785                	addi	a5,a5,1
 1000a46:	0585                	addi	a1,a1,1
 1000a48:	fed78fa3          	sb	a3,-1(a5)
 1000a4c:	0037f693          	andi	a3,a5,3
 1000a50:	b7fd                	j	1000a3e <memcpy+0x46>
 1000a52:	ffc77693          	andi	a3,a4,-4
 1000a56:	fe068613          	addi	a2,a3,-32
 1000a5a:	06c7f563          	bgeu	a5,a2,1000ac4 <memcpy+0xcc>
 1000a5e:	1171                	addi	sp,sp,-4
 1000a60:	c022                	sw	s0,0(sp)
 1000a62:	49c0                	lw	s0,20(a1)
 1000a64:	0005a303          	lw	t1,0(a1)
 1000a68:	0085a383          	lw	t2,8(a1)
 1000a6c:	cbc0                	sw	s0,20(a5)
 1000a6e:	4d80                	lw	s0,24(a1)
 1000a70:	0067a023          	sw	t1,0(a5)
 1000a74:	0045a303          	lw	t1,4(a1)
 1000a78:	cf80                	sw	s0,24(a5)
 1000a7a:	4dc0                	lw	s0,28(a1)
 1000a7c:	0067a223          	sw	t1,4(a5)
 1000a80:	00c5a283          	lw	t0,12(a1)
 1000a84:	0105a303          	lw	t1,16(a1)
 1000a88:	02458593          	addi	a1,a1,36
 1000a8c:	cfc0                	sw	s0,28(a5)
 1000a8e:	ffc5a403          	lw	s0,-4(a1)
 1000a92:	0077a423          	sw	t2,8(a5)
 1000a96:	0057a623          	sw	t0,12(a5)
 1000a9a:	0067a823          	sw	t1,16(a5)
 1000a9e:	02478793          	addi	a5,a5,36
 1000aa2:	fe87ae23          	sw	s0,-4(a5)
 1000aa6:	fac7eee3          	bltu	a5,a2,1000a62 <memcpy+0x6a>
 1000aaa:	f8d7f2e3          	bgeu	a5,a3,1000a2e <memcpy+0x36>
 1000aae:	4190                	lw	a2,0(a1)
 1000ab0:	0791                	addi	a5,a5,4
 1000ab2:	0591                	addi	a1,a1,4
 1000ab4:	fec7ae23          	sw	a2,-4(a5)
 1000ab8:	bfcd                	j	1000aaa <memcpy+0xb2>
 1000aba:	4190                	lw	a2,0(a1)
 1000abc:	0791                	addi	a5,a5,4
 1000abe:	0591                	addi	a1,a1,4
 1000ac0:	fec7ae23          	sw	a2,-4(a5)
 1000ac4:	fed7ebe3          	bltu	a5,a3,1000aba <memcpy+0xc2>
 1000ac8:	f4e7e4e3          	bltu	a5,a4,1000a10 <memcpy+0x18>
 1000acc:	8082                	ret
 1000ace:	8082                	ret
 1000ad0:	0000                	unimp
	...

01000ad4 <memset>:
 1000ad4:	433d                	li	t1,15
 1000ad6:	872a                	mv	a4,a0
 1000ad8:	02c37363          	bgeu	t1,a2,1000afe <memset+0x2a>
 1000adc:	00f77793          	andi	a5,a4,15
 1000ae0:	efbd                	bnez	a5,1000b5e <memset+0x8a>
 1000ae2:	e5ad                	bnez	a1,1000b4c <memset+0x78>
 1000ae4:	ff067693          	andi	a3,a2,-16
 1000ae8:	8a3d                	andi	a2,a2,15
 1000aea:	96ba                	add	a3,a3,a4
 1000aec:	c30c                	sw	a1,0(a4)
 1000aee:	c34c                	sw	a1,4(a4)
 1000af0:	c70c                	sw	a1,8(a4)
 1000af2:	c74c                	sw	a1,12(a4)
 1000af4:	0741                	addi	a4,a4,16
 1000af6:	fed76be3          	bltu	a4,a3,1000aec <memset+0x18>
 1000afa:	e211                	bnez	a2,1000afe <memset+0x2a>
 1000afc:	8082                	ret
 1000afe:	40c306b3          	sub	a3,t1,a2
 1000b02:	068a                	slli	a3,a3,0x2
 1000b04:	00000297          	auipc	t0,0x0
 1000b08:	9696                	add	a3,a3,t0
 1000b0a:	00a68067          	jr	10(a3)
 1000b0e:	00b70723          	sb	a1,14(a4)
 1000b12:	00b706a3          	sb	a1,13(a4)
 1000b16:	00b70623          	sb	a1,12(a4)
 1000b1a:	00b705a3          	sb	a1,11(a4)
 1000b1e:	00b70523          	sb	a1,10(a4)
 1000b22:	00b704a3          	sb	a1,9(a4)
 1000b26:	00b70423          	sb	a1,8(a4)
 1000b2a:	00b703a3          	sb	a1,7(a4)
 1000b2e:	00b70323          	sb	a1,6(a4)
 1000b32:	00b702a3          	sb	a1,5(a4)
 1000b36:	00b70223          	sb	a1,4(a4)
 1000b3a:	00b701a3          	sb	a1,3(a4)
 1000b3e:	00b70123          	sb	a1,2(a4)
 1000b42:	00b700a3          	sb	a1,1(a4)
 1000b46:	00b70023          	sb	a1,0(a4)
 1000b4a:	8082                	ret
 1000b4c:	0ff5f593          	andi	a1,a1,255
 1000b50:	00859693          	slli	a3,a1,0x8
 1000b54:	8dd5                	or	a1,a1,a3
 1000b56:	01059693          	slli	a3,a1,0x10
 1000b5a:	8dd5                	or	a1,a1,a3
 1000b5c:	b761                	j	1000ae4 <memset+0x10>
 1000b5e:	00279693          	slli	a3,a5,0x2
 1000b62:	00000297          	auipc	t0,0x0
 1000b66:	9696                	add	a3,a3,t0
 1000b68:	8286                	mv	t0,ra
 1000b6a:	fa8680e7          	jalr	-88(a3)
 1000b6e:	8096                	mv	ra,t0
 1000b70:	17c1                	addi	a5,a5,-16
 1000b72:	8f1d                	sub	a4,a4,a5
 1000b74:	963e                	add	a2,a2,a5
 1000b76:	f8c374e3          	bgeu	t1,a2,1000afe <memset+0x2a>
 1000b7a:	b7a5                	j	1000ae2 <memset+0xe>
 1000b7c:	0000                	unimp
	...
