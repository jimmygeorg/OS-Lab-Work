#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

int main() {
    
    pid_t ParentID = getpid();

    int fd[2];
    int P;

    int P2 = fork();
    if (P2 == 0){   //P2
        
        int ChildrenToWait = 2;
        int ChildrenFinished = 0;

        pid_t FinPID[2];
        int j = 0;

        for (int i = 4; i < 7; ++i)
        {
            P=fork();
            if(P == 0){
                printf("I am the child process P%d with PID: %d\n", i, getpid());
                printf("My parent is process P2 with PID: %d\n\n", getppid());
                
                exit(0);
            }

        }
        
        
        //while (ChildrenFinished < ChildrenToWait) {
            /*FinPID[j] = wait(NULL);
            printf("*Child process with PID %d has finished*.\n\n", FinPID[j]);
            j++;*/
            for (int i = 4; i < 6; ++i) {
                wait(NULL);
                printf("*Child process P%d has finished.*\n", i);
            }
          //  ChildrenFinished++;
        //}

    
        printf("I am the child process P2 with PID: %d\n", getpid());
        printf("My parent is process P0 with PID: %d\n\n", getppid());

        exit(2);
    }
    
    wait(&P2);
    int P1=fork();
    if(P1 == 0){
        
        if(pipe(fd) == -1){
            printf("An error occured with opening the pipe\n");
            return 1;
        }

        
    	int P3 =fork();
        
    	if(P3 == 0){   //P3
            
            close(fd[0]);

            char msg[] = "Hello from your children";
            if(write(fd[1], msg, 25) == -1){
                printf("An error occured with writing to the pipe\n");
                return 2;
            }

            close(fd[1]);

    		printf("I am the child process P3 with PID: %d\n", getpid());
    		printf("My parent is process P1 with PID: %d\n\n", getppid());

        	exit(3);

    	} else{    //back to P1
            close(fd[1]);

            char buf[100];
            if(read(fd[0], buf, 100) == -1){
                printf("An error occured with reading from the pipe\n");
                return 3;
            }
        
            
            wait(&P3);
            close(fd[0]);

            printf("P3 says: %s\n", buf);
            printf("I am the child process P1 with PID: %d\n", getpid());
            printf("My parent is process P0 with PID: %d\n\n", ParentID);
        }
        
        exit(1);
    }

    /*int P2 = fork();
    if (P2 == 0){   //P2
        wait(&P1);
        for (int i = 4; i < 7; ++i)
        {
            P=fork();
            if(P == 0){
                printf("I am the child process P%d with PID: %d\n", i, getpid());
                printf("My parent is process P2 with PID: %d\n\n", getppid());

                sleep(2);
                exit(0);
            }

            wait(NULL);
        }

        printf("I am the child process P2 with PID: %d\n", getpid());
        printf("My parent is process P0 with PID: %d\n\n", getppid());

        exit(2);
    }*/

    if (getpid() == ParentID){

    	wait(&P2); wait(&P1); 
    	printf("I am the parent process P0 with PID: %d\n\n", ParentID);
    	
    	execlp("cat", "cat", __FILE__, NULL);
    	return 0;
    }
}
