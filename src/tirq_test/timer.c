#include <xbr820.h>
#include <typdef.h>

#define STCCTL				(XBR820_STC_BASE + 0x00)
#define WDGCNT				(XBR820_STC_BASE + 0x04)
#define TIMINIT				((reg32_t *)(XBR820_STC_BASE + 0x08))
#define TIMCNT				((ro32_t *)(XBR820_STC_BASE + 0x40))

#define TMEN(i)				(0x10 << (i))
#define TMCLR(i)				(0x100 << (i))

volatile uint32_t tm_count;

void timer_init(void) {
	tm_count = 0;
	//TIMINIT[0] = SYSTEM_CLOCK / 10;	// 100ms
	TIMINIT[0] = SYSTEM_CLOCK / 1000;	// 1ms
	reg32_set(STCCTL, TMEN(0));
	csi_vic_enable_irq(TIM0_IRQn);
}

void handle_irq(uint32_t vec) {
	if (vec == TIM0_IRQn) {
		tm_count++;
		reg32_set(STCCTL, TMCLR(0));
	}
}
