.section .init
.global _init
.type _init, @function

_init:
    push %ebp
    movl %esp, %ebp

    /* crtbegin's init section would be put here */

.section .fini
.global _finish
.type _finish, @function

_fini:
    push %ebp
    movl %esp, %ebp

    /* crtbegin's fini section would be put here */