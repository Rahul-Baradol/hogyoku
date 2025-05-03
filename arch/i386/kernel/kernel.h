#ifndef KERNEL_H
#define KERNEL_H

#include "stdbool.h"
#include "../../../include/types.h"

__attribute__((regparm(0))) void kernel_main(unsigned long magic, unsigned long address);
void accept_input();
void handle_keyboard_input(u8 scancode);
void handle_keyboard_enter(char *input);

extern void init_gdt();
extern void clear_interrupts();

extern volatile bool bankai;
extern volatile bool keyboard_lock;

#endif