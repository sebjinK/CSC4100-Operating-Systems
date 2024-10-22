#include "process.h"
int create_process(int (*code_adddress)())// code_address is the pointer to thfuncitons that conaints the process code
{
    uint64_t stackPointer[1024] = allocStack();
    if (!stackPointer)
        return -1;
    
    // set sp to stackptr + 1024 to put sp at the bottom of the stack;
    for (int i = 0; i <= 32; i++)
    {
        // decrement sp
        // set uint64_t at which sp points to 0
    }
    // [sp + 30] to code_address (type cast as uint64_t so compiler doesn't complain)
    // pcb = allocPCB() // return a pointer back to pcb
    // if (!pcb) return -1;
    // pcb.sp = sp at the top of the stack
    // pcb.pid = nextPID; // you can keep track of next_pid using next_pid =0 and next_Pid++;

    //enqueue()

    // return


}