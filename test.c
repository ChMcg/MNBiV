#include <stdio.h>
#include <string.h>

int main()
{
    char buffer[10];
    int a = scanf("%s", buffer);

    if (a > 0)
    {
        for (int i = strlen(buffer); i >= 0; i--)
        {
            printf("%c", buffer[i]);
        }
    }
    // printf("%s", buffer);
    return 0;
}
