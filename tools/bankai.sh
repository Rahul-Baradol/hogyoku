#!/bin/bash

BASE_PATH=/home/rahulb/osdev

CRTI_OBJ=$BASE_PATH/build/crti.o
CRTBEGIN_OBJ=$(i686-elf-gcc $CFLAGS -print-file-name=crtbegin.o)
CRTEND_OBJ=$(i686-elf-gcc $CFLAGS -print-file-name=crtend.o)
CRTN_OBJ=$BASE_PATH/build/crtn.o
 
mkdir -p $BASE_PATH/build
mkdir -p $BASE_PATH/isodir/boot/grub
mkdir -p $BASE_PATH/image
mkdir -p $BASE_PATH/bin

i686-elf-as $BASE_PATH/kernel/arch/i386/boot.s -o $BASE_PATH/build/boot.o
i686-elf-as $BASE_PATH/kernel/arch/i386/crti.s -o $BASE_PATH/build/crti.o
i686-elf-as $BASE_PATH/kernel/arch/i386/crtn.s -o $BASE_PATH/build/crtn.o

i686-elf-gcc -c $BASE_PATH/kernel/kernel/kernel.c -o $BASE_PATH/build/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

i686-elf-gcc -T $BASE_PATH/kernel/arch/i386/linker.ld -o $BASE_PATH/bin/myos.bin -ffreestanding -O2 -nostdlib $CRTI_OBJ $CRTBEGIN_OBJ $BASE_PATH/build/boot.o $BASE_PATH/build/kernel.o $CRTEND_OBJ $CRTN_OBJ -lgcc

cp $BASE_PATH/bin/myos.bin $BASE_PATH/isodir/boot/myos.bin
cp $BASE_PATH/config/grub.cfg $BASE_PATH/isodir/boot/grub/grub.cfg

grub2-mkrescue -o $BASE_PATH/image/myos.iso $BASE_PATH/isodir
