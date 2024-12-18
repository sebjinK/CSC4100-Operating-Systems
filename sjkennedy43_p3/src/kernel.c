#include "queue.h"
#include "process.h"

int clear_scr(int start_row, int start_column, int width, int height);

int main()
{
    //call clear screen so we can get the height and width
    clear_scr(21, 49, 27, 79);
    //putc_to(24, 59, 'H');
    //call box so we can use the assembly function
    //if (box(21, 49, 27, 79) == 0) //sr, sc, er, ec
    print_to(6, 36, "Running Processes");
    print_to(7, 36, "-----------------");
    // init Round Robin Queue data structure
        // linked list queue -- dynamic size
        // no using c - malloc/c++ - new (no memory allocation)
        // use templates---so much more nice
    ready_queue.head = NULL;
    ready_queue.tail = NULL;
    // make a pcb data item which you can enqueue and dequeue from the round robin
    // pass a pointer/address of the first instructions of the passed process
    //clear_scr(21, 49, 27, 79);// clear scr
    clear_scr(0, 0, 90, 90);
    if (create_process(p1) != 0) // setup and queue all four processes
        return -1;
    if (create_process(p2) != 0)
        return -1;
    if (create_process(p3) != 0)
        return -1;
    if (create_process(p4) != 0)
        return -1;
    // set up exception table
    setup_EVT();
    // init the timer
    init_timer();
    go(); // start dequeuing and running processes
    return 0;
}