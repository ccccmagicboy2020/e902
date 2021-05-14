
#include <xbr820.h>



//extern void uart_init(void);
//extern int getchar(void);
//extern void _putchar(int ch);

//static void _puts(const char * str) {
//	while (*str)
//		_putchar(*str++);
//}

void i2c_slave_init(void)
{
	//
	SLAVEDEV = 0x0000000CUL;
	EN_SLAVEB = 0x00000001UL;
	csi_vic_enable_irq(I2C_SLAVE_IRQn);
}

int main() {
    /* get interrupt level from info */
//    CLIC->CLICCFG = (((CLIC->CLICINFO & CLIC_INFO_CLICINTCTLBITS_Msk) >> CLIC_INFO_CLICINTCTLBITS_Pos) << CLIC_CLICCFG_NLBIT_Pos);
//
//	for (int i = 0; i < 64; i++) {
//        CLIC->CLICINT[i].IP = 0;
//        CLIC->CLICINT[i].ATTR = 1; /* use vector interrupt */
//    }
//    for (int i = GPIO_IRQn; i < IRQ_NUMS; i++) {
//        CLIC->CLICINT[i].ATTR = 3; /* use positive egde vector interrupt */
//    }
    __enable_excp_irq();

	//uart_init();
	//_puts("-- UartIRQ test "__DATE__" "__TIME__" --\n");
	
	i2c_slave_init();
	
	while(1) 
	{
		//do nothing
	}
	return 0;
}
