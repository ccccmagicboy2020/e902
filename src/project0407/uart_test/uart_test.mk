##
## Auto Generated makefile by CDK
## Do not modify this file, and any manual changes will be erased!!!   
##
## BuildSet
ProjectName            :=uart_test
ConfigurationName      :=BuildSet
WorkspacePath          :=../
ProjectPath            :=./
IntermediateDirectory  :=Obj
OutDir                 :=$(IntermediateDirectory)
User                   :=DELL
Date                   :=07/04/2021
CDKPath                :=../../../C-Sky/CDK/
LinkerName             :=riscv64-unknown-elf-gcc
LinkerNameoption       :=
SIZE                   :=riscv64-unknown-elf-size
READELF                :=riscv64-unknown-elf-readelf
CHECKSUM               :=crc32
SharedObjectLinkerName :=
ObjectSuffix           :=.o
DependSuffix           :=.d
PreprocessSuffix       :=.i
DisassemSuffix         :=.asm
IHexSuffix             :=.ihex
BinSuffix              :=.bin
ExeSuffix              :=.elf
LibSuffix              :=.a
DebugSwitch            :=-g 
IncludeSwitch          :=-I
LibrarySwitch          :=-l
OutputSwitch           :=-o 
ElfInfoSwitch          :=-hlS
LibraryPathSwitch      :=-L
PreprocessorSwitch     :=-D
UnPreprocessorSwitch   :=-U
SourceSwitch           :=-c 
ObjdumpSwitch          :=-S
ObjcopySwitch          :=-O ihex
ObjcopyBinSwitch       :=-O binary
OutputFile             :=$(ProjectName)
ObjectSwitch           :=-o 
ArchiveOutputSwitch    := 
PreprocessOnlySwitch   :=-E
ObjectsFileList        :=uart_test.txt
MakeDirCommand         :=mkdir
LinkOptions            := -mabi=ilp32e -march=rv32ecxthead  -nostartfiles -Wl,--gc-sections -T$(ProjectPath)/uart_test.ld
LinkOtherFlagsOption   :=
IncludePackagePath     :=
IncludeCPath           :=$(IncludeSwitch). $(IncludeSwitch)../../../C-Sky/CDK/CSKY/csi/csi_core/include/ $(IncludeSwitch)../../../C-Sky/CDK/CSKY/csi/csi_core/csi_cdk/ $(IncludeSwitch)../../../C-Sky/CDK/CSKY/csi/csi_driver/include/ $(IncludeSwitch). $(IncludeSwitch)../boot 
IncludeAPath           :=$(IncludeSwitch). $(IncludeSwitch)../../../C-Sky/CDK/CSKY/csi/csi_core/include/ $(IncludeSwitch)../../../C-Sky/CDK/CSKY/csi/csi_core/csi_cdk/ $(IncludeSwitch)../../../C-Sky/CDK/CSKY/csi/csi_driver/include/ $(IncludeSwitch). 
Libs                   := -Wl,--whole-archive  -Wl,--no-whole-archive  
ArLibs                 := 
PackagesLibPath        :=
LibPath                := $(PackagesLibPath) 

##
## Common variables
## AR, CXX, CC, AS, CXXFLAGS and CFLAGS can be overriden using an environment variables
##
AR       :=riscv64-unknown-elf-ar rcu
CXX      :=riscv64-unknown-elf-g++
CC       :=riscv64-unknown-elf-gcc
AS       :=riscv64-unknown-elf-gcc
OBJDUMP  :=riscv64-unknown-elf-objdump
OBJCOPY  :=riscv64-unknown-elf-objcopy
CXXFLAGS := -mabi=ilp32e -march=rv32ecxthead    -Og  -g3  -Wall  
CFLAGS   := -mabi=ilp32e -march=rv32ecxthead    -Og  -g3  -Wall  
ASFLAGS  := -mabi=ilp32e -march=rv32ecxthead    -Wa,--gdwarf2    


Objects0=$(IntermediateDirectory)/startup$(ObjectSuffix) $(IntermediateDirectory)/main$(ObjectSuffix) $(IntermediateDirectory)/boot_fifo$(ObjectSuffix) $(IntermediateDirectory)/boot_stc$(ObjectSuffix) $(IntermediateDirectory)/boot_uart$(ObjectSuffix) $(IntermediateDirectory)/boot_system$(ObjectSuffix) $(IntermediateDirectory)/boot_board_init$(ObjectSuffix) $(IntermediateDirectory)/boot_console$(ObjectSuffix) $(IntermediateDirectory)/boot_shell$(ObjectSuffix) 



Objects=$(Objects0) 

##
## Main Build Targets 
##
.PHONY: all
all: $(IntermediateDirectory)/$(OutputFile)

$(IntermediateDirectory)/$(OutputFile):  $(Objects) Always_Link 
	$(LinkerName) $(OutputSwitch) $(IntermediateDirectory)/$(OutputFile)$(ExeSuffix) $(LinkerNameoption) $(LinkOtherFlagsOption)  -Wl,-Map=$(ProjectPath)/Lst/$(OutputFile).map  @$(ObjectsFileList)  $(LinkOptions) $(LibPath) $(Libs)
	@mv $(ProjectPath)/Lst/$(OutputFile).map $(ProjectPath)/Lst/$(OutputFile).temp && $(READELF) $(ElfInfoSwitch) $(ProjectPath)/Obj/$(OutputFile)$(ExeSuffix) > $(ProjectPath)/Lst/$(OutputFile).map && echo ====================================================================== >> $(ProjectPath)/Lst/$(OutputFile).map && cat $(ProjectPath)/Lst/$(OutputFile).temp >> $(ProjectPath)/Lst/$(OutputFile).map && rm -rf $(ProjectPath)/Lst/$(OutputFile).temp
	$(OBJCOPY) $(ObjcopySwitch) $(ProjectPath)/$(IntermediateDirectory)/$(OutputFile)$(ExeSuffix)  $(ProjectPath)/Obj/$(OutputFile)$(IHexSuffix) 
		$(OBJDUMP) $(ObjdumpSwitch) $(ProjectPath)/$(IntermediateDirectory)/$(OutputFile)$(ExeSuffix)  > $(ProjectPath)/Lst/$(OutputFile)$(DisassemSuffix) 
	@echo size of target:
	@$(SIZE) $(ProjectPath)$(IntermediateDirectory)/$(OutputFile)$(ExeSuffix) 
	@echo -n checksum value of target:  
	@$(CHECKSUM) $(ProjectPath)/$(IntermediateDirectory)/$(OutputFile)$(ExeSuffix) 
	
Always_Link:


##
## Objects
##
$(IntermediateDirectory)/startup$(ObjectSuffix): startup.S  
	$(AS) $(SourceSwitch) startup.S $(ASFLAGS) -MMD -MP -MT$(IntermediateDirectory)/startup$(ObjectSuffix) -MF$(IntermediateDirectory)/startup$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/startup$(ObjectSuffix) $(IncludeAPath) $(IncludePackagePath)
Lst/startup$(PreprocessSuffix): startup.S
	$(CC) $(CFLAGS)$(IncludeAPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/startup$(PreprocessSuffix) startup.S

$(IntermediateDirectory)/main$(ObjectSuffix): main.c  
	$(CC) $(SourceSwitch) main.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/main$(ObjectSuffix) -MF$(IntermediateDirectory)/main$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/main$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/main$(PreprocessSuffix): main.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/main$(PreprocessSuffix) main.c

$(IntermediateDirectory)/boot_fifo$(ObjectSuffix): ../boot/fifo.c  
	$(CC) $(SourceSwitch) ../boot/fifo.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/boot_fifo$(ObjectSuffix) -MF$(IntermediateDirectory)/boot_fifo$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/boot_fifo$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/boot_fifo$(PreprocessSuffix): ../boot/fifo.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/boot_fifo$(PreprocessSuffix) ../boot/fifo.c

$(IntermediateDirectory)/boot_stc$(ObjectSuffix): ../boot/stc.c  
	$(CC) $(SourceSwitch) ../boot/stc.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/boot_stc$(ObjectSuffix) -MF$(IntermediateDirectory)/boot_stc$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/boot_stc$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/boot_stc$(PreprocessSuffix): ../boot/stc.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/boot_stc$(PreprocessSuffix) ../boot/stc.c

$(IntermediateDirectory)/boot_uart$(ObjectSuffix): ../boot/uart.c  
	$(CC) $(SourceSwitch) ../boot/uart.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/boot_uart$(ObjectSuffix) -MF$(IntermediateDirectory)/boot_uart$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/boot_uart$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/boot_uart$(PreprocessSuffix): ../boot/uart.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/boot_uart$(PreprocessSuffix) ../boot/uart.c

$(IntermediateDirectory)/boot_system$(ObjectSuffix): ../boot/system.c  
	$(CC) $(SourceSwitch) ../boot/system.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/boot_system$(ObjectSuffix) -MF$(IntermediateDirectory)/boot_system$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/boot_system$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/boot_system$(PreprocessSuffix): ../boot/system.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/boot_system$(PreprocessSuffix) ../boot/system.c

$(IntermediateDirectory)/boot_board_init$(ObjectSuffix): ../boot/board_init.c  
	$(CC) $(SourceSwitch) ../boot/board_init.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/boot_board_init$(ObjectSuffix) -MF$(IntermediateDirectory)/boot_board_init$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/boot_board_init$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/boot_board_init$(PreprocessSuffix): ../boot/board_init.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/boot_board_init$(PreprocessSuffix) ../boot/board_init.c

$(IntermediateDirectory)/boot_console$(ObjectSuffix): ../boot/console.c  
	$(CC) $(SourceSwitch) ../boot/console.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/boot_console$(ObjectSuffix) -MF$(IntermediateDirectory)/boot_console$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/boot_console$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/boot_console$(PreprocessSuffix): ../boot/console.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/boot_console$(PreprocessSuffix) ../boot/console.c

$(IntermediateDirectory)/boot_shell$(ObjectSuffix): ../boot/shell.c  
	$(CC) $(SourceSwitch) ../boot/shell.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/boot_shell$(ObjectSuffix) -MF$(IntermediateDirectory)/boot_shell$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/boot_shell$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/boot_shell$(PreprocessSuffix): ../boot/shell.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/boot_shell$(PreprocessSuffix) ../boot/shell.c


-include $(IntermediateDirectory)/*$(DependSuffix)
