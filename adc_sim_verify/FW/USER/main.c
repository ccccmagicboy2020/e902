#include "stm32f10x.h"
#include "ADC_DMA.h"

double V;
void USART_Config()
{   
    GPIO_InitTypeDef    GPIO_InitStruct;
    //开启时钟
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);  
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
    //配置GPIO_TX为复用推挽输出
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_0|GPIO_Pin_1|GPIO_Pin_2|GPIO_Pin_3|GPIO_Pin_4|GPIO_Pin_5|GPIO_Pin_6|GPIO_Pin_7|GPIO_Pin_8|GPIO_Pin_9|GPIO_Pin_10|GPIO_Pin_11;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStruct.GPIO_Speed =GPIO_Speed_50MHz;
    GPIO_Init(GPIOB,&GPIO_InitStruct) ;
	
	  GPIO_InitStruct.GPIO_Pin = GPIO_Pin_1|GPIO_Pin_2|GPIO_Pin_3;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStruct.GPIO_Speed =GPIO_Speed_50MHz;
    GPIO_Init(GPIOA,&GPIO_InitStruct) ;
	
    GPIO_SetBits( GPIOB, GPIO_Pin_0);
	  GPIO_SetBits( GPIOB, GPIO_Pin_1);
	  GPIO_SetBits( GPIOB, GPIO_Pin_2);
	  GPIO_SetBits( GPIOB, GPIO_Pin_3);
	  GPIO_SetBits( GPIOB, GPIO_Pin_4);
	  GPIO_SetBits( GPIOB, GPIO_Pin_5);
	  GPIO_SetBits( GPIOB, GPIO_Pin_6);
	  GPIO_SetBits( GPIOB, GPIO_Pin_7);
	  GPIO_SetBits( GPIOB, GPIO_Pin_8);
	  GPIO_SetBits( GPIOB, GPIO_Pin_9);
		GPIO_SetBits( GPIOB, GPIO_Pin_10);
		GPIO_SetBits( GPIOB, GPIO_Pin_11);
	  GPIO_SetBits( GPIOA, GPIO_Pin_1);
	  GPIO_SetBits( GPIOA, GPIO_Pin_2);
	  GPIO_SetBits( GPIOA, GPIO_Pin_3);
}

int main(void)
{
	u16 i;
  USART_Config();
  ADCx_Init(); 
  while (1)
  {
		for(i=1000;i>0;i--);
    V=ADC1_Voltage();
  }
}


