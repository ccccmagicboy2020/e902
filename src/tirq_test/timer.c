#include <xbr820.h>
#include <typdef.h>

#define STCCTL				(XBR820_STC_BASE + 0x00)
#define WDGCNT				(XBR820_STC_BASE + 0x04)
#define TIMINIT				((reg32_t *)(XBR820_STC_BASE + 0x08))
#define TIMCNT				((ro32_t *)(XBR820_STC_BASE + 0x40))

#define TMEN(i)				(0x10 << (i))
#define TMCLR(i)				(0x100 << (i))

volatile uint32_t tm_count;

void timer_deinit(unsigned char chan)
{
	switch(chan)
	{
		case 0:
			csi_vic_disable_irq(TIM0_IRQn);
			reg32_clr(STCCTL, TMEN(0));
			reg32_set(STCCTL, TMCLR(0));
		break;
		
		case 1:
			csi_vic_disable_irq(TIM1_IRQn);
			reg32_clr(STCCTL, TMEN(1));
			reg32_set(STCCTL, TMCLR(1));	
		break;
		
		case 2:
			csi_vic_disable_irq(TIM2_IRQn);
			reg32_clr(STCCTL, TMEN(2));
			reg32_set(STCCTL, TMCLR(2));		
		break;
		
		case 3:
			csi_vic_disable_irq(TIM3_IRQn);
			reg32_clr(STCCTL, TMEN(3));
			reg32_set(STCCTL, TMCLR(3));		
		break;
		
		default:
		break;
	}
}

void timer_init(unsigned char chan, unsigned int val) {
	switch (chan)
	{
		case 0:
			timer_deinit(0);
			TIMINIT[0] = val;
			reg32_set(STCCTL, TMEN(0));
			csi_vic_enable_irq(TIM0_IRQn);		
		break;
		
		case 1:
			timer_deinit(1);
			TIMINIT[1] = val;
			reg32_set(STCCTL, TMEN(1));
			csi_vic_enable_irq(TIM1_IRQn);		
		break;
		
		case 2:
			timer_deinit(2);
			TIMINIT[2] = val;
			reg32_set(STCCTL, TMEN(2));
			csi_vic_enable_irq(TIM2_IRQn);			
		break;
		
		case 3:
			timer_deinit(3);
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
}
