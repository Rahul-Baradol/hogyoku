#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include "../include/screen.h"
#include "../include/idt.h"

/* Check if the compiler thinks you are targeting the wrong operating system. */
#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

/* This tutorial will only work for the 32-bit ix86 targets. */
#if !defined(__i386__)
#error "Source needs to be compiled with a ix86-elf compiler"
#endif

void kernel_main(void) {
	setup_idt();
	
	terminal_initialize();

	terminal_writestring("Bankai!\n\nGetsugatensho...\n");
	terminal_writestring("Mugetsu!\n\n");
}