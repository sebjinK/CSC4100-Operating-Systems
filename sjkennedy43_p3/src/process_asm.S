.section .text
.global dispatch
.global go
.global setup_EVT
.global init_timer
.extern enqueue
.extern dequeue
.extern ready_queue
.extern running
.extern unsupported

go:
    B _restore_context
dispatch:
    msr DAIFSet, #0x2 // no interrupts firiing while process switching
    
    STR X1, [SP, -16]! // SP points to SP_EL1--the operating system stack pointer
                        // X1 points to SP_EL0 -- the process stack pointer
    MRS X1, SP_EL0

    SUB X1, X1, 16*17
        // subtract 16 * 17 from the stack 

    // copy all registers to the stack (in the order x0, x1, ..., x30)
    // STP X0, X1, [X1]
    STR X0,         [X1]
    LDR X0,         [SP], 16
    STR X0,         [X1, 8]
    STP X2, X3,     [X1, 16]
    STP X4, X5,     [X1, 16*2]
    STP X6, X7,     [X1, 16*3]
    STP X8, X9,     [X1, 16*4]
    STP X10, X11,   [X1, 16*5]    
    STP X12, X13,   [X1, 16*6]
    STP X14, X15,   [X1, 16*7]
    STP X16, X17,   [X1, 16*8]
    STP X18, X19,   [X1, 16*9]
    STP X20, X21,   [X1, 16*10]
    STP X22, X23,   [X1, 16*11]
    STP X24, X25,   [X1, 16*12]
    STP X26, X27,   [X1, 16*13]
    STP X28, X29,   [X1, 16*14]
    STR X30,        [X1, 16*15]       

    // put the PSTATE int the stack with the following code:
    mrs x0, SPSR_EL1        // Save PSTATE
    str x0, [X1, 16*15+8]

    mrs x0, ELR_EL1 // save interrupt return address
    str x0, [X1, 16*16]

    // store the new sp value into the pcb which running points -- use .extern in c file to get the right address from assembly
    adr x1, running
    ldr x1, [x1]
    mov x4, sp
    str x4, [x1]

    ADR X0, ready_queue
    BL enqueue //(x0--ReadyQ, x1--Running);
    // fall through into restore_context after branch
_restore_context: //this is where go() jumps to
    //call dequeue (x0 -- ReadyQueue)
    ADR X0, ready_queue
    BL dequeue

    // return value of dequeue goes into Running
    adr		x1, running
    str		x0, [x1]   // store the pointer to the PCB into the Running variable
    ldr		x2, [x0]   // x2 now has the value of the stack ptr (we cant ldr sp directly)
    mov		sp, x2     // sp now has the top of stack for the chosen process

    ldr     x0, [sp, 16*15+8]   // Restore PSTATE
    msr     SPSR_EL1, x0
    ldr     x0, [sp, 16*16]     // Restore Interrupt address
    msr     ELR_EL1, x0

    mov x0, x1
    add x0, x0, 16*17
    MSR SP_EL0, x0

    // load all registers back
    LDP X2, X3,     [X1, 16]
    LDP X4, X5,     [X1, 16*2]
    LDP X6, X7,     [X1, 16*3]
    LDP X8, X9,     [X1, 16*4]
    LDP X10, X11,   [X1, 16*5]
    LDP X12, X13,   [X1, 16*6]
    LDP X14, X15,   [X1, 16*7]
    LDP X16, X17,   [X1, 16*8]
    LDP X18, X19,   [X1, 16*9]
    LDP X20, X21,   [X1, 16*10]
    LDP X22, X23,   [X1, 16*11]
    LDP X24, X25,   [X1, 16*12]
    LDP X26, X27,   [X1, 16*13]
    LDP X28, X29,   [X1, 16*14]


    SUB SP, SP, 16
    STP X0, X1, [X1, 16]
    BL clear_timer
    LDP X0, X1, [SP, 16]
    ADD SP, SP, 16

    LDR X30, [X1, 16*15]

    LDP X0, X1, [X1]

    msr     DAIFClr, #0x2

    eret

setup_EVT:
    // set up the exception vector table
    adr     x0, vector_table 
    msr     VBAR_EL1, x0        // Set the vector base address
    ret

init_timer:
    stp     x29, x30, [sp, -16]!
    bl      clear_timer
    //route core 0 counter to core 0 irq
    ldr     x0, =0x40000040
    mov     x1, 0x08
    str     w1, [x0]
    // enable timer
    mov     x0, 1
    msr     CNTV_CTL_EL0, x0
    ldp     x29, x30, [sp], 16
    ret
clear_timer:
    // read count frequency
    mrs     x0, CNTFRQ_EL0
    mov     x1, 20
    udiv    x0, x0, x1
    // clear cntv interrupt and set next 1 sec timer.
    msr     CNTV_TVAL_EL0, x0
    ret
vector_table:
    .balign 128
        b unsupported
    .balign 128
        b dispatch
    .balign 128
        b unsupported
    .balign 128
        b unsupported
    .balign 128
        b unsupported
    .balign 128
        b dispatch    // yes
    .balign 128
        b unsupported
    .balign 128
        b unsupported
    .balign 128
        b unsupported
    .balign 128
        b dispatch
    .balign 128
        b unsupported
    .balign 128
        b unsupported
    .balign 128
        b unsupported
    .balign 128
        b dispatch
    .balign 128
        b unsupported
    .balign 128
        b unsupported