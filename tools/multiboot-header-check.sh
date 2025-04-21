#! /bin/bash

BASE_PATH=/Users/rahulbaradol/Documents/projects/seireitei

if i686-elf-grub-file --is-x86-multiboot $BASE_PATH/bin/myos.bin; then
  echo multiboot confirmed
else
  echo the file is not multiboot
fi