#include "../drivers/screen.h"
#include "../kernel/kernel.h"
#include "isr.h"

extern void init_gdt();

void setup() {
    screen_initialize();
    println("screen Initialized");

    println("setting up gdt...");
    init_gdt();

    // still need to setup idt
    // the files related to idt do not work yet 

    // this is a checkpoint => where GDT is setup 

    println("starting kernel...");
    kernel_main();
}