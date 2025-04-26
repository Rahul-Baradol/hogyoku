.section .text
.global init_gdt

gdt_start: 
    .quad 0x0000000000000000

gdt_code: 
    .word 0xffff    
    .word 0x0       
    .byte 0x0       
    .byte 0x9A # 10011010b 
    .byte 0xCF # 11001111b 
    .byte 0x0       

gdt_data:
    .word 0xffff
    .word 0x0
    .byte 0x0
    .byte 0x92 # 10010010b
    .byte 0xCF # 11001111b
    .byte 0x0

gdt_end:

gdt_descriptor:
    .word gdt_end - gdt_start - 1 
    .long gdt_start 

.set CODE_SEGMENT, gdt_code - gdt_start
.set DATA_SEG, gdt_data - gdt_start

init_gdt:
    lgdt gdt_descriptor

    movl %cr0, %eax
    orl $0x1, %eax           # Set PE (Protection Enable) bit
    movl %eax, %cr0

    ljmp $CODE_SEGMENT, $init_pm  # Far jump to flush pipeline

init_pm:
    movw $DATA_SEG, %ax      # Reload segment registers with data segment
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss

    ret