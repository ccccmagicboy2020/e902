/*----------------------------------------------------------------------*/
/* Setup                                                                */
/*----------------------------------------------------------------------*/

/* The OUTPUT_ARCH command specifies the machine architecture where the
   argument is one of the names used in the BFD library. More
   specifically one of the entires in bfd/cpu-mips.c */

OUTPUT_ARCH( "riscv" )
/*************************************************************
// <m> Entry Point <2>
// <i> config start function for this application
*************************************************************/
ENTRY(Reset_Handler)

MEMORY
{
  MEM : 
/*************************************************************
// <o> Memory Start Address (in Bytes) <0x0-0xFFFFFFFF:0x100>
// <i> config start address of RAM area for this application
*************************************************************/
  ORIGIN = 0x01000000 , 
/*************************************************************
// <o> Memory Length (in Bytes) <0x0-0xFFFFFFFF:0x1>
// <i> config the length of RAM area for this application
*************************************************************/
  LENGTH = 0x1000
}

PROVIDE (__origin = ORIGIN(MEM));
PROVIDE (__length = LENGTH(MEM));

PROVIDE (__stack_top = (__origin + __length));

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/

SECTIONS
{

  /* text: test code section */

  .text : {
	  *(.text.init)
	  *(.text)
	  *(.vectors.code)
 } > MEM

  /* data segment */
  .data : {
	  KEEP(*startup.o(*.vectors*))
	  *(.data)
  } > MEM

  .sdata : {
    __global_pointer$ = . + 0x800;
    *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2) *(.srodata*)
    *(.sdata .sdata.* .gnu.linkonce.s.*)
  } > MEM

  /* bss segment */
  .sbss : {
	. = ALIGN(0x4) ;
	__bss_start__ = . ;
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.scommon)
  } > MEM
  .bss : {
	  *(.bss)
	  . = ALIGN(0x10) ;
	  __bss_end__ = .;
	  KEEP(*startup.o(.bss.app_stack))
	  KEEP(*vector.o(.bss.trap_stack))
  } > MEM

  /* End of uninitalized data segement */
  _end = .;
}

