[BITS 16]
[ORG 0x7C00]    ; Bootloader will start at 0x7C00 in memory

start:
    cli                 ; Disable interrupts
    xor ax, ax
    mov ds, ax          ; Set DS segment to 0
    mov es, ax          ; Set ES segment to 0

    ; Set up stack (optional, just in case)
    mov ss, ax
    mov sp, 0x7C00

    ; Load kernel (myos.bin) into memory at 0x2000 (as per your linker script)
    ; Let's assume the kernel is 1 sector (512 bytes) in size for simplicity.
    ; You can load multiple sectors based on your kernel size.
    mov ah, 0x02         ; BIOS read sectors
    mov al, 1            ; Read 1 sector
    mov ch, 0            ; Cylinder (CH)
    mov cl, 2            ; Sector (CL, assuming the kernel starts at sector 2)
    mov dh, 0            ; Head (DH)
    mov dl, 0x80         ; Drive (0x80 for first hard drive, use 0x00 for floppy)
    mov bx, 0x2000       ; Memory location to load kernel (0x2000 as per linker script)
    int 0x13             ; BIOS interrupt to read sectors

    ; Check if the disk read was successful (AH=0 means success)
    jc disk_error        ; Jump to error handling if read failed

    ; Jump to the kernel's _start function
    jmp 0x0000:0x2000    ; Jump to _start in kernel (memory address 0x2000)

disk_error:
    ; Handle error (simple hang or display error message)
    mov ah, 0x0E         ; BIOS teletype output function
    mov al, 'E'
    int 0x10             ; BIOS interrupt for output to screen
    mov al, 'R'
    int 0x10
    mov al, 'R'
    int 0x10
    mov al, 'O'
    int 0x10
    mov al, 'R'
    int 0x10
    hlt                  ; Halt the system (in case of error)

; Padding + boot signature (Standard BIOS bootloader signature)
times 510 - ($ - $$) db 0
dw 0xAA55
