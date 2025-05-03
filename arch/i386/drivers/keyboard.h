#ifndef KEYBOARD_H
#define KEYBOARD_H

#include "../../../include/types.h"

#define BACKSPACE 0x0E
#define ENTER 0x1C

extern const char *sc_name[];
extern const char sc_ascii[];

void init_keyboard();

#endif