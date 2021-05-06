#include <xbr820.h>

volatile uint32_t tm_count;

void handle_irq(uint32_t vec) 
{	
	if (I2C_MASTER_IRQn == vec)
	{
		MAST_CLEAR |= 0x00000007;
	}
	
	if (TIM0_IRQn == vec)
	{
		tm_count++;
		TIMER_CR |= 0x00000100;
	}
}
