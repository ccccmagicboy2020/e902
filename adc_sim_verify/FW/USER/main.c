#include "stm32f10x.h"
#include "ADC_DMA.h"

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

void GPIO_Config()
{   
    GPIO_InitTypeDef    GPIO_InitStruct;
		NVIC_InitTypeDef NVIC_InitStructure;
		EXTI_InitTypeDef EXTI_InitStructure;
    //开启时钟
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);  
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
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
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IPD;
    GPIO_InitStruct.GPIO_Speed =GPIO_Speed_2MHz;
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
		
		EXTI_ClearITPendingBit(EXTI_Line0);
		GPIO_EXTILineConfig(GPIO_PortSourceGPIOA,GPIO_PinSource0);//PA0
		EXTI_InitStructure.EXTI_Line= EXTI_Line0;
		EXTI_InitStructure.EXTI_Mode= EXTI_Mode_Interrupt; 
		EXTI_InitStructure.EXTI_Trigger= EXTI_Trigger_Rising;	//使用上升沿
		EXTI_InitStructure.EXTI_LineCmd=ENABLE;
		EXTI_Init(&EXTI_InitStructure);
		
		NVIC_PriorityGroupConfig(NVIC_PriorityGroup_1);   //NVIC
		NVIC_InitStructure.NVIC_IRQChannel = EXTI15_10_IRQn;
		NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority= 0;
		NVIC_InitStructure.NVIC_IRQChannelSubPriority= 2;        
		NVIC_InitStructure.NVIC_IRQChannelCmd=ENABLE;   
		NVIC_Init(&NVIC_InitStructure);
}


void EXTI15_10_IRQHandler(void)
{		
	 if(EXTI_GetITStatus(EXTI_Line0) != RESET)
   {
		 EXTI_ClearITPendingBit(EXTI_Line0);		//清中断
		 
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

int main(void)
{
  GPIO_Config();
  ADCx_Init();
  while (1)
  {
		//ADC_ConvertedValue
  }
}



