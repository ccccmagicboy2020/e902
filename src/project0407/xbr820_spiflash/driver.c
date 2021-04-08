/*******************************************************************************
 * Copyright (c) 2012-2019 Hangzhou C-SKY Microsystems Co., Ltd.
 * 
 * All rights reserved. This software is proprietary and confidential to
 * Hangzhou C-SKY Microsystems Co., Ltd. and its licensors.
 *
 * Contributors:
 *     Hangzhou C-SKY Microsystems Co., Ltd.
 *
 * 2019.6.18   Jiang Long(long_jiang@c-sky.com)
 *     Initial API and implementation
 *******************************************************************************/
#include "xbr820.h"
#include "flash_config.h"


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


#define send_cmd(cmd)		do { reg32_write(SPI_CM, 0x01 | (cmd << 8)); } while(0)

/**
 * Driver for flash program.
 */

/**
 * ERROR TYPE. MUST NOT BE MODIFIED
 */
#define ERROR_INIT      -200
#define ERROR_READID    -201
#define ERROR_PROGRAM   -202
#define ERROR_READ      -203
#define ERROR_ERASE     -204
#define ERROR_CHIPERASE -205
#define ERROR_UNINIT	-206
#define ERROR_CHECKSUM  -207

uint32_t sf_size;
uint32_t sf_id;
#ifdef CONFIG_LOG_NUMS	
uint16_t* log_data;
uint8_t log_i;
#endif

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

static uint32_t get_id(int jedec)
{
	BHW_t id = { .w = 0};

	/* Enable SFLASH module */
	reg32_write(SPI_CR, 0);
	reg32_write(SPI_CR, SPI_CR_SPIEN | SPI_CR_STOP);
	if (jedec) {
		/* Read Identification JEDEC ID */
		/* TX command length is 1, RX data length is 3, total is 4 */
		reg32_write(SPI_CM, 0x000000B4 | (COMMON_INS_JEDEC << 8));
		id.w = reg32_read(SPI_CR);
		swap(id.b[0], id.b[2], id.b[3]);
		id.w &= 0x00FFFFFF;
	}
	else {
		/* Read Electronic Manufacturer ID & Device ID */
		/* TX command length is 4, RX data length is 2, total is 6 */
		reg32_write(SPI_CM1, 0);
		reg32_write(SPI_CM, 0x000000A6 | (COMMON_INS_RDID << 8));
		id.w = reg32_read(SPI_CR);
		swap(id.b[0], id.b[1], id.b[3]);
		id.w &= 0x0000FFFF;
	}
	return id.w;
}

static void block_erase(uint32_t offset)
{
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
}


/**
 * Customize this method to perform any initialization
 * needed to access your flash device.
 *
 * @return: if this method returns an error,MUST RUTURN ERROR_INIT,
 * Otherwise return 0.
 */
int  flashInit(){
  sf_size = 0;
#ifdef CONFIG_LOG_NUMS
	log_data = (uint16_t *)(XBR820_SRAM_BASE + XBR820_SRAM_SIZE - sizeof(uint16_t)*CONFIG_LOG_NUMS);
	for (log_i = 0; log_i < CONFIG_LOG_NUMS; log_i++)
		log_data[log_i] = 0;
	log_i = 0;
#endif
  sf_id = get_id(1);
  write_protect(1);
  if (!sf_id)
	return ERROR_INIT;
  sf_size = SF_BLOCK_SIZE << (sf_id & 0x0F);
  return 0;
}

/**
 * Customize this method to read flash ID
 *
 * @param flashID: returns for flash ID
 *
 * @return: if this method returns an error,MUST RUTURN ERROR_READID,
 * Otherwise return 0.
 */
int  flashID(uint32_t* flashID){
  uint32_t id = get_id(0);
  if (!id)
	  return ERROR_READID;
  if (flashID)
	  *flashID = id;
  return 0;
}

/**
 * This method takes the data pointed to by the src parameter
 * and writes it to the flash blocks indicated by the
 * dst parameter.
 *
 * @param dst : destination address where flash program
 * @param src : address of data
 * @param length : data length
 *
 * @return : if this method returns an error,MUST RUTURN ERROR_PROGRAM,
 * Otherwise return 0.
 */
int flashProgram(uint32_t dst, const uint8_t *src, uint32_t length){
	uint8_t buffer[12];
	uint32_t first;

#ifdef CONFIG_LOG_NUMS
	if (log_i <= CONFIG_LOG_NUMS - 3) {
		log_data[log_i++] = 1;
		log_data[log_i++] = (uint16_t)dst;
		log_data[log_i++] = (uint16_t)length;
	}
#endif
  if (dst >= sf_size)
	  return ERROR_PROGRAM;
  if (dst + length > sf_size)
	  length = sf_size - dst;

  reg32_write(SPI_CR, SPI_CR_SPIEN | SPI_CR_STOP);
  write_protect(0);
  while (length > 0) {
    uint32_t block_len = ((dst + SF_PAGE_SIZE) & ~(SF_PAGE_SIZE - 1)) - dst;  /* Num to align */
    if (block_len > length)
      block_len = length;
    length -= block_len;
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
        buffer[2] = (uint8_t)(dst >> 16);
        buffer[3] = (uint8_t)(dst >> 8);
        buffer[4] = (uint8_t)(dst);
        pos = 5;
        dst += block_len;
      } else {
        current_len = (block_len > SPI_CMMD_LEN) ? SPI_CMMD_LEN : block_len;
        /* TX command length is current_len, RX data length is 0, total is current_len */
        buffer[0] = current_len;
        pos = 1;
      }
      block_len -= current_len;
      /* Set WR instruction */
      for (uint32_t i = 0; i < current_len; i++)
        buffer[pos++] = *src++;

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

/**
 * Customize this method to read data from a group of flash blocks into a buffer
 *
 * @param dst : reads the contents of those flash blocks into the address pointed to by
 * the dst parameter.
 * @param src : a pointer to a single flash.
 * @param length : data length
 *
 *  @return: if this method returns an error,MUST RUTURN ERROR_READ,
 * Otherwise return 0.
 */
int flashRead(uint8_t* dst, uint32_t src, uint32_t length){
  uint8_t cmd = SF_CMD_READ;
  uint8_t dmlen =(cmd == COMMON_INS_READ) ?  0 : 1;
  uint8_t crmsk = (cmd == COMMON_INS_FARDD) ? 0x20 : 0;
  uint8_t buffer[7] = {0};
  int first = 1;

#ifdef CONFIG_LOG_NUMS	
	if (log_i <= CONFIG_LOG_NUMS - 3) {
		log_data[log_i++] = 2;
		log_data[log_i++] = (uint16_t)src;
		log_data[log_i++] = (uint16_t)length;
	}
#endif
  if (src >= sf_size)
	  return ERROR_READ;
  if (src + length > sf_size)
	  length = sf_size - src;

  reg32_write(SPI_CR, SPI_CR_SPIEN | SPI_CR_STOP);
  while (length) {
    uint32_t current_len = length > SPI_READ_LEN ? SPI_READ_LEN : length;
    length -= current_len;
    if (length) {
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
      buffer[2] = (uint8_t)(src >> 16);
      buffer[3] = (uint8_t)(src >> 8);
      buffer[4] = (uint8_t)(src);
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
        *dst++ = ((dw >> (8 * i)) & 0xFF);
      }
    }
  }
  reg32_write(SPI_CR, SPI_CR_SPIEN | SPI_CR_STOP);
  return 0;
}

/**
 * Customize this method to erase a group of flash blocks.
 *
 * @param dst : a pointer to the base of the flash device.
 * NOTE: dst will always be sector aligned, the sector size is stored in FlashDev.c#FlashDevices#Devs#PageSize
 * @param length : erase length
 * NOTE: length will always be sector aligned, the sector size is stored in FlashDev.c#FlashDevices#Devs#PageSize
 *
 * @return : if this method returns an error,MUST RUTURN ERROR_ERASE,
 * Otherwise return 0
 */
int flashErase(uint32_t dst, uint32_t length){
#ifdef CONFIG_LOG_NUMS	
	if (log_i <= CONFIG_LOG_NUMS - 3) {
		log_data[log_i++] = 3;
		log_data[log_i++] = (uint16_t)dst;
		log_data[log_i++] = (uint16_t)length;
	}
#endif
  if (dst >= sf_size)
	  return ERROR_ERASE;
  if (dst + length > sf_size)
	  length = sf_size - dst;

  uint32_t start = dst & (SF_BLOCK_SIZE - 1);
  uint32_t end = (dst + length - 1) & (SF_BLOCK_SIZE - 1);
  while (start < end) {
	  block_erase(start);
	  start += SF_BLOCK_SIZE;
  }
  return 0;
}

/**
 * Customize this method to erase the whole flash.
 *
 * @return : if this method returns an error,MUST RUTURN ERROR_CHIPERASE,
 * Otherwise return 0.
 */
int flashChipErase( ){
  if (!sf_size)
	  return ERROR_CHIPERASE;

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
