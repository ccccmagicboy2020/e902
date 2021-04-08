/* The OUTPUT_ARCH command specifies the machine architecture where the
   argument is one of the names used in the BFD library. More
   specifically one of the entires in bfd/cpu-mips.c */

OUTPUT_ARCH( "riscv" )
/*************************************************************
// <m> Entry Point <2>
// <i> config start function for this application
*************************************************************/
ENTRY( Reset_Handler )

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

PROVIDE (__origin = 0x01000000);
PROVIDE (__length = 0x1000);

PROVIDE (__stack = (0x01000000 + 0x1000) & 0xfffffff8);

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/

SECTIONS
{
	.text : {
		. = ALIGN(0x4) ;
		__stext = . ;
		*(.text.init)
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
		__data_start = . ;
		KEEP (*main.o(.data))
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
		KEEP(*startup.o(.app_stack))
		KEEP(*startup.o(.app_heap))
		__end = . ;
		end = . ;
	} > MEM
}
