#! /bin/bash

BASE_PATH=/home/rahulb/osdev

if grub2-file --is-x86-multiboot $BASE_PATH/bin/myos.bin; then
  echo multiboot confirmed
else
  echo the file is not multiboot
fi