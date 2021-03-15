OUTPUT = hello

XTOOLS = riscv64-unknown-elf-

X_GCC = $(XTOOLS)gcc
X_OBJCOPY = $(XTOOLS)objcopy
X_OBJDUMP = $(XTOOLS)objdump
X_NM = $(XTOOLS)nm
X_GDB = $(XTOOLS)gdb
X_READELF = $(XTOOLS)readelf

SRC = main.c

OBJ = $(patsubst %.c, %.o, $(SRC))
OBJ += crt0.o

# include paths
INCLUDE = ../../include

# defines
DEFINE =

# compiler flags
X_CFLAGS = -mabi=ilp32e -march=rv32ecxtheadse -mtune=e902 -mccrt
# X_CFLAGS += -Wall -Wstrict-prototypes -Werror -O0 -g -v
X_CFLAGS += -Wall -O0 -g -v

# linker flags
LDSCRIPT = xbr820.ld
X_LDFLAGS = -T$(LDSCRIPT) -Wl,-Map,$(OUTPUT).map -Wl,--gc-sections -nostdlib

.S.o:
	$(X_GCC) $(INCLUDE) $(DEFINE) $(X_CFLAGS) -c $< -o $@
.c.o:
	$(X_GCC) $(INCLUDE) $(DEFINE) $(X_CFLAGS) -c $< -o $@

.PHONY: all clean debug qemu

all: $(OBJ)
	$(X_GCC) $(X_CFLAGS) $(X_LDFLAGS) $(OBJ) -o $(OUTPUT).elf
	$(X_OBJCOPY) -O binary $(OUTPUT).elf $(OUTPUT).bin
	$(X_OBJDUMP) -h $(OUTPUT).elf
	$(X_OBJDUMP) -D -m riscv $(OUTPUT).elf > $(OUTPUT).dis
	$(X_OBJDUMP) -h -b binary -m riscv $(OUTPUT).bin
	$(X_NM) -A -g $(OUTPUT).elf > $(OUTPUT).map2
	$(X_NM) -A -g $(OBJ) > $(OUTPUT).map3
	$(X_READELF) -s $(OUTPUT).elf > $(OUTPUT).map4
	mv $(OUTPUT).bin ../../bin/$(OUTPUT).bin

clean:
	-rm $(OBJ)	
	-rm $(OUTPUT)
	
debug:
	$(X_GDB) $(OUTPUT).elf -ex "target remote localhost:1234"
	
qemu:
	qemu-system-riscv32 -machine smartl -cpu e902 -kernel $(OUTPUT).elf -nographic -gdb tcp::1234 -S
	
	
	