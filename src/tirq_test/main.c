
#include <xbr820.h>

extern void timer_init(unsigned char chan, unsigned int val);

extern volatile uint32_t tm_count;
extern volatile uint32_t tm_count1;
extern volatile uint32_t tm_count2;
extern volatile uint32_t tm_count3;

void delay(unsigned int val)
{
	tm_count = 0;
	while(tm_count < val)
	{
		//
	}
}

void delay1(unsigned int val)
{
	tm_count1 = 0;
	while(tm_count1 < val)
	{
		//
	}
}

void delay2(unsigned int val)
{
	tm_count2 = 0;
	while(tm_count2 < val)
	{
		//
	}
}

void delay3(unsigned int val)
{
	tm_count3 = 0;
	while(tm_count3 < val)
	{
		//
	}
}

int main() {
    /* get interrupt level from info */
    CLIC->CLICCFG = (((CLIC->CLICINFO & CLIC_INFO_CLICINTCTLBITS_Msk) >> CLIC_INFO_CLICINTCTLBITS_Pos) << CLIC_CLICCFG_NLBIT_Pos);

     for (int i = 0; i < 64; i++) {
        CLIC->CLICINT[i].IP = 0;
        CLIC->CLICINT[i].ATTR = 1; /* use vector interrupt */
    }
    for (int i = GPIO_IRQn; i < IRQ_NUMS; i++) {
        CLIC->CLICINT[i].ATTR = 3; /* use positive egde vector interrupt */
    }
    __enable_excp_irq();
	
	

	timer_init(0, SYSTEM_CLOCK / 1000);	//1ms
	timer_init(1, SYSTEM_CLOCK / 100);	//10ms
	timer_init(2, SYSTEM_CLOCK / 10);	//100ms
	timer_init(3, SYSTEM_CLOCK / 100);	//10ms

	while(1)
	{
		delay(1000);
		delay1(100);
		delay2(10);
		delay3(100);
	}
	return 0;
}
