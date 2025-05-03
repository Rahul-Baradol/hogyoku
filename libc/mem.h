#ifndef MEM_H
#define MEM_H

#include <stdint.h>
#include "../include/types.h"

#define MEMORY_START 0x00300000

extern uint32_t free_memory_pointer;

void memory_copy(u8 *source, u8 *dest, int nbytes);
void memory_set(u8 *dest, u8 val, u32 len);

// toy memory allocator
uint8_t* kmalloc();

#endif
