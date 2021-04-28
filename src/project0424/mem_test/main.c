
#include "xbr820.h"

volatile uint8_t* ptr = (volatile uint8_t*)(XBR820_SRAM_BASE + XBR820_SRAM_SIZE/2);
int main() {
	for (int i = 0; i < 256; i++) {
		ptr[i] = (uint8_t)i;
	}
	while(1);
	return 0;
}
