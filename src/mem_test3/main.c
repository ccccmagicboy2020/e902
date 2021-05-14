
#include "xbr820.h"

extern uint8_t __sdata[];
typedef volatile uint8_t*	TEST_PTR;
uint32_t cksum = 0;
int main() {
	TEST_PTR ptr = (TEST_PTR)(__sdata + XBR820_SRAM_SIZE/2);
	TEST_PTR rp = ptr;
	TEST_PTR pcksum = (TEST_PTR)0x1f000030;	// top register for test

	for (int i = 0; i < 256; i++) {
		ptr[i] = i;
	}
	for (int j = 0; j < 256; j++) {
		cksum += rp[j];
		*pcksum += rp[j];
	}
	while(1);
	return 0;
}
