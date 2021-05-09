
#include <xbr820.h>

volatile uint8_t i2c_master_send_buffer[200];
volatile uint8_t i2c_master_sended_buffer[16];
volatile uint8_t i2c_master_rev_buffer[200];
uint8_t master_work_flag = 0;

extern volatile uint32_t tm_count;
extern volatile unsigned int ii;
extern volatile unsigned int ii2;
extern volatile unsigned int buffer_pointer;
extern volatile unsigned int buffer_cycle;
extern volatile unsigned int buffer_pointer2;
extern volatile unsigned int buffer_cycle2;

volatile unsigned int rw_flag = 0;

void __bkpt_label();

void i2c_master_init(void)
{
	unsigned int i = 0;   //index
	//
	SLAVE_ADDR = 0x0000000AUL;	//stm32 slave
	
	MAST_CLK = 0x00000020UL;		//I2C CLK: 16000000/32/8 = 62.5K  pass!
	//MAST_CLK = 0x00000010UL;		//I2C CLK: 16000000/16/8 = 125K  pass!
	//MAST_CLK = 0x00000008UL;		//I2C CLK: 16000000/8/8 = 250K  not ok!
	
	MAST_EN = 0x00000001UL;			//enable master clock
	
	MAST_MISC = 0x00000002UL;		//enable last ack
	
	//MAST_INT_EN |= 0x0000000f;//enable int source
	//MAST_INT_EN |= 0x00000008;//enable int source
	MAST_INT_EN |= 0x0000000A;  //enable int source
	
	csi_vic_enable_irq(I2C_MASTER_IRQn);
	
	i2c_master_send_buffer[0] = 0x12;
	i2c_master_send_buffer[1] = 0x55;
	i2c_master_send_buffer[2] = 0xAA;
	i2c_master_send_buffer[3] = 0xEB;
	i2c_master_send_buffer[4] = 0x90;
	i2c_master_send_buffer[5] = 0x99;
	i2c_master_send_buffer[6] = 0x2A;
	i2c_master_send_buffer[7] = 0xBE;
	
	for (i = 8;i<200;i++)
	{
		i2c_master_send_buffer[i] = i;
	}
}

void timer0_init(unsigned int init_val)
{
	tm_count = 0;
	TIMER0_REG = init_val;	//load the initial value
	TIMER_CR |= 0x00000010;//enable timer0
	
	csi_vic_enable_irq(TIM0_IRQn);
}

void i2c_master_transmit(unsigned int trans_num)
{
	rw_flag = 0;
	NWORD = trans_num - 1;
	DATA_2_IICM0 = (i2c_master_send_buffer[3] << 24) | (i2c_master_send_buffer[2] << 16) | (i2c_master_send_buffer[1] << 8) | (i2c_master_send_buffer[0]);
	MASTER_CPU_CMD = 0x00000011UL;
}

void i2c_master_rev(unsigned int rev_num)
{
	rw_flag = 1;
	NWORD = rev_num - 1;	
	MASTER_CPU_CMD = 0x00000012UL;
}

void i2c_master_restart_rev1(unsigned char address, unsigned int rev_num)
{
	rw_flag = 1;
	MAST_READ_ADDR = address;
	NWORD = rev_num - 1;
	MASTER_CPU_CMD = 0x00000017UL;
}

void i2c_master_restart_rev2(unsigned short address, unsigned int rev_num)
{
	rw_flag = 1;
	MAST_READ_ADDR = address;
	NWORD = rev_num - 1;
	MASTER_CPU_CMD = 0x0000001FUL;
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
	unsigned int i = 0;
	i2c_master_init();
	timer0_init(16000);	
	ii = 0;
	ii2 = 0;
	master_work_flag = 0;
	buffer_pointer = 0;
	buffer_cycle = 0;
	
	buffer_pointer2 = 0;
	buffer_cycle2 = 0;
	
	rw_flag = 0;
	
    __enable_excp_irq();	
	
	while(1)
	{
		if (1)
		{
			//transmit
			i2c_master_transmit(128);
			
			while(master_work_flag==0)
			{
				//
			}
			master_work_flag = 0;
			DATA_2_IICM0 = (i2c_master_send_buffer[3] << 24) | (i2c_master_send_buffer[2] << 16) | (i2c_master_send_buffer[1] << 8) | (i2c_master_send_buffer[0]);

			delay(5000);
			buffer_cycle = 0;			
		}
		
		if (1)
		{
			//rev
			i2c_master_rev(128);
			
			while(master_work_flag==0)
			{
				//
			}
			master_work_flag = 0;
			i2c_master_rev_buffer[4+(buffer_cycle2-1)*8] = IICM_2_DATA1 & 0x000000ff;
			i2c_master_rev_buffer[5+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x0000ff00) >> 8;
			i2c_master_rev_buffer[6+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x00ff0000) >> 16;
			i2c_master_rev_buffer[7+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0xff000000) >> 24;				

			delay(5000);
			buffer_cycle2 = 0;	

			for (i=0;i<200;i++)
			{
				i2c_master_rev_buffer[i] = 0x00;
			}		
		}
		
		if (1)
		{
			//restart rev mode1
			i2c_master_restart_rev1(0x55, 128);
			
			while(master_work_flag==0)
			{
				//
			}
			master_work_flag = 0;
			i2c_master_rev_buffer[4+(buffer_cycle2-1)*8] = IICM_2_DATA1 & 0x000000ff;
			i2c_master_rev_buffer[5+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x0000ff00) >> 8;
			i2c_master_rev_buffer[6+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x00ff0000) >> 16;
			i2c_master_rev_buffer[7+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0xff000000) >> 24;				
		
			delay(5000);	
			buffer_cycle2 = 0;	
			
			for (i=0;i<200;i++)
			{
				i2c_master_rev_buffer[i] = 0x00;
			}				
		}
		
		if (1)
		{
			//restart rev mode2
			i2c_master_restart_rev2(0x5872, 128);
			
			while(master_work_flag==0)
			{
				//
			}
			master_work_flag = 0;
			i2c_master_rev_buffer[4+(buffer_cycle2-1)*8] = IICM_2_DATA1 & 0x000000ff;
			i2c_master_rev_buffer[5+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x0000ff00) >> 8;
			i2c_master_rev_buffer[6+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0x00ff0000) >> 16;
			i2c_master_rev_buffer[7+(buffer_cycle2-1)*8] = (IICM_2_DATA1 & 0xff000000) >> 24;				
		
			delay(5000);	
			buffer_cycle2 = 0;	
			
			for (i=0;i<200;i++)
			{
				i2c_master_rev_buffer[i] = 0x00;
			}			
		}
		
		//__bkpt_label();
	}
	return 0;
}


