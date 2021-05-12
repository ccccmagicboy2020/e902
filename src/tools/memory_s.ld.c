#include <memory_ld.h>
MEMORY
{
  RAM : 
/*************************************************************
// <o> RAM Start Address (in Bytes) <0x0-0xFFFFFFFF:0x100>
// <i> config start address of (bss, data) area for this application
*************************************************************/
  ORIGIN = XBR820_SRAM_BASE , 
/*************************************************************
// <o> Memory Length (in Bytes) <0x0-0xFFFFFFFF:0x1>
// <i> config the length of (text, rodata) area for this application
*************************************************************/
  LENGTH = XBR820_SRAM_SIZE
}
