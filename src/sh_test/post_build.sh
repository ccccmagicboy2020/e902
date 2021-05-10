#!/bin/sh

if [ $# -lt 2 ]; then
  echo Usage: $0 <ProjectPath> [ProjectName]
  exit 64
fi

ProjectPath=$1
ProjectOutputFile=$2
objpath=${ProjectPath}Obj/
prefix=${objpath}${ProjectOutputFile}
tmpbin=${prefix}_tmp.bin

if [ -f ${prefix}.elf ]; then
	riscv64-unknown-elf-objcopy -O binary -Sg ${prefix}.elf ${tmpbin}
	if [ $? -eq 0 -a -f ../boot/boot.bin -a -f ${tmpbin} ] ; then
		cat ../boot/boot.bin ${tmpbin} > ${prefix}.bin
		if [ $? -eq 0 ] ; then
			rm -f ${tmpbin}
			echo ROM file ${prefix}.bin merged OK.
		fi
	fi
	if [ -f ${tmpbin} ] ; then
		mv -f ${tmpbin} ${prefix}.bin
	fi
else
  echo ${prefix}.elf not found
fi
