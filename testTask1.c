#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[]) {
  int pid;
  int k, numChild;
  double x, z;

  if(argc < 2)
	numChild = 1; //Default
  else
	numChild = atoi(argv[1]);
  if (numChild < 0 ||numChild > 20)
	numChild = 2;
  if (argc>=3)
  	numChild = atoi(argv[2]);
  x = 0;
  pid = 0;

  for ( k = 0; k < numChild; k++ ) {
    pid = fork ();
    if ( pid < 0 ) {
      printf(1, "%d failed in fork!\n", getpid());
    } else if (pid > 0) {
      // parent
      printf(1, "Parent %d creating child %d\n",getpid(), pid);
      wait();
      }
      else{
	printf(1,"Child %d created\n",getpid());
	//Wasting CPU time around 10 seconds	
	for(z = 0.0; z < 80000000.0; z+=1.0)
	    x = x + 3.14*89.64;
	break;
      }
  }
  exit();
}
