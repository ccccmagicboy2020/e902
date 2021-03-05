cc = riscv64-unknown-elf-gcc
prom1 = hello
src1 = ./src/hello_world.c
flag1 = -march=rv32imac -mabi=ilp32 -mccrt
$(prom1): $(src1)
	$(cc) $(flag1) -o $(prom1) $(src1)
	mv hello ./bin
	qemu-riscv32 hello
	
#清除
.PHONY: clean	
clean:
	rm -rf ./$(prom1)
	rm -rf ./bin/$(prom1)
