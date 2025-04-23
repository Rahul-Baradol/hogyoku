#include "../drivers/screen.h"
#include "../kernel/kernel.h"
#include "isr.h"

extern void init_gdt();

void setup() {
    // screen_initialize();
    // println("screen Initialized");

    // println("setting up gdt...\n");
    init_gdt();

    // println("setting up idt...\n");
    isr_install();
    irq_install();

    kprint("starting kernel...");
    kernel_main();
}