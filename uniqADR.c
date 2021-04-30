#include "types.h"
#include "stat.h"
#include "user.h"

char buf[5120000];
char *argNum;
void
uniq(int fd, char *name)
{
  int i, n,j,l,count=0;
  int k=0;
  int num=0;
  int TotalLines=0;
  int nextLineInt=0;
  int s=0;
  int z=0;
  int e=0;
  int numCount=0;
  int numLines=0;
  int repeatIndex[1000];
  char NextLine[2500];
  char repeat[2500];
  char currentLine[2500];
  char result[20000];


  while((n = read(fd, buf, sizeof(buf))) > 0){
 		 //get a line and set it to Currentline
                for(i=0;buf[i]!='\n';i++)
                {
                        num++;
                        currentLine[i]=buf[i];
                }
		currentLine[i]='\0';
		repeatIndex[numLines]=1;

		//Count the number of lines
 		for(j=0; j<n; j++)
		 {
                     if(buf[j] == '\n')
                          TotalLines++;
                 }
     
		// put firstline in result
                for(i=0;i<num+1;i++)
                {
                result[i]=currentLine[i];

		numCount++;
                }
		result[i]='\0';	
		nextLineInt=i;

	// do the following continously until numLines = Total lines
	while(numLines<TotalLines-1){
	numLines++;
	s=nextLineInt;
	repeatIndex[numLines]=1;
	z=nextLineInt;
	count=0;	//amount of characters in each line

	//from the next line to the end of the line set char line to the character in the nextline
	for(i=nextLineInt;buf[i]!='\n';i++){
			count++;
        		NextLine[k]=buf[i];
			k++;

        	}
	NextLine[i]='\0';
	
	k=0;
	if(strcmp(currentLine,NextLine)==0){repeatIndex[numLines]+=1;} //increment repeatIndex everytime a line is duplicated
	//you need a previous line to compare it to your current add nextline to the whole result
	if(strcmp(currentLine,NextLine)!=0){
		for(l=0;l<count;l++){

			result[s]=NextLine[l];
			s++;
			numCount++;
		}
		result[s]='\0'; 	
	        
		// print amount of time each line is outputed
		if(strcmp(argNum,"-c")==0 || strcmp(argNum,"-C")==0){

			
			if(numLines==1){
				printf(1,"%d", repeatIndex[numLines-1]);
				printf(1, "%s \n",currentLine);
			}
			printf(1,"%d", repeatIndex[numLines-1]);
			for(e=0;e<count;e++){
 				printf(1, "%c",result[z]);
				z++;
			}
			printf(1, "\n");
		}else if(strcmp(argNum,"-d")==0 || strcmp(argNum,"-D")==0){}
		//convert currentline and nextline characters to capital letters then compare and print
		else if(strcmp(argNum,"-i")==0 || strcmp(argNum,"-I")==0){

			for(e=0;e<count;e++){
		
			if((currentLine[e]>96) && (currentLine[e]<123)) currentLine[e] ^=0x20;
			if((NextLine[e]>96) && (NextLine[e]<123)) NextLine[e] ^=0x20;
			if(strcmp(currentLine,NextLine)!=0){
				for(l=0;l<count;l++){

					result[s]=NextLine[l];

					s++;
					numCount++;


					}
	
				result[s]='\0';
				if(numLines==1){
					printf(1, "%s \n",currentLine);
				}
				for(e=0;e<count;e++){
 					printf(1, "%c",result[z]);
					z++;
				}
				printf(1, "\n");
			 }
		}
		}else {
			if(numLines==1){
				printf(1, "%s \n",currentLine);
			}
			for(e=0;e<count;e++){
 				printf(1, "%c",result[z]);
				z++;
			}
			printf(1, "\n");
		}
	strcpy(currentLine,NextLine);
	//Only print duplicate lines
	}else if(strcmp(currentLine,NextLine)==0 && (strcmp(argNum,"-d")==0 || strcmp(argNum,"-D")==0)){ 

	strcpy(currentLine,NextLine);
	if(strcmp(repeat,NextLine)!=0){
		printf(1, "%s \n",NextLine);
		strcpy(repeat,currentLine);
	}
	
	
	
	}
	
	nextLineInt=nextLineInt+count+1;
	
	}


	
  }strcpy(result,NextLine);
		
	

}

int
main(int argc, char *argv[])
{
  int fd, i,j;

  if(argc <= 1){
    uniq(0, "");
    exit();
  }else if(argc==2){

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "uniq: cannot open %s\n", argv[i]);
      exit();
    }
    uniq(fd, argv[i]);
    close(fd);
  }
  exit();
}else{

for(j = 2; j < argc; j++){
    if((fd = open(argv[j], 0)) < 0){
      printf(1,"uniq: cannot open %s\n", argv[j]);
      exit();
    }
    argNum=argv[1];
    uniq(fd, argv[j]);
    close(fd);
  }
  exit();
  }
}
