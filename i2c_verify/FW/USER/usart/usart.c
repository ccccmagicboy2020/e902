#include "usart.h"
#include "stdio.h"	
//�������´���,֧��printf����,������Ҫѡ��use MicroLIB	  
#if 1
#pragma import(__use_no_semihosting)             
//��׼����Ҫ��֧�ֺ���                 
struct __FILE 
{ 
	int handle; 
}; 

FILE __stdout;       
//����_sys_exit()�Ա���ʹ�ð�����ģʽ    
void  _sys_exit(int x)
{ 
	x = x; 
} 
//�ض���fputc���� 
int fputc(int ch, FILE *f)
{ 	
	while((USART1->SR&0X40)==0);//ѭ������,ֱ���������   
	USART1->DR = (u8) ch;      
	return ch;
}
#endif
static void NVIC_Configuration(void)
{
    NVIC_InitTypeDef  NVIC_InitStructure;    
    NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2);              // Ƕ�������жϿ�������ѡ��    
    NVIC_InitStructure.NVIC_IRQChannel =USART2_IRQn ;            // ����USARTΪ�ж�Դ     
    NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 1;    // �������ȼ�     
    NVIC_InitStructure.NVIC_IRQChannelSubPriority = 1;           // �����ȼ�    
    NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;              // ʹ���ж�    
    NVIC_Init(&NVIC_InitStructure);                              // ��ʼ������NVIC 
}
/******************************
�������ܣ����ڡ��ܽų�ʼ��
�������ƣ�void USART_Config()
��������ֵ����
������������
*******************************/
void USART_Config()
{   
    USART_InitTypeDef   USART_Structure;
    GPIO_InitTypeDef    GPIO_InitStruct;
    //����ʱ��
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);  
    RCC_APB1PeriphClockCmd(RCC_APB2Periph_USART1,ENABLE);
  
    //����GPIO_TXΪ�����������
    GPIO_InitStruct.GPIO_Pin = TX ;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_AF_PP;
    GPIO_InitStruct.GPIO_Speed =GPIO_Speed_50MHz;
    GPIO_Init(GPIOA,&GPIO_InitStruct) ; 
    //����GPIO_RXΪ��������
    GPIO_InitStruct.GPIO_Pin = RX ;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IN_FLOATING;
    GPIO_Init(GPIOA,&GPIO_InitStruct) ; 
    
    //���ô���ͨ��
    USART_Structure.USART_BaudRate =115200;
    USART_Structure.USART_HardwareFlowControl =  USART_HardwareFlowControl_None;
    USART_Structure.USART_Mode =  USART_Mode_Rx|USART_Mode_Tx;
    USART_Structure.USART_Parity =USART_Parity_No;
    USART_Structure.USART_StopBits =USART_StopBits_1;
    USART_Structure.USART_WordLength =  USART_WordLength_8b;
    USART_Init(USART1 ,&USART_Structure);
    
    //ʹ�ܴ�����Χ�豸
    USART_Cmd( USART1,  ENABLE);
    
    //ʹ�ܴ��ڽ��������жϣ����պ���������Ϣ��ʵ��״̬���
//    USART_ITConfig(USART2,USART_IT_RXNE, ENABLE);
//    USART_ITConfig(USART2,USART_IT_IDLE,ENABLE);            //ʹ�����߿��м���ж�
    
    //�ж����ȼ�
    NVIC_Configuration();
}
/*****************************************************************
�������ܣ�ͨ�����ڷ���4���ֽ�
�������ƣ�void Usart_SendByte( USART_TypeDef * USARTx, uint8_t ch)
��������ֵ����
����������USARTx��������  ch��Ҫ���͵��ֽ�
*****************************************************************/
void Usart_SendByte( USART_TypeDef * USARTx, uint32_t ch)
{   
    u8 Sendch[4];
    u8 i=0;
    Sendch[0]=ch>>24;
    Sendch[1]=ch>>16;
    Sendch[2]=ch>>8;
    Sendch[3]=ch;
    for(i=2;i<4;i++)                                                        //i=2,ֻ����16λ
    {
        USART_SendData(USARTx,Sendch[i]);		                            // ����һ���ֽ����ݵ�USART 	
        while (USART_GetFlagStatus(USARTx, USART_FLAG_TXE) == RESET);       // �ȴ��������ݼĴ���Ϊ��
    }        
}






