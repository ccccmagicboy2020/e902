#ifndef __SF_H__
#define __SF_H__
#include "xbr820.h"

extern uint32_t sf_size;
extern uint32_t sf_id;

extern int sf_init(void);
extern int sf_chip_erase(void);
extern int sf_block_erase(uint32_t offset);
extern int sf_write(uint32_t offset, const uint8_t *data, uint32_t len);
extern int sf_read(uint8_t *data, uint32_t offset, uint32_t len);
#ifdef SF_VERIFY
extern int sf_verify(uint32_t offset, const uint8_t *data, uint32_t len);
#endif // SF_VERIFY

#endif // __SF_H__