/******************************************************************************
 * @file     isr.c
 * @brief    source file for the interrupt server route
 * @version  V1.0
 * @date     09. Apr. 2021
 ******************************************************************************/
#include "xbr820.h"

#if CONFIG_HAVE_VIC
extern void PMU_IRQHandler(void);
extern void uart_rx_irqhandler(int index);
extern void uart_tx_irqhandler(int index);
extern void timer_irqhandler(int index);

extern void GPIO_IRQHandler(void);
extern void I2CM_IRQHandler(void);
extern void I2CS_IRQHandler(void);
extern void IR_IRQHandler(void);
extern void WDG_IRQHandler(void);


_VCODE_SECTION_ void SW_IRQHandler(void) {
}

_VCODE_SECTION_ void CORET_IRQHandler(void) {
}

_VCODE_SECTION_ void EXT_IRQHandler(void) {
}

_VCODE_SECTION_ void UART0RX_IRQHandler(void) {
	uart_rx_irqhandler(0);
}

_VCODE_SECTION_ void UART0TX_IRQHandler(void) {
	uart_tx_irqhandler(0);
}

_VCODE_SECTION_ void UART1RX_IRQHandler(void) {
	uart_rx_irqhandler(1);
}

_VCODE_SECTION_ void UART1TX_IRQHandler(void) {
	uart_tx_irqhandler(1);
}

_VCODE_SECTION_ void TIM0_IRQHandler(void) {
	timer_irqhandler(0);
}

_VCODE_SECTION_ void TIM1_IRQHandler(void) {
	timer_irqhandler(1);
}

_VCODE_SECTION_ void TIM2_IRQHandler(void) {
	timer_irqhandler(2);
}

_VCODE_SECTION_ void TIM3_IRQHandler(void) {
	timer_irqhandler(3);
}

#define RSV_IRQHandler	0
void (*irqvector[IRQ_NUMS])(void) = {
	RSV_IRQHandler,
	RSV_IRQHandler,
	RSV_IRQHandler,
	SW_IRQHandler,
	RSV_IRQHandler,
	RSV_IRQHandler,
	RSV_IRQHandler,
	CORET_IRQHandler,
	RSV_IRQHandler,
	RSV_IRQHandler,
	RSV_IRQHandler,
	EXT_IRQHandler,
	RSV_IRQHandler,
	RSV_IRQHandler,
	RSV_IRQHandler,
	RSV_IRQHandler,

	GPIO_IRQHandler,
	PMU_IRQHandler,
	UART0RX_IRQHandler,
	UART0TX_IRQHandler,
	UART1RX_IRQHandler,
	UART1TX_IRQHandler,
	I2CM_IRQHandler,
	I2CS_IRQHandler,
	IR_IRQHandler,
	WDG_IRQHandler,
	TIM0_IRQHandler,
	TIM1_IRQHandler,
	TIM2_IRQHandler,
	TIM3_IRQHandler
};


//void (*trap_callback)(void) = NULL;
_VCODE_SECTION_ void trap(uint32_t *regs)
{
//    uint32_t vec = __get_MCAUSE() & 0x3FF;
//
//    print("CPU Exception: NO.%d", vec);
//    print("\n");
//
//    for (int i = 0; i < 15; i++) {
//        print("x%d: %08x\t", i + 1, regs[i]);
//
//        if ((i % 4) == 3) {
//            print("\n");
//        }
//    }
//
//    print("\n");
//    print("mepc   : %08x\n", regs[15]);
//    print("mstatus: %08x\n", regs[16]);
//
//    if (trap_callback) {
//        trap_callback();
//    }
    while (1);
}
#endif
