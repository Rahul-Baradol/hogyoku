#! /bin/bash

BASE_PATH=/Users/rahulbaradol/Documents/projects/hogyoku

if i686-elf-grub-file --is-x86-multiboot $BASE_PATH/bin/hogyoku.bin; then
  echo multiboot confirmed
else
  echo the file is not multiboot
fi