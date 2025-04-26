#include "../drivers/screen.h"
#include "../kernel/kernel.h"
#include "isr.h"

extern void init_gdt();

void setup() {
    screen_println("Setting up..");
    screen_println("Setting up gdt...");
    init_gdt();

    screen_println("Setting up idt...");
    isr_install();
    screen_println("");

    screen_println("Installing IRQs...");
    irq_install();
    screen_println("");

    screen_println("Starting kernel...");
    kernel_main();  
}