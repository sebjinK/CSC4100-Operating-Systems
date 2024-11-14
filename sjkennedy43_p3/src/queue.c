#include "queue.h"
// needed to init here since using extern on global variables
uint32_t next_stack = 0; // starts next stack at 0 and will advance with each new pcb
PCB_Q_t ready_queue; // init queue of ready pcbs
uint64_t stacks[MAX_STACKS][1024]; // init stacks assigned to each pcb
PCB_t pcbs[MAX_NUM_PCBS]; // init pcb array that holds space for each pcb
PCB_t * running; // sets up the running process

uint64_t * allocStack() // allocates stack memory
{
    if (next_stack >= MAX_STACKS) // check if there's too many processes
        return NULL;
    return stacks[next_stack++]; // advance to next stack whilst returning the current stack
}    
PCB_t * allocPCB() // allocates pcb
{
    static int advance = 0; // starts advance at 0 and will increase until advance approaches MAX_NUM_PCBS
    if (advance >= MAX_NUM_PCBS)
        return NULL;
    return &pcbs[advance++]; // uses reference variable since allocPCB is a pointer
}

void enqueue(PCB_Q_t * queue, PCB_t * pcb)
{
    if (queue->tail == NULL)
        queue->head = queue->tail = pcb; // if nothing exists, make everything the same
    else
    {
        queue->tail->next = pcb; // if something exists, push it behind the tail
        queue->tail = pcb; // make that something behind the tail the new tail
    }
    pcb->next = NULL; // there is nothing behind the tail
}
PCB_t * dequeue(PCB_Q_t * queue)
{
    if (queue->head == NULL)//QUEUE IS EMPTY
        return NULL; //return null

    PCB_t * temp = queue->head; //set up temporary head before it's cut off so we can returnn it
    queue->head = queue->head->next; //advance the head

    return temp; //return dequeued node   
}
void unsupported()
{
    clear_scr(0, 0, 90, 90); // clean up screen real quick
    print_to(0, 0, "Error: Unsupported Interrupt!"); // 
    while (1) {}
}
int clear_scr(int start_row, int start_column, int end_row, int end_column) // clear the screen row by row, column by column
{
    for (int i = start_row; i < end_row + 1; i++)
    {
        for (int j = start_column; j < end_column + 1; j++)
        {
            putc_to(i, j, ' ');
        }
    }
}
// test processes
int p1() //processes
{
    if(box(9, 23, 11, 39) != 0)
        return -1;
        // print_to(9, 23, errormsg)
        // while (1)
    char message[] = "Process 1: 0";
    print_to(10, 25, message);
    static int num = 0;

    while(1)
    {
        message[11] = num + '0';
        print_to(10, 25, message);
        num++;
        if (num > 9)
            num = 0; 
    }
}
int p2() //processes
{
    if(box(13, 23, 15, 39) != 0)
        return -1;
    char message[] = "Process 2: 0";
    print_to(14, 25, message);
    static int num = 0;

    while(1)
    {
        message[11] = num + '0';
        print_to(14, 25, message);
        num++;
        if (num > 9)
            num = 0;
    }
}
int p3() //processes
{
    if(box(9, 49, 11, 65) != 0)
        return -1;
    char message[] = "Process 3: 0";
    print_to(10, 51, message);
    static int num = 0;

    while(1)
    {
        message[11] = num + '0';
        print_to(10, 51, message);
        num++;
        if (num > 9)
            num = 0;
    }
}
int p4() //processes
{
    if(box(13, 49, 15, 65) != 0)
        return -1;
    char message[] = "Process 4: 0";
    print_to(14, 51, message);
    static int num = 0;

    while(1)
    {
        message[11] = num + '0';
        print_to(14, 51, message);
        num++;
        if (num > 9)
            num = 0;
    }
}