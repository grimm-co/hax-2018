#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <signal.h>

#define NARGS 6

int main(int argc, char **argv, char **envp)
{
    DIR *d;
    struct dirent *dir;
    char *tok, *fname, *fbuf;
    char *xargv[NARGS];
    char *nc = "/bin/nc.traditional";
    int ctr = 0, p[2], fd;
    size_t len;
    pid_t child;

    signal(SIGPIPE, SIG_IGN);

    if (argc < 2)
        return 1;

    if (chdir(argv[1]))
        return 0;
    d = opendir(".");
    if (!d)
        return 1;
    while (NULL != (dir = readdir(d)))
    {
        if ('.' != dir->d_name[0])
        {
            xargv[ctr++] = nc;
            fname = strdup(dir->d_name);
            while (ctr < NARGS-1 && NULL != (tok = strsep(&fname, ":")))
            {
                xargv[ctr++] = tok;
            }
            xargv[ctr] = NULL;
            pipe(p);
            if (!fork()){
                // child
                close(p[1]);
                dup2(p[0], 0);
                close(p[0]);
                closedir(d);
                free(fname);
                execve(nc, xargv, envp);
                perror("ERROR");
                exit(1);
            }

            // parent
            close(p[0]);
            fd = open(dir->d_name, O_RDONLY);
            if (fd > 0){
                len = lseek(fd, 0, SEEK_END);
                lseek(fd, 0, SEEK_SET);
                fbuf = mmap(NULL, len, PROT_READ, MAP_PRIVATE, fd, 0);
                if (MAP_FAILED != fbuf){
                    write(p[1], fbuf, len);
                    munmap(fbuf, len);
                } else {
                    perror("ERROR");
                }
            } else {
                    perror("ERROR");
            }
            close(p[1]);
            ctr = 0;
            free(fname);
            unlink(dir->d_name);
        }
    }
    closedir(d);
    return 0;
}
