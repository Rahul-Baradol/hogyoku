BASE_PATH := /Users/rahulbaradol/Documents/projects/seireitei
BUILD_DIR := $(BASE_PATH)/build
ISO_DIR := $(BASE_PATH)/isodir
IMAGE_DIR := $(BASE_PATH)/image
BIN_DIR := $(BASE_PATH)/bin

CRTI_OBJ := $(BUILD_DIR)/crti.o
CRTN_OBJ := $(BUILD_DIR)/crtn.o
CRTBEGIN_OBJ := $(shell i686-elf-gcc $(CFLAGS) -print-file-name=crtbegin.o)
CRTEND_OBJ := $(shell i686-elf-gcc $(CFLAGS) -print-file-name=crtend.o)

KERNEL_OBJS := $(BUILD_DIR)/gdt.o $(BUILD_DIR)/interrupt.o $(BUILD_DIR)/string.o $(BUILD_DIR)/keyboard.o $(BUILD_DIR)/timer.o $(BUILD_DIR)/port.o $(BUILD_DIR)/isr.o $(BUILD_DIR)/mem.o $(BUILD_DIR)/idt.o $(BUILD_DIR)/boot.o $(BUILD_DIR)/kernel.o $(BUILD_DIR)/screen.o $(BUILD_DIR)/setup.o

all: directories iso

directories:
	mkdir -p $(BUILD_DIR) $(ISO_DIR)/boot/grub $(IMAGE_DIR) $(BIN_DIR)

loader:
	nasm -f bin $(BASE_PATH)/arch/i386/boot/bootloader.asm -o $(BIN_DIR)/bootloader.bin

merge:
	cat $(BIN_DIR)/bootloader.bin $(BIN_DIR)/myos.bin > os.bin

$(BUILD_DIR)/gdt.o: $(BASE_PATH)/arch/i386/boot/gdt.s
	i686-elf-as $< -o $@

$(BUILD_DIR)/interrupt.o: $(BASE_PATH)/arch/i386/boot/interrupt.asm
	nasm -f elf32 $< -o $@

$(BUILD_DIR)/boot.o: $(BASE_PATH)/arch/i386/boot/boot.s
	i686-elf-as $< -o $@

$(CRTI_OBJ): $(BASE_PATH)/arch/i386/boot/crti.s
	i686-elf-as $< -o $@

$(CRTN_OBJ): $(BASE_PATH)/arch/i386/boot/crtn.s
	i686-elf-as $< -o $@

$(BUILD_DIR)/isr.o: $(BASE_PATH)/arch/i386/boot/isr.c
	i686-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

$(BUILD_DIR)/port.o: $(BASE_PATH)/arch/i386/cpu/port.c
	i686-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

$(BUILD_DIR)/timer.o: $(BASE_PATH)/arch/i386/cpu/timer.c
	i686-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

$(BUILD_DIR)/keyboard.o: $(BASE_PATH)/arch/i386/drivers/keyboard.c
	i686-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

$(BUILD_DIR)/mem.o: $(BASE_PATH)/arch/i386/drivers/mem.c
	i686-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

$(BUILD_DIR)/string.o: $(BASE_PATH)/libc/string.c
	i686-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

$(BUILD_DIR)/setup.o: $(BASE_PATH)/arch/i386/boot/setup.c
	i686-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

$(BUILD_DIR)/idt.o: $(BASE_PATH)/arch/i386/boot/idt.c
	i686-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

$(BUILD_DIR)/kernel.o: $(BASE_PATH)/arch/i386/kernel/kernel.c
	i686-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

$(BUILD_DIR)/screen.o: $(BASE_PATH)/arch/i386/drivers/screen.c
	i686-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

$(BIN_DIR)/myos.bin: $(CRTI_OBJ) $(CRTN_OBJ) $(KERNEL_OBJS)
	i686-elf-gcc -T $(BASE_PATH)/arch/i386/linker.ld -o $@ -ffreestanding -O2 -nostdlib \
		$(CRTI_OBJ) $(CRTBEGIN_OBJ) $(KERNEL_OBJS) $(CRTEND_OBJ) $(CRTN_OBJ) -lgcc

iso: $(BIN_DIR)/myos.bin
	cp $< $(ISO_DIR)/boot/myos.bin
	cp $(BASE_PATH)/config/grub.cfg $(ISO_DIR)/boot/grub/grub.cfg
	i686-elf-grub-mkrescue -o $(IMAGE_DIR)/seireitei.iso $(ISO_DIR)

run:
	qemu-system-i386 -monitor stdio -cdrom $(BASE_PATH)/image/seireitei.iso -boot d -m 2G 

clean:
	rm -rf $(BUILD_DIR) $(ISO_DIR) $(IMAGE_DIR) $(BIN_DIR)

.PHONY: all directories iso clean start
