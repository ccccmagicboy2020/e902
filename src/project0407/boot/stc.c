#include "xbr820.h"
#include "driver.h"

#ifndef CONFIG_TICK_TIMER
 #define CONFIG_TICK_TIMER	(CONFIG_TIMER_NUM - 1)
#endif

#define STCCTL	(XBR820_STC_BASE + 0x00)
#define WDGCNT	(XBR820_STC_BASE + 0x04)
#define TIMINIT	((reg32_t *)(XBR820_STC_BASE + 0x08))
#define TIMCNT	((ro32_t *)(XBR820_STC_BASE + 0x40))

static uint32_t tm_count[CONFIG_TIMER_NUM];
static timer_cb_t tm_cb[CONFIG_TIMER_NUM];

static void tick_init(void);

void WDG_IRQHandler(void) {
	
}

void timer_irqhandler(int index) {
	tm_count[index]++;
	if (tm_cb[index])
		tm_cb[index](index);
}

void stc_init(void) {
	for (int i = 0; i < CONFIG_TIMER_NUM; i++) {
		tm_count[i] = 0;
		tm_cb[i] = NULL;
	}
	tick_init();
}

void timer_register(int index, timer_cb_t cb) {
	if (index >= CONFIG_TIMER_NUM)
		return;
	tm_cb[index] = cb;
}

void timer_enable(int index, bool enable) {
	if (index >= CONFIG_TIMER_NUM)
		return;
	uint32_t mask = 0x10 << index;

	if (enable)
		reg32_set(STCCTL, mask);
	else
		reg32_clr(STCCTL, mask);
}

uint32_t timer_count(int index) {
	if (index < CONFIG_TIMER_NUM)
		return tm_count[index];
	return 0;
}

void Watchdog_enable(bool enable) {
	if (enable)
		reg32_set(STCCTL, 0x02);
	else
		reg32_clr(STCCTL, 0x02);
}

#define TIMCNT_MAX	UINT32_MAX
static void tick_init(void) {
	TIMINIT[CONFIG_TICK_TIMER] = TIMCNT_MAX;
	timer_enable(CONFIG_TICK_TIMER, true);
}

uint32_t tick_count(void) {
	return TIMCNT[CONFIG_TICK_TIMER];
}

uint32_t tick_diff(uint32_t start) {
	uint32_t diff;
	uint32_t cnt = tick_count();
	if (cnt > start)
		diff = start + (TIMCNT_MAX - cnt);
	else
		diff = start - cnt;
	return diff;
}

#define TIMCNT_MS	(SYSTEM_CLOCK / 1000)
#define TIMCNT_US	(TIMCNT_MS / 1000)

uint32_t tick_diff_us(uint32_t start) {
	uint32_t diff = tick_diff(start);
	return (diff + 4) / TIMCNT_US;
}

uint32_t tick_diff_ms(uint32_t start) {
	uint32_t diff = tick_diff(start);
	return (diff + 4) / TIMCNT_MS;
}

void delay_us(uint32_t us) {
	uint32_t start = tick_count();
	uint32_t period = us * TIMCNT_US;
	while (tick_diff(start) < period);
}

void delay_ms(uint32_t ms) {
	uint32_t start = tick_count();
	uint32_t period = ms * TIMCNT_MS;
	while (tick_diff(start) < period);
}
