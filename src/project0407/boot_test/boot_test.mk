##
## Auto Generated makefile by CDK
## Do not modify this file, and any manual changes will be erased!!!   
##
## BuildSet
ProjectName            :=boot_test
ConfigurationName      :=BuildSet
WorkspacePath          :=../
ProjectPath            :=./
IntermediateDirectory  :=Obj
OutDir                 :=$(IntermediateDirectory)
User                   :=wy
Date                   :=2021/3/30
CDKPath                :=C:/CDK/
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
ObjectsFileList        :=boot_test.txt
MakeDirCommand         :=mkdir
LinkOptions            := -mabi=ilp32e -march=rv32em  -nostartfiles -T$(ProjectPath)/boot_test.ld
LinkOtherFlagsOption   :=
IncludePackagePath     :=
IncludeCPath           :=$(IncludeSwitch). $(IncludeSwitch)C:/CDK/CSKY/csi/csi_core/include/ $(IncludeSwitch)C:/CDK/CSKY/csi/csi_core/csi_cdk/ $(IncludeSwitch)C:/CDK/CSKY/csi/csi_driver/include/ 
IncludeAPath           :=$(IncludeSwitch). $(IncludeSwitch)C:/CDK/CSKY/csi/csi_core/include/ $(IncludeSwitch)C:/CDK/CSKY/csi/csi_core/csi_cdk/ $(IncludeSwitch)C:/CDK/CSKY/csi/csi_driver/include/ 
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
CXXFLAGS := -mabi=ilp32e -march=rv32em    -Og  -g3  -Wall  
CFLAGS   := -mabi=ilp32e -march=rv32em    -Og  -g3  -Wall  
ASFLAGS  := -mabi=ilp32e -march=rv32em    -Wa,--gdwarf2    


Objects0=$(IntermediateDirectory)/startup$(ObjectSuffix) $(IntermediateDirectory)/init$(ObjectSuffix) $(IntermediateDirectory)/main$(ObjectSuffix) 



Objects=$(Objects0) 

##
## Main Build Targets 
##
.PHONY: all
all: $(IntermediateDirectory)/$(OutputFile)

$(IntermediateDirectory)/$(OutputFile):  $(Objects) Always_Link 
	$(LinkerName) $(OutputSwitch) $(IntermediateDirectory)/$(OutputFile)$(ExeSuffix) $(LinkerNameoption) $(LinkOtherFlagsOption)  @$(ObjectsFileList)  $(LinkOptions) $(LibPath) $(Libs)
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

$(IntermediateDirectory)/init$(ObjectSuffix): init.c  
	$(CC) $(SourceSwitch) init.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/init$(ObjectSuffix) -MF$(IntermediateDirectory)/init$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/init$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/init$(PreprocessSuffix): init.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/init$(PreprocessSuffix) init.c

$(IntermediateDirectory)/main$(ObjectSuffix): main.c  
	$(CC) $(SourceSwitch) main.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/main$(ObjectSuffix) -MF$(IntermediateDirectory)/main$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/main$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/main$(PreprocessSuffix): main.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/main$(PreprocessSuffix) main.c


-include $(IntermediateDirectory)/*$(DependSuffix)
