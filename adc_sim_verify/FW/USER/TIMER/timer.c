#include "timer.h"
#include "usart.h"
#include "stdio.h"	
extern __IO uint16_t ADC_ConvertedValue; 
u16 Vel_Value[30000]={0};
//u16 Vel_Value;
u16 num;
//u16 T_num=0;
u8 Symble=0;
u16 num_sign[500];
u16 sign=0;
// �ж����ȼ�����
static void BASIC_TIM_NVIC_Config(void)
{
    NVIC_InitTypeDef NVIC_InitStructure;     
    NVIC_PriorityGroupConfig(NVIC_PriorityGroup_0);		         // �����ж���Ϊ0		
    NVIC_InitStructure.NVIC_IRQChannel = BASIC_TIM_IRQ ;	     // �����ж���Դ		
    NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;	 // ���������ȼ�Ϊ 1	  
    NVIC_InitStructure.NVIC_IRQChannelSubPriority = 3;	         // ������ռ���ȼ�Ϊ3
    NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;              // �ж�ʹ��
    NVIC_Init(&NVIC_InitStructure);
}
//��ʱ����ʼ��
static void BASIC_TIM_Mode_Config(void)
{
    TIM_TimeBaseInitTypeDef  TIM_TimeBaseStructure;	
    BASIC_TIM_APBxClock_FUN(BASIC_TIM_CLK, ENABLE);          // ������ʱ��ʱ��,���ڲ�ʱ��CK_INT=72M		
    TIM_TimeBaseStructure.TIM_Period = BASIC_TIM_Period;	 // �Զ���װ�ؼĴ�����ֵ���ۼ�TIM_Period+1��Ƶ�ʺ����һ�����»����ж�
    TIM_TimeBaseStructure.TIM_Prescaler= BASIC_TIM_Prescaler;// ����ʱ��Ԥ��Ƶ   
    TIM_TimeBaseInit(BASIC_TIM, &TIM_TimeBaseStructure);     // ��ʼ����ʱ��			
    TIM_ClearFlag(BASIC_TIM, TIM_FLAG_Update);               // ����������жϱ�־λ	  	
    TIM_ITConfig(BASIC_TIM,TIM_IT_Update,ENABLE);            // �����������ж�		   
    TIM_Cmd(BASIC_TIM, ENABLE);                              // ʹ�ܼ�����	
}
//��ʼ��  �жϣ���ʱ��
void BASIC_TIM_Init(void)
{
	BASIC_TIM_NVIC_Config();
	BASIC_TIM_Mode_Config();
}

#if 0
void TIM3_IRQHandler()
{   
	if ( TIM_GetITStatus( TIM3, TIM_IT_Update) != RESET ) 
	{    
        Vel_Value=ADC_ConvertedValue;
        printf("%04d ",Vel_Value );      	
    TIM_ClearITPendingBit(TIM3 , TIM_FLAG_Update);   //�жϹ���   
    }
}
#endif



#if 1
//��ʱ��3�жϷ�����
void TIM3_IRQHandler()
{   
	if ( TIM_GetITStatus( TIM3, TIM_IT_Update) != RESET ) 
	{
//        if(num==0) printf("Begin ");
        if(Symble==0)
        {
            Vel_Value[num]=ADC_ConvertedValue;
        }
        else
        {
            Vel_Value[num]=9999;
            num_sign[sign]=ADC_ConvertedValue;
            Symble=0;
            sign++;
        }
        num++;        
        if(num==30000) 
        {   
            sign=0;
            printf("Begin ");
            for (num = 0; num < 30000; num++ )
            {
                if(Vel_Value[num]==9999) 
                {
                    printf("%04d ",num_sign[sign] );
                    printf("\r\n ");
                          
                    sign++;
                }
                else printf("%04d ",Vel_Value[num] );
//                delay_us(40);
            }
            printf("End\r\n");
            sign=0;
            num=0;
	    }	
    TIM_ClearITPendingBit(TIM3 , TIM_FLAG_Update);   //�жϹ���   
    }
}
#endif









