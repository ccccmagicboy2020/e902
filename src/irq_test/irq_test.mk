##
## Auto Generated makefile by CDK
## Do not modify this file, and any manual changes will be erased!!!   
##
## BuildSet
ProjectName            :=irq_test
ConfigurationName      :=BuildSet
WorkspacePath          :=../
ProjectPath            :=./
IntermediateDirectory  :=Obj
OutDir                 :=$(IntermediateDirectory)
User                   :=wy
Date                   :=2021/4/13
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
ObjectsFileList        :=irq_test.txt
MakeDirCommand         :=mkdir
LinkOptions            := -mabi=ilp32e -march=rv32ecxthead  -nostartfiles -Wl,--gc-sections -T$(ProjectPath)/ckcpu.ld
LinkOtherFlagsOption   :=
IncludePackagePath     :=
IncludeCPath           :=$(IncludeSwitch). $(IncludeSwitch)C:/CDK/CSKY/Flash $(IncludeSwitch)C:/CDK/CSKY/csi/csi_core/include/ $(IncludeSwitch)C:/CDK/CSKY/csi/csi_core/csi_cdk/ $(IncludeSwitch)C:/CDK/CSKY/csi/csi_driver/include/ $(IncludeSwitch)../nos/ 
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
CXXFLAGS := -mabi=ilp32e -march=rv32ecxthead    -Og  -g  -Wall -fno-isolate-erroneous-paths-dereference 
CFLAGS   := -mabi=ilp32e -march=rv32ecxthead    -Og  -g  -Wall -fno-isolate-erroneous-paths-dereference 
ASFLAGS  := -mabi=ilp32e -march=rv32ecxthead    -Wa,--gdwarf2    


Objects0=$(IntermediateDirectory)/crt0$(ObjectSuffix) $(IntermediateDirectory)/main$(ObjectSuffix) $(IntermediateDirectory)/irq$(ObjectSuffix) 



Objects=$(Objects0) 

##
## Main Build Targets 
##
.PHONY: all
all: $(IntermediateDirectory)/$(OutputFile)

$(IntermediateDirectory)/$(OutputFile):  $(Objects) Always_Link 
	$(LinkerName) $(OutputSwitch) $(IntermediateDirectory)/$(OutputFile)$(ExeSuffix) $(LinkerNameoption) $(LinkOtherFlagsOption)  -Wl,-Map=$(ProjectPath)/Lst/$(OutputFile).map  @$(ObjectsFileList)  $(LinkOptions) $(LibPath) $(Libs)
	@mv $(ProjectPath)/Lst/$(OutputFile).map $(ProjectPath)/Lst/$(OutputFile).temp && $(READELF) $(ElfInfoSwitch) $(ProjectPath)/Obj/$(OutputFile)$(ExeSuffix) > $(ProjectPath)/Lst/$(OutputFile).map && echo ====================================================================== >> $(ProjectPath)/Lst/$(OutputFile).map && cat $(ProjectPath)/Lst/$(OutputFile).temp >> $(ProjectPath)/Lst/$(OutputFile).map && rm -rf $(ProjectPath)/Lst/$(OutputFile).temp
	$(OBJDUMP) $(ObjdumpSwitch) $(ProjectPath)/$(IntermediateDirectory)/$(OutputFile)$(ExeSuffix)  > $(ProjectPath)/Lst/$(OutputFile)$(DisassemSuffix) 
	@echo size of target:
	@$(SIZE) $(ProjectPath)$(IntermediateDirectory)/$(OutputFile)$(ExeSuffix) 
	@echo -n checksum value of target:  
	@$(CHECKSUM) $(ProjectPath)/$(IntermediateDirectory)/$(OutputFile)$(ExeSuffix) 
	
Always_Link:


##
## Objects
##
$(IntermediateDirectory)/crt0$(ObjectSuffix): crt0.S  
	$(AS) $(SourceSwitch) crt0.S $(ASFLAGS) -MMD -MP -MT$(IntermediateDirectory)/crt0$(ObjectSuffix) -MF$(IntermediateDirectory)/crt0$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/crt0$(ObjectSuffix) $(IncludeAPath) $(IncludePackagePath)
Lst/crt0$(PreprocessSuffix): crt0.S
	$(CC) $(CFLAGS)$(IncludeAPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/crt0$(PreprocessSuffix) crt0.S

$(IntermediateDirectory)/main$(ObjectSuffix): main.c  
	$(CC) $(SourceSwitch) main.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/main$(ObjectSuffix) -MF$(IntermediateDirectory)/main$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/main$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/main$(PreprocessSuffix): main.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/main$(PreprocessSuffix) main.c

$(IntermediateDirectory)/irq$(ObjectSuffix): irq.c  
	$(CC) $(SourceSwitch) irq.c $(CFLAGS) -MMD -MP -MT$(IntermediateDirectory)/irq$(ObjectSuffix) -MF$(IntermediateDirectory)/irq$(DependSuffix) $(ObjectSwitch)$(IntermediateDirectory)/irq$(ObjectSuffix) $(IncludeCPath) $(IncludePackagePath)
Lst/irq$(PreprocessSuffix): irq.c
	$(CC) $(CFLAGS)$(IncludeCPath) $(PreprocessOnlySwitch) $(OutputSwitch) Lst/irq$(PreprocessSuffix) irq.c


-include $(IntermediateDirectory)/*$(DependSuffix)
