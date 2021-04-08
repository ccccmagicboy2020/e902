#ifndef __TYPDEF_H__
#define __TYPDEF_H__

#include <stdint.h>
#include <stdbool.h>
#include <config.h>

/* IO definitions (access restrictions to peripheral registers) */
/**
    \defgroup CSI_glob_defs CSI Global Defines

    <strong>IO Type Qualifiers</strong> are used
    \li to specify the access to peripheral variables.
    \li for automatic generation of peripheral register debug information.
*/
#ifdef __cplusplus
#define     __I      volatile             /*!< Defines 'read only' permissions */
#else
#define     __I      volatile const       /*!< Defines 'read only' permissions */
#endif
#define     __O      volatile             /*!< Defines 'write only' permissions */
#define     __IO     volatile             /*!< Defines 'read / write' permissions */

/* following defines should be used for structure members */
#define     __IM     volatile const       /*! Defines 'read only' structure member permissions */
#define     __OM     volatile             /*! Defines 'write only' structure member permissions */
#define     __IOM    volatile             /*! Defines 'read / write' structure member permissions */


typedef __IO  uint32_t		ro32_t;
typedef __IOM uint32_t		rw32_t;
typedef rw32_t				reg32_t;

#define reg32_read(r)		(*(ro32_t *)(r))
#define reg32_write(r, v)	do { *(rw32_t *)(r) = (uint32_t)(v); } while(0)
#define reg32_set(r, m)		reg32_write(r, reg32_read(r) | (m))
#define reg32_clr(r, m)		reg32_write(r, reg32_read(r) & ~(m))

#endif // __TYPDEF_H__