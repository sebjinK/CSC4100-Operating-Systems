#include "queue.h"
uint32_t next_stack = 0;
PCB_Q_t ready_queue;
uint64_t stacks[MAX_STACKS][1024];
uint32_t next_stack;
PCB_t pcbs[MAX_NUM_PCBS];
PCB_t * running;
uint64_t * allocStack()
{
    if (next_stack >= MAX_STACKS)
        return NULL;
    return stacks[next_stack++];
}    
PCB_t * allocPCB()
{
    static int advance = 0;
    if (advance >= MAX_NUM_PCBS)
        return NULL;
    return &pcbs[advance++];
}

void enqueue(PCB_Q_t * queue, PCB_t * pcb)
{
    if (queue->tail == NULL)
        queue->head = queue->tail = pcb;
    else
    {
        queue->tail->next = pcb;
        queue->tail = pcb;
    }
    pcb->next = NULL;
}
PCB_t * dequeue(PCB_Q_t * queue)
{
    if (queue->head == NULL)//QUEUE IS EMPTY
        return NULL; //return null

    PCB_t * temp = queue->head; //set up temporary head before it's cut off so we can returnn it
    queue->head = queue->head->next; //advance the head

    return temp; //return dequeued node   
}

// test processes
int p1()
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
        dispatch();
    }
}
int p2()
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
        dispatch();
    }
}
int p3()
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
        dispatch();
    }
}
int p4()
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
        dispatch();
    }
}