MEMORY {
    rom (rx)  : ORIGIN = 0x0,        LENGTH = 64M
    ram (rwx) : ORIGIN = 0x80000000, LENGTH = 64M
}

SECTIONS {
    . = 0x0;

    .text : {
        main.o (.text)
    } > rom

    .data : AT (ADDR (.text) + SIZEOF (.text)) {
        main.o (.data);
    } > rom

    STACK_TOP = 0x84000000;
}

ENTRY(start)
