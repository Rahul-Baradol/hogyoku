#!/bin/bash

BASE_PATH=/home/rahulb/osdev/

mkdir -p $BASE_PATH/build
mkdir -p $BASE_PATH/isodir/boot/grub
mkdir -p $BASE_PATH/image
mkdir -p $BASE_PATH/bin

i686-elf-as $BASE_PATH/kernel/boot.s -o $BASE_PATH/build/boot.o

i686-elf-gcc -c $BASE_PATH/kernel/kernel.c -o $BASE_PATH/build/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

i686-elf-gcc -T $BASE_PATH/tools/linker.ld -o $BASE_PATH/bin/myos.bin -ffreestanding -O2 -nostdlib $BASE_PATH/build/boot.o $BASE_PATH/build/kernel.o -lgcc

cp $BASE_PATH/bin/myos.bin $BASE_PATH/isodir/boot/myos.bin
cp $BASE_PATH/config/grub.cfg $BASE_PATH/isodir/boot/grub/grub.cfg

grub2-mkrescue -o $BASE_PATH/image/myos.iso $BASE_PATH/isodir
