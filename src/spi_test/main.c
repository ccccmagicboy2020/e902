#include <xbr820.h>

#define XBR820_SPI_BASEADDR	(0)

#define SPI_CMMD_LEN		11
#define SPI_READ_LEN		4
#define SPI_BURST_LEN		4

/* XBR820 serial FLASH registers, loop mapping each 16B */
#define SPI_CR				(XBR820_SPI_BASEADDR + 0)
#define SPI_CM				(XBR820_SPI_BASEADDR + 4)
#define SPI_CM1				(XBR820_SPI_BASEADDR + 8)
#define SPI_CM2				(XBR820_SPI_BASEADDR + 12)

/* XBR820 serial FLASH CR bits */
#define SPI_CR_CLKPH		0x01	/* SPI clock phase when working */
#define SPI_CR_CLKPO		0x02	/* SPI clock active porlarity */
#define SPI_CR_SPIEN		0x04	/* SPI controller enable or not */
#define SPI_CR_STOP			0x08	/* SPI sequency stop */
#define SPI_CR_HOLD			0x10	/* SPI HOLD pin control */
#define SPI_CR_DUAL			0x20	/* SPI FLASH dual read mode */
#define SPI_CR_SPI2			0x40	/* SPI CS2 for second SPI FLASH */

/* XBR820 serial FLASH CM0 bits */
#define SPI_CM_CMLEN		0x04
#define SPI_CM_RXLEN		0x70
#define SPI_CM_RXEN			0x80

uint32_t flash_id;

int main() {
	BHW_t id = { .w = 0};

	/* Enable SFLASH module */
	reg32_write(SPI_CR, 0);
	reg32_write(SPI_CR, SPI_CR_SPIEN | SPI_CR_STOP);
	reg32_write(SPI_CM, 0x000000B4 | (0x9F << 8));
	id.w = reg32_read(SPI_CR);
	swap(id.b[0], id.b[2], id.b[3]);
	flash_id = id.w & 0x00FFFFFF;
	while(1);
	return 0;
}
