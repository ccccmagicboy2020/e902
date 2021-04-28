#include "xbr820.h"
#include "driver.h"
#include "console.h"
#include "shell.h"
#include <string.h>

#ifndef CONFIG_SH_MAX_ARGS
 #define CONFIG_SH_MAX_ARGS		5
#endif
#ifndef CONFIG_SH_ARGV_MAXSIZE
 #define CONFIG_SH_ARGV_MAXSIZE	12
#endif
#ifndef CONFIG_SH_CMDLINE_SIZE
 #define CONFIG_SH_CMDLINE_SIZE	64
#endif

#ifdef CONFIG_SHELL
typedef struct {
	int error;
	char* argv[CONFIG_SH_MAX_ARGS];
	char cmdline[CONFIG_SH_CMDLINE_SIZE];
	uint8_t offs;
	uint8_t argc;
} sh_priv_t;

static const char prompt[] = "\n:>";
static sh_priv_t sh;

static void dump_bytes(const void *buf, uint16_t bytes)
{
	const uint8_t *p = (const uint8_t *)buf;
	uint16_t i, cols, offs = ((uint32_t)buf) & 0xffff;

	puts("     ");
	cols = (bytes > 16) ? 16 : bytes;
	for (i = 0; i < cols; i++) {
		#ifdef CONFIG_PRINTF
		print(" %02x", (offs+i) & 0x0f);
		#else
		putchar(' ');
		put_h8((offs+i) & 0x0f);
		#endif
	}
	putchar('\n');
	for (i = 0; i < bytes; i++, offs++, p++) {
		if (!(i & 0x0f))
		#ifdef CONFIG_PRINTF
			print("%04x:", offs);
		print(" %02X", *p);
		#else
		{
			put_h16(offs);
			putchar(':');
		}
		putchar(' ');
		put_h8(*p);
		#endif
		if (0x0f == (i & 0x0f))
			putchar('\n');
	}
	if (i & 0x0f)
		putchar('\n');
}

static void dump_words(const void *buf, uint16_t words)
{
	ro32_t *p = (ro32_t *)buf;
	uint16_t i, offs = ((uint32_t)buf) & 0xffff;

	for (i = 0; i < words; i++, offs+=4, p++) {
		if (!(i & 0x03))
		#ifdef CONFIG_PRINTF
			print("%04x:", offs);
		print(" %08X", *p);
		#else
		{
			put_h16(offs);
			putchar(':');
		}
		putchar(' ');
		put_h32(*p);
		#endif
		if (0x03 == (i & 0x03))
			putchar('\n');
	}
	if (i & 0x03)
		putchar('\n');
}

#define XBR820_SRAM_END (XBR820_SRAM_BASE + XBR820_SRAM_SIZE)
#define IS_SRAM(addr)	((uint32_t)(addr) >= XBR820_SRAM_BASE \
							&& (uint32_t)(addr) < XBR820_SRAM_END)
void dump(const void *buf, uint16_t count) {
	putchar('\n');
	if (IS_SRAM(buf))
		dump_bytes(buf, count);
	else
		dump_words(buf, count);
}

uint32_t stoi(const char* s) {
	bool hex, at = false;
	uint32_t val = 0;
	
//	while (*s) {
//		if (*s != ' ' && *s != '\t')
//			break;
//		s++;
//	}
	if ('*' == *s) {
		at = true;
		s++;
	}
	hex = ('0' == s[0] && ('x' == s[1] || 'X' == s[1]));
	if (hex) {
		for (s += 2; *s; s++) {
			if (*s >= '0' && *s <= '9')
				val = (val << 4) | (*s - '0');
			else if (*s >= 'A' && *s <= 'F')
				val = (val << 4) | (*s - 'A' + 10);
			else if (*s >= 'a' && *s <= 'f')
				val = (val << 4) | (*s - 'a' + 10);
			else
				break;
		}
	}
	else {
		bool minus = false;
		if ('-' == *s) {
			minus = true;
			s++;
		}
		while (*s >= '0' && *s <= '9') {
			val = val * 10 + (*s - '0');
			s++;
		}
		if (minus)
			val = (uint32_t)(-(int)val);
	}
	if (at)
		return reg32_read(val);
	else
		return val;
}

#ifdef CONFIG_CMD_DUMP
static int cmd_dump(uint8_t argc, char*argv[]) {
	uint8_t byte = 0;
	uint16_t count = 1;
	uint32_t addr;
	if (argc < 2) {
		#ifdef CONFIG_PRINTF
		print("Usage: %s <addr> [count]\n", argv[0]);
		#else
		puts("Usage: ");
		puts(argv[0]);
		puts(" <addr> [count]\n");
		#endif
		return EINVAL;
	}

	if (argc > 2)
		count = stoi(argv[2]);
	addr = stoi(argv[1]);
	byte  = IS_SRAM(addr);
	#ifdef CONFIG_PRINTF
	print("Dump %u %s at 0x%x:\n", count, byte ? "bytes" : "words", addr);
	#else
	puts("Dump 0x");
	put_h16(count);
	puts(byte ? "bytes" : "words");
	puts(" at 0x");
	put_h32(addr);
	#endif
	dump((const void *)addr, count);
	return EOK;
}
#endif


#ifdef CONFIG_CMD_READ
static int cmd_read(uint8_t argc, char*argv[]) {
	uint8_t byte = 0;
	uint16_t offs = 0, count = 1;
	uint32_t addr, from = INVALID_ADDRESS;
	if (argc < 2) {
		#ifdef CONFIG_PRINTF
		print("Usage: %s <addr> [count] [compare addr]\n", argv[0]);
		#else
		puts("Usage: ");
		puts(argv[0]);
		puts(" <addr> [count] [compare addr]\n");
		#endif
		return EINVAL;
	}
	if (argc > 2) {
		addr = stoi(argv[2]);
		if (addr & 0xffff)
			count = addr;
		if (argc > 3)
			from = stoi(argv[3]);
	}
	addr = stoi(argv[1]);
	byte  = IS_SRAM(addr);
	if (INVALID_ADDRESS != from) {
		#ifdef CONFIG_PRINTF
		print("Compare %u %s from 0x%x to 0x%x, ", count, byte ? "bytes" : "words", from, addr);
		#else
		puts("Compare 0x");
		put_h16(count);
		puts(byte ? "bytes" : "words");
		puts(" from 0x");
		put_h32(from);
		puts(" to 0x");
		put_h32(addr);
		#endif
		if (byte) {
			const uint8_t* dst = (const uint8_t*)addr;
			const uint8_t * src = (const uint8_t*)from;
			
			while (offs < count) {
				if (*dst != *src)
					break;
				dst++;
				src++;
			}
			if (offs != count)
			#ifdef CONFIG_PRINTF
				print("0x%02x != 0x%02x at offset 0x%x\n", *src, *dst, offs);
			#else
			{
				puts("0x");
				put_h8(*src);
				puts(" != 0x");
				put_h8(*dst);
				puts(" at offset 0x");
				put_h16(offs);
				putchar('\n');
			}
			#endif
			else
				puts("is same.\n");
		}
		else {
			ro32_t* dst = (ro32_t*)addr;
			ro32_t* src = (ro32_t*)from;
			
			while (offs < count) {
				if (*dst != *src)
					break;
				dst++;
				src++;
			}
			if (offs != count)
			#ifdef CONFIG_PRINTF
				print("0x%08x != 0x%08x at offset 0x%x\n", *src, *dst, offs);
			#else
			{
				puts("0x");
				put_h32(*src);
				puts(" != 0x");
				put_h32(*dst);
				puts(" at offset 0x");
				put_h16(offs);
				putchar('\n');
			}
			#endif
			else
				puts("is same.\n");
		}
	}
	else {
		#ifdef CONFIG_PRINTF
		print("Dump %u %s at 0x%x:\n", count, byte ? "bytes" : "words", addr);
		#else
		puts("Dump 0x");
		put_h16(count);
		puts(byte ? "bytes" : "words");
		puts(" at 0x");
		put_h32(addr);
		#endif
		dump((const void *)addr, count);
	}
	return EOK;
}
#endif
#ifdef CONFIG_CMD_WRITE
static int cmd_write(uint8_t argc, char*argv[]) {
	uint8_t from, byte, seq = 0;
	uint16_t count = 1;
	uint32_t addr, data;

	if (argc < 3) {
		#ifdef CONFIG_PRINTF
		print("Usage: %s <addr> <[!]data|&from> [count]\n", argv[0]);
		#else
		puts("Usage: ");
		puts(argv[0]);
		puts(" <addr> <[!]data|&from> [count]\n");
		#endif
		return EINVAL;
	}
	if (argc > 3) {
		addr = stoi(argv[3]);
		if (addr & 0xffff)
			count = addr;
	}
	if ('&' == argv[2][0]) {
		data = stoi(&(argv[2][1]));
		from = 1;
	}
	else if ('!' == argv[2][0]) {
		data = stoi(&(argv[2][1]));
		seq = 1;
	}
	else
		data = stoi(argv[2]);
	addr = stoi(argv[1]);
	byte  = IS_SRAM(addr);
	if (from) {
		if (byte) {
			uint8_t* dst = (uint8_t*)addr;
			const uint8_t * src = (const uint8_t*)data;
			#ifdef CONFIG_PRINTF
			print("Copy %u bytes from 0x%x to 0x%x ", count, data, addr);
			#else
			puts("Copy 0x");
			put_h16(count);
			puts(" bytes from 0x");
			put_h32(data);
			puts(" to 0x");
			put_h32(addr);
			putchar(' ');
			#endif
			while (count--)
				*dst++ = *src++;
		}
		else {
			rw32_t* dst = (rw32_t*)addr;
			ro32_t* src = (ro32_t*)data;
			#ifdef CONFIG_PRINTF
			print("Copy %u words from 0x%x to 0x%x ", count, data, addr);
			#else
			puts("Copy 0x");
			put_h16(count);
			puts(" words from 0x");
			put_h32(data);
			puts(" to 0x");
			put_h32(addr);
			putchar(' ');
			#endif
			while (count--)
				*dst++ = *src++;
		}
	}
	else {
		if (byte) {
			uint8_t* dst = (uint8_t*)addr;

			if (seq) {
				#ifdef CONFIG_PRINTF
				print("Write %u bytes seq:0x%x to 0x%x ", count, data, addr);
				#else
				puts("Write 0x");
				put_h16(count);
				puts(" bytes seq:0x");
				put_h8(data);
				puts(" to 0x");
				put_h32(addr);
				putchar(' ');
				#endif
				while (count--)
					*dst++ = (uint8_t)data++;
			}
			else {
				#ifdef CONFIG_PRINTF
				print("Fill %u bytes 0x%x to 0x%x ", count, data, addr);
				#else
				puts("Fill 0x");
				put_h16(count);
				puts(" bytes 0x");
				put_h8(data);
				puts(" to 0x");
				put_h32(addr);
				putchar(' ');
				#endif
				while (count--)
					*dst++ = (uint8_t)data;
			}
		}
		else {
			rw32_t* dst = (rw32_t*)addr;

			if (seq) {
				#ifdef CONFIG_PRINTF
				print("Write %u words seq:0x%x to 0x%x ", count, data, addr);
				#else
				puts("Write 0x");
				put_h16(count);
				puts(" words seq:0x");
				put_h32(data);
				puts(" to 0x");
				put_h32(addr);
				putchar(' ');
				#endif
				while (count--)
					*dst++ = data++;
			}
			else {
				#ifdef CONFIG_PRINTF
				print("Fill %u words 0x%x to 0x%x ", count, data, addr);
				#else
				puts("Fill 0x");
				put_h16(count);
				puts(" words 0x");
				put_h8(data);
				puts(" to 0x");
				put_h32(addr);
				putchar(' ');
				#endif
				while (count--)
					*dst++ = data;
			}
		}
	}
	return EOK;
}
#endif
#ifdef CONFIG_CMD_SLEEP
static int cmd_sleep(uint8_t argc, char*argv[]) {
	uint32_t ms;

	if (argc < 2) {
		#ifdef CONFIG_PRINTF
		print("Usage: %s <ms>\n", argv[0]);
		#else
		puts("Usage: ");
		puts(argv[0]);
		puts(" <ms>\n");
		#endif
		return EINVAL;
	}
	ms = stoi(argv[0]);
	if (ms) {
		#ifdef CONFIG_PRINTF
		print("Sleep %u ms ", argv[0]);
		#else
		puts("Sleep ");
		puts(argv[0]);
		puts(" <ms>");
		#endif
		delay_ms(ms);
		puts(" OK.");
	}
	return EOK;
}
#endif
static int cmd_exit(uint8_t argc, char*argv[]) {
	return EEXIT;
}

/* ================================================================================ */
/* ================                  Command List                  ================ */
/* ================================================================================ */
static int cmd_help(uint8_t argc, char*argv[]);
typedef struct {
	const char* cmd;
	int (*handler)(uint8_t argc, char*argv[]);
} sh_cmdlist_t;
static const sh_cmdlist_t cmdlist[] = {
#ifdef CONFIG_CMD_DUMP
	{"dump",  cmd_dump},
#endif
#ifdef CONFIG_CMD_READ
	{"read",  cmd_read},
#endif
#ifdef CONFIG_CMD_WRITE
	{"write", cmd_write},
#endif
#ifdef CONFIG_CMD_SLEEP
	{"sleep", cmd_sleep},
#endif
	{"help",  cmd_help},
	{"exit",  cmd_exit}
};
#define CMDLIST_SIZE	(sizeof(cmdlist) / sizeof(cmdlist[0]))

static int cmd_help(uint8_t argc, char*argv[]) {
	for (int i = 0; i < CMDLIST_SIZE; i++) {
		puts(cmdlist[i].cmd);
		putchar('\n');
	}
	return EOK;
}

/* ================================================================================ */

static int sh_input(char c) {
	if (sh.offs >= CONFIG_SH_CMDLINE_SIZE) {
		puts("Command line too long!");
		puts(prompt);
		return ENOCMD;
	}
	sh.cmdline[sh.offs++] = c;
	putchar(c);
	return EOK;
}

void sh_init(void) {
	sh.error = 0;
	sh.offs = 0;
	puts(prompt);
}

int sh_loop(void) {
	char* input;
	int ret = EOK;
	int ch = getchar();

	if (ch <= 0)
		return EOK;

	if ((char)ch < ' ') {
		if (ch == '\b') {	// Backspace
			if (sh.offs) {
				sh.offs--;
				puts("\b \b");
				return EOK;
			}
		}
		else if ('\t' == ch)
			return sh_input(' ');
		else if ('\n' != ch && '\r' != ch)
			return EOK;
	}
	else
		return sh_input((char)ch);

	putchar('\n');
	if (!sh.offs)
		goto end;
	sh.cmdline[sh.offs] = 0;
	sh.offs = 0;
	sh.argc = 0;
	input = sh.cmdline;
	while (1) {
		char* next;

		while (*input && *input <= ' ')
			input++;
		for (next = input; *next > ' '; next++);
		if (next == input)
			break;
		if (sh.argc >= CONFIG_SH_MAX_ARGS) {
			puts("Too many args!");
			ret = ENOCMD;
			goto end;
		}
		*next++ = 0;
		sh.argv[sh.argc++] = input;
		input = next;
	}
	if (sh.argc) {
		int i;
		for (i = 0; i < CMDLIST_SIZE; i++) {
			if (strcmp(cmdlist[i].cmd, sh.argv[0]) == 0) {
				ret = sh.error = cmdlist[i].handler(sh.argc, sh.argv);
				break;
			}
		}
		if (i == CMDLIST_SIZE) {
			ret = ENOCMD;
			puts("Unknown command: ");
			puts(sh.argv[0]);
		}
	}
end:
	puts(prompt);
	return ret;
}

int sh_error(void) {
	return sh.error;
}
#endif
