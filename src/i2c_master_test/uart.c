#include <xbr820.h>

volatile uint32_t tm_count;
extern volatile uint8_t i2c_master_sended_buffer[16];
volatile unsigned int ii = 0;
volatile unsigned int ii2 = 0;

void handle_irq(uint32_t vec) 
{	
	
	if (I2C_MASTER_IRQn == vec)
	{		
		ii2++;
		if (0x00000010 & MAST_STATUS) // byte done
		{
			MAST_CLEAR |= 0x00000008;
			
			i2c_master_sended_buffer[ii] = (0x0000ff00 & MAST_STATUS) >> 8;
			ii++;
			if (16 <= ii)
			{
				ii = 0;
			}
		}
		
		if (0x00000008 & MAST_STATUS)//idle
		{
			
		}
		
		if (0x00000004 & MAST_STATUS)//timeout
		{
			MAST_CLEAR |= 0x00000004;
		}
		
		if (0x00000002 & MAST_STATUS)//no stop
		{
			MAST_CLEAR |= 0x00000002;
		}
		
		if (0x00000001 & MAST_STATUS)//no ack
		{
			MAST_CLEAR |= 0x00000001;
		}
	}
	
	if (TIM0_IRQn == vec)
	{
		tm_count++;
		TIMER_CR |= 0x00000100;
	}
}
