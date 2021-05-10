/*
// <<< Use Configuration Wizard in Context Menu >>>
*/

OUTPUT_ARCH( "riscv" )
/*
// <m> Entry Point <2>
// <i> config start function for this application
*/
ENTRY( Reset_Handler )

INCLUDE Obj\memory.ld

PROVIDE (__stack = ORIGIN(RAM) + LENGTH(RAM));

SECTIONS
{
    .text : {
		. = ALIGN(0x4) ;
		__stext = . ;
		*startup.o(.vectors)
		*startup.o(.text)
		*(.text)
		*(.text*)
		*(.text.*)
		. = ALIGN(0x10) ;
		__etext = . ;
    } > RAM

    .rodata : {
		. = ALIGN(0x4) ;
		__srodata = .;
		*(.rdata)
		*(.rdata*)
		*(.rdata.*)
		*(.rodata)
		*(.rodata*)
		*(.rodata.*)
		. = ALIGN(0x10) ;
		__erodata = .;
    } > RAM

    .data : {
		. = ALIGN(0x4) ;
		__sdata = . ;
		__data_start = . ;
		*(.data)
		*(.data*)
		*(.data.*)
		__global_pointer$ = .;
		*(.sdata) 
		*(.sdata.*)
		. = ALIGN(0x10) ; 
		__data_end__ = .;
		__edata = . ;
	} > RAM

    .bss : {
		. = ALIGN(0x4) ;
		__sbss = ALIGN(0x4) ;
		__bss_start__ = . ;
		*(.bss)
		*(.bss.*)
		*(COMMON)
		. = ALIGN(0x10) ;
		__bss_end__ = .;
		KEEP(*startup.o(.bss.app_stack))
		KEEP(*startup.o(.bss.trap_stack))
		__end = . ;
		end = . ;
	} > RAM
}
