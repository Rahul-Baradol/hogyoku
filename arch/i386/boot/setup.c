#include "../drivers/screen.h"
#include "../kernel/kernel.h"
#include "isr.h"

extern void init_gdt();

void setup() {
    kprintln("Setting up..");
    kprintln("Setting up gdt...");
    init_gdt();

    kprintln("Setting up idt...");
    isr_install();
    kprintln("");

    kprintln("Installing IRQs...");
    irq_install();
    kprintln("");

    kprintln("Starting kernel...");
    kernel_main();  
}