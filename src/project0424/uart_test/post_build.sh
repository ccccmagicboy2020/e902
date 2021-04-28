#!/bin/sh

if [ -f Obj/uart_test.elf ]; then
	riscv64-unknown-elf-objcopy -O binary -Sg Obj/uart_test.elf Obj/_uart_test.bin
	if [ $? -eq 0 -a -f ../boot/boot.bin -a -f Obj/_uart_test.bin ] ; then
		cat ../boot/boot.bin Obj/_uart_test.bin > Obj/uart_test.bin
		if [ $? -eq 0 ] ; then
			rm -f Obj/_uart_test.bin
			echo ROM file Obj/uart_test.bin merged OK.
		fi
	fi
fi
