.set ALIGN,    1<<0             /* align loaded modules on page boundaries */
.set MEMINFO,  1<<1             /* provide memory map */
.set FLAGS,    ALIGN | MEMINFO  /* this is the Multiboot 'flag' field */
.set MAGIC,    0x1BADB002       /* 'magic number' lets bootloader find the header */
.set CHECKSUM, -(MAGIC + FLAGS) /* checksum of above, to prove we are multiboot */

.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 1024
.long 768
.long 32

.section .bss
.align 4
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

.section .text
.global _start, clear_interrupts, enable_interrupts

_start:
	mov $stack_top, %esp
	
	# eax stores the magic value set by GRUB and ebx stores the 32 bit physical address of multiboot info structure 
	# pushing the contents of eax and ebx to stack before calling _init, 
	# because crtbegin.o seems to change the contents of the eax register 
	push %ebx
	push %eax
	
	# setup global constructors
	call _init

	call kernel_main

	jmp .

clear_interrupts:
	cli
	ret

enable_interrupts:
	sti
	ret

.size _start, . - _start