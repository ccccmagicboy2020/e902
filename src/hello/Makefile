OUTPUT = hello

XTOOLS = riscv64-unknown-elf-

X_GCC = $(XTOOLS)gcc
X_OBJCOPY = $(XTOOLS)objcopy
X_OBJDUMP = $(XTOOLS)objdump

SRC = main.c

OBJ = $(patsubst %.c, %.o, $(SRC))
OBJ += crt0.o

# include paths
INCLUDE =

# defines
DEFINE =

# compiler flags
X_CFLAGS = -mabi=ilp32e -march=rv32ecxthead
# X_CFLAGS += -Wall -Wstrict-prototypes -Werror -O0 -g -v
X_CFLAGS += -Wall -Wstrict-prototypes -O0 -g -v

# linker flags
LDSCRIPT = xbr820.ld
X_LDFLAGS = -T$(LDSCRIPT) -Wl,-Map,$(OUTPUT).map -Wl,--gc-sections -nostdlib

.S.o:
	$(X_GCC) $(INCLUDE) $(DEFINE) $(X_CFLAGS) -c $< -o $@
.c.o:
	$(X_GCC) $(INCLUDE) $(DEFINE) $(X_CFLAGS) -c $< -o $@

.PHONY: all clean

all: $(OBJ)
	$(X_GCC) $(X_CFLAGS) $(X_LDFLAGS) $(OBJ) -o $(OUTPUT)
	$(X_OBJCOPY) -O binary $(OUTPUT) $(OUTPUT).bin
	$(X_OBJDUMP) -h $(OUTPUT)
	$(X_OBJDUMP) -D -m riscv $(OUTPUT) > $(OUTPUT).dis
	$(X_OBJDUMP) -h -b binary -m riscv $(OUTPUT).bin
	mv $(OUTPUT).bin ../../bin/$(OUTPUT).bin

clean:
	-rm $(OBJ)	
	-rm $(OUTPUT)
	-rm ../../bin/$(OUTPUT).bin
	