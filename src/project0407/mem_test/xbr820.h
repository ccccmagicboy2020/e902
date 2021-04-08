/*
 * Copyright (C) 2017-2019 Alibaba Group Holding Limited
 */


/**************************************************************************//**
 * @file     xbr820.h
 * @brief    XBR820 Core Peripheral Access Layer Header File for
 *           CSKYSOC Device Series
 * @version  V1.0
 * @date     15. March 2021
 ******************************************************************************/

#ifndef _XBR820_H_
#define _XBR820_H_

#include "config.h"
#include "core_rv32.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifndef SYSTEM_CLOCK
 #define SYSTEM_CLOCK		(16 * 1000 * 1000)	// 16M
#endif

/* -------------------------  Interrupt Number Definition  ------------------------ */
typedef enum IRQn {
    /* ----------------------  XBR820 Specific Interrupt Numbers  --------------------- */
    Machine_Software_IRQn           =   3,      /* Machine software interrupt */
    CORET_IRQn                      =   7,      /* core Timer Interrupt */
    Machine_External_IRQn           =   11,     /* Machine external interrupt */
    GPIO_IRQn                       =   16,     /* GPIO interrupt */
    PMU0_IRQn                    ,//=   17,     /* pmu0 Interrupt */
    PMU1_IRQn                    ,//=   18,     /* pmu0 Interrupt */
    PMU2_IRQn                    ,//=   19,     /* pmu0 Interrupt */
    PMU3_IRQn                    ,//=   20,     /* pmu0 Interrupt */
    UART0_RX_IRQn                ,//=   21,     /* uart0 RX Interrupt */
    UART0_TX_IRQn                ,//=   22,     /* uart0 TX Interrupt */
    UART1_RX_IRQn                ,//=   23,     /* uart1 RX Interrupt */
    UART1_TX_IRQn                ,//=   24,     /* uart1 TX Interrupt */
    I2C_MASTER_IRQn              ,//=   25,     /* I2C master Interrupt */
    I2C_SLAVE_IRQn               ,//=   26,     /* I2C slave Interrupt */
    IR_IRQn                      ,//=   27,     /* IR Interrupt */
    WDG_IRQn                     ,//=   28,     /* WatchDog Interrupt */
    TIM0_IRQn                    ,//=   29,     /* timer0 Interrupt */
    TIM1_IRQn                    ,//=   30,     /* timer1 Interrupt */
    TIM2_IRQn                    ,//=   31,     /* timer2 Interrupt */
    TIM3_IRQn                    ,//=   32,     /* timer3 Interrupt */
	IRQ_NUMS
} IRQn_Type;


/* ================================================================================ */
/* ================       Device Specific Peripheral Section       ================ */
/* ================================================================================ */
#define CONFIG_UART_NUM     2
#define CONFIG_TIMER_NUM    4
#define CONFIG_PMU_NUM      4
#define CONFIG_GPIO_PIN_NUM 30

/* ================================================================================ */
/* ================              Peripheral memory map             ================ */
/* ================================================================================ */
/* ----------------------------  SOC memory map  --------------------------------- */
#define XBR820_SRAM_BASE              (0x01000000UL)
#define XBR820_SRAM_SIZE              (0x00001000UL)

#define XBR820_SPI_BASE               (0x00000000UL)
#define XBR820_TOP_BASE               (0x1f000000UL)
#define XBR820_PMU_BASE               (0x1f100000UL)
#define XBR820_STC_BASE               (0x1f200000UL)
#define XBR820_I2CM_BASE              (0x1f300000UL)
#define XBR820_I2CS_BASE              (0x1f400000UL)
#define XBR820_UART0_BASE             (0x1f500000UL)
#define XBR820_UART1_BASE             (0x1f600000UL)
#define XBR820_IR_BASE                (0x1f700000UL)

/* ================================================================================ */
/* ================             Peripheral declaration             ================ */
/* ================================================================================ */
//#define XBR820_UART                  ((XBR820_UART_TypeDef *)XBR820_UART1_BASE)

#ifdef __cplusplus
}
#endif

#endif  /* _XBR820_H_ */
