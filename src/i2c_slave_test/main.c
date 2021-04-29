
#include <xbr820.h>

extern void uart_init(void);
extern int getchar(void);
extern void _putchar(int ch);

static void _puts(const char * str) {
	while (*str)
		_putchar(*str++);
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

	uart_init();
	_puts("-- UartIRQ test "__DATE__" "__TIME__" --\n");
	while(1) {
		int ch = getchar();
		if (ch > 0)
			_putchar(ch);
	}
	return 0;
}
