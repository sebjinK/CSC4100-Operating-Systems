#include "process.h"
int create_process(int (*code_address)())// code_address is the pointer to thfuncitons that conaints the process code
{
    static uint32_t next_pid = 0;
    uint64_t stackPointer[1024] = allocStack();
    if (!stackPointer) // if (stackPointer == NULL)
        return -1;
    
    // set sp to stackptr + 1024 to put sp at the bottom of the stack;
    uint32_t * sp = (uint32_t) (stackPointer + 1024);

    for (int i = 0; i <= 32; i++)
    {
        sp--;// decrement sp
        *sp = 0;// set uint64_t at which sp points to 0
    }
    
    // sp[*sp + 30] = (uint64_t)code_address();// [sp + 30] to code_address (type cast as uint64_t so compiler doesn't complain)
    // ^^^^^^ ASK ROGERS ABOUT THIS ^^^^^^
    PCB_t * pcb = allocPCB();// pcb = allocPCB() // return a pointer back to pcb
    if (!pcb)
        return -1;// check if the pcb doesn't exist
    pcb->sp = (uint64_t) sp;// pcb.sp = sp at the top of the stack
    pcb->pid = next_pid++;// pcb.pid = nextPID; // you can keep track of next_pid using next_pid =0 and next_Pid++;

    enqueue(&ready_queue, pcb);

    return 0;


}