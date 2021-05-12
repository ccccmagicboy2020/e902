#ifndef _BA141738_8524_47BC_942E_463FABAF5D70_
#define _BA141738_8524_47BC_942E_463FABAF5D70_

#include "xbr820.h"

typedef struct {
	void* buf;
    uint8_t rsize;
    uint8_t tsize;
    uint8_t cfg;
    uint8_t buad;
} uart_config_t;

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

typedef struct {
    uart_reg_t* reg;
    IRQn_Type irq;
	fifo_t rx_fifo;
	fifo_t tx_fifo;
} uart_device_t;

enum {
	BAUD_075 = 0,
	BAUD_110,
	BAUD_150,
	BAUD_300,
	BAUD_600,
	BAUD_1200,
	BAUD_1800,
	BAUD_2400,
	BAUD_4800,
	BAUD_7200,
	BAUD_9600,
	BAUD_14400,
	BAUD_19200,
	BAUD_38400,
	BAUD_57600,
	BAUD_115200,
	BAUD_230400,
	BAUD_460800,
	BAUD_921600	
};

#define UART_PARITY_NONE	0
#define UART_PARITY_ODD		1
#define UART_PARITY_EVEN	3
#ifndef UART_PARITY
 #define UART_PARITY		UART_PARITY_NONE
#endif

#define UART_STOPBITS_1		0
#define UART_STOPBITS_1_5	0xC0
#define UART_STOPBITS_2		0x80
#ifndef UART_STOPBITS
 #define UART_STOPBITS		UART_STOPBITS_1
#endif

#define UART_RFIFO_CLR	(1 << 5)
#define UART_RFIFO_NEXT	(1 << 4)
#define UART_RFIFO_MASK	(UART_RFIFO_NEXT - 1)

#define UART_CONFIG			(UART_STOPBITS | UART_PARITY)
#define UART_BAUD			BAUD_115200

#define XBR820_UART0	((uart_reg_t *)XBR820_UART0_BASE)
#define XBR820_UART1	((uart_reg_t *)XBR820_UART1_BASE)

bool uart_init(int index, const uart_config_t* config);
bool sent_byte(int index, uint32_t data0);


#endif//_BA141738_8524_47BC_942E_463FABAF5D70_
