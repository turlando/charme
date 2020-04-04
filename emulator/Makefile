AS := arm-none-eabi-as
LD := arm-none-eabi-ld
OC := arm-none-eabi-objcopy
DB := arm-none-eabi-gdb
DD := dd
QE := qemu-system-arm
NC := nc

ASFLAGS := -march armv7-a   \
           -mcpu cortex-a15
DBFLAGS := -ex 'target remote localhost:9990'
QEFLAGS := -cpu cortex-a15                 \
           -machine vexpress-a15           \
           -m 64M                          \
           -nographic                      \
           -audiodev none,id=0             \
           -serial tcp::9991,server,nowait \
           -gdb tcp::9990                  \
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
	$(QE)                                 \
		$(QEFLAGS)                          \
		-drive if=pflash,format=raw,file=$<

.PHONY: gdb
gdb: main.elf
	$(DB) $(DBFLAGS) $<

.PHONY: serial
serial:
	$(NC) localhost 9991

.PHONY: clean
clean:
	$(RM) main.o
	$(RM) main.elf
	$(RM) main.bin
	$(RM) rom.bin
