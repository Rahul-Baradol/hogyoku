.section .data
.global gdt_descriptor
.global CODE_SEG
.global DATA_SEG

gdt_start:
    .long 0x0        # First 4 bytes of null descriptor
    .long 0x0        # Second 4 bytes of null descriptor

gdt_code:
    .word 0xffff     # Limit bits 0-15
    .word 0x0000     # Base bits 0-15
    .byte 0x00       # Base bits 16-23
    .byte 0x9A       # Access byte: 10011010b
    .byte 0xCF       # Flags (4 bits) + Limit bits 16-19
    .byte 0x00       # Base bits 24-31

gdt_data:
    .word 0xffff
    .word 0x0000
    .byte 0x00
    .byte 0x92       # Access byte: 10010010b
    .byte 0xCF
    .byte 0x00

gdt_end:

gdt_descriptor:
    .word gdt_end - gdt_start - 1  # Limit (size - 1)
    .long gdt_start                # Address of GDT

# Constants for code and data segment selectors (offsets)
CODE_SEG = gdt_code - gdt_start
DATA_SEG = gdt_data - gdt_start
