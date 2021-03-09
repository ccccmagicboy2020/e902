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
// 中断优先级配置
static void BASIC_TIM_NVIC_Config(void)
{
    NVIC_InitTypeDef NVIC_InitStructure;     
    NVIC_PriorityGroupConfig(NVIC_PriorityGroup_0);		         // 设置中断组为0		
    NVIC_InitStructure.NVIC_IRQChannel = BASIC_TIM_IRQ ;	     // 设置中断来源		
    NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;	 // 设置主优先级为 1	  
    NVIC_InitStructure.NVIC_IRQChannelSubPriority = 3;	         // 设置抢占优先级为3
    NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;              // 中断使能
    NVIC_Init(&NVIC_InitStructure);
}
//定时器初始化
static void BASIC_TIM_Mode_Config(void)
{
    TIM_TimeBaseInitTypeDef  TIM_TimeBaseStructure;	
    BASIC_TIM_APBxClock_FUN(BASIC_TIM_CLK, ENABLE);          // 开启定时器时钟,即内部时钟CK_INT=72M		
    TIM_TimeBaseStructure.TIM_Period = BASIC_TIM_Period;	 // 自动重装载寄存器的值，累计TIM_Period+1个频率后产生一个更新或者中断
    TIM_TimeBaseStructure.TIM_Prescaler= BASIC_TIM_Prescaler;// 设置时钟预分频   
    TIM_TimeBaseInit(BASIC_TIM, &TIM_TimeBaseStructure);     // 初始化定时器			
    TIM_ClearFlag(BASIC_TIM, TIM_FLAG_Update);               // 清除计数器中断标志位	  	
    TIM_ITConfig(BASIC_TIM,TIM_IT_Update,ENABLE);            // 开启计数器中断		   
    TIM_Cmd(BASIC_TIM, ENABLE);                              // 使能计数器	
}
//初始化  中断，定时器
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
    TIM_ClearITPendingBit(TIM3 , TIM_FLAG_Update);   //中断挂起   
    }
}
#endif



#if 1
//定时器3中断服务函数
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
    TIM_ClearITPendingBit(TIM3 , TIM_FLAG_Update);   //中断挂起   
    }
}
#endif









