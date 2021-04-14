/*
// <<< Use Configuration Wizard in Context Menu >>>
*/

/*
// <m> Entry Point <2>
// <i> config start function for this application
*/
ENTRY( Reset_Handler )

MEMORY
{
  MEM : 
/*
// <o> Memory Start Address (in Bytes) <0x0-0xFFFFFFFF:0x100>
// <i> config start address of RAM area for this application
*/
  ORIGIN = 0x01000000 , 
/*
// <o> Memory Length (in Bytes) <0x0-0xFFFFFFFF:0x1>
// <i> config the length of RAM area for this application
*/
  LENGTH = 0x1000
}

__stack_top = ORIGIN(MEM) + LENGTH(MEM);

SECTIONS
{
    .text : {
		. = ALIGN(0x4) ;
		*crt0.o(.text)
		__stext = . ;
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
		*(.rdata.*)
		*(.rodata)
		*(.rodata*)
		*(.rodata.*)
		. = ALIGN(0x10) ;
		__erodata = .;
    } > MEM

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
	} > MEM

    .bss : {
		. = ALIGN(0x4) ;
		__sbss = ALIGN(0x4) ;
		__bss_start__ = . ;
		*(.bss)
		*(.bss.*)
		*(COMMON)
		. = ALIGN(0x10) ;
		__bss_end__ = .;
		__end = . ;
		end = . ;
	} > MEM
}
