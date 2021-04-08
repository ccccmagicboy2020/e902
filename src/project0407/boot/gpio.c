#include "xbr820.h"

typedef struct {
    __IOM uint32_t out;
    __IOM uint32_t en;
    __IOM uint32_t mask;
    __IOM uint32_t trig;
    __IOM uint32_t clear;
    __IOM uint32_t state;
} gpio_reg_t;
#define XBR820_GPIO	((gpio_reg_t *)(XBR820_TOP_BASE + 0xC0))

void GPIO_IRQHandler(void) {
	XBR820_GPIO->clear = XBR820_GPIO->state;
}
