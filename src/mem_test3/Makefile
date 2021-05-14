
NAME   = mem_test
CDIR   = .
BUILDDIR= $(CDIR)/out
OBJDIR = $(BUILDDIR)/obj
MAKEDIR = $(shell pwd)

CFLAGS += -g2
CFLAGS += -O3 -funroll-all-loops -fgcse-sm -finline-limit=500 -fno-schedule-insns

LINKFILE = $(NAME).ld

CC      = riscv64-unknown-elf-gcc
LD      = riscv64-unknown-elf-ld
AR      = riscv64-unknown-elf-ar
AS      = riscv64-unknown-elf-as
OBJDUMP = riscv64-unknown-elf-objdump
OBJCOPY = riscv64-unknown-elf-objcopy
RM      = rm

INCLUDEDIRS = -l.

CFLAGS += $(INCLUDEDIRS)
CFLAGS += -c -g -ffunction-sections -fdata-sections -Wall
CFLAGS += -march=rv32ecxthead -mabi=ilp32e
LDFLAGS += -march=rv32ecxthead -mabi=ilp32e

ifeq ($(V), 1)
Q =
else
Q = @
endif

all: $(NAME).elf hexfile

OBJECTS := $(patsubst %.c,%.o,$(wildcard *.c)) $(patsubst %.S,%.o,$(wildcard *.S))

%.o:%.c
	@echo CC ${shell echo $<|awk -F '/' '{print $$NF}'}
	$(Q)$(CC)  $(CFLAGS) -o $@  $<

%.o:%.S
	@echo AS ${shell echo $<|awk -F '/' '{print $$NF}'}
	$(Q)$(CC)  $(CFLAGS) -o $@  $<

build_dir:
	@mkdir -p $(BUILDDIR)
	@mkdir -p $(OBJDIR)

$(NAME).elf: build_dir $(OBJECTS) $(LINKFILE)
	@echo LINK $@
	$(Q)$(CC) $(LDFLAGS) \
	-nostartfiles -o $(BUILDDIR)/$(NAME).elf \
	-Wl,--whole-archive $(OBJECTS) -Wl,--no-whole-archive \
	-Wl,-T$(LINKFILE) \
	-Wl,-Map,$(BUILDDIR)/$(NAME).map \
	-lm -lc -lgcc -Wl,-gc-sections -Wl,-zmax-page-size=1024
	@-mv $(OBJECTS) $(OBJDIR)
	$(Q)$(OBJDUMP) -S $(BUILDDIR)/$(NAME).elf > $(BUILDDIR)/$(NAME).dis

hexfile:
	@$(OBJCOPY)  -O ihex $(BUILDDIR)/$(NAME).elf $(BUILDDIR)/$(NAME).hex
	@$(OBJCOPY)  -O binary -S -g $(BUILDDIR)/$(NAME).elf $(BUILDDIR)/$(NAME).bin

clean:
	@$(RM) -rf $(BUILDDIR)
