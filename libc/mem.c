#include "mem.h"

uint32_t free_memory_pointer = MEMORY_START;

void memory_copy(u8 *source, u8 *dest, int nbytes) {
    int i;
    for (i = 0; i < nbytes; i++) {
        *(dest + i) = *(source + i);
    }
}

void memory_set(u8 *dest, u8 val, u32 len) {
    u8 *temp = (u8 *)dest;
    for ( ; len != 0; len--) *temp++ = val;
}

// toy memory allocator - works for now x)
uint8_t* kmalloc() {
    uint8_t *cur_pointer = (uint8_t*) free_memory_pointer;
    free_memory_pointer++;
    return cur_pointer;
} 