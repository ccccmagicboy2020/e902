/*
 * Copyright (C) 2020 C-SKY Microsystems Co., Ltd. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*******************************************************************************
* Filename: link.h
*******************************************************************************/

#ifndef __LINK_H__
#define __LINK_H__
//#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/*------ Link return error code ------*/
enum LINK_ERROR {
	LINK_ERROR_NONE = 0,               ///< No error
	LINK_ERROR_NO_DEVICE = 0x80000001, ///< No device
	LINK_ERROR_IO = 0x80000002,        ///< Error IO
	LINK_ERROR_UNSUPPORT = 0x80000003, ///< Unsupport

	LINK_ERROR_UNKNOWN = 0x80000fff,   ///< Unknown error
};

/*----- Config key type -----*/
enum LINK_CONFIG_KEY
{
	LINK_CONFIG_CLK = 0,         ///< Set the jtag clock

	LINK_CONFIG_DDC,             ///< Enable DDC
#define LINK_CONFIG_DCC_VALUE_ENABLE     1
#define LINK_CONFIG_DCC_VALUE_DISABLE    0

	LINK_CONFIG_MTCR_DELAY,      ///< Unused

	LINK_CONFIG_CDI,             ///< Set SWD or JTAG
#define LINK_CONFIG_CDI_VALUE_JTAG       0
#define LINK_CONFIG_CDI_VALUE_SWD        1

	LINK_CONFIG_TRESET,          ///< Do Treset

	LINK_CONFIG_ISA_VER,         ///< Set ISA Version, 2,3: CSKY 8xx; 4: RV32; 5:RV64

	LINK_CONFIG_HACR_LENGTH,     ///< Set HACR(IR) length in bits
#define LINK_CONFIG_HACR_LENGTH_VALUE_8  8
#define LINK_CONFIG_HACR_LENGTH_VALUE_16 16

	LINK_CONFIG_CPU_SEL,         ///< select CPU

	LINK_CONFIG_DM,              ///< For RISCV DM, Unused
};


/*------ Memory Access Mode -------*/
enum MEMORY_ACC_MODE {
	M_BYTE = 1,                 ///< Access memory via byte
	M_HWORD = 2,                ///< Access memory via half-word
	M_WORD = 4,                 ///< Access memory via word
	M_DWORD = 6,                ///< Access memory via double word
};


#if 0

/**
\brief        Initilize
\param[in]    cfg
\return       zero for success, negative for error
*/
int  link_init (dbg_server_cfg_t *cfg);

/**
\brief        open the link
\param[in]    cfg, configuations
\param[in]    unique, a unique string, such as serial num
\return       a handle for the link which is open
*/
void* link_open (dbg_server_cfg_t *cfg, void *unique);

/**
\brief        close the link
\param[in]    handle, the return value of link_open
\return       zero for success, negative for error
*/
void link_close (void *handle);

/**
\brief        Config the links
\param[in]    handle, the return value of link_open
\param[in]    key, the config key
\param[in]    value, the config value
\return       zero for success, negative for error
*/
int  link_config (void *handle,  enum LINK_CONFIG_KEY key, unsigned int value);

/**
\brief        Upgrade the firmware of the link
\param[in]    handle, the return value of link_open
\param[in]    path, the path of the program
\return       zero for success, negative for error
*/
int  link_upgrade (void *handle, const char *path);

/**
\brief        Read memory from the target
\param[in]    handle, the return value of link_open
\param[in]    addr, the base address of memory
\param[in]    xlen, 32 or 64
\param[out]   buff, a point which is used to save the memory value
\param[in]    length, the length of the memory which need to be read
\param[in]    mode, byte/half word/word/double word
\return       zero for success, negative for error
*/
int  link_memory_read (void *handle, uint64_t addr, int xlen, uint8_t *buff, int length, int mode);

/**
\brief        Write memory to the target
\param[in]    handle, the return value of link_open
\param[in]    addr, the base address of memory
\param[in]    xlen, 32 or 64
\param[in]    buff, a point which is used to save the memory value
\param[in]    length, the length of the memory which need to be read
\param[in]    mode, byte/half word/word/double word
\return       zero for success, negative for error
*/
int  link_memory_write (void *handle, uint64_t addr, int xlen, uint8_t *buff, int length, int mode);

/**
\brief        Read register to the target
\param[in]    handle, the return value of link_open
\param[in]    regno, the number of register
\param[in]    buff, a point which is used to save the value of the register
\param[in]    nbyte, the length of register in byte
\return       zero for success, negative for error
*/
int  link_register_read (void *handle, int regno, uint8_t *buff, int nbyte);

/**
\brief        Write register to the target
\param[in]    handle, the return value of link_open
\param[in]    regno, the number of register
\param[in]    buff, a point which is used to save the value of the register
\param[in]    nbyte, the length of register in byte
\return       zero for success, negative for error
*/
int  link_register_write (void *, int regno, uint8_t *buff, int nbyte);

/**
\brief        Do a JTAG transfer.
              NOTICE: if read is true, should save the DR output to dr_r.
\param[in]    handle, the return value of link_open
\param[in]    ir_len, the length of IR in bytes
\param[in]    ir, the value of IR
\param[in]    dr_len, the length of DR in bytes
\param[in]    dr_r, the DR output
\param[in]    dr_w, the DR input 
\param[in]    read, a flag indicats need read or not.
\return       zero for success, negative for error
*/
int  link_jtag_operator (void *handle, int ir_len, unsigned char *ir,
                      int dr_len, unsigned char *dr_r, unsigned char *dr_w, int read);

/**
\brief        Do a GPIO transfer.
\param[in]    handle, the return value of link_open
\param[in]    gpio_out, the output value of GPIO
\param[in]    gpio_in, save the GPIO value
\param[in]    gpio_oe, GPIO output enable
\param[in]    gpio_mode, the gpio mode
\return       zero for success, negative for error
*/
int  link_gpio_operator (void *, int gpio_out, int *gpio_in, int gpio_eo, int gpio_mode);

/**
\brief        Show some infomations about link via func
\param[in]    handle, the return value of link_open
\param[in]    cfg, the configurations
\param[in]    func, an output channel
\return       zero for success, negative for error
*/
int  link_show_info (void *, dbg_server_cfg_t *cfg, void (*func)(const char *, ...));

/**
\brief        Reset the target
\param[in]    handle, the return value of link_open
\param[in]    hard, hard reset(nreset) or not
\return       zero for success, negative for error
*/
int  link_reset (void *handle, int hard);

/**
\brief        Get the link device list
\param[in]    handle, the return value of link_open
\param[in]    hard, hard reset(nreset) or not
\return       zero for success, negative for error
*/
int  link_get_device_list (struct link_dev *dev, int *count);

/**
\brief        Get the name of link. It is a special function which indicates
              that the dll is supported to DebugServer.
\return       The name of link.
*/
const char * THE_NAME_OF_LINK (void);

#endif


#ifdef __cplusplus
}
#endif

#endif
