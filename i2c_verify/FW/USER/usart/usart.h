#ifndef __USART_H
#define __USART_H

#include "stm32f10x.h"

#define   RX     GPIO_Pin_10
#define   TX     GPIO_Pin_9

static void NVIC_Configuration(void);
void USART_Config(void);
void Usart_SendByte( USART_TypeDef * USARTx, uint32_t ch);





#endif




