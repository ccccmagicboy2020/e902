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
		 EXTI_ClearITPendingBit(EXTI_Line1);		//«Â÷–∂œ
		 
			//ADC_ConvertedValue
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
   }
}


/******************* (C) COPYRIGHT 2011 STMicroelectronics *****END OF FILE****/
