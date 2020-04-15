# charme emulator

## Prerequisites

* make
* nc
* qemu-system-arm
* arm-none-eabi-gcc
* arm-none-eabi-binutils
* arm-none-eabi-gdb

## Usage

* `make run` compile and execute `main.s`
* `make serial` run the serial monitor
* `make gdb` run the debugger

The CPU will start in an halt state. GDB is required to step through
the instructions.

## GDB for the impatient
`
* Show content of registers r0, r1 and r5
  * info registers r0 r1 r5
  * i r r0 r1 r5
* Step single instruction:
  * stepi
  * si
* Show assembly
  * disassemble
  * disass
