# WinARM template makefile 
# by Martin Thomas, Kaiserslautern, Germany 
# <eversmith(at)heizung-thomas(dot)de>
#
# Released to the Public Domain
# Please read the make user manual!
#
# The user-configuration is based on the WinAVR makefile-template
# written by Eric B. Weddington, J�rg Wunsch, et al. but the internal
# handling used here is very different.
# This makefile can also be used with the GNU tools included in
# Yagarto, GNUARM or the Codesourcery packages. It should work
# on Unix/Linux-Systems too. Just a rather up-to-date GNU make is
# needed.
#
#
# On command line:
#
# make all = Make software.
#
# make clean = Clean out built project files.
#
# make program = Upload load-image to the device
#
# make filename.s = Just compile filename.c into the assembler code only
#
# make filename.o = Create object filename.o from filename.c (using CFLAGS)
#
# To rebuild project do "make clean" then "make all".

# Toolchain prefix (arm-elf- -> arm-elf-gcc.exe)
TCHAIN_PREFIX = arm-none-eabi-
#TCHAIN_PREFIX = arm-eabi-
#TCHAIN_PREFIX = arm-elf-
# cs-rm is a standard GNU rm which gets installed with CS G++ lite.
# Just the filename is different. Use REMOVE_CMD=rm in environments
# with rm (Linux, BSD, msys, Cygwin etc.)
REMOVE_CMD=rm

# YES enables -mthumb option to flags for source-files listed 
# in SRC and CPPSRC and -mthumb-interwork option for all source
USE_THUMB_MODE = YES
#USE_THUMB_MODE = NO

# MCU name, submodel and board
# - MCU used for compiler-option (-mcpu)
# - SUBMDL used for linker-script name (-T) and passed as define
# - BOARD just passed as define (don't used '-' characters)
MCU      = cortex-m4
CHIP     = STM32F4xx
BOARD    = STM32F4DISCOVERY

# *** This example only supports "FLASH_RUN" ***
# RUN_MODE is passed as define and used for the linker-script filename,
# the user has to implement the necessary operations for 
# the used mode (i.e. no copy of .data, remapping...)
# Create FLASH-Image
RUN_MODE=FLASH_RUN
# Create RAM-Image
#RUN_MODE=RAM_RUN

# Exception-vectors placement option is just passed as define,
# the user has to implement the necessary operations (i.e. remapping)
# Exception vectors in FLASH:
VECTOR_TABLE_LOCATION=VECT_TAB_FLASH
# Exception vectors in RAM:
#VECTOR_TABLE_LOCATION=VECT_TAB_RAM

# Directory for output files (lst, obj, dep, elf, sym, map, hex, bin etc.)
OUTDIR = "./build/$(RUN_MODE)"

# Target file name (without extension).
TARGET = project

# Utility variables
APPLIBDIR      = ./Libraries
STMLIBDIR      = $(APPLIBDIR)
CMSISDEVDIR    = $(STMLIBDIR)/Device/STM32F4xx
STMSPDDIR      = $(STMLIBDIR)/STM32F4xx_StdPeriph_Driver
STMSPDSRCDIR   = $(STMSPDDIR)/src
STMSPDINCDIR   = $(STMSPDDIR)/inc
CMSISCOREDIR   = $(STMLIBDIR)/CMSIS
STMUTILDIR     = $(CMSISDEVDIR)/STM32F4-Discovery
CMSISDEVINCDIR = $(CMSISDEVDIR)/Include
CMSISDEVSRCDIR = $(CMSISDEVDIR)/Source
CMSISCOREINCDIR= $(CMSISCOREDIR)/Include

# List C source files here. (C dependencies are automatically generated.)
# use file-extension c for "c-only"-files
#SRC = system_stm32f4xx.c stm32f4xx_it.c  main.c selftest.c usb_bsp.c usbd_desc.c usbd_usr.c
SRC = $(wildcard src/*.c) 

SRC += $(STMUTILDIR)/stm32f4_discovery.c
#SRC += $(STMUTILDIR)/stm32f4_discovery.c 
#SRC += $(STMUTILDIR)/stm32f4_discovery_lis302dl.c 
#SRC += $(STMUTILDIR)/stm32f4_discovery_audio_codec.c 

SRC += $(STMSPDSRCDIR)/misc.c
#SRC += $(STMSPDSRCDIR)/stm32f4xx_adc.c
#SRC += $(STMSPDSRCDIR)/stm32f4xx_dac.c
#SRC += $(STMSPDSRCDIR)/stm32f4xx_dma.c
SRC += $(STMSPDSRCDIR)/stm32f4xx_exti.c
#SRC += $(STMSPDSRCDIR)/stm32f4xx_flash.c
SRC += $(STMSPDSRCDIR)/stm32f4xx_gpio.c
#SRC += $(STMSPDSRCDIR)/stm32f4xx_i2c.c
#SRC += $(STMSPDSRCDIR)/stm32f4xx_rcc.c
#SRC += $(STMSPDSRCDIR)/stm32f4xx_spi.c
SRC += $(STMSPDSRCDIR)/stm32f4xx_syscfg.c
SRC += $(STMSPDSRCDIR)/stm32f4xx_tim.c
SRC += $(STMSPDSRCDIR)/stm32f4xx_rcc.c

SRC += $(STMLIBDIR)/STM32_USB_HOST_Library/Core/src/usbh_core.c 
SRC += $(STMLIBDIR)/STM32_USB_HOST_Library/Core/src/usbh_hcs.c 
SRC += $(STMLIBDIR)/STM32_USB_HOST_Library/Core/src/usbh_ioreq.c 
SRC += $(STMLIBDIR)/STM32_USB_HOST_Library/Core/src/usbh_stdreq.c
SRC += $(STMLIBDIR)/STM32_USB_OTG_Driver/src/usb_core.c
SRC += $(STMLIBDIR)/STM32_USB_OTG_Driver/src/usb_hcd_int.c
SRC += $(STMLIBDIR)/STM32_USB_OTG_Driver/src/usb_hcd.c


# List C source files here which must be compiled in ARM-Mode (no -mthumb).
# use file-extension c for "c-only"-files
## just for testing, timer.c could be compiled in thumb-mode too
SRCARM = 

# List C++ source files here.
# use file-extension .cpp for C++-files (not .C)
CPPSRC = 

# List C++ source files here which must be compiled in ARM-Mode.
# use file-extension .cpp for C++-files (not .C)
#CPPSRCARM = $(TARGET).cpp
CPPSRCARM = 

# List Assembler source files here.
# Make them always end in a capital .S. Files ending in a lowercase .s
# will not be considered source files but generated files (assembler
# output from the compiler), and will be deleted upon "make clean"!
# Even though the DOS/Win* filesystem matches both .s and .S the same,
# it will preserve the spelling of the filenames, and gcc itself does
# care about how the name is spelled on its command-line.
#ASRC = startup_stm32f4xx.S
ASRC = $(CMSISDEVDIR)/startup_stm32f4xx.S

# List Assembler source files here which must be assembled in ARM-Mode.
ASRCARM  = 

# Place project-specific -D (define) and/or -U options for C here.
CDEFS = -DUSE_STDPERIPH_DRIVER
CDEFS += -DSTM32F4XX
CDEFS += -DHSE_VALUE=8000000UL
CDEFS += -DUSE_USB_OTG_FS
#CDEFS += -DUSE_FULL_ASSERT
# enable modifications in STM's libraries
CDEFS += -DMOD_MTHOMAS_STMLIB

# Place project-specific -D and/or -U options for 
# Assembler with preprocessor here.
ADEFS = 

# List any extra directories to look for include files here.
#    Each directory must be seperated by a space.
EXTRAINCDIRS  = ./inc $(STMSPDINCDIR) $(CMSISDEVINCDIR) $(CMSISCOREINCDIR) $(STMUTILDIR)
EXTRAINCDIRS += $(APPLIBDIR)/STM32_USB_HOST_Library/Core/inc
EXTRAINCDIRS += $(APPLIBDIR)/STM32_USB_OTG_Driver/inc

# Extra libraries
#    Each library-name must be seperated by a space.
#    i.e. to link with libxyz.a, libabc.a and libefsl.a: 
#     EXTRA_LIBS = xyz abc efsl
#    for newlib-lpc (file: libnewlibc-lpc.a):
#     EXTRA_LIBS = newlib-lpc
EXTRA_LIBS =

# List non-source files which should trigger build here
#    Typically the Makefile and selected header-files
#    Entries must be seperated by a space.
BUILDONCHANGE = Makefile
#BUILDONCHANGE =

# Path to linker-scripts (see -T option)
LINKERSCRIPTPATH = $(CMSISDEVDIR)

# List any directories with files included from linker-scripts.
#    Each directory must be seperated by a space.
LINKERSCRIPTINC  = .

# List any extra directories to look for library files here.
#     Each directory must be seperated by a space.
EXTRA_LIBDIRS =

# Optimization level, can be [0, 1, 2, 3, s]. 
# 0 = Turn off optimization. Reduce compilation time and make debugging
#     produce the expected results.
# 1 = The compiler tries to reduce code size and execution time, without
#     performing any optimizations that take a great deal of compilation time.
# 2 = GCC performs nearly all supported optimizations that do not involve a 
#     space-speed tradeoff. As compared to -O1, this option increases
#     both compilation time and the performance of the generated code.
# 3 = Optimize yet more. Turns on -finline-functions and more.
# s = -Os enables all -O2 optimizations that do not typically increase code
#     size.
# (See gcc manual for further information)
OPT = s
#OPT = 2
#OPT = 3
#OPT = 0

# Debugging format.
#DEBUG = stabs
#DEBUG = dwarf-2
DEBUG = gdb

# Compiler flag to set the C Standard level.
# c89   - "ANSI" C
# gnu89 - c89 plus GCC extensions
# c99   - ISO C99 standard (not yet fully implemented)
# gnu99 - c99 plus GCC extensions
CSTANDARD = -std=gnu99

# Flash programming tool
FLASH_TOOL = STLINKv2
#FLASH_TOOL = OPENOCD
#FLASH_TOOL = LPC21ISP

# Some warnings can be disabled by this setting 
# (useful for the old single-file AT91-lib) 
#  yes - disable some warnings
#  no  - keep default settings
#DISABLESPECIALWARNINGS = yes
DISABLESPECIALWARNINGS = no


# ---------------------------------------------------------------------------
# Options for lpc21isp by Martin Maurer 
# lpc21isp only supports NXP LPC and Analog ADuC ARMs though the 
# integrated uart-bootloader (ISP)
#
# Settings and variables:
LPC21ISP = lpc21isp
LPC21ISP_FLASHFILE = $(OUTDIR)/$(TARGET).hex
LPC21ISP_PORT = com1
LPC21ISP_BAUD = 57600
LPC21ISP_XTAL = 12000
# other options:
# -debug: verbose output
# -control: enter bootloader via RS232 DTR/RTS (only if hardware 
#           supports this feature - see NXP AppNote)
LPC21ISP_OPTIONS = -control
#LPC21ISP_OPTIONS += -debug
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Options for OpenOCD flash-programming
# see openocd.pdf/openocd.texi for further information
#
OOCD_LOADFILE+=$(OUTDIR)/$(TARGET).elf
# if OpenOCD is in the $PATH just set OPENOCDEXE=openocd
OOCD_EXE=./OpenOCD/bin/openocd
# debug level
OOCD_CL=-d0
#OOCD_CL=-d3
# interface and board/target settings (using the OOCD target-library here)
OOCD_CL+=-f board\stm32f4discovery.cfg
# initialize
OOCD_CL+=-c init
# if no SRST available:
## why unknown - it's documented... OOCD_CL+=-c "cortex_m3 reset_config sysresetreq"
# commands to prepare flash-write
OOCD_CL+= -c "reset halt"
# show the targets
OOCD_CL+=-c targets
# increase JTAG frequency a little bit - can be disabled for tests
OOCD_CL+= -c "adapter_khz 1000"
# disable polling (optional)
OOCD_CL+= -c "poll off"
# flash-write and -verify
OOCD_CL+=-c "flash write_image erase $(OOCD_LOADFILE)" -c "verify_image $(OOCD_LOADFILE)"
# AIRCR SYSRESETREQ - workaround since sometimes the controller does not start after reset run
# but seems to "hang" in an NMI - should be removed once cortex_m3 reset_config works
OOCD_CL+=-c"mww 0xE000ED0C 0x05fa0004" -c "sleep 200"
# reset target
OOCD_CL+=-c "reset run"
# show the targets
OOCD_CL+=-c targets
# terminate OOCD after programming
OOCD_CL+=-c shutdown
# ---------------------------------------------------------------------------


ifdef VECTOR_TABLE_LOCATION
CDEFS += -D$(VECTOR_TABLE_LOCATION)
ADEFS += -D$(VECTOR_TABLE_LOCATION)
endif

CDEFS += -D$(RUN_MODE) -D$(CHIP) -D$(BOARD)
ADEFS += -D$(RUN_MODE) -D$(CHIP) -D$(BOARD)


# Compiler flags.

ifeq ($(USE_THUMB_MODE),YES)
THUMB    = -mthumb
THUMB_IW = -mthumb-interwork
else 
THUMB    = 
THUMB_IW = 
endif

#  -g*:          generate debugging information
#  -O*:          optimization level
#  -f...:        tuning, see GCC manual
#  -Wall...:     warning level
#  -Wa,...:      tell GCC to pass this to the assembler.
#    -adhlns...: create assembler listing
#
# Flags for C and C++ (arm-elf-gcc/arm-elf-g++)
CFLAGS =  -g$(DEBUG)
CFLAGS += -O$(OPT)
CFLAGS += -mcpu=$(MCU) $(THUMB_IW) 
CFLAGS += $(CDEFS)
CFLAGS += $(patsubst %,-I%,$(EXTRAINCDIRS)) -I.
# when using ".ramfunc"s without attribute longcall:
#CFLAGS += -mlong-calls
# -mapcs-frame is important if gcc's interrupt attributes are used
# (at least from my eabi tests), not needed if assembler-wrappers are used 
CFLAGS += -mapcs-frame 
#CFLAGS += -fomit-frame-pointer
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -fstrict-volatile-bitfields
CFLAGS += -Wall -Wextra
#CFLAGS += -pedantic
CFLAGS += -Wcast-align -Wpointer-arith
CFLAGS += -Wredundant-decls -Wshadow -Wcast-qual -Wcast-align
CFLAGS += -Wa,-adhlns=$(addprefix $(OUTDIR)/, $(notdir $(addsuffix .lst, $(basename $<))))
# Compiler flags to generate dependency files:
#CFLAGS += -MD -MP -MF $(OUTDIR)/dep/$(@F).d 
CFLAGS += -MMD -MP -MF $(OUTDIR)/dep/$(@F).d
##testing##CFLAGS += -MF"$@" -MG -MM -MP -MT"$@" -MT"$(<:.c=.o)"
#CFLAGS += -fno-dwarf2-cfi-asm
#CFLAGS += -fno-strict-aliasing -Wno-nested-externs

# flags only for C
CONLYFLAGS += -Wnested-externs 
CONLYFLAGS += $(CSTANDARD)

ifeq ($(DISABLESPECIALWARNINGS),yes)
CFLAGS += -Wno-cast-qual
CONLYFLAGS += -Wno-missing-prototypes 
CONLYFLAGS += -Wno-strict-prototypes
CONLYFLAGS += -Wno-missing-declarations
endif

# flags only for C++ (arm-*-g++)
CPPFLAGS = -fno-rtti -fno-exceptions

# Assembler flags.
#  -Wa,...:    tell GCC to pass this to the assembler.
#  -ahlns:     create listing
#  -g$(DEBUG): have the assembler create line number information
ASFLAGS  = -mcpu=$(MCU) $(THUMB_IW) -I. -x assembler-with-cpp
ASFLAGS += -D__ASSEMBLY__ $(ADEFS)
ASFLAGS += -Wa,-adhlns=$(addprefix $(OUTDIR)/, $(notdir $(addsuffix .lst, $(basename $<))))
ASFLAGS += -Wa,-g$(DEBUG)
ASFLAGS += $(patsubst %,-I%,$(EXTRAINCDIRS))

# Link with the GNU C++ stdlib.
CPLUSPLUS_LIB = -lstdc++
#CPLUSPLUS_LIB += -lsupc++

# Linker flags.
#  -Wl,...:     tell GCC to pass this to linker.
#    -Map:      create map file
#    --cref:    add cross reference to  map file
LDFLAGS = -Wl,-Map=$(OUTDIR)/$(TARGET).map,--cref,--gc-sections
LDFLAGS += -lc -lm -lc -lgcc
LDFLAGS += $(CPLUSPLUS_LIB)
LDFLAGS += $(patsubst %,-L%,$(EXTRA_LIBDIRS))
LDFLAGS += $(patsubst %,-L%,$(LINKERSCRIPTINC))
LDFLAGS += $(patsubst %,-l%,$(EXTRA_LIBS)) 

# Set linker-script name depending on selected run-mode and chip
ifeq ($(RUN_MODE),RAM_RUN)
LDFLAGS +=-T$(LINKERSCRIPTPATH)/$(CHIP)_ram.ld
else 
LDFLAGS +=-T$(LINKERSCRIPTPATH)/$(CHIP)_flash.ld
endif

# Autodetect environment
SHELL   = sh
ifneq ($(or $(COMSPEC), $(ComSpec)),)
$(info COMSPEC detected $(COMSPEC) $(ComSpec))
ifeq ($(findstring cygdrive,$(shell set)),)
SHELL:=$(or $(COMSPEC),$(ComSpec))
SHELL_IS_WIN32=1
else
$(info cygwin detected)
#override user-setting since cygwin has rm
REMOVE_CMD:=rm
endif
else
#most probaly a Unix/Linux/BSD system which should have rm
REMOVE_CMD:=rm
endif
#$(info SHELL is $(SHELL), REMOVE_CMD is $(REMOVE_CMD))

# Define programs and commands.
CC      = $(TCHAIN_PREFIX)gcc
CPP     = $(TCHAIN_PREFIX)g++
AR      = $(TCHAIN_PREFIX)ar
OBJCOPY = $(TCHAIN_PREFIX)objcopy
OBJDUMP = $(TCHAIN_PREFIX)objdump
SIZE    = $(TCHAIN_PREFIX)size
NM      = $(TCHAIN_PREFIX)nm
REMOVE  = $(REMOVE_CMD) -f

# Define Messages
# English
MSG_BEGIN = --------  begin, mode: $(RUN_MODE)  --------
MSG_END = --------  end  --------
MSG_BUILD_DIR = Build dir: $(OUTDIR)
MSG_SIZE_BEFORE = Size before:
MSG_SIZE_AFTER = Size after build:
MSG_LOAD_FILE = Creating load file:
MSG_EXTENDED_LISTING = Creating Extended Listing/Disassembly:
MSG_SYMBOL_TABLE = Creating Symbol Table:
MSG_LINKING = ---- Linking:
MSG_COMPILING = ---- Compiling C:
MSG_COMPILING_ARM = ---- Compiling C ARM-only:
MSG_COMPILINGCPP = ---- Compiling C++:
MSG_COMPILINGCPP_ARM = ---- Compiling C++ ARM-only:
MSG_ASSEMBLING = ---- Assembling:
MSG_ASSEMBLING_ARM = ---- Assembling ARM-only:
MSG_CLEANING = Cleaning project:
MSG_LPC21_RESETREMINDER = You may have to bring the target in bootloader-mode now.
MSG_ASMFROMC = "Creating asm-File from C-Source:"
MSG_ASMFROMC_ARM = "Creating asm-File from C-Source (ARM-only):"

ifeq ($(V),1)
# Prefix displaying the following command if and only if verbose is a goal.
VERB =
# New line displayed if and only if verbose is a goal.
VERBNL = @echo
else
VERB = @
VERBNL =
endif


# List of all source files.
ALLSRC     = $(ASRCARM) $(ASRC) $(SRCARM) $(SRC) $(CPPSRCARM) $(CPPSRC)
# List of all source files without directory and file-extension.
ALLSRCBASE = $(notdir $(basename $(ALLSRC)))

# Define all object files.
ALLOBJ     = $(addprefix $(OUTDIR)/, $(addsuffix .o, $(ALLSRCBASE)))

# Define all listing files (used for make clean).
LSTFILES   = $(addprefix $(OUTDIR)/, $(addsuffix .lst, $(ALLSRCBASE)))
# Define all depedency-files (used for make clean).
DEPFILES   = $(addprefix $(OUTDIR)/dep/, $(addsuffix .o.d, $(ALLSRCBASE)))

# Default target.
all: begin createdirs gccversion build sizeafter end

elf: $(OUTDIR)/$(TARGET).elf
lss: $(OUTDIR)/$(TARGET).lss 
sym: $(OUTDIR)/$(TARGET).sym
hex: $(OUTDIR)/$(TARGET).hex
bin: $(OUTDIR)/$(TARGET).bin

# Target for the build-sequence.
build: elf lss sym hex bin

# Create output directories.
ifdef SHELL_IS_WIN32
createdirs:
	-@md $(OUTDIR) >NUL 2>&1 || echo "" >NUL
	-@md $(OUTDIR)/dep >NUL 2>&1 || echo "" >NUL
else
createdirs:
	-@mkdir -p $(OUTDIR)/dep 2>/dev/null || echo "" >/dev/null
endif

# Eye candy.
begin:
	@echo $(MSG_BEGIN)
	@echo $(MSG_BUILD_DIR) 
	@echo "Assembly: " $(ASRC) 

end:
	@echo $(MSG_END)

# Display sizes of sections.
ELFSIZE = $(SIZE) -A  $(OUTDIR)/$(TARGET).elf
sizebefore:
#	@if [ -f  $(OUTDIR)/$(TARGET).elf ]; then echo; echo $(MSG_SIZE_BEFORE); $(ELFSIZE); echo; fi

sizeafter:
#	@if [ -f  $(OUTDIR)/$(TARGET).elf ]; then echo; echo $(MSG_SIZE_AFTER); $(ELFSIZE); echo; fi
	@echo $(MSG_SIZE_AFTER)
	$(ELFSIZE)

# Display compiler version information.
gccversion : 
	@$(CC) --version
	@echo

# Program the device.
ifeq ($(FLASH_TOOL),STLINKv2)
program: $(OUTDIR)/$(TARGET).elf
	@echo "Programming with ST-Link v2"
	@echo "NOT YET SUPPORTED"
else
ifeq ($(FLASH_TOOL),OPENOCD)
# Program the device with Dominic Rath's OPENOCD in "batch-mode"
program: $(OUTDIR)/$(TARGET).elf
	@echo "Programming with OPENOCD"
ifdef SHELL_IS_WIN32 
	$(subst /,\,$(OOCD_EXE)) $(OOCD_CL)
else
	$(OOCD_EXE) $(OOCD_CL)
endif
else
# Program the device using lpc21isp (for NXP2k and ADuC UART bootloader)
program: $(OUTDIR)/$(TARGET).hex
	@echo $(MSG_LPC21_RESETREMINDER)
	-$(LPC21ISP) $(LPC21ISP_OPTIONS) $(LPC21ISP_FLASHFILE) $(LPC21ISP_PORT) $(LPC21ISP_BAUD) $(LPC21ISP_XTAL)
endif
endif

# Create final output file in ihex format from ELF output file (.hex).
%.hex: %.elf
	@echo $(MSG_LOAD_FILE) $@
	$(VERB)$(OBJCOPY) -O ihex $< $@
	$(VERBNL)
	
# Create final output file in raw binary format from ELF output file (.bin)
%.bin: %.elf
	@echo $(MSG_LOAD_FILE) $@
	$(VERB)$(OBJCOPY) -O binary $< $@
	$(VERBNL)

# Create extended listing file/disassambly from ELF output file.
# using objdump (testing: option -C)
%.lss: %.elf
	@echo $(MSG_EXTENDED_LISTING) $@
	$(VERB)$(OBJDUMP) -h -S -C -r $< > $@
	$(VERBNL)

# Create a symbol table from ELF output file.
%.sym: %.elf
	@echo $(MSG_SYMBOL_TABLE) $@
	$(VERB)$(NM) -n $< > $@
	$(VERBNL)

# Link: create ELF output file from object files.
.SECONDARY : $(TARGET).elf
.PRECIOUS : $(ALLOBJ)
%.elf:  $(ALLOBJ) $(BUILDONCHANGE)
	@echo $(MSG_LINKING) $@
# use $(CC) for C-only projects or $(CPP) for C++-projects:
ifeq "$(strip $(CPPSRC)$(CPPARM))" ""
	$(VERB)$(CC) $(THUMB) $(CFLAGS) $(ALLOBJ) --output $@ -nostartfiles $(LDFLAGS)
	$(VERBNL)
else
	$(VERB)$(CPP) $(THUMB) $(CFLAGS) $(ALLOBJ) --output $@ $(LDFLAGS)
	$(VERBNL)
endif


# Assemble: create object files from assembler source files.
define ASSEMBLE_TEMPLATE
$(OUTDIR)/$(notdir $(basename $(1))).o : $(1) $(BUILDONCHANGE)
	@echo $(MSG_ASSEMBLING) $$< to $$@
	$(VERB)$(CC) -c $(THUMB) $$(ASFLAGS) $$< -o $$@ 
	$(VERBNL)
endef
$(foreach src, $(ASRC), $(eval $(call ASSEMBLE_TEMPLATE, $(src)))) 

# Assemble: create object files from assembler source files. ARM-only
define ASSEMBLE_ARM_TEMPLATE
$(OUTDIR)/$(notdir $(basename $(1))).o : $(1) $(BUILDONCHANGE)
	@echo $(MSG_ASSEMBLING_ARM) $$< to $$@
	$(VERB)$(CC) -c $$(ASFLAGS) $$< -o $$@ 
	$(VERBNL)
endef
$(foreach src, $(ASRCARM), $(eval $(call ASSEMBLE_ARM_TEMPLATE, $(src)))) 


# Compile: create object files from C source files.
define COMPILE_C_TEMPLATE
$(OUTDIR)/$(notdir $(basename $(1))).o : $(1) $(BUILDONCHANGE)
	@echo $(MSG_COMPILING) $$< to $$@
	$(VERB)$(CC) -c $(THUMB) $$(CFLAGS) $$(CONLYFLAGS) $$< -o $$@ 
	$(VERBNL)
endef
$(foreach src, $(SRC), $(eval $(call COMPILE_C_TEMPLATE, $(src)))) 

# Compile: create object files from C source files. ARM-only
define COMPILE_C_ARM_TEMPLATE
$(OUTDIR)/$(notdir $(basename $(1))).o : $(1) $(BUILDONCHANGE)
	@echo $(MSG_COMPILING_ARM) $$< to $$@
	$(VERB)$(CC) -c $$(CFLAGS) $$(CONLYFLAGS) $$< -o $$@ 
	$(VERBNL)
endef
$(foreach src, $(SRCARM), $(eval $(call COMPILE_C_ARM_TEMPLATE, $(src)))) 


# Compile: create object files from C++ source files.
define COMPILE_CPP_TEMPLATE
$(OUTDIR)/$(notdir $(basename $(1))).o : $(1) $(BUILDONCHANGE)
	@echo $(MSG_COMPILINGCPP) $$< to $$@
	$(VERB)$(CC) -c $(THUMB) $$(CFLAGS) $$(CPPFLAGS) $$< -o $$@ 
	$(VERBNL)
endef
$(foreach src, $(CPPSRC), $(eval $(call COMPILE_CPP_TEMPLATE, $(src)))) 

# Compile: create object files from C++ source files. ARM-only
define COMPILE_CPP_ARM_TEMPLATE
$(OUTDIR)/$(notdir $(basename $(1))).o : $(1) $(BUILDONCHANGE)
	@echo $(MSG_COMPILINGCPP_ARM) $$< to $$@
	$(VERB)$(CC) -c $$(CFLAGS) $$(CPPFLAGS) $$< -o $$@ 
	$(VERBNL)
endef
$(foreach src, $(CPPSRCARM), $(eval $(call COMPILE_CPP_ARM_TEMPLATE, $(src)))) 


# Compile: create assembler files from C source files. ARM/Thumb
$(SRC:.c=.s) : %.s : %.c $(BUILDONCHANGE)
	@echo $(MSG_ASMFROMC) $< to $@
	$(VERB)$(CC) $(THUMB) -S $(CFLAGS) $(CONLYFLAGS) $< -o $@
	$(VERBNL)

# Compile: create assembler files from C source files. ARM only
$(SRCARM:.c=.s) : %.s : %.c $(BUILDONCHANGE)
	@echo $(MSG_ASMFROMC_ARM) $< to $@
	$(VERB)$(CC) -S $(CFLAGS) $(CONLYFLAGS) $< -o $@
	$(VERBNL)

# Target: clean project.
clean: begin clean_list end

clean_list :
	@echo $(MSG_CLEANING)
	$(VERB)$(REMOVE) $(OUTDIR)/$(TARGET).map
	$(VERB)$(REMOVE) $(OUTDIR)/$(TARGET).elf
	$(VERB)$(REMOVE) $(OUTDIR)/$(TARGET).hex
	$(VERB)$(REMOVE) $(OUTDIR)/$(TARGET).bin
	$(VERB)$(REMOVE) $(OUTDIR)/$(TARGET).sym
	$(VERB)$(REMOVE) $(OUTDIR)/$(TARGET).lss
	$(VERB)$(REMOVE) $(ALLOBJ)
	$(VERB)$(REMOVE) $(LSTFILES)
	$(VERB)$(REMOVE) $(DEPFILES)
	$(VERB)$(REMOVE) $(SRC:.c=.s)
	$(VERB)$(REMOVE) $(SRCARM:.c=.s)
	$(VERB)$(REMOVE) $(CPPSRC:.cpp=.s)
	$(VERB)$(REMOVE) $(CPPSRCARM:.cpp=.s)
	$(VERBNL)

# Include the dependency files.
##-include $(wildcard dep/*)
-include $(wildcard *.d)

# Listing of phony targets.
.PHONY : all begin end sizebefore sizeafter gccversion build elf hex bin lss sym clean clean_list program createdirs

