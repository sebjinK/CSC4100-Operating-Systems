#include "queue.h"
#include "process.h"
int create_process(int (*code_address)())// code_address is the pointer to thfuncitons that conaints the process code
{
    static uint32_t next_pid = 0; // set up static pid that will advance with each additional process
    uint64_t * stackPointer = allocStack(); // set up stack pointer 
    if (!stackPointer) // if (stackPointer == NULL)
        return -1;
    // set sp to stackptr + 1024 to put sp at the bottom of the stack;
    uint64_t * sp = stackPointer + 1024; 

    for (int i = 0; i <= 32; i++) // for all 32 registers
    {
        sp--;// decrement sp
        *sp = 0;// set uint64_t at which sp points to 0
    }
    sp[30] = (uint64_t)code_address;// [sp + 30] to code_address (type cast as uint64_t so compiler doesn't complain)
    PCB_t * pcb = allocPCB();// allocates a pcb within the stack
    if (!pcb)
        return -1;// check if the pcb doesn't exist
    pcb->sp = sp;// pcb.sp = sp at the top of the stack
    pcb->pid = next_pid++;// pcb.pid = nextPID; // you can keep track of next_pid using next_pid =0 and next_Pid++;

    enqueue(&ready_queue, pcb); // queue the pcb onto to the ready queue

    return 0; // successful entry onto ready queue
}