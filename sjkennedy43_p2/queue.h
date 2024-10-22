#ifndef QUEUE_H
#define QUEUE_H
#include "libos.h"
#include <stdio.h>
#include <stdint.h>
extern int box (unsigned int srow, unsigned int scolumn, unsigned int erow, unsigned int ecolumn);
struct pcb
{
    uint64_t sp;
    uint32_t pid;
    struct pcb * next;
};
typedef struct pcb PCB_t;
struct pcb_q
{
    PCB_t * head;
    PCB_t * tail;
};
typedef struct pcb_q PCB_Q_t;

void enqueue(PCB_Q_t *queue, PCB_t *pcb);
PCB_t *dequeue(PCB_Q_t *queue);
uint64_t * allocStack();


// test processes:

int p1();
int p2();
int p3();
int p4();
#endif