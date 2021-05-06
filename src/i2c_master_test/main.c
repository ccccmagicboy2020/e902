
#include <xbr820.h>

uint8_t i2c_master_send_buffer[8];
uint8_t i2c_master_rev_buffer[8];

extern volatile uint32_t tm_count;

void __bkpt_label();

void i2c_master_init(void)
{
	//
	SLAVE_ADDR = 0x0000000AUL;	//stm32 slave
	
	//MAST_CLK = 0x00000020UL;		//I2C CLK: 16000000/32/8 = 62.5K
	MAST_CLK = 0x00000010UL;		//I2C CLK: 16000000/16/8 = 125K
	//MAST_CLK = 0x00000008UL;		//I2C CLK: 16000000/8/8 = 250K
	
	MAST_EN = 0x00000001UL;			//enable master clock
	
	csi_vic_enable_irq(I2C_MASTER_IRQn);
	
	i2c_master_send_buffer[0] = 0x12;
	i2c_master_send_buffer[1] = 0x55;
	i2c_master_send_buffer[2] = 0xAA;
	i2c_master_send_buffer[3] = 0xEB;
	i2c_master_send_buffer[4] = 0x90;
	i2c_master_send_buffer[5] = 0x99;
	i2c_master_send_buffer[6] = 0x2A;
	i2c_master_send_buffer[7] = 0xBE;	
}

void timer0_init(unsigned int init_val)
{
	tm_count = 0;
	TIMER0_REG = init_val;	//load the initial value
	TIMER_CR |= 0x00000010;//enable timer0
	
	csi_vic_enable_irq(TIM0_IRQn);
}

void i2c_master_transmit()
{
	NWORD = 0x00000009UL;	//send 10 bytes
	DATA_2_IICM0 = (i2c_master_send_buffer[3] << 24) | (i2c_master_send_buffer[2] << 16) | (i2c_master_send_buffer[1] << 8) | (i2c_master_send_buffer[0]);
	DATA_2_IICM1 = (i2c_master_send_buffer[7] << 24) | (i2c_master_send_buffer[6] << 16) | (i2c_master_send_buffer[5] << 8) | (i2c_master_send_buffer[4]);
	MASTER_CPU_CMD = 0x00000011UL;
}

void i2c_master_rev()
{
	NWORD = 0x00000009UL;	//rev 10 bytes
	MASTER_CPU_CMD = 0x00000012UL;
}

void delay(unsigned int val)
{
	tm_count = 0;
	while(tm_count < val)
	{
		//
	}	
}

int main() 
{
    __enable_excp_irq();
	
	i2c_master_init();
	timer0_init(16000);
	
	while(1)
	{
		i2c_master_transmit();
		delay(5000);
		i2c_master_rev();
		
		while(1)
		{
			if (0x00000008 & MAST_STATUS)//check idle
			{
				break;
			}
		}
		
		i2c_master_rev_buffer[0] = IICM_2_DATA0 & 0x000000ff;
		i2c_master_rev_buffer[1] = (IICM_2_DATA0 & 0x0000ff00) >> 8;
		i2c_master_rev_buffer[2] = (IICM_2_DATA0 & 0x00ff0000) >> 16;
		i2c_master_rev_buffer[3] = (IICM_2_DATA0 & 0xff000000) >> 24;
		i2c_master_rev_buffer[4] = IICM_2_DATA1 & 0x000000ff;
		i2c_master_rev_buffer[5] = (IICM_2_DATA1 & 0x0000ff00) >> 8;
		i2c_master_rev_buffer[6] = (IICM_2_DATA1 & 0x00ff0000) >> 16;
		i2c_master_rev_buffer[7] = (IICM_2_DATA1 & 0xff000000) >> 24;		
		
		delay(5000);
		
		//__bkpt_label();
	}
	return 0;
}


