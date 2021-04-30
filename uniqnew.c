#include "types.h"
#include "user.h"
#define MAX_BUF 1024
#define NULL (void *)0

char buf[MAX_BUF];
int argumentIndex = 1;
int optionCD = 1;   // 1 for no option // 2 for -C // 3 for option -D
int optionI = 0;  // 1 for option -I

int readLine(char *line, int fd) {
    memset(line, 0, MAX_BUF);
    char *dst = line;
    while ((read(fd, buf, 1)) > 0) {
        if (buf[0] == '\n') {
            *dst++ = buf[0];
            break;
        } else {
            *dst++ = buf[0];
            if ((dst - line) + 1 > MAX_BUF) {
                break;
            }
        }

    }
    //adding \n to line end if it doesn't have one..
    if (*(dst - 1) != '\n') *dst = '\n';
    return dst - line;
}

int caseIgnoreComparison(const char *first, const char *second) {
    uchar chA, chB;
    chA = *first;
    chB = *second;
    if (chA >= 'A' && chA <= 'Z')
        chA = 'a' + (chA - 'A');
    if (chB >= 'A' && chB <= 'Z')
        chB = 'a' + (chB - 'A');

    while (*first && chA == chB)
    {
      first++;
      second++;
      if (chA >= 'A' && chA <= 'Z')
        chA = 'a' + (chA - 'A');
      if (chB >= 'A' && chB <= 'Z')
        chB = 'a' + (chB - 'A');
    }

    return (uchar) *first - (uchar) *second;
}

void uniq(int fd, char *name) {
    char *prev = NULL, *cur = NULL;
    char *line = (char *) malloc(MAX_BUF * sizeof(char));
    int count = 0;
    while ((readLine(line, fd)) > 0) {
        if (prev == NULL) {
            prev = (char *) malloc(MAX_BUF * sizeof(char));
            cur = (char *) malloc(MAX_BUF * sizeof(char));
            memmove(prev, line, MAX_BUF);
            memmove(cur, line, MAX_BUF);
            count = 1;
            if (optionCD == 1) {
                printf(1, "%s", cur);
            }
            else if (optionCD == 2)
            {
                printf(1, "%d %s", count, cur);
            }
        } else {
            memmove(cur, line, MAX_BUF);
            int cmp_result;
            if (optionI) {
                cmp_result = caseIgnoreComparison(cur, prev);
            } else {
                cmp_result = strcmp(cur, prev);
            }
            if (cmp_result == 0)
            {
                count++;
                if (optionI) {
                    memmove(cur, prev, MAX_BUF);
                }
            }
            else {
                if (optionCD == 1)
                {
                    printf(1, "%s", cur);
                } else if (optionCD == 3 && count > 1)
                {
                    printf(1, "%s", prev);
                } else if (optionCD == 2)
                {
                    printf(1, "%d %s", count, prev);
                }
                count = 1;
            }
        }
        memmove(prev, cur, MAX_BUF);
    }
    if ((optionCD == 3 && count > 1)) {
        printf(1, "%s", cur);
    } else if (optionCD == 2) {
        printf(1, "%d %s", count, cur);

    }
    free(prev);
    free(cur);
    free(line);
}

int readOperators(int argc, char *argv[]) {
    if (argumentIndex >= argc - 1) {
        return 0;
    }
    char *options = "cdiCDI";
    char *arg = argv[argumentIndex];
    if (arg[0] != '-' || (strchr(options, arg[1]) == 0)) {
        printf(1, "Not a valid option for UNIQ : %s\n", arg);
        return 0;
    } else {
        argumentIndex++;
        return arg[1];
    }
}

int main(int argc, char *argv[]) {
    int fd;
    int c;
    if (argc <= 1) {
        uniq(0, "");
        exit();
    } else if (argc == 2) {
        if ((fd = open(argv[1], 0)) < 0) {
            printf(1, "uniq: cannot open %s\n", argv[1]);
            exit();
        }
        uniq(fd, argv[1]);
        exit();
    } else if (argc >= 3) {
        while ((c = readOperators(argc, argv)) > 0) {

            if (c == 'c' || c == 'C')
            {
              optionCD = 2;
            }
            if (c == 'd' || c == 'D')
            {
              optionCD = 3;
            }
            if (c == 'i' || c == 'I')
            {
              optionI = 1;
            }
        }
        if ((fd = open(argv[argc - 1], 0)) < 0) {
            printf(1, "uniq: cannot open %s\n", argv[1]);
            exit();
        }
        uniq(fd, argv[argc - 1]);
        exit();
    }
    exit();
}
