#include <xbr820.h>
#include <driver.h>
#include <console.h>
#include <shell.h>


int __attribute__((weak)) main(void) {
	puts("--- SH "__DATE__" "__TIME__" ---\n");
	#ifdef CONFIG_SHELL
	sh_init();
	while (EEXIT != sh_loop()) {
		// do other things
	}
	#else
	while(1) {
		int ch = getchar();
		if (ch > 0)
			putchar(ch);
	}
	#endif
	while(1);
	return 0;
}
