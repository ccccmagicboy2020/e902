#include <xbr820.h>
#include <uart.h>
#include <string.h>

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

const uint32_t buad_rates[] = {
	75,
	110,
	150,
	300,
	600,
	1200,
	1800,
	2400,
	4800,
	7200,
	9600,
	14400,
	19200,
	38400,
	57600,
	115200,
	230400,
	460800,
	921600
};

uart_device_t uart_dev[CONFIG_UART_NUM];

void handle_irq(uint32_t vec) 
{	
	if (UART0_RX_IRQn == vec)
	{		
		//
	}
	
	if (TIM0_IRQn == vec)
	{
		tm_count++;
		TIMER_CR |= 0x00000100;
	}
}

bool uart_init(int index, const uart_config_t* config) {
	uint8_t cfg = UART_CONFIG;
	uint8_t buad = UART_BAUD;
	uint32_t divisor = 0;

	if (index >= CONFIG_UART_NUM)
		return false;
		
	memset(&uart_dev[index], 0, sizeof(uart_dev[index]));
	
	uart_dev[index].reg = index ? XBR820_UART1 : XBR820_UART0;			//链接硬件寄存器
	uart_dev[index].irq = index ? UART1_RX_IRQn : UART0_RX_IRQn;		//链接中断源
	uart_dev[index].reg->enable = 0;									//寄存器操作
	
	if (config) //如果有新的设置
	{
		if (config->buf) //如果有一个数据buffer，用于rx/tx共用，地址相接
		{
			if (config->rsize) 
			{
				uart_dev[index].rx_fifo.buffer = (uint8_t *)config->buf;
				uart_dev[index].rx_fifo.size = config->rsize;
			}
			
			if (config->tsize) 
			{
				uart_dev[index].tx_fifo.buffer = (uint8_t *)config->buf + config->rsize;
				uart_dev[index].tx_fifo.size = config->tsize;
			}
		}
	
		cfg = config->cfg;
			
		if (config->buad <= BAUD_921600)
			buad = config->buad;
	}
	
	uart_dev[index].reg->config = cfg;
	divisor = (SYSTEM_CLOCK + buad_rates[buad]/2) / buad_rates[buad] - 1;
	uart_dev[index].reg->baud_high = (divisor >> 8) & 0xff;
	uart_dev[index].reg->baud_low = divisor & 0xff;
	uart_dev[index].reg->rfifo = UART_RFIFO_CLR;	//clear fifo
	uart_dev[index].reg->enable |= 0xB0;			//enable user define buadrate, tx, and rx

	//enalbe the rev irq
	csi_vic_enable_irq(uart_dev[index].irq);
	
	return true;
}

bool sent_byte(int index, uint32_t data0)
{
	uart_reg_t* uart = uart_dev[index].reg;
	
	do 
	{
		// TX not idle
	}
	while (uart->state & 0x07);
	
	uart->int_err |= 0x02;
	uart->tx_data = data0;
	
	return 1;
}

