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
