/* The OUTPUT_ARCH command specifies the machine architecture where the
   argument is one of the names used in the BFD library. More
   specifically one of the entires in bfd/cpu-mips.c */

OUTPUT_ARCH( "riscv" )
/*************************************************************
// <m> Entry Point <2>
// <i> config start function for this application
*************************************************************/
ENTRY( Reset_Handler )

HIDDEN (RAM_ADDR = 0x01000000);
HIDDEN (RAM_SIZE = 0x1000);

MEMORY
{
  MEM : 
/*************************************************************
// <o> Memory Start Address (in Bytes) <0x0-0xFFFFFFFF:0x100>
// <i> config start address of RAM area for this application
*************************************************************/
  ORIGIN = RAM_ADDR , 
/*************************************************************
// <o> Memory Length (in Bytes) <0x0-0xFFFFFFFF:0x1>
// <i> config the length of RAM area for this application
*************************************************************/
  LENGTH = RAM_SIZE
}

PROVIDE (__origin = RAM_ADDR);
PROVIDE (__length = RAM_SIZE);

PROVIDE (__stack = (__origin + __length) & 0xfffffff8);

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/

SECTIONS
{
	.text : {
		. = ALIGN(0x4) ;
		__stext = . ;
		KEEP(*startup.o(*.vectors*))
		*(.vectors.code)
		*(.text)
		*(.text*)
		*(.text.*)
		. = ALIGN(0x10) ;
		__etext = . ;
	} > MEM

    .rodata : {
		. = ALIGN(0x4) ;
		__srodata = .;
		*(.rdata)
		*(.rdata*)
		*(.rdata1)
		*(.rdata.*)
		*(.rodata)
		*(.rodata1)
		*(.rodata*)
		*(.rodata.*)
		. = ALIGN(0x10) ;
		__erodata = .;
    } > MEM

    .data : {
		. = ALIGN(0x4) ;
		__sdata = . ;
		__data_start__ = . ;
		*(.data)
		*(.data*)
		*(.data1)
		*(.data.*)
		*(.data1)
		__global_pointer$ = .;
		*(.sdata) 
		*(.sdata.*)
		. = ALIGN(0x10) ; 
		__data_end__ = .;
		__edata = . ;
	} > MEM

    .bss : {
		. = ALIGN(0x4) ;
		__sbss = ALIGN(0x4) ;
		__bss_start__ = . ;
		*(.sbss)
		*(.sbss.*)
		*(.bss)
		*(.bss.*)
		. = ALIGN(0x10) ;
		__bss_end__ = .;
		KEEP(*startup.o(.bss.app_stack))
		KEEP(*vector.o(.bss.trap_stack))
		__end = . ;
		end = . ;
	} > MEM
}
