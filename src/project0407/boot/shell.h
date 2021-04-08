#ifndef __MISC_H__
#define __MISC_H__

#include "typdef.h"

enum {
	EOK		 =  0,         ///< Operation completed successfully.
	ENOCMD	 = -1,         ///< Unspecified error: not a command.
	EFAULT	 = -2,         ///< Unspecified error: run-time error but no other error message fits.
	ETIMEOUT = -3,         ///< Operation not completed within the timeout period.
	ENORES	 = -4,         ///< Resource not available.
	EINVAL	 = -5,         ///< Parameter error.
	ENOMEM	 = -6,         ///< System is out of memory: it was impossible to allocate or reserve memory for the operation.
	EEXIT	 = INT32_MIN   ///< Operation Exit.
};

#define INVALID_ADDRESS		UINT32_MAX

uint32_t stoi(const char* s);
void dump(const void *buf, uint16_t count);
void sh_init(void);
int sh_loop(void);

#endif // __MISC_H__