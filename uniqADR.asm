
_uniqADR:     file format elf32-i386


Disassembly of section .text:

00000000 <uniq>:

char buf[5120000];
char *argNum;
void
uniq(int fd, char *name)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	81 ec 68 7b 00 00    	sub    $0x7b68,%esp
  int i, n,j,l,count=0;
       9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  int k=0;
      10:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  int num=0;
      17:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  int TotalLines=0;
      1e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  int nextLineInt=0;
      25:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  int s=0;
      2c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  int z=0;
      33:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  int e=0;
      3a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  int numCount=0;
      41:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  int numLines=0;
      48:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  char repeat[2500];
  char currentLine[2500];
  char result[20000];


  while((n = read(fd, buf, sizeof(buf))) > 0){
      4f:	e9 3b 06 00 00       	jmp    68f <uniq+0x68f>
 		 //get a line and set it to Currentline
                for(i=0;buf[i]!='\n';i++)
      54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      5b:	eb 20                	jmp    7d <uniq+0x7d>
                {
                        num++;
      5d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
                        currentLine[i]=buf[i];
      61:	8b 45 f4             	mov    -0xc(%ebp),%eax
      64:	05 40 13 00 00       	add    $0x1340,%eax
      69:	0f b6 00             	movzbl (%eax),%eax
      6c:	8d 8d d4 d2 ff ff    	lea    -0x2d2c(%ebp),%ecx
      72:	8b 55 f4             	mov    -0xc(%ebp),%edx
      75:	01 ca                	add    %ecx,%edx
      77:	88 02                	mov    %al,(%edx)
  char result[20000];


  while((n = read(fd, buf, sizeof(buf))) > 0){
 		 //get a line and set it to Currentline
                for(i=0;buf[i]!='\n';i++)
      79:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
      80:	05 40 13 00 00       	add    $0x1340,%eax
      85:	0f b6 00             	movzbl (%eax),%eax
      88:	3c 0a                	cmp    $0xa,%al
      8a:	75 d1                	jne    5d <uniq+0x5d>
                {
                        num++;
                        currentLine[i]=buf[i];
                }
		currentLine[i]='\0';
      8c:	8d 95 d4 d2 ff ff    	lea    -0x2d2c(%ebp),%edx
      92:	8b 45 f4             	mov    -0xc(%ebp),%eax
      95:	01 d0                	add    %edx,%eax
      97:	c6 00 00             	movb   $0x0,(%eax)
		repeatIndex[numLines]=1;
      9a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
      9d:	c7 84 85 20 f0 ff ff 	movl   $0x1,-0xfe0(%ebp,%eax,4)
      a4:	01 00 00 00 

		//Count the number of lines
 		for(j=0; j<n; j++)
      a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      af:	eb 17                	jmp    c8 <uniq+0xc8>
		 {
                     if(buf[j] == '\n')
      b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b4:	05 40 13 00 00       	add    $0x1340,%eax
      b9:	0f b6 00             	movzbl (%eax),%eax
      bc:	3c 0a                	cmp    $0xa,%al
      be:	75 04                	jne    c4 <uniq+0xc4>
                          TotalLines++;
      c0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
                }
		currentLine[i]='\0';
		repeatIndex[numLines]=1;

		//Count the number of lines
 		for(j=0; j<n; j++)
      c4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
      cb:	3b 45 c0             	cmp    -0x40(%ebp),%eax
      ce:	7c e1                	jl     b1 <uniq+0xb1>
                     if(buf[j] == '\n')
                          TotalLines++;
                 }
     
		// put firstline in result
                for(i=0;i<num+1;i++)
      d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      d7:	eb 23                	jmp    fc <uniq+0xfc>
                {
                result[i]=currentLine[i];
      d9:	8d 95 d4 d2 ff ff    	lea    -0x2d2c(%ebp),%edx
      df:	8b 45 f4             	mov    -0xc(%ebp),%eax
      e2:	01 d0                	add    %edx,%eax
      e4:	0f b6 00             	movzbl (%eax),%eax
      e7:	8d 8d b4 84 ff ff    	lea    -0x7b4c(%ebp),%ecx
      ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
      f0:	01 ca                	add    %ecx,%edx
      f2:	88 02                	mov    %al,(%edx)

		numCount++;
      f4:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
                     if(buf[j] == '\n')
                          TotalLines++;
                 }
     
		// put firstline in result
                for(i=0;i<num+1;i++)
      f8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
      ff:	83 c0 01             	add    $0x1,%eax
     102:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     105:	7f d2                	jg     d9 <uniq+0xd9>
                {
                result[i]=currentLine[i];

		numCount++;
                }
		result[i]='\0';	
     107:	8d 95 b4 84 ff ff    	lea    -0x7b4c(%ebp),%edx
     10d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     110:	01 d0                	add    %edx,%eax
     112:	c6 00 00             	movb   $0x0,(%eax)
		nextLineInt=i;
     115:	8b 45 f4             	mov    -0xc(%ebp),%eax
     118:	89 45 d8             	mov    %eax,-0x28(%ebp)

	// do the following continously until numLines = Total lines
	while(numLines<TotalLines-1){
     11b:	e9 60 05 00 00       	jmp    680 <uniq+0x680>
	numLines++;
     120:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
	s=nextLineInt;
     124:	8b 45 d8             	mov    -0x28(%ebp),%eax
     127:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	repeatIndex[numLines]=1;
     12a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     12d:	c7 84 85 20 f0 ff ff 	movl   $0x1,-0xfe0(%ebp,%eax,4)
     134:	01 00 00 00 
	z=nextLineInt;
     138:	8b 45 d8             	mov    -0x28(%ebp),%eax
     13b:	89 45 d0             	mov    %eax,-0x30(%ebp)
	count=0;	//amount of characters in each line
     13e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	//from the next line to the end of the line set char line to the character in the nextline
	for(i=nextLineInt;buf[i]!='\n';i++){
     145:	8b 45 d8             	mov    -0x28(%ebp),%eax
     148:	89 45 f4             	mov    %eax,-0xc(%ebp)
     14b:	eb 24                	jmp    171 <uniq+0x171>
			count++;
     14d:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
        		NextLine[k]=buf[i];
     151:	8b 45 f4             	mov    -0xc(%ebp),%eax
     154:	05 40 13 00 00       	add    $0x1340,%eax
     159:	0f b6 00             	movzbl (%eax),%eax
     15c:	8d 8d 5c e6 ff ff    	lea    -0x19a4(%ebp),%ecx
     162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     165:	01 ca                	add    %ecx,%edx
     167:	88 02                	mov    %al,(%edx)
			k++;
     169:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
	repeatIndex[numLines]=1;
	z=nextLineInt;
	count=0;	//amount of characters in each line

	//from the next line to the end of the line set char line to the character in the nextline
	for(i=nextLineInt;buf[i]!='\n';i++){
     16d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     171:	8b 45 f4             	mov    -0xc(%ebp),%eax
     174:	05 40 13 00 00       	add    $0x1340,%eax
     179:	0f b6 00             	movzbl (%eax),%eax
     17c:	3c 0a                	cmp    $0xa,%al
     17e:	75 cd                	jne    14d <uniq+0x14d>
			count++;
        		NextLine[k]=buf[i];
			k++;

        	}
	NextLine[i]='\0';
     180:	8d 95 5c e6 ff ff    	lea    -0x19a4(%ebp),%edx
     186:	8b 45 f4             	mov    -0xc(%ebp),%eax
     189:	01 d0                	add    %edx,%eax
     18b:	c6 00 00             	movb   $0x0,(%eax)
	
	k=0;
     18e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if(strcmp(currentLine,NextLine)==0){repeatIndex[numLines]+=1;} //increment repeatIndex everytime a line is duplicated
     195:	8d 85 5c e6 ff ff    	lea    -0x19a4(%ebp),%eax
     19b:	89 44 24 04          	mov    %eax,0x4(%esp)
     19f:	8d 85 d4 d2 ff ff    	lea    -0x2d2c(%ebp),%eax
     1a5:	89 04 24             	mov    %eax,(%esp)
     1a8:	e8 12 07 00 00       	call   8bf <strcmp>
     1ad:	85 c0                	test   %eax,%eax
     1af:	75 17                	jne    1c8 <uniq+0x1c8>
     1b1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     1b4:	8b 84 85 20 f0 ff ff 	mov    -0xfe0(%ebp,%eax,4),%eax
     1bb:	8d 50 01             	lea    0x1(%eax),%edx
     1be:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     1c1:	89 94 85 20 f0 ff ff 	mov    %edx,-0xfe0(%ebp,%eax,4)
	//you need a previous line to compare it to your current add nextline to the whole result
	if(strcmp(currentLine,NextLine)!=0){
     1c8:	8d 85 5c e6 ff ff    	lea    -0x19a4(%ebp),%eax
     1ce:	89 44 24 04          	mov    %eax,0x4(%esp)
     1d2:	8d 85 d4 d2 ff ff    	lea    -0x2d2c(%ebp),%eax
     1d8:	89 04 24             	mov    %eax,(%esp)
     1db:	e8 df 06 00 00       	call   8bf <strcmp>
     1e0:	85 c0                	test   %eax,%eax
     1e2:	0f 84 ce 03 00 00    	je     5b6 <uniq+0x5b6>
		for(l=0;l<count;l++){
     1e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     1ef:	eb 27                	jmp    218 <uniq+0x218>

			result[s]=NextLine[l];
     1f1:	8d 95 5c e6 ff ff    	lea    -0x19a4(%ebp),%edx
     1f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
     1fa:	01 d0                	add    %edx,%eax
     1fc:	0f b6 00             	movzbl (%eax),%eax
     1ff:	8d 8d b4 84 ff ff    	lea    -0x7b4c(%ebp),%ecx
     205:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     208:	01 ca                	add    %ecx,%edx
     20a:	88 02                	mov    %al,(%edx)
			s++;
     20c:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			numCount++;
     210:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
	
	k=0;
	if(strcmp(currentLine,NextLine)==0){repeatIndex[numLines]+=1;} //increment repeatIndex everytime a line is duplicated
	//you need a previous line to compare it to your current add nextline to the whole result
	if(strcmp(currentLine,NextLine)!=0){
		for(l=0;l<count;l++){
     214:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     218:	8b 45 ec             	mov    -0x14(%ebp),%eax
     21b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     21e:	7c d1                	jl     1f1 <uniq+0x1f1>

			result[s]=NextLine[l];
			s++;
			numCount++;
		}
		result[s]='\0'; 	
     220:	8d 95 b4 84 ff ff    	lea    -0x7b4c(%ebp),%edx
     226:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     229:	01 d0                	add    %edx,%eax
     22b:	c6 00 00             	movb   $0x0,(%eax)
	        
		// print amount of time each line is outputed
		if(strcmp(argNum,"-c")==0 || strcmp(argNum,"-C")==0){
     22e:	a1 20 13 00 00       	mov    0x1320,%eax
     233:	c7 44 24 04 3e 10 00 	movl   $0x103e,0x4(%esp)
     23a:	00 
     23b:	89 04 24             	mov    %eax,(%esp)
     23e:	e8 7c 06 00 00       	call   8bf <strcmp>
     243:	85 c0                	test   %eax,%eax
     245:	74 1d                	je     264 <uniq+0x264>
     247:	a1 20 13 00 00       	mov    0x1320,%eax
     24c:	c7 44 24 04 41 10 00 	movl   $0x1041,0x4(%esp)
     253:	00 
     254:	89 04 24             	mov    %eax,(%esp)
     257:	e8 63 06 00 00       	call   8bf <strcmp>
     25c:	85 c0                	test   %eax,%eax
     25e:	0f 85 c9 00 00 00    	jne    32d <uniq+0x32d>

			
			if(numLines==1){
     264:	83 7d c4 01          	cmpl   $0x1,-0x3c(%ebp)
     268:	75 43                	jne    2ad <uniq+0x2ad>
				printf(1,"%d", repeatIndex[numLines-1]);
     26a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     26d:	83 e8 01             	sub    $0x1,%eax
     270:	8b 84 85 20 f0 ff ff 	mov    -0xfe0(%ebp,%eax,4),%eax
     277:	89 44 24 08          	mov    %eax,0x8(%esp)
     27b:	c7 44 24 04 44 10 00 	movl   $0x1044,0x4(%esp)
     282:	00 
     283:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     28a:	e8 e3 09 00 00       	call   c72 <printf>
				printf(1, "%s \n",currentLine);
     28f:	8d 85 d4 d2 ff ff    	lea    -0x2d2c(%ebp),%eax
     295:	89 44 24 08          	mov    %eax,0x8(%esp)
     299:	c7 44 24 04 47 10 00 	movl   $0x1047,0x4(%esp)
     2a0:	00 
     2a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2a8:	e8 c5 09 00 00       	call   c72 <printf>
			}
			printf(1,"%d", repeatIndex[numLines-1]);
     2ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     2b0:	83 e8 01             	sub    $0x1,%eax
     2b3:	8b 84 85 20 f0 ff ff 	mov    -0xfe0(%ebp,%eax,4),%eax
     2ba:	89 44 24 08          	mov    %eax,0x8(%esp)
     2be:	c7 44 24 04 44 10 00 	movl   $0x1044,0x4(%esp)
     2c5:	00 
     2c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2cd:	e8 a0 09 00 00       	call   c72 <printf>
			for(e=0;e<count;e++){
     2d2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
     2d9:	eb 31                	jmp    30c <uniq+0x30c>
 				printf(1, "%c",result[z]);
     2db:	8d 95 b4 84 ff ff    	lea    -0x7b4c(%ebp),%edx
     2e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
     2e4:	01 d0                	add    %edx,%eax
     2e6:	0f b6 00             	movzbl (%eax),%eax
     2e9:	0f be c0             	movsbl %al,%eax
     2ec:	89 44 24 08          	mov    %eax,0x8(%esp)
     2f0:	c7 44 24 04 4c 10 00 	movl   $0x104c,0x4(%esp)
     2f7:	00 
     2f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2ff:	e8 6e 09 00 00       	call   c72 <printf>
				z++;
     304:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
			if(numLines==1){
				printf(1,"%d", repeatIndex[numLines-1]);
				printf(1, "%s \n",currentLine);
			}
			printf(1,"%d", repeatIndex[numLines-1]);
			for(e=0;e<count;e++){
     308:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
     30c:	8b 45 cc             	mov    -0x34(%ebp),%eax
     30f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     312:	7c c7                	jl     2db <uniq+0x2db>
 				printf(1, "%c",result[z]);
				z++;
			}
			printf(1, "\n");
     314:	c7 44 24 04 4f 10 00 	movl   $0x104f,0x4(%esp)
     31b:	00 
     31c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     323:	e8 4a 09 00 00       	call   c72 <printf>
     328:	e9 6c 02 00 00       	jmp    599 <uniq+0x599>
		}else if(strcmp(argNum,"-d")==0 || strcmp(argNum,"-D")==0){}
     32d:	a1 20 13 00 00       	mov    0x1320,%eax
     332:	c7 44 24 04 51 10 00 	movl   $0x1051,0x4(%esp)
     339:	00 
     33a:	89 04 24             	mov    %eax,(%esp)
     33d:	e8 7d 05 00 00       	call   8bf <strcmp>
     342:	85 c0                	test   %eax,%eax
     344:	0f 84 4f 02 00 00    	je     599 <uniq+0x599>
     34a:	a1 20 13 00 00       	mov    0x1320,%eax
     34f:	c7 44 24 04 54 10 00 	movl   $0x1054,0x4(%esp)
     356:	00 
     357:	89 04 24             	mov    %eax,(%esp)
     35a:	e8 60 05 00 00       	call   8bf <strcmp>
     35f:	85 c0                	test   %eax,%eax
     361:	0f 84 32 02 00 00    	je     599 <uniq+0x599>
		//convert currentline and nextline characters to capital letters then compare and print
		else if(strcmp(argNum,"-i")==0 || strcmp(argNum,"-I")==0){
     367:	a1 20 13 00 00       	mov    0x1320,%eax
     36c:	c7 44 24 04 57 10 00 	movl   $0x1057,0x4(%esp)
     373:	00 
     374:	89 04 24             	mov    %eax,(%esp)
     377:	e8 43 05 00 00       	call   8bf <strcmp>
     37c:	85 c0                	test   %eax,%eax
     37e:	74 1d                	je     39d <uniq+0x39d>
     380:	a1 20 13 00 00       	mov    0x1320,%eax
     385:	c7 44 24 04 5a 10 00 	movl   $0x105a,0x4(%esp)
     38c:	00 
     38d:	89 04 24             	mov    %eax,(%esp)
     390:	e8 2a 05 00 00       	call   8bf <strcmp>
     395:	85 c0                	test   %eax,%eax
     397:	0f 85 82 01 00 00    	jne    51f <uniq+0x51f>

			for(e=0;e<count;e++){
     39d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
     3a4:	e9 68 01 00 00       	jmp    511 <uniq+0x511>
		
			if((currentLine[e]>96) && (currentLine[e]<123)) currentLine[e] ^=0x20;
     3a9:	8d 95 d4 d2 ff ff    	lea    -0x2d2c(%ebp),%edx
     3af:	8b 45 cc             	mov    -0x34(%ebp),%eax
     3b2:	01 d0                	add    %edx,%eax
     3b4:	0f b6 00             	movzbl (%eax),%eax
     3b7:	3c 60                	cmp    $0x60,%al
     3b9:	7e 30                	jle    3eb <uniq+0x3eb>
     3bb:	8d 95 d4 d2 ff ff    	lea    -0x2d2c(%ebp),%edx
     3c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
     3c4:	01 d0                	add    %edx,%eax
     3c6:	0f b6 00             	movzbl (%eax),%eax
     3c9:	3c 7a                	cmp    $0x7a,%al
     3cb:	7f 1e                	jg     3eb <uniq+0x3eb>
     3cd:	8d 95 d4 d2 ff ff    	lea    -0x2d2c(%ebp),%edx
     3d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
     3d6:	01 d0                	add    %edx,%eax
     3d8:	0f b6 00             	movzbl (%eax),%eax
     3db:	83 f0 20             	xor    $0x20,%eax
     3de:	8d 8d d4 d2 ff ff    	lea    -0x2d2c(%ebp),%ecx
     3e4:	8b 55 cc             	mov    -0x34(%ebp),%edx
     3e7:	01 ca                	add    %ecx,%edx
     3e9:	88 02                	mov    %al,(%edx)
			if((NextLine[e]>96) && (NextLine[e]<123)) NextLine[e] ^=0x20;
     3eb:	8d 95 5c e6 ff ff    	lea    -0x19a4(%ebp),%edx
     3f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
     3f4:	01 d0                	add    %edx,%eax
     3f6:	0f b6 00             	movzbl (%eax),%eax
     3f9:	3c 60                	cmp    $0x60,%al
     3fb:	7e 30                	jle    42d <uniq+0x42d>
     3fd:	8d 95 5c e6 ff ff    	lea    -0x19a4(%ebp),%edx
     403:	8b 45 cc             	mov    -0x34(%ebp),%eax
     406:	01 d0                	add    %edx,%eax
     408:	0f b6 00             	movzbl (%eax),%eax
     40b:	3c 7a                	cmp    $0x7a,%al
     40d:	7f 1e                	jg     42d <uniq+0x42d>
     40f:	8d 95 5c e6 ff ff    	lea    -0x19a4(%ebp),%edx
     415:	8b 45 cc             	mov    -0x34(%ebp),%eax
     418:	01 d0                	add    %edx,%eax
     41a:	0f b6 00             	movzbl (%eax),%eax
     41d:	83 f0 20             	xor    $0x20,%eax
     420:	8d 8d 5c e6 ff ff    	lea    -0x19a4(%ebp),%ecx
     426:	8b 55 cc             	mov    -0x34(%ebp),%edx
     429:	01 ca                	add    %ecx,%edx
     42b:	88 02                	mov    %al,(%edx)
			if(strcmp(currentLine,NextLine)!=0){
     42d:	8d 85 5c e6 ff ff    	lea    -0x19a4(%ebp),%eax
     433:	89 44 24 04          	mov    %eax,0x4(%esp)
     437:	8d 85 d4 d2 ff ff    	lea    -0x2d2c(%ebp),%eax
     43d:	89 04 24             	mov    %eax,(%esp)
     440:	e8 7a 04 00 00       	call   8bf <strcmp>
     445:	85 c0                	test   %eax,%eax
     447:	0f 84 c0 00 00 00    	je     50d <uniq+0x50d>
				for(l=0;l<count;l++){
     44d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     454:	eb 27                	jmp    47d <uniq+0x47d>

					result[s]=NextLine[l];
     456:	8d 95 5c e6 ff ff    	lea    -0x19a4(%ebp),%edx
     45c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     45f:	01 d0                	add    %edx,%eax
     461:	0f b6 00             	movzbl (%eax),%eax
     464:	8d 8d b4 84 ff ff    	lea    -0x7b4c(%ebp),%ecx
     46a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     46d:	01 ca                	add    %ecx,%edx
     46f:	88 02                	mov    %al,(%edx)

					s++;
     471:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
					numCount++;
     475:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
			for(e=0;e<count;e++){
		
			if((currentLine[e]>96) && (currentLine[e]<123)) currentLine[e] ^=0x20;
			if((NextLine[e]>96) && (NextLine[e]<123)) NextLine[e] ^=0x20;
			if(strcmp(currentLine,NextLine)!=0){
				for(l=0;l<count;l++){
     479:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     47d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     480:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     483:	7c d1                	jl     456 <uniq+0x456>
					numCount++;


					}
	
				result[s]='\0';
     485:	8d 95 b4 84 ff ff    	lea    -0x7b4c(%ebp),%edx
     48b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     48e:	01 d0                	add    %edx,%eax
     490:	c6 00 00             	movb   $0x0,(%eax)
				if(numLines==1){
     493:	83 7d c4 01          	cmpl   $0x1,-0x3c(%ebp)
     497:	75 1e                	jne    4b7 <uniq+0x4b7>
					printf(1, "%s \n",currentLine);
     499:	8d 85 d4 d2 ff ff    	lea    -0x2d2c(%ebp),%eax
     49f:	89 44 24 08          	mov    %eax,0x8(%esp)
     4a3:	c7 44 24 04 47 10 00 	movl   $0x1047,0x4(%esp)
     4aa:	00 
     4ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4b2:	e8 bb 07 00 00       	call   c72 <printf>
				}
				for(e=0;e<count;e++){
     4b7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
     4be:	eb 31                	jmp    4f1 <uniq+0x4f1>
 					printf(1, "%c",result[z]);
     4c0:	8d 95 b4 84 ff ff    	lea    -0x7b4c(%ebp),%edx
     4c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
     4c9:	01 d0                	add    %edx,%eax
     4cb:	0f b6 00             	movzbl (%eax),%eax
     4ce:	0f be c0             	movsbl %al,%eax
     4d1:	89 44 24 08          	mov    %eax,0x8(%esp)
     4d5:	c7 44 24 04 4c 10 00 	movl   $0x104c,0x4(%esp)
     4dc:	00 
     4dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4e4:	e8 89 07 00 00       	call   c72 <printf>
					z++;
     4e9:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
	
				result[s]='\0';
				if(numLines==1){
					printf(1, "%s \n",currentLine);
				}
				for(e=0;e<count;e++){
     4ed:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
     4f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
     4f4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     4f7:	7c c7                	jl     4c0 <uniq+0x4c0>
 					printf(1, "%c",result[z]);
					z++;
				}
				printf(1, "\n");
     4f9:	c7 44 24 04 4f 10 00 	movl   $0x104f,0x4(%esp)
     500:	00 
     501:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     508:	e8 65 07 00 00       	call   c72 <printf>
			printf(1, "\n");
		}else if(strcmp(argNum,"-d")==0 || strcmp(argNum,"-D")==0){}
		//convert currentline and nextline characters to capital letters then compare and print
		else if(strcmp(argNum,"-i")==0 || strcmp(argNum,"-I")==0){

			for(e=0;e<count;e++){
     50d:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
     511:	8b 45 cc             	mov    -0x34(%ebp),%eax
     514:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     517:	0f 8c 8c fe ff ff    	jl     3a9 <uniq+0x3a9>
				z++;
			}
			printf(1, "\n");
		}else if(strcmp(argNum,"-d")==0 || strcmp(argNum,"-D")==0){}
		//convert currentline and nextline characters to capital letters then compare and print
		else if(strcmp(argNum,"-i")==0 || strcmp(argNum,"-I")==0){
     51d:	eb 7a                	jmp    599 <uniq+0x599>
				}
				printf(1, "\n");
			 }
		}
		}else {
			if(numLines==1){
     51f:	83 7d c4 01          	cmpl   $0x1,-0x3c(%ebp)
     523:	75 1e                	jne    543 <uniq+0x543>
				printf(1, "%s \n",currentLine);
     525:	8d 85 d4 d2 ff ff    	lea    -0x2d2c(%ebp),%eax
     52b:	89 44 24 08          	mov    %eax,0x8(%esp)
     52f:	c7 44 24 04 47 10 00 	movl   $0x1047,0x4(%esp)
     536:	00 
     537:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     53e:	e8 2f 07 00 00       	call   c72 <printf>
			}
			for(e=0;e<count;e++){
     543:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
     54a:	eb 31                	jmp    57d <uniq+0x57d>
 				printf(1, "%c",result[z]);
     54c:	8d 95 b4 84 ff ff    	lea    -0x7b4c(%ebp),%edx
     552:	8b 45 d0             	mov    -0x30(%ebp),%eax
     555:	01 d0                	add    %edx,%eax
     557:	0f b6 00             	movzbl (%eax),%eax
     55a:	0f be c0             	movsbl %al,%eax
     55d:	89 44 24 08          	mov    %eax,0x8(%esp)
     561:	c7 44 24 04 4c 10 00 	movl   $0x104c,0x4(%esp)
     568:	00 
     569:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     570:	e8 fd 06 00 00       	call   c72 <printf>
				z++;
     575:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
		}
		}else {
			if(numLines==1){
				printf(1, "%s \n",currentLine);
			}
			for(e=0;e<count;e++){
     579:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
     57d:	8b 45 cc             	mov    -0x34(%ebp),%eax
     580:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     583:	7c c7                	jl     54c <uniq+0x54c>
 				printf(1, "%c",result[z]);
				z++;
			}
			printf(1, "\n");
     585:	c7 44 24 04 4f 10 00 	movl   $0x104f,0x4(%esp)
     58c:	00 
     58d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     594:	e8 d9 06 00 00       	call   c72 <printf>
		}
	strcpy(currentLine,NextLine);
     599:	8d 85 5c e6 ff ff    	lea    -0x19a4(%ebp),%eax
     59f:	89 44 24 04          	mov    %eax,0x4(%esp)
     5a3:	8d 85 d4 d2 ff ff    	lea    -0x2d2c(%ebp),%eax
     5a9:	89 04 24             	mov    %eax,(%esp)
     5ac:	e8 de 02 00 00       	call   88f <strcpy>
     5b1:	e9 bc 00 00 00       	jmp    672 <uniq+0x672>
	//Only print duplicate lines
	}else if(strcmp(currentLine,NextLine)==0 && (strcmp(argNum,"-d")==0 || strcmp(argNum,"-D")==0)){ 
     5b6:	8d 85 5c e6 ff ff    	lea    -0x19a4(%ebp),%eax
     5bc:	89 44 24 04          	mov    %eax,0x4(%esp)
     5c0:	8d 85 d4 d2 ff ff    	lea    -0x2d2c(%ebp),%eax
     5c6:	89 04 24             	mov    %eax,(%esp)
     5c9:	e8 f1 02 00 00       	call   8bf <strcmp>
     5ce:	85 c0                	test   %eax,%eax
     5d0:	0f 85 9c 00 00 00    	jne    672 <uniq+0x672>
     5d6:	a1 20 13 00 00       	mov    0x1320,%eax
     5db:	c7 44 24 04 51 10 00 	movl   $0x1051,0x4(%esp)
     5e2:	00 
     5e3:	89 04 24             	mov    %eax,(%esp)
     5e6:	e8 d4 02 00 00       	call   8bf <strcmp>
     5eb:	85 c0                	test   %eax,%eax
     5ed:	74 19                	je     608 <uniq+0x608>
     5ef:	a1 20 13 00 00       	mov    0x1320,%eax
     5f4:	c7 44 24 04 54 10 00 	movl   $0x1054,0x4(%esp)
     5fb:	00 
     5fc:	89 04 24             	mov    %eax,(%esp)
     5ff:	e8 bb 02 00 00       	call   8bf <strcmp>
     604:	85 c0                	test   %eax,%eax
     606:	75 6a                	jne    672 <uniq+0x672>

	strcpy(currentLine,NextLine);
     608:	8d 85 5c e6 ff ff    	lea    -0x19a4(%ebp),%eax
     60e:	89 44 24 04          	mov    %eax,0x4(%esp)
     612:	8d 85 d4 d2 ff ff    	lea    -0x2d2c(%ebp),%eax
     618:	89 04 24             	mov    %eax,(%esp)
     61b:	e8 6f 02 00 00       	call   88f <strcpy>
	if(strcmp(repeat,NextLine)!=0){
     620:	8d 85 5c e6 ff ff    	lea    -0x19a4(%ebp),%eax
     626:	89 44 24 04          	mov    %eax,0x4(%esp)
     62a:	8d 85 98 dc ff ff    	lea    -0x2368(%ebp),%eax
     630:	89 04 24             	mov    %eax,(%esp)
     633:	e8 87 02 00 00       	call   8bf <strcmp>
     638:	85 c0                	test   %eax,%eax
     63a:	74 36                	je     672 <uniq+0x672>
		printf(1, "%s \n",NextLine);
     63c:	8d 85 5c e6 ff ff    	lea    -0x19a4(%ebp),%eax
     642:	89 44 24 08          	mov    %eax,0x8(%esp)
     646:	c7 44 24 04 47 10 00 	movl   $0x1047,0x4(%esp)
     64d:	00 
     64e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     655:	e8 18 06 00 00       	call   c72 <printf>
		strcpy(repeat,currentLine);
     65a:	8d 85 d4 d2 ff ff    	lea    -0x2d2c(%ebp),%eax
     660:	89 44 24 04          	mov    %eax,0x4(%esp)
     664:	8d 85 98 dc ff ff    	lea    -0x2368(%ebp),%eax
     66a:	89 04 24             	mov    %eax,(%esp)
     66d:	e8 1d 02 00 00       	call   88f <strcpy>
	
	
	
	}
	
	nextLineInt=nextLineInt+count+1;
     672:	8b 45 e8             	mov    -0x18(%ebp),%eax
     675:	8b 55 d8             	mov    -0x28(%ebp),%edx
     678:	01 d0                	add    %edx,%eax
     67a:	83 c0 01             	add    $0x1,%eax
     67d:	89 45 d8             	mov    %eax,-0x28(%ebp)
                }
		result[i]='\0';	
		nextLineInt=i;

	// do the following continously until numLines = Total lines
	while(numLines<TotalLines-1){
     680:	8b 45 dc             	mov    -0x24(%ebp),%eax
     683:	83 e8 01             	sub    $0x1,%eax
     686:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
     689:	0f 8f 91 fa ff ff    	jg     120 <uniq+0x120>
  char repeat[2500];
  char currentLine[2500];
  char result[20000];


  while((n = read(fd, buf, sizeof(buf))) > 0){
     68f:	c7 44 24 08 00 20 4e 	movl   $0x4e2000,0x8(%esp)
     696:	00 
     697:	c7 44 24 04 40 13 00 	movl   $0x1340,0x4(%esp)
     69e:	00 
     69f:	8b 45 08             	mov    0x8(%ebp),%eax
     6a2:	89 04 24             	mov    %eax,(%esp)
     6a5:	e8 40 04 00 00       	call   aea <read>
     6aa:	89 45 c0             	mov    %eax,-0x40(%ebp)
     6ad:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
     6b1:	0f 8f 9d f9 ff ff    	jg     54 <uniq+0x54>
	
	}


	
  }strcpy(result,NextLine);
     6b7:	8d 85 5c e6 ff ff    	lea    -0x19a4(%ebp),%eax
     6bd:	89 44 24 04          	mov    %eax,0x4(%esp)
     6c1:	8d 85 b4 84 ff ff    	lea    -0x7b4c(%ebp),%eax
     6c7:	89 04 24             	mov    %eax,(%esp)
     6ca:	e8 c0 01 00 00       	call   88f <strcpy>
		
	

}
     6cf:	c9                   	leave  
     6d0:	c3                   	ret    

000006d1 <main>:

int
main(int argc, char *argv[])
{
     6d1:	55                   	push   %ebp
     6d2:	89 e5                	mov    %esp,%ebp
     6d4:	83 e4 f0             	and    $0xfffffff0,%esp
     6d7:	83 ec 20             	sub    $0x20,%esp
  int fd, i,j;

  if(argc <= 1){
     6da:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     6de:	7f 19                	jg     6f9 <main+0x28>
    uniq(0, "");
     6e0:	c7 44 24 04 5d 10 00 	movl   $0x105d,0x4(%esp)
     6e7:	00 
     6e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     6ef:	e8 0c f9 ff ff       	call   0 <uniq>
    exit();
     6f4:	e8 d9 03 00 00       	call   ad2 <exit>
  }else if(argc==2){
     6f9:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
     6fd:	0f 85 ae 00 00 00    	jne    7b1 <main+0xe0>

  for(i = 1; i < argc; i++){
     703:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
     70a:	00 
     70b:	e9 8f 00 00 00       	jmp    79f <main+0xce>
    if((fd = open(argv[i], 0)) < 0){
     710:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     714:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     71b:	8b 45 0c             	mov    0xc(%ebp),%eax
     71e:	01 d0                	add    %edx,%eax
     720:	8b 00                	mov    (%eax),%eax
     722:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     729:	00 
     72a:	89 04 24             	mov    %eax,(%esp)
     72d:	e8 e0 03 00 00       	call   b12 <open>
     732:	89 44 24 14          	mov    %eax,0x14(%esp)
     736:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
     73b:	79 2f                	jns    76c <main+0x9b>
      printf(1, "uniq: cannot open %s\n", argv[i]);
     73d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     741:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     748:	8b 45 0c             	mov    0xc(%ebp),%eax
     74b:	01 d0                	add    %edx,%eax
     74d:	8b 00                	mov    (%eax),%eax
     74f:	89 44 24 08          	mov    %eax,0x8(%esp)
     753:	c7 44 24 04 5e 10 00 	movl   $0x105e,0x4(%esp)
     75a:	00 
     75b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     762:	e8 0b 05 00 00       	call   c72 <printf>
      exit();
     767:	e8 66 03 00 00       	call   ad2 <exit>
    }
    uniq(fd, argv[i]);
     76c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     770:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     777:	8b 45 0c             	mov    0xc(%ebp),%eax
     77a:	01 d0                	add    %edx,%eax
     77c:	8b 00                	mov    (%eax),%eax
     77e:	89 44 24 04          	mov    %eax,0x4(%esp)
     782:	8b 44 24 14          	mov    0x14(%esp),%eax
     786:	89 04 24             	mov    %eax,(%esp)
     789:	e8 72 f8 ff ff       	call   0 <uniq>
    close(fd);
     78e:	8b 44 24 14          	mov    0x14(%esp),%eax
     792:	89 04 24             	mov    %eax,(%esp)
     795:	e8 60 03 00 00       	call   afa <close>
  if(argc <= 1){
    uniq(0, "");
    exit();
  }else if(argc==2){

  for(i = 1; i < argc; i++){
     79a:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
     79f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     7a3:	3b 45 08             	cmp    0x8(%ebp),%eax
     7a6:	0f 8c 64 ff ff ff    	jl     710 <main+0x3f>
      exit();
    }
    uniq(fd, argv[i]);
    close(fd);
  }
  exit();
     7ac:	e8 21 03 00 00       	call   ad2 <exit>
}else{

for(j = 2; j < argc; j++){
     7b1:	c7 44 24 18 02 00 00 	movl   $0x2,0x18(%esp)
     7b8:	00 
     7b9:	e9 9a 00 00 00       	jmp    858 <main+0x187>
    if((fd = open(argv[j], 0)) < 0){
     7be:	8b 44 24 18          	mov    0x18(%esp),%eax
     7c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     7c9:	8b 45 0c             	mov    0xc(%ebp),%eax
     7cc:	01 d0                	add    %edx,%eax
     7ce:	8b 00                	mov    (%eax),%eax
     7d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     7d7:	00 
     7d8:	89 04 24             	mov    %eax,(%esp)
     7db:	e8 32 03 00 00       	call   b12 <open>
     7e0:	89 44 24 14          	mov    %eax,0x14(%esp)
     7e4:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
     7e9:	79 2f                	jns    81a <main+0x149>
      printf(1,"uniq: cannot open %s\n", argv[j]);
     7eb:	8b 44 24 18          	mov    0x18(%esp),%eax
     7ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     7f6:	8b 45 0c             	mov    0xc(%ebp),%eax
     7f9:	01 d0                	add    %edx,%eax
     7fb:	8b 00                	mov    (%eax),%eax
     7fd:	89 44 24 08          	mov    %eax,0x8(%esp)
     801:	c7 44 24 04 5e 10 00 	movl   $0x105e,0x4(%esp)
     808:	00 
     809:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     810:	e8 5d 04 00 00       	call   c72 <printf>
      exit();
     815:	e8 b8 02 00 00       	call   ad2 <exit>
    }
    argNum=argv[1];
     81a:	8b 45 0c             	mov    0xc(%ebp),%eax
     81d:	8b 40 04             	mov    0x4(%eax),%eax
     820:	a3 20 13 00 00       	mov    %eax,0x1320
    uniq(fd, argv[j]);
     825:	8b 44 24 18          	mov    0x18(%esp),%eax
     829:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     830:	8b 45 0c             	mov    0xc(%ebp),%eax
     833:	01 d0                	add    %edx,%eax
     835:	8b 00                	mov    (%eax),%eax
     837:	89 44 24 04          	mov    %eax,0x4(%esp)
     83b:	8b 44 24 14          	mov    0x14(%esp),%eax
     83f:	89 04 24             	mov    %eax,(%esp)
     842:	e8 b9 f7 ff ff       	call   0 <uniq>
    close(fd);
     847:	8b 44 24 14          	mov    0x14(%esp),%eax
     84b:	89 04 24             	mov    %eax,(%esp)
     84e:	e8 a7 02 00 00       	call   afa <close>
    close(fd);
  }
  exit();
}else{

for(j = 2; j < argc; j++){
     853:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
     858:	8b 44 24 18          	mov    0x18(%esp),%eax
     85c:	3b 45 08             	cmp    0x8(%ebp),%eax
     85f:	0f 8c 59 ff ff ff    	jl     7be <main+0xed>
    }
    argNum=argv[1];
    uniq(fd, argv[j]);
    close(fd);
  }
  exit();
     865:	e8 68 02 00 00       	call   ad2 <exit>

0000086a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     86a:	55                   	push   %ebp
     86b:	89 e5                	mov    %esp,%ebp
     86d:	57                   	push   %edi
     86e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     86f:	8b 4d 08             	mov    0x8(%ebp),%ecx
     872:	8b 55 10             	mov    0x10(%ebp),%edx
     875:	8b 45 0c             	mov    0xc(%ebp),%eax
     878:	89 cb                	mov    %ecx,%ebx
     87a:	89 df                	mov    %ebx,%edi
     87c:	89 d1                	mov    %edx,%ecx
     87e:	fc                   	cld    
     87f:	f3 aa                	rep stos %al,%es:(%edi)
     881:	89 ca                	mov    %ecx,%edx
     883:	89 fb                	mov    %edi,%ebx
     885:	89 5d 08             	mov    %ebx,0x8(%ebp)
     888:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     88b:	5b                   	pop    %ebx
     88c:	5f                   	pop    %edi
     88d:	5d                   	pop    %ebp
     88e:	c3                   	ret    

0000088f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     88f:	55                   	push   %ebp
     890:	89 e5                	mov    %esp,%ebp
     892:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     895:	8b 45 08             	mov    0x8(%ebp),%eax
     898:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     89b:	90                   	nop
     89c:	8b 45 08             	mov    0x8(%ebp),%eax
     89f:	8d 50 01             	lea    0x1(%eax),%edx
     8a2:	89 55 08             	mov    %edx,0x8(%ebp)
     8a5:	8b 55 0c             	mov    0xc(%ebp),%edx
     8a8:	8d 4a 01             	lea    0x1(%edx),%ecx
     8ab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     8ae:	0f b6 12             	movzbl (%edx),%edx
     8b1:	88 10                	mov    %dl,(%eax)
     8b3:	0f b6 00             	movzbl (%eax),%eax
     8b6:	84 c0                	test   %al,%al
     8b8:	75 e2                	jne    89c <strcpy+0xd>
    ;
  return os;
     8ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     8bd:	c9                   	leave  
     8be:	c3                   	ret    

000008bf <strcmp>:

int
strcmp(const char *p, const char *q)
{
     8bf:	55                   	push   %ebp
     8c0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     8c2:	eb 08                	jmp    8cc <strcmp+0xd>
    p++, q++;
     8c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     8c8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     8cc:	8b 45 08             	mov    0x8(%ebp),%eax
     8cf:	0f b6 00             	movzbl (%eax),%eax
     8d2:	84 c0                	test   %al,%al
     8d4:	74 10                	je     8e6 <strcmp+0x27>
     8d6:	8b 45 08             	mov    0x8(%ebp),%eax
     8d9:	0f b6 10             	movzbl (%eax),%edx
     8dc:	8b 45 0c             	mov    0xc(%ebp),%eax
     8df:	0f b6 00             	movzbl (%eax),%eax
     8e2:	38 c2                	cmp    %al,%dl
     8e4:	74 de                	je     8c4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     8e6:	8b 45 08             	mov    0x8(%ebp),%eax
     8e9:	0f b6 00             	movzbl (%eax),%eax
     8ec:	0f b6 d0             	movzbl %al,%edx
     8ef:	8b 45 0c             	mov    0xc(%ebp),%eax
     8f2:	0f b6 00             	movzbl (%eax),%eax
     8f5:	0f b6 c0             	movzbl %al,%eax
     8f8:	29 c2                	sub    %eax,%edx
     8fa:	89 d0                	mov    %edx,%eax
}
     8fc:	5d                   	pop    %ebp
     8fd:	c3                   	ret    

000008fe <strlen>:

uint
strlen(char *s)
{
     8fe:	55                   	push   %ebp
     8ff:	89 e5                	mov    %esp,%ebp
     901:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     904:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     90b:	eb 04                	jmp    911 <strlen+0x13>
     90d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     911:	8b 55 fc             	mov    -0x4(%ebp),%edx
     914:	8b 45 08             	mov    0x8(%ebp),%eax
     917:	01 d0                	add    %edx,%eax
     919:	0f b6 00             	movzbl (%eax),%eax
     91c:	84 c0                	test   %al,%al
     91e:	75 ed                	jne    90d <strlen+0xf>
    ;
  return n;
     920:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     923:	c9                   	leave  
     924:	c3                   	ret    

00000925 <memset>:

void*
memset(void *dst, int c, uint n)
{
     925:	55                   	push   %ebp
     926:	89 e5                	mov    %esp,%ebp
     928:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     92b:	8b 45 10             	mov    0x10(%ebp),%eax
     92e:	89 44 24 08          	mov    %eax,0x8(%esp)
     932:	8b 45 0c             	mov    0xc(%ebp),%eax
     935:	89 44 24 04          	mov    %eax,0x4(%esp)
     939:	8b 45 08             	mov    0x8(%ebp),%eax
     93c:	89 04 24             	mov    %eax,(%esp)
     93f:	e8 26 ff ff ff       	call   86a <stosb>
  return dst;
     944:	8b 45 08             	mov    0x8(%ebp),%eax
}
     947:	c9                   	leave  
     948:	c3                   	ret    

00000949 <strchr>:

char*
strchr(const char *s, char c)
{
     949:	55                   	push   %ebp
     94a:	89 e5                	mov    %esp,%ebp
     94c:	83 ec 04             	sub    $0x4,%esp
     94f:	8b 45 0c             	mov    0xc(%ebp),%eax
     952:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     955:	eb 14                	jmp    96b <strchr+0x22>
    if(*s == c)
     957:	8b 45 08             	mov    0x8(%ebp),%eax
     95a:	0f b6 00             	movzbl (%eax),%eax
     95d:	3a 45 fc             	cmp    -0x4(%ebp),%al
     960:	75 05                	jne    967 <strchr+0x1e>
      return (char*)s;
     962:	8b 45 08             	mov    0x8(%ebp),%eax
     965:	eb 13                	jmp    97a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     967:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     96b:	8b 45 08             	mov    0x8(%ebp),%eax
     96e:	0f b6 00             	movzbl (%eax),%eax
     971:	84 c0                	test   %al,%al
     973:	75 e2                	jne    957 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     975:	b8 00 00 00 00       	mov    $0x0,%eax
}
     97a:	c9                   	leave  
     97b:	c3                   	ret    

0000097c <gets>:

char*
gets(char *buf, int max)
{
     97c:	55                   	push   %ebp
     97d:	89 e5                	mov    %esp,%ebp
     97f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     982:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     989:	eb 4c                	jmp    9d7 <gets+0x5b>
    cc = read(0, &c, 1);
     98b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     992:	00 
     993:	8d 45 ef             	lea    -0x11(%ebp),%eax
     996:	89 44 24 04          	mov    %eax,0x4(%esp)
     99a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     9a1:	e8 44 01 00 00       	call   aea <read>
     9a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     9a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     9ad:	7f 02                	jg     9b1 <gets+0x35>
      break;
     9af:	eb 31                	jmp    9e2 <gets+0x66>
    buf[i++] = c;
     9b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9b4:	8d 50 01             	lea    0x1(%eax),%edx
     9b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
     9ba:	89 c2                	mov    %eax,%edx
     9bc:	8b 45 08             	mov    0x8(%ebp),%eax
     9bf:	01 c2                	add    %eax,%edx
     9c1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     9c5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     9c7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     9cb:	3c 0a                	cmp    $0xa,%al
     9cd:	74 13                	je     9e2 <gets+0x66>
     9cf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     9d3:	3c 0d                	cmp    $0xd,%al
     9d5:	74 0b                	je     9e2 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9da:	83 c0 01             	add    $0x1,%eax
     9dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
     9e0:	7c a9                	jl     98b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     9e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9e5:	8b 45 08             	mov    0x8(%ebp),%eax
     9e8:	01 d0                	add    %edx,%eax
     9ea:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     9ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9f0:	c9                   	leave  
     9f1:	c3                   	ret    

000009f2 <stat>:

int
stat(char *n, struct stat *st)
{
     9f2:	55                   	push   %ebp
     9f3:	89 e5                	mov    %esp,%ebp
     9f5:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     9f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     9ff:	00 
     a00:	8b 45 08             	mov    0x8(%ebp),%eax
     a03:	89 04 24             	mov    %eax,(%esp)
     a06:	e8 07 01 00 00       	call   b12 <open>
     a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     a0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     a12:	79 07                	jns    a1b <stat+0x29>
    return -1;
     a14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a19:	eb 23                	jmp    a3e <stat+0x4c>
  r = fstat(fd, st);
     a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
     a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
     a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a25:	89 04 24             	mov    %eax,(%esp)
     a28:	e8 fd 00 00 00       	call   b2a <fstat>
     a2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a33:	89 04 24             	mov    %eax,(%esp)
     a36:	e8 bf 00 00 00       	call   afa <close>
  return r;
     a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     a3e:	c9                   	leave  
     a3f:	c3                   	ret    

00000a40 <atoi>:

int
atoi(const char *s)
{
     a40:	55                   	push   %ebp
     a41:	89 e5                	mov    %esp,%ebp
     a43:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     a46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     a4d:	eb 25                	jmp    a74 <atoi+0x34>
    n = n*10 + *s++ - '0';
     a4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a52:	89 d0                	mov    %edx,%eax
     a54:	c1 e0 02             	shl    $0x2,%eax
     a57:	01 d0                	add    %edx,%eax
     a59:	01 c0                	add    %eax,%eax
     a5b:	89 c1                	mov    %eax,%ecx
     a5d:	8b 45 08             	mov    0x8(%ebp),%eax
     a60:	8d 50 01             	lea    0x1(%eax),%edx
     a63:	89 55 08             	mov    %edx,0x8(%ebp)
     a66:	0f b6 00             	movzbl (%eax),%eax
     a69:	0f be c0             	movsbl %al,%eax
     a6c:	01 c8                	add    %ecx,%eax
     a6e:	83 e8 30             	sub    $0x30,%eax
     a71:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a74:	8b 45 08             	mov    0x8(%ebp),%eax
     a77:	0f b6 00             	movzbl (%eax),%eax
     a7a:	3c 2f                	cmp    $0x2f,%al
     a7c:	7e 0a                	jle    a88 <atoi+0x48>
     a7e:	8b 45 08             	mov    0x8(%ebp),%eax
     a81:	0f b6 00             	movzbl (%eax),%eax
     a84:	3c 39                	cmp    $0x39,%al
     a86:	7e c7                	jle    a4f <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     a88:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     a8b:	c9                   	leave  
     a8c:	c3                   	ret    

00000a8d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     a8d:	55                   	push   %ebp
     a8e:	89 e5                	mov    %esp,%ebp
     a90:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     a93:	8b 45 08             	mov    0x8(%ebp),%eax
     a96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     a99:	8b 45 0c             	mov    0xc(%ebp),%eax
     a9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     a9f:	eb 17                	jmp    ab8 <memmove+0x2b>
    *dst++ = *src++;
     aa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
     aa4:	8d 50 01             	lea    0x1(%eax),%edx
     aa7:	89 55 fc             	mov    %edx,-0x4(%ebp)
     aaa:	8b 55 f8             	mov    -0x8(%ebp),%edx
     aad:	8d 4a 01             	lea    0x1(%edx),%ecx
     ab0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     ab3:	0f b6 12             	movzbl (%edx),%edx
     ab6:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     ab8:	8b 45 10             	mov    0x10(%ebp),%eax
     abb:	8d 50 ff             	lea    -0x1(%eax),%edx
     abe:	89 55 10             	mov    %edx,0x10(%ebp)
     ac1:	85 c0                	test   %eax,%eax
     ac3:	7f dc                	jg     aa1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     ac5:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ac8:	c9                   	leave  
     ac9:	c3                   	ret    

00000aca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     aca:	b8 01 00 00 00       	mov    $0x1,%eax
     acf:	cd 40                	int    $0x40
     ad1:	c3                   	ret    

00000ad2 <exit>:
SYSCALL(exit)
     ad2:	b8 02 00 00 00       	mov    $0x2,%eax
     ad7:	cd 40                	int    $0x40
     ad9:	c3                   	ret    

00000ada <wait>:
SYSCALL(wait)
     ada:	b8 03 00 00 00       	mov    $0x3,%eax
     adf:	cd 40                	int    $0x40
     ae1:	c3                   	ret    

00000ae2 <pipe>:
SYSCALL(pipe)
     ae2:	b8 04 00 00 00       	mov    $0x4,%eax
     ae7:	cd 40                	int    $0x40
     ae9:	c3                   	ret    

00000aea <read>:
SYSCALL(read)
     aea:	b8 05 00 00 00       	mov    $0x5,%eax
     aef:	cd 40                	int    $0x40
     af1:	c3                   	ret    

00000af2 <write>:
SYSCALL(write)
     af2:	b8 10 00 00 00       	mov    $0x10,%eax
     af7:	cd 40                	int    $0x40
     af9:	c3                   	ret    

00000afa <close>:
SYSCALL(close)
     afa:	b8 15 00 00 00       	mov    $0x15,%eax
     aff:	cd 40                	int    $0x40
     b01:	c3                   	ret    

00000b02 <kill>:
SYSCALL(kill)
     b02:	b8 06 00 00 00       	mov    $0x6,%eax
     b07:	cd 40                	int    $0x40
     b09:	c3                   	ret    

00000b0a <exec>:
SYSCALL(exec)
     b0a:	b8 07 00 00 00       	mov    $0x7,%eax
     b0f:	cd 40                	int    $0x40
     b11:	c3                   	ret    

00000b12 <open>:
SYSCALL(open)
     b12:	b8 0f 00 00 00       	mov    $0xf,%eax
     b17:	cd 40                	int    $0x40
     b19:	c3                   	ret    

00000b1a <mknod>:
SYSCALL(mknod)
     b1a:	b8 11 00 00 00       	mov    $0x11,%eax
     b1f:	cd 40                	int    $0x40
     b21:	c3                   	ret    

00000b22 <unlink>:
SYSCALL(unlink)
     b22:	b8 12 00 00 00       	mov    $0x12,%eax
     b27:	cd 40                	int    $0x40
     b29:	c3                   	ret    

00000b2a <fstat>:
SYSCALL(fstat)
     b2a:	b8 08 00 00 00       	mov    $0x8,%eax
     b2f:	cd 40                	int    $0x40
     b31:	c3                   	ret    

00000b32 <link>:
SYSCALL(link)
     b32:	b8 13 00 00 00       	mov    $0x13,%eax
     b37:	cd 40                	int    $0x40
     b39:	c3                   	ret    

00000b3a <mkdir>:
SYSCALL(mkdir)
     b3a:	b8 14 00 00 00       	mov    $0x14,%eax
     b3f:	cd 40                	int    $0x40
     b41:	c3                   	ret    

00000b42 <chdir>:
SYSCALL(chdir)
     b42:	b8 09 00 00 00       	mov    $0x9,%eax
     b47:	cd 40                	int    $0x40
     b49:	c3                   	ret    

00000b4a <dup>:
SYSCALL(dup)
     b4a:	b8 0a 00 00 00       	mov    $0xa,%eax
     b4f:	cd 40                	int    $0x40
     b51:	c3                   	ret    

00000b52 <getpid>:
SYSCALL(getpid)
     b52:	b8 0b 00 00 00       	mov    $0xb,%eax
     b57:	cd 40                	int    $0x40
     b59:	c3                   	ret    

00000b5a <sbrk>:
SYSCALL(sbrk)
     b5a:	b8 0c 00 00 00       	mov    $0xc,%eax
     b5f:	cd 40                	int    $0x40
     b61:	c3                   	ret    

00000b62 <sleep>:
SYSCALL(sleep)
     b62:	b8 0d 00 00 00       	mov    $0xd,%eax
     b67:	cd 40                	int    $0x40
     b69:	c3                   	ret    

00000b6a <uptime>:
SYSCALL(uptime)
     b6a:	b8 0e 00 00 00       	mov    $0xe,%eax
     b6f:	cd 40                	int    $0x40
     b71:	c3                   	ret    

00000b72 <changepriority>:
SYSCALL(changepriority)
     b72:	b8 16 00 00 00       	mov    $0x16,%eax
     b77:	cd 40                	int    $0x40
     b79:	c3                   	ret    

00000b7a <processstatus>:
SYSCALL(processstatus)
     b7a:	b8 17 00 00 00       	mov    $0x17,%eax
     b7f:	cd 40                	int    $0x40
     b81:	c3                   	ret    

00000b82 <randomgen>:
SYSCALL(randomgen)
     b82:	b8 18 00 00 00       	mov    $0x18,%eax
     b87:	cd 40                	int    $0x40
     b89:	c3                   	ret    

00000b8a <randomgenrange>:
SYSCALL(randomgenrange)
     b8a:	b8 19 00 00 00       	mov    $0x19,%eax
     b8f:	cd 40                	int    $0x40
     b91:	c3                   	ret    

00000b92 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     b92:	55                   	push   %ebp
     b93:	89 e5                	mov    %esp,%ebp
     b95:	83 ec 18             	sub    $0x18,%esp
     b98:	8b 45 0c             	mov    0xc(%ebp),%eax
     b9b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     b9e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     ba5:	00 
     ba6:	8d 45 f4             	lea    -0xc(%ebp),%eax
     ba9:	89 44 24 04          	mov    %eax,0x4(%esp)
     bad:	8b 45 08             	mov    0x8(%ebp),%eax
     bb0:	89 04 24             	mov    %eax,(%esp)
     bb3:	e8 3a ff ff ff       	call   af2 <write>
}
     bb8:	c9                   	leave  
     bb9:	c3                   	ret    

00000bba <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     bba:	55                   	push   %ebp
     bbb:	89 e5                	mov    %esp,%ebp
     bbd:	56                   	push   %esi
     bbe:	53                   	push   %ebx
     bbf:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     bc2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     bc9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     bcd:	74 17                	je     be6 <printint+0x2c>
     bcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     bd3:	79 11                	jns    be6 <printint+0x2c>
    neg = 1;
     bd5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
     bdf:	f7 d8                	neg    %eax
     be1:	89 45 ec             	mov    %eax,-0x14(%ebp)
     be4:	eb 06                	jmp    bec <printint+0x32>
  } else {
    x = xx;
     be6:	8b 45 0c             	mov    0xc(%ebp),%eax
     be9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     bec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     bf3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     bf6:	8d 41 01             	lea    0x1(%ecx),%eax
     bf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
     bfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
     bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c02:	ba 00 00 00 00       	mov    $0x0,%edx
     c07:	f7 f3                	div    %ebx
     c09:	89 d0                	mov    %edx,%eax
     c0b:	0f b6 80 e0 12 00 00 	movzbl 0x12e0(%eax),%eax
     c12:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     c16:	8b 75 10             	mov    0x10(%ebp),%esi
     c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c1c:	ba 00 00 00 00       	mov    $0x0,%edx
     c21:	f7 f6                	div    %esi
     c23:	89 45 ec             	mov    %eax,-0x14(%ebp)
     c26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     c2a:	75 c7                	jne    bf3 <printint+0x39>
  if(neg)
     c2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c30:	74 10                	je     c42 <printint+0x88>
    buf[i++] = '-';
     c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c35:	8d 50 01             	lea    0x1(%eax),%edx
     c38:	89 55 f4             	mov    %edx,-0xc(%ebp)
     c3b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     c40:	eb 1f                	jmp    c61 <printint+0xa7>
     c42:	eb 1d                	jmp    c61 <printint+0xa7>
    putc(fd, buf[i]);
     c44:	8d 55 dc             	lea    -0x24(%ebp),%edx
     c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c4a:	01 d0                	add    %edx,%eax
     c4c:	0f b6 00             	movzbl (%eax),%eax
     c4f:	0f be c0             	movsbl %al,%eax
     c52:	89 44 24 04          	mov    %eax,0x4(%esp)
     c56:	8b 45 08             	mov    0x8(%ebp),%eax
     c59:	89 04 24             	mov    %eax,(%esp)
     c5c:	e8 31 ff ff ff       	call   b92 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     c61:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     c65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     c69:	79 d9                	jns    c44 <printint+0x8a>
    putc(fd, buf[i]);
}
     c6b:	83 c4 30             	add    $0x30,%esp
     c6e:	5b                   	pop    %ebx
     c6f:	5e                   	pop    %esi
     c70:	5d                   	pop    %ebp
     c71:	c3                   	ret    

00000c72 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     c72:	55                   	push   %ebp
     c73:	89 e5                	mov    %esp,%ebp
     c75:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     c78:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     c7f:	8d 45 0c             	lea    0xc(%ebp),%eax
     c82:	83 c0 04             	add    $0x4,%eax
     c85:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     c88:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     c8f:	e9 7c 01 00 00       	jmp    e10 <printf+0x19e>
    c = fmt[i] & 0xff;
     c94:	8b 55 0c             	mov    0xc(%ebp),%edx
     c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c9a:	01 d0                	add    %edx,%eax
     c9c:	0f b6 00             	movzbl (%eax),%eax
     c9f:	0f be c0             	movsbl %al,%eax
     ca2:	25 ff 00 00 00       	and    $0xff,%eax
     ca7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     caa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     cae:	75 2c                	jne    cdc <printf+0x6a>
      if(c == '%'){
     cb0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     cb4:	75 0c                	jne    cc2 <printf+0x50>
        state = '%';
     cb6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     cbd:	e9 4a 01 00 00       	jmp    e0c <printf+0x19a>
      } else {
        putc(fd, c);
     cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cc5:	0f be c0             	movsbl %al,%eax
     cc8:	89 44 24 04          	mov    %eax,0x4(%esp)
     ccc:	8b 45 08             	mov    0x8(%ebp),%eax
     ccf:	89 04 24             	mov    %eax,(%esp)
     cd2:	e8 bb fe ff ff       	call   b92 <putc>
     cd7:	e9 30 01 00 00       	jmp    e0c <printf+0x19a>
      }
    } else if(state == '%'){
     cdc:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     ce0:	0f 85 26 01 00 00    	jne    e0c <printf+0x19a>
      if(c == 'd'){
     ce6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     cea:	75 2d                	jne    d19 <printf+0xa7>
        printint(fd, *ap, 10, 1);
     cec:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cef:	8b 00                	mov    (%eax),%eax
     cf1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     cf8:	00 
     cf9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     d00:	00 
     d01:	89 44 24 04          	mov    %eax,0x4(%esp)
     d05:	8b 45 08             	mov    0x8(%ebp),%eax
     d08:	89 04 24             	mov    %eax,(%esp)
     d0b:	e8 aa fe ff ff       	call   bba <printint>
        ap++;
     d10:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     d14:	e9 ec 00 00 00       	jmp    e05 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     d19:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     d1d:	74 06                	je     d25 <printf+0xb3>
     d1f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     d23:	75 2d                	jne    d52 <printf+0xe0>
        printint(fd, *ap, 16, 0);
     d25:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d28:	8b 00                	mov    (%eax),%eax
     d2a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     d31:	00 
     d32:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     d39:	00 
     d3a:	89 44 24 04          	mov    %eax,0x4(%esp)
     d3e:	8b 45 08             	mov    0x8(%ebp),%eax
     d41:	89 04 24             	mov    %eax,(%esp)
     d44:	e8 71 fe ff ff       	call   bba <printint>
        ap++;
     d49:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     d4d:	e9 b3 00 00 00       	jmp    e05 <printf+0x193>
      } else if(c == 's'){
     d52:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     d56:	75 45                	jne    d9d <printf+0x12b>
        s = (char*)*ap;
     d58:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d5b:	8b 00                	mov    (%eax),%eax
     d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     d60:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     d64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d68:	75 09                	jne    d73 <printf+0x101>
          s = "(null)";
     d6a:	c7 45 f4 74 10 00 00 	movl   $0x1074,-0xc(%ebp)
        while(*s != 0){
     d71:	eb 1e                	jmp    d91 <printf+0x11f>
     d73:	eb 1c                	jmp    d91 <printf+0x11f>
          putc(fd, *s);
     d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d78:	0f b6 00             	movzbl (%eax),%eax
     d7b:	0f be c0             	movsbl %al,%eax
     d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
     d82:	8b 45 08             	mov    0x8(%ebp),%eax
     d85:	89 04 24             	mov    %eax,(%esp)
     d88:	e8 05 fe ff ff       	call   b92 <putc>
          s++;
     d8d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d94:	0f b6 00             	movzbl (%eax),%eax
     d97:	84 c0                	test   %al,%al
     d99:	75 da                	jne    d75 <printf+0x103>
     d9b:	eb 68                	jmp    e05 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     d9d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     da1:	75 1d                	jne    dc0 <printf+0x14e>
        putc(fd, *ap);
     da3:	8b 45 e8             	mov    -0x18(%ebp),%eax
     da6:	8b 00                	mov    (%eax),%eax
     da8:	0f be c0             	movsbl %al,%eax
     dab:	89 44 24 04          	mov    %eax,0x4(%esp)
     daf:	8b 45 08             	mov    0x8(%ebp),%eax
     db2:	89 04 24             	mov    %eax,(%esp)
     db5:	e8 d8 fd ff ff       	call   b92 <putc>
        ap++;
     dba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     dbe:	eb 45                	jmp    e05 <printf+0x193>
      } else if(c == '%'){
     dc0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     dc4:	75 17                	jne    ddd <printf+0x16b>
        putc(fd, c);
     dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     dc9:	0f be c0             	movsbl %al,%eax
     dcc:	89 44 24 04          	mov    %eax,0x4(%esp)
     dd0:	8b 45 08             	mov    0x8(%ebp),%eax
     dd3:	89 04 24             	mov    %eax,(%esp)
     dd6:	e8 b7 fd ff ff       	call   b92 <putc>
     ddb:	eb 28                	jmp    e05 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     ddd:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     de4:	00 
     de5:	8b 45 08             	mov    0x8(%ebp),%eax
     de8:	89 04 24             	mov    %eax,(%esp)
     deb:	e8 a2 fd ff ff       	call   b92 <putc>
        putc(fd, c);
     df0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     df3:	0f be c0             	movsbl %al,%eax
     df6:	89 44 24 04          	mov    %eax,0x4(%esp)
     dfa:	8b 45 08             	mov    0x8(%ebp),%eax
     dfd:	89 04 24             	mov    %eax,(%esp)
     e00:	e8 8d fd ff ff       	call   b92 <putc>
      }
      state = 0;
     e05:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     e0c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     e10:	8b 55 0c             	mov    0xc(%ebp),%edx
     e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e16:	01 d0                	add    %edx,%eax
     e18:	0f b6 00             	movzbl (%eax),%eax
     e1b:	84 c0                	test   %al,%al
     e1d:	0f 85 71 fe ff ff    	jne    c94 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     e23:	c9                   	leave  
     e24:	c3                   	ret    

00000e25 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     e25:	55                   	push   %ebp
     e26:	89 e5                	mov    %esp,%ebp
     e28:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     e2b:	8b 45 08             	mov    0x8(%ebp),%eax
     e2e:	83 e8 08             	sub    $0x8,%eax
     e31:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e34:	a1 08 13 00 00       	mov    0x1308,%eax
     e39:	89 45 fc             	mov    %eax,-0x4(%ebp)
     e3c:	eb 24                	jmp    e62 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     e3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e41:	8b 00                	mov    (%eax),%eax
     e43:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e46:	77 12                	ja     e5a <free+0x35>
     e48:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e4b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e4e:	77 24                	ja     e74 <free+0x4f>
     e50:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e53:	8b 00                	mov    (%eax),%eax
     e55:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     e58:	77 1a                	ja     e74 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e5d:	8b 00                	mov    (%eax),%eax
     e5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
     e62:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e65:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e68:	76 d4                	jbe    e3e <free+0x19>
     e6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e6d:	8b 00                	mov    (%eax),%eax
     e6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     e72:	76 ca                	jbe    e3e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e77:	8b 40 04             	mov    0x4(%eax),%eax
     e7a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e84:	01 c2                	add    %eax,%edx
     e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e89:	8b 00                	mov    (%eax),%eax
     e8b:	39 c2                	cmp    %eax,%edx
     e8d:	75 24                	jne    eb3 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     e8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e92:	8b 50 04             	mov    0x4(%eax),%edx
     e95:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e98:	8b 00                	mov    (%eax),%eax
     e9a:	8b 40 04             	mov    0x4(%eax),%eax
     e9d:	01 c2                	add    %eax,%edx
     e9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ea2:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ea8:	8b 00                	mov    (%eax),%eax
     eaa:	8b 10                	mov    (%eax),%edx
     eac:	8b 45 f8             	mov    -0x8(%ebp),%eax
     eaf:	89 10                	mov    %edx,(%eax)
     eb1:	eb 0a                	jmp    ebd <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     eb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     eb6:	8b 10                	mov    (%eax),%edx
     eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ebb:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ec0:	8b 40 04             	mov    0x4(%eax),%eax
     ec3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ecd:	01 d0                	add    %edx,%eax
     ecf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     ed2:	75 20                	jne    ef4 <free+0xcf>
    p->s.size += bp->s.size;
     ed4:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ed7:	8b 50 04             	mov    0x4(%eax),%edx
     eda:	8b 45 f8             	mov    -0x8(%ebp),%eax
     edd:	8b 40 04             	mov    0x4(%eax),%eax
     ee0:	01 c2                	add    %eax,%edx
     ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ee5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     ee8:	8b 45 f8             	mov    -0x8(%ebp),%eax
     eeb:	8b 10                	mov    (%eax),%edx
     eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ef0:	89 10                	mov    %edx,(%eax)
     ef2:	eb 08                	jmp    efc <free+0xd7>
  } else
    p->s.ptr = bp;
     ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ef7:	8b 55 f8             	mov    -0x8(%ebp),%edx
     efa:	89 10                	mov    %edx,(%eax)
  freep = p;
     efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
     eff:	a3 08 13 00 00       	mov    %eax,0x1308
}
     f04:	c9                   	leave  
     f05:	c3                   	ret    

00000f06 <morecore>:

static Header*
morecore(uint nu)
{
     f06:	55                   	push   %ebp
     f07:	89 e5                	mov    %esp,%ebp
     f09:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     f0c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     f13:	77 07                	ja     f1c <morecore+0x16>
    nu = 4096;
     f15:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     f1c:	8b 45 08             	mov    0x8(%ebp),%eax
     f1f:	c1 e0 03             	shl    $0x3,%eax
     f22:	89 04 24             	mov    %eax,(%esp)
     f25:	e8 30 fc ff ff       	call   b5a <sbrk>
     f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     f2d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     f31:	75 07                	jne    f3a <morecore+0x34>
    return 0;
     f33:	b8 00 00 00 00       	mov    $0x0,%eax
     f38:	eb 22                	jmp    f5c <morecore+0x56>
  hp = (Header*)p;
     f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f43:	8b 55 08             	mov    0x8(%ebp),%edx
     f46:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f4c:	83 c0 08             	add    $0x8,%eax
     f4f:	89 04 24             	mov    %eax,(%esp)
     f52:	e8 ce fe ff ff       	call   e25 <free>
  return freep;
     f57:	a1 08 13 00 00       	mov    0x1308,%eax
}
     f5c:	c9                   	leave  
     f5d:	c3                   	ret    

00000f5e <malloc>:

void*
malloc(uint nbytes)
{
     f5e:	55                   	push   %ebp
     f5f:	89 e5                	mov    %esp,%ebp
     f61:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f64:	8b 45 08             	mov    0x8(%ebp),%eax
     f67:	83 c0 07             	add    $0x7,%eax
     f6a:	c1 e8 03             	shr    $0x3,%eax
     f6d:	83 c0 01             	add    $0x1,%eax
     f70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     f73:	a1 08 13 00 00       	mov    0x1308,%eax
     f78:	89 45 f0             	mov    %eax,-0x10(%ebp)
     f7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     f7f:	75 23                	jne    fa4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     f81:	c7 45 f0 00 13 00 00 	movl   $0x1300,-0x10(%ebp)
     f88:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f8b:	a3 08 13 00 00       	mov    %eax,0x1308
     f90:	a1 08 13 00 00       	mov    0x1308,%eax
     f95:	a3 00 13 00 00       	mov    %eax,0x1300
    base.s.size = 0;
     f9a:	c7 05 04 13 00 00 00 	movl   $0x0,0x1304
     fa1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fa7:	8b 00                	mov    (%eax),%eax
     fa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
     faf:	8b 40 04             	mov    0x4(%eax),%eax
     fb2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     fb5:	72 4d                	jb     1004 <malloc+0xa6>
      if(p->s.size == nunits)
     fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fba:	8b 40 04             	mov    0x4(%eax),%eax
     fbd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     fc0:	75 0c                	jne    fce <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fc5:	8b 10                	mov    (%eax),%edx
     fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fca:	89 10                	mov    %edx,(%eax)
     fcc:	eb 26                	jmp    ff4 <malloc+0x96>
      else {
        p->s.size -= nunits;
     fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fd1:	8b 40 04             	mov    0x4(%eax),%eax
     fd4:	2b 45 ec             	sub    -0x14(%ebp),%eax
     fd7:	89 c2                	mov    %eax,%edx
     fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fdc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fe2:	8b 40 04             	mov    0x4(%eax),%eax
     fe5:	c1 e0 03             	shl    $0x3,%eax
     fe8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fee:	8b 55 ec             	mov    -0x14(%ebp),%edx
     ff1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ff7:	a3 08 13 00 00       	mov    %eax,0x1308
      return (void*)(p + 1);
     ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fff:	83 c0 08             	add    $0x8,%eax
    1002:	eb 38                	jmp    103c <malloc+0xde>
    }
    if(p == freep)
    1004:	a1 08 13 00 00       	mov    0x1308,%eax
    1009:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    100c:	75 1b                	jne    1029 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    100e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1011:	89 04 24             	mov    %eax,(%esp)
    1014:	e8 ed fe ff ff       	call   f06 <morecore>
    1019:	89 45 f4             	mov    %eax,-0xc(%ebp)
    101c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1020:	75 07                	jne    1029 <malloc+0xcb>
        return 0;
    1022:	b8 00 00 00 00       	mov    $0x0,%eax
    1027:	eb 13                	jmp    103c <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1029:	8b 45 f4             	mov    -0xc(%ebp),%eax
    102c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    102f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1032:	8b 00                	mov    (%eax),%eax
    1034:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1037:	e9 70 ff ff ff       	jmp    fac <malloc+0x4e>
}
    103c:	c9                   	leave  
    103d:	c3                   	ret    
