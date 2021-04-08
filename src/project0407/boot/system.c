#include "xbr820.h"

#ifndef CONFIG_SYSTICK_HZ
 #define CONFIG_SYSTICK_HZ	100	//10ms
#endif

extern void stc_init(void);

/**
  * @brief  initialize the system
  *         Initialize the psr and vbr.
  * @param  None
  * @return None
  */
void SystemInit(void)
{
    /* enable mxstatus THEADISAEE */
    uint32_t mxstatus = __get_MXSTATUS();
    mxstatus |= (1 << 22);
    __set_MXSTATUS(mxstatus);

    /* get interrupt level from info */
    CLIC->CLICCFG = (((CLIC->CLICINFO & CLIC_INFO_CLICINTCTLBITS_Msk) >> CLIC_INFO_CLICINTCTLBITS_Pos) << CLIC_CLICCFG_NLBIT_Pos);

    for (int i = 0; i < 64; i++) {
        CLIC->CLICINT[i].IP = 0;
        CLIC->CLICINT[i].ATTR = 1; /* use vector interrupt */
    }

    /* tspend use positive interrupt */
    CLIC->CLICINT[Machine_Software_IRQn].ATTR = 0x3;

    //csi_icache_enable();
    csi_vic_enable_irq(Machine_Software_IRQn);
	
	stc_init();
#if CONFIG_HAVE_VIC
    __enable_excp_irq();
#endif
    csi_coret_config(SYSTEM_CLOCK / CONFIG_SYSTICK_HZ); 
}
