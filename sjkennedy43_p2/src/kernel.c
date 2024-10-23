#include "queue.h"
#include "process.h"

int clear_scr(int start_row, int start_column, int width, int height);

int main()
{
    //call clear screen so we can get the height and width
    clear_scr(21, 49, 27, 79);
    //putc_to(24, 59, 'H');
    //call box so we can use the assembly function
    if (box(21, 49, 27, 79) == 0) //sr, sc, er, ec
        print_to(24, 59, "Running Processes");
    // init Round Robin Queue data structure
        // linked list queue -- dynamic size
        // no using c - malloc/c++ - new (no memory allocation)
        // use templates---so much more nice
    ready_queue.head = NULL;
    ready_queue.tail = NULL;
    // make a pcb data item which you can enqueue and dequeue from the round robin
    // pass a pointer/address of the first instructions of the passed process
    clear_scr(21, 49, 27, 79);// clear scr
    if (create_process(p1) != 0) // setup and queue all four processes
        return -1;
    if (create_process(p2) != 0)
        return -1;
    if (create_process(p3) != 0)
        return -1;
    if (create_process(p4) != 0)
        return -1;
    go(); // start dequeuing and running processes
    return 0;
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