#include "xbr820.h"
#include "fifo.h"
#include <string.h>


#define min(a, b)  (((a) < (b)) ? (a) : (b))

/**
  * \brief  Removes the entire FIFO contents.
  * \param  [in] fifo: The fifo to be emptied.
  * \return None.
  */
void fifo_reset(fifo_t *fifo)
{
    fifo->write = fifo->read = 0;
    fifo->len = 0;
}

/**
  * \brief  Puts some data into the FIFO.
  * \param  [in] fifo: The fifo to be used.
  * \param  [in] in:   The data to be added.
  * \param  [in] len:  The length of the data to be added.
  * \return The number of bytes copied.
  * \note   This function copies at most @len bytes from the @in into
  *         the FIFO depending on the free space, and returns the number
  *         of bytes copied.
  */
FIFO_SIZE_t fifo_write(fifo_t *fifo, const void *datptr, FIFO_SIZE_t len)
{
    FIFO_SIZE_t writelen = 0, tmplen = 0;

    if(fifo_is_full(fifo))
        return 0;

    tmplen = fifo_avail(fifo);
    writelen = tmplen > len ? len : tmplen;

    if(fifo->write < fifo->read) {
        memcpy((void*)&fifo->buffer[fifo->write], (void*)datptr, writelen);
    } else {
        tmplen = fifo_size(fifo) - fifo->write;
        if(writelen <= tmplen) {
            memcpy((void*)&fifo->buffer[fifo->write], (void*)datptr, writelen);
        } else {
            memcpy((void*)&fifo->buffer[fifo->write], (void*)datptr, tmplen);
            memcpy((void*)fifo->buffer, (const uint8_t*)datptr + tmplen, writelen - tmplen);
        }
    }

	tmplen = fifo->write + writelen;
    fifo->write = tmplen > fifo_size(fifo) ? tmplen - fifo_size(fifo) : tmplen;
    fifo->len += writelen;

    return writelen;
}

/**
  * \brief  Gets some data from the FIFO.
  * \param  [in] fifo: The fifo to be used.
  * \param  [in] out:  Where the data must be copied.
  * \param  [in] len:  The size of the destination buffer.
  * \return The number of copied bytes.
  * \note   This function copies at most @len bytes from the FIFO into
  *         the @out and returns the number of copied bytes.
  */
FIFO_SIZE_t fifo_read(fifo_t *fifo, void *outbuf, FIFO_SIZE_t len)
{
    FIFO_SIZE_t readlen = 0, tmplen = 0;
    if(fifo_is_empty(fifo))
        return 0;

    readlen = len > fifo->len ? fifo->len : len;
    tmplen = fifo_size(fifo) - fifo->read;

    if(NULL != outbuf) {
        if(readlen <= tmplen) {
            memcpy((void*)outbuf, (void*)&fifo->buffer[fifo->read], readlen);
        } else {
            memcpy((void*)outbuf,(void*)&fifo->buffer[fifo->read], tmplen);
            memcpy((uint8_t*)outbuf + tmplen,(void*)fifo->buffer,readlen - tmplen);
        }
    }

	tmplen = fifo->read + readlen;
    fifo->read = tmplen > fifo_size(fifo) ? tmplen - fifo_size(fifo) : tmplen;
    fifo->len -= readlen;

    return readlen;
}

