.PHONY: clean All Project_Title Project_PreBuild Project_Build Project_PostBuild

All: Project_Title Project_PreBuild Project_Build Project_PostBuild

Project_Title:
	@echo "----------Building project:[ sh_test - BuildSet ]----------"

Project_PreBuild:
	@echo Executing Pre Build commands ...
	@export CDKPath="D:/C-Sky/CDK" CDK_VERSION="V2.8.7" ProjectPath="D:/cccc2020/CODE/e902/src/sh_test/" && riscv64-unknown-elf-gcc -I. -I ../tools -E -P ../tools/memory_s.ld.c -o Obj/memory.ld
	@echo Done

Project_Build:
	@make -r -f sh_test.mk -j 8 -C  ./ 

Project_PostBuild:
	@echo Executing Post Build commands ...
	@export CDKPath="D:/C-Sky/CDK" CDK_VERSION="V2.8.7" ProjectPath="D:/cccc2020/CODE/e902/src/sh_test/" && D:/cccc2020/CODE/e902/src/sh_test/post_build.sh D:/cccc2020/CODE/e902/src/sh_test/ sh_test
	@echo Done


clean:
	@echo "----------Cleaning project:[ sh_test - BuildSet ]----------"

