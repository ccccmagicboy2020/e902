#!/bin/sh

if [ $# -lt 2 ]; then
  echo Usage: $0 <ProjectPath> [ProjectName]
  exit 64
fi

ProjectPath=$1
ProjectOutputFile=$2
objpath=${ProjectPath}Obj/
prefix=${objpath}${ProjectOutputFile}
toolpath=${ProjectPath}../tools/
splitool=${toolpath}split.sh
if [ -x ${ProjectPath}post_build.sh ] ; then
	source ${ProjectPath}post_build.sh
fi
elf_file=${prefix}.elf
if [ -f $elf_file ] ; then
	bins_file=${prefix}*.bin
	rm -f $bins_file
	bin_file=${prefix}.bin
	riscv64-unknown-elf-objcopy -O binary -Sg $elf_file $bin_file
	cp -f ${toolpath}flash.init ${objpath}
	${splitool} ${prefix}
	cat ${prefix}.init >> ${objpath}flash.init
	echo -e "\n\nset *(int*)0x1f010058=0x10" >> ${objpath}flash.init
#	echo -e "\nquit\ny" >> ${objpath}flash.init
	rm -rf ${prefix}.init
fi
