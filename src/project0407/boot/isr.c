/*
 * Copyright (C) 2017-2019 Alibaba Group Holding Limited
 */


/******************************************************************************
 * @file     isr.c
 * @brief    source file for the interrupt server route
 * @version  V1.0
 * @date     02. June 2017
 ******************************************************************************/
#include "xbr820.h"


extern void pmu_irqhandler(int index);
extern void uart_irqhandler(int index, int tx);
extern void timer_irqhandler(int index);

extern void GPIO_IRQHandler(void);
extern void I2CM_IRQHandler(void);
extern void I2CS_IRQHandler(void);
extern void IR_IRQHandler(void);
extern void WDG_IRQHandler(void);


void SW_IRQHandler(void) {
}

void CORET_IRQHandler(void) {
}

void EXT_IRQHandler(void) {
}

void PMU0_IRQHandler(void) {
	pmu_irqhandler(0);
}

void PMU1_IRQHandler(void) {
	pmu_irqhandler(1);
}

void PMU2_IRQHandler(void) {
	pmu_irqhandler(2);
}

void PMU3_IRQHandler(void) {
	pmu_irqhandler(3);
}

void UART0RX_IRQHandler(void) {
	uart_irqhandler(0, 0);
}

void UART0TX_IRQHandler(void) {
	uart_irqhandler(0, 1);
}

void UART1RX_IRQHandler(void) {
	uart_irqhandler(1, 0);
}

void UART1TX_IRQHandler(void) {
	uart_irqhandler(1, 1);
}

void TIM0_IRQHandler(void) {
	timer_irqhandler(0);
}

void TIM1_IRQHandler(void) {
	timer_irqhandler(1);
}

void TIM2_IRQHandler(void) {
	timer_irqhandler(2);
}

void TIM3_IRQHandler(void) {
	timer_irqhandler(3);
}

#define RSV_IRQHandler	0
const void (*irqvector[IRQ_NUMS])(void) = {
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
	PMU0_IRQHandler,
	PMU1_IRQHandler,
	PMU2_IRQHandler,
	PMU3_IRQHandler,
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
void trap(uint32_t *regs)
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
