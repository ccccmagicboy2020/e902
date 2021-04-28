/******************************************************************************
 * @file     isr.c
 * @brief    source file for the interrupt server route
 * @version  V1.0
 * @date     09. Apr. 2021
 ******************************************************************************/
#include "xbr820.h"
#include "timer.h"

#if CONFIG_HAVE_VIC
extern uint32_t tm_count;
_VCODE_SECTION_ void TIM0_IRQHandler(void) {
	tm_count++;
	reg32_set(STCCTL, TMCLR(0));
}

void (*irqvector[IRQ_NUMS])(void) = {
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,

	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	TIM0_IRQHandler,
	0,
	0,
	0
};

_VCODE_SECTION_ void trap(uint32_t *regs)
{
    while (1);
}
#endif
