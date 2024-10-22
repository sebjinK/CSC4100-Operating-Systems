section .text:
.global _dispatch
.global go

_dispatch:
    ; subtract 16 * 16 from the stack 
    ; copy all registers to the stack (in the order x0, x1, ..., x30)
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
