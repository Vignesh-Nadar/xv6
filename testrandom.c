#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"


int main(int argc, char *argv[]) {

  int r,i;
  
  printf(1,"Printing 5 random numbers [default between 0 and (2^32 - 1) / 2, which is 2147483647] : \n");
  for(i=0;i<5;i++)
  {
  	r = randomgen();
	printf(1,"%d  ",r);
         
  }

 
  printf(1,"\nPrinting 5 random numbers between 50 and 100 : \n");
  for(i=0;i<5;i++)
  {
  	r = randomgenrange(50,100);
	printf(1,"%d  ",r);
         
  }
  printf(1,"\n");
  exit();
}
