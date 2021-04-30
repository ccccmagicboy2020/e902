#include <xbr820.h>

#ifndef CONFIG_CONSOLE_HANDLE
 #define CONFIG_CONSOLE_HANDLE		0
#endif

typedef struct {
    __IOM uint32_t enable;
    __IOM uint32_t config;
    __IM  uint32_t rx_data;
    __IOM uint32_t tx_data;
    __IOM uint32_t int_err;
    __IM  uint32_t state;
    __IOM uint32_t baud_high;
    __IOM uint32_t baud_low;
    __IOM uint32_t rfifo;
} uart_reg_t;



#if CONFIG_CONSOLE_HANDLE
 #define XBR820_UART	((uart_reg_t *)XBR820_UART1_BASE)
 #define UART_RX_IRQn	UART1_RX_IRQn
#else
 #define XBR820_UART	((uart_reg_t *)XBR820_UART0_BASE)
 #define UART_RX_IRQn	UART0_RX_IRQn
#endif
#define UART_BAUDRATE	57600
#define UART_CONFIG		3
#define UART_CFG_MASK	0x38
#define UART_RFIFO_GET	(1 << 4)
#define UART_RFIFO_MASK	(UART_RFIFO_GET - 1)

uint8_t fifo[256];

uint8_t i2c_slave_buffer[5];

uint8_t rp, wp;
void uart_init(void) {
	uint32_t divisor;

	rp = wp = 0;
	XBR820_UART->enable = 0;
	XBR820_UART->config = UART_CONFIG;
	divisor = (SYSTEM_CLOCK + UART_BAUDRATE/2) / UART_BAUDRATE - 1;
	XBR820_UART->baud_high = (divisor >> 8) & 0xff;
	XBR820_UART->baud_low = divisor & 0xff;
	XBR820_UART->enable |= 0xb0; // enable user define buadrate
	csi_vic_enable_irq(UART_RX_IRQn);
}

void handle_irq(uint32_t vec) {
	static unsigned char pos = 0;
	
	
	if (I2C_SLAVE_IRQn == vec)
	{		
		//SLAVEB_CLEAR = 0x00000005;
		//SLAVEB_CLEAR = 0x00000000;
		if (0x00000008 & SLAVEB_STATUS)		//addr
		{
			SLAVEB_CLEAR |= 0x00000008;
			//SLAVEB_CLEAR &= 0xFFFFFFF7;			
			i2c_slave_buffer[0] = (SLAVEB_DATA >> 8) & 0x000000FF;
			pos = 1;
		}
		
		if (0x00000001 & SLAVEB_STATUS)		//rw int
		{
			SLAVEB_CLEAR |= 0x00000001;
			SLAVEB_CLEAR &= 0xFFFFFFFE;			
			if (0x00000010 & SLAVEB_STATUS)
			{
				//transmit
			}
			else		
			{
				//rev
				i2c_slave_buffer[pos] = (SLAVEB_DATA) & 0x000000FF;
				pos++;
			}			
		}
		
		if (0x00000004 & SLAVEB_STATUS)		//stop
		{
			SLAVEB_CLEAR |= 0x00000004;
			SLAVEB_CLEAR &= 0xFFFFFFFB;			
			if (0x00000010 & SLAVEB_STATUS)
			{
				//transmit
			}
			else		
			{
				//rev
				pos = 0;
				SLAVEB_CLEAR &= 0xFFFFFFF7;
			}
		}
	}
}


static inline void _putc(int ch) {
	while (XBR820_UART->state & 0x07); // TX not idle
	XBR820_UART->int_err |= 0x02;
	XBR820_UART->tx_data = ch;
}

int getchar(void) {
	if (rp == wp)
		return -1;
	return (int)fifo[rp++];
}

void _putchar(int ch) {
	if (ch == '\n') {
		_putc('\r');
	}
	_putc(ch);
}
