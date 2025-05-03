.section .text
.global corrupt_kernel_memory

corrupt_kernel_memory:
    xor %ecx, %ecx
    mov $0x00200000, %edx 
    comedy:
        movl $0x12345678, (%edx,%ecx,1)    
        movl (%edx,%ecx,1), %eax           
        inc %ecx
        cmp $0x002A0000, %ecx
        jne comedy

    ret