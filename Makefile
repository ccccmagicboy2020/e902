cc = riscv64-unknown-elf-gcc
prom1 = hello_world
src1 = ../src/hello_world.c
     
$(prom1): $(src1)
	$(cc) -o $(prom1) $(src1)
	#rm -f hello_world.o
	mv hello_world ../bin
	
#清除
.PHONY: clean	
clean:
	cat hello_world.c
