CROSS_COMPILE = arm-none-eabi-

all: kernel.img

bootloader.o: bootloader.s
	$(CROSS_COMPILE)as -o $@ $<

kernel.o: kernel.c
	$(CROSS_COMPILE)gcc -ffreestanding -c -o $@ $<

kernel.elf: bootloader.o kernel.o | linker.ld
	$(CROSS_COMPILE)ld -T linker.ld -o $@ $^

kernel.img: kernel.elf
	$(CROSS_COMPILE)objcopy -O binary $< $@

clean:
	rm -f *.o *.elf *.img
