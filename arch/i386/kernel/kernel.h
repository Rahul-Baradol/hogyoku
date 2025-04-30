#ifndef KERNEL_H
#define KERNEL_H

void kernel_main();
void accept_input();
void handle_keyboard_input(char *input);

extern void init_gdt();

extern volatile int bankai;

#endif