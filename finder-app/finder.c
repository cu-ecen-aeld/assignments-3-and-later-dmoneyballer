#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define BUFFER 1000
int main(int argc, char ** argv) {
    if (argc < 3) {
        printf("please call this with 2 args, <dir to search> <text to search> to run this %d command\n", argc);
        return 1;
    }
    // printf("grep -r %s %s\n", argv[2], argv[1]);
    // for (int i=0; i<argc; i++) {
    FILE *fp;
    char buffer[BUFFER];
    char cmd1[112] = "find ";
    cmd1 + *argv[1];
    char cmd2[244] = " -type f 2>/dev/null|wc -l";
    char *dir = argv[1];
    strcat(cmd1, dir);
    strcat(cmd1,cmd2);
    // free(dir);
    // char final = strcpy(cmd,/cmd2);
    // char cmd = "find %s -type f|wc -l", argv[1];
    // char cmd = printf("find %s -type f|wc -l\n", argv[1]);
    fp = popen(cmd1, "r");
    FILE * wf;

    int ch;
    char str;
    wf = fopen("/tmp/num", "w");

    while ((ch=fgetc(fp)) != EOF)
        // printf("%d\n",ch);
        // strcat(str,ch);
        // printf("\n");
        putc(ch, wf);
        // printf("\n");
    // while (fgets(buffer, BUFFER-1, fp) != NULL) {
    //     numb = buffer;
    //     printf("output[%d]: %s", count, buffer);
    //     count ++;
    // }
    pclose(fp);
    pclose(wf);
    FILE *fp1;
    char grep_cmd[112] = "grep -r ";
    char *search = argv[2];
    strcat(grep_cmd, search);
    strcat(grep_cmd, dir);
    strcat(grep_cmd, " 2>/dev/null|wc -l");
    printf("%s", grep_cmd);
    fp1 = popen(grep_cmd, "r");
    // int count =0;
    // char num_found;
    // while (fgets(buffer2, BUFFER-1, fp) != NULL) {
    //     strcat(buffer2, num_found);
    //     // printf("output[%d]: %s", count, buffer);
    //     count ++;
    // }
    // pclose(fp);
    // printf("The number of files are %s and the number of matching lines are %s", num_files, num_found);


    // printf("\nnum is%d\n", str);
    return 0;
}