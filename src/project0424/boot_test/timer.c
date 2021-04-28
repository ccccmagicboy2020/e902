#include "xbr820.h"
#include "timer.h"

uint32_t tm_count;	// 0x1000260

void stc_init(void) {
	tm_count = 0;
	TIMINIT[0] = SYSTEM_CLOCK / CONFIG_TICK_HZ;	// 10ms
	reg32_set(STCCTL, TMEN(0));
	csi_vic_enable_irq(TIM0_IRQn);
}
