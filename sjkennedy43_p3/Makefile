# make
CC=aarch64-linux-gnu-gcc
LD=aarch64-linux-gnu-ld
# run
QEMU=qemu-system-aarch64
# debug
GDB=gdb-multiarch

# make flags (CFLAGS - C compiler, ASFLAGS - ASM run, LDFLAGS - Linker)
CFLAGS=-g -pedantic -Wall -Wextra -fPIC -std=gnu2x -MMD -c
ASFLAGS=-g -MMD
LDFLAGS=-g -N -Ttext=0x10000

# specify machine for qemu
MACHINE=raspi3b

# set up the big target that we want to run correctly
TARGET=kernel.elf

# Object files made from source files
OBJS=./obj/boot.o ./obj/kernel.o ./obj/queue.o ./obj/process.o ./obj/libos.a ./obj/box.o ./obj/process_asm.o 

# source files 
KERNEL_SRC=./src/kernel.c
QUEUE_SRC=./src/queue.c
PROCESS_SRC=./src/process.c
BOOT_SRC=./src/boot.S
BOX_SRC=./src/box.S
PROCESS_ASM_SRC=./src/process_asm.S

# make kernel.elf our target
all: $(TARGET)
# kernel.elf should be made with all object files
$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@
# kernel.o object should be compiled with kernel.c and CFLAGS
./obj/kernel.o: $(KERNEL_SRC)
	$(CC) $(CFLAGS) $< -o $@
# boot.o object should be compiled with boot.S and ASFLAGS
./obj/boot.o: $(BOOT_SRC)
	$(CC) $(ASFLAGS) -c $< -o $@
# box.o object should be compiled with box.S and ASFLAGS
./obj/box.o: $(BOX_SRC)
	$(CC) $(ASFLAGS) -c $< -o $@
# queue.o object should be compiled with queue.c, queue.h and CFLAGS
./obj/queue.o: $(QUEUE_SRC)
	$(CC) $(CFLAGS) -c $< -o $@
# process.o object should be compiled with process.c, process.h and CFLAGS
./obj/process.o: $(PROCESS_SRC)
	$(CC) $(CFLAGS) -c $< -o $@
# process_asm.o object should be compiled with process_asm.S and ASFLAGS
./obj/process_asm.o: $(PROCESS_ASM_SRC)
	$(CC) $(ASFLAGS) -c $< -o $@

# run using the target as a dependency
run: $(TARGET)
	$(QEMU) -machine $(MACHINE) -kernel $<

# debug using the target as a dependency; use & to run two commands at once 
debug: $(TARGET)
	$(QEMU) -machine $(MACHINE) -S -s -kernel $< &
	ddd --debugger '$(GDB) -ex "target remote localhost:1234" -ex "break _restore_context" -ex "continue"' $<

# delete all possible object files, .elf files, and .d dependency files 
clean:
	rm ./obj/*.o *.elf ./obj/*.d core