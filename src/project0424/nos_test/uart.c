#include "xbr820.h"
#include "driver.h"
#include <string.h>

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
#define XBR820_UART1	((uart_reg_t *)XBR820_UART1_BASE)

#define UART_CFG_MASK	0x38
#define UART_RFIFO_GET	(1 << 4)
#define UART_RFIFO_MASK	(UART_RFIFO_GET - 1)

uart_reg_t* uart_dev[CONFIG_UART_NUM];

bool uart_init(int index, uint32_t buadrate) {
	uint32_t divisor;

	if (index >= CONFIG_UART_NUM)
		return false;
	uart_dev[index] = index ? XBR820_UART1 : XBR820_UART0;
	uart_dev[index]->config = UART_CONFIG;
	if (!buadrate)
		buadrate = UART_BAUDRATE;
	divisor = (SYSTEM_CLOCK + buadrate/2) / buadrate - 1;
	uart_dev[index]->baud_high = (divisor >> 8) & 0xff;
	uart_dev[index]->baud_low = divisor & 0xff;
	uart_dev[index]->enable |= 0xb0; // enable user define buadrate
	return true;
}

bool uart_putc(int index, int ch, int timeout) {
	uart_reg_t* uart;
	uint32_t start;

	if (index >= CONFIG_UART_NUM)
		return false;
	start = tick_count();
	uart = uart_dev[index];
	while (1) {
		do {
			if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
				return false;
		} while (uart->state & 0x07); // TX not idle
		uart->int_err &= ~0x02;
		uart->tx_data = ch & 0xff;
		uart->int_err &= ~0x02;
		break;
	}
	return true;
}

int uart_getc(int index, int timeout) {
	uart_reg_t* uart;
	uint32_t start;
	int ret = -1;

	if (index >= CONFIG_UART_NUM)
		return ret;
	start = tick_count();
	uart = uart_dev[index];
	while (1) {
		if ((uart->int_err & 0x10) == 0x10) {
			uart->rfifo = UART_RFIFO_GET;
			ret = uart->rx_data & 0xff;
			uart->int_err &= ~0x10;
			break;
		}
		if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
			break;
	}
	return ret;
}
