#include "stm32f10x.h"
#include "ADC_DMA.h"

extern __IO uint16_t ADC_ConvertedValue;

void GPIO_Config()
{   
    GPIO_InitTypeDef    GPIO_InitStruct;
		NVIC_InitTypeDef NVIC_InitStructure;
		EXTI_InitTypeDef EXTI_InitStructure;
    //开启时钟
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);  
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
		RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO, ENABLE);
    //配置GPIO为推挽输出
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_0|GPIO_Pin_1|GPIO_Pin_2|GPIO_Pin_3|GPIO_Pin_4|GPIO_Pin_5|GPIO_Pin_6|GPIO_Pin_7|GPIO_Pin_8|GPIO_Pin_9|GPIO_Pin_10|GPIO_Pin_11;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStruct.GPIO_Speed =GPIO_Speed_50MHz;
    GPIO_Init(GPIOB,&GPIO_InitStruct) ;
	
	  GPIO_InitStruct.GPIO_Pin = GPIO_Pin_2|GPIO_Pin_3;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStruct.GPIO_Speed =GPIO_Speed_50MHz;
    GPIO_Init(GPIOA,&GPIO_InitStruct) ;
	
	  GPIO_InitStruct.GPIO_Pin = GPIO_Pin_1;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IPU;
		GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOA,&GPIO_InitStruct);
	
    GPIO_SetBits( GPIOB, GPIO_Pin_0);		//ADC bit0
	  GPIO_SetBits( GPIOB, GPIO_Pin_1);		//ADC bit1
	  GPIO_SetBits( GPIOB, GPIO_Pin_2);		//ADC bit2
	  GPIO_SetBits( GPIOB, GPIO_Pin_3);		//ADC bit3
	  GPIO_SetBits( GPIOB, GPIO_Pin_4);		//ADC bit4
	  GPIO_SetBits( GPIOB, GPIO_Pin_5);		//ADC bit5
	  GPIO_SetBits( GPIOB, GPIO_Pin_6);		//ADC bit6
	  GPIO_SetBits( GPIOB, GPIO_Pin_7);		//ADC bit7
	  GPIO_SetBits( GPIOB, GPIO_Pin_8);		//ADC bit8
	  GPIO_SetBits( GPIOB, GPIO_Pin_9);		//ADC bit9
		GPIO_SetBits( GPIOB, GPIO_Pin_10);	//ADC bit10
		GPIO_SetBits( GPIOB, GPIO_Pin_11);	//ADC bit11
	  GPIO_SetBits( GPIOA, GPIO_Pin_2);		//备用
	  GPIO_SetBits( GPIOA, GPIO_Pin_3);		//备用

		GPIO_EXTILineConfig(GPIO_PortSourceGPIOA,GPIO_PinSource1);//PA1
		EXTI_ClearITPendingBit(EXTI_Line1);
		EXTI_InitStructure.EXTI_Line= EXTI_Line1;
		EXTI_InitStructure.EXTI_Mode= EXTI_Mode_Interrupt; 
		EXTI_InitStructure.EXTI_Trigger= EXTI_Trigger_Rising;	//使用上升沿
		EXTI_InitStructure.EXTI_LineCmd=ENABLE;
		EXTI_Init(&EXTI_InitStructure);
		
		NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2);   //NVIC
		NVIC_InitStructure.NVIC_IRQChannel = EXTI1_IRQn;
		NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority= 2;
		NVIC_InitStructure.NVIC_IRQChannelSubPriority= 0;        
		NVIC_InitStructure.NVIC_IRQChannelCmd=ENABLE;   
		NVIC_Init(&NVIC_InitStructure);
}

int main(void)
{
	volatile uint16_t temp = 0;
	
  GPIO_Config();
  ADCx_Init();
  while (1)
  {
		temp = ADC_ConvertedValue;
  }
}



