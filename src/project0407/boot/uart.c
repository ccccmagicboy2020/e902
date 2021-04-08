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
} uart_reg_t;

#define XBR820_UART0	((uart_reg_t *)XBR820_UART0_BASE)
#define XBR820_UART1	((uart_reg_t *)XBR820_UART0_BASE)

#define UART_CFG_MASK	0x38

typedef struct {
    uart_reg_t* reg;
    IRQn_Type irq;
	fifo_t rx_fifo;
	fifo_t tx_fifo;
} uart_device_t;
uart_device_t uart_dev[CONFIG_UART_NUM];

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

bool uart_init(int index, const uart_config_t* config) {
	uint8_t cfg = UART_CONFIG;
	uint8_t buad = UART_BAUD;
	uint32_t divisor;

	if (index >= CONFIG_UART_NUM)
		return false;
	memset(&uart_dev[index], 0, sizeof(uart_dev[index]));
	if (index) {
		uart_dev[1].reg = XBR820_UART1;
		uart_dev[1].irq = UART1_RX_IRQn;
	}
	else {
		uart_dev[0].reg = XBR820_UART0;
		uart_dev[0].irq = UART0_RX_IRQn;
	}
	uart_dev[index].reg->enable = 0;
	if (config) {
		if (config->buf) {
			if (config->rsize) {
				uart_dev[index].rx_fifo.buffer = (uint8_t *)config->buf;
				uart_dev[index].rx_fifo.size = config->rsize;
			}
			if (config->tsize) {
				uart_dev[index].tx_fifo.buffer = (uint8_t *)config->buf + config->rsize;
				uart_dev[index].tx_fifo.size = config->tsize;
			}
			if (UART_CFG_DEF != config->cfg)
				cfg = config->cfg & UART_CFG_MASK;
			if (config->buad <= BAUD_921600)
				buad = config->buad;
		}
	}
	uart_dev[index].reg->config = cfg;
	divisor = (SYSTEM_CLOCK + buad_rates[buad]/2) / buad_rates[buad] - 1;
	uart_dev[index].reg->baud_high = (divisor >> 8) & 0xff;
	uart_dev[index].reg->baud_low = divisor & 0xff;
	uart_dev[index].reg->enable |= 0xb0; // enable user define buadrate
	if (uart_dev[index].rx_fifo.size) {
		csi_vic_enable_irq(uart_dev[index].irq);
	}
	return true;
}

void uart_irqhandler(int index, int tx) {
	uint32_t iflag;
	uart_reg_t* uart = uart_dev[index].reg;
	
	for (iflag = uart->int_err; iflag & 0x11; iflag = uart->int_err) {
		uint32_t iclear = 0x0a;
		
		if (iflag & 0x10) {
			iclear &= ~0x08;
			if (0 == (iflag & 0x60)) {
				uint32_t data = uart->rx_data;
				fifo_putc(&(uart_dev[index].rx_fifo), data);
			}
		}
		if (iflag & 0x01) {
			uint32_t data;
			iclear &= ~0x02;
			if (fifo_getc(&(uart_dev[index].tx_fifo), data) == 1)
				uart->tx_data = data;
			if (fifo_is_empty(&uart_dev[index].tx_fifo))
				csi_vic_disable_irq(uart_dev[index].irq + 1);	// Disable tx interrupt if no data 
		}
		uart->int_err = iclear;
	}
}

FIFO_SIZE_t uart_send(int index, const void *data, FIFO_SIZE_t size, int timeout) {
	uart_reg_t* uart;
	FIFO_SIZE_t cnt = 0;
	const uint8_t* ptr = (const uint8_t*)data;
	uint32_t start;

	if (index >= CONFIG_UART_NUM || !size)
		return 0;
	start = tick_count();
	uart = uart_dev[index].reg;
	if (fifo_size(&(uart_dev[index].tx_fifo))) {
		while (size) {
			if (fifo_is_full(&(uart_dev[index].tx_fifo))) {
				if (0 == (uart->state & 0x07)) {
					uint32_t tmp;
					fifo_getc(&(uart_dev[index].tx_fifo), tmp);
					uart->tx_data = tmp;
				}
			}
			else {
				FIFO_SIZE_t filled = fifo_write(&(uart_dev[index].tx_fifo), ptr, size);
				if (fifo_len(&(uart_dev[index].tx_fifo)))
					csi_vic_enable_irq(uart_dev[index].irq + 1);
				ptr += filled;
				size -= filled;
				cnt += filled;
			}
		}
	}
	else {
		while (size) {
			do {
				if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
					goto end;
			} while (uart->state & 0x07); // TX not idle
			uart->int_err &= ~0x02;
			uart->tx_data = *ptr++;
			size--;
			cnt++;
			do {
				if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
					goto end;
			} while (uart->int_err & 0x01); // TX finished
			uart->int_err &= ~0x02;
		}
	}
end:
	return cnt;
}

FIFO_SIZE_t uart_receive(int index, void *data, FIFO_SIZE_t size, int timeout) {
	uart_reg_t* uart;
	FIFO_SIZE_t cnt = 0;
	uint8_t* ptr = (uint8_t*)data;
	uint32_t start;

	if (index >= CONFIG_UART_NUM || !size)
		return 0;
	start = tick_count();
	uart = uart_dev[index].reg;
	if (fifo_size(&(uart_dev[index].rx_fifo))) {
		while (size) {
			FIFO_SIZE_t read = fifo_read(&(uart_dev[index].rx_fifo), ptr, size);
			ptr += read;
			size -= read;
			cnt += read;
			if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
				break;
		}		
	}
	else {
		while (size) {
			if ((uart->int_err & 0x10) == 0x10) {
				*ptr++ = (uint8_t)uart->rx_data;
				uart->int_err &= ~0x10;
				size--;
				cnt++;
			}
			if (timeout >= 0 && (int)tick_diff_ms(start) >= timeout)
				break;
		}
	}
	return cnt;
}
