#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <syslog.h>
#define BUFFER 1000

int main(int argc, char ** argv) {
    openlog("Logs", LOG_SYSLOG, LOG_USER);
    if (argc < 3) {
        syslog(LOG_PERROR, "please call this with 2 args, <dir to search> <text to search> to run this %d command\n", argc);
        printf("please call this with 2 args, <dir to search> <text to search> to run this %d command\n", argc);
        return 1;
    }

    FILE *fp;
    char buffer[BUFFER];
    char cmd1[112] = "find ";
    cmd1 + *argv[1];
    char cmd2[244] = " -type f 2>/dev/null|wc -l";
    char *dir = argv[1];
    strcat(cmd1, dir);
    strcat(cmd1,cmd2);

    fp = popen(cmd1, "r");
    FILE * wf;

    int ch;

    wf = fopen("/tmp/num", "w");
    while ((ch=fgetc(fp)) != EOF)
        putc(ch, wf);

    pclose(fp);
    pclose(wf);
    FILE *fp1;
    FILE *wf1;
    char grep_cmd[112] = "grep -r ";
    char *search = argv[2];
    strcat(grep_cmd, search);
    strcat(grep_cmd, dir);
    strcat(grep_cmd, " 2>/dev/null|wc -l");
    fp1 = popen(grep_cmd, "r");
    int ch1;
    wf1 = fopen("/tmp/occur", "w");
    while ((ch=fgetc(fp1)) != EOF)

        putc(ch, wf1);

    pclose(fp1);
    pclose(wf1);

    char x[999];
    FILE* file_num = fopen("/tmp/num", "r");
    while (fgets(x, 100, file_num) )
    {
    ;
    }
    pclose(file_num);
    char y[999];
    FILE* file_occur = fopen("/tmp/occur", "r");
    while (fgets(y, 100, file_occur) )
    {
    ;
    }
    pclose(file_occur);
    x[strlen(x)-1] = 0;
    
    printf("The number of files are %s and the number of matching lines are %s", x, y);
    closelog();
    return 0;
}