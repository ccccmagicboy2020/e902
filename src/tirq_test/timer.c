#include <xbr820.h>
#include <typdef.h>

#define STCCTL				(XBR820_STC_BASE + 0x00)
#define WDGCNT				(XBR820_STC_BASE + 0x04)
#define TIMINIT				((reg32_t *)(XBR820_STC_BASE + 0x08))
#define TIMCNT				((ro32_t *)(XBR820_STC_BASE + 0x40))

#define TMEN(i)				(0x10 << (i))
#define TMCLR(i)			(0x100 << (i))

volatile uint32_t tm_count;
volatile uint32_t tm_count1;
volatile uint32_t tm_count2;
volatile uint32_t tm_count3;

void timer_init(unsigned char chan, unsigned int val) {
	switch (chan)
	{
		case 0:
			TIMINIT[0] = val;
			reg32_set(STCCTL, TMEN(0));
			csi_vic_enable_irq(TIM0_IRQn);		
		break;
		
		case 1:
			TIMINIT[1] = val;
			reg32_set(STCCTL, TMEN(1));
			csi_vic_enable_irq(TIM1_IRQn);		
		break;
		
		case 2:
			TIMINIT[2] = val;
			reg32_set(STCCTL, TMEN(2));
			csi_vic_enable_irq(TIM2_IRQn);			
		break;
		
		case 3:
			TIMINIT[3] = val;
			reg32_set(STCCTL, TMEN(3));
			csi_vic_enable_irq(TIM3_IRQn);			
		break;
		
		default:
		break;
	}
}

void handle_irq(uint32_t vec) {
	if (vec == TIM0_IRQn) {
		tm_count++;
		reg32_set(STCCTL, TMCLR(0));
	}
	if (vec == TIM1_IRQn) {
		tm_count1++;
		reg32_set(STCCTL, TMCLR(1));
	}
	if (vec == TIM2_IRQn) {
		tm_count2++;
		reg32_set(STCCTL, TMCLR(2));
	}
	if (vec == TIM3_IRQn) {
		tm_count3++;
		reg32_set(STCCTL, TMCLR(3));
	}	
}
