
.//Obj/sh_test.elf:     file format elf32-littleriscv


Disassembly of section .text:

01000000 <__stext>:
 1000000:	0e00                	addi	s0,sp,784
 1000002:	0000                	unimp
 1000004:	0008                	0x8
 1000006:	0100                	addi	s0,sp,128

01000008 <Reset_Handler>:
    .align  2
    .globl  Reset_Handler
    .type   Reset_Handler, %function
Reset_Handler:
	# enable MXSTATUS.THEADISAEE bit[22]
	li t0,  0x400000
 1000008:	004002b7          	lui	t0,0x400
	csrs mxstatus, t0
 100000c:	7c02a073          	csrs	mxstatus,t0

	# invalid icache
	ICACHE.IALL
#else
	# icache disable
	csrw mhcr, zero
 1000010:	7c101073          	csrw	mhcr,zero
      li      t1, 0x10
      sw      t1, (t0)
#endif
.option push
.option norelax
    la      gp, __global_pointer$
 1000014:	00001197          	auipc	gp,0x1
 1000018:	dec18193          	addi	gp,gp,-532 # 1000e00 <__erodata>
.option pop
    la      sp, g_top_irqstack
 100001c:	12018113          	addi	sp,gp,288 # 1000f20 <uart_dev>
    csrw    mscratch, sp
 1000020:	34011073          	csrw	mscratch,sp
    la      a0, __Vectors
    csrw    mtvt, a0
#endif

#ifndef __NO_SYSTEM_INIT
    jal     SystemInit
 1000024:	55e000ef          	jal	ra,1000582 <SystemInit>
#endif

#ifndef __NO_BOARD_INIT
    jal     board_init
 1000028:	026000ef          	jal	ra,100004e <board_init>
#endif

    jal     main
 100002c:	008000ef          	jal	ra,1000034 <main>

01000030 <__exit>:

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit
 1000030:	a001                	j	1000030 <__exit>
	...

01000034 <main>:
#include <driver.h>
#include <console.h>
#include <shell.h>


int __attribute__((weak)) main(void) {
 1000034:	1151                	addi	sp,sp,-12
 1000036:	c406                	sw	ra,8(sp)
	puts("--- SH "__DATE__" "__TIME__" ---\n");
 1000038:	f4418513          	addi	a0,gp,-188 # 1000d44 <HEX_TABLE+0x14>
 100003c:	141000ef          	jal	ra,100097c <puts>
	#ifdef CONFIG_SHELL
	sh_init();
 1000040:	2665                	jal	10003e8 <sh_init>
	while (EEXIT != sh_loop()) {
 1000042:	26d9                	jal	1000408 <sh_loop>
 1000044:	800007b7          	lui	a5,0x80000
 1000048:	fef51de3          	bne	a0,a5,1000042 <main+0xe>
		int ch = getchar();
		if (ch > 0)
			putchar(ch);
	}
	#endif
	while(1);
 100004c:	a001                	j	100004c <main+0x18>

0100004e <board_init>:
#include "console.h"

void board_init(void)
{
 100004e:	1151                	addi	sp,sp,-12
 1000050:	c406                	sw	ra,8(sp)
    /* init the console*/
    console_init();
 1000052:	0a5000ef          	jal	ra,10008f6 <console_init>
}
 1000056:	40a2                	lw	ra,8(sp)
 1000058:	0131                	addi	sp,sp,12
 100005a:	8082                	ret

0100005c <cmd_exit>:
	return EOK;
}
#endif
static int cmd_exit(uint8_t argc, char*argv[]) {
	return EEXIT;
}
 100005c:	80000537          	lui	a0,0x80000
 1000060:	8082                	ret

01000062 <cmd_help>:
	{"help",  cmd_help},
	{"exit",  cmd_exit}
};
#define CMDLIST_SIZE	(sizeof(cmdlist) / sizeof(cmdlist[0]))

static int cmd_help(uint8_t argc, char*argv[]) {
 1000062:	1151                	addi	sp,sp,-12
 1000064:	c406                	sw	ra,8(sp)
 1000066:	c222                	sw	s0,4(sp)
	for (int i = 0; i < CMDLIST_SIZE; i++) {
 1000068:	4401                	li	s0,0
 100006a:	a829                	j	1000084 <cmd_help+0x22>
		puts(cmdlist[i].cmd);
 100006c:	00341713          	slli	a4,s0,0x3
 1000070:	ec018793          	addi	a5,gp,-320 # 1000cc0 <__etext>
 1000074:	97ba                	add	a5,a5,a4
 1000076:	4388                	lw	a0,0(a5)
 1000078:	105000ef          	jal	ra,100097c <puts>
		putchar('\n');
 100007c:	4529                	li	a0,10
 100007e:	0b5000ef          	jal	ra,1000932 <putchar>
	for (int i = 0; i < CMDLIST_SIZE; i++) {
 1000082:	0405                	addi	s0,s0,1
 1000084:	478d                	li	a5,3
 1000086:	fe87f3e3          	bgeu	a5,s0,100006c <cmd_help+0xa>
	}
	return EOK;
}
 100008a:	4501                	li	a0,0
 100008c:	40a2                	lw	ra,8(sp)
 100008e:	4412                	lw	s0,4(sp)
 1000090:	0131                	addi	sp,sp,12
 1000092:	8082                	ret

01000094 <sh_input>:

/* ================================================================================ */

static int sh_input(char c) {
 1000094:	1151                	addi	sp,sp,-12
 1000096:	c406                	sw	ra,8(sp)
	if (sh.offs >= CONFIG_SH_CMDLINE_SIZE) {
 1000098:	00018793          	mv	a5,gp
 100009c:	0587c703          	lbu	a4,88(a5) # 80000058 <__bss_end__+0x7efff0f8>
 10000a0:	03f00793          	li	a5,63
 10000a4:	02e7e163          	bltu	a5,a4,10000c6 <sh_input+0x32>
		puts("Command line too long!");
		puts(prompt);
		return ENOCMD;
	}
	sh.cmdline[sh.offs++] = c;
 10000a8:	00018793          	mv	a5,gp
 10000ac:	00170693          	addi	a3,a4,1
 10000b0:	04d78c23          	sb	a3,88(a5)
 10000b4:	97ba                	add	a5,a5,a4
 10000b6:	00a78c23          	sb	a0,24(a5)
	putchar(c);
 10000ba:	079000ef          	jal	ra,1000932 <putchar>
	return EOK;
 10000be:	4501                	li	a0,0
}
 10000c0:	40a2                	lw	ra,8(sp)
 10000c2:	0131                	addi	sp,sp,12
 10000c4:	8082                	ret
		puts("Command line too long!");
 10000c6:	f6818513          	addi	a0,gp,-152 # 1000d68 <HEX_TABLE+0x38>
 10000ca:	0b3000ef          	jal	ra,100097c <puts>
		puts(prompt);
 10000ce:	ec018513          	addi	a0,gp,-320 # 1000cc0 <__etext>
 10000d2:	02050513          	addi	a0,a0,32 # 80000020 <__bss_end__+0x7efff0c0>
 10000d6:	0a7000ef          	jal	ra,100097c <puts>
		return ENOCMD;
 10000da:	557d                	li	a0,-1
 10000dc:	b7d5                	j	10000c0 <sh_input+0x2c>

010000de <dump_bytes>:
{
 10000de:	1111                	addi	sp,sp,-28
 10000e0:	cc06                	sw	ra,24(sp)
 10000e2:	ca22                	sw	s0,20(sp)
 10000e4:	c826                	sw	s1,16(sp)
 10000e6:	c02a                	sw	a0,0(sp)
 10000e8:	842e                	mv	s0,a1
 10000ea:	c42e                	sw	a1,8(sp)
	uint16_t i, cols, offs = ((uint32_t)buf) & 0xffff;
 10000ec:	c62a                	sw	a0,12(sp)
 10000ee:	01051793          	slli	a5,a0,0x10
 10000f2:	83c1                	srli	a5,a5,0x10
 10000f4:	c23e                	sw	a5,4(sp)
	puts("     ");
 10000f6:	f8018513          	addi	a0,gp,-128 # 1000d80 <HEX_TABLE+0x50>
 10000fa:	083000ef          	jal	ra,100097c <puts>
	cols = (bytes > 16) ? 16 : bytes;
 10000fe:	84a2                	mv	s1,s0
 1000100:	47c1                	li	a5,16
 1000102:	0087f363          	bgeu	a5,s0,1000108 <dump_bytes+0x2a>
 1000106:	44c1                	li	s1,16
 1000108:	04c2                	slli	s1,s1,0x10
 100010a:	80c1                	srli	s1,s1,0x10
	for (i = 0; i < cols; i++) {
 100010c:	4401                	li	s0,0
 100010e:	02947063          	bgeu	s0,s1,100012e <dump_bytes+0x50>
		putchar(' ');
 1000112:	02000513          	li	a0,32
 1000116:	01d000ef          	jal	ra,1000932 <putchar>
		put_h8((offs+i) & 0x0f);
 100011a:	47b2                	lw	a5,12(sp)
 100011c:	00878533          	add	a0,a5,s0
 1000120:	893d                	andi	a0,a0,15
 1000122:	087000ef          	jal	ra,10009a8 <put_h8>
	for (i = 0; i < cols; i++) {
 1000126:	0405                	addi	s0,s0,1
 1000128:	0442                	slli	s0,s0,0x10
 100012a:	8041                	srli	s0,s0,0x10
 100012c:	b7cd                	j	100010e <dump_bytes+0x30>
	putchar('\n');
 100012e:	4529                	li	a0,10
 1000130:	003000ef          	jal	ra,1000932 <putchar>
	for (i = 0; i < bytes; i++, offs++, p++) {
 1000134:	4401                	li	s0,0
 1000136:	a83d                	j	1000174 <dump_bytes+0x96>
			put_h16(offs);
 1000138:	4512                	lw	a0,4(sp)
 100013a:	0cb000ef          	jal	ra,1000a04 <put_h16>
			putchar(':');
 100013e:	03a00513          	li	a0,58
 1000142:	7f0000ef          	jal	ra,1000932 <putchar>
		putchar(' ');
 1000146:	02000513          	li	a0,32
 100014a:	7e8000ef          	jal	ra,1000932 <putchar>
		put_h8(*p);
 100014e:	4782                	lw	a5,0(sp)
 1000150:	0007c503          	lbu	a0,0(a5)
 1000154:	055000ef          	jal	ra,10009a8 <put_h8>
		if (0x0f == (i & 0x0f))
 1000158:	47bd                	li	a5,15
 100015a:	02f48463          	beq	s1,a5,1000182 <dump_bytes+0xa4>
	for (i = 0; i < bytes; i++, offs++, p++) {
 100015e:	0405                	addi	s0,s0,1
 1000160:	0442                	slli	s0,s0,0x10
 1000162:	8041                	srli	s0,s0,0x10
 1000164:	4792                	lw	a5,4(sp)
 1000166:	0785                	addi	a5,a5,1
 1000168:	07c2                	slli	a5,a5,0x10
 100016a:	83c1                	srli	a5,a5,0x10
 100016c:	c23e                	sw	a5,4(sp)
 100016e:	4782                	lw	a5,0(sp)
 1000170:	0785                	addi	a5,a5,1
 1000172:	c03e                	sw	a5,0(sp)
 1000174:	47a2                	lw	a5,8(sp)
 1000176:	00f47a63          	bgeu	s0,a5,100018a <dump_bytes+0xac>
		if (!(i & 0x0f))
 100017a:	00f47493          	andi	s1,s0,15
 100017e:	f4e1                	bnez	s1,1000146 <dump_bytes+0x68>
 1000180:	bf65                	j	1000138 <dump_bytes+0x5a>
			putchar('\n');
 1000182:	4529                	li	a0,10
 1000184:	7ae000ef          	jal	ra,1000932 <putchar>
 1000188:	bfd9                	j	100015e <dump_bytes+0x80>
	if (i & 0x0f)
 100018a:	883d                	andi	s0,s0,15
 100018c:	e411                	bnez	s0,1000198 <dump_bytes+0xba>
}
 100018e:	40e2                	lw	ra,24(sp)
 1000190:	4452                	lw	s0,20(sp)
 1000192:	44c2                	lw	s1,16(sp)
 1000194:	0171                	addi	sp,sp,28
 1000196:	8082                	ret
		putchar('\n');
 1000198:	4529                	li	a0,10
 100019a:	798000ef          	jal	ra,1000932 <putchar>
}
 100019e:	bfc5                	j	100018e <dump_bytes+0xb0>

010001a0 <dump_words>:
{
 10001a0:	1121                	addi	sp,sp,-24
 10001a2:	ca06                	sw	ra,20(sp)
 10001a4:	c822                	sw	s0,16(sp)
 10001a6:	c626                	sw	s1,12(sp)
 10001a8:	84aa                	mv	s1,a0
 10001aa:	c42e                	sw	a1,8(sp)
	uint16_t i, offs = ((uint32_t)buf) & 0xffff;
 10001ac:	01051793          	slli	a5,a0,0x10
 10001b0:	83c1                	srli	a5,a5,0x10
 10001b2:	c03e                	sw	a5,0(sp)
	for (i = 0; i < words; i++, offs+=4, p++) {
 10001b4:	4401                	li	s0,0
 10001b6:	a825                	j	10001ee <dump_words+0x4e>
			put_h16(offs);
 10001b8:	4502                	lw	a0,0(sp)
 10001ba:	04b000ef          	jal	ra,1000a04 <put_h16>
			putchar(':');
 10001be:	03a00513          	li	a0,58
 10001c2:	770000ef          	jal	ra,1000932 <putchar>
		putchar(' ');
 10001c6:	02000513          	li	a0,32
 10001ca:	768000ef          	jal	ra,1000932 <putchar>
		put_h32(*p);
 10001ce:	4088                	lw	a0,0(s1)
 10001d0:	065000ef          	jal	ra,1000a34 <put_h32>
		if (0x03 == (i & 0x03))
 10001d4:	478d                	li	a5,3
 10001d6:	4712                	lw	a4,4(sp)
 10001d8:	02f70363          	beq	a4,a5,10001fe <dump_words+0x5e>
	for (i = 0; i < words; i++, offs+=4, p++) {
 10001dc:	0405                	addi	s0,s0,1
 10001de:	0442                	slli	s0,s0,0x10
 10001e0:	8041                	srli	s0,s0,0x10
 10001e2:	4782                	lw	a5,0(sp)
 10001e4:	0791                	addi	a5,a5,4
 10001e6:	07c2                	slli	a5,a5,0x10
 10001e8:	83c1                	srli	a5,a5,0x10
 10001ea:	c03e                	sw	a5,0(sp)
 10001ec:	0491                	addi	s1,s1,4
 10001ee:	47a2                	lw	a5,8(sp)
 10001f0:	00f47b63          	bgeu	s0,a5,1000206 <dump_words+0x66>
		if (!(i & 0x03))
 10001f4:	00347793          	andi	a5,s0,3
 10001f8:	c23e                	sw	a5,4(sp)
 10001fa:	f7f1                	bnez	a5,10001c6 <dump_words+0x26>
 10001fc:	bf75                	j	10001b8 <dump_words+0x18>
			putchar('\n');
 10001fe:	4529                	li	a0,10
 1000200:	732000ef          	jal	ra,1000932 <putchar>
 1000204:	bfe1                	j	10001dc <dump_words+0x3c>
	if (i & 0x03)
 1000206:	880d                	andi	s0,s0,3
 1000208:	e411                	bnez	s0,1000214 <dump_words+0x74>
}
 100020a:	40d2                	lw	ra,20(sp)
 100020c:	4442                	lw	s0,16(sp)
 100020e:	44b2                	lw	s1,12(sp)
 1000210:	0161                	addi	sp,sp,24
 1000212:	8082                	ret
		putchar('\n');
 1000214:	4529                	li	a0,10
 1000216:	71c000ef          	jal	ra,1000932 <putchar>
}
 100021a:	bfc5                	j	100020a <dump_words+0x6a>

0100021c <dump>:
void dump(const void *buf, uint16_t count) {
 100021c:	1151                	addi	sp,sp,-12
 100021e:	c406                	sw	ra,8(sp)
 1000220:	c222                	sw	s0,4(sp)
 1000222:	c026                	sw	s1,0(sp)
 1000224:	842a                	mv	s0,a0
 1000226:	84ae                	mv	s1,a1
	putchar('\n');
 1000228:	4529                	li	a0,10
 100022a:	708000ef          	jal	ra,1000932 <putchar>
	if (IS_SRAM(buf))
 100022e:	ff0007b7          	lui	a5,0xff000
 1000232:	97a2                	add	a5,a5,s0
 1000234:	6705                	lui	a4,0x1
 1000236:	00e7fa63          	bgeu	a5,a4,100024a <dump+0x2e>
		dump_bytes(buf, count);
 100023a:	85a6                	mv	a1,s1
 100023c:	8522                	mv	a0,s0
 100023e:	3545                	jal	10000de <dump_bytes>
}
 1000240:	40a2                	lw	ra,8(sp)
 1000242:	4412                	lw	s0,4(sp)
 1000244:	4482                	lw	s1,0(sp)
 1000246:	0131                	addi	sp,sp,12
 1000248:	8082                	ret
		dump_words(buf, count);
 100024a:	85a6                	mv	a1,s1
 100024c:	8522                	mv	a0,s0
 100024e:	3f89                	jal	10001a0 <dump_words>
}
 1000250:	bfc5                	j	1000240 <dump+0x24>

01000252 <stoi>:
	if ('*' == *s) {
 1000252:	00054703          	lbu	a4,0(a0)
 1000256:	02a00793          	li	a5,42
 100025a:	00f70f63          	beq	a4,a5,1000278 <stoi+0x26>
	bool hex, at = false;
 100025e:	4581                	li	a1,0
	hex = ('0' == s[0] && ('x' == s[1] || 'X' == s[1]));
 1000260:	00054783          	lbu	a5,0(a0)
 1000264:	03000713          	li	a4,48
 1000268:	00e78b63          	beq	a5,a4,100027e <stoi+0x2c>
 100026c:	4601                	li	a2,0
	if (hex) {
 100026e:	ce3d                	beqz	a2,10002ec <stoi+0x9a>
		for (s += 2; *s; s++) {
 1000270:	00250613          	addi	a2,a0,2
	uint32_t val = 0;
 1000274:	4701                	li	a4,0
		for (s += 2; *s; s++) {
 1000276:	a081                	j	10002b6 <stoi+0x64>
		s++;
 1000278:	0505                	addi	a0,a0,1
		at = true;
 100027a:	4585                	li	a1,1
 100027c:	b7d5                	j	1000260 <stoi+0xe>
	hex = ('0' == s[0] && ('x' == s[1] || 'X' == s[1]));
 100027e:	00154703          	lbu	a4,1(a0)
 1000282:	07800693          	li	a3,120
 1000286:	00d70863          	beq	a4,a3,1000296 <stoi+0x44>
 100028a:	05800693          	li	a3,88
 100028e:	00d70663          	beq	a4,a3,100029a <stoi+0x48>
 1000292:	4601                	li	a2,0
 1000294:	bfe9                	j	100026e <stoi+0x1c>
 1000296:	4605                	li	a2,1
 1000298:	bfd9                	j	100026e <stoi+0x1c>
 100029a:	4605                	li	a2,1
 100029c:	bfc9                	j	100026e <stoi+0x1c>
			else if (*s >= 'A' && *s <= 'F')
 100029e:	fbf78693          	addi	a3,a5,-65 # feffffbf <__bss_end__+0xfdfff05f>
 10002a2:	0ff6f693          	andi	a3,a3,255
 10002a6:	4515                	li	a0,5
 10002a8:	02d56663          	bltu	a0,a3,10002d4 <stoi+0x82>
				val = (val << 4) | (*s - 'A' + 10);
 10002ac:	0712                	slli	a4,a4,0x4
 10002ae:	fc978513          	addi	a0,a5,-55
 10002b2:	8f49                	or	a4,a4,a0
		for (s += 2; *s; s++) {
 10002b4:	0605                	addi	a2,a2,1
 10002b6:	00064783          	lbu	a5,0(a2)
 10002ba:	c7bd                	beqz	a5,1000328 <stoi+0xd6>
			if (*s >= '0' && *s <= '9')
 10002bc:	fd078693          	addi	a3,a5,-48
 10002c0:	0ff6f693          	andi	a3,a3,255
 10002c4:	4525                	li	a0,9
 10002c6:	fcd56ce3          	bltu	a0,a3,100029e <stoi+0x4c>
				val = (val << 4) | (*s - '0');
 10002ca:	0712                	slli	a4,a4,0x4
 10002cc:	fd078513          	addi	a0,a5,-48
 10002d0:	8f49                	or	a4,a4,a0
 10002d2:	b7cd                	j	10002b4 <stoi+0x62>
			else if (*s >= 'a' && *s <= 'f')
 10002d4:	f9f78693          	addi	a3,a5,-97
 10002d8:	0ff6f693          	andi	a3,a3,255
 10002dc:	4515                	li	a0,5
 10002de:	04d56563          	bltu	a0,a3,1000328 <stoi+0xd6>
				val = (val << 4) | (*s - 'a' + 10);
 10002e2:	0712                	slli	a4,a4,0x4
 10002e4:	fa978513          	addi	a0,a5,-87
 10002e8:	8f49                	or	a4,a4,a0
 10002ea:	b7e9                	j	10002b4 <stoi+0x62>
		if ('-' == *s) {
 10002ec:	02d00713          	li	a4,45
 10002f0:	02e78663          	beq	a5,a4,100031c <stoi+0xca>
			minus = true;
 10002f4:	4701                	li	a4,0
		while (*s >= '0' && *s <= '9') {
 10002f6:	00054683          	lbu	a3,0(a0)
 10002fa:	fd068793          	addi	a5,a3,-48
 10002fe:	0ff7f793          	andi	a5,a5,255
 1000302:	4325                	li	t1,9
 1000304:	00f36f63          	bltu	t1,a5,1000322 <stoi+0xd0>
			val = val * 10 + (*s - '0');
 1000308:	00271793          	slli	a5,a4,0x2
 100030c:	97ba                	add	a5,a5,a4
 100030e:	00179713          	slli	a4,a5,0x1
 1000312:	9736                	add	a4,a4,a3
 1000314:	fd070713          	addi	a4,a4,-48 # fd0 <__stext-0xfff030>
			s++;
 1000318:	0505                	addi	a0,a0,1
 100031a:	bff1                	j	10002f6 <stoi+0xa4>
			s++;
 100031c:	0505                	addi	a0,a0,1
			minus = true;
 100031e:	4605                	li	a2,1
 1000320:	bfd1                	j	10002f4 <stoi+0xa2>
		if (minus)
 1000322:	c219                	beqz	a2,1000328 <stoi+0xd6>
			val = (uint32_t)(-(int)val);
 1000324:	40e00733          	neg	a4,a4
	if (at)
 1000328:	c191                	beqz	a1,100032c <stoi+0xda>
		return reg32_read(val);
 100032a:	4318                	lw	a4,0(a4)
}
 100032c:	853a                	mv	a0,a4
 100032e:	8082                	ret

01000330 <cmd_sw>:
static int cmd_sw(uint8_t argc, char*argv[]) {
 1000330:	1151                	addi	sp,sp,-12
 1000332:	c406                	sw	ra,8(sp)
 1000334:	c222                	sw	s0,4(sp)
 1000336:	c026                	sw	s1,0(sp)
 1000338:	842e                	mv	s0,a1
	if (argc < 3) {
 100033a:	4789                	li	a5,2
 100033c:	02a7ff63          	bgeu	a5,a0,100037a <cmd_sw+0x4a>
	addr = stoi(argv[1]);
 1000340:	41c8                	lw	a0,4(a1)
 1000342:	3f01                	jal	1000252 <stoi>
 1000344:	84aa                	mv	s1,a0
	word = stoi(argv[2]);
 1000346:	4408                	lw	a0,8(s0)
 1000348:	3729                	jal	1000252 <stoi>
 100034a:	842a                	mv	s0,a0
	reg32_write(addr, word);
 100034c:	c088                	sw	a0,0(s1)
	puts("*0x");
 100034e:	fa018513          	addi	a0,gp,-96 # 1000da0 <HEX_TABLE+0x70>
 1000352:	62a000ef          	jal	ra,100097c <puts>
	put_h32(addr);
 1000356:	8526                	mv	a0,s1
 1000358:	6dc000ef          	jal	ra,1000a34 <put_h32>
	puts(" <= 0x");
 100035c:	fa418513          	addi	a0,gp,-92 # 1000da4 <HEX_TABLE+0x74>
 1000360:	61c000ef          	jal	ra,100097c <puts>
	put_h32(word);
 1000364:	8522                	mv	a0,s0
 1000366:	6ce000ef          	jal	ra,1000a34 <put_h32>
	putchar('\n');
 100036a:	4529                	li	a0,10
 100036c:	23d9                	jal	1000932 <putchar>
	return EOK;
 100036e:	4501                	li	a0,0
}
 1000370:	40a2                	lw	ra,8(sp)
 1000372:	4412                	lw	s0,4(sp)
 1000374:	4482                	lw	s1,0(sp)
 1000376:	0131                	addi	sp,sp,12
 1000378:	8082                	ret
		puts("Usage: ");
 100037a:	f8818513          	addi	a0,gp,-120 # 1000d88 <HEX_TABLE+0x58>
 100037e:	5fe000ef          	jal	ra,100097c <puts>
		puts(argv[0]);
 1000382:	4008                	lw	a0,0(s0)
 1000384:	5f8000ef          	jal	ra,100097c <puts>
		puts(" <addr> <word>\n");
 1000388:	f9018513          	addi	a0,gp,-112 # 1000d90 <HEX_TABLE+0x60>
 100038c:	5f0000ef          	jal	ra,100097c <puts>
		return EINVAL;
 1000390:	556d                	li	a0,-5
 1000392:	bff9                	j	1000370 <cmd_sw+0x40>

01000394 <cmd_lw>:
static int cmd_lw(uint8_t argc, char*argv[]) {
 1000394:	1151                	addi	sp,sp,-12
 1000396:	c406                	sw	ra,8(sp)
 1000398:	c222                	sw	s0,4(sp)
 100039a:	c026                	sw	s1,0(sp)
 100039c:	842e                	mv	s0,a1
	if (argc < 2) {
 100039e:	4785                	li	a5,1
 10003a0:	02a7fa63          	bgeu	a5,a0,10003d4 <cmd_lw+0x40>
	addr = stoi(argv[1]);
 10003a4:	41c8                	lw	a0,4(a1)
 10003a6:	3575                	jal	1000252 <stoi>
 10003a8:	842a                	mv	s0,a0
	word = reg32_read(addr);
 10003aa:	4104                	lw	s1,0(a0)
	puts("*0x");
 10003ac:	fa018513          	addi	a0,gp,-96 # 1000da0 <HEX_TABLE+0x70>
 10003b0:	23f1                	jal	100097c <puts>
	put_h32(addr);
 10003b2:	8522                	mv	a0,s0
 10003b4:	680000ef          	jal	ra,1000a34 <put_h32>
	puts(" => 0x");
 10003b8:	fb818513          	addi	a0,gp,-72 # 1000db8 <HEX_TABLE+0x88>
 10003bc:	23c1                	jal	100097c <puts>
	put_h32(word);
 10003be:	8526                	mv	a0,s1
 10003c0:	674000ef          	jal	ra,1000a34 <put_h32>
	putchar('\n');
 10003c4:	4529                	li	a0,10
 10003c6:	23b5                	jal	1000932 <putchar>
	return EOK;
 10003c8:	4501                	li	a0,0
}
 10003ca:	40a2                	lw	ra,8(sp)
 10003cc:	4412                	lw	s0,4(sp)
 10003ce:	4482                	lw	s1,0(sp)
 10003d0:	0131                	addi	sp,sp,12
 10003d2:	8082                	ret
		puts("Usage: ");
 10003d4:	f8818513          	addi	a0,gp,-120 # 1000d88 <HEX_TABLE+0x58>
 10003d8:	2355                	jal	100097c <puts>
		puts(argv[0]);
 10003da:	4008                	lw	a0,0(s0)
 10003dc:	2345                	jal	100097c <puts>
		puts(" <addr>\n");
 10003de:	fac18513          	addi	a0,gp,-84 # 1000dac <HEX_TABLE+0x7c>
 10003e2:	2b69                	jal	100097c <puts>
		return EINVAL;
 10003e4:	556d                	li	a0,-5
 10003e6:	b7d5                	j	10003ca <cmd_lw+0x36>

010003e8 <sh_init>:

void sh_init(void) {
 10003e8:	1151                	addi	sp,sp,-12
 10003ea:	c406                	sw	ra,8(sp)
	sh.error = 0;
 10003ec:	00018793          	mv	a5,gp
 10003f0:	0007a023          	sw	zero,0(a5)
	sh.offs = 0;
 10003f4:	04078c23          	sb	zero,88(a5)
	puts(prompt);
 10003f8:	ec018513          	addi	a0,gp,-320 # 1000cc0 <__etext>
 10003fc:	02050513          	addi	a0,a0,32
 1000400:	2bb5                	jal	100097c <puts>
}
 1000402:	40a2                	lw	ra,8(sp)
 1000404:	0131                	addi	sp,sp,12
 1000406:	8082                	ret

01000408 <sh_loop>:

int sh_loop(void) {
 1000408:	1141                	addi	sp,sp,-16
 100040a:	c606                	sw	ra,12(sp)
 100040c:	c422                	sw	s0,8(sp)
 100040e:	c226                	sw	s1,4(sp)
	char* input;
	int ret = EOK;
	int ch = getchar();
 1000410:	29f5                	jal	100090c <getchar>

	if (ch <= 0)
 1000412:	14a05c63          	blez	a0,100056a <sh_loop+0x162>
		return EOK;

	if (ch == '\b' || ch == '\x7f') {
 1000416:	47a1                	li	a5,8
 1000418:	04f50763          	beq	a0,a5,1000466 <sh_loop+0x5e>
 100041c:	07f00793          	li	a5,127
 1000420:	04f50363          	beq	a0,a5,1000466 <sh_loop+0x5e>
		sh.offs--;
		puts("\b \b");
		return EOK;
	}
	else if ('\t' == ch)
 1000424:	47a5                	li	a5,9
 1000426:	04f50c63          	beq	a0,a5,100047e <sh_loop+0x76>
		return sh_input(' ');
	else if ((char)ch < ' ') {
 100042a:	0ff57793          	andi	a5,a0,255
 100042e:	477d                	li	a4,31
 1000430:	04f76c63          	bltu	a4,a5,1000488 <sh_loop+0x80>
		if ('\n' != ch && '\r' != ch)
 1000434:	47a9                	li	a5,10
 1000436:	00f50563          	beq	a0,a5,1000440 <sh_loop+0x38>
 100043a:	47b5                	li	a5,13
 100043c:	12f51e63          	bne	a0,a5,1000578 <sh_loop+0x170>
			return EOK;
	}
	else
		return sh_input((char)ch);

	putchar('\n');
 1000440:	4529                	li	a0,10
 1000442:	29c5                	jal	1000932 <putchar>
	if (!sh.offs)
 1000444:	00018793          	mv	a5,gp
 1000448:	0587c783          	lbu	a5,88(a5)
 100044c:	10078863          	beqz	a5,100055c <sh_loop+0x154>
		goto end;
	sh.cmdline[sh.offs] = 0;
 1000450:	00018613          	mv	a2,gp
 1000454:	97b2                	add	a5,a5,a2
 1000456:	00078c23          	sb	zero,24(a5)
	sh.offs = 0;
 100045a:	04060c23          	sb	zero,88(a2)
	sh.argc = 0;
 100045e:	04060ca3          	sb	zero,89(a2)
	input = sh.cmdline;
 1000462:	0661                	addi	a2,a2,24
 1000464:	a03d                	j	1000492 <sh_loop+0x8a>
		sh.offs--;
 1000466:	00018793          	mv	a5,gp
 100046a:	0587c703          	lbu	a4,88(a5)
 100046e:	177d                	addi	a4,a4,-1
 1000470:	04e78c23          	sb	a4,88(a5)
		puts("\b \b");
 1000474:	fc018513          	addi	a0,gp,-64 # 1000dc0 <HEX_TABLE+0x90>
 1000478:	2311                	jal	100097c <puts>
		return EOK;
 100047a:	4401                	li	s0,0
 100047c:	a8c5                	j	100056c <sh_loop+0x164>
		return sh_input(' ');
 100047e:	02000513          	li	a0,32
 1000482:	3909                	jal	1000094 <sh_input>
 1000484:	842a                	mv	s0,a0
 1000486:	a0dd                	j	100056c <sh_loop+0x164>
		return sh_input((char)ch);
 1000488:	853e                	mv	a0,a5
 100048a:	3129                	jal	1000094 <sh_input>
 100048c:	842a                	mv	s0,a0
 100048e:	a8f9                	j	100056c <sh_loop+0x164>
	while (1) {
		char* next;

		while (*input && *input <= ' ')
			input++;
 1000490:	0605                	addi	a2,a2,1
		while (*input && *input <= ' ')
 1000492:	00064783          	lbu	a5,0(a2)
 1000496:	17fd                	addi	a5,a5,-1
 1000498:	0ff7f793          	andi	a5,a5,255
 100049c:	477d                	li	a4,31
 100049e:	fef779e3          	bgeu	a4,a5,1000490 <sh_loop+0x88>
		for (next = input; *next > ' '; next++);
 10004a2:	87b2                	mv	a5,a2
 10004a4:	0007c683          	lbu	a3,0(a5)
 10004a8:	02000713          	li	a4,32
 10004ac:	00d77463          	bgeu	a4,a3,10004b4 <sh_loop+0xac>
 10004b0:	0785                	addi	a5,a5,1
 10004b2:	bfcd                	j	10004a4 <sh_loop+0x9c>
		if (next == input)
 10004b4:	02f60f63          	beq	a2,a5,10004f2 <sh_loop+0xea>
			break;
		if (sh.argc >= CONFIG_SH_MAX_ARGS) {
 10004b8:	00018713          	mv	a4,gp
 10004bc:	05974683          	lbu	a3,89(a4)
 10004c0:	4711                	li	a4,4
 10004c2:	02d76363          	bltu	a4,a3,10004e8 <sh_loop+0xe0>
			puts("Too many args!");
			ret = ENOCMD;
			goto end;
		}
		sh.argv[sh.argc++] = input;
 10004c6:	00018713          	mv	a4,gp
 10004ca:	00168593          	addi	a1,a3,1
 10004ce:	04b70ca3          	sb	a1,89(a4)
 10004d2:	068a                	slli	a3,a3,0x2
 10004d4:	9736                	add	a4,a4,a3
 10004d6:	c350                	sw	a2,4(a4)
		if (!*next)
 10004d8:	0007c703          	lbu	a4,0(a5)
 10004dc:	cb19                	beqz	a4,10004f2 <sh_loop+0xea>
			break;
		*next++ = 0;
 10004de:	00178613          	addi	a2,a5,1
 10004e2:	00078023          	sb	zero,0(a5)
	while (1) {
 10004e6:	b775                	j	1000492 <sh_loop+0x8a>
			puts("Too many args!");
 10004e8:	fc418513          	addi	a0,gp,-60 # 1000dc4 <HEX_TABLE+0x94>
 10004ec:	2941                	jal	100097c <puts>
			ret = ENOCMD;
 10004ee:	547d                	li	s0,-1
			goto end;
 10004f0:	a0bd                	j	100055e <sh_loop+0x156>
		input = next;
	}
	if (sh.argc) {
 10004f2:	00018793          	mv	a5,gp
 10004f6:	0597c403          	lbu	s0,89(a5)
 10004fa:	c035                	beqz	s0,100055e <sh_loop+0x156>
		int i;
		for (i = 0; i < CMDLIST_SIZE; i++) {
 10004fc:	4481                	li	s1,0
 10004fe:	478d                	li	a5,3
 1000500:	0497e163          	bltu	a5,s1,1000542 <sh_loop+0x13a>
			if (strcmp(cmdlist[i].cmd, sh.argv[0]) == 0) {
 1000504:	00349793          	slli	a5,s1,0x3
 1000508:	ec018713          	addi	a4,gp,-320 # 1000cc0 <__etext>
 100050c:	97ba                	add	a5,a5,a4
 100050e:	00018713          	mv	a4,gp
 1000512:	434c                	lw	a1,4(a4)
 1000514:	4388                	lw	a0,0(a5)
 1000516:	682000ef          	jal	ra,1000b98 <strcmp>
 100051a:	c119                	beqz	a0,1000520 <sh_loop+0x118>
		for (i = 0; i < CMDLIST_SIZE; i++) {
 100051c:	0485                	addi	s1,s1,1
 100051e:	b7c5                	j	10004fe <sh_loop+0xf6>
				ret = sh.error = cmdlist[i].handler(sh.argc, sh.argv);
 1000520:	00349713          	slli	a4,s1,0x3
 1000524:	ec018793          	addi	a5,gp,-320 # 1000cc0 <__etext>
 1000528:	97ba                	add	a5,a5,a4
 100052a:	43dc                	lw	a5,4(a5)
 100052c:	00018713          	mv	a4,gp
 1000530:	c03a                	sw	a4,0(sp)
 1000532:	00470593          	addi	a1,a4,4
 1000536:	8522                	mv	a0,s0
 1000538:	9782                	jalr	a5
 100053a:	842a                	mv	s0,a0
 100053c:	4702                	lw	a4,0(sp)
 100053e:	c308                	sw	a0,0(a4)
				break;
 1000540:	a011                	j	1000544 <sh_loop+0x13c>
	int ret = EOK;
 1000542:	4401                	li	s0,0
			}
		}
		if (i == CMDLIST_SIZE) {
 1000544:	4791                	li	a5,4
 1000546:	00f49c63          	bne	s1,a5,100055e <sh_loop+0x156>
			ret = ENOCMD;
			puts("Unknown command: ");
 100054a:	fd418513          	addi	a0,gp,-44 # 1000dd4 <HEX_TABLE+0xa4>
 100054e:	213d                	jal	100097c <puts>
			puts(sh.argv[0]);
 1000550:	00018793          	mv	a5,gp
 1000554:	43c8                	lw	a0,4(a5)
 1000556:	211d                	jal	100097c <puts>
			ret = ENOCMD;
 1000558:	547d                	li	s0,-1
 100055a:	a011                	j	100055e <sh_loop+0x156>
	int ret = EOK;
 100055c:	4401                	li	s0,0
		}
	}
end:
	puts(prompt);
 100055e:	ec018513          	addi	a0,gp,-320 # 1000cc0 <__etext>
 1000562:	02050513          	addi	a0,a0,32
 1000566:	2919                	jal	100097c <puts>
	return ret;
 1000568:	a011                	j	100056c <sh_loop+0x164>
		return EOK;
 100056a:	4401                	li	s0,0
}
 100056c:	8522                	mv	a0,s0
 100056e:	40b2                	lw	ra,12(sp)
 1000570:	4422                	lw	s0,8(sp)
 1000572:	4492                	lw	s1,4(sp)
 1000574:	0141                	addi	sp,sp,16
 1000576:	8082                	ret
			return EOK;
 1000578:	4401                	li	s0,0
 100057a:	bfcd                	j	100056c <sh_loop+0x164>

0100057c <sh_error>:

int sh_error(void) {
	return sh.error;
}
 100057c:	0001a503          	lw	a0,0(gp) # 1000e00 <__erodata>
 1000580:	8082                	ret

01000582 <SystemInit>:
  *         Initialize the psr and vbr.
  * @param  None
  * @return None
  */
void SystemInit(void)
{
 1000582:	1151                	addi	sp,sp,-12
 1000584:	c406                	sw	ra,8(sp)
    /* tspend use positive interrupt */
    CLIC->CLICINT[Machine_Software_IRQn].ATTR = 0x3;
    csi_vic_enable_irq(Machine_Software_IRQn);
#endif	
#endif
	stc_init();
 1000586:	205d                	jal	100062c <stc_init>
           function <b>SysTick_Config</b> is not included. In this case, the file <b><i>device</i>.h</b>
           must contain a vendor-specific implementation of this function.
 */
__STATIC_INLINE void csi_coret_config(uint32_t ticks)
{
    if (CORET->MTIMECMP) {
 1000588:	e00047b7          	lui	a5,0xe0004
 100058c:	4398                	lw	a4,0(a5)
 100058e:	43dc                	lw	a5,4(a5)
 1000590:	00f766b3          	or	a3,a4,a5
 1000594:	c29d                	beqz	a3,10005ba <SystemInit+0x38>
        CORET->MTIMECMP = CORET->MTIMECMP + ticks;
 1000596:	e0004737          	lui	a4,0xe0004
 100059a:	4308                	lw	a0,0(a4)
 100059c:	434c                	lw	a1,4(a4)
 100059e:	000277b7          	lui	a5,0x27
 10005a2:	10078793          	addi	a5,a5,256 # 27100 <__stext-0xfd8f00>
 10005a6:	97aa                	add	a5,a5,a0
 10005a8:	00a7b333          	sltu	t1,a5,a0
 10005ac:	00b306b3          	add	a3,t1,a1
 10005b0:	c31c                	sw	a5,0(a4)
 10005b2:	c354                	sw	a3,4(a4)
#if CONFIG_HAVE_VIC
    __enable_excp_irq();
#endif
    csi_coret_config(SYSTEM_CLOCK / CONFIG_SYSTICK_HZ); 
}
 10005b4:	40a2                	lw	ra,8(sp)
 10005b6:	0131                	addi	sp,sp,12
 10005b8:	8082                	ret
    } else {
        CORET->MTIMECMP = CORET->MTIME + ticks;
 10005ba:	e000c7b7          	lui	a5,0xe000c
 10005be:	ff87a503          	lw	a0,-8(a5) # e000bff8 <__bss_end__+0xdf00b098>
 10005c2:	ffc7a583          	lw	a1,-4(a5)
 10005c6:	000277b7          	lui	a5,0x27
 10005ca:	10078793          	addi	a5,a5,256 # 27100 <__stext-0xfd8f00>
 10005ce:	97aa                	add	a5,a5,a0
 10005d0:	00a7b733          	sltu	a4,a5,a0
 10005d4:	863e                	mv	a2,a5
 10005d6:	00b706b3          	add	a3,a4,a1
 10005da:	e00047b7          	lui	a5,0xe0004
 10005de:	c390                	sw	a2,0(a5)
 10005e0:	c3d4                	sw	a3,4(a5)
 10005e2:	bfc9                	j	10005b4 <SystemInit+0x32>

010005e4 <timer_init>:
static timer_cb_t tm_cb[CONFIG_TIMER_NUM];
#endif

static void tick_init(void);
static void timer_init(int index, uint32_t init_cnt) {
	if (init_cnt) {
 10005e4:	02058163          	beqz	a1,1000606 <timer_init+0x22>
		TIMINIT[index] = init_cnt;
 10005e8:	00251793          	slli	a5,a0,0x2
 10005ec:	1f020737          	lui	a4,0x1f020
 10005f0:	00870693          	addi	a3,a4,8 # 1f020008 <__bss_end__+0x1e01f0a8>
 10005f4:	97b6                	add	a5,a5,a3
 10005f6:	c38c                	sw	a1,0(a5)
		reg32_set(STCCTL, TMEN(index));
 10005f8:	4314                	lw	a3,0(a4)
 10005fa:	47c1                	li	a5,16
 10005fc:	00a797b3          	sll	a5,a5,a0
 1000600:	8edd                	or	a3,a3,a5
 1000602:	c314                	sw	a3,0(a4)
 1000604:	8082                	ret
	}
	else
		reg32_clr(STCCTL, TMEN(index));
 1000606:	1f0206b7          	lui	a3,0x1f020
 100060a:	4298                	lw	a4,0(a3)
 100060c:	47c1                	li	a5,16
 100060e:	00a797b3          	sll	a5,a5,a0
 1000612:	fff7c793          	not	a5,a5
 1000616:	8ff9                	and	a5,a5,a4
 1000618:	c29c                	sw	a5,0(a3)
}
 100061a:	8082                	ret

0100061c <tick_init>:
	return 0;
}
#endif

#define TIMCNT_MAX	UINT32_MAX
static void tick_init(void) {
 100061c:	1151                	addi	sp,sp,-12
 100061e:	c406                	sw	ra,8(sp)
	timer_init(CONFIG_TICK_TIMER, TIMCNT_MAX);
 1000620:	55fd                	li	a1,-1
 1000622:	450d                	li	a0,3
 1000624:	37c1                	jal	10005e4 <timer_init>
}
 1000626:	40a2                	lw	ra,8(sp)
 1000628:	0131                	addi	sp,sp,12
 100062a:	8082                	ret

0100062c <stc_init>:
void stc_init(void) {
 100062c:	1151                	addi	sp,sp,-12
 100062e:	c406                	sw	ra,8(sp)
	tick_init();
 1000630:	37f5                	jal	100061c <tick_init>
}
 1000632:	40a2                	lw	ra,8(sp)
 1000634:	0131                	addi	sp,sp,12
 1000636:	8082                	ret

01000638 <tick_count>:

uint32_t tick_count(void) {
	return TIMCNT[CONFIG_TICK_TIMER];
 1000638:	1f0207b7          	lui	a5,0x1f020
 100063c:	47e8                	lw	a0,76(a5)
}
 100063e:	8082                	ret

01000640 <tick_diff>:

uint32_t tick_diff(uint32_t start) {
 1000640:	1151                	addi	sp,sp,-12
 1000642:	c406                	sw	ra,8(sp)
 1000644:	c222                	sw	s0,4(sp)
 1000646:	842a                	mv	s0,a0
	uint32_t diff;
	uint32_t cnt = tick_count();
 1000648:	3fc5                	jal	1000638 <tick_count>
	if (cnt > start)
 100064a:	00a47963          	bgeu	s0,a0,100065c <tick_diff+0x1c>
		diff = start + (TIMCNT_MAX - cnt);
 100064e:	40a40533          	sub	a0,s0,a0
 1000652:	157d                	addi	a0,a0,-1
	else
		diff = start - cnt;
	return diff;
}
 1000654:	40a2                	lw	ra,8(sp)
 1000656:	4412                	lw	s0,4(sp)
 1000658:	0131                	addi	sp,sp,12
 100065a:	8082                	ret
		diff = start - cnt;
 100065c:	40a40533          	sub	a0,s0,a0
	return diff;
 1000660:	bfd5                	j	1000654 <tick_diff+0x14>

01000662 <tick_diff_ms>:

uint32_t tick_diff_ms(uint32_t start) {
 1000662:	1151                	addi	sp,sp,-12
 1000664:	c406                	sw	ra,8(sp)
	uint32_t diff = tick_diff(start);
 1000666:	3fe9                	jal	1000640 <tick_diff>
	return (diff + 4) / TIMCNT_MS;
 1000668:	6591                	lui	a1,0x4
 100066a:	e8058593          	addi	a1,a1,-384 # 3e80 <__stext-0xffc180>
 100066e:	0511                	addi	a0,a0,4
 1000670:	2101                	jal	1000a70 <__udivsi3>
}
 1000672:	40a2                	lw	ra,8(sp)
 1000674:	0131                	addi	sp,sp,12
 1000676:	8082                	ret

01000678 <delay_ms>:

void delay_ms(uint32_t ms) {
 1000678:	1151                	addi	sp,sp,-12
 100067a:	c406                	sw	ra,8(sp)
 100067c:	c222                	sw	s0,4(sp)
 100067e:	c026                	sw	s1,0(sp)
 1000680:	842a                	mv	s0,a0
	uint32_t start = tick_count();
 1000682:	3f5d                	jal	1000638 <tick_count>
 1000684:	84aa                	mv	s1,a0
	uint32_t period = ms * TIMCNT_MS;
 1000686:	00541793          	slli	a5,s0,0x5
 100068a:	8f81                	sub	a5,a5,s0
 100068c:	00279513          	slli	a0,a5,0x2
 1000690:	9522                	add	a0,a0,s0
 1000692:	00751413          	slli	s0,a0,0x7
	while (tick_diff(start) < period);
 1000696:	8526                	mv	a0,s1
 1000698:	3765                	jal	1000640 <tick_diff>
 100069a:	fe856ee3          	bltu	a0,s0,1000696 <delay_ms+0x1e>
}
 100069e:	40a2                	lw	ra,8(sp)
 10006a0:	4412                	lw	s0,4(sp)
 10006a2:	4482                	lw	s1,0(sp)
 10006a4:	0131                	addi	sp,sp,12
 10006a6:	8082                	ret

010006a8 <uart_init>:
bool uart_init(int index, const uart_config_t* config) {
	uint8_t cfg = UART_CONFIG;
	uint8_t buad = UART_BAUD;
	uint32_t divisor;

	if (index >= CONFIG_UART_NUM)
 10006a8:	4785                	li	a5,1
 10006aa:	00a7d463          	bge	a5,a0,10006b2 <uart_init+0xa>
		return false;
 10006ae:	4501                	li	a0,0
	uart_dev[index].reg->enable |= 0xb0; // enable user define buadrate
	if (uart_dev[index].rx_fifo.size) {
		csi_vic_enable_irq(uart_dev[index].irq);
	}
	return true;
}
 10006b0:	8082                	ret
bool uart_init(int index, const uart_config_t* config) {
 10006b2:	1151                	addi	sp,sp,-12
 10006b4:	c406                	sw	ra,8(sp)
 10006b6:	c222                	sw	s0,4(sp)
 10006b8:	c026                	sw	s1,0(sp)
 10006ba:	84ae                	mv	s1,a1
 10006bc:	842a                	mv	s0,a0
	memset(&uart_dev[index], 0, sizeof(uart_dev[index]));
 10006be:	0516                	slli	a0,a0,0x5
 10006c0:	02000613          	li	a2,32
 10006c4:	4581                	li	a1,0
 10006c6:	12018793          	addi	a5,gp,288 # 1000f20 <uart_dev>
 10006ca:	953e                	add	a0,a0,a5
 10006cc:	2931                	jal	1000ae8 <memset>
	uart_dev[index].reg = index ? XBR820_UART1 : XBR820_UART0;
 10006ce:	c441                	beqz	s0,1000756 <uart_init+0xae>
 10006d0:	1f0606b7          	lui	a3,0x1f060
 10006d4:	00541793          	slli	a5,s0,0x5
 10006d8:	12018713          	addi	a4,gp,288 # 1000f20 <uart_dev>
 10006dc:	97ba                	add	a5,a5,a4
 10006de:	c394                	sw	a3,0(a5)
	uart_dev[index].irq = index ? UART1_RX_IRQn : UART0_RX_IRQn;
 10006e0:	cc35                	beqz	s0,100075c <uart_init+0xb4>
 10006e2:	4651                	li	a2,20
 10006e4:	00541793          	slli	a5,s0,0x5
 10006e8:	12018713          	addi	a4,gp,288 # 1000f20 <uart_dev>
 10006ec:	97ba                	add	a5,a5,a4
 10006ee:	c3d0                	sw	a2,4(a5)
	uart_dev[index].reg->enable = 0;
 10006f0:	0006a023          	sw	zero,0(a3) # 1f060000 <__bss_end__+0x1e05f0a0>
	if (config) {
 10006f4:	c8a5                	beqz	s1,1000764 <uart_init+0xbc>
		if (config->buf) {
 10006f6:	4094                	lw	a3,0(s1)
 10006f8:	0e068763          	beqz	a3,10007e6 <uart_init+0x13e>
			if (config->rsize) {
 10006fc:	0044c783          	lbu	a5,4(s1)
 1000700:	cb99                	beqz	a5,1000716 <uart_init+0x6e>
				uart_dev[index].rx_fifo.buffer = (uint8_t *)config->buf;
 1000702:	00541793          	slli	a5,s0,0x5
 1000706:	12018713          	addi	a4,gp,288 # 1000f20 <uart_dev>
 100070a:	97ba                	add	a5,a5,a4
 100070c:	cb94                	sw	a3,16(a5)
				uart_dev[index].rx_fifo.size = config->rsize;
 100070e:	0044c703          	lbu	a4,4(s1)
 1000712:	00e79423          	sh	a4,8(a5) # 1f020008 <__bss_end__+0x1e01f0a8>
			if (config->tsize) {
 1000716:	0054c783          	lbu	a5,5(s1)
 100071a:	cf99                	beqz	a5,1000738 <uart_init+0x90>
				uart_dev[index].tx_fifo.buffer = (uint8_t *)config->buf + config->rsize;
 100071c:	4094                	lw	a3,0(s1)
 100071e:	0044c783          	lbu	a5,4(s1)
 1000722:	96be                	add	a3,a3,a5
 1000724:	00541793          	slli	a5,s0,0x5
 1000728:	12018713          	addi	a4,gp,288 # 1000f20 <uart_dev>
 100072c:	97ba                	add	a5,a5,a4
 100072e:	cfd4                	sw	a3,28(a5)
				uart_dev[index].tx_fifo.size = config->tsize;
 1000730:	0054c703          	lbu	a4,5(s1)
 1000734:	00e79a23          	sh	a4,20(a5)
			if (UART_CFG_DEF != config->cfg)
 1000738:	0064c683          	lbu	a3,6(s1)
 100073c:	0ff00793          	li	a5,255
 1000740:	02f68063          	beq	a3,a5,1000760 <uart_init+0xb8>
				cfg = config->cfg & UART_CFG_MASK;
 1000744:	0386f693          	andi	a3,a3,56
			if (config->buad <= BAUD_921600)
 1000748:	0074c783          	lbu	a5,7(s1)
 100074c:	4749                	li	a4,18
 100074e:	00f77d63          	bgeu	a4,a5,1000768 <uart_init+0xc0>
	uint8_t buad = UART_BAUD;
 1000752:	47b9                	li	a5,14
 1000754:	a811                	j	1000768 <uart_init+0xc0>
	uart_dev[index].reg = index ? XBR820_UART1 : XBR820_UART0;
 1000756:	1f0506b7          	lui	a3,0x1f050
 100075a:	bfad                	j	10006d4 <uart_init+0x2c>
	uart_dev[index].irq = index ? UART1_RX_IRQn : UART0_RX_IRQn;
 100075c:	4649                	li	a2,18
 100075e:	b759                	j	10006e4 <uart_init+0x3c>
	uint8_t cfg = UART_CONFIG;
 1000760:	468d                	li	a3,3
 1000762:	b7dd                	j	1000748 <uart_init+0xa0>
	uint8_t buad = UART_BAUD;
 1000764:	47b9                	li	a5,14
	uint8_t cfg = UART_CONFIG;
 1000766:	468d                	li	a3,3
	uart_dev[index].reg->config = cfg;
 1000768:	00541493          	slli	s1,s0,0x5
 100076c:	12018713          	addi	a4,gp,288 # 1000f20 <uart_dev>
 1000770:	94ba                	add	s1,s1,a4
 1000772:	4098                	lw	a4,0(s1)
 1000774:	c354                	sw	a3,4(a4)
	divisor = (SYSTEM_CLOCK + buad_rates[buad]/2) / buad_rates[buad] - 1;
 1000776:	00279713          	slli	a4,a5,0x2
 100077a:	ee418793          	addi	a5,gp,-284 # 1000ce4 <buad_rates>
 100077e:	97ba                	add	a5,a5,a4
 1000780:	438c                	lw	a1,0(a5)
 1000782:	0015d513          	srli	a0,a1,0x1
 1000786:	00f427b7          	lui	a5,0xf42
 100078a:	40078793          	addi	a5,a5,1024 # f42400 <__stext-0xbdc00>
 100078e:	953e                	add	a0,a0,a5
 1000790:	24c5                	jal	1000a70 <__udivsi3>
 1000792:	157d                	addi	a0,a0,-1
	uart_dev[index].reg->baud_high = (divisor >> 8) & 0xff;
 1000794:	00855793          	srli	a5,a0,0x8
 1000798:	4098                	lw	a4,0(s1)
 100079a:	0ff7f793          	andi	a5,a5,255
 100079e:	cf1c                	sw	a5,24(a4)
	uart_dev[index].reg->baud_low = divisor & 0xff;
 10007a0:	409c                	lw	a5,0(s1)
 10007a2:	0ff57513          	andi	a0,a0,255
 10007a6:	cfc8                	sw	a0,28(a5)
	uart_dev[index].reg->rfifo = UART_RFIFO_CLR;
 10007a8:	409c                	lw	a5,0(s1)
 10007aa:	02000713          	li	a4,32
 10007ae:	d398                	sw	a4,32(a5)
	uart_dev[index].reg->enable |= 0xb0; // enable user define buadrate
 10007b0:	4098                	lw	a4,0(s1)
 10007b2:	431c                	lw	a5,0(a4)
 10007b4:	0b07e793          	ori	a5,a5,176
 10007b8:	c31c                	sw	a5,0(a4)
	if (uart_dev[index].rx_fifo.size) {
 10007ba:	0084d783          	lhu	a5,8(s1)
 10007be:	c79d                	beqz	a5,10007ec <uart_init+0x144>
		csi_vic_enable_irq(uart_dev[index].irq);
 10007c0:	40dc                	lw	a5,4(s1)
    CLIC->CLICINT[IRQn].IE |= CLIC_INTIE_IE_Msk;
 10007c2:	40078793          	addi	a5,a5,1024
 10007c6:	078a                	slli	a5,a5,0x2
 10007c8:	e0800737          	lui	a4,0xe0800
 10007cc:	97ba                	add	a5,a5,a4
 10007ce:	0017c703          	lbu	a4,1(a5)
 10007d2:	00176713          	ori	a4,a4,1
 10007d6:	00e780a3          	sb	a4,1(a5)
	return true;
 10007da:	4505                	li	a0,1
}
 10007dc:	40a2                	lw	ra,8(sp)
 10007de:	4412                	lw	s0,4(sp)
 10007e0:	4482                	lw	s1,0(sp)
 10007e2:	0131                	addi	sp,sp,12
 10007e4:	8082                	ret
	uint8_t buad = UART_BAUD;
 10007e6:	47b9                	li	a5,14
	uint8_t cfg = UART_CONFIG;
 10007e8:	468d                	li	a3,3
 10007ea:	bfbd                	j	1000768 <uart_init+0xc0>
	return true;
 10007ec:	4505                	li	a0,1
 10007ee:	b7fd                	j	10007dc <uart_init+0x134>

010007f0 <uart_send>:
		uart->int_err |= 0x02;
	}
	
}
#endif
FIFO_SIZE_t uart_send(int index, const void *data, FIFO_SIZE_t size, int timeout) {
 10007f0:	1111                	addi	sp,sp,-28
 10007f2:	cc06                	sw	ra,24(sp)
 10007f4:	ca22                	sw	s0,20(sp)
 10007f6:	c826                	sw	s1,16(sp)
 10007f8:	c62e                	sw	a1,12(sp)
 10007fa:	c232                	sw	a2,4(sp)
	uart_reg_t* uart;
	FIFO_SIZE_t cnt = 0;
	const uint8_t* ptr = (const uint8_t*)data;
	uint32_t start;

	if (index >= CONFIG_UART_NUM || !size)
 10007fc:	4785                	li	a5,1
 10007fe:	06a7c363          	blt	a5,a0,1000864 <uart_send+0x74>
 1000802:	84aa                	mv	s1,a0
 1000804:	8436                	mv	s0,a3
 1000806:	e601                	bnez	a2,100080e <uart_send+0x1e>
		return 0;
 1000808:	4792                	lw	a5,4(sp)
 100080a:	c43e                	sw	a5,8(sp)
 100080c:	a8a9                	j	1000866 <uart_send+0x76>
	start = tick_count();
 100080e:	352d                	jal	1000638 <tick_count>
 1000810:	c02a                	sw	a0,0(sp)
	uart = uart_dev[index].reg;
 1000812:	0496                	slli	s1,s1,0x5
 1000814:	12018793          	addi	a5,gp,288 # 1000f20 <uart_dev>
 1000818:	94be                	add	s1,s1,a5
 100081a:	4084                	lw	s1,0(s1)
	FIFO_SIZE_t cnt = 0;
 100081c:	c402                	sw	zero,8(sp)
		}
	}
	else
#endif
	{
		while (size) {
 100081e:	a081                	j	100085e <uart_send+0x6e>
			do {
				if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
					goto end;
			} while (uart->state & 0x07); // TX not idle
 1000820:	48dc                	lw	a5,20(s1)
 1000822:	8b9d                	andi	a5,a5,7
 1000824:	cb81                	beqz	a5,1000834 <uart_send+0x44>
				if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
 1000826:	fe044de3          	bltz	s0,1000820 <uart_send+0x30>
 100082a:	4502                	lw	a0,0(sp)
 100082c:	3d1d                	jal	1000662 <tick_diff_ms>
 100082e:	fe8549e3          	blt	a0,s0,1000820 <uart_send+0x30>
 1000832:	a815                	j	1000866 <uart_send+0x76>
			uart->int_err |= 0x02;
 1000834:	489c                	lw	a5,16(s1)
 1000836:	0027e793          	ori	a5,a5,2
 100083a:	c89c                	sw	a5,16(s1)
			uart->tx_data = *ptr++;
 100083c:	4732                	lw	a4,12(sp)
 100083e:	00074783          	lbu	a5,0(a4) # e0800000 <__bss_end__+0xdf7ff0a0>
 1000842:	c4dc                	sw	a5,12(s1)
			size--;
 1000844:	4792                	lw	a5,4(sp)
 1000846:	17fd                	addi	a5,a5,-1
 1000848:	07c2                	slli	a5,a5,0x10
 100084a:	83c1                	srli	a5,a5,0x10
 100084c:	c23e                	sw	a5,4(sp)
			cnt++;
 100084e:	47a2                	lw	a5,8(sp)
 1000850:	0785                	addi	a5,a5,1
 1000852:	07c2                	slli	a5,a5,0x10
 1000854:	83c1                	srli	a5,a5,0x10
 1000856:	c43e                	sw	a5,8(sp)
			uart->tx_data = *ptr++;
 1000858:	00170793          	addi	a5,a4,1
 100085c:	c63e                	sw	a5,12(sp)
		while (size) {
 100085e:	4792                	lw	a5,4(sp)
 1000860:	f3f9                	bnez	a5,1000826 <uart_send+0x36>
 1000862:	a011                	j	1000866 <uart_send+0x76>
		return 0;
 1000864:	c402                	sw	zero,8(sp)
		}
	}
end:
	return cnt;
}
 1000866:	4522                	lw	a0,8(sp)
 1000868:	40e2                	lw	ra,24(sp)
 100086a:	4452                	lw	s0,20(sp)
 100086c:	44c2                	lw	s1,16(sp)
 100086e:	0171                	addi	sp,sp,28
 1000870:	8082                	ret

01000872 <uart_receive>:

FIFO_SIZE_t uart_receive(int index, void *data, FIFO_SIZE_t size, int timeout) {
 1000872:	1111                	addi	sp,sp,-28
 1000874:	cc06                	sw	ra,24(sp)
 1000876:	ca22                	sw	s0,20(sp)
 1000878:	c826                	sw	s1,16(sp)
 100087a:	c42e                	sw	a1,8(sp)
 100087c:	c036                	sw	a3,0(sp)
	uart_reg_t* uart;
	FIFO_SIZE_t cnt = 0;
	uint8_t* ptr = (uint8_t*)data;
	uint32_t start;

	if (index >= CONFIG_UART_NUM || !size)
 100087e:	4785                	li	a5,1
 1000880:	06a7c463          	blt	a5,a0,10008e8 <uart_receive+0x76>
 1000884:	84aa                	mv	s1,a0
 1000886:	8432                	mv	s0,a2
 1000888:	e219                	bnez	a2,100088e <uart_receive+0x1c>
		return 0;
 100088a:	c232                	sw	a2,4(sp)
 100088c:	a8b9                	j	10008ea <uart_receive+0x78>
	start = tick_count();
 100088e:	336d                	jal	1000638 <tick_count>
 1000890:	c62a                	sw	a0,12(sp)
	uart = uart_dev[index].reg;
 1000892:	0496                	slli	s1,s1,0x5
 1000894:	12018793          	addi	a5,gp,288 # 1000f20 <uart_dev>
 1000898:	94be                	add	s1,s1,a5
 100089a:	4084                	lw	s1,0(s1)
	FIFO_SIZE_t cnt = 0;
 100089c:	c202                	sw	zero,4(sp)
		}		
	}
	else
#endif
	{
		while (size) {
 100089e:	a021                	j	10008a6 <uart_receive+0x34>
				uart->rfifo = UART_RFIFO_NEXT;
				uart->int_err |= 0x08;
				size--;
				cnt++;
			}
			if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
 10008a0:	4782                	lw	a5,0(sp)
 10008a2:	0207dd63          	bgez	a5,10008dc <uart_receive+0x6a>
		while (size) {
 10008a6:	04040263          	beqz	s0,10008ea <uart_receive+0x78>
			if (UART_RFIFO_MASK & uart->rfifo) {
 10008aa:	509c                	lw	a5,32(s1)
 10008ac:	8bbd                	andi	a5,a5,15
 10008ae:	dbed                	beqz	a5,10008a0 <uart_receive+0x2e>
				*ptr++ = (uint8_t)uart->rx_data;
 10008b0:	449c                	lw	a5,8(s1)
 10008b2:	4722                	lw	a4,8(sp)
 10008b4:	00f70023          	sb	a5,0(a4)
				uart->rfifo = UART_RFIFO_NEXT;
 10008b8:	47c1                	li	a5,16
 10008ba:	d09c                	sw	a5,32(s1)
				uart->int_err |= 0x08;
 10008bc:	489c                	lw	a5,16(s1)
 10008be:	0087e793          	ori	a5,a5,8
 10008c2:	c89c                	sw	a5,16(s1)
				size--;
 10008c4:	147d                	addi	s0,s0,-1
 10008c6:	0442                	slli	s0,s0,0x10
 10008c8:	8041                	srli	s0,s0,0x10
				cnt++;
 10008ca:	4792                	lw	a5,4(sp)
 10008cc:	0785                	addi	a5,a5,1
 10008ce:	07c2                	slli	a5,a5,0x10
 10008d0:	83c1                	srli	a5,a5,0x10
 10008d2:	c23e                	sw	a5,4(sp)
				*ptr++ = (uint8_t)uart->rx_data;
 10008d4:	00170793          	addi	a5,a4,1
 10008d8:	c43e                	sw	a5,8(sp)
 10008da:	b7d9                	j	10008a0 <uart_receive+0x2e>
			if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
 10008dc:	4532                	lw	a0,12(sp)
 10008de:	3351                	jal	1000662 <tick_diff_ms>
 10008e0:	4782                	lw	a5,0(sp)
 10008e2:	fcf542e3          	blt	a0,a5,10008a6 <uart_receive+0x34>
 10008e6:	a011                	j	10008ea <uart_receive+0x78>
		return 0;
 10008e8:	c202                	sw	zero,4(sp)
				break;
		}
	}
	return cnt;
}
 10008ea:	4512                	lw	a0,4(sp)
 10008ec:	40e2                	lw	ra,24(sp)
 10008ee:	4452                	lw	s0,20(sp)
 10008f0:	44c2                	lw	s1,16(sp)
 10008f2:	0171                	addi	sp,sp,28
 10008f4:	8082                	ret

010008f6 <console_init>:

static int console_handle;
#ifdef CONFIG_CONSOLE_RXSIZE
static uint8_t console_buffer[CONFIG_CONSOLE_RXSIZE + CONFIG_CONSOLE_TXSIZE];
#endif
void console_init(void) {
 10008f6:	1151                	addi	sp,sp,-12
 10008f8:	c406                	sw	ra,8(sp)
	config.tsize = CONFIG_CONSOLE_TXSIZE;
	config.cfg = UART_CONFIG;
	config.buad = UART_BAUD;
	uart_init(CONFIG_CONSOLE_HANDLE, &config);
#else
	uart_init(CONFIG_CONSOLE_HANDLE, 0);
 10008fa:	4581                	li	a1,0
 10008fc:	4505                	li	a0,1
 10008fe:	336d                	jal	10006a8 <uart_init>
#endif
	console_handle = CONFIG_CONSOLE_HANDLE;
 1000900:	4705                	li	a4,1
 1000902:	04e1ae23          	sw	a4,92(gp) # 1000e5c <console_handle>
}
 1000906:	40a2                	lw	ra,8(sp)
 1000908:	0131                	addi	sp,sp,12
 100090a:	8082                	ret

0100090c <getchar>:
	if (uart_send(console_handle, &ch, 1, CONFIG_CONSOLE_TXTIMEOUT) != 1)
		return CONSOLE_EOF;
	return 1;
}

int getchar(void) {
 100090c:	1141                	addi	sp,sp,-16
 100090e:	c606                	sw	ra,12(sp)
	uint8_t ch;

	if (uart_receive(console_handle, &ch, 1, CONFIG_CONSOLE_RXTIMEOUT) != 1)
 1000910:	4685                	li	a3,1
 1000912:	4605                	li	a2,1
 1000914:	00310593          	addi	a1,sp,3
 1000918:	05c1a503          	lw	a0,92(gp) # 1000e5c <console_handle>
 100091c:	3f99                	jal	1000872 <uart_receive>
 100091e:	4785                	li	a5,1
 1000920:	00f51763          	bne	a0,a5,100092e <getchar+0x22>
		return CONSOLE_EOF;
	return (int)ch;
 1000924:	00314503          	lbu	a0,3(sp)
}
 1000928:	40b2                	lw	ra,12(sp)
 100092a:	0141                	addi	sp,sp,16
 100092c:	8082                	ret
		return CONSOLE_EOF;
 100092e:	557d                	li	a0,-1
 1000930:	bfe5                	j	1000928 <getchar+0x1c>

01000932 <putchar>:

int putchar(int ch) {
 1000932:	1141                	addi	sp,sp,-16
 1000934:	c606                	sw	ra,12(sp)
 1000936:	c422                	sw	s0,8(sp)
 1000938:	842a                	mv	s0,a0
	if (ch == '\n') {
 100093a:	47a9                	li	a5,10
 100093c:	02f50163          	beq	a0,a5,100095e <putchar+0x2c>
		if (_putc('\r') != 1)
			return CONSOLE_EOF;
	}
	return _putc(ch);
 1000940:	c022                	sw	s0,0(sp)
	if (uart_send(console_handle, &ch, 1, CONFIG_CONSOLE_TXTIMEOUT) != 1)
 1000942:	4685                	li	a3,1
 1000944:	4605                	li	a2,1
 1000946:	858a                	mv	a1,sp
 1000948:	05c1a503          	lw	a0,92(gp) # 1000e5c <console_handle>
 100094c:	3555                	jal	10007f0 <uart_send>
 100094e:	4785                	li	a5,1
 1000950:	02f51463          	bne	a0,a5,1000978 <putchar+0x46>
	return 1;
 1000954:	4505                	li	a0,1
}
 1000956:	40b2                	lw	ra,12(sp)
 1000958:	4422                	lw	s0,8(sp)
 100095a:	0141                	addi	sp,sp,16
 100095c:	8082                	ret
		if (_putc('\r') != 1)
 100095e:	47b5                	li	a5,13
 1000960:	c03e                	sw	a5,0(sp)
	if (uart_send(console_handle, &ch, 1, CONFIG_CONSOLE_TXTIMEOUT) != 1)
 1000962:	4685                	li	a3,1
 1000964:	4605                	li	a2,1
 1000966:	858a                	mv	a1,sp
 1000968:	05c1a503          	lw	a0,92(gp) # 1000e5c <console_handle>
 100096c:	3551                	jal	10007f0 <uart_send>
 100096e:	4785                	li	a5,1
 1000970:	fcf508e3          	beq	a0,a5,1000940 <putchar+0xe>
			return CONSOLE_EOF;
 1000974:	557d                	li	a0,-1
 1000976:	b7c5                	j	1000956 <putchar+0x24>
		return CONSOLE_EOF;
 1000978:	557d                	li	a0,-1
	return _putc(ch);
 100097a:	bff1                	j	1000956 <putchar+0x24>

0100097c <puts>:

int puts(const char * str) {
 100097c:	1151                	addi	sp,sp,-12
 100097e:	c406                	sw	ra,8(sp)
 1000980:	c222                	sw	s0,4(sp)
 1000982:	c026                	sw	s1,0(sp)
 1000984:	842a                	mv	s0,a0
	int cnt = 0;
 1000986:	4481                	li	s1,0
	while (*str) {
 1000988:	00044503          	lbu	a0,0(s0)
 100098c:	c901                	beqz	a0,100099c <puts+0x20>
		if (putchar(*str++) != 1)
 100098e:	0405                	addi	s0,s0,1
 1000990:	374d                	jal	1000932 <putchar>
 1000992:	4785                	li	a5,1
 1000994:	00f51463          	bne	a0,a5,100099c <puts+0x20>
			break;
		cnt++;
 1000998:	0485                	addi	s1,s1,1
 100099a:	b7fd                	j	1000988 <puts+0xc>
	}
	return cnt;
}
 100099c:	8526                	mv	a0,s1
 100099e:	40a2                	lw	ra,8(sp)
 10009a0:	4412                	lw	s0,4(sp)
 10009a2:	4482                	lw	s1,0(sp)
 10009a4:	0131                	addi	sp,sp,12
 10009a6:	8082                	ret

010009a8 <put_h8>:
}

#else

static const char HEX_TABLE[] = {"0123456789ABCDEF"};
int put_h8(uint8_t byte) {
 10009a8:	1141                	addi	sp,sp,-16
 10009aa:	c606                	sw	ra,12(sp)
 10009ac:	c422                	sw	s0,8(sp)
 10009ae:	842a                	mv	s0,a0
	if (_putc(HEX_TABLE[(byte >> 4) & 0x0F]) != 1)
 10009b0:	00455713          	srli	a4,a0,0x4
 10009b4:	f3018793          	addi	a5,gp,-208 # 1000d30 <HEX_TABLE>
 10009b8:	97ba                	add	a5,a5,a4
 10009ba:	0007c783          	lbu	a5,0(a5)
 10009be:	c03e                	sw	a5,0(sp)
	if (uart_send(console_handle, &ch, 1, CONFIG_CONSOLE_TXTIMEOUT) != 1)
 10009c0:	4685                	li	a3,1
 10009c2:	4605                	li	a2,1
 10009c4:	858a                	mv	a1,sp
 10009c6:	05c1a503          	lw	a0,92(gp) # 1000e5c <console_handle>
 10009ca:	351d                	jal	10007f0 <uart_send>
 10009cc:	4785                	li	a5,1
 10009ce:	02f51463          	bne	a0,a5,10009f6 <put_h8+0x4e>
		return CONSOLE_EOF;
	if (_putc(HEX_TABLE[byte & 0x0F]) != 1)
 10009d2:	883d                	andi	s0,s0,15
 10009d4:	f3018793          	addi	a5,gp,-208 # 1000d30 <HEX_TABLE>
 10009d8:	943e                	add	s0,s0,a5
 10009da:	00044783          	lbu	a5,0(s0)
 10009de:	c03e                	sw	a5,0(sp)
	if (uart_send(console_handle, &ch, 1, CONFIG_CONSOLE_TXTIMEOUT) != 1)
 10009e0:	4685                	li	a3,1
 10009e2:	4605                	li	a2,1
 10009e4:	858a                	mv	a1,sp
 10009e6:	05c1a503          	lw	a0,92(gp) # 1000e5c <console_handle>
 10009ea:	3519                	jal	10007f0 <uart_send>
 10009ec:	4785                	li	a5,1
 10009ee:	00f51963          	bne	a0,a5,1000a00 <put_h8+0x58>
		return CONSOLE_EOF;
	return 2;
 10009f2:	4509                	li	a0,2
 10009f4:	a011                	j	10009f8 <put_h8+0x50>
		return CONSOLE_EOF;
 10009f6:	557d                	li	a0,-1
}
 10009f8:	40b2                	lw	ra,12(sp)
 10009fa:	4422                	lw	s0,8(sp)
 10009fc:	0141                	addi	sp,sp,16
 10009fe:	8082                	ret
		return CONSOLE_EOF;
 1000a00:	557d                	li	a0,-1
 1000a02:	bfdd                	j	10009f8 <put_h8+0x50>

01000a04 <put_h16>:

int put_h16(uint16_t word) {
 1000a04:	1151                	addi	sp,sp,-12
 1000a06:	c406                	sw	ra,8(sp)
 1000a08:	c222                	sw	s0,4(sp)
 1000a0a:	842a                	mv	s0,a0
	if (put_h8(word >> 8) != 2)
 1000a0c:	8121                	srli	a0,a0,0x8
 1000a0e:	3f69                	jal	10009a8 <put_h8>
 1000a10:	4789                	li	a5,2
 1000a12:	00f51d63          	bne	a0,a5,1000a2c <put_h16+0x28>
		return CONSOLE_EOF;
	if (put_h8(word) != 2)
 1000a16:	0ff47513          	andi	a0,s0,255
 1000a1a:	3779                	jal	10009a8 <put_h8>
 1000a1c:	4789                	li	a5,2
 1000a1e:	00f51963          	bne	a0,a5,1000a30 <put_h16+0x2c>
		return CONSOLE_EOF;
	return 4;
 1000a22:	4511                	li	a0,4
}
 1000a24:	40a2                	lw	ra,8(sp)
 1000a26:	4412                	lw	s0,4(sp)
 1000a28:	0131                	addi	sp,sp,12
 1000a2a:	8082                	ret
		return CONSOLE_EOF;
 1000a2c:	557d                	li	a0,-1
 1000a2e:	bfdd                	j	1000a24 <put_h16+0x20>
		return CONSOLE_EOF;
 1000a30:	557d                	li	a0,-1
 1000a32:	bfcd                	j	1000a24 <put_h16+0x20>

01000a34 <put_h32>:

int put_h32(uint32_t dword) {
 1000a34:	1151                	addi	sp,sp,-12
 1000a36:	c406                	sw	ra,8(sp)
 1000a38:	c222                	sw	s0,4(sp)
 1000a3a:	842a                	mv	s0,a0
	if (put_h16(dword >> 16) != 4)
 1000a3c:	8141                	srli	a0,a0,0x10
 1000a3e:	37d9                	jal	1000a04 <put_h16>
 1000a40:	4791                	li	a5,4
 1000a42:	00f51e63          	bne	a0,a5,1000a5e <put_h32+0x2a>
		return CONSOLE_EOF;
	if (put_h16(dword) != 4)
 1000a46:	01041513          	slli	a0,s0,0x10
 1000a4a:	8141                	srli	a0,a0,0x10
 1000a4c:	3f65                	jal	1000a04 <put_h16>
 1000a4e:	4791                	li	a5,4
 1000a50:	00f51963          	bne	a0,a5,1000a62 <put_h32+0x2e>
		return CONSOLE_EOF;
	return 8;
 1000a54:	4521                	li	a0,8
}
 1000a56:	40a2                	lw	ra,8(sp)
 1000a58:	4412                	lw	s0,4(sp)
 1000a5a:	0131                	addi	sp,sp,12
 1000a5c:	8082                	ret
		return CONSOLE_EOF;
 1000a5e:	557d                	li	a0,-1
 1000a60:	bfdd                	j	1000a56 <put_h32+0x22>
		return CONSOLE_EOF;
 1000a62:	557d                	li	a0,-1
 1000a64:	bfcd                	j	1000a56 <put_h32+0x22>
	...

01000a68 <__divsi3>:
 1000a68:	02054e63          	bltz	a0,1000aa4 <__umodsi3+0x8>
 1000a6c:	0405c363          	bltz	a1,1000ab2 <__umodsi3+0x16>

01000a70 <__udivsi3>:
 1000a70:	862e                	mv	a2,a1
 1000a72:	85aa                	mv	a1,a0
 1000a74:	557d                	li	a0,-1
 1000a76:	c215                	beqz	a2,1000a9a <__udivsi3+0x2a>
 1000a78:	4685                	li	a3,1
 1000a7a:	00b67863          	bgeu	a2,a1,1000a8a <__udivsi3+0x1a>
 1000a7e:	00c05663          	blez	a2,1000a8a <__udivsi3+0x1a>
 1000a82:	0606                	slli	a2,a2,0x1
 1000a84:	0686                	slli	a3,a3,0x1
 1000a86:	feb66ce3          	bltu	a2,a1,1000a7e <__udivsi3+0xe>
 1000a8a:	4501                	li	a0,0
 1000a8c:	00c5e463          	bltu	a1,a2,1000a94 <__udivsi3+0x24>
 1000a90:	8d91                	sub	a1,a1,a2
 1000a92:	8d55                	or	a0,a0,a3
 1000a94:	8285                	srli	a3,a3,0x1
 1000a96:	8205                	srli	a2,a2,0x1
 1000a98:	faf5                	bnez	a3,1000a8c <__udivsi3+0x1c>
 1000a9a:	8082                	ret

01000a9c <__umodsi3>:
 1000a9c:	8286                	mv	t0,ra
 1000a9e:	3fc9                	jal	1000a70 <__udivsi3>
 1000aa0:	852e                	mv	a0,a1
 1000aa2:	8282                	jr	t0
 1000aa4:	40a00533          	neg	a0,a0
 1000aa8:	0005d763          	bgez	a1,1000ab6 <__umodsi3+0x1a>
 1000aac:	40b005b3          	neg	a1,a1
 1000ab0:	b7c1                	j	1000a70 <__udivsi3>
 1000ab2:	40b005b3          	neg	a1,a1
 1000ab6:	8286                	mv	t0,ra
 1000ab8:	3f65                	jal	1000a70 <__udivsi3>
 1000aba:	40a00533          	neg	a0,a0
 1000abe:	8282                	jr	t0

01000ac0 <__modsi3>:
 1000ac0:	8286                	mv	t0,ra
 1000ac2:	0005c763          	bltz	a1,1000ad0 <__modsi3+0x10>
 1000ac6:	00054963          	bltz	a0,1000ad8 <__modsi3+0x18>
 1000aca:	375d                	jal	1000a70 <__udivsi3>
 1000acc:	852e                	mv	a0,a1
 1000ace:	8282                	jr	t0
 1000ad0:	40b005b3          	neg	a1,a1
 1000ad4:	fe055be3          	bgez	a0,1000aca <__modsi3+0xa>
 1000ad8:	40a00533          	neg	a0,a0
 1000adc:	3f51                	jal	1000a70 <__udivsi3>
 1000ade:	40b00533          	neg	a0,a1
 1000ae2:	8282                	jr	t0
 1000ae4:	0000                	unimp
	...

01000ae8 <memset>:
 1000ae8:	433d                	li	t1,15
 1000aea:	872a                	mv	a4,a0
 1000aec:	02c37563          	bgeu	t1,a2,1000b16 <memset+0x2e>
 1000af0:	00f77793          	andi	a5,a4,15
 1000af4:	e3c9                	bnez	a5,1000b76 <memset+0x8e>
 1000af6:	06059763          	bnez	a1,1000b64 <memset+0x7c>
 1000afa:	ff067693          	andi	a3,a2,-16
 1000afe:	8a3d                	andi	a2,a2,15
 1000b00:	96ba                	add	a3,a3,a4
 1000b02:	c30c                	sw	a1,0(a4)
 1000b04:	c34c                	sw	a1,4(a4)
 1000b06:	c70c                	sw	a1,8(a4)
 1000b08:	c74c                	sw	a1,12(a4)
 1000b0a:	0741                	addi	a4,a4,16
 1000b0c:	fed76be3          	bltu	a4,a3,1000b02 <memset+0x1a>
 1000b10:	00061363          	bnez	a2,1000b16 <memset+0x2e>
 1000b14:	8082                	ret
 1000b16:	40c306b3          	sub	a3,t1,a2
 1000b1a:	068a                	slli	a3,a3,0x2
 1000b1c:	00000297          	auipc	t0,0x0
 1000b20:	9696                	add	a3,a3,t0
 1000b22:	00a68067          	jr	10(a3) # 1f05000a <__bss_end__+0x1e04f0aa>
 1000b26:	00b70723          	sb	a1,14(a4)
 1000b2a:	00b706a3          	sb	a1,13(a4)
 1000b2e:	00b70623          	sb	a1,12(a4)
 1000b32:	00b705a3          	sb	a1,11(a4)
 1000b36:	00b70523          	sb	a1,10(a4)
 1000b3a:	00b704a3          	sb	a1,9(a4)
 1000b3e:	00b70423          	sb	a1,8(a4)
 1000b42:	00b703a3          	sb	a1,7(a4)
 1000b46:	00b70323          	sb	a1,6(a4)
 1000b4a:	00b702a3          	sb	a1,5(a4)
 1000b4e:	00b70223          	sb	a1,4(a4)
 1000b52:	00b701a3          	sb	a1,3(a4)
 1000b56:	00b70123          	sb	a1,2(a4)
 1000b5a:	00b700a3          	sb	a1,1(a4)
 1000b5e:	00b70023          	sb	a1,0(a4)
 1000b62:	8082                	ret
 1000b64:	0ff5f593          	andi	a1,a1,255
 1000b68:	00859693          	slli	a3,a1,0x8
 1000b6c:	8dd5                	or	a1,a1,a3
 1000b6e:	01059693          	slli	a3,a1,0x10
 1000b72:	8dd5                	or	a1,a1,a3
 1000b74:	b759                	j	1000afa <memset+0x12>
 1000b76:	00279693          	slli	a3,a5,0x2
 1000b7a:	00000297          	auipc	t0,0x0
 1000b7e:	9696                	add	a3,a3,t0
 1000b80:	8286                	mv	t0,ra
 1000b82:	fa8680e7          	jalr	-88(a3)
 1000b86:	8096                	mv	ra,t0
 1000b88:	17c1                	addi	a5,a5,-16
 1000b8a:	8f1d                	sub	a4,a4,a5
 1000b8c:	963e                	add	a2,a2,a5
 1000b8e:	f8c374e3          	bgeu	t1,a2,1000b16 <memset+0x2e>
 1000b92:	b795                	j	1000af6 <memset+0xe>
 1000b94:	0000                	unimp
	...

01000b98 <strcmp>:
 1000b98:	00b56733          	or	a4,a0,a1
 1000b9c:	53fd                	li	t2,-1
 1000b9e:	8b0d                	andi	a4,a4,3
 1000ba0:	e779                	bnez	a4,1000c6e <strcmp+0xd6>
 1000ba2:	7f7f87b7          	lui	a5,0x7f7f8
 1000ba6:	f7f78793          	addi	a5,a5,-129 # 7f7f7f7f <__bss_end__+0x7e7f701f>
 1000baa:	4110                	lw	a2,0(a0)
 1000bac:	4194                	lw	a3,0(a1)
 1000bae:	00f672b3          	and	t0,a2,a5
 1000bb2:	00f66333          	or	t1,a2,a5
 1000bb6:	92be                	add	t0,t0,a5
 1000bb8:	0062e2b3          	or	t0,t0,t1
 1000bbc:	0c729863          	bne	t0,t2,1000c8c <strcmp+0xf4>
 1000bc0:	06d61863          	bne	a2,a3,1000c30 <strcmp+0x98>
 1000bc4:	4150                	lw	a2,4(a0)
 1000bc6:	41d4                	lw	a3,4(a1)
 1000bc8:	00f672b3          	and	t0,a2,a5
 1000bcc:	00f66333          	or	t1,a2,a5
 1000bd0:	92be                	add	t0,t0,a5
 1000bd2:	0062e2b3          	or	t0,t0,t1
 1000bd6:	0a729963          	bne	t0,t2,1000c88 <strcmp+0xf0>
 1000bda:	04d61b63          	bne	a2,a3,1000c30 <strcmp+0x98>
 1000bde:	4510                	lw	a2,8(a0)
 1000be0:	4594                	lw	a3,8(a1)
 1000be2:	00f672b3          	and	t0,a2,a5
 1000be6:	00f66333          	or	t1,a2,a5
 1000bea:	92be                	add	t0,t0,a5
 1000bec:	0062e2b3          	or	t0,t0,t1
 1000bf0:	0a729263          	bne	t0,t2,1000c94 <strcmp+0xfc>
 1000bf4:	02d61e63          	bne	a2,a3,1000c30 <strcmp+0x98>
 1000bf8:	4550                	lw	a2,12(a0)
 1000bfa:	45d4                	lw	a3,12(a1)
 1000bfc:	00f672b3          	and	t0,a2,a5
 1000c00:	00f66333          	or	t1,a2,a5
 1000c04:	92be                	add	t0,t0,a5
 1000c06:	0062e2b3          	or	t0,t0,t1
 1000c0a:	08729b63          	bne	t0,t2,1000ca0 <strcmp+0x108>
 1000c0e:	02d61163          	bne	a2,a3,1000c30 <strcmp+0x98>
 1000c12:	4910                	lw	a2,16(a0)
 1000c14:	4994                	lw	a3,16(a1)
 1000c16:	00f672b3          	and	t0,a2,a5
 1000c1a:	00f66333          	or	t1,a2,a5
 1000c1e:	92be                	add	t0,t0,a5
 1000c20:	0062e2b3          	or	t0,t0,t1
 1000c24:	08729463          	bne	t0,t2,1000cac <strcmp+0x114>
 1000c28:	0551                	addi	a0,a0,20
 1000c2a:	05d1                	addi	a1,a1,20
 1000c2c:	f6d60fe3          	beq	a2,a3,1000baa <strcmp+0x12>
 1000c30:	01061713          	slli	a4,a2,0x10
 1000c34:	01069793          	slli	a5,a3,0x10
 1000c38:	00f71c63          	bne	a4,a5,1000c50 <strcmp+0xb8>
 1000c3c:	01065713          	srli	a4,a2,0x10
 1000c40:	0106d793          	srli	a5,a3,0x10
 1000c44:	40f70533          	sub	a0,a4,a5
 1000c48:	0ff57593          	andi	a1,a0,255
 1000c4c:	e991                	bnez	a1,1000c60 <strcmp+0xc8>
 1000c4e:	8082                	ret
 1000c50:	8341                	srli	a4,a4,0x10
 1000c52:	83c1                	srli	a5,a5,0x10
 1000c54:	40f70533          	sub	a0,a4,a5
 1000c58:	0ff57593          	andi	a1,a0,255
 1000c5c:	e191                	bnez	a1,1000c60 <strcmp+0xc8>
 1000c5e:	8082                	ret
 1000c60:	0ff77713          	andi	a4,a4,255
 1000c64:	0ff7f793          	andi	a5,a5,255
 1000c68:	40f70533          	sub	a0,a4,a5
 1000c6c:	8082                	ret
 1000c6e:	00054603          	lbu	a2,0(a0)
 1000c72:	0005c683          	lbu	a3,0(a1)
 1000c76:	0505                	addi	a0,a0,1
 1000c78:	0585                	addi	a1,a1,1
 1000c7a:	00d61463          	bne	a2,a3,1000c82 <strcmp+0xea>
 1000c7e:	fe0618e3          	bnez	a2,1000c6e <strcmp+0xd6>
 1000c82:	40d60533          	sub	a0,a2,a3
 1000c86:	8082                	ret
 1000c88:	0511                	addi	a0,a0,4
 1000c8a:	0591                	addi	a1,a1,4
 1000c8c:	fed611e3          	bne	a2,a3,1000c6e <strcmp+0xd6>
 1000c90:	4501                	li	a0,0
 1000c92:	8082                	ret
 1000c94:	0521                	addi	a0,a0,8
 1000c96:	05a1                	addi	a1,a1,8
 1000c98:	fcd61be3          	bne	a2,a3,1000c6e <strcmp+0xd6>
 1000c9c:	4501                	li	a0,0
 1000c9e:	8082                	ret
 1000ca0:	0531                	addi	a0,a0,12
 1000ca2:	05b1                	addi	a1,a1,12
 1000ca4:	fcd615e3          	bne	a2,a3,1000c6e <strcmp+0xd6>
 1000ca8:	4501                	li	a0,0
 1000caa:	8082                	ret
 1000cac:	0541                	addi	a0,a0,16
 1000cae:	05c1                	addi	a1,a1,16
 1000cb0:	fad61fe3          	bne	a2,a3,1000c6e <strcmp+0xd6>
 1000cb4:	4501                	li	a0,0
 1000cb6:	8082                	ret
	...
