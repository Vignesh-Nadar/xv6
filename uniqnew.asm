
_uniqnew:     file format elf32-i386


Disassembly of section .text:

00000000 <readLine>:
char buf[MAX_BUF];
int argumentIndex = 1;
int optionCD = 1;   // 1 for no option // 2 for -C // 3 for option -D
int optionI = 0;  // 1 for option -I

int readLine(char *line, int fd) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
    memset(line, 0, MAX_BUF);
   6:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
   d:	00 
   e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  15:	00 
  16:	8b 45 08             	mov    0x8(%ebp),%eax
  19:	89 04 24             	mov    %eax,(%esp)
  1c:	e8 b0 06 00 00       	call   6d1 <memset>
    char *dst = line;
  21:	8b 45 08             	mov    0x8(%ebp),%eax
  24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((read(fd, buf, 1)) > 0) {
  27:	eb 47                	jmp    70 <readLine+0x70>
        if (buf[0] == '\n') {
  29:	0f b6 05 40 11 00 00 	movzbl 0x1140,%eax
  30:	3c 0a                	cmp    $0xa,%al
  32:	75 14                	jne    48 <readLine+0x48>
            *dst++ = buf[0];
  34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  37:	8d 50 01             	lea    0x1(%eax),%edx
  3a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  3d:	0f b6 15 40 11 00 00 	movzbl 0x1140,%edx
  44:	88 10                	mov    %dl,(%eax)
            break;
  46:	eb 47                	jmp    8f <readLine+0x8f>
        } else {
            *dst++ = buf[0];
  48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4b:	8d 50 01             	lea    0x1(%eax),%edx
  4e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  51:	0f b6 15 40 11 00 00 	movzbl 0x1140,%edx
  58:	88 10                	mov    %dl,(%eax)
            if ((dst - line) + 1 > MAX_BUF) {
  5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  5d:	8b 45 08             	mov    0x8(%ebp),%eax
  60:	29 c2                	sub    %eax,%edx
  62:	89 d0                	mov    %edx,%eax
  64:	83 c0 01             	add    $0x1,%eax
  67:	3d 00 04 00 00       	cmp    $0x400,%eax
  6c:	7e 02                	jle    70 <readLine+0x70>
                break;
  6e:	eb 1f                	jmp    8f <readLine+0x8f>
int optionI = 0;  // 1 for option -I

int readLine(char *line, int fd) {
    memset(line, 0, MAX_BUF);
    char *dst = line;
    while ((read(fd, buf, 1)) > 0) {
  70:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  77:	00 
  78:	c7 44 24 04 40 11 00 	movl   $0x1140,0x4(%esp)
  7f:	00 
  80:	8b 45 0c             	mov    0xc(%ebp),%eax
  83:	89 04 24             	mov    %eax,(%esp)
  86:	e8 0b 08 00 00       	call   896 <read>
  8b:	85 c0                	test   %eax,%eax
  8d:	7f 9a                	jg     29 <readLine+0x29>
            }
        }

    }
    //adding \n to line end if it doesn't have one..
    if (*(dst - 1) != '\n') *dst = '\n';
  8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  92:	83 e8 01             	sub    $0x1,%eax
  95:	0f b6 00             	movzbl (%eax),%eax
  98:	3c 0a                	cmp    $0xa,%al
  9a:	74 06                	je     a2 <readLine+0xa2>
  9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  9f:	c6 00 0a             	movb   $0xa,(%eax)
    return dst - line;
  a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	29 c2                	sub    %eax,%edx
  aa:	89 d0                	mov    %edx,%eax
}
  ac:	c9                   	leave  
  ad:	c3                   	ret    

000000ae <caseIgnoreComparison>:

int caseIgnoreComparison(const char *first, const char *second) {
  ae:	55                   	push   %ebp
  af:	89 e5                	mov    %esp,%ebp
  b1:	83 ec 10             	sub    $0x10,%esp
    uchar chA, chB;
    chA = *first;
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	0f b6 00             	movzbl (%eax),%eax
  ba:	88 45 ff             	mov    %al,-0x1(%ebp)
    chB = *second;
  bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  c0:	0f b6 00             	movzbl (%eax),%eax
  c3:	88 45 fe             	mov    %al,-0x2(%ebp)
    if (chA >= 'A' && chA <= 'Z')
  c6:	80 7d ff 40          	cmpb   $0x40,-0x1(%ebp)
  ca:	76 0a                	jbe    d6 <caseIgnoreComparison+0x28>
  cc:	80 7d ff 5a          	cmpb   $0x5a,-0x1(%ebp)
  d0:	77 04                	ja     d6 <caseIgnoreComparison+0x28>
        chA = 'a' + (chA - 'A');
  d2:	80 45 ff 20          	addb   $0x20,-0x1(%ebp)
    if (chB >= 'A' && chB <= 'Z')
  d6:	80 7d fe 40          	cmpb   $0x40,-0x2(%ebp)
  da:	76 0c                	jbe    e8 <caseIgnoreComparison+0x3a>
  dc:	80 7d fe 5a          	cmpb   $0x5a,-0x2(%ebp)
  e0:	77 06                	ja     e8 <caseIgnoreComparison+0x3a>
        chB = 'a' + (chB - 'A');
  e2:	80 45 fe 20          	addb   $0x20,-0x2(%ebp)

    while (*first && chA == chB)
  e6:	eb 2a                	jmp    112 <caseIgnoreComparison+0x64>
  e8:	eb 28                	jmp    112 <caseIgnoreComparison+0x64>
    {
      first++;
  ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
      second++;
  ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
      if (chA >= 'A' && chA <= 'Z')
  f2:	80 7d ff 40          	cmpb   $0x40,-0x1(%ebp)
  f6:	76 0a                	jbe    102 <caseIgnoreComparison+0x54>
  f8:	80 7d ff 5a          	cmpb   $0x5a,-0x1(%ebp)
  fc:	77 04                	ja     102 <caseIgnoreComparison+0x54>
        chA = 'a' + (chA - 'A');
  fe:	80 45 ff 20          	addb   $0x20,-0x1(%ebp)
      if (chB >= 'A' && chB <= 'Z')
 102:	80 7d fe 40          	cmpb   $0x40,-0x2(%ebp)
 106:	76 0a                	jbe    112 <caseIgnoreComparison+0x64>
 108:	80 7d fe 5a          	cmpb   $0x5a,-0x2(%ebp)
 10c:	77 04                	ja     112 <caseIgnoreComparison+0x64>
        chB = 'a' + (chB - 'A');
 10e:	80 45 fe 20          	addb   $0x20,-0x2(%ebp)
    if (chA >= 'A' && chA <= 'Z')
        chA = 'a' + (chA - 'A');
    if (chB >= 'A' && chB <= 'Z')
        chB = 'a' + (chB - 'A');

    while (*first && chA == chB)
 112:	8b 45 08             	mov    0x8(%ebp),%eax
 115:	0f b6 00             	movzbl (%eax),%eax
 118:	84 c0                	test   %al,%al
 11a:	74 09                	je     125 <caseIgnoreComparison+0x77>
 11c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
 120:	3a 45 fe             	cmp    -0x2(%ebp),%al
 123:	74 c5                	je     ea <caseIgnoreComparison+0x3c>
        chA = 'a' + (chA - 'A');
      if (chB >= 'A' && chB <= 'Z')
        chB = 'a' + (chB - 'A');
    }

    return (uchar) *first - (uchar) *second;
 125:	8b 45 08             	mov    0x8(%ebp),%eax
 128:	0f b6 00             	movzbl (%eax),%eax
 12b:	0f b6 d0             	movzbl %al,%edx
 12e:	8b 45 0c             	mov    0xc(%ebp),%eax
 131:	0f b6 00             	movzbl (%eax),%eax
 134:	0f b6 c0             	movzbl %al,%eax
 137:	29 c2                	sub    %eax,%edx
 139:	89 d0                	mov    %edx,%eax
}
 13b:	c9                   	leave  
 13c:	c3                   	ret    

0000013d <uniq>:

void uniq(int fd, char *name) {
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
 140:	83 ec 38             	sub    $0x38,%esp
    char *prev = NULL, *cur = NULL;
 143:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 14a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char *line = (char *) malloc(MAX_BUF * sizeof(char));
 151:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
 158:	e8 ad 0b 00 00       	call   d0a <malloc>
 15d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    int count = 0;
 160:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while ((readLine(line, fd)) > 0) {
 167:	e9 e8 01 00 00       	jmp    354 <uniq+0x217>
        if (prev == NULL) {
 16c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 170:	0f 85 b8 00 00 00    	jne    22e <uniq+0xf1>
            prev = (char *) malloc(MAX_BUF * sizeof(char));
 176:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
 17d:	e8 88 0b 00 00       	call   d0a <malloc>
 182:	89 45 f4             	mov    %eax,-0xc(%ebp)
            cur = (char *) malloc(MAX_BUF * sizeof(char));
 185:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
 18c:	e8 79 0b 00 00       	call   d0a <malloc>
 191:	89 45 f0             	mov    %eax,-0x10(%ebp)
            memmove(prev, line, MAX_BUF);
 194:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 19b:	00 
 19c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 19f:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a6:	89 04 24             	mov    %eax,(%esp)
 1a9:	e8 8b 06 00 00       	call   839 <memmove>
            memmove(cur, line, MAX_BUF);
 1ae:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 1b5:	00 
 1b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 1bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1c0:	89 04 24             	mov    %eax,(%esp)
 1c3:	e8 71 06 00 00       	call   839 <memmove>
            count = 1;
 1c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
            if (optionCD == 1) {
 1cf:	a1 04 11 00 00       	mov    0x1104,%eax
 1d4:	83 f8 01             	cmp    $0x1,%eax
 1d7:	75 20                	jne    1f9 <uniq+0xbc>
                printf(1, "%s", cur);
 1d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1dc:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e0:	c7 44 24 04 ec 0d 00 	movl   $0xdec,0x4(%esp)
 1e7:	00 
 1e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1ef:	e8 2a 08 00 00       	call   a1e <printf>
 1f4:	e9 41 01 00 00       	jmp    33a <uniq+0x1fd>
            }
            else if (optionCD == 2)
 1f9:	a1 04 11 00 00       	mov    0x1104,%eax
 1fe:	83 f8 02             	cmp    $0x2,%eax
 201:	0f 85 33 01 00 00    	jne    33a <uniq+0x1fd>
            {
                printf(1, "%d %s", count, cur);
 207:	8b 45 f0             	mov    -0x10(%ebp),%eax
 20a:	89 44 24 0c          	mov    %eax,0xc(%esp)
 20e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 211:	89 44 24 08          	mov    %eax,0x8(%esp)
 215:	c7 44 24 04 ef 0d 00 	movl   $0xdef,0x4(%esp)
 21c:	00 
 21d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 224:	e8 f5 07 00 00       	call   a1e <printf>
 229:	e9 0c 01 00 00       	jmp    33a <uniq+0x1fd>
            }
        } else {
            memmove(cur, line, MAX_BUF);
 22e:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 235:	00 
 236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 239:	89 44 24 04          	mov    %eax,0x4(%esp)
 23d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 240:	89 04 24             	mov    %eax,(%esp)
 243:	e8 f1 05 00 00       	call   839 <memmove>
            int cmp_result;
            if (optionI) {
 248:	a1 20 11 00 00       	mov    0x1120,%eax
 24d:	85 c0                	test   %eax,%eax
 24f:	74 17                	je     268 <uniq+0x12b>
                cmp_result = caseIgnoreComparison(cur, prev);
 251:	8b 45 f4             	mov    -0xc(%ebp),%eax
 254:	89 44 24 04          	mov    %eax,0x4(%esp)
 258:	8b 45 f0             	mov    -0x10(%ebp),%eax
 25b:	89 04 24             	mov    %eax,(%esp)
 25e:	e8 4b fe ff ff       	call   ae <caseIgnoreComparison>
 263:	89 45 e8             	mov    %eax,-0x18(%ebp)
 266:	eb 15                	jmp    27d <uniq+0x140>
            } else {
                cmp_result = strcmp(cur, prev);
 268:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26b:	89 44 24 04          	mov    %eax,0x4(%esp)
 26f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 272:	89 04 24             	mov    %eax,(%esp)
 275:	e8 f1 03 00 00       	call   66b <strcmp>
 27a:	89 45 e8             	mov    %eax,-0x18(%ebp)
            }
            if (cmp_result == 0)
 27d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 281:	75 30                	jne    2b3 <uniq+0x176>
            {
                count++;
 283:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
                if (optionI) {
 287:	a1 20 11 00 00       	mov    0x1120,%eax
 28c:	85 c0                	test   %eax,%eax
 28e:	0f 84 a6 00 00 00    	je     33a <uniq+0x1fd>
                    memmove(cur, prev, MAX_BUF);
 294:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 29b:	00 
 29c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 29f:	89 44 24 04          	mov    %eax,0x4(%esp)
 2a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2a6:	89 04 24             	mov    %eax,(%esp)
 2a9:	e8 8b 05 00 00       	call   839 <memmove>
 2ae:	e9 87 00 00 00       	jmp    33a <uniq+0x1fd>
                }
            }
            else {
                if (optionCD == 1)
 2b3:	a1 04 11 00 00       	mov    0x1104,%eax
 2b8:	83 f8 01             	cmp    $0x1,%eax
 2bb:	75 1d                	jne    2da <uniq+0x19d>
                {
                    printf(1, "%s", cur);
 2bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2c0:	89 44 24 08          	mov    %eax,0x8(%esp)
 2c4:	c7 44 24 04 ec 0d 00 	movl   $0xdec,0x4(%esp)
 2cb:	00 
 2cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2d3:	e8 46 07 00 00       	call   a1e <printf>
 2d8:	eb 59                	jmp    333 <uniq+0x1f6>
                } else if (optionCD == 3 && count > 1)
 2da:	a1 04 11 00 00       	mov    0x1104,%eax
 2df:	83 f8 03             	cmp    $0x3,%eax
 2e2:	75 23                	jne    307 <uniq+0x1ca>
 2e4:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 2e8:	7e 1d                	jle    307 <uniq+0x1ca>
                {
                    printf(1, "%s", prev);
 2ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ed:	89 44 24 08          	mov    %eax,0x8(%esp)
 2f1:	c7 44 24 04 ec 0d 00 	movl   $0xdec,0x4(%esp)
 2f8:	00 
 2f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 300:	e8 19 07 00 00       	call   a1e <printf>
 305:	eb 2c                	jmp    333 <uniq+0x1f6>
                } else if (optionCD == 2)
 307:	a1 04 11 00 00       	mov    0x1104,%eax
 30c:	83 f8 02             	cmp    $0x2,%eax
 30f:	75 22                	jne    333 <uniq+0x1f6>
                {
                    printf(1, "%d %s", count, prev);
 311:	8b 45 f4             	mov    -0xc(%ebp),%eax
 314:	89 44 24 0c          	mov    %eax,0xc(%esp)
 318:	8b 45 ec             	mov    -0x14(%ebp),%eax
 31b:	89 44 24 08          	mov    %eax,0x8(%esp)
 31f:	c7 44 24 04 ef 0d 00 	movl   $0xdef,0x4(%esp)
 326:	00 
 327:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 32e:	e8 eb 06 00 00       	call   a1e <printf>
                }
                count = 1;
 333:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
            }
        }
        memmove(prev, cur, MAX_BUF);
 33a:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 341:	00 
 342:	8b 45 f0             	mov    -0x10(%ebp),%eax
 345:	89 44 24 04          	mov    %eax,0x4(%esp)
 349:	8b 45 f4             	mov    -0xc(%ebp),%eax
 34c:	89 04 24             	mov    %eax,(%esp)
 34f:	e8 e5 04 00 00       	call   839 <memmove>

void uniq(int fd, char *name) {
    char *prev = NULL, *cur = NULL;
    char *line = (char *) malloc(MAX_BUF * sizeof(char));
    int count = 0;
    while ((readLine(line, fd)) > 0) {
 354:	8b 45 08             	mov    0x8(%ebp),%eax
 357:	89 44 24 04          	mov    %eax,0x4(%esp)
 35b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 35e:	89 04 24             	mov    %eax,(%esp)
 361:	e8 9a fc ff ff       	call   0 <readLine>
 366:	85 c0                	test   %eax,%eax
 368:	0f 8f fe fd ff ff    	jg     16c <uniq+0x2f>
                count = 1;
            }
        }
        memmove(prev, cur, MAX_BUF);
    }
    if ((optionCD == 3 && count > 1)) {
 36e:	a1 04 11 00 00       	mov    0x1104,%eax
 373:	83 f8 03             	cmp    $0x3,%eax
 376:	75 23                	jne    39b <uniq+0x25e>
 378:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 37c:	7e 1d                	jle    39b <uniq+0x25e>
        printf(1, "%s", cur);
 37e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 381:	89 44 24 08          	mov    %eax,0x8(%esp)
 385:	c7 44 24 04 ec 0d 00 	movl   $0xdec,0x4(%esp)
 38c:	00 
 38d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 394:	e8 85 06 00 00       	call   a1e <printf>
 399:	eb 2c                	jmp    3c7 <uniq+0x28a>
    } else if (optionCD == 2) {
 39b:	a1 04 11 00 00       	mov    0x1104,%eax
 3a0:	83 f8 02             	cmp    $0x2,%eax
 3a3:	75 22                	jne    3c7 <uniq+0x28a>
        printf(1, "%d %s", count, cur);
 3a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
 3ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3af:	89 44 24 08          	mov    %eax,0x8(%esp)
 3b3:	c7 44 24 04 ef 0d 00 	movl   $0xdef,0x4(%esp)
 3ba:	00 
 3bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3c2:	e8 57 06 00 00       	call   a1e <printf>

    }
    free(prev);
 3c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ca:	89 04 24             	mov    %eax,(%esp)
 3cd:	e8 ff 07 00 00       	call   bd1 <free>
    free(cur);
 3d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3d5:	89 04 24             	mov    %eax,(%esp)
 3d8:	e8 f4 07 00 00       	call   bd1 <free>
    free(line);
 3dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3e0:	89 04 24             	mov    %eax,(%esp)
 3e3:	e8 e9 07 00 00       	call   bd1 <free>
}
 3e8:	c9                   	leave  
 3e9:	c3                   	ret    

000003ea <readOperators>:

int readOperators(int argc, char *argv[]) {
 3ea:	55                   	push   %ebp
 3eb:	89 e5                	mov    %esp,%ebp
 3ed:	83 ec 28             	sub    $0x28,%esp
    if (argumentIndex >= argc - 1) {
 3f0:	8b 45 08             	mov    0x8(%ebp),%eax
 3f3:	8d 50 ff             	lea    -0x1(%eax),%edx
 3f6:	a1 00 11 00 00       	mov    0x1100,%eax
 3fb:	39 c2                	cmp    %eax,%edx
 3fd:	7f 0a                	jg     409 <readOperators+0x1f>
        return 0;
 3ff:	b8 00 00 00 00       	mov    $0x0,%eax
 404:	e9 81 00 00 00       	jmp    48a <readOperators+0xa0>
    }
    char *options = "cdiCDI";
 409:	c7 45 f4 f5 0d 00 00 	movl   $0xdf5,-0xc(%ebp)
    char *arg = argv[argumentIndex];
 410:	a1 00 11 00 00       	mov    0x1100,%eax
 415:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 41c:	8b 45 0c             	mov    0xc(%ebp),%eax
 41f:	01 d0                	add    %edx,%eax
 421:	8b 00                	mov    (%eax),%eax
 423:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (arg[0] != '-' || (strchr(options, arg[1]) == 0)) {
 426:	8b 45 f0             	mov    -0x10(%ebp),%eax
 429:	0f b6 00             	movzbl (%eax),%eax
 42c:	3c 2d                	cmp    $0x2d,%al
 42e:	75 1f                	jne    44f <readOperators+0x65>
 430:	8b 45 f0             	mov    -0x10(%ebp),%eax
 433:	83 c0 01             	add    $0x1,%eax
 436:	0f b6 00             	movzbl (%eax),%eax
 439:	0f be c0             	movsbl %al,%eax
 43c:	89 44 24 04          	mov    %eax,0x4(%esp)
 440:	8b 45 f4             	mov    -0xc(%ebp),%eax
 443:	89 04 24             	mov    %eax,(%esp)
 446:	e8 aa 02 00 00       	call   6f5 <strchr>
 44b:	85 c0                	test   %eax,%eax
 44d:	75 22                	jne    471 <readOperators+0x87>
        printf(1, "Not a valid option for UNIQ : %s\n", arg);
 44f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 452:	89 44 24 08          	mov    %eax,0x8(%esp)
 456:	c7 44 24 04 fc 0d 00 	movl   $0xdfc,0x4(%esp)
 45d:	00 
 45e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 465:	e8 b4 05 00 00       	call   a1e <printf>
        return 0;
 46a:	b8 00 00 00 00       	mov    $0x0,%eax
 46f:	eb 19                	jmp    48a <readOperators+0xa0>
    } else {
        argumentIndex++;
 471:	a1 00 11 00 00       	mov    0x1100,%eax
 476:	83 c0 01             	add    $0x1,%eax
 479:	a3 00 11 00 00       	mov    %eax,0x1100
        return arg[1];
 47e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 481:	83 c0 01             	add    $0x1,%eax
 484:	0f b6 00             	movzbl (%eax),%eax
 487:	0f be c0             	movsbl %al,%eax
    }
}
 48a:	c9                   	leave  
 48b:	c3                   	ret    

0000048c <main>:

int main(int argc, char *argv[]) {
 48c:	55                   	push   %ebp
 48d:	89 e5                	mov    %esp,%ebp
 48f:	83 e4 f0             	and    $0xfffffff0,%esp
 492:	83 ec 20             	sub    $0x20,%esp
    int fd;
    int c;
    if (argc <= 1) {
 495:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 499:	7f 19                	jg     4b4 <main+0x28>
        uniq(0, "");
 49b:	c7 44 24 04 1e 0e 00 	movl   $0xe1e,0x4(%esp)
 4a2:	00 
 4a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4aa:	e8 8e fc ff ff       	call   13d <uniq>
        exit();
 4af:	e8 ca 03 00 00       	call   87e <exit>
    } else if (argc == 2) {
 4b4:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 4b8:	75 65                	jne    51f <main+0x93>
        if ((fd = open(argv[1], 0)) < 0) {
 4ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bd:	83 c0 04             	add    $0x4,%eax
 4c0:	8b 00                	mov    (%eax),%eax
 4c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4c9:	00 
 4ca:	89 04 24             	mov    %eax,(%esp)
 4cd:	e8 ec 03 00 00       	call   8be <open>
 4d2:	89 44 24 1c          	mov    %eax,0x1c(%esp)
 4d6:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 4db:	79 25                	jns    502 <main+0x76>
            printf(1, "uniq: cannot open %s\n", argv[1]);
 4dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e0:	83 c0 04             	add    $0x4,%eax
 4e3:	8b 00                	mov    (%eax),%eax
 4e5:	89 44 24 08          	mov    %eax,0x8(%esp)
 4e9:	c7 44 24 04 1f 0e 00 	movl   $0xe1f,0x4(%esp)
 4f0:	00 
 4f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4f8:	e8 21 05 00 00       	call   a1e <printf>
            exit();
 4fd:	e8 7c 03 00 00       	call   87e <exit>
        }
        uniq(fd, argv[1]);
 502:	8b 45 0c             	mov    0xc(%ebp),%eax
 505:	83 c0 04             	add    $0x4,%eax
 508:	8b 00                	mov    (%eax),%eax
 50a:	89 44 24 04          	mov    %eax,0x4(%esp)
 50e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 512:	89 04 24             	mov    %eax,(%esp)
 515:	e8 23 fc ff ff       	call   13d <uniq>
        exit();
 51a:	e8 5f 03 00 00       	call   87e <exit>
    } else if (argc >= 3) {
 51f:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 523:	0f 8e e8 00 00 00    	jle    611 <main+0x185>
        while ((c = readOperators(argc, argv)) > 0) {
 529:	eb 48                	jmp    573 <main+0xe7>

            if (c == 'c' || c == 'C')
 52b:	83 7c 24 18 63       	cmpl   $0x63,0x18(%esp)
 530:	74 07                	je     539 <main+0xad>
 532:	83 7c 24 18 43       	cmpl   $0x43,0x18(%esp)
 537:	75 0a                	jne    543 <main+0xb7>
            {
              optionCD = 2;
 539:	c7 05 04 11 00 00 02 	movl   $0x2,0x1104
 540:	00 00 00 
            }
            if (c == 'd' || c == 'D')
 543:	83 7c 24 18 64       	cmpl   $0x64,0x18(%esp)
 548:	74 07                	je     551 <main+0xc5>
 54a:	83 7c 24 18 44       	cmpl   $0x44,0x18(%esp)
 54f:	75 0a                	jne    55b <main+0xcf>
            {
              optionCD = 3;
 551:	c7 05 04 11 00 00 03 	movl   $0x3,0x1104
 558:	00 00 00 
            }
            if (c == 'i' || c == 'I')
 55b:	83 7c 24 18 69       	cmpl   $0x69,0x18(%esp)
 560:	74 07                	je     569 <main+0xdd>
 562:	83 7c 24 18 49       	cmpl   $0x49,0x18(%esp)
 567:	75 0a                	jne    573 <main+0xe7>
            {
              optionI = 1;
 569:	c7 05 20 11 00 00 01 	movl   $0x1,0x1120
 570:	00 00 00 
            exit();
        }
        uniq(fd, argv[1]);
        exit();
    } else if (argc >= 3) {
        while ((c = readOperators(argc, argv)) > 0) {
 573:	8b 45 0c             	mov    0xc(%ebp),%eax
 576:	89 44 24 04          	mov    %eax,0x4(%esp)
 57a:	8b 45 08             	mov    0x8(%ebp),%eax
 57d:	89 04 24             	mov    %eax,(%esp)
 580:	e8 65 fe ff ff       	call   3ea <readOperators>
 585:	89 44 24 18          	mov    %eax,0x18(%esp)
 589:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 58e:	7f 9b                	jg     52b <main+0x9f>
            if (c == 'i' || c == 'I')
            {
              optionI = 1;
            }
        }
        if ((fd = open(argv[argc - 1], 0)) < 0) {
 590:	8b 45 08             	mov    0x8(%ebp),%eax
 593:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
 598:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 59f:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a2:	01 d0                	add    %edx,%eax
 5a4:	8b 00                	mov    (%eax),%eax
 5a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 5ad:	00 
 5ae:	89 04 24             	mov    %eax,(%esp)
 5b1:	e8 08 03 00 00       	call   8be <open>
 5b6:	89 44 24 1c          	mov    %eax,0x1c(%esp)
 5ba:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 5bf:	79 25                	jns    5e6 <main+0x15a>
            printf(1, "uniq: cannot open %s\n", argv[1]);
 5c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c4:	83 c0 04             	add    $0x4,%eax
 5c7:	8b 00                	mov    (%eax),%eax
 5c9:	89 44 24 08          	mov    %eax,0x8(%esp)
 5cd:	c7 44 24 04 1f 0e 00 	movl   $0xe1f,0x4(%esp)
 5d4:	00 
 5d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5dc:	e8 3d 04 00 00       	call   a1e <printf>
            exit();
 5e1:	e8 98 02 00 00       	call   87e <exit>
        }
        uniq(fd, argv[argc - 1]);
 5e6:	8b 45 08             	mov    0x8(%ebp),%eax
 5e9:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
 5ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 5f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f8:	01 d0                	add    %edx,%eax
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 600:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 604:	89 04 24             	mov    %eax,(%esp)
 607:	e8 31 fb ff ff       	call   13d <uniq>
        exit();
 60c:	e8 6d 02 00 00       	call   87e <exit>
    }
    exit();
 611:	e8 68 02 00 00       	call   87e <exit>

00000616 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 616:	55                   	push   %ebp
 617:	89 e5                	mov    %esp,%ebp
 619:	57                   	push   %edi
 61a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 61b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 61e:	8b 55 10             	mov    0x10(%ebp),%edx
 621:	8b 45 0c             	mov    0xc(%ebp),%eax
 624:	89 cb                	mov    %ecx,%ebx
 626:	89 df                	mov    %ebx,%edi
 628:	89 d1                	mov    %edx,%ecx
 62a:	fc                   	cld    
 62b:	f3 aa                	rep stos %al,%es:(%edi)
 62d:	89 ca                	mov    %ecx,%edx
 62f:	89 fb                	mov    %edi,%ebx
 631:	89 5d 08             	mov    %ebx,0x8(%ebp)
 634:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 637:	5b                   	pop    %ebx
 638:	5f                   	pop    %edi
 639:	5d                   	pop    %ebp
 63a:	c3                   	ret    

0000063b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 63b:	55                   	push   %ebp
 63c:	89 e5                	mov    %esp,%ebp
 63e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 641:	8b 45 08             	mov    0x8(%ebp),%eax
 644:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 647:	90                   	nop
 648:	8b 45 08             	mov    0x8(%ebp),%eax
 64b:	8d 50 01             	lea    0x1(%eax),%edx
 64e:	89 55 08             	mov    %edx,0x8(%ebp)
 651:	8b 55 0c             	mov    0xc(%ebp),%edx
 654:	8d 4a 01             	lea    0x1(%edx),%ecx
 657:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 65a:	0f b6 12             	movzbl (%edx),%edx
 65d:	88 10                	mov    %dl,(%eax)
 65f:	0f b6 00             	movzbl (%eax),%eax
 662:	84 c0                	test   %al,%al
 664:	75 e2                	jne    648 <strcpy+0xd>
    ;
  return os;
 666:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 669:	c9                   	leave  
 66a:	c3                   	ret    

0000066b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 66b:	55                   	push   %ebp
 66c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 66e:	eb 08                	jmp    678 <strcmp+0xd>
    p++, q++;
 670:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 674:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 678:	8b 45 08             	mov    0x8(%ebp),%eax
 67b:	0f b6 00             	movzbl (%eax),%eax
 67e:	84 c0                	test   %al,%al
 680:	74 10                	je     692 <strcmp+0x27>
 682:	8b 45 08             	mov    0x8(%ebp),%eax
 685:	0f b6 10             	movzbl (%eax),%edx
 688:	8b 45 0c             	mov    0xc(%ebp),%eax
 68b:	0f b6 00             	movzbl (%eax),%eax
 68e:	38 c2                	cmp    %al,%dl
 690:	74 de                	je     670 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 692:	8b 45 08             	mov    0x8(%ebp),%eax
 695:	0f b6 00             	movzbl (%eax),%eax
 698:	0f b6 d0             	movzbl %al,%edx
 69b:	8b 45 0c             	mov    0xc(%ebp),%eax
 69e:	0f b6 00             	movzbl (%eax),%eax
 6a1:	0f b6 c0             	movzbl %al,%eax
 6a4:	29 c2                	sub    %eax,%edx
 6a6:	89 d0                	mov    %edx,%eax
}
 6a8:	5d                   	pop    %ebp
 6a9:	c3                   	ret    

000006aa <strlen>:

uint
strlen(char *s)
{
 6aa:	55                   	push   %ebp
 6ab:	89 e5                	mov    %esp,%ebp
 6ad:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 6b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 6b7:	eb 04                	jmp    6bd <strlen+0x13>
 6b9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 6bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6c0:	8b 45 08             	mov    0x8(%ebp),%eax
 6c3:	01 d0                	add    %edx,%eax
 6c5:	0f b6 00             	movzbl (%eax),%eax
 6c8:	84 c0                	test   %al,%al
 6ca:	75 ed                	jne    6b9 <strlen+0xf>
    ;
  return n;
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6cf:	c9                   	leave  
 6d0:	c3                   	ret    

000006d1 <memset>:

void*
memset(void *dst, int c, uint n)
{
 6d1:	55                   	push   %ebp
 6d2:	89 e5                	mov    %esp,%ebp
 6d4:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 6d7:	8b 45 10             	mov    0x10(%ebp),%eax
 6da:	89 44 24 08          	mov    %eax,0x8(%esp)
 6de:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e5:	8b 45 08             	mov    0x8(%ebp),%eax
 6e8:	89 04 24             	mov    %eax,(%esp)
 6eb:	e8 26 ff ff ff       	call   616 <stosb>
  return dst;
 6f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6f3:	c9                   	leave  
 6f4:	c3                   	ret    

000006f5 <strchr>:

char*
strchr(const char *s, char c)
{
 6f5:	55                   	push   %ebp
 6f6:	89 e5                	mov    %esp,%ebp
 6f8:	83 ec 04             	sub    $0x4,%esp
 6fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 6fe:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 701:	eb 14                	jmp    717 <strchr+0x22>
    if(*s == c)
 703:	8b 45 08             	mov    0x8(%ebp),%eax
 706:	0f b6 00             	movzbl (%eax),%eax
 709:	3a 45 fc             	cmp    -0x4(%ebp),%al
 70c:	75 05                	jne    713 <strchr+0x1e>
      return (char*)s;
 70e:	8b 45 08             	mov    0x8(%ebp),%eax
 711:	eb 13                	jmp    726 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 713:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 717:	8b 45 08             	mov    0x8(%ebp),%eax
 71a:	0f b6 00             	movzbl (%eax),%eax
 71d:	84 c0                	test   %al,%al
 71f:	75 e2                	jne    703 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 721:	b8 00 00 00 00       	mov    $0x0,%eax
}
 726:	c9                   	leave  
 727:	c3                   	ret    

00000728 <gets>:

char*
gets(char *buf, int max)
{
 728:	55                   	push   %ebp
 729:	89 e5                	mov    %esp,%ebp
 72b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 72e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 735:	eb 4c                	jmp    783 <gets+0x5b>
    cc = read(0, &c, 1);
 737:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 73e:	00 
 73f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 742:	89 44 24 04          	mov    %eax,0x4(%esp)
 746:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 74d:	e8 44 01 00 00       	call   896 <read>
 752:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 755:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 759:	7f 02                	jg     75d <gets+0x35>
      break;
 75b:	eb 31                	jmp    78e <gets+0x66>
    buf[i++] = c;
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	8d 50 01             	lea    0x1(%eax),%edx
 763:	89 55 f4             	mov    %edx,-0xc(%ebp)
 766:	89 c2                	mov    %eax,%edx
 768:	8b 45 08             	mov    0x8(%ebp),%eax
 76b:	01 c2                	add    %eax,%edx
 76d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 771:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 773:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 777:	3c 0a                	cmp    $0xa,%al
 779:	74 13                	je     78e <gets+0x66>
 77b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 77f:	3c 0d                	cmp    $0xd,%al
 781:	74 0b                	je     78e <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 783:	8b 45 f4             	mov    -0xc(%ebp),%eax
 786:	83 c0 01             	add    $0x1,%eax
 789:	3b 45 0c             	cmp    0xc(%ebp),%eax
 78c:	7c a9                	jl     737 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 78e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 791:	8b 45 08             	mov    0x8(%ebp),%eax
 794:	01 d0                	add    %edx,%eax
 796:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 799:	8b 45 08             	mov    0x8(%ebp),%eax
}
 79c:	c9                   	leave  
 79d:	c3                   	ret    

0000079e <stat>:

int
stat(char *n, struct stat *st)
{
 79e:	55                   	push   %ebp
 79f:	89 e5                	mov    %esp,%ebp
 7a1:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 7ab:	00 
 7ac:	8b 45 08             	mov    0x8(%ebp),%eax
 7af:	89 04 24             	mov    %eax,(%esp)
 7b2:	e8 07 01 00 00       	call   8be <open>
 7b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7be:	79 07                	jns    7c7 <stat+0x29>
    return -1;
 7c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7c5:	eb 23                	jmp    7ea <stat+0x4c>
  r = fstat(fd, st);
 7c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 7ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	89 04 24             	mov    %eax,(%esp)
 7d4:	e8 fd 00 00 00       	call   8d6 <fstat>
 7d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	89 04 24             	mov    %eax,(%esp)
 7e2:	e8 bf 00 00 00       	call   8a6 <close>
  return r;
 7e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7ea:	c9                   	leave  
 7eb:	c3                   	ret    

000007ec <atoi>:

int
atoi(const char *s)
{
 7ec:	55                   	push   %ebp
 7ed:	89 e5                	mov    %esp,%ebp
 7ef:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 7f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 7f9:	eb 25                	jmp    820 <atoi+0x34>
    n = n*10 + *s++ - '0';
 7fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7fe:	89 d0                	mov    %edx,%eax
 800:	c1 e0 02             	shl    $0x2,%eax
 803:	01 d0                	add    %edx,%eax
 805:	01 c0                	add    %eax,%eax
 807:	89 c1                	mov    %eax,%ecx
 809:	8b 45 08             	mov    0x8(%ebp),%eax
 80c:	8d 50 01             	lea    0x1(%eax),%edx
 80f:	89 55 08             	mov    %edx,0x8(%ebp)
 812:	0f b6 00             	movzbl (%eax),%eax
 815:	0f be c0             	movsbl %al,%eax
 818:	01 c8                	add    %ecx,%eax
 81a:	83 e8 30             	sub    $0x30,%eax
 81d:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 820:	8b 45 08             	mov    0x8(%ebp),%eax
 823:	0f b6 00             	movzbl (%eax),%eax
 826:	3c 2f                	cmp    $0x2f,%al
 828:	7e 0a                	jle    834 <atoi+0x48>
 82a:	8b 45 08             	mov    0x8(%ebp),%eax
 82d:	0f b6 00             	movzbl (%eax),%eax
 830:	3c 39                	cmp    $0x39,%al
 832:	7e c7                	jle    7fb <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 834:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 837:	c9                   	leave  
 838:	c3                   	ret    

00000839 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 839:	55                   	push   %ebp
 83a:	89 e5                	mov    %esp,%ebp
 83c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 83f:	8b 45 08             	mov    0x8(%ebp),%eax
 842:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 845:	8b 45 0c             	mov    0xc(%ebp),%eax
 848:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 84b:	eb 17                	jmp    864 <memmove+0x2b>
    *dst++ = *src++;
 84d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 850:	8d 50 01             	lea    0x1(%eax),%edx
 853:	89 55 fc             	mov    %edx,-0x4(%ebp)
 856:	8b 55 f8             	mov    -0x8(%ebp),%edx
 859:	8d 4a 01             	lea    0x1(%edx),%ecx
 85c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 85f:	0f b6 12             	movzbl (%edx),%edx
 862:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 864:	8b 45 10             	mov    0x10(%ebp),%eax
 867:	8d 50 ff             	lea    -0x1(%eax),%edx
 86a:	89 55 10             	mov    %edx,0x10(%ebp)
 86d:	85 c0                	test   %eax,%eax
 86f:	7f dc                	jg     84d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 871:	8b 45 08             	mov    0x8(%ebp),%eax
}
 874:	c9                   	leave  
 875:	c3                   	ret    

00000876 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 876:	b8 01 00 00 00       	mov    $0x1,%eax
 87b:	cd 40                	int    $0x40
 87d:	c3                   	ret    

0000087e <exit>:
SYSCALL(exit)
 87e:	b8 02 00 00 00       	mov    $0x2,%eax
 883:	cd 40                	int    $0x40
 885:	c3                   	ret    

00000886 <wait>:
SYSCALL(wait)
 886:	b8 03 00 00 00       	mov    $0x3,%eax
 88b:	cd 40                	int    $0x40
 88d:	c3                   	ret    

0000088e <pipe>:
SYSCALL(pipe)
 88e:	b8 04 00 00 00       	mov    $0x4,%eax
 893:	cd 40                	int    $0x40
 895:	c3                   	ret    

00000896 <read>:
SYSCALL(read)
 896:	b8 05 00 00 00       	mov    $0x5,%eax
 89b:	cd 40                	int    $0x40
 89d:	c3                   	ret    

0000089e <write>:
SYSCALL(write)
 89e:	b8 10 00 00 00       	mov    $0x10,%eax
 8a3:	cd 40                	int    $0x40
 8a5:	c3                   	ret    

000008a6 <close>:
SYSCALL(close)
 8a6:	b8 15 00 00 00       	mov    $0x15,%eax
 8ab:	cd 40                	int    $0x40
 8ad:	c3                   	ret    

000008ae <kill>:
SYSCALL(kill)
 8ae:	b8 06 00 00 00       	mov    $0x6,%eax
 8b3:	cd 40                	int    $0x40
 8b5:	c3                   	ret    

000008b6 <exec>:
SYSCALL(exec)
 8b6:	b8 07 00 00 00       	mov    $0x7,%eax
 8bb:	cd 40                	int    $0x40
 8bd:	c3                   	ret    

000008be <open>:
SYSCALL(open)
 8be:	b8 0f 00 00 00       	mov    $0xf,%eax
 8c3:	cd 40                	int    $0x40
 8c5:	c3                   	ret    

000008c6 <mknod>:
SYSCALL(mknod)
 8c6:	b8 11 00 00 00       	mov    $0x11,%eax
 8cb:	cd 40                	int    $0x40
 8cd:	c3                   	ret    

000008ce <unlink>:
SYSCALL(unlink)
 8ce:	b8 12 00 00 00       	mov    $0x12,%eax
 8d3:	cd 40                	int    $0x40
 8d5:	c3                   	ret    

000008d6 <fstat>:
SYSCALL(fstat)
 8d6:	b8 08 00 00 00       	mov    $0x8,%eax
 8db:	cd 40                	int    $0x40
 8dd:	c3                   	ret    

000008de <link>:
SYSCALL(link)
 8de:	b8 13 00 00 00       	mov    $0x13,%eax
 8e3:	cd 40                	int    $0x40
 8e5:	c3                   	ret    

000008e6 <mkdir>:
SYSCALL(mkdir)
 8e6:	b8 14 00 00 00       	mov    $0x14,%eax
 8eb:	cd 40                	int    $0x40
 8ed:	c3                   	ret    

000008ee <chdir>:
SYSCALL(chdir)
 8ee:	b8 09 00 00 00       	mov    $0x9,%eax
 8f3:	cd 40                	int    $0x40
 8f5:	c3                   	ret    

000008f6 <dup>:
SYSCALL(dup)
 8f6:	b8 0a 00 00 00       	mov    $0xa,%eax
 8fb:	cd 40                	int    $0x40
 8fd:	c3                   	ret    

000008fe <getpid>:
SYSCALL(getpid)
 8fe:	b8 0b 00 00 00       	mov    $0xb,%eax
 903:	cd 40                	int    $0x40
 905:	c3                   	ret    

00000906 <sbrk>:
SYSCALL(sbrk)
 906:	b8 0c 00 00 00       	mov    $0xc,%eax
 90b:	cd 40                	int    $0x40
 90d:	c3                   	ret    

0000090e <sleep>:
SYSCALL(sleep)
 90e:	b8 0d 00 00 00       	mov    $0xd,%eax
 913:	cd 40                	int    $0x40
 915:	c3                   	ret    

00000916 <uptime>:
SYSCALL(uptime)
 916:	b8 0e 00 00 00       	mov    $0xe,%eax
 91b:	cd 40                	int    $0x40
 91d:	c3                   	ret    

0000091e <changepriority>:
SYSCALL(changepriority)
 91e:	b8 16 00 00 00       	mov    $0x16,%eax
 923:	cd 40                	int    $0x40
 925:	c3                   	ret    

00000926 <processstatus>:
SYSCALL(processstatus)
 926:	b8 17 00 00 00       	mov    $0x17,%eax
 92b:	cd 40                	int    $0x40
 92d:	c3                   	ret    

0000092e <randomgen>:
SYSCALL(randomgen)
 92e:	b8 18 00 00 00       	mov    $0x18,%eax
 933:	cd 40                	int    $0x40
 935:	c3                   	ret    

00000936 <randomgenrange>:
SYSCALL(randomgenrange)
 936:	b8 19 00 00 00       	mov    $0x19,%eax
 93b:	cd 40                	int    $0x40
 93d:	c3                   	ret    

0000093e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 93e:	55                   	push   %ebp
 93f:	89 e5                	mov    %esp,%ebp
 941:	83 ec 18             	sub    $0x18,%esp
 944:	8b 45 0c             	mov    0xc(%ebp),%eax
 947:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 94a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 951:	00 
 952:	8d 45 f4             	lea    -0xc(%ebp),%eax
 955:	89 44 24 04          	mov    %eax,0x4(%esp)
 959:	8b 45 08             	mov    0x8(%ebp),%eax
 95c:	89 04 24             	mov    %eax,(%esp)
 95f:	e8 3a ff ff ff       	call   89e <write>
}
 964:	c9                   	leave  
 965:	c3                   	ret    

00000966 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 966:	55                   	push   %ebp
 967:	89 e5                	mov    %esp,%ebp
 969:	56                   	push   %esi
 96a:	53                   	push   %ebx
 96b:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 96e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 975:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 979:	74 17                	je     992 <printint+0x2c>
 97b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 97f:	79 11                	jns    992 <printint+0x2c>
    neg = 1;
 981:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 988:	8b 45 0c             	mov    0xc(%ebp),%eax
 98b:	f7 d8                	neg    %eax
 98d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 990:	eb 06                	jmp    998 <printint+0x32>
  } else {
    x = xx;
 992:	8b 45 0c             	mov    0xc(%ebp),%eax
 995:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 998:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 99f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 9a2:	8d 41 01             	lea    0x1(%ecx),%eax
 9a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 9ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9ae:	ba 00 00 00 00       	mov    $0x0,%edx
 9b3:	f7 f3                	div    %ebx
 9b5:	89 d0                	mov    %edx,%eax
 9b7:	0f b6 80 08 11 00 00 	movzbl 0x1108(%eax),%eax
 9be:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 9c2:	8b 75 10             	mov    0x10(%ebp),%esi
 9c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9c8:	ba 00 00 00 00       	mov    $0x0,%edx
 9cd:	f7 f6                	div    %esi
 9cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9d6:	75 c7                	jne    99f <printint+0x39>
  if(neg)
 9d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9dc:	74 10                	je     9ee <printint+0x88>
    buf[i++] = '-';
 9de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e1:	8d 50 01             	lea    0x1(%eax),%edx
 9e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9e7:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 9ec:	eb 1f                	jmp    a0d <printint+0xa7>
 9ee:	eb 1d                	jmp    a0d <printint+0xa7>
    putc(fd, buf[i]);
 9f0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 9f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f6:	01 d0                	add    %edx,%eax
 9f8:	0f b6 00             	movzbl (%eax),%eax
 9fb:	0f be c0             	movsbl %al,%eax
 9fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 a02:	8b 45 08             	mov    0x8(%ebp),%eax
 a05:	89 04 24             	mov    %eax,(%esp)
 a08:	e8 31 ff ff ff       	call   93e <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a0d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a15:	79 d9                	jns    9f0 <printint+0x8a>
    putc(fd, buf[i]);
}
 a17:	83 c4 30             	add    $0x30,%esp
 a1a:	5b                   	pop    %ebx
 a1b:	5e                   	pop    %esi
 a1c:	5d                   	pop    %ebp
 a1d:	c3                   	ret    

00000a1e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a1e:	55                   	push   %ebp
 a1f:	89 e5                	mov    %esp,%ebp
 a21:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a24:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a2b:	8d 45 0c             	lea    0xc(%ebp),%eax
 a2e:	83 c0 04             	add    $0x4,%eax
 a31:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 a34:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a3b:	e9 7c 01 00 00       	jmp    bbc <printf+0x19e>
    c = fmt[i] & 0xff;
 a40:	8b 55 0c             	mov    0xc(%ebp),%edx
 a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a46:	01 d0                	add    %edx,%eax
 a48:	0f b6 00             	movzbl (%eax),%eax
 a4b:	0f be c0             	movsbl %al,%eax
 a4e:	25 ff 00 00 00       	and    $0xff,%eax
 a53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a56:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a5a:	75 2c                	jne    a88 <printf+0x6a>
      if(c == '%'){
 a5c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a60:	75 0c                	jne    a6e <printf+0x50>
        state = '%';
 a62:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a69:	e9 4a 01 00 00       	jmp    bb8 <printf+0x19a>
      } else {
        putc(fd, c);
 a6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a71:	0f be c0             	movsbl %al,%eax
 a74:	89 44 24 04          	mov    %eax,0x4(%esp)
 a78:	8b 45 08             	mov    0x8(%ebp),%eax
 a7b:	89 04 24             	mov    %eax,(%esp)
 a7e:	e8 bb fe ff ff       	call   93e <putc>
 a83:	e9 30 01 00 00       	jmp    bb8 <printf+0x19a>
      }
    } else if(state == '%'){
 a88:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a8c:	0f 85 26 01 00 00    	jne    bb8 <printf+0x19a>
      if(c == 'd'){
 a92:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a96:	75 2d                	jne    ac5 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 a98:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a9b:	8b 00                	mov    (%eax),%eax
 a9d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 aa4:	00 
 aa5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 aac:	00 
 aad:	89 44 24 04          	mov    %eax,0x4(%esp)
 ab1:	8b 45 08             	mov    0x8(%ebp),%eax
 ab4:	89 04 24             	mov    %eax,(%esp)
 ab7:	e8 aa fe ff ff       	call   966 <printint>
        ap++;
 abc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ac0:	e9 ec 00 00 00       	jmp    bb1 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 ac5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 ac9:	74 06                	je     ad1 <printf+0xb3>
 acb:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 acf:	75 2d                	jne    afe <printf+0xe0>
        printint(fd, *ap, 16, 0);
 ad1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ad4:	8b 00                	mov    (%eax),%eax
 ad6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 add:	00 
 ade:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 ae5:	00 
 ae6:	89 44 24 04          	mov    %eax,0x4(%esp)
 aea:	8b 45 08             	mov    0x8(%ebp),%eax
 aed:	89 04 24             	mov    %eax,(%esp)
 af0:	e8 71 fe ff ff       	call   966 <printint>
        ap++;
 af5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 af9:	e9 b3 00 00 00       	jmp    bb1 <printf+0x193>
      } else if(c == 's'){
 afe:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 b02:	75 45                	jne    b49 <printf+0x12b>
        s = (char*)*ap;
 b04:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b07:	8b 00                	mov    (%eax),%eax
 b09:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b0c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b14:	75 09                	jne    b1f <printf+0x101>
          s = "(null)";
 b16:	c7 45 f4 35 0e 00 00 	movl   $0xe35,-0xc(%ebp)
        while(*s != 0){
 b1d:	eb 1e                	jmp    b3d <printf+0x11f>
 b1f:	eb 1c                	jmp    b3d <printf+0x11f>
          putc(fd, *s);
 b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b24:	0f b6 00             	movzbl (%eax),%eax
 b27:	0f be c0             	movsbl %al,%eax
 b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
 b2e:	8b 45 08             	mov    0x8(%ebp),%eax
 b31:	89 04 24             	mov    %eax,(%esp)
 b34:	e8 05 fe ff ff       	call   93e <putc>
          s++;
 b39:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b40:	0f b6 00             	movzbl (%eax),%eax
 b43:	84 c0                	test   %al,%al
 b45:	75 da                	jne    b21 <printf+0x103>
 b47:	eb 68                	jmp    bb1 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b49:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b4d:	75 1d                	jne    b6c <printf+0x14e>
        putc(fd, *ap);
 b4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b52:	8b 00                	mov    (%eax),%eax
 b54:	0f be c0             	movsbl %al,%eax
 b57:	89 44 24 04          	mov    %eax,0x4(%esp)
 b5b:	8b 45 08             	mov    0x8(%ebp),%eax
 b5e:	89 04 24             	mov    %eax,(%esp)
 b61:	e8 d8 fd ff ff       	call   93e <putc>
        ap++;
 b66:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b6a:	eb 45                	jmp    bb1 <printf+0x193>
      } else if(c == '%'){
 b6c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b70:	75 17                	jne    b89 <printf+0x16b>
        putc(fd, c);
 b72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b75:	0f be c0             	movsbl %al,%eax
 b78:	89 44 24 04          	mov    %eax,0x4(%esp)
 b7c:	8b 45 08             	mov    0x8(%ebp),%eax
 b7f:	89 04 24             	mov    %eax,(%esp)
 b82:	e8 b7 fd ff ff       	call   93e <putc>
 b87:	eb 28                	jmp    bb1 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b89:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 b90:	00 
 b91:	8b 45 08             	mov    0x8(%ebp),%eax
 b94:	89 04 24             	mov    %eax,(%esp)
 b97:	e8 a2 fd ff ff       	call   93e <putc>
        putc(fd, c);
 b9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b9f:	0f be c0             	movsbl %al,%eax
 ba2:	89 44 24 04          	mov    %eax,0x4(%esp)
 ba6:	8b 45 08             	mov    0x8(%ebp),%eax
 ba9:	89 04 24             	mov    %eax,(%esp)
 bac:	e8 8d fd ff ff       	call   93e <putc>
      }
      state = 0;
 bb1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 bb8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
 bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bc2:	01 d0                	add    %edx,%eax
 bc4:	0f b6 00             	movzbl (%eax),%eax
 bc7:	84 c0                	test   %al,%al
 bc9:	0f 85 71 fe ff ff    	jne    a40 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 bcf:	c9                   	leave  
 bd0:	c3                   	ret    

00000bd1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bd1:	55                   	push   %ebp
 bd2:	89 e5                	mov    %esp,%ebp
 bd4:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bd7:	8b 45 08             	mov    0x8(%ebp),%eax
 bda:	83 e8 08             	sub    $0x8,%eax
 bdd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 be0:	a1 2c 11 00 00       	mov    0x112c,%eax
 be5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 be8:	eb 24                	jmp    c0e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bed:	8b 00                	mov    (%eax),%eax
 bef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bf2:	77 12                	ja     c06 <free+0x35>
 bf4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bf7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bfa:	77 24                	ja     c20 <free+0x4f>
 bfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bff:	8b 00                	mov    (%eax),%eax
 c01:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c04:	77 1a                	ja     c20 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c09:	8b 00                	mov    (%eax),%eax
 c0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c11:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c14:	76 d4                	jbe    bea <free+0x19>
 c16:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c19:	8b 00                	mov    (%eax),%eax
 c1b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c1e:	76 ca                	jbe    bea <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c20:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c23:	8b 40 04             	mov    0x4(%eax),%eax
 c26:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c30:	01 c2                	add    %eax,%edx
 c32:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c35:	8b 00                	mov    (%eax),%eax
 c37:	39 c2                	cmp    %eax,%edx
 c39:	75 24                	jne    c5f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c3e:	8b 50 04             	mov    0x4(%eax),%edx
 c41:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c44:	8b 00                	mov    (%eax),%eax
 c46:	8b 40 04             	mov    0x4(%eax),%eax
 c49:	01 c2                	add    %eax,%edx
 c4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c4e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c54:	8b 00                	mov    (%eax),%eax
 c56:	8b 10                	mov    (%eax),%edx
 c58:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c5b:	89 10                	mov    %edx,(%eax)
 c5d:	eb 0a                	jmp    c69 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c62:	8b 10                	mov    (%eax),%edx
 c64:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c67:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c6c:	8b 40 04             	mov    0x4(%eax),%eax
 c6f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c76:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c79:	01 d0                	add    %edx,%eax
 c7b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c7e:	75 20                	jne    ca0 <free+0xcf>
    p->s.size += bp->s.size;
 c80:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c83:	8b 50 04             	mov    0x4(%eax),%edx
 c86:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c89:	8b 40 04             	mov    0x4(%eax),%eax
 c8c:	01 c2                	add    %eax,%edx
 c8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c91:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c94:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c97:	8b 10                	mov    (%eax),%edx
 c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c9c:	89 10                	mov    %edx,(%eax)
 c9e:	eb 08                	jmp    ca8 <free+0xd7>
  } else
    p->s.ptr = bp;
 ca0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ca3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 ca6:	89 10                	mov    %edx,(%eax)
  freep = p;
 ca8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cab:	a3 2c 11 00 00       	mov    %eax,0x112c
}
 cb0:	c9                   	leave  
 cb1:	c3                   	ret    

00000cb2 <morecore>:

static Header*
morecore(uint nu)
{
 cb2:	55                   	push   %ebp
 cb3:	89 e5                	mov    %esp,%ebp
 cb5:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 cb8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 cbf:	77 07                	ja     cc8 <morecore+0x16>
    nu = 4096;
 cc1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 cc8:	8b 45 08             	mov    0x8(%ebp),%eax
 ccb:	c1 e0 03             	shl    $0x3,%eax
 cce:	89 04 24             	mov    %eax,(%esp)
 cd1:	e8 30 fc ff ff       	call   906 <sbrk>
 cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 cd9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 cdd:	75 07                	jne    ce6 <morecore+0x34>
    return 0;
 cdf:	b8 00 00 00 00       	mov    $0x0,%eax
 ce4:	eb 22                	jmp    d08 <morecore+0x56>
  hp = (Header*)p;
 ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cef:	8b 55 08             	mov    0x8(%ebp),%edx
 cf2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cf8:	83 c0 08             	add    $0x8,%eax
 cfb:	89 04 24             	mov    %eax,(%esp)
 cfe:	e8 ce fe ff ff       	call   bd1 <free>
  return freep;
 d03:	a1 2c 11 00 00       	mov    0x112c,%eax
}
 d08:	c9                   	leave  
 d09:	c3                   	ret    

00000d0a <malloc>:

void*
malloc(uint nbytes)
{
 d0a:	55                   	push   %ebp
 d0b:	89 e5                	mov    %esp,%ebp
 d0d:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d10:	8b 45 08             	mov    0x8(%ebp),%eax
 d13:	83 c0 07             	add    $0x7,%eax
 d16:	c1 e8 03             	shr    $0x3,%eax
 d19:	83 c0 01             	add    $0x1,%eax
 d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d1f:	a1 2c 11 00 00       	mov    0x112c,%eax
 d24:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d2b:	75 23                	jne    d50 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 d2d:	c7 45 f0 24 11 00 00 	movl   $0x1124,-0x10(%ebp)
 d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d37:	a3 2c 11 00 00       	mov    %eax,0x112c
 d3c:	a1 2c 11 00 00       	mov    0x112c,%eax
 d41:	a3 24 11 00 00       	mov    %eax,0x1124
    base.s.size = 0;
 d46:	c7 05 28 11 00 00 00 	movl   $0x0,0x1128
 d4d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d53:	8b 00                	mov    (%eax),%eax
 d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d5b:	8b 40 04             	mov    0x4(%eax),%eax
 d5e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d61:	72 4d                	jb     db0 <malloc+0xa6>
      if(p->s.size == nunits)
 d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d66:	8b 40 04             	mov    0x4(%eax),%eax
 d69:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d6c:	75 0c                	jne    d7a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d71:	8b 10                	mov    (%eax),%edx
 d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d76:	89 10                	mov    %edx,(%eax)
 d78:	eb 26                	jmp    da0 <malloc+0x96>
      else {
        p->s.size -= nunits;
 d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d7d:	8b 40 04             	mov    0x4(%eax),%eax
 d80:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d83:	89 c2                	mov    %eax,%edx
 d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d88:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d8e:	8b 40 04             	mov    0x4(%eax),%eax
 d91:	c1 e0 03             	shl    $0x3,%eax
 d94:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d9d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 da3:	a3 2c 11 00 00       	mov    %eax,0x112c
      return (void*)(p + 1);
 da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dab:	83 c0 08             	add    $0x8,%eax
 dae:	eb 38                	jmp    de8 <malloc+0xde>
    }
    if(p == freep)
 db0:	a1 2c 11 00 00       	mov    0x112c,%eax
 db5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 db8:	75 1b                	jne    dd5 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
 dbd:	89 04 24             	mov    %eax,(%esp)
 dc0:	e8 ed fe ff ff       	call   cb2 <morecore>
 dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 dc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 dcc:	75 07                	jne    dd5 <malloc+0xcb>
        return 0;
 dce:	b8 00 00 00 00       	mov    $0x0,%eax
 dd3:	eb 13                	jmp    de8 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dde:	8b 00                	mov    (%eax),%eax
 de0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 de3:	e9 70 ff ff ff       	jmp    d58 <malloc+0x4e>
}
 de8:	c9                   	leave  
 de9:	c3                   	ret    
