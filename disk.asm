[org 0x7c00]

mov bp, 0x8000 
mov sp, bp

mov bx, 0x4000 

mov ah, 0x02
mov al, 2

mov cl, 0x02
mov ch, 0x00

mov dh, 0x00 
int 0x13      
jc disk_error 

mov bx, 0x4000
mov dx, [0x4000] ; retrieve the first loaded word, 0xdada
call print_hex

jmp $

disk_error:
    mov bx, error_msg
    call print
    jmp $

error_msg:
    db "disk error", 0

%include "printer.asm"
%include "printer_hex.asm"

times 510 - ($ - $$) db 0
dw 0xaa55

times 256 dw 0xdada
times 256 dw 0xface