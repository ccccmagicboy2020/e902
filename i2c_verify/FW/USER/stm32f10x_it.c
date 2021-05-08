/**
  ******************************************************************************
  * @file    Project/STM32F10x_StdPeriph_Template/stm32f10x_it.c 
  * @author  MCD Application Team
  * @version V3.5.0
  * @date    08-April-2011
  * @brief   Main Interrupt Service Routines.
  *          This file provides template for all exceptions handler and 
  *          peripherals interrupt service routine.
  ******************************************************************************
  * @attention
  *
  * THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
  * WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE
  * TIME. AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY
  * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING
  * FROM THE CONTENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE
  * CODING INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
  *
  * <h2><center>&copy; COPYRIGHT 2011 STMicroelectronics</center></h2>
  ******************************************************************************
  */

/* Includes ------------------------------------------------------------------*/
#include "stm32f10x_it.h"
#include "SEGGER_RTT.h"
#include "SEGGER_RTT_Conf.h"
#include "SEGGER_SYSVIEW.h"
#include "delay.h"

extern __IO uint16_t ADC_ConvertedValue;

union
{
	uint16_t	value;
	struct
	{
		BitAction	adc0:1;
		BitAction	adc1:1;
		BitAction	adc2:1;
		BitAction	adc3:1;
		BitAction	adc4:1;
		BitAction	adc5:1;
		BitAction	adc6:1;
		BitAction	adc7:1;
		BitAction	adc8:1;
		BitAction	adc9:1;
		BitAction	adc10:1;
		BitAction	adc11:1;
		BitAction	temp:4;		
	}bits;
}test_data1;

void i2c1_initial(void);

/** @addtogroup STM32F10x_StdPeriph_Template
  * @{
  */

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/

/******************************************************************************/
/*            Cortex-M3 Processor Exceptions Handlers                         */
/******************************************************************************/

/**
  * @brief  This function handles NMI exception.
  * @param  None
  * @retval None
  */
void NMI_Handler(void)
{
}

/**
  * @brief  This function handles Hard Fault exception.
  * @param  None
  * @retval None
  */
void HardFault_Handler(void)
{
  /* Go to infinite loop when Hard Fault exception occurs */
  while (1)
  {
  }
}

/**
  * @brief  This function handles Memory Manage exception.
  * @param  None
  * @retval None
  */
void MemManage_Handler(void)
{
  /* Go to infinite loop when Memory Manage exception occurs */
  while (1)
  {
  }
}

/**
  * @brief  This function handles Bus Fault exception.
  * @param  None
  * @retval None
  */
void BusFault_Handler(void)
{
  /* Go to infinite loop when Bus Fault exception occurs */
  while (1)
  {
  }
}

/**
  * @brief  This function handles Usage Fault exception.
  * @param  None
  * @retval None
  */
void UsageFault_Handler(void)
{
  /* Go to infinite loop when Usage Fault exception occurs */
  while (1)
  {
  }
}

/**
  * @brief  This function handles SVCall exception.
  * @param  None
  * @retval None
  */
void SVC_Handler(void)
{
}

/**
  * @brief  This function handles Debug Monitor exception.
  * @param  None
  * @retval None
  */
void DebugMon_Handler(void)
{
}

/**
  * @brief  This function handles PendSVC exception.
  * @param  None
  * @retval None
  */
void PendSV_Handler(void)
{
}

/**
  * @brief  This function handles SysTick Handler.
  * @param  None
  * @retval None
  */
void SysTick_Handler(void)
{
}

/******************************************************************************/
/*                 STM32F10x Peripherals Interrupt Handlers                   */
/*  Add here the Interrupt Handler for the used peripheral(s) (PPP), for the  */
/*  available peripheral interrupt handler's name please refer to the startup */
/*  file (startup_stm32f10x_xx.s).                                            */
/******************************************************************************/

/**
  * @brief  This function handles PPP interrupt request.
  * @param  None
  * @retval None
  */
void EXTI1_IRQHandler(void)
{		
	 if(EXTI_GetITStatus(EXTI_Line1) != RESET)
   {
		 EXTI_ClearITPendingBit(EXTI_Line1);		//���ж�
		 
		 test_data1.value = ADC_ConvertedValue;
		 
		 GPIO_WriteBit(GPIOB, GPIO_Pin_0, test_data1.bits.adc0);
		 GPIO_WriteBit(GPIOB, GPIO_Pin_1, test_data1.bits.adc1);
		 GPIO_WriteBit(GPIOB, GPIO_Pin_2, test_data1.bits.adc2);
		 GPIO_WriteBit(GPIOB, GPIO_Pin_3, test_data1.bits.adc3);
		 GPIO_WriteBit(GPIOB, GPIO_Pin_4, test_data1.bits.adc4);
		 GPIO_WriteBit(GPIOB, GPIO_Pin_5, test_data1.bits.adc5);
		 GPIO_WriteBit(GPIOB, GPIO_Pin_6, test_data1.bits.adc6);
		 GPIO_WriteBit(GPIOB, GPIO_Pin_7, test_data1.bits.adc7);
		 GPIO_WriteBit(GPIOB, GPIO_Pin_8, test_data1.bits.adc8);
		 GPIO_WriteBit(GPIOB, GPIO_Pin_9, test_data1.bits.adc9);
		 GPIO_WriteBit(GPIOB, GPIO_Pin_10, test_data1.bits.adc10);
		 GPIO_WriteBit(GPIOB, GPIO_Pin_11, test_data1.bits.adc11);
		 
		 SEGGER_RTT_printf(0, "radar_if_raw: 0x%x(%d)\r\n", test_data1.value, test_data1.value);
		 
		 delay_us(10);
		 SEGGER_RTT_printf(0, "PA2: %d\r\n", GPIO_ReadOutputDataBit(GPIOA, GPIO_Pin_2));
		 GPIO_SetBits(GPIOA, GPIO_Pin_2);
		 SEGGER_RTT_printf(0, "PA2: %d\r\n", GPIO_ReadOutputDataBit(GPIOA, GPIO_Pin_2));
		 delay_us(10);
		 
		 GPIO_ResetBits(GPIOA, GPIO_Pin_2);
		 SEGGER_RTT_printf(0, "PA2: %d\r\n", GPIO_ReadOutputDataBit(GPIOA, GPIO_Pin_2));
		 SEGGER_RTT_printf(0, "%d %d %d %d %d %d %d %d %d %d %d %d \r\n", 
												GPIO_ReadOutputDataBit(GPIOB, GPIO_Pin_11),
												GPIO_ReadOutputDataBit(GPIOB, GPIO_Pin_10),
												GPIO_ReadOutputDataBit(GPIOB, GPIO_Pin_9),
												GPIO_ReadOutputDataBit(GPIOB, GPIO_Pin_8),		 
												GPIO_ReadOutputDataBit(GPIOB, GPIO_Pin_7),
												GPIO_ReadOutputDataBit(GPIOB, GPIO_Pin_6),
												GPIO_ReadOutputDataBit(GPIOB, GPIO_Pin_5),
												GPIO_ReadOutputDataBit(GPIOB, GPIO_Pin_4),		
												GPIO_ReadOutputDataBit(GPIOB, GPIO_Pin_3),
												GPIO_ReadOutputDataBit(GPIOB, GPIO_Pin_2),
												GPIO_ReadOutputDataBit(GPIOB, GPIO_Pin_1),
												GPIO_ReadOutputDataBit(GPIOB, GPIO_Pin_0)										
		 );
   }
}


void I2C1_ER_IRQHandler(void) 
{ 
	switch (I2C_GetLastEvent(I2C1))
	{ 
			case I2C_EVENT_SLAVE_ACK_FAILURE:				//EV3_2
				I2C_ClearITPendingBit(I2C1, I2C_IT_AF);
				SEGGER_RTT_printf(0, "i2c slave last byte nack\r\n");
				i2c1_initial();
			break;
	}
}

void I2C1_EV_IRQHandler(void)     
{
	unsigned char ch = 0;
	static unsigned char temp = 0x55;
	static unsigned char byte_counter = 0;
	static unsigned char byte_counter2 = 0;
	
	switch (I2C_GetLastEvent(I2C1))
	{ 
		//EV1��>EV3-1��>EV3��>EV3-2
		/* Slave Transmitter ---------------------------------------------------*/ 
		case I2C_EVENT_SLAVE_BYTE_TRANSMITTING:             /* EV3 */  
			/* Transmit I2C1 data */
			I2C_SendData(I2C1, temp);
			byte_counter2++;
			SEGGER_RTT_printf(0, "i2c slave EV3: load 0x%02x@%02d\r\n", temp, byte_counter2);
			temp++;
			break; 

		//EV1��>EV2��>EV4
		/* Slave Receiver ------------------------------------------------------*/ 
		case I2C_EVENT_SLAVE_RECEIVER_ADDRESS_MATCHED:     /* EV1 */
			//do some thing
			SEGGER_RTT_printf(0, "i2c slave EV1: address matched!\r\n");
			byte_counter = 0;
			byte_counter2 = 0;
			break; 
 
		case I2C_EVENT_SLAVE_BYTE_RECEIVED:                /* EV2 */ 
			/* Store I2C1 received data */
			ch = I2C_ReceiveData(I2C1);
			//do some thing
			byte_counter++;
			SEGGER_RTT_printf(0, "EV2: rev 0x%02x@%02d\r\n", ch, byte_counter);
			//
			break; 
 
		case I2C_EVENT_SLAVE_STOP_DETECTED:                /* EV4 */
			//do some thing
			SEGGER_RTT_printf(0, "i2c slave EV4: stop detected!\r\n");
			I2C_Cmd(I2C1,ENABLE);
			break; 
 
		default: 
			break;    
 
	}
}

/******************* (C) COPYRIGHT 2011 STMicroelectronics *****END OF FILE****/
