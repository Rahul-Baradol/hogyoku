Journey to understanding Operating Systems

# Assembling boot.s

`i686-elf-as boot.s -o boot.o`

# Compiling Kernel

`i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra`

# Linking

`i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc`

### Also move this myos.bin to the ./isodir/boot/ folder

# Generating .iso file

`grub2-mkrescue -o myos.iso isodir`

# Running 

`qemu-system-i386 -cdrom myos.iso`
