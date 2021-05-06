#include <xbr820.h>

volatile uint32_t tm_count;
volatile uint8_t data_num;

void handle_irq(uint32_t vec) 
{	
	
	if (I2C_MASTER_IRQn == vec)
	{
		MAST_CLEAR |= 0x00000010;
		MAST_CLEAR &= 0xffffffef;
		
		if (0x00000008 & MAST_STATUS)//idle
		{
			
		}
		
		if (0x00000004 & MAST_STATUS)//timeout
		{
			MAST_CLEAR |= 0x00000004;
			MAST_CLEAR &= 0xfffffffb;
		}
		
		if (0x00000002 & MAST_STATUS)//no stop
		{
			MAST_CLEAR |= 0x00000002;
			MAST_CLEAR &= 0xfffffffd;
		}
		
		if (0x00000001 & MAST_STATUS)//no ack
		{
			MAST_CLEAR |= 0x00000001;
			MAST_CLEAR &= 0xfffffffe;
		}
		
		data_num = (0x0000ff00 & MAST_STATUS) >> 8;
	}
	
	if (TIM0_IRQn == vec)
	{
		tm_count++;
		TIMER_CR |= 0x00000100;
	}
}
