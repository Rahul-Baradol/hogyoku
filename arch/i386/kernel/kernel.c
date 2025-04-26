#include "../drivers/screen.h"
#include "kernel.h"
#include "../../../libc/string.h"

__attribute__((noreturn)) void kernel_nop_loop() {
    while (1) {}
}

__attribute__((noreturn)) void kernel_main() {
    kprintln("In the kernel now :)\n");
    
    kernel_nop_loop();
}

void user_input(char *input) {
    if (strcmp(input, "END") == 0) {
        kprintln("ENDING...");
        asm volatile("hlt");
    }
    kprint("You said: ");
    kprintln(input);
}