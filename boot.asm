[org 0x7c00]
mov ah, 0x0e

mov bp, 0x8000
mov sp, bp

mov bx, message
call printer

jmp $

%include "printer.asm"

message:
    db "Hello kernel!", 0

times 510-($ - $$) db 0
db 0x55
db 0xaa