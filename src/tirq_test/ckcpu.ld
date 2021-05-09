/*
// <<< Use Configuration Wizard in Context Menu >>>
*/

OUTPUT_ARCH( "riscv" )
/*
// <m> Entry Point <2>
// <i> config start function for this application
*/
ENTRY( Reset_Handler )

INCLUDE memory.ld

PROVIDE (__stack = ORIGIN(RAM) + LENGTH(RAM));

REGION_ALIAS("REGION_TEXT",    ROM);
REGION_ALIAS("REGION_RODATA",  ROM);
REGION_ALIAS("REGION_DATA",    RAM);
REGION_ALIAS("REGION_BSS",     RAM);

SECTIONS
{
    .text : {
		. = ALIGN(0x4) ;
		__stext = . ;
		*crt0.o(.text.init)
		. = ALIGN(0x10) ;
		__etext = . ;
    } > REGION_TEXT

	.code : {
		. = ALIGN(0x4) ;
		__scode = . ;
		*crt0.o(.exp_table)
		*(.text)
		__ecode = .;
		__code_end__ = .;
		. = ALIGN(0x4) ;
	} > REGION_DATA AT > REGION_RODATA

	.rodata : {
		. = ALIGN(0x4) ;
		__srodata = .;
		*(.rdata)
		*(.rodata)
		. = ALIGN(0x4) ;
		__erodata = .;
		__rodata_end__ = .;
	} > REGION_DATA AT > REGION_RODATA

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
	} > REGION_DATA AT > REGION_RODATA

    .bss : {
		. = ALIGN(0x4) ;
		__sbss = ALIGN(0x4) ;
		__bss_start__ = . ;
		*(.bss)
		*(.bss.*)
		*(COMMON)
		. = ALIGN(0x10) ;
		__bss_end__ = .;
		KEEP(*crt0.o(.bss.app_stack))
		KEEP(*crt0.o(.bss.trap_stack))
		__end = . ;
		end = . ;
	} > REGION_BSS
}
