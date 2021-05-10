#ifndef __CONSOLE_H__
#define __CONSOLE_H__

#include "typdef.h"

#define CONSOLE_EOF	(-1)

#ifdef __cplusplus
extern "C" {
#endif

void console_init(void);
int getchar(void);
int putchar(int ch);
int puts(const char * str);
#ifdef CONFIG_PRINTF
int print(const char* format, ...);
int sprintf(char* buffer, const char* format, ...);
int snprintf(char* buffer, unsigned int count, const char* format, ...);
#else
int put_h8(uint8_t byte);
int put_h16(uint16_t word);
int put_h32(uint32_t dword);
#endif

#ifdef __cplusplus
}
#endif

#endif // __CONSOLE_H__