#include "../drivers/screen.h"
#include "../kernel/kernel.h"

void setup() {
    screen_initialize();
    print("screen Initialized\n");

    kernel_main();
}