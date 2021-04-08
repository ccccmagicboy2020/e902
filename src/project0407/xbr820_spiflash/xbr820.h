#ifndef __XBR820_H__
#define __XBR820_H__

#include "typdef.h"

#define reg8_read(r)		(*(reg8_t *)(r))
#define reg8_write(r, v)	do { *(reg8_t *)(r) = (uint8_t)(v); } while(0)
#define reg16_read(r)		(*(reg16_t *)(r))
#define reg16_write(r, v)	do { *(reg16_t *)(r) = (uint16_t)(v); } while(0)
#define reg32_read(r)		(*(reg32_t *)(r))
#define reg32_write(r, v)	do { *(reg32_t *)(r) = (uint32_t)(v); } while(0)
#define reg32_set(r, m)		reg32_write(r, reg32_read(r) | (m))
#define reg32_clr(r, m)		reg32_write(r, reg32_read(r) & ~(m))

#define XBR820_SRAM_BASE    (0x01000000UL)
#define XBR820_SRAM_SIZE    (0x00001000UL)

#endif // __XBR820_H__