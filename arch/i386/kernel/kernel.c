#include "../drivers/screen.h"
#include "kernel.h"
#include "../../../libc/string.h"
#include "../boot/isr.h"

__attribute__((noreturn)) void kernel_nop_loop() {
    while (1) {}
}

__attribute__((noreturn)) void kernel_main() {
    screen_println("(toy mode)");
    screen_print("kernel is live :)\n\n");
        
    screen_println("Setting up gdt...");
    init_gdt();

    screen_println("Setting up idt...");
    isr_install();
    screen_println("");

    screen_println("Installing IRQs...");
    irq_install();
    screen_println("");

    screen_print("use Shunsui's bankai to halt the system\n\n");

    screen_print("$ ");
    
    kernel_nop_loop();
}

void accept_input() {
    screen_print("$ ");
}

void handle_keyboard_input(char *input) {
    if (strcmp(input, "KATEN KYOKOTSU KARAMATSU SHINJUU") == 0) {
        screen_println("System Halting xD ...");
        asm volatile("hlt");
    }
    screen_print("You said: ");
    screen_println(input);
    screen_println("");
    
    accept_input();
}