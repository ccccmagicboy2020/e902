#ifndef __TIMER_H
#define __TIMER_H


#define            BASIC_TIM                   TIM3
#define            BASIC_TIM_APBxClock_FUN     RCC_APB1PeriphClockCmd
#define            BASIC_TIM_CLK               RCC_APB1Periph_TIM3
#define            BASIC_TIM_Period            719
#define            BASIC_TIM_Prescaler         0                       //10 us发生一次中断
#define            BASIC_TIM_IRQ               TIM3_IRQn
#define            BASIC_TIM_IRQHandler        TIM3_IRQHandler

void BASIC_TIM_Init(void);
 
#endif
