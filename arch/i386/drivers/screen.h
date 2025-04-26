#ifndef SCREEN_H
#define SCREEN_H

#include "../../../include/types.h"

#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_ON_BLACK 0x0f
#define RED_ON_WHITE 0xf4

/* Screen i/o ports */
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

/* Public kernel API */
void clear_screen();
void screen_print_at(char *message, int col, int row);
void screen_print(char *message);
void screen_println(char *message);
void screen_print_int(int num);
void screen_println_int(int num);
void screen_backspace();

#endif
