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
    PMU_IRQn                     ,//=   17,     /* pmu0 Interrupt */
    UART0_RX_IRQn                ,//=   18,     /* uart0 RX Interrupt */
    UART0_TX_IRQn                ,//=   19,     /* uart0 TX Interrupt */
    UART1_RX_IRQn                ,//=   20,     /* uart1 RX Interrupt */
    UART1_TX_IRQn                ,//=   21,     /* uart1 TX Interrupt */
    I2C_MASTER_IRQn              ,//=   22,     /* I2C master Interrupt */
    I2C_SLAVE_IRQn               ,//=   23,     /* I2C slave Interrupt */
    IR_IRQn                      ,//=   24,     /* IR Interrupt */
    WDG_IRQn                     ,//=   25,     /* WatchDog Interrupt */
    TIM0_IRQn                    ,//=   26,     /* timer0 Interrupt */
    TIM1_IRQn                    ,//=   27,     /* timer1 Interrupt */
    TIM2_IRQn                    ,//=   28,     /* timer2 Interrupt */
    TIM3_IRQn                    ,//=   29,     /* timer3 Interrupt */
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
#define XBR820_PMU_BASE               (0x1f010000UL)
#define XBR820_STC_BASE               (0x1f020000UL)
#define XBR820_I2CM_BASE              (0x1f030000UL)
#define XBR820_I2CS_BASE              (0x1f040000UL)
#define XBR820_UART0_BASE             (0x1f050000UL)
#define XBR820_UART1_BASE             (0x1f060000UL)
#define XBR820_IR_BASE                (0x1f070000UL)
#define XBR820_SPI_BASEADDR           (0x1f090000UL)

/* ================================================================================ */
/* ================             Peripheral declaration             ================ */
/* ================================================================================ */
#define	SLAVE_ADDR			(*((volatile int *)(XBR820_I2CM_BASE + 0x00)))		//slave addr
#define	NWORD				(*((volatile int *)(XBR820_I2CM_BASE + 0x04)))		//master rw data length - 1
#define	MASTER_CPU_CMD		(*((volatile int *)(XBR820_I2CM_BASE + 0x08)))		//master command trigger

//#define	SLAVEB_DATA_2_IIC	(*((volatile int *)(XBR820_I2CM_BASE + 0x0C)))

#define	MAST_MISC			(*((volatile int *)(XBR820_I2CM_BASE + 0x10)))		//master misc.
#define	MAST_READ_ADDR		(*((volatile int *)(XBR820_I2CM_BASE + 0x14)))		//master data address
#define	DATA_2_IICM0		(*((volatile int *)(XBR820_I2CM_BASE + 0x18)))		//master send buffer0
#define	DATA_2_IICM1		(*((volatile int *)(XBR820_I2CM_BASE + 0x1C)))		//master send buffer1
#define	IICM_2_DATA0		(*((volatile int *)(XBR820_I2CM_BASE + 0x20)))		//master rev buffer0
#define	IICM_2_DATA1		(*((volatile int *)(XBR820_I2CM_BASE + 0x24)))		//master rev buffer1
#define	MAST_STATUS			(*((volatile int *)(XBR820_I2CM_BASE + 0x28)))		//master status reg
#define	MAST_INT_EN			(*((volatile int *)(XBR820_I2CM_BASE + 0x2C)))		//master interrupt enable
#define	MAST_CLEAR			(*((volatile int *)(XBR820_I2CM_BASE + 0x30)))		//master clear flags
#define	MAST_CLK			(*((volatile int *)(XBR820_I2CM_BASE + 0x34)))		//master clock div
#define	MAST_EN				(*((volatile int *)(XBR820_I2CM_BASE + 0x38)))		//master clock enable

#define	TIMER0_REG			(*((volatile int *)(XBR820_STC_BASE + 0x08)))
#define	TIMER_CR			(*((volatile int *)(XBR820_STC_BASE + 0x00)))

#ifdef __cplusplus
}
#endif

#endif  /* _XBR820_H_ */
