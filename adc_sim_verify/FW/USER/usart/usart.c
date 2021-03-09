#include "usart.h"
#include "stdio.h"	
//加入以下代码,支持printf函数,而不需要选择use MicroLIB	  
#if 1
#pragma import(__use_no_semihosting)             
//标准库需要的支持函数                 
struct __FILE 
{ 
	int handle; 
}; 

FILE __stdout;       
//定义_sys_exit()以避免使用半主机模式    
void  _sys_exit(int x)
{ 
	x = x; 
} 
//重定义fputc函数 
int fputc(int ch, FILE *f)
{ 	
	while((USART1->SR&0X40)==0);//循环发送,直到发送完毕   
	USART1->DR = (u8) ch;      
	return ch;
}
#endif
static void NVIC_Configuration(void)
{
    NVIC_InitTypeDef  NVIC_InitStructure;    
    NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2);              // 嵌套向量中断控制器组选择    
    NVIC_InitStructure.NVIC_IRQChannel =USART2_IRQn ;            // 配置USART为中断源     
    NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 1;    // 抢断优先级     
    NVIC_InitStructure.NVIC_IRQChannelSubPriority = 1;           // 子优先级    
    NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;              // 使能中断    
    NVIC_Init(&NVIC_InitStructure);                              // 初始化配置NVIC 
}
/******************************
函数功能：串口、管脚初始化
函数名称：void USART_Config()
函数返回值：无
函数参数：无
*******************************/
void USART_Config()
{   
    USART_InitTypeDef   USART_Structure;
    GPIO_InitTypeDef    GPIO_InitStruct;
    //开启时钟
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);  
    RCC_APB1PeriphClockCmd(RCC_APB2Periph_USART1,ENABLE);
  
    //配置GPIO_TX为复用推挽输出
    GPIO_InitStruct.GPIO_Pin = TX ;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_AF_PP;
    GPIO_InitStruct.GPIO_Speed =GPIO_Speed_50MHz;
    GPIO_Init(GPIOA,&GPIO_InitStruct) ; 
    //配置GPIO_RX为浮空输入
    GPIO_InitStruct.GPIO_Pin = RX ;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IN_FLOATING;
    GPIO_Init(GPIOA,&GPIO_InitStruct) ; 
    
    //配置串口通信
    USART_Structure.USART_BaudRate =115200;
    USART_Structure.USART_HardwareFlowControl =  USART_HardwareFlowControl_None;
    USART_Structure.USART_Mode =  USART_Mode_Rx|USART_Mode_Tx;
    USART_Structure.USART_Parity =USART_Parity_No;
    USART_Structure.USART_StopBits =USART_StopBits_1;
    USART_Structure.USART_WordLength =  USART_WordLength_8b;
    USART_Init(USART1 ,&USART_Structure);
    
    //使能串口外围设备
    USART_Cmd( USART1,  ENABLE);
    
    //使能串口接受数据中断，接收后立马返回信息以实现状态检测
//    USART_ITConfig(USART2,USART_IT_RXNE, ENABLE);
//    USART_ITConfig(USART2,USART_IT_IDLE,ENABLE);            //使能总线空闲检测中断
    
    //中断优先级
    NVIC_Configuration();
}
/*****************************************************************
函数功能：通过串口发送4个字节
函数名称：void Usart_SendByte( USART_TypeDef * USARTx, uint8_t ch)
函数返回值：无
函数参数：USARTx，串口组  ch，要发送的字节
*****************************************************************/
void Usart_SendByte( USART_TypeDef * USARTx, uint32_t ch)
{   
    u8 Sendch[4];
    u8 i=0;
    Sendch[0]=ch>>24;
    Sendch[1]=ch>>16;
    Sendch[2]=ch>>8;
    Sendch[3]=ch;
    for(i=2;i<4;i++)                                                        //i=2,只发低16位
    {
        USART_SendData(USARTx,Sendch[i]);		                            // 发送一个字节数据到USART 	
        while (USART_GetFlagStatus(USARTx, USART_FLAG_TXE) == RESET);       // 等待发送数据寄存器为空
    }        
}






