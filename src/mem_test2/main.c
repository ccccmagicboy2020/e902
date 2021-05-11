
#include "xbr820.h"

extern uint8_t __sdata[];
typedef volatile uint8_t*	TEST_PTR;
TEST_PTR ptr = (TEST_PTR)(__sdata + XBR820_SRAM_SIZE/2);
uint32_t cksum = 0;
int main() {
	TEST_PTR rp = ptr;

	for (int i = 0; i < 256; i++) {
		ptr[i] = i;
	}
	for (int j = 0; j < 256; j++)
		cksum += rp[j];
	while(1);
	return 0;
}
