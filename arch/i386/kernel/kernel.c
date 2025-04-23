#include "../drivers/screen.h"
#include "kernel.h"
#include "../../../libc/string.h"

void kernel_main() {
    kprintln("In the kernel now :)\n");
}

void user_input(char *input) {
    kprint("You said: ");
    kprintln(input);
}