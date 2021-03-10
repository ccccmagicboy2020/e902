MEMORY
{
  rom : ORIGIN = 0x00000000, LENGTH = 4M
  ram : ORIGIN = 0x00400000, LENGTH = 4K
}

PROVIDE(_ram_start = ORIGIN(ram));
PROVIDE(_ram_end = ORIGIN(ram) + LENGTH(ram));
PROVIDE(__stack_top = ORIGIN(ram) + LENGTH(ram));

OUTPUT_ARCH( "riscv" )
OUTPUT_FORMAT("elf32-littleriscv", "elf32-littleriscv", "elf32-littleriscv")

ENTRY(_start)

SECTIONS
{
  .text :
  {
    KEEP(*(.text.start))
    *(.text .text.*)
    . = ALIGN(8);
    PROVIDE(_etext = ABSOLUTE(.));
  } >rom

  .rodata :
  {
    *(.rodata .rodata.*)
  } >rom

  .data :
  {
    *(.data .data.*)
    . = ALIGN(8);
    PROVIDE(_edata = ABSOLUTE(.));
  } >ram

  .bss :
  {
    PROVIDE(_bss = ABSOLUTE(.));
    *(.bss .bss.*)
    *(COMMON)
    . = ALIGN(8);
    PROVIDE(_ebss = ABSOLUTE(.));
  } >ram


  . = ALIGN(64);
  PROVIDE(_end = ABSOLUTE(.));

}
