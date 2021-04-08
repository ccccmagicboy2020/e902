#ifndef __FIFO_H__
#define __FIFO_H__

#include "typdef.h"

#ifndef FIFO_SIZE_t
 #define FIFO_SIZE_t	uint16_t
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef struct fifo {
    FIFO_SIZE_t size;
    FIFO_SIZE_t write;
    FIFO_SIZE_t read;
    FIFO_SIZE_t len;
	uint8_t* buffer;
} fifo_t;

#define fifo_init(fifo, size)	\
	do {						\
		(fifo)->size = size;	\
		fifo_reset(fifo);		\
	} while (0)
#define fifo_size(fifo)		((fifo)->size)
#define fifo_len(fifo)		((fifo)->len)
#define fifo_avail(fifo)	(fifo_size(fifo) - fifo_len(fifo))
#define fifo_is_empty(fifo)	(fifo_len(fifo) == 0)
#define fifo_is_full(fifo)	(fifo_avail(fifo) == 0)
#define fifo_putc(fifo, c)	fifo_write(fifo, &(c), 1)
#define fifo_getc(fifo, c)	fifo_read(fifo, &(c), 1)

void fifo_reset(fifo_t *fifo);

/*write to fifo*/
FIFO_SIZE_t fifo_write(fifo_t *fifo, const void *in, FIFO_SIZE_t len);

/*read to fifo*/
FIFO_SIZE_t fifo_read(fifo_t *fifo, void *out, FIFO_SIZE_t len);

#ifdef __cplusplus
}
#endif

#endif // __FIFO_H__


