#include <xbr820.h>
#include <driver.h>

#ifndef CONFIG_CONSOLE_HANDLE
 #define CONFIG_CONSOLE_HANDLE		0
#endif

#ifndef CONFIG_CONSOLE_RXTIMEOUT
 #define CONFIG_CONSOLE_RXTIMEOUT	1
#endif

#ifndef CONFIG_CONSOLE_TXTIMEOUT
 #define CONFIG_CONSOLE_TXTIMEOUT	2
#endif

static inline int _putc(int ch) {
	if (uart_putc(CONFIG_CONSOLE_HANDLE, ch, CONFIG_CONSOLE_TXTIMEOUT))
		return 1;
	return -1;
}

int getchar(void) {
	return uart_getc(CONFIG_CONSOLE_HANDLE, CONFIG_CONSOLE_RXTIMEOUT);
}

int putchar(int ch) {
	if (ch == '\n') {
		if (_putc('\r') != 1)
			return -1;
	}
	return _putc(ch);
}

int puts(const char * str) {
	int cnt = 0;
	while (*str) {
		if (putchar(*str++) != 1)
			break;
		cnt++;
	}
	return cnt;
}

int __attribute__((weak)) main(void) {
	uart_init(CONFIG_CONSOLE_HANDLE, 0);
	puts("--- NOS test "__DATE__" "__TIME__" ---\n");
	while(1) {
		int ch = getchar();
		if (ch > 0)
			putchar(ch);
	}
	return 0;
}
