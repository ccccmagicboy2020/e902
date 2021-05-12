.PHONY: clean All Project_Title Project_PreBuild Project_Build

All: Project_Title Project_PreBuild Project_Build

Project_Title:
	@echo "----------Building project:[ uart1_tx - BuildSet ]----------"

Project_PreBuild:
	@echo Executing Pre Build commands ...
	@export CDKPath="D:/C-Sky/CDK" CDK_VERSION="V2.8.7" ProjectPath="D:/cccc2020/CODE/e902/src/uart1_tx/" && riscv64-unknown-elf-gcc -I. -I ../tools -E -P ../tools/memory.ld.c -o Obj/memory.ld
	@echo Done

Project_Build:
	@make -r -f uart1_tx.mk -j 8 -C  ./ 


clean:
	@echo "----------Cleaning project:[ uart1_tx - BuildSet ]----------"

