#include "libos.h"

extern int box (unsigned int srow, unsigned int scolumn, unsigned int erow, unsigned int ecolumn);
//extern void putc_to(unsigned int row, unsigned int column, const char c);
//extern void print_to(unsigned int row, unsigned int column, const char * string);

int clear_scr(int start_row, int start_column, int width, int height);

int main()
{
    //call clear screen so we can get the height and width
    clear_scr(21, 49, 27, 79);
    //putc_to(24, 59, 'H');
    //call box so we can use the assembly function
    if (box(21, 49, 27, 79) == 0) //sr, sc, er, ec
        print_to(24, 59, "Hello World");
    //call print to
    //print_to(24, 59, "Hello World");

    return 0;
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