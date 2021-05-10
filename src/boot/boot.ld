/*************************************************************
// <m> Entry Point <2>
// <i> config start function for this application
*************************************************************/
ENTRY( Reset_Handler )

INCLUDE memory.ld

SECTIONS
{
 .text : {
  . = ALIGN(0x4) ;
  __stext = . ;
  KEEP(*startup.o(*.text*))
  *(.text)
  __etext = . ;
 } > ROM
 .rodata : {
  . = ALIGN(0x4) ;
  __srodata = .;
  *(.rodata)
  . = ALIGN(0x10) ;
  __erodata = .;
 } > ROM
}
