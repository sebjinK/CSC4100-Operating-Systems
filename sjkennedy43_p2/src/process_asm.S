.section .text
.global dispatch
.global go
.extern enqueue
.extern dequeue
.extern ready_queue
.extern running
go:
    B _restore_context
dispatch:
    // subtract 16 * 16 from the stack 
    // copy all registers to the stack (in the order x0, x1, ..., x30)
    SUB SP, SP, 256
    STP X0, X1, [SP]
    STP X2, X3, [SP, 16]
    STP X4, X5, [SP, 16*2]
    STP X6, X7, [SP, 16*3]
    STP X8, X9, [SP, 16*4]
    STP X10, X11, [SP, 16*5]    
    STP X12, X13, [SP, 16*6]
    STP X14, X15, [SP, 16*7]
    STP X16, X17, [SP, 16*8]
    STP X18, X19, [SP, 16*9]
    STP X20, X21, [SP, 16*10]
    STP X22, X23, [SP, 16*11]
    STP X24, X25, [SP, 16*12]
    STP X26, X27, [SP, 16*13]
    STP X28, X29, [SP, 16*14]
    STR X30, [SP, 16*15]       
    // put the PSTATE int the stack with the following code:
    mrs x0, SPSR_EL1        // Save PSTATE
    str x0, [sp, 16*15+8]
    // store the new sp value into the pcb which running points -- use .extern in c file to get the right address from assembly
    // (note that you cannot move sp into memory directly)
    // you hav  to do something like:
    adr x1, running
    ldr x1, [x1]
    mov x4, sp
    str x4, [x1]
    

    ADR X0, ready_queue
    // STR X0, [SP]
    // STR X1, [SP, 16]
    BL enqueue //(x0--ReadyQ, x1--Running);

_restore_context: //this is where go() jumps to
    // STP X29, X30, [SP, -16]!
    
    //call dequeue (x0 -- ReadyQueue)
    ADR X0, ready_queue
    // STR X0, [SP]
    BL dequeue


    //mov running, [X0] // return value of dequeue goes into Running

    adr		x1, running
    str		x0, [x1]   // store the pointer to the PCB into the Running variable
    ldr		x2, [x0]   // x2 now has the value of the stack ptr (we cant ldr sp directly)
    mov		sp, x2     // sp now has the top of stack for the chosen process

    ldr     x0, [sp, 16*15+8]   // Restore PSTATE
    msr     SPSR_EL1, x0

    LDP X0, X1, [SP]
    LDP X2, X3, [SP, 16]
    LDP X4, X5, [SP, 16*2]
    LDP X6, X7, [SP, 16*3]
    LDP X8, X9, [SP, 16*4]
    LDP X10, X11, [SP, 16*5]
    LDP X12, X13, [SP, 16*6]
    LDP X14, X15, [SP, 16*7]
    LDP X16, X17, [SP, 16*8]
    LDP X18, X19, [SP, 16*9]
    LDP X20, X21, [SP, 16*10]
    LDP X22, X23, [SP, 16*11]
    LDP X24, X25, [SP, 16*12]
    LDP X26, X27, [SP, 16*13]
    LDP X28, X29, [SP, 16*14]
    LDR X30, [SP, 16*15]
    ADD SP, SP, 256

    // LDP X29, X30, [SP], 16
    RET