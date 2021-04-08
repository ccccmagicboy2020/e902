/*============================================================================
 * Name        : sf.c
 * Author      : WangYang
 * Description : SPI Flash interface
 *============================================================================
 */
#include "sf_dev.h"
#include "sf.h"

#ifndef SF_PAGE_SIZE
 #define SF_PAGE_SIZE	(1 << 8)
#endif
#ifndef SF_CMD_READ
 #define SF_CMD_READ	COMMON_INS_FARDD
#endif

#define SPI_CMMD_LEN	11
#define SPI_READ_LEN	4
#define SPI_BURST_LEN	4

/* XBR820 serial FLASH registers, loop mapping each 16B */
#define SPI_CR			(XBR820_SPI_BASEADDR + 0)
#define SPI_CM			(XBR820_SPI_BASEADDR + 4)
#define SPI_CM1			(XBR820_SPI_BASEADDR + 8)
#define SPI_CM2			(XBR820_SPI_BASEADDR + 12)

/* XBR820 serial FLASH CR bits */
#define SPI_CR_CLKPH	0x01	/* SPI clock phase when working */
#define SPI_CR_CLKPO	0x02	/* SPI clock active porlarity */
#define SPI_CR_SPIEN	0x04	/* SPI controller enable or not */
#define SPI_CR_STOP		0x08	/* SPI sequency stop */
#define SPI_CR_HOLD		0x10	/* SPI HOLD pin control */
#define SPI_CR_DUAL		0x20	/* SPI FLASH dual read mode */
#define SPI_CR_SPI2		0x40	/* SPI CS2 for second SPI FLASH */

/* XBR820 serial FLASH CM0 bits */
#define SPI_CM_CMLEN	0x04
#define SPI_CM_RXLEN	0x70
#define SPI_CM_RXEN		0x80


#define send_cmd(cmd)	do { reg32_write(SPI_CM, 0x01 | (cmd << 8)); } while(0)

uint32_t sf_size;
uint32_t sf_id;

static void wait_ready(void)
{
	/* Read from any address of serial flash to check device free. */
	while (1) {
		/* Set RDSR instruction: TX command length is 1, RX data length is 1, total 2 */
		reg32_write(SPI_CM, 0x92 | (COMMON_INS_RDSR << 8));

		if (reg32_read(SPI_CR & 1) == 0)
			break;
	}
	/* Reset sflash to common read mode */
}

static void write_protect(int en)
{
	send_cmd(COMMON_INS_WREN);
	if (en) {
		/* Set WRSR instruction: TX command length is 2 (SR=0x7F), RX data length is 0, total 2 */
		reg32_write(SPI_CM, 0x02 | (COMMON_INS_WRSR << 8) | (0x7F << 16));
	} else {
		/* Set WRSR instruction: TX command length is 2 (SR=0x00), RX data length is 0, total 2 */
		reg32_write(SPI_CM, 0x02 | (COMMON_INS_WRSR << 8));
	}
	wait_ready();
}

static uint32_t get_id(void)
{
	BHW_t id;

	/* Enable SFLASH module */
	reg32_write(SPI_CR, 0);
	reg32_write(SPI_CR, SPI_CR_SPIEN | SPI_CR_STOP);
	write_protect(1);
	/* Read Identification JEDEC ID */
	/* TX command length is 1, RX data length is 3, total is 4 */
	reg32_write(SPI_CM, 0x000000B4 | (COMMON_INS_JEDEC << 8));
	id.w = reg32_read(SPI_CR0);
	swap(id.b[0], id.b[2], id.b[3]);
	id.w &= 0x00FFFFFF;
	return id;
}

int sf_init(void)
{
	sf_id = get_id();
	if (sf_id) {
		uint8_t cap = sf_id & 0x0F;
		sf_size = SF_BLOCK_SIZE << cap;
	}
	else
		sf_size = 0;
	return (sf_id != 0);
}

int sf_chip_erase(void)
{
	if (!sf_size)
		return -1;

	reg32_write(SPI_CR, SPI_CR_SPIEN | SPI_CR_STOP);
	write_protect(0);
	/* Enable write */
	send_cmd(COMMON_INS_WREN);
	/* Set errase instruction: TX command length is 1, RX data length is 0, total 1 */
	reg32_write(SPI_CM, 0x01 | (COMMON_INS_BE << 8));

	wait_ready();
	/* Protect chip */
	write_protect(1);

	return 0;
}

int sf_block_erase(uint32_t offset)
{
	if (offset >= sf_size)
		return -1;

	reg32_write(SPI_CR, SPI_CR_SPIEN | SPI_CR_STOP);
	write_protect(0);
	/* Enable write */
	send_cmd(COMMON_INS_WREN);
	/* Set errase instruction: TX command length is 4, RX data length is 0, total 4 */
	reg32_write((SPI_CM1), offset & 0xFF);
	reg32_write(SPI_CM, 0x04 | (COMMON_INS_SE << 8) | (offset & 0xFF0000) | ((offset & 0xFF00) << 16));

	wait_ready();
	/* Protect chip */
	write_protect(1);

	return 0;
}

int sf_write(uint32_t offset, const uint8_t *data, uint32_t len)
{
	uint8_t buffer[12];
	uint32_t first;

	if (offset + len > sf_size)
		return -1;

	reg32_write(SPI_CR, SPI_CR_SPIEN | SPI_CR_STOP);
	write_protect(0);
	while (len > 0) {
		uint32_t block_len = ((offset + SF_PAGE_SIZE) & ~(SF_PAGE_SIZE - 1)) - offset;	/* Num to align */
		if (block_len > len)
			block_len = len;
		len -= block_len;
		first = 1;
		send_cmd(COMMON_INS_WREN);
		while (block_len > 0) {
			uint32_t pos, current_len;
			if (first) {
				first = 0;
				buffer[1] = COMMON_INS_PP;
				current_len = (block_len + 4 > SPI_CMMD_LEN) ? SPI_CMMD_LEN - 4 : block_len;
				/* TX command length is current_len + 4, RX data length is 0, total is current_len + 4 */
				buffer[0] = current_len + 4;
				buffer[2] = (uint8_t)(offset >> 16);
				buffer[3] = (uint8_t)(offset >> 8);
				buffer[4] = (uint8_t)(offset);
				pos = 5;
				offset += block_len;
			} else {
				current_len = (block_len > SPI_CMMD_LEN) ? SPI_CMMD_LEN : block_len;
				/* TX command length is current_len, RX data length is 0, total is current_len */
				buffer[0] = current_len;
				pos = 1;
			}
			block_len -= current_len;
			/* Set WR instruction */
			for (uint32_t i = 0; i < current_len; i++)
				buffer[pos++] = *data++;

			if (block_len) {
				/* If we need next read action, set transfer keeping */
				reg32_write(SPI_CR, SPI_CR_SPIEN);
			} else {
				reg32_write(SPI_CR, SPI_CR_SPIEN | SPI_CR_STOP);
			}
			/* Set page program instruction */
			reg32_write((SPI_CM2), (buffer[11] << 24) | (buffer[10] << 16) | (buffer[9] << 8) | buffer[8]);
			reg32_write((SPI_CM1), (buffer[7 ] << 24) | (buffer[6 ] << 16) | (buffer[5] << 8) | buffer[4]);
			reg32_write((SPI_CM ), (buffer[3 ] << 24) | (buffer[2 ] << 16) | (buffer[1] << 8) | buffer[0]);
		}
		wait_ready();
	}

	/* Protect chip */
	write_protect(1);

	return 0;
}

int sf_read(uint8_t *data, uint32_t offset, uint32_t len)
{
	uint8_t cmd = SF_CMD_READ;
	uint8_t dmlen =(cmd == COMMON_INS_READ) ?  0 : 1;
	uint8_t crmsk = (cmd == COMMON_INS_FARDD) ? 0x20 : 0;
	uint8_t buffer[7] = {0};
	int first = 1;

	if (offset + len > sf_size)
		return -1;

	reg32_write(SPI_CR, SPI_CR_SPIEN | SPI_CR_STOP);
	while (len) {
		uint32_t current_len = len > SPI_READ_LEN ? SPI_READ_LEN : len;
		len -= current_len;
		if (len) {
			/* If we need next read action, set transfer keeping */
			reg32_write(SPI_CR, crmsk | SPI_CR_SPIEN);
		} else {
			reg32_write(SPI_CR, crmsk | SPI_CR_SPIEN | SPI_CR_STOP);
		}
		/* Set RD instruction */
		if (first) {
			first = 0;
			buffer[1] = cmd;
			/* TX command length is 5, RX data length is current_len, total is current_len + 5 */
			buffer[0] = 0x80 | (current_len << 4) | (current_len + dmlen + 4);
			buffer[2] = (uint8_t)(offset >> 16);
			buffer[3] = (uint8_t)(offset >> 8);
			buffer[4] = (uint8_t)(offset);
		} else {
			/* TX command length is 0, RX data length is current_len, total is current_len */
			buffer[0] = 0x80 | (current_len << 4) | current_len;
		}
		reg32_write((SPI_CM1), buffer[4]);
		reg32_write((SPI_CM ), (buffer[3] << 24) | (buffer[2] << 16) | (buffer[1] << 8) | buffer[0]);
		/* Read data */
		for (uint32_t burst_len = current_len > SPI_BURST_LEN ?
			SPI_BURST_LEN : current_len; current_len > 0; current_len -= burst_len) {
			uint32_t dw = reg32_read(SPI_CR);
			for (uint32_t i = 0; i < burst_len; i++) {
				*data++ = ((dw >> (8 * i)) & 0xFF);
			}
		}
	}
	reg32_write(SPI_CR, SPI_CR_SPIEN | SPI_CR_STOP);
	return 0;
}
#ifdef SF_VERIFY
static const uint32_t msk_tab[4] = {0xFF, 0xFFFF, 0xFFFFFF, 0xFFFFFFFF};
int sf_verify(uint32_t offset, const uint8_t *data, uint32_t len)
{
	uint8_t cmd = SF_CMD_READ;
	uint8_t dmlen =(cmd == COMMON_INS_READ) ?  0 : 1;
	uint8_t crmsk = (cmd == COMMON_INS_FARDD) ? 0x20 : 0;
	/* IC support MAX only 4 bytes continue read */
	uint8_t buffer[5];
	int first = 1, ret = 1;

	if (offset + len > sf_size)
		return -1;

	reg32_write(SPI_CR, SPI_CR_SPIEN | SPI_CR_STOP);
	while (len && ret) {
		uint32_t current_len = len > SPI_READ_LEN ? SPI_READ_LEN : len;
		len -= current_len;
		if (len) {
			/* If we need next read action, set transfer keeping */
			reg32_write(SPI_CR, crmsk | SPI_CR_SPIEN);
		} else {
			reg32_write(SPI_CR, crmsk | SPI_CR_SPIEN | SPI_CR_STOP);
		}
		/* Set RD instruction */
		if (first) {
			first = 0;
			buffer[1] = cmd;
			/* TX command length is 5, RX data length is current_len, total is current_len + 5 */
			buffer[0] = 0x80 | (current_len << 4) | (current_len + dmlen + 4);
			buffer[2] = (uint8_t)(offset >> 16);
			buffer[3] = (uint8_t)(offset >> 8);
			buffer[4] = (uint8_t)(offset);
		} else {
			/* TX command length is 0, RX data length is current_len, total is current_len */
			buffer[0] = 0x80 | (current_len << 4) | current_len;
		}
		reg32_write((SPI_CM1), buffer[4]);
		reg32_write((SPI_CM ), (buffer[3] << 24) | (buffer[2] << 16) | (buffer[1] << 8) | buffer[0]);
		/* Verify data */
		for (uint32_t burst_len = current_len > SPI_BURST_LEN ?
			SPI_BURST_LEN : current_len; current_len > 0; current_len -= burst_len) {
			uint32_t msk = msk_tab[burst_len - 1];
			uint32_t dst = reg32_read(SPI_CR) & msk;
			uint32_t src = *data++;
			src |= (*data++ << 8);
			src |= (*data++ << 16);
			src |= (*data++ << 24);
			src &= msk;
			if (dst != src) {
				ret = 0;
				break;
			}
		}
	}

	reg32_write(SPI_CR, SPI_CR_SPIEN | SPI_CR_STOP);
	reg32_read(SPI_CR);	/* Read out dummy data when break case */

	return ret;
}
#endif // SF_VERIFY
