#include "kernel.h"

#include "../drivers/screen.h"
#include "../boot/isr.h"
#include "../cpu/timer.h"

#include "../../../libc/string.h"

volatile int bankai = 0;

void accept_input() {
    screen_print("$ ");
}

// toy mode -> making sure interrupts are working fine
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
    
    while (!bankai) {}
    
    volatile u32 base_tick = tick;   

    clear_screen();
    screen_print("GETSUGA...");

    while (tick < base_tick+50) {    }

    screen_println("TENSHO...");

    while (1);
}

void handle_keyboard_input(char *input) {
    if (strcmp(input, "TICK") == 0) {
        screen_println_int(tick);
        screen_println("");
        accept_input();
        return;
    }

    if (strcmp(input, "BANKAI") == 0) {
        bankai = 1;
        return;
    }

    if (strcmp(input, "KATEN KYOKOTSU KARAMATSU SHINJUU") == 0) {
        screen_println("System Halting xD ...");
        asm volatile("hlt");
    }

    screen_print("You said: ");
    screen_println(input);
    screen_println("");
    
    accept_input();
}