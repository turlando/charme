.text

.global start
start:
    ldr sp, =STACK_TOP


main:
    mov   r0, #65        @ Set print arg, 'A'
    bl    putchar        @ Call putchar

    mov   r0, #15        @ Set fib arg
    bl    fib            @ Call fib

    b     stop           @ Halt CPU


putchar:
    mov   r1, #0x1C000000     @ base CS3 addr
    mov   r2, #0x90000        @ UART0 offset
    str   r0, [r1, r2]        @ store r0 in [r1 + r2]
    bx    lr                  @ Return from subroutine


fib:
    mov   r1, #0         @ fib(0) = 0
    mov   r2, #1         @ fib(1) = 1

fib_loop:
    add   r3, r1, r2     @ fib(n) = fib(n-1) + fib(n-2)
    mov   r1, r2         @ fib(n-1) = fib(n-2)
    mov   r2, r3         @ fib(n-2) = fib(n)
    sub   r0, r0, #1     @ Decrement R0
    beq   fib_end        @ Branch if R0 is 0
    b     fib_loop       @ Branch always

fib_end:
    mov   r0, r3         @ Save result in R0
    bx    lr             @ Return from subroutine


stop:
    b     stop           @ "halt" CPU
