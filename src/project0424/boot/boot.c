#include <xbr820.h>

extern const uint32_t __data_end__;
void boot(void) {
	const uint32_t *src = (const uint32_t*)&__data_end__;
	uint32_t size = src[0], entry = src[1];
	if (size && size < XBR820_SRAM_SIZE &&
		entry >= XBR820_SRAM_BASE+8 &&
		entry <= (XBR820_SRAM_BASE + XBR820_SRAM_SIZE - 4)) {
		uint32_t *dst = (uint32_t *)XBR820_SRAM_BASE;
		for (uint32_t i = 0; i < size; i += 4)
			*dst++ = *src++;
		((void(*)(void))entry)();
	}
}
