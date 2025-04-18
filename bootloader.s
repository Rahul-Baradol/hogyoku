.global _start
.extern kernel_main

.section .text
_start:
    ldr sp, =0x8000
    bl kernel_main

hang:
    b hang
