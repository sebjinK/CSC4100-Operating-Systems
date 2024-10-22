#include "queue.h"


uint64_t * allocStack()
{
    // static uint32_t next_stack = 0;
    if (next_stack == MAX_STACKS)
        return NULL;
    return stacks[next_stack++];
}    
PCB_t *allocPCB()
{
    static int advance = 0;
    if (advance >= MAX_NUM_PCBS)
        return NULL;
    return &pcbs[advance++];
}

void enqueue(PCB_Q_t * queue, PCB_t * pcb)
{
    pcb->next = NULL;//set up the pcb next pointer
    if (queue->tail == NULL) //if queue is empty
        queue->head = queue->tail = pcb; //set everything to be the passed pcb
    else // if queue is not empty
    {
        queue->tail->next = pcb; //push the passed pcb to the front of the queue
        queue->tail = queue->tail->next; // advance the tail
    }
}
PCB_t * dequeue(PCB_Q_t * queue)
{
    if (queue->head == NULL)//QUEUE IS EMPTY
        return NULL; //return null

    PCB_t * temp = queue->head; //set up temporary head before it's cut off so we can returnn it
    queue->head = queue->head->next; //advance the head

    if (queue->head == NULL) //IF THE QUEUE BECOMES EMPTY
        queue->tail == NULL; //TAIL NEEDS TO BE EMPTY

    return temp; //return dequeued node   
}

// test processes
int p1()
{
    if(box(9, 23, 11, 39) != 0)
        return -1;
    char message[] = "Process 1: 0";
    print_to(10, 25, message);
    int num = 0;

    while(1 == 1)
    {
        num = num + '0';
        message[11] = num;
        num = num - '0';
        print_to(10, 25, message);
        num++;
        if (num > 9)
            num = 0;
        //call dispatch from process_asm
    }
}
int p2()
{
    if(box(13, 23, 15, 39) != 0)
        return -1;
    char message[] = "Process 2: 0";
    print_to(14, 25, message);
    int num = 0;

    while(1 == 1)
    {
        num = num + '0';
        message[11] = num;
        num = num - '0';
        print_to(14, 25, message);
        num++;
        if (num > 9)
            num = 0;
        //call dispatch from process_asm
    }
}
int p3()
{
    if(box(9, 49, 11, 65) != 0)
        return -1;
    char message[] = "Process 3: 0";
    print_to(10, 51, message);
    int num = 0;

    while(1 == 1)
    {
        num = num + '0';
        message[11] = num;
        num = num - '0';
        print_to(10, 51, message);
        num++;
        if (num > 9)
            num = 0;
        //call dispatch from process_asm
    }
}
int p4()
{
    if(box(13, 49, 15, 65) != 0)
        return -1;
    char message[] = "Process 4: 0";
    print_to(14, 51, message);
    int num = 0;

    while(1 == 1)
    {
        num = num + '0';
        message[11] = num;
        num = num - '0';
        print_to(14, 51, message);
        num++;
        if (num > 9)
            num = 0;
        //call dispatch from process_asm
    }
}