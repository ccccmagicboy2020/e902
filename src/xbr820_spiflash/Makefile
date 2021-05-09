.PHONY: clean All Project_Title Project_PreBuild Project_Build

All: Project_Title Project_PreBuild Project_Build

Project_Title:
	@echo "----------Building project:[ xbr820_spiflash - BuildSet ]----------"

Project_PreBuild:
	@echo Executing Pre Build commands ...
	@export CDKPath="D:/C-Sky/CDK" CDK_VERSION="V2.6.6" ProjectPath="D:/cccc2020/CODE/e902/src/xbr820_spiflash" && riscv64-unknown-elf-gcc -I. -I ../tools -E -P ../tools/memory_s.ld.c -o memory.ld
	@echo Done

Project_Build:
	@make -r -f xbr820_spiflash.mk -j 8 -C  ./ 


clean:
	@echo "----------Cleaning project:[ xbr820_spiflash - BuildSet ]----------"

