#include <xbr820.h>

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

#define XBR820_UART0	((uart_reg_t *)XBR820_UART0_BASE)
#define UART_BAUDRATE	57600
#define UART_CONFIG		3
#define UART_CFG_MASK	0x38
#define UART_RFIFO_GET	(1 << 4)
#define UART_RFIFO_MASK	(UART_RFIFO_GET - 1)

int uart_buf_pos;
char uart_buffer[256];
void uart_init(void) {
	uint32_t divisor;

	uart_buf_pos = 0;
	uart_buffer[0] = 0;
	XBR820_UART0->enable = 0;
	XBR820_UART0->config = UART_CONFIG;
	divisor = (SYSTEM_CLOCK + UART_BAUDRATE/2) / UART_BAUDRATE - 1;
	XBR820_UART0->baud_high = (divisor >> 8) & 0xff;
	XBR820_UART0->baud_low = divisor & 0xff;
	XBR820_UART0->enable |= 0xb0; // enable user define buadrate
	csi_vic_enable_irq(UART0_RX_IRQn);
}

void handle_trap(uint32_t cause, uint32_t mpc) {
	uint32_t iflag;
	
	for (iflag = XBR820_UART0->int_err; iflag & 0x10; iflag = XBR820_UART0->int_err) {
		if (0 == (iflag & 0x60)) {
			while (UART_RFIFO_MASK & XBR820_UART0->rfifo) {
				uint32_t data;

				XBR820_UART0->rfifo = UART_RFIFO_GET;
				data = XBR820_UART0->rx_data;
				uart_buffer[uart_buf_pos++] = (char)data;
				uart_buffer[uart_buf_pos] = 0;
			}
		}
		XBR820_UART0->int_err &= ~0x08;
	}
	
}