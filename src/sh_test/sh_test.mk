##
## Auto Generated makefile by CDK
## Do not modify this file, and any manual changes will be erased!!!   
##
## BuildSet
ProjectName            :=sh_test
ConfigurationName      :=BuildSet
WorkspacePath          :=./
ProjectPath            :=./
IntermediateDirectory  :=Obj
OutDir                 :=$(IntermediateDirectory)
User                   :=phosense
Date                   :=12/05/2021
CDKPath                :=../../../../../C-Sky/CDK/
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
ObjectsFileList        :=sh_test.txt
MakeDirCommand         :=mkdir
LinkOptions            := -mabi=ilp32e -mtune=e902 -march=rv32ecxtheadse  -nostartfiles -Wl,--gc-sections -T"$(ProjectPath)/sh_test.ld"
LinkOtherFlagsOption   :=
IncludePackagePath     :=
IncludeCPath           := $(IncludeSwitch). $(IncludeSwitch)../../../../../C-Sky/CDK/CSKY/csi/csi_core/include/ $(IncludeSwitch)../../../../../C-Sky/CDK/CSKY/csi/csi_core/csi_cdk/ $(IncludeSwitch)../../../../../C-Sky/CDK/CSKY/csi/csi_driver/include/ $(IncludeSwitch). $(IncludeSwitch)../nos/  
IncludeAPath           := $(IncludeSwitch). $(IncludeSwitch)../../../../../C-Sky/CDK/CSKY/csi/csi_core/include/ $(IncludeSwitch)../../../../../C-Sky/CDK/CSKY/csi/csi_core/csi_cdk/ $(IncludeSwitch)../../../../../C-Sky/CDK/CSKY/csi/csi_driver/include/ $(IncludeSwitch). $(IncludeSwitch)../nos/ $(IncludeSwitch)../tools/  
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
CXXFLAGS := -mabi=ilp32e -mtune=e902 -march=rv32ecxtheadse    -Og  -g3  -Wall  
CFLAGS   := -mabi=ilp32e -mtune=e902 -march=rv32ecxtheadse    -Og  -g3  -Wall  
ASFLAGS  := -mabi=ilp32e -mtune=e902 -march=rv32ecxtheadse    -Wa,--gdwarf2    


Objects0=$(IntermediateDirectory)/isr$(ObjectSuffix) $(IntermediateDirectory)/startup$(ObjectSuffix) $(IntermediateDirectory)/vectors$(ObjectSuffix) $(IntermediateDirectory)/main$(ObjectSuffix) $(IntermediateDirectory)/board_init$(ObjectSuffix) $(IntermediateDirectory)/shell$(ObjectSuffix) $(IntermediateDirectory)/system$(ObjectSuffix) $(IntermediateDirectory)/stc$(ObjectSuffix) $(IntermediateDirectory)/uart$(ObjectSuffix) $(IntermediateDirectory)/console$(ObjectSuffix) \
	$(IntermediateDirectory)/fifo$(ObjectSuffix) 



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
	@$(ProjectName).modify.bat $(IntermediateDirectory) $(OutputFile)$(ExeSuffix) 

Always_Link:


##
## Objects
##
$(IntermediateDirectory)/isr$(ObjectSuffix): isr.c  
	$(CC) $(SourceSwitch) isr.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/isr$(ObjectSuffix) -MF$(IntermediateDirectory)/isr$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/isr$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/isr$(PreprocessSuffix): isr.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/isr$(PreprocessSuffix) isr.c

$(IntermediateDirectory)/startup$(ObjectSuffix): startup.S  
	$(AS) $(SourceSwitch) startup.S $(ASFLAGS) -MMD -MP -MT$(IntermediateDirectory)/startup$(ObjectSuffix) -MF$(IntermediateDirectory)/startup$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/startup$(ObjectSuffix) $(IncludeAPath) $(IncludePackagePath)
Lst/startup$(PreprocessSuffix): startup.S
	$(CC) $(CFLAGS)$(IncludeAPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/startup$(PreprocessSuffix) startup.S

$(IntermediateDirectory)/vectors$(ObjectSuffix): vectors.S  
	$(AS) $(SourceSwitch) vectors.S $(ASFLAGS) -MMD -MP -MT$(IntermediateDirectory)/vectors$(ObjectSuffix) -MF$(IntermediateDirectory)/vectors$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/vectors$(ObjectSuffix) $(IncludeAPath) $(IncludePackagePath)
Lst/vectors$(PreprocessSuffix): vectors.S
	$(CC) $(CFLAGS)$(IncludeAPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/vectors$(PreprocessSuffix) vectors.S

$(IntermediateDirectory)/main$(ObjectSuffix): main.c  
	$(CC) $(SourceSwitch) main.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/main$(ObjectSuffix) -MF$(IntermediateDirectory)/main$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/main$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/main$(PreprocessSuffix): main.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/main$(PreprocessSuffix) main.c

$(IntermediateDirectory)/board_init$(ObjectSuffix): board_init.c  
	$(CC) $(SourceSwitch) board_init.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/board_init$(ObjectSuffix) -MF$(IntermediateDirectory)/board_init$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/board_init$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/board_init$(PreprocessSuffix): board_init.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/board_init$(PreprocessSuffix) board_init.c

$(IntermediateDirectory)/shell$(ObjectSuffix): shell.c  
	$(CC) $(SourceSwitch) shell.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/shell$(ObjectSuffix) -MF$(IntermediateDirectory)/shell$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/shell$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/shell$(PreprocessSuffix): shell.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/shell$(PreprocessSuffix) shell.c

$(IntermediateDirectory)/system$(ObjectSuffix): system.c  
	$(CC) $(SourceSwitch) system.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/system$(ObjectSuffix) -MF$(IntermediateDirectory)/system$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/system$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/system$(PreprocessSuffix): system.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/system$(PreprocessSuffix) system.c

$(IntermediateDirectory)/stc$(ObjectSuffix): stc.c  
	$(CC) $(SourceSwitch) stc.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/stc$(ObjectSuffix) -MF$(IntermediateDirectory)/stc$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/stc$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/stc$(PreprocessSuffix): stc.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/stc$(PreprocessSuffix) stc.c

$(IntermediateDirectory)/uart$(ObjectSuffix): uart.c  
	$(CC) $(SourceSwitch) uart.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/uart$(ObjectSuffix) -MF$(IntermediateDirectory)/uart$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/uart$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/uart$(PreprocessSuffix): uart.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/uart$(PreprocessSuffix) uart.c

$(IntermediateDirectory)/console$(ObjectSuffix): console.c  
	$(CC) $(SourceSwitch) console.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/console$(ObjectSuffix) -MF$(IntermediateDirectory)/console$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/console$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/console$(PreprocessSuffix): console.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/console$(PreprocessSuffix) console.c

$(IntermediateDirectory)/fifo$(ObjectSuffix): fifo.c  
	$(CC) $(SourceSwitch) fifo.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/fifo$(ObjectSuffix) -MF$(IntermediateDirectory)/fifo$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/fifo$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/fifo$(PreprocessSuffix): fifo.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/fifo$(PreprocessSuffix) fifo.c


-include $(IntermediateDirectory)/*$(DependSuffix)
