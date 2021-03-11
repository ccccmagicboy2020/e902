#ifndef __XBR820_H__
#define __XBR820_H__

typedef unsigned char		uint8_t;
typedef unsigned short		uint16_t;
typedef unsigned int			uint32_t;

typedef volatile uint8_t		reg8_t;
typedef volatile uint16_t	reg16_t;
typedef volatile uint32_t	reg32_t;

#define reg8_read(r)			(*(reg8_t *)(r))
#define reg8_write(r, v)		do { *(reg8_t *)(r) = (uint8_t)(v); } while(0)
#define reg16_read(r)		(*(reg16_t *)(r))
#define reg16_write(r, v)	do { *(reg16_t *)(r) = (uint16_t)(v); } while(0)
#define reg32_read(r)		(*(reg32_t *)(r))
#define reg32_write(r, v)	do { *(reg32_t *)(r) = (uint32_t)(v); } while(0)
#define reg32_set(r, m)		reg32_write(r, reg32_read(r) | (m))
#define reg32_clr(r, m)		reg32_write(r, reg32_read(r) & ~(m))

// Memory Map
#define SRAM_START		(0x40000)
#define SRAM_SIZE			(0x1000)

#endif // __XBR820_H__