
#include <xbr820.h>

extern void timer_init(void);

extern volatile uint32_t tm_count;

void delay(unsigned int val)
{
	tm_count = 0;
	while(tm_count < val)
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

	timer_init();

	while(1)
	{
		delay(100);
	}
	return 0;
}
