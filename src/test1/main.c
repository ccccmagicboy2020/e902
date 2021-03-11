/*============================================================================
 * Name        : main.c
 * Author      : WangYang
 * Version     : 0.0.0
 * Copyright   : Your copyright notice
 * Description : Simple function in C, Ansi-style
 *============================================================================
 */
 #include "xbr820.h"
 
 #define TEST_ADDR	(SRAM_START + SRAM_SIZE / 2)

/**
 * @brief the main entry of the application; when run to here, the system has been initialized includes:
 * 1 CPU processor status register
 * 2 CPU vector base register
 * 3 CPU Units such as MGU, Cache...
 * 4 IO base address
 *
 * @return For MCU application, it's better to loop here
 */
int main()
{
    reg32_write(TEST_ADDR, 0x5aa5a55a);
     reg16_write(TEST_ADDR + 6, 0x5aa5);
     reg8_write(TEST_ADDR + 11, 0xa5);
	 while(1);
    return 0;
}
