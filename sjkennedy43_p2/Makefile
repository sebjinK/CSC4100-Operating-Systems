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
OBJS=kernel.o queue.o process.o boot.o box.o process_asm.o libos.a 

# source files 
KERNEL_SRC=kernel.c
QUEUE_SRC=queue.c
PROCESS_SRC=s=process.c
BOOT_SRC=boot.S
BOX_SRC=box.S
PROCESS_ASM_SRC=process_asm.s

# make kernel.elf our target
all: $(TARGET)
# kernel.elf should be made with all object files
$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@
# kernel.o object should be compiled with kernel.c and CFLAGS
kernel.o: $(KERNEL_SRC)
	$(CC) $(CFLAGS) $< -o $@
# boot.o object should be compiled with boot.S and ASFLAGS
boot.o: $(BOOT_SRC)
	$(CC) $(ASFLAGS) -c $< -o $@
# box.o object should be compiled with box.S and ASFLAGS
box.o: $(BOX_SRC)
	$(CC) $(ASFLAGS) -c $< -o $@
# queue.o object should be compiled with queue.c, queue.h and CFLAGS
queue.o: $(QUEUE_SRC)
	$(CC) $(CFLAGS) -c $< -o $@
# process.o object should be compiled with process.c, process.h and CFLAGS
process.o: $(PROCESS_SRC)
	$(CC) $(CFLAGS) -c $< -o $@
# process_asm.o object should be compiled with process_asm.S and ASFLAGS
process_asm.o: $(PROCESS_ASM_SRC)
	$(CC) $(ASFLAGS) -c $< -o $@

# run using the target as a dependency
run: $(TARGET)
	$(QEMU) -machine $(MACHINE) -kernel $<

# debug using the target as a dependency; use & to run two commands at once 
debug: $(TARGET)
	$(QEMU) -machine $(MACHINE) -S -s -kernel $< &
	ddd --debugger '$(GDB) -ex "target remote localhost:1234" -ex "break main" -ex "continue"' $<

# delete all possible object files, .elf files, and .d dependency files 
clean:
	rm *.o *.elf *.d