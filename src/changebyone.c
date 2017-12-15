#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main() {
    char *buff = NULL;
    size_t len = 0;

    setvbuf(stdin, NULL, _IONBF, 0);
    setvbuf(stdout, NULL, _IONBF, 0);

    while(1) {
        printf("\n > ");
        if (getline(&buff, &len, stdin) < 0) {
            break;
        }
        if (strstr(buff, "uname -a")) {
            system("uname -a");
        } else if (strstr(buff, "exit")) {
            break;
        } else if (strstr(buff, "help")) {
            printf("Strong software\n"
                   "  uname -a  :  get current OS\n"
                   "  help  :  show this message\n"
                   "  exit  :  go out (recommanded)\n");
        } else {
            printf("Unknow command %s", buff);
        }
    }
    free(buff);
    return 0;
}

