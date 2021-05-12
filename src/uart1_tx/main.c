
#include <xbr820.h>
#include <uart.h>

extern volatile uint32_t tm_count;

void timer0_init(unsigned int init_val)
{
	tm_count = 0;
	TIMER0_REG = init_val;	//load the initial value
	TIMER_CR |= 0x00000010;	//enable timer0
	
	csi_vic_enable_irq(TIM0_IRQn);
}

void delay(unsigned int val)
{
	tm_count = 0;
	while(tm_count < val)
	{
		//
	}	
}

void uart0_initial(void)
{
	uart_config_t config;
	
	config.buad = BAUD_115200;
	//config.buad = BAUD_57600;
	config.cfg = (UART_STOPBITS_1 | UART_PARITY_NONE);
	//config.cfg = (UART_STOPBITS_1 | UART_PARITY_EVEN);
	//config.cfg = (UART_STOPBITS_1_5 | UART_PARITY_NONE);
	//config.cfg = (UART_STOPBITS_2 | UART_PARITY_NONE);
	
	config.buf = 0;
	config.tsize = 0;
	config.rsize = 0;

	uart_init(1, &config);	
}

int main() 
{
	uart0_initial();
	timer0_init(16000);	//1ms
	
    __enable_excp_irq();	
	
	while(1)
	{
		if (1)
		{
			sent_byte(1, 0x55);
			sent_byte(1, 0xAA);
			sent_byte(1, 0xEB);
			sent_byte(1, 0x90);
			delay(1000);
		}
	}
	return 0;
}


