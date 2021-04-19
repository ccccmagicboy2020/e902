#include "stm32f10x.h"
#include "ADC_DMA.h"
#include "sys.h"
#include "delay.h"
#include "SEGGER_RTT.h"
#include "SEGGER_RTT_Conf.h"
#include "SEGGER_SYSVIEW.h"

typedef struct Val
{
	unsigned short Val1;		//radar if
} Val_t;

extern __IO uint16_t ADC_ConvertedValue;
char JS_RTT_UpBuffer[1024];
Val_t adc_value;

void GPIO_Config()
{   
    GPIO_InitTypeDef    GPIO_InitStruct;
		NVIC_InitTypeDef NVIC_InitStructure;
		EXTI_InitTypeDef EXTI_InitStructure;
    //开启时钟
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);  
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
		RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO, ENABLE);
		//
		GPIO_PinRemapConfig(GPIO_Remap_SWJ_JTAGDisable, ENABLE);
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
		
	  GPIO_ResetBits( GPIOA, GPIO_Pin_2);		//sync output  PA2
		
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

void segger_init(void)
{
	//
	SEGGER_RTT_ConfigUpBuffer(1, "JScope_U2", &JS_RTT_UpBuffer[0], sizeof(JS_RTT_UpBuffer), SEGGER_RTT_MODE_NO_BLOCK_SKIP);
	
	SEGGER_RTT_Init();
	SEGGER_RTT_printf(0, "%sphosense radar chip: XBR820 DEMO%s\r\n", RTT_CTRL_BG_BRIGHT_RED, RTT_CTRL_RESET);
	
	SEGGER_SYSVIEW_Conf();
}

int main(void)
{
	unsigned int free_runner = 0;
	
  GPIO_Config();
  ADCx_Init();
	segger_init();
	delay_init();
	
  while (1)
  {
		free_runner++;
		adc_value.Val1 = ADC_ConvertedValue;
		SEGGER_RTT_Write(1, &adc_value, sizeof(adc_value));
		delay_us(200);
		
		if (free_runner%300 == 0)
		{
			//
		}
  }
}


