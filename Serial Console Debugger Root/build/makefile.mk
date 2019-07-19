TARGET = kernel7.img
ELFILE = myos.elf 
CC = arm-none-eabi-gcc.exe
OC = arm-none-eabi-objcopy.exe
EM = qemu-system-arm.exe
CPU = cortex-a7
MEM = 1024

SHELL = C:/Windows/system32/cmd.exe

CFLAGS = -mcpu=$(CPU) -fpic -ffreestanding -Wall
EMFLAGS = -m $(MEM) -M raspi2 -serial stdio -kernel $(OBJS_DIR)/$(ELFILE)
CSRCFLAGS = -g -02 -Wall -Wextra
LFLAGS = -ffreestanding -02 -nostdlib

SRC_CMN_DIR = ../source/common
SRC_KER_DIR = ../source/kernel
INC_CMN_DIR = ../include/common
INC_KER_DIR = ../include/kernel
OBJS_DIR = objects
EM_DIR = C:\Program Files\qemu
CC_DIR = C:\Program Files (x86)\GNU Tools ARM Embedded\8 2019-q3-update\bin


$(OBJS_DIR)/%.o : $(SRC_KER_DIR)/%.s
	@echo Compiling Assembler Source File $<
	@$(CC_DIR)/$(CC) $(CFLAGS) -c $< -o $@


$(OBJS_DIR)/%.o : $(SRC_CMN_DIR)/%.c $(INC_CMN_DIR)/%.h
	@echo Compiling C Source File $<
	@$(CC_DIR)/$(CC) $(CFLAGS) -I$(INC_CMN_DIR) -I$(INC_KER_DIR) -c $< -o $@ $(CSRCFLAGS)


$(OBJS_DIR)/$(ELFILE) : $(OBJS_DIR)/boot.o $(OBJS_DIR)/object1.0 $(OBJS_DIR)/object2.o
	@echo Linking Objects Files: $^
	@$(CC_DIR)/$(CC) -T linker.ld -o $(OBJS_DIR)/$(ELFILE) $(LFLAGS) $^
	@echo Extensible Linkable Format File: $@ created


$(TARGET) : $(OBJS_DIR)/$(ELFILE)
	@$(CC_DIR)/$(OC) $(OBJS_DIR)/$(ELFILE) -O binary $(OBJS_DIR)/$(TARGET)
	@echo Kernel Image File: $(TARGET) created

all: $(TARGET)

clean:
	@echo Removing Object Files $(wildcard $(OBJS_DIR)/*.o)
	@rm $(OBJS_DIR)/*.o 
	@echo Removing $(ELFILE)

run: $(OBJS_DIR)/$(ELFILE)
	$(EM_DIR)/$(EM) $(EMFLAGS)

.PHONY: clean run