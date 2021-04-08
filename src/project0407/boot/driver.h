#ifndef __DRIVER_H__
#define __DRIVER_H__

#include "typdef.h"

/* ================================================================================ */
/* ================                STC  declaration                ================ */
/* ================================================================================ */
#ifdef __cplusplus
extern "C" {
#endif

typedef void (*timer_cb_t)(int index);

void stc_init(void);
void timer_register(int index, timer_cb_t cb);
uint32_t timer_count(int index);
void watchdog_enable(bool enable);
void timer_enable(int index, bool enable);
uint32_t tick_count(void);
uint32_t tick_diff(uint32_t prev);
uint32_t tick_diff_us(uint32_t start);
uint32_t tick_diff_ms(uint32_t start);
void delay_us(uint32_t us);
void delay_ms(uint32_t ms);

#ifdef __cplusplus
}
#endif


/* ================================================================================ */
/* ================                UART declaration                ================ */
/* ================================================================================ */

#define UART_PARITY_NONE	0
#define UART_PARITY_ODD		1
#define UART_PARITY_EVEN	3
#ifndef UART_PARITY
 #define UART_PARITY		UART_PARITY_EVEN
#endif

#define UART_STOPBITS_1		0
#define UART_STOPBITS_1_5	0xC0
#define UART_STOPBITS_2		0x80
#ifndef UART_STOPBITS
 #define UART_STOPBITS		UART_STOPBITS_1
#endif

#define UART_CONFIG			(UART_STOPBITS | UART_PARITY)

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

#ifndef UART_BAUD
 #define UART_BAUD		BAUD_115200
#endif

typedef struct {
	void* buf;
    uint8_t rsize;
    uint8_t tsize;
    uint8_t cfg;
    uint8_t buad;
} uart_config_t;
#define UART_CFG_DEF		0xFF

#include "fifo.h"

#ifdef __cplusplus
extern "C" {
#endif

bool uart_init(int index, const uart_config_t* config);
FIFO_SIZE_t uart_send(int index, const void *data, FIFO_SIZE_t size, int timeout);
FIFO_SIZE_t uart_receive(int index, void *data, FIFO_SIZE_t size, int timeout);

#ifdef __cplusplus
}
#endif

#endif // __DRIVER_H__