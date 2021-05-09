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

uint8_t volatile i2c_slave_buffer[200];

void handle_irq(uint32_t vec) 
{	
	static unsigned char pos = 0;
	
	if (I2C_SLAVE_IRQn == vec)
	{		
		SLAVEB_CLEAR |= 0x00000010;
		
		if (0x00000008 & SLAVEB_STATUS)		//addr
		{
			SLAVEB_CLEAR |= 0x00000008;		
			i2c_slave_buffer[0] = (SLAVEB_DATA >> 8) & 0x000000FF;
			pos = 1;
		}
		
		if (0x00000001 & SLAVEB_STATUS)		//rw int
		{
			SLAVEB_CLEAR |= 0x00000001;			
			if (0x00000010 & SLAVEB_STATUS)
			{
				//transmit
				SLAVEB_DATA_2_IIC = i2c_slave_buffer[pos];
				pos++;
			}
			else		
			{
				//rev
				i2c_slave_buffer[pos] = (SLAVEB_DATA) & 0x000000FF;
				pos++;
			}			
		}
		
		if (0x00000002 & SLAVEB_STATUS)		//nack
		{
			SLAVEB_CLEAR |= 0x00000002;
			
		}
		if (0x00000004 & SLAVEB_STATUS)		//stop
		{
			SLAVEB_CLEAR |= 0x00000004;		
			if (0x00000010 & SLAVEB_STATUS)
			{
				//transmit
			}
			else		
			{
				//rev
				pos = 0;
			}
		}
	}	
	
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
