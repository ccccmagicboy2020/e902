#include <xbr820.h>

extern uint32_t tm_count;

uint32_t seconds;

void board_init(void) {
	seconds = 0;
}

int __attribute__((weak)) main(void) {
	while(1) {
		seconds = tm_count / CONFIG_TICK_HZ;
	}
	return 0;
}
