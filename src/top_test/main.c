/*============================================================================
 * Name        : main.c
 * Author      : WangYang
 * Version     : 0.0.0
 * Copyright   : Your copyright notice
 * Description : Simple function in C, Ansi-style
 *============================================================================
 */
 #include "xbr820.h"


/**
 * @brief the main entry of the application; when run to here, the system has been initialized includes:
 * 1 CPU processor status register
 * 2 CPU vector base register
 * 3 CPU Units such as MGU, Cache...
 * 4 IO base address
 *
 * @return For MCU application, it's better to loop here
 */
 uint32_t reg_data;
int main()
{
	reg_data = reg32_read(XBR820_TOP_BASE);
	reg32_write(XBR820_TOP_BASE + 0xC0, reg_data);
	while(1);
	return 0;
}
