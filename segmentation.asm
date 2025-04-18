

mov ah, 0x0e
mov bx, 0x7c0
mov es, bx
mov al, [es:message]
int 0x10

jmp $

message:
    db "hello!"

times 510-($ - $$) db 0
dw 0xaa55