#ifndef __XBR820_H__
#define __XBR820_H__

typedef unsigned char		uint8_t;
typedef unsigned short		uint16_t;
typedef unsigned int		uint32_t;

typedef volatile uint8_t	reg8_t;
typedef volatile uint16_t	reg16_t;
typedef volatile uint32_t	reg32_t;

#define reg8_read(r)		(*(reg8_t *)(r))
#define reg8_write(r, v)	do { *(reg8_t *)(r) = (uint8_t)(v); } while(0)
#define reg16_read(r)		(*(reg16_t *)(r))
#define reg16_write(r, v)	do { *(reg16_t *)(r) = (uint16_t)(v); } while(0)
#define reg32_read(r)		(*(reg32_t *)(r))
#define reg32_write(r, v)	do { *(reg32_t *)(r) = (uint32_t)(v); } while(0)
#define reg32_set(r, m)		reg32_write(r, reg32_read(r) | (m))
#define reg32_clr(r, m)		reg32_write(r, reg32_read(r) & ~(m))


typedef union byte_half_word{
	uint8_t  b[4];
	uint16_t h[2];
	uint32_t w;
} BHW_t;

typedef union byte_half{
	uint8_t  b[2];
	uint16_t h;
} BH_t;

#define  swap(x,y,t)     do {(t)=(x);(x)=(y);(y)=(t);} while(0)


#define XBR820_SPI_BASEADDR	(0)

#define SF_BLOCK_SIZE		(0x10000)

// Memory Map
#define SRAM_START			(0x40000)
#define SRAM_SIZE			(0x800)

#endif // __XBR820_H__