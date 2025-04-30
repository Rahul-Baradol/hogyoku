#ifndef KERNEL_H
#define KERNEL_H

__attribute__((regparm(0))) void kernel_main(unsigned long magic, unsigned long address);
void accept_input();
void handle_keyboard_input(char *input);

extern void init_gdt();

extern volatile int bankai;

#endif