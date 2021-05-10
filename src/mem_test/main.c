#include "xbr820.h"

typedef	volatile uint8_t*	TEST_PTR;
TEST_PTR ptr = (TEST_PTR)(XBR820_SRAM_BASE + XBR820_SRAM_SIZE/2);
int main() {
	for (int i = 0; i < 256; i++) {
		ptr[i] = i;
	}
	while(1);
	return 0;
}
