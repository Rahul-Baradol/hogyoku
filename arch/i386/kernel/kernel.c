#include "../drivers/screen.h"
#include "kernel.h"
#include "../../../libc/string.h"

__attribute__((noreturn)) void kernel_nop_loop() {
    while (1) {}
}

__attribute__((noreturn)) void kernel_main() {
    screen_println("In the kernel now :)\n");
    
    kernel_nop_loop();
}

void user_input(char *input) {
    if (strcmp(input, "END") == 0) {
        screen_println("ENDING...");
        asm volatile("hlt");
    }
    screen_print("You said: ");
    screen_println(input);
}