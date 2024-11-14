#ifndef QUEUE_H
#define QUEUE_H
#include "libos.h"
#include <stdio.h>
#include <stdint.h>
extern int box (unsigned int srow, unsigned int scolumn, unsigned int erow, unsigned int ecolumn);
extern void go();
extern void dispatch(); // call go and dispatch
extern void setup_EVT();
extern void init_timer();
extern void clear_timer();
int clear_scr(int, int, int, int);
void unsupported();
struct pcb // pcb struct holds the pcb stack pointer and process ID and next pcb pointer
{
    uint64_t sp;
    uint32_t pid;
    struct pcb * next;
};
typedef struct pcb PCB_t;
struct pcb_q // pcb queue holds the head and tail pcbs
{
    PCB_t * head;
    PCB_t * tail
};
typedef struct pcb_q PCB_Q_t;

void enqueue(PCB_Q_t *queue, PCB_t *pcb);
PCB_t *dequeue(PCB_Q_t *queue);
extern PCB_Q_t ready_queue; // use extern to access global ready_queue easily

uint64_t * allocStack();
#define MAX_STACKS 10 // set up the maximum number of stacks
extern uint64_t stacks[MAX_STACKS][1024];
extern uint32_t next_stack;

PCB_t * allocPCB();
#define MAX_NUM_PCBS 100 // set up number of pcbs
extern PCB_t pcbs[MAX_NUM_PCBS];

extern PCB_t * running; // use extern to access global running process easily

// set up test processes:

int p1();
int p2();
int p3();
int p4();
#endif