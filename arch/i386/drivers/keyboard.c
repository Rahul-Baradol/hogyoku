#include "../kernel/kernel.h"

#include "keyboard.h"
#include "screen.h"
#include "stdbool.h"

#include "../cpu/port.h"
#include "../boot/isr.h"

#include "../../../libc/string.h"
#include "../../../libc/function.h"
#include "../../../libc/mem.h"

#define BACKSPACE 0x0E
#define ENTER 0x1C
#define KEY_BUFFER_LENGTH 256

static char key_buffer[KEY_BUFFER_LENGTH];

#define SC_MAX 57
const char *sc_name[] = { "ERROR", "Esc", "1", "2", "3", "4", "5", "6", 
    "7", "8", "9", "0", "-", "=", "Backspace", "Tab", "Q", "W", "E", 
        "R", "T", "Y", "U", "I", "O", "P", "[", "]", "Enter", "Lctrl", 
        "A", "S", "D", "F", "G", "H", "J", "K", "L", ";", "'", "`", 
        "LShift", "\\", "Z", "X", "C", "V", "B", "N", "M", ",", ".", 
        "/", "RShift", "Keypad *", "LAlt", "Spacebar"};
const char sc_ascii[] = { '?', '?', '1', '2', '3', '4', '5', '6',     
    '7', '8', '9', '0', '-', '=', '?', '?', 'Q', 'W', 'E', 'R', 'T', 'Y', 
        'U', 'I', 'O', 'P', '[', ']', '?', '?', 'A', 'S', 'D', 'F', 'G', 
        'H', 'J', 'K', 'L', ';', '\'', '`', '?', '\\', 'Z', 'X', 'C', 'V', 
        'B', 'N', 'M', ',', '.', '/', '?', '?', '?', ' '};

bool is_key_pressed(int scancode) {
    return (scancode & 0x80) == 0;
}

static void keyboard_callback(registers_t regs) {
    /* The PIC leaves us the scancode in port 0x60 */
    u8 scancode = port_byte_in(0x60);

    if (!is_key_pressed(scancode)) {
        return;
    }

    if (scancode == BACKSPACE) {
        backspace(key_buffer);
        screen_backspace();
        UNUSED(regs);
        return;
    } 
    
    if (scancode == ENTER) {
        screen_print("\n");
        handle_keyboard_input(key_buffer); 
        key_buffer[0] = '\0';
        UNUSED(regs);
        return;
    }

    if (strlen(key_buffer) >= KEY_BUFFER_LENGTH) {
        screen_print("\n[+] Key Buffer could be of 256 length max\n\n");
        key_buffer[0] = '\0';
        accept_input();
        UNUSED(regs);
        return;
    }
    
    char letter = sc_ascii[(int)scancode];
    
    char str[2] = {letter, '\0'};
    append(key_buffer, letter);
    screen_print(str);
    
    UNUSED(regs);
}

void init_keyboard() {
    screen_println("Initializing keyboard...");
    register_interrupt_handler(IRQ1, keyboard_callback); 
}
