

void kernel_main(void) {
    volatile unsigned int *UART0DR = (unsigned int*) 0x101f1000;
    *UART0DR = 'a';
    while (1);
}
