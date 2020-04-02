MEMORY {
    rom (rx) : ORIGIN = 0x0,       LENGTH = 64M
    ram (rw) : ORIGIN = 0xF424000, LENGTH = 64M
}

SECTIONS {
    . = 0x0;

    .text : {
        main.o (.text)
    } > rom

    STACK_TOP = 0xF424000;
}

ENTRY(start)
