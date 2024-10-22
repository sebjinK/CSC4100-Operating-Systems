section .text:
.global _dispatch
.global go
.extern enqueue
.extern ready_queue
.extern stacks
.extern running
_dispatch:
    SUB SP, SP, 256; subtract 16 * 16 from the stack 
    ; copy all registers to the stack (in the order x0, x1, ..., x30)
    STP X0, X1, [SP]
    STP X2, X3, [SP, 16]
    STP X4, X5, [SP, 32]
    STP X6, X7, [SP, 48]
    STP X8, X9, [SP, 64]
    STP X10, X11, [SP, 80]    
    STP X12, X13, [SP, 96]
    STP X13, X14, [SP, 112]
    STP X15, X16, [SP, 128]
    STP X17, X18, [SP, 144]
    STP X19, X20, [SP, 160]
    STP X21, X22, [SP, 176]
    STP X23, X24, [SP, 192]
    STP X25, X26, [SP, 208]
    STP X27, X28, [SP, 224]
    STP X29, X30, [SP, 240]
    STP X31, X32, [SP, 256]        
    ; put the PSTATE int the stack with the following code:
;   mrs x0, SPSR_EL1        // Save PSTATE
;   str x0, [sp, 16*15+8]
    ; store the new sp value into the pcb which running points -- use .extern in c file to get the right address from assembly
    ; (note that you cannot move sp into memory directly)
    ; you hav  to do something like:
;   adr x1, Running
;   ldr x1, [x1]
;   mov x4, sp
;   str x4, [x1]
    ; call enqueue(x0--ReadyQ, x1--Running);
go:
    b restore_context
restore_context: //this is where go() jumps to
    ; call dequeue(x0 -- ReadQ)
    ; mov [Running], x0 ; return value of dequeue goes into Running
    ; 
