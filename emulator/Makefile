AS := arm-none-eabi-as
LD := arm-none-eabi-ld
OC := arm-none-eabi-objcopy
DB := arm-none-eabi-gdb
DD := dd
QE := qemu-system-arm
NC := nc

GDBPORT    := 9900
SERIALPORT := 9901

ASFLAGS := -march armv7-a   \
           -mcpu cortex-a15

# FIXME: very nasty hack to make GDB slightly more
# usable by default.
# Q: Why isn't this in .gdbinit?
# A: Because the GDB safety policy requres you to flag
#    the current directory as safe before being able to
#    use the .gdbinit file.
# Q: Why is pagination disabled?
# A: Because it shows an annoying question upon startup.
#    It breaks pagination (of course).
# Q: Why si and then disass?
# A: Because otherwise GDB will not show the assembly code
#    (not sure why though). The instruction pointer is still
#    set to 0x0 at startup (again, not really sure why).
DBFLAGS := -ex 'target remote localhost:$(GDBPORT)' \
           -ex 'set pagination off'                 \
           -ex 'tui enable'                         \
           -ex 'layout split'                       \
           -ex 'layout next' -ex 'layout next'      \
           -ex 'si' -ex 'disass'

QEFLAGS := -cpu cortex-a15                          \
           -machine vexpress-a15                    \
           -m 64M                                   \
           -nographic                               \
           -audiodev none,id=0                      \
           -serial tcp::$(SERIALPORT),server,nowait \
           -gdb tcp::$(GDBPORT)                     \
           -S

main.o: main.s
	$(AS) -o $@ $<

main.elf: main.ld main.o
	$(LD) -T $^ -o $@

main.bin: main.elf
	$(OC) -O binary $< $@

rom.bin: main.bin
	$(DD) if=/dev/zero of=$@ bs=64M count=1
	$(DD) if=$< of=$@ bs=4K conv=notrunc

.PHONY: run
run: rom.bin
	$(QE) $(QEFLAGS) -drive if=pflash,format=raw,file=$<

.PHONY: gdb
gdb: main.elf
	$(DB) $(DBFLAGS) $<

.PHONY: serial
serial:
	$(NC) localhost $(SERIALPORT)

.PHONY: clean
clean:
	$(RM) main.o
	$(RM) main.elf
	$(RM) main.bin
	$(RM) rom.bin
