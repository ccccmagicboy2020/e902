#include "console.h"
#include "shell.h"

#define BOOT_VER	1

int __attribute__((weak)) main(void) {
	print("XBR820 v%u %s %s", BOOT_VER, __DATE__, __TIME__);
	sh_init();
	while (EEXIT != sh_loop()) {
		// do other things
	}
	while (1);
	return 0;
}
