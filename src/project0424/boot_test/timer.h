#ifndef __TIMER_H__
#define __TIMER_H__

#define STCCTL				(XBR820_STC_BASE + 0x00)
#define WDGCNT				(XBR820_STC_BASE + 0x04)
#define TIMINIT				((reg32_t *)(XBR820_STC_BASE + 0x08))
#define TIMCNT				((ro32_t *)(XBR820_STC_BASE + 0x40))
#define TMEN(i)				(0x10 << (i))
#define TMCLR(i)				(0x100 << (i))

#endif
