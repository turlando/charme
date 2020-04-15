.data

test_string:
.asciz "Test string"


.text

.global start
start:
    ldr sp, =STACK_TOP


main:
    ldr   r0, =test_string    @ Set putstring arg
    bl    putstring           @ Call putstring

    mov   r0, #15             @ Set fib arg
    bl    fib                 @ Call fib

    b     stop                @ Halt CPU


putchar:
    mov   r1, #0x1C000000     @ CS3 base addr
    mov   r2, #0x90000        @ UART0 offset
    strb  r0, [r1, r2]        @ Store r0 in [r1 + r2]
    bx    lr                  @ Return from subroutine


putstring:
    ldrb  r1, [r0]          @ Load content of address in r0 to r1
    cmp   r1, #0            @ Check if char is null terminator
    beq   putstring_end     @ If so go to putstring_end

    push  {r0, lr}          @ Push registers onto stack
    mov   r0, r1            @ Set putchar arg
    bl    putchar           @ Call putchar
    pop   {r0, lr}          @ Pop registers from stack

    add   r0, r0, #1        @ Increment string address
    b     putstring         @ Go to putstring

putstring_end:
    bx lr


fib:
    mov   r1, #0         @ fib(0) = 0
    mov   r2, #1         @ fib(1) = 1

fib_loop:
    add   r3, r1, r2     @ fib(n) = fib(n-1) + fib(n-2)
    mov   r1, r2         @ fib(n-1) = fib(n-2)
    mov   r2, r3         @ fib(n-2) = fib(n)
    subs  r0, r0, #1     @ Decrement R0
    beq   fib_end        @ Branch if R0 is 0
    b     fib_loop       @ Branch always

fib_end:
    mov   r0, r3         @ Save result in R0
    bx    lr             @ Return from subroutine


stop:
    b     stop           @ "halt" CPU
