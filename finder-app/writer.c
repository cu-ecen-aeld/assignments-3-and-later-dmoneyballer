#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <syslog.h>
#define BUFFER 1000

int main(int argc, char ** argv) {
    openlog("Logs", LOG_SYSLOG, LOG_USER);
    if (argc < 3) {
        syslog(LOG_PERROR, "please call this with 2 args, <dir to write> <text to write> to run this %d command\n", argc);
        printf("please call this with 2 args, <dir to write> <text to write> to run this %d command\n", argc);
        return 1;
    }
    char *dir = argv[1];
    char *data = argv[2];
    FILE *fp;
    fp = fopen(dir, "w");
    syslog(LOG_DEBUG,"Writing %s to %s", argv[2], argv[1]);
    fputs(data, fp);
    pclose(fp);
    return 0;
}