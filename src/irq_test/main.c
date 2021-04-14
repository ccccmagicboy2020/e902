
#include <xbr820.h>

extern void uart_init(void);
int main() {
    /* get interrupt level from info */
    CLIC->CLICCFG = (((CLIC->CLICINFO & CLIC_INFO_CLICINTCTLBITS_Msk) >> CLIC_INFO_CLICINTCTLBITS_Pos) << CLIC_CLICCFG_NLBIT_Pos);

     for (int i = 0; i < 64; i++) {
        CLIC->CLICINT[i].IP = 0;
        CLIC->CLICINT[i].ATTR = 1; /* use vector interrupt */
    }
    for (int i = GPIO_IRQn; i < IRQ_NUMS; i++) {
        CLIC->CLICINT[i].ATTR = 5; /* use positive level vector interrupt */
    }
    __enable_excp_irq();

	uart_init();

	while(1);
	return 0;
}
