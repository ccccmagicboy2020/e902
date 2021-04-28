/*************************************************************
// <m> Entry Point <2>
// <i> config start function for this application
*************************************************************/
ENTRY( Reset_Handler )

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
  LENGTH = 0x40000
  
  RAM : 
/*************************************************************
// <o> RAM Start Address (in Bytes) <0x0-0xFFFFFFFF:0x100>
// <i> config start address of (bss, data) area for this application
*************************************************************/
  ORIGIN = 0x01000000 , 
/*************************************************************
// <o> Memory Length (in Bytes) <0x0-0xFFFFFFFF:0x1>
// <i> config the length of (text, rodata) area for this application
*************************************************************/
  LENGTH = 0x1000
}

__stack_top = ORIGIN(RAM) + LENGTH(RAM);

REGION_ALIAS("REGION_TEXT",    ROM);
REGION_ALIAS("REGION_RODATA",  ROM);
REGION_ALIAS("REGION_DATA",    RAM);
REGION_ALIAS("REGION_BSS",     RAM);

ENTRY(Reset_Handler)
SECTIONS
{
 .text : {
  . = ALIGN(0x4) ;
  __stext = . ;
  KEEP(*startup.o(*.text*))
  *(.text)
  . = ALIGN(0x10) ;
  __etext = . ;
 } > REGION_TEXT
 .rodata : {
  . = ALIGN(0x4) ;
  __srodata = .;
  *(.rodata)
  __erodata = .;
 } > REGION_RODATA
 .data : {
  . = ALIGN(0x4) ;
  __sdata = . ;
  __data_start__ = . ;
  *(.data)
  __global_pointer$ = .;
  . = ALIGN(0x4) ;
  __data_end__ = .;
  __edata = .;
 } > REGION_DATA AT > REGION_RODATA
 .bss : {
  . = ALIGN(0x4) ;
  __sbss = ALIGN(0x4) ;
  __bss_start__ = . ;
  *(.bss)
   __ebss = . ;
  __bss_end__ = .;
  __end = . ;
  end = . ;
 } > REGION_BSS AT > REGION_BSS
}
