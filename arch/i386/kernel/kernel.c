#include "stdbool.h"

#include "kernel.h"

#include "../drivers/screen.h"
#include "../drivers/keyboard.h"
#include "../boot/isr.h"
#include "../boot/multiboot.h"
#include "../cpu/timer.h"

#include "../../../libc/string.h"

#define KEY_BUFFER_LENGTH 256

extern void enable_paging();

volatile bool bankai = 0;
volatile bool keyboard_lock = 0;

static char key_buffer[KEY_BUFFER_LENGTH];

void accept_input() {
    screen_print("$ ");
}

__attribute__((regparm(0))) void kernel_main(unsigned long magic, unsigned long address) {
    if (magic != MULTIBOOT_BOOTLOADER_MAGIC) {
        screen_print("Invalid magic value, found ");
        screen_println_int(magic);
        return;
    }

    screen_println("Magic value matched...\n");
    screen_println("Kernel is live :)\n");

    multiboot_info_t *boot_info = (multiboot_info_t*) address;

    screen_println("------ MULTIBOOT INFORMATION ------\n");

    screen_print("lower memory found ");
    screen_println_int(boot_info -> mem_lower);

    screen_print("upper memory found ");
    screen_println_int(boot_info -> mem_upper);

    screen_print("mmap length found ");
    screen_println_int(boot_info -> mmap_length);

    screen_println("\n-------------- SETUP --------------\n");

    screen_println("Setting up gdt...");
    init_gdt();

    screen_println("Setting up idt...");
    isr_install();
    screen_println("");

    screen_println("Installing IRQs...");
    irq_install();

    screen_println("\n------------------------------------\n");

    screen_println("fire BANKAI, to explore soul society");
    screen_print("use Shunsui's bankai to halt the system\n\n");

    accept_input();

    // stopping here, to check if timer and keyboard interrupt handlers are working properly
    while (!bankai) {}
    
    volatile u32 base_tick = tick;   

    clear_screen();
    screen_print("GETSUGA...");

    while (tick < base_tick+50) {    }

    screen_println("TENSHO...");
    
    while (tick < base_tick+100) {    }

    // Enable Paging
    screen_println("\nEnabling Paging...");
    enable_paging();
    screen_println("Paging enabled!\n");
}

void handle_keyboard_enter(char *input) {
    if (strcmp(input, "TICK") == 0) {
        screen_println_int(tick);
        screen_println("");
        accept_input();
        return;
    }

    if (strcmp(input, "BANKAI") == 0) {
        bankai = 1;
        keyboard_lock = 1;
        clear_interrupts();
        return;
    }

    if (strcmp(input, "KATEN KYOKOTSU KARAMATSU SHINJUU") == 0) {
        screen_println("System Halting xD ...");
        asm volatile("hlt");
    }

    // if (!bankai) {
        screen_print("You said: ");
        screen_println(input);
        screen_println("");
        
        accept_input();
    // }
}

void handle_keyboard_input(u8 scancode) {
    if (keyboard_lock) return;

    if (scancode == BACKSPACE) {
        backspace(key_buffer);
        screen_backspace();
        return;
    } 
    
    if (scancode == ENTER) {
        screen_print("\n");
        handle_keyboard_enter(key_buffer); 
        key_buffer[0] = '\0';
        return;
    }

    if (strlen(key_buffer) >= KEY_BUFFER_LENGTH) {
        screen_print("\n[+] Key Buffer could be of 256 length max\n\n");
        key_buffer[0] = '\0';
        accept_input();
        return;
    }

    if (strlen(key_buffer) >= KEY_BUFFER_LENGTH) {
        screen_print("\n[+] Key Buffer could be of 256 length max\n\n");
        key_buffer[0] = '\0';
        accept_input();
        return;
    }

    char letter = sc_ascii[(int)scancode];
    
    char str[2] = {letter, '\0'};
    append(key_buffer, letter);
    screen_print(str);
}