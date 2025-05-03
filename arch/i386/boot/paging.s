.section .bss
.align 4096

page_directory:
    .skip 4096

page_table:
    .skip 4096

.section .text
.global enable_paging, test_paging

enable_paging:
    lea page_directory, %eax
    lea page_table, %ebx

    xor %ecx, %ecx

    fill_table:
        mov %ecx, %edx
        shl $12, %edx
        or $0x3, %edx
        mov %edx, (%ebx, %ecx, 4)
        inc %ecx
        cmp $1024, %ecx
        jne fill_table

    mov %ebx, %edx
    or $0x3, %edx
    mov %edx, (%eax)

    mov %eax, %cr3

    mov %cr0, %edx
    or $0x80000001, %edx
    mov %edx, %cr0

    ret
