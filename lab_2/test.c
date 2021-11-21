#include <stdlib.h>
#include <unistd.h>


int main (void)
{
    write(1, "hello and bye\n", 15);
    return EXIT_SUCCESS;
}
