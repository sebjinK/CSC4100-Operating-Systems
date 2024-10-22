#include "process.h"

int clear_scr(int start_row, int start_column, int width, int height);

void main()
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
    // make a pcb data item which you can enqueue and dequeue from the round robin
    // pass a pointer/address of the first instructions of the passed process

    //call print to
    //print_to(24, 59, "Hello World");
}

int clear_scr(int start_row, int start_column, int width, int height) // clear the screen row by row, column by column
{
    for (int i = start_row; i < height + 1; i++)
    {
        for (int j = start_column; j < width + 1; j++)
        {
            putc_to(i, j, ' ');
        }
    }
}