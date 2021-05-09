#include <xbr820.h>

volatile uint32_t tm_count;
extern volatile uint8_t i2c_master_sended_buffer[16];
extern volatile uint8_t i2c_master_send_buffer[200];
extern volatile uint8_t i2c_master_rev_buffer[200];
volatile unsigned int ii = 0;
volatile unsigned int ii2 = 0;
extern uint8_t master_work_flag;

volatile unsigned int buffer_pointer = 0;
volatile unsigned int buffer_cycle = 0;

volatile unsigned int buffer_pointer2 = 0;
volatile unsigned int buffer_cycle2 = 0;

extern volatile unsigned int rw_flag;

void handle_irq(uint32_t vec) 
{	
	
	if (I2C_MASTER_IRQn == vec)
	{		
		ii2++;
		if (0x00000010 & MAST_STATUS) // byte done
		{
			MAST_CLEAR |= 0x00000008;
			
			if (rw_flag)
			{
				buffer_pointer2 = (0x0000ff00 & MAST_STATUS) >> 8;
				buffer_pointer = 0;
			}
			else
			{
				buffer_pointer = (0x0000ff00 & MAST_STATUS) >> 8;
				buffer_pointer2 = 0;
			}
			
			i2c_master_sended_buffer[ii] = (0x0000ff00 & MAST_STATUS) >> 8;
			ii++;
			if (16 <= ii)
			{
				ii = 0;
			}
			
			
			if (buffer_pointer % 8 == 1)
			{
				DATA_2_IICM1 = (i2c_master_send_buffer[7+buffer_cycle*8] << 24) | (i2c_master_send_buffer[6+buffer_cycle*8] << 16) | (i2c_master_send_buffer[5+buffer_cycle*8] << 8) | (i2c_master_send_buffer[4+buffer_cycle*8]);				
				buffer_cycle++;
			}
			else if (buffer_pointer % 8 == 4)
			{
				DATA_2_IICM0 = (i2c_master_send_buffer[3+buffer_cycle*8] << 24) | (i2c_master_send_buffer[2+buffer_cycle*8] << 16) | (i2c_master_send_buffer[1+buffer_cycle*8] << 8) | (i2c_master_send_buffer[0+buffer_cycle*8]);
			}
			
			if (buffer_pointer2 % 8 == 1)
			{
				if (buffer_cycle2 != 0)
				{
					i2c_master_rev_buffer[4+(buffer_cycle2-1)*8] = IICM_2_DATA1 & 0x000000ff;
					i2c_master_rev_buffer[5+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x0000ff00) >> 8;
					i2c_master_rev_buffer[6+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x00ff0000) >> 16;
					i2c_master_rev_buffer[7+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0xff000000) >> 24;					
				}
			}
			else if (buffer_pointer2 % 8 == 5)
			{
				i2c_master_rev_buffer[0+buffer_cycle2*8] = IICM_2_DATA0 & 0x000000ff;
				i2c_master_rev_buffer[1+buffer_cycle2*8] = (IICM_2_DATA0 & 0x0000ff00) >> 8;
				i2c_master_rev_buffer[2+buffer_cycle2*8] = (IICM_2_DATA0 & 0x00ff0000) >> 16;
				i2c_master_rev_buffer[3+buffer_cycle2*8] = (IICM_2_DATA0 & 0xff000000) >> 24;
				buffer_cycle2++;
			}
		}
		
		if (0x00000008 & MAST_STATUS)//idle
		{
			
		}
		
		if (0x00000004 & MAST_STATUS)//timeout
		{
			MAST_CLEAR |= 0x00000004;
		}
		
		if (0x00000002 & MAST_STATUS)//after stop
		{
			MAST_CLEAR |= 0x00000002;
			master_work_flag = 1;
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
