#ifndef __TYPDEF_H__
#define __TYPDEF_H__

typedef unsigned char		uint8_t;
typedef unsigned short		uint16_t;
typedef unsigned int		uint32_t;

typedef volatile uint8_t	reg8_t;
typedef volatile uint16_t	reg16_t;
typedef volatile uint32_t	reg32_t;

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

#endif // __TYPDEF_H__
