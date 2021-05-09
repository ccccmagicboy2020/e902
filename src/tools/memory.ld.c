#include <memory_ld.h>
MEMORY
{
  ROM : 
/*************************************************************
// <o> ROM Start Address (in Bytes) <0x0-0xFFFFFFFF:0x100>
// <i> config start address of (text, rodata) area for this application
*************************************************************/
  ORIGIN = 0x0 , 
/*************************************************************
// <o> Memory Length (in Bytes) <0x0-0xFFFFFFFF:0x1>
// <i> config the length of (text, rodata) area for this application
*************************************************************/
  LENGTH = 0x20000
  
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
