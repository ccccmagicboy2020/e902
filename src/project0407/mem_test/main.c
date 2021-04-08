#include "xbr820.h"

#define TEST_ADDR	(XBR820_SRAM_BASE + XBR820_SRAM_SIZE / 2)

int __attribute__((weak)) main(void) {
	uint8_t *data = (uint8_t *)TEST_ADDR;
	if (*data) {
		for (uint16_t i = 0; i < 256; i++)
			data[i] = (uint8_t)i;
	}
	else {
		for (uint16_t i = 0; i < 256; i++)
			data[i] = (uint8_t)~i;
	}
	while (1);
	return 0;
}
