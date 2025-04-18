# Makefile for building Seireitei OS

BASE_PATH := /Users/rahulbaradol/Documents/comedy/seireitei
BUILD_DIR := $(BASE_PATH)/build
ISO_DIR := $(BASE_PATH)/isodir
IMAGE_DIR := $(BASE_PATH)/image
BIN_DIR := $(BASE_PATH)/bin

CRTI_OBJ := $(BUILD_DIR)/crti.o
CRTN_OBJ := $(BUILD_DIR)/crtn.o
CRTBEGIN_OBJ := $(shell i686-elf-gcc $(CFLAGS) -print-file-name=crtbegin.o)
CRTEND_OBJ := $(shell i686-elf-gcc $(CFLAGS) -print-file-name=crtend.o)

KERNEL_OBJS := $(BUILD_DIR)/boot.o $(BUILD_DIR)/kernel.o $(BUILD_DIR)/terminal.o

all: directories iso

directories:
	mkdir -p $(BUILD_DIR) $(ISO_DIR)/boot/grub $(IMAGE_DIR) $(BIN_DIR)

$(BUILD_DIR)/boot.o: $(BASE_PATH)/kernel/arch/i386/boot.s
	i686-elf-as $< -o $@

$(CRTI_OBJ): $(BASE_PATH)/kernel/arch/i386/crti.s
	i686-elf-as $< -o $@

$(CRTN_OBJ): $(BASE_PATH)/kernel/arch/i386/crtn.s
	i686-elf-as $< -o $@

$(BUILD_DIR)/kernel.o: $(BASE_PATH)/kernel/kernel/kernel.c
	i686-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

$(BUILD_DIR)/terminal.o: $(BASE_PATH)/kernel/kernel/terminal.c
	i686-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

$(BIN_DIR)/myos.bin: $(CRTI_OBJ) $(CRTN_OBJ) $(KERNEL_OBJS)
	i686-elf-gcc -T $(BASE_PATH)/kernel/arch/i386/linker.ld -o $@ -ffreestanding -O2 -nostdlib \
		$(CRTI_OBJ) $(CRTBEGIN_OBJ) $(KERNEL_OBJS) $(CRTEND_OBJ) $(CRTN_OBJ) -lgcc

iso: $(BIN_DIR)/myos.bin
	cp $< $(ISO_DIR)/boot/myos.bin
	cp $(BASE_PATH)/config/grub.cfg $(ISO_DIR)/boot/grub/grub.cfg
	i686-elf-grub-mkrescue -o $(IMAGE_DIR)/myos.iso $(ISO_DIR)

clean:
	rm -rf $(BUILD_DIR) $(ISO_DIR) $(IMAGE_DIR) $(BIN_DIR)

.PHONY: all directories iso clean
