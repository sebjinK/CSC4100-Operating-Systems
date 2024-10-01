# make
CC = aarch64-linux-gnu-gcc
LD = aarch64-linux-gnu-ld
# run
QEMU = qemu-system-aarch64
# debug
GDB = gdb-multiarch

# make flags (CFLAGS - C compiler, ASFLAGS - ASM run, LDFLAGS - Linker)
CFLAGS = -g -pedantic -Wall -Wextra -fPIC -std=gnu2x -MMD -c
ASFLAGS = -g -MMD
LDFLAGS = -g -N -Ttext=0x10000

# specify machine for qemu
MACHINE=raspi3b

# set up the big target that we want to run correctly
TARGET=kernel.elf

# Object files made from source files
OBJS=kernel.o boot.o box.o libos.a 

# source files 
KERNEL_SRC=kernel.c
BOOT_SRC=boot.S
BOX_SRC=box.S

# make kernel.elf our target
all: $(TARGET)

# kernel.elf should be made with all object files
$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

# kernel.o object should be compiled with kernel.c and CFLAGS
kernel.o: $(KERNEL_SRC)
	$(CC) $(CFLAGS) $(KERNEL_SRC) -o $@
# boot.o object should be compiled with boot.S and ASFLAGS
boot.o: $(BOOT_SRC)
	$(CC) $(ASFLAGS) -c $(BOOT_SRC) -o $@
# box.o object should be compiled with box.S and ASFLAGS
box.o: $(BOX_SRC)
	$(CC) $(ASFLAGS) -c $(BOX_SRC) -o $@
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