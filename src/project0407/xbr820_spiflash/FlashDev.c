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
#include "FlashOS.h"
#include "flash_config.h"

/**
 * structure to describe flash device
 */
struct FlashDevice const FlashDevices  INDEVSECTION =  {
    6,                      // Reserved version description, do not modify!!!
    "xbr820_spiflash",      // Flash name
    "xbr820",               // CPU name, must in low case
    P25Q20_JEDEC_ID,        // Flash ID
    "NorFlash",             // type
    SF_CHIP_SIZE,               // Reserved
    1,                      // Access directly
    1,                      // RangeNumbers
	// {start address, the flash size, sector size}
    {{0x0, SF_CHIP_SIZE, SF_BLOCK_SIZE}}
};
