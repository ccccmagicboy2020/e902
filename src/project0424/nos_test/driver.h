#ifndef __DRIVER_H__
#define __DRIVER_H__

#include "typdef.h"

/* ================================================================================ */
/* ================                STC  declaration                ================ */
/* ================================================================================ */
#ifdef __cplusplus
extern "C" {
#endif

void tick_init(void);
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

#ifndef UART_BAUDRATE
 #define UART_BAUDRATE		57600
#endif

#ifdef __cplusplus
extern "C" {
#endif

bool uart_init(int index, uint32_t buadrate);
bool uart_putc(int index, int ch, int timeout);
int uart_getc(int index, int timeout);

#ifdef __cplusplus
}
#endif

#endif // __DRIVER_H__