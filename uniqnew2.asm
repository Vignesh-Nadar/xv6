
_uniqnew2:     file format elf32-i386


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
  1c:	e8 71 06 00 00       	call   692 <memset>
    char *dst = line;
  21:	8b 45 08             	mov    0x8(%ebp),%eax
  24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((read(fd, buf, 1)) > 0) {
  27:	eb 47                	jmp    70 <readLine+0x70>
        if (buf[0] == '\n') {
  29:	0f b6 05 20 11 00 00 	movzbl 0x1120,%eax
  30:	3c 0a                	cmp    $0xa,%al
  32:	75 14                	jne    48 <readLine+0x48>
            *dst++ = buf[0];
  34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  37:	8d 50 01             	lea    0x1(%eax),%edx
  3a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  3d:	0f b6 15 20 11 00 00 	movzbl 0x1120,%edx
  44:	88 10                	mov    %dl,(%eax)
            break;
  46:	eb 47                	jmp    8f <readLine+0x8f>
        } else {
            *dst++ = buf[0];
  48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4b:	8d 50 01             	lea    0x1(%eax),%edx
  4e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  51:	0f b6 15 20 11 00 00 	movzbl 0x1120,%edx
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
  78:	c7 44 24 04 20 11 00 	movl   $0x1120,0x4(%esp)
  7f:	00 
  80:	8b 45 0c             	mov    0xc(%ebp),%eax
  83:	89 04 24             	mov    %eax,(%esp)
  86:	e8 cc 07 00 00       	call   857 <read>
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

000000ae <tolower>:

uchar tolower(uchar ch) {
  ae:	55                   	push   %ebp
  af:	89 e5                	mov    %esp,%ebp
  b1:	83 ec 04             	sub    $0x4,%esp
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	88 45 fc             	mov    %al,-0x4(%ebp)
    if (ch >= 'A' && ch <= 'Z')
  ba:	80 7d fc 40          	cmpb   $0x40,-0x4(%ebp)
  be:	76 0a                	jbe    ca <tolower+0x1c>
  c0:	80 7d fc 5a          	cmpb   $0x5a,-0x4(%ebp)
  c4:	77 04                	ja     ca <tolower+0x1c>
        ch = 'a' + (ch - 'A');
  c6:	80 45 fc 20          	addb   $0x20,-0x4(%ebp)
    return ch;
  ca:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
}
  ce:	c9                   	leave  
  cf:	c3                   	ret    

000000d0 <caseIgnoreComparison>:

int caseIgnoreComparison(const char *p, const char *q) {
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	53                   	push   %ebx
  d4:	83 ec 04             	sub    $0x4,%esp
    while (*p && tolower(*p) == tolower(*q))
  d7:	eb 08                	jmp    e1 <caseIgnoreComparison+0x11>
        p++, q++;
  d9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  dd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        ch = 'a' + (ch - 'A');
    return ch;
}

int caseIgnoreComparison(const char *p, const char *q) {
    while (*p && tolower(*p) == tolower(*q))
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 00             	movzbl (%eax),%eax
  e7:	84 c0                	test   %al,%al
  e9:	74 28                	je     113 <caseIgnoreComparison+0x43>
  eb:	8b 45 08             	mov    0x8(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	0f b6 c0             	movzbl %al,%eax
  f4:	89 04 24             	mov    %eax,(%esp)
  f7:	e8 b2 ff ff ff       	call   ae <tolower>
  fc:	89 c3                	mov    %eax,%ebx
  fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 101:	0f b6 00             	movzbl (%eax),%eax
 104:	0f b6 c0             	movzbl %al,%eax
 107:	89 04 24             	mov    %eax,(%esp)
 10a:	e8 9f ff ff ff       	call   ae <tolower>
 10f:	38 c3                	cmp    %al,%bl
 111:	74 c6                	je     d9 <caseIgnoreComparison+0x9>
        p++, q++;
    return (uchar) *p - (uchar) *q;
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	0f b6 00             	movzbl (%eax),%eax
 119:	0f b6 d0             	movzbl %al,%edx
 11c:	8b 45 0c             	mov    0xc(%ebp),%eax
 11f:	0f b6 00             	movzbl (%eax),%eax
 122:	0f b6 c0             	movzbl %al,%eax
 125:	29 c2                	sub    %eax,%edx
 127:	89 d0                	mov    %edx,%eax
}
 129:	83 c4 04             	add    $0x4,%esp
 12c:	5b                   	pop    %ebx
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret    

0000012f <uniq>:

void uniq(int fd, char *name) {
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
 132:	83 ec 38             	sub    $0x38,%esp
    char *prev = NULL, *cur = NULL;
 135:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 13c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char *line = (char *) malloc(MAX_BUF * sizeof(char));
 143:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
 14a:	e8 7c 0b 00 00       	call   ccb <malloc>
 14f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    int count = 0;
 152:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while ((readLine(line, fd)) > 0) {
 159:	e9 b7 01 00 00       	jmp    315 <uniq+0x1e6>
        if (prev == NULL) {
 15e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 162:	0f 85 87 00 00 00    	jne    1ef <uniq+0xc0>
            prev = (char *) malloc(MAX_BUF * sizeof(char));
 168:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
 16f:	e8 57 0b 00 00       	call   ccb <malloc>
 174:	89 45 f4             	mov    %eax,-0xc(%ebp)
            cur = (char *) malloc(MAX_BUF * sizeof(char));
 177:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
 17e:	e8 48 0b 00 00       	call   ccb <malloc>
 183:	89 45 f0             	mov    %eax,-0x10(%ebp)
            memmove(prev, line, MAX_BUF);
 186:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 18d:	00 
 18e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 191:	89 44 24 04          	mov    %eax,0x4(%esp)
 195:	8b 45 f4             	mov    -0xc(%ebp),%eax
 198:	89 04 24             	mov    %eax,(%esp)
 19b:	e8 5a 06 00 00       	call   7fa <memmove>
            memmove(cur, line, MAX_BUF);
 1a0:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 1a7:	00 
 1a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 1af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1b2:	89 04 24             	mov    %eax,(%esp)
 1b5:	e8 40 06 00 00       	call   7fa <memmove>
            count = 1;
 1ba:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
            if (optionCD == 1) {
 1c1:	a1 e8 10 00 00       	mov    0x10e8,%eax
 1c6:	83 f8 01             	cmp    $0x1,%eax
 1c9:	0f 85 2c 01 00 00    	jne    2fb <uniq+0x1cc>
                printf(1, "%s", cur);
 1cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1d2:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d6:	c7 44 24 04 ac 0d 00 	movl   $0xdac,0x4(%esp)
 1dd:	00 
 1de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1e5:	e8 f5 07 00 00       	call   9df <printf>
 1ea:	e9 0c 01 00 00       	jmp    2fb <uniq+0x1cc>
            }
        } else {
            memmove(cur, line, MAX_BUF);
 1ef:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 1f6:	00 
 1f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 1fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 201:	89 04 24             	mov    %eax,(%esp)
 204:	e8 f1 05 00 00       	call   7fa <memmove>
            int cmp_result;
            if (optionI) {
 209:	a1 00 11 00 00       	mov    0x1100,%eax
 20e:	85 c0                	test   %eax,%eax
 210:	74 17                	je     229 <uniq+0xfa>
                cmp_result = caseIgnoreComparison(cur, prev);
 212:	8b 45 f4             	mov    -0xc(%ebp),%eax
 215:	89 44 24 04          	mov    %eax,0x4(%esp)
 219:	8b 45 f0             	mov    -0x10(%ebp),%eax
 21c:	89 04 24             	mov    %eax,(%esp)
 21f:	e8 ac fe ff ff       	call   d0 <caseIgnoreComparison>
 224:	89 45 e8             	mov    %eax,-0x18(%ebp)
 227:	eb 15                	jmp    23e <uniq+0x10f>
            } else {
                cmp_result = strcmp(cur, prev);
 229:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22c:	89 44 24 04          	mov    %eax,0x4(%esp)
 230:	8b 45 f0             	mov    -0x10(%ebp),%eax
 233:	89 04 24             	mov    %eax,(%esp)
 236:	e8 f1 03 00 00       	call   62c <strcmp>
 23b:	89 45 e8             	mov    %eax,-0x18(%ebp)
            }
            if (cmp_result == 0)
 23e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 242:	75 30                	jne    274 <uniq+0x145>
            {
                count++;
 244:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
                if (optionI) {
 248:	a1 00 11 00 00       	mov    0x1100,%eax
 24d:	85 c0                	test   %eax,%eax
 24f:	0f 84 a6 00 00 00    	je     2fb <uniq+0x1cc>
                    memmove(cur, prev, MAX_BUF);
 255:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 25c:	00 
 25d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 260:	89 44 24 04          	mov    %eax,0x4(%esp)
 264:	8b 45 f0             	mov    -0x10(%ebp),%eax
 267:	89 04 24             	mov    %eax,(%esp)
 26a:	e8 8b 05 00 00       	call   7fa <memmove>
 26f:	e9 87 00 00 00       	jmp    2fb <uniq+0x1cc>
                }
            }
            else {
                if (optionCD == 1)
 274:	a1 e8 10 00 00       	mov    0x10e8,%eax
 279:	83 f8 01             	cmp    $0x1,%eax
 27c:	75 1d                	jne    29b <uniq+0x16c>
                {
                    printf(1, "%s", cur);
 27e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 281:	89 44 24 08          	mov    %eax,0x8(%esp)
 285:	c7 44 24 04 ac 0d 00 	movl   $0xdac,0x4(%esp)
 28c:	00 
 28d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 294:	e8 46 07 00 00       	call   9df <printf>
 299:	eb 59                	jmp    2f4 <uniq+0x1c5>
                } else if (optionCD == 2)
 29b:	a1 e8 10 00 00       	mov    0x10e8,%eax
 2a0:	83 f8 02             	cmp    $0x2,%eax
 2a3:	75 24                	jne    2c9 <uniq+0x19a>
                {
                    printf(1, "%d %s", count, prev);
 2a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
 2ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 2af:	89 44 24 08          	mov    %eax,0x8(%esp)
 2b3:	c7 44 24 04 af 0d 00 	movl   $0xdaf,0x4(%esp)
 2ba:	00 
 2bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2c2:	e8 18 07 00 00       	call   9df <printf>
 2c7:	eb 2b                	jmp    2f4 <uniq+0x1c5>
                } else if (optionCD == 3 && count > 1)
 2c9:	a1 e8 10 00 00       	mov    0x10e8,%eax
 2ce:	83 f8 03             	cmp    $0x3,%eax
 2d1:	75 21                	jne    2f4 <uniq+0x1c5>
 2d3:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 2d7:	7e 1b                	jle    2f4 <uniq+0x1c5>
                {
                    printf(1, "%s", prev);
 2d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2dc:	89 44 24 08          	mov    %eax,0x8(%esp)
 2e0:	c7 44 24 04 ac 0d 00 	movl   $0xdac,0x4(%esp)
 2e7:	00 
 2e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2ef:	e8 eb 06 00 00       	call   9df <printf>
                }
                count = 1;
 2f4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
            }
        }
        memmove(prev, cur, MAX_BUF);
 2fb:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 302:	00 
 303:	8b 45 f0             	mov    -0x10(%ebp),%eax
 306:	89 44 24 04          	mov    %eax,0x4(%esp)
 30a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30d:	89 04 24             	mov    %eax,(%esp)
 310:	e8 e5 04 00 00       	call   7fa <memmove>

void uniq(int fd, char *name) {
    char *prev = NULL, *cur = NULL;
    char *line = (char *) malloc(MAX_BUF * sizeof(char));
    int count = 0;
    while ((readLine(line, fd)) > 0) {
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	89 44 24 04          	mov    %eax,0x4(%esp)
 31c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 31f:	89 04 24             	mov    %eax,(%esp)
 322:	e8 d9 fc ff ff       	call   0 <readLine>
 327:	85 c0                	test   %eax,%eax
 329:	0f 8f 2f fe ff ff    	jg     15e <uniq+0x2f>
                count = 1;
            }
        }
        memmove(prev, cur, MAX_BUF);
    }
    if ((optionCD == 3 && count > 1)) {
 32f:	a1 e8 10 00 00       	mov    0x10e8,%eax
 334:	83 f8 03             	cmp    $0x3,%eax
 337:	75 23                	jne    35c <uniq+0x22d>
 339:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 33d:	7e 1d                	jle    35c <uniq+0x22d>
        printf(1, "%s", cur);
 33f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 342:	89 44 24 08          	mov    %eax,0x8(%esp)
 346:	c7 44 24 04 ac 0d 00 	movl   $0xdac,0x4(%esp)
 34d:	00 
 34e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 355:	e8 85 06 00 00       	call   9df <printf>
 35a:	eb 2c                	jmp    388 <uniq+0x259>
    } else if (optionCD == 2) {
 35c:	a1 e8 10 00 00       	mov    0x10e8,%eax
 361:	83 f8 02             	cmp    $0x2,%eax
 364:	75 22                	jne    388 <uniq+0x259>
        printf(1, "%d %s", count, cur);
 366:	8b 45 f0             	mov    -0x10(%ebp),%eax
 369:	89 44 24 0c          	mov    %eax,0xc(%esp)
 36d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 370:	89 44 24 08          	mov    %eax,0x8(%esp)
 374:	c7 44 24 04 af 0d 00 	movl   $0xdaf,0x4(%esp)
 37b:	00 
 37c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 383:	e8 57 06 00 00       	call   9df <printf>

    }
    free(prev);
 388:	8b 45 f4             	mov    -0xc(%ebp),%eax
 38b:	89 04 24             	mov    %eax,(%esp)
 38e:	e8 ff 07 00 00       	call   b92 <free>
    free(cur);
 393:	8b 45 f0             	mov    -0x10(%ebp),%eax
 396:	89 04 24             	mov    %eax,(%esp)
 399:	e8 f4 07 00 00       	call   b92 <free>
    free(line);
 39e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3a1:	89 04 24             	mov    %eax,(%esp)
 3a4:	e8 e9 07 00 00       	call   b92 <free>
}
 3a9:	c9                   	leave  
 3aa:	c3                   	ret    

000003ab <readOperators>:

int readOperators(int argc, char *argv[]) {
 3ab:	55                   	push   %ebp
 3ac:	89 e5                	mov    %esp,%ebp
 3ae:	83 ec 28             	sub    $0x28,%esp
    if (argumentIndex >= argc - 1) {
 3b1:	8b 45 08             	mov    0x8(%ebp),%eax
 3b4:	8d 50 ff             	lea    -0x1(%eax),%edx
 3b7:	a1 e4 10 00 00       	mov    0x10e4,%eax
 3bc:	39 c2                	cmp    %eax,%edx
 3be:	7f 0a                	jg     3ca <readOperators+0x1f>
        return 0;
 3c0:	b8 00 00 00 00       	mov    $0x0,%eax
 3c5:	e9 81 00 00 00       	jmp    44b <readOperators+0xa0>
    }
    char *options = "cdiCDI";
 3ca:	c7 45 f4 b5 0d 00 00 	movl   $0xdb5,-0xc(%ebp)
    char *arg = argv[argumentIndex];
 3d1:	a1 e4 10 00 00       	mov    0x10e4,%eax
 3d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 3dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e0:	01 d0                	add    %edx,%eax
 3e2:	8b 00                	mov    (%eax),%eax
 3e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (arg[0] != '-' || (strchr(options, arg[1]) == 0)) {
 3e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3ea:	0f b6 00             	movzbl (%eax),%eax
 3ed:	3c 2d                	cmp    $0x2d,%al
 3ef:	75 1f                	jne    410 <readOperators+0x65>
 3f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3f4:	83 c0 01             	add    $0x1,%eax
 3f7:	0f b6 00             	movzbl (%eax),%eax
 3fa:	0f be c0             	movsbl %al,%eax
 3fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 401:	8b 45 f4             	mov    -0xc(%ebp),%eax
 404:	89 04 24             	mov    %eax,(%esp)
 407:	e8 aa 02 00 00       	call   6b6 <strchr>
 40c:	85 c0                	test   %eax,%eax
 40e:	75 22                	jne    432 <readOperators+0x87>
        printf(1, "Not a valid option for UNIQ : %s\n", arg);
 410:	8b 45 f0             	mov    -0x10(%ebp),%eax
 413:	89 44 24 08          	mov    %eax,0x8(%esp)
 417:	c7 44 24 04 bc 0d 00 	movl   $0xdbc,0x4(%esp)
 41e:	00 
 41f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 426:	e8 b4 05 00 00       	call   9df <printf>
        return 0;
 42b:	b8 00 00 00 00       	mov    $0x0,%eax
 430:	eb 19                	jmp    44b <readOperators+0xa0>
    } else {
        argumentIndex++;
 432:	a1 e4 10 00 00       	mov    0x10e4,%eax
 437:	83 c0 01             	add    $0x1,%eax
 43a:	a3 e4 10 00 00       	mov    %eax,0x10e4
        return arg[1];
 43f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 442:	83 c0 01             	add    $0x1,%eax
 445:	0f b6 00             	movzbl (%eax),%eax
 448:	0f be c0             	movsbl %al,%eax
    }
}
 44b:	c9                   	leave  
 44c:	c3                   	ret    

0000044d <main>:

int main(int argc, char *argv[]) {
 44d:	55                   	push   %ebp
 44e:	89 e5                	mov    %esp,%ebp
 450:	83 e4 f0             	and    $0xfffffff0,%esp
 453:	83 ec 20             	sub    $0x20,%esp
    int fd;
    int c;
    if (argc <= 1) {
 456:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 45a:	7f 19                	jg     475 <main+0x28>
        uniq(0, "");
 45c:	c7 44 24 04 de 0d 00 	movl   $0xdde,0x4(%esp)
 463:	00 
 464:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 46b:	e8 bf fc ff ff       	call   12f <uniq>
        exit();
 470:	e8 ca 03 00 00       	call   83f <exit>
    } else if (argc == 2) {
 475:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 479:	75 65                	jne    4e0 <main+0x93>
        if ((fd = open(argv[1], 0)) < 0) {
 47b:	8b 45 0c             	mov    0xc(%ebp),%eax
 47e:	83 c0 04             	add    $0x4,%eax
 481:	8b 00                	mov    (%eax),%eax
 483:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 48a:	00 
 48b:	89 04 24             	mov    %eax,(%esp)
 48e:	e8 ec 03 00 00       	call   87f <open>
 493:	89 44 24 1c          	mov    %eax,0x1c(%esp)
 497:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 49c:	79 25                	jns    4c3 <main+0x76>
            printf(1, "uniq: cannot open %s\n", argv[1]);
 49e:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a1:	83 c0 04             	add    $0x4,%eax
 4a4:	8b 00                	mov    (%eax),%eax
 4a6:	89 44 24 08          	mov    %eax,0x8(%esp)
 4aa:	c7 44 24 04 df 0d 00 	movl   $0xddf,0x4(%esp)
 4b1:	00 
 4b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4b9:	e8 21 05 00 00       	call   9df <printf>
            exit();
 4be:	e8 7c 03 00 00       	call   83f <exit>
        }
        uniq(fd, argv[1]);
 4c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c6:	83 c0 04             	add    $0x4,%eax
 4c9:	8b 00                	mov    (%eax),%eax
 4cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 4d3:	89 04 24             	mov    %eax,(%esp)
 4d6:	e8 54 fc ff ff       	call   12f <uniq>
        exit();
 4db:	e8 5f 03 00 00       	call   83f <exit>
    } else if (argc >= 3) {
 4e0:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 4e4:	0f 8e e8 00 00 00    	jle    5d2 <main+0x185>
        while ((c = readOperators(argc, argv)) > 0) {
 4ea:	eb 48                	jmp    534 <main+0xe7>

            if (c == 'c' || c == 'C')
 4ec:	83 7c 24 18 63       	cmpl   $0x63,0x18(%esp)
 4f1:	74 07                	je     4fa <main+0xad>
 4f3:	83 7c 24 18 43       	cmpl   $0x43,0x18(%esp)
 4f8:	75 0a                	jne    504 <main+0xb7>
            {
              optionCD = 2;
 4fa:	c7 05 e8 10 00 00 02 	movl   $0x2,0x10e8
 501:	00 00 00 
            }
            if (c == 'd' || c == 'D')
 504:	83 7c 24 18 64       	cmpl   $0x64,0x18(%esp)
 509:	74 07                	je     512 <main+0xc5>
 50b:	83 7c 24 18 44       	cmpl   $0x44,0x18(%esp)
 510:	75 0a                	jne    51c <main+0xcf>
            {
              optionCD = 3;
 512:	c7 05 e8 10 00 00 03 	movl   $0x3,0x10e8
 519:	00 00 00 
            }
            if (c == 'i' || c == 'I')
 51c:	83 7c 24 18 69       	cmpl   $0x69,0x18(%esp)
 521:	74 07                	je     52a <main+0xdd>
 523:	83 7c 24 18 49       	cmpl   $0x49,0x18(%esp)
 528:	75 0a                	jne    534 <main+0xe7>
            {
              optionI = 1;
 52a:	c7 05 00 11 00 00 01 	movl   $0x1,0x1100
 531:	00 00 00 
            exit();
        }
        uniq(fd, argv[1]);
        exit();
    } else if (argc >= 3) {
        while ((c = readOperators(argc, argv)) > 0) {
 534:	8b 45 0c             	mov    0xc(%ebp),%eax
 537:	89 44 24 04          	mov    %eax,0x4(%esp)
 53b:	8b 45 08             	mov    0x8(%ebp),%eax
 53e:	89 04 24             	mov    %eax,(%esp)
 541:	e8 65 fe ff ff       	call   3ab <readOperators>
 546:	89 44 24 18          	mov    %eax,0x18(%esp)
 54a:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 54f:	7f 9b                	jg     4ec <main+0x9f>
            if (c == 'i' || c == 'I')
            {
              optionI = 1;
            }
        }
        if ((fd = open(argv[argc - 1], 0)) < 0) {
 551:	8b 45 08             	mov    0x8(%ebp),%eax
 554:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
 559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 560:	8b 45 0c             	mov    0xc(%ebp),%eax
 563:	01 d0                	add    %edx,%eax
 565:	8b 00                	mov    (%eax),%eax
 567:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 56e:	00 
 56f:	89 04 24             	mov    %eax,(%esp)
 572:	e8 08 03 00 00       	call   87f <open>
 577:	89 44 24 1c          	mov    %eax,0x1c(%esp)
 57b:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 580:	79 25                	jns    5a7 <main+0x15a>
            printf(1, "uniq: cannot open %s\n", argv[1]);
 582:	8b 45 0c             	mov    0xc(%ebp),%eax
 585:	83 c0 04             	add    $0x4,%eax
 588:	8b 00                	mov    (%eax),%eax
 58a:	89 44 24 08          	mov    %eax,0x8(%esp)
 58e:	c7 44 24 04 df 0d 00 	movl   $0xddf,0x4(%esp)
 595:	00 
 596:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 59d:	e8 3d 04 00 00       	call   9df <printf>
            exit();
 5a2:	e8 98 02 00 00       	call   83f <exit>
        }
        uniq(fd, argv[argc - 1]);
 5a7:	8b 45 08             	mov    0x8(%ebp),%eax
 5aa:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
 5af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 5b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b9:	01 d0                	add    %edx,%eax
 5bb:	8b 00                	mov    (%eax),%eax
 5bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c1:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 5c5:	89 04 24             	mov    %eax,(%esp)
 5c8:	e8 62 fb ff ff       	call   12f <uniq>
        exit();
 5cd:	e8 6d 02 00 00       	call   83f <exit>
    }
    exit();
 5d2:	e8 68 02 00 00       	call   83f <exit>

000005d7 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 5d7:	55                   	push   %ebp
 5d8:	89 e5                	mov    %esp,%ebp
 5da:	57                   	push   %edi
 5db:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 5dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5df:	8b 55 10             	mov    0x10(%ebp),%edx
 5e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e5:	89 cb                	mov    %ecx,%ebx
 5e7:	89 df                	mov    %ebx,%edi
 5e9:	89 d1                	mov    %edx,%ecx
 5eb:	fc                   	cld    
 5ec:	f3 aa                	rep stos %al,%es:(%edi)
 5ee:	89 ca                	mov    %ecx,%edx
 5f0:	89 fb                	mov    %edi,%ebx
 5f2:	89 5d 08             	mov    %ebx,0x8(%ebp)
 5f5:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 5f8:	5b                   	pop    %ebx
 5f9:	5f                   	pop    %edi
 5fa:	5d                   	pop    %ebp
 5fb:	c3                   	ret    

000005fc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 5fc:	55                   	push   %ebp
 5fd:	89 e5                	mov    %esp,%ebp
 5ff:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 602:	8b 45 08             	mov    0x8(%ebp),%eax
 605:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 608:	90                   	nop
 609:	8b 45 08             	mov    0x8(%ebp),%eax
 60c:	8d 50 01             	lea    0x1(%eax),%edx
 60f:	89 55 08             	mov    %edx,0x8(%ebp)
 612:	8b 55 0c             	mov    0xc(%ebp),%edx
 615:	8d 4a 01             	lea    0x1(%edx),%ecx
 618:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 61b:	0f b6 12             	movzbl (%edx),%edx
 61e:	88 10                	mov    %dl,(%eax)
 620:	0f b6 00             	movzbl (%eax),%eax
 623:	84 c0                	test   %al,%al
 625:	75 e2                	jne    609 <strcpy+0xd>
    ;
  return os;
 627:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 62a:	c9                   	leave  
 62b:	c3                   	ret    

0000062c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 62c:	55                   	push   %ebp
 62d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 62f:	eb 08                	jmp    639 <strcmp+0xd>
    p++, q++;
 631:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 635:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 639:	8b 45 08             	mov    0x8(%ebp),%eax
 63c:	0f b6 00             	movzbl (%eax),%eax
 63f:	84 c0                	test   %al,%al
 641:	74 10                	je     653 <strcmp+0x27>
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	0f b6 10             	movzbl (%eax),%edx
 649:	8b 45 0c             	mov    0xc(%ebp),%eax
 64c:	0f b6 00             	movzbl (%eax),%eax
 64f:	38 c2                	cmp    %al,%dl
 651:	74 de                	je     631 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 653:	8b 45 08             	mov    0x8(%ebp),%eax
 656:	0f b6 00             	movzbl (%eax),%eax
 659:	0f b6 d0             	movzbl %al,%edx
 65c:	8b 45 0c             	mov    0xc(%ebp),%eax
 65f:	0f b6 00             	movzbl (%eax),%eax
 662:	0f b6 c0             	movzbl %al,%eax
 665:	29 c2                	sub    %eax,%edx
 667:	89 d0                	mov    %edx,%eax
}
 669:	5d                   	pop    %ebp
 66a:	c3                   	ret    

0000066b <strlen>:

uint
strlen(char *s)
{
 66b:	55                   	push   %ebp
 66c:	89 e5                	mov    %esp,%ebp
 66e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 671:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 678:	eb 04                	jmp    67e <strlen+0x13>
 67a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 67e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 681:	8b 45 08             	mov    0x8(%ebp),%eax
 684:	01 d0                	add    %edx,%eax
 686:	0f b6 00             	movzbl (%eax),%eax
 689:	84 c0                	test   %al,%al
 68b:	75 ed                	jne    67a <strlen+0xf>
    ;
  return n;
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 690:	c9                   	leave  
 691:	c3                   	ret    

00000692 <memset>:

void*
memset(void *dst, int c, uint n)
{
 692:	55                   	push   %ebp
 693:	89 e5                	mov    %esp,%ebp
 695:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 698:	8b 45 10             	mov    0x10(%ebp),%eax
 69b:	89 44 24 08          	mov    %eax,0x8(%esp)
 69f:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a6:	8b 45 08             	mov    0x8(%ebp),%eax
 6a9:	89 04 24             	mov    %eax,(%esp)
 6ac:	e8 26 ff ff ff       	call   5d7 <stosb>
  return dst;
 6b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6b4:	c9                   	leave  
 6b5:	c3                   	ret    

000006b6 <strchr>:

char*
strchr(const char *s, char c)
{
 6b6:	55                   	push   %ebp
 6b7:	89 e5                	mov    %esp,%ebp
 6b9:	83 ec 04             	sub    $0x4,%esp
 6bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 6bf:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 6c2:	eb 14                	jmp    6d8 <strchr+0x22>
    if(*s == c)
 6c4:	8b 45 08             	mov    0x8(%ebp),%eax
 6c7:	0f b6 00             	movzbl (%eax),%eax
 6ca:	3a 45 fc             	cmp    -0x4(%ebp),%al
 6cd:	75 05                	jne    6d4 <strchr+0x1e>
      return (char*)s;
 6cf:	8b 45 08             	mov    0x8(%ebp),%eax
 6d2:	eb 13                	jmp    6e7 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 6d4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 6d8:	8b 45 08             	mov    0x8(%ebp),%eax
 6db:	0f b6 00             	movzbl (%eax),%eax
 6de:	84 c0                	test   %al,%al
 6e0:	75 e2                	jne    6c4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 6e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 6e7:	c9                   	leave  
 6e8:	c3                   	ret    

000006e9 <gets>:

char*
gets(char *buf, int max)
{
 6e9:	55                   	push   %ebp
 6ea:	89 e5                	mov    %esp,%ebp
 6ec:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 6f6:	eb 4c                	jmp    744 <gets+0x5b>
    cc = read(0, &c, 1);
 6f8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6ff:	00 
 700:	8d 45 ef             	lea    -0x11(%ebp),%eax
 703:	89 44 24 04          	mov    %eax,0x4(%esp)
 707:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 70e:	e8 44 01 00 00       	call   857 <read>
 713:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 716:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 71a:	7f 02                	jg     71e <gets+0x35>
      break;
 71c:	eb 31                	jmp    74f <gets+0x66>
    buf[i++] = c;
 71e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 721:	8d 50 01             	lea    0x1(%eax),%edx
 724:	89 55 f4             	mov    %edx,-0xc(%ebp)
 727:	89 c2                	mov    %eax,%edx
 729:	8b 45 08             	mov    0x8(%ebp),%eax
 72c:	01 c2                	add    %eax,%edx
 72e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 732:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 734:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 738:	3c 0a                	cmp    $0xa,%al
 73a:	74 13                	je     74f <gets+0x66>
 73c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 740:	3c 0d                	cmp    $0xd,%al
 742:	74 0b                	je     74f <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 744:	8b 45 f4             	mov    -0xc(%ebp),%eax
 747:	83 c0 01             	add    $0x1,%eax
 74a:	3b 45 0c             	cmp    0xc(%ebp),%eax
 74d:	7c a9                	jl     6f8 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 74f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 752:	8b 45 08             	mov    0x8(%ebp),%eax
 755:	01 d0                	add    %edx,%eax
 757:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 75a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 75d:	c9                   	leave  
 75e:	c3                   	ret    

0000075f <stat>:

int
stat(char *n, struct stat *st)
{
 75f:	55                   	push   %ebp
 760:	89 e5                	mov    %esp,%ebp
 762:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 765:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 76c:	00 
 76d:	8b 45 08             	mov    0x8(%ebp),%eax
 770:	89 04 24             	mov    %eax,(%esp)
 773:	e8 07 01 00 00       	call   87f <open>
 778:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 77b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 77f:	79 07                	jns    788 <stat+0x29>
    return -1;
 781:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 786:	eb 23                	jmp    7ab <stat+0x4c>
  r = fstat(fd, st);
 788:	8b 45 0c             	mov    0xc(%ebp),%eax
 78b:	89 44 24 04          	mov    %eax,0x4(%esp)
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	89 04 24             	mov    %eax,(%esp)
 795:	e8 fd 00 00 00       	call   897 <fstat>
 79a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 79d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a0:	89 04 24             	mov    %eax,(%esp)
 7a3:	e8 bf 00 00 00       	call   867 <close>
  return r;
 7a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7ab:	c9                   	leave  
 7ac:	c3                   	ret    

000007ad <atoi>:

int
atoi(const char *s)
{
 7ad:	55                   	push   %ebp
 7ae:	89 e5                	mov    %esp,%ebp
 7b0:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 7b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 7ba:	eb 25                	jmp    7e1 <atoi+0x34>
    n = n*10 + *s++ - '0';
 7bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7bf:	89 d0                	mov    %edx,%eax
 7c1:	c1 e0 02             	shl    $0x2,%eax
 7c4:	01 d0                	add    %edx,%eax
 7c6:	01 c0                	add    %eax,%eax
 7c8:	89 c1                	mov    %eax,%ecx
 7ca:	8b 45 08             	mov    0x8(%ebp),%eax
 7cd:	8d 50 01             	lea    0x1(%eax),%edx
 7d0:	89 55 08             	mov    %edx,0x8(%ebp)
 7d3:	0f b6 00             	movzbl (%eax),%eax
 7d6:	0f be c0             	movsbl %al,%eax
 7d9:	01 c8                	add    %ecx,%eax
 7db:	83 e8 30             	sub    $0x30,%eax
 7de:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7e1:	8b 45 08             	mov    0x8(%ebp),%eax
 7e4:	0f b6 00             	movzbl (%eax),%eax
 7e7:	3c 2f                	cmp    $0x2f,%al
 7e9:	7e 0a                	jle    7f5 <atoi+0x48>
 7eb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ee:	0f b6 00             	movzbl (%eax),%eax
 7f1:	3c 39                	cmp    $0x39,%al
 7f3:	7e c7                	jle    7bc <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 7f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7f8:	c9                   	leave  
 7f9:	c3                   	ret    

000007fa <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 7fa:	55                   	push   %ebp
 7fb:	89 e5                	mov    %esp,%ebp
 7fd:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 800:	8b 45 08             	mov    0x8(%ebp),%eax
 803:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 806:	8b 45 0c             	mov    0xc(%ebp),%eax
 809:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 80c:	eb 17                	jmp    825 <memmove+0x2b>
    *dst++ = *src++;
 80e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 811:	8d 50 01             	lea    0x1(%eax),%edx
 814:	89 55 fc             	mov    %edx,-0x4(%ebp)
 817:	8b 55 f8             	mov    -0x8(%ebp),%edx
 81a:	8d 4a 01             	lea    0x1(%edx),%ecx
 81d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 820:	0f b6 12             	movzbl (%edx),%edx
 823:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 825:	8b 45 10             	mov    0x10(%ebp),%eax
 828:	8d 50 ff             	lea    -0x1(%eax),%edx
 82b:	89 55 10             	mov    %edx,0x10(%ebp)
 82e:	85 c0                	test   %eax,%eax
 830:	7f dc                	jg     80e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 832:	8b 45 08             	mov    0x8(%ebp),%eax
}
 835:	c9                   	leave  
 836:	c3                   	ret    

00000837 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 837:	b8 01 00 00 00       	mov    $0x1,%eax
 83c:	cd 40                	int    $0x40
 83e:	c3                   	ret    

0000083f <exit>:
SYSCALL(exit)
 83f:	b8 02 00 00 00       	mov    $0x2,%eax
 844:	cd 40                	int    $0x40
 846:	c3                   	ret    

00000847 <wait>:
SYSCALL(wait)
 847:	b8 03 00 00 00       	mov    $0x3,%eax
 84c:	cd 40                	int    $0x40
 84e:	c3                   	ret    

0000084f <pipe>:
SYSCALL(pipe)
 84f:	b8 04 00 00 00       	mov    $0x4,%eax
 854:	cd 40                	int    $0x40
 856:	c3                   	ret    

00000857 <read>:
SYSCALL(read)
 857:	b8 05 00 00 00       	mov    $0x5,%eax
 85c:	cd 40                	int    $0x40
 85e:	c3                   	ret    

0000085f <write>:
SYSCALL(write)
 85f:	b8 10 00 00 00       	mov    $0x10,%eax
 864:	cd 40                	int    $0x40
 866:	c3                   	ret    

00000867 <close>:
SYSCALL(close)
 867:	b8 15 00 00 00       	mov    $0x15,%eax
 86c:	cd 40                	int    $0x40
 86e:	c3                   	ret    

0000086f <kill>:
SYSCALL(kill)
 86f:	b8 06 00 00 00       	mov    $0x6,%eax
 874:	cd 40                	int    $0x40
 876:	c3                   	ret    

00000877 <exec>:
SYSCALL(exec)
 877:	b8 07 00 00 00       	mov    $0x7,%eax
 87c:	cd 40                	int    $0x40
 87e:	c3                   	ret    

0000087f <open>:
SYSCALL(open)
 87f:	b8 0f 00 00 00       	mov    $0xf,%eax
 884:	cd 40                	int    $0x40
 886:	c3                   	ret    

00000887 <mknod>:
SYSCALL(mknod)
 887:	b8 11 00 00 00       	mov    $0x11,%eax
 88c:	cd 40                	int    $0x40
 88e:	c3                   	ret    

0000088f <unlink>:
SYSCALL(unlink)
 88f:	b8 12 00 00 00       	mov    $0x12,%eax
 894:	cd 40                	int    $0x40
 896:	c3                   	ret    

00000897 <fstat>:
SYSCALL(fstat)
 897:	b8 08 00 00 00       	mov    $0x8,%eax
 89c:	cd 40                	int    $0x40
 89e:	c3                   	ret    

0000089f <link>:
SYSCALL(link)
 89f:	b8 13 00 00 00       	mov    $0x13,%eax
 8a4:	cd 40                	int    $0x40
 8a6:	c3                   	ret    

000008a7 <mkdir>:
SYSCALL(mkdir)
 8a7:	b8 14 00 00 00       	mov    $0x14,%eax
 8ac:	cd 40                	int    $0x40
 8ae:	c3                   	ret    

000008af <chdir>:
SYSCALL(chdir)
 8af:	b8 09 00 00 00       	mov    $0x9,%eax
 8b4:	cd 40                	int    $0x40
 8b6:	c3                   	ret    

000008b7 <dup>:
SYSCALL(dup)
 8b7:	b8 0a 00 00 00       	mov    $0xa,%eax
 8bc:	cd 40                	int    $0x40
 8be:	c3                   	ret    

000008bf <getpid>:
SYSCALL(getpid)
 8bf:	b8 0b 00 00 00       	mov    $0xb,%eax
 8c4:	cd 40                	int    $0x40
 8c6:	c3                   	ret    

000008c7 <sbrk>:
SYSCALL(sbrk)
 8c7:	b8 0c 00 00 00       	mov    $0xc,%eax
 8cc:	cd 40                	int    $0x40
 8ce:	c3                   	ret    

000008cf <sleep>:
SYSCALL(sleep)
 8cf:	b8 0d 00 00 00       	mov    $0xd,%eax
 8d4:	cd 40                	int    $0x40
 8d6:	c3                   	ret    

000008d7 <uptime>:
SYSCALL(uptime)
 8d7:	b8 0e 00 00 00       	mov    $0xe,%eax
 8dc:	cd 40                	int    $0x40
 8de:	c3                   	ret    

000008df <changepriority>:
SYSCALL(changepriority)
 8df:	b8 16 00 00 00       	mov    $0x16,%eax
 8e4:	cd 40                	int    $0x40
 8e6:	c3                   	ret    

000008e7 <processstatus>:
SYSCALL(processstatus)
 8e7:	b8 17 00 00 00       	mov    $0x17,%eax
 8ec:	cd 40                	int    $0x40
 8ee:	c3                   	ret    

000008ef <randomgen>:
SYSCALL(randomgen)
 8ef:	b8 18 00 00 00       	mov    $0x18,%eax
 8f4:	cd 40                	int    $0x40
 8f6:	c3                   	ret    

000008f7 <randomgenrange>:
SYSCALL(randomgenrange)
 8f7:	b8 19 00 00 00       	mov    $0x19,%eax
 8fc:	cd 40                	int    $0x40
 8fe:	c3                   	ret    

000008ff <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 8ff:	55                   	push   %ebp
 900:	89 e5                	mov    %esp,%ebp
 902:	83 ec 18             	sub    $0x18,%esp
 905:	8b 45 0c             	mov    0xc(%ebp),%eax
 908:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 90b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 912:	00 
 913:	8d 45 f4             	lea    -0xc(%ebp),%eax
 916:	89 44 24 04          	mov    %eax,0x4(%esp)
 91a:	8b 45 08             	mov    0x8(%ebp),%eax
 91d:	89 04 24             	mov    %eax,(%esp)
 920:	e8 3a ff ff ff       	call   85f <write>
}
 925:	c9                   	leave  
 926:	c3                   	ret    

00000927 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 927:	55                   	push   %ebp
 928:	89 e5                	mov    %esp,%ebp
 92a:	56                   	push   %esi
 92b:	53                   	push   %ebx
 92c:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 92f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 936:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 93a:	74 17                	je     953 <printint+0x2c>
 93c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 940:	79 11                	jns    953 <printint+0x2c>
    neg = 1;
 942:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 949:	8b 45 0c             	mov    0xc(%ebp),%eax
 94c:	f7 d8                	neg    %eax
 94e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 951:	eb 06                	jmp    959 <printint+0x32>
  } else {
    x = xx;
 953:	8b 45 0c             	mov    0xc(%ebp),%eax
 956:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 959:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 960:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 963:	8d 41 01             	lea    0x1(%ecx),%eax
 966:	89 45 f4             	mov    %eax,-0xc(%ebp)
 969:	8b 5d 10             	mov    0x10(%ebp),%ebx
 96c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 96f:	ba 00 00 00 00       	mov    $0x0,%edx
 974:	f7 f3                	div    %ebx
 976:	89 d0                	mov    %edx,%eax
 978:	0f b6 80 ec 10 00 00 	movzbl 0x10ec(%eax),%eax
 97f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 983:	8b 75 10             	mov    0x10(%ebp),%esi
 986:	8b 45 ec             	mov    -0x14(%ebp),%eax
 989:	ba 00 00 00 00       	mov    $0x0,%edx
 98e:	f7 f6                	div    %esi
 990:	89 45 ec             	mov    %eax,-0x14(%ebp)
 993:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 997:	75 c7                	jne    960 <printint+0x39>
  if(neg)
 999:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 99d:	74 10                	je     9af <printint+0x88>
    buf[i++] = '-';
 99f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a2:	8d 50 01             	lea    0x1(%eax),%edx
 9a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9a8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 9ad:	eb 1f                	jmp    9ce <printint+0xa7>
 9af:	eb 1d                	jmp    9ce <printint+0xa7>
    putc(fd, buf[i]);
 9b1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 9b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b7:	01 d0                	add    %edx,%eax
 9b9:	0f b6 00             	movzbl (%eax),%eax
 9bc:	0f be c0             	movsbl %al,%eax
 9bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 9c3:	8b 45 08             	mov    0x8(%ebp),%eax
 9c6:	89 04 24             	mov    %eax,(%esp)
 9c9:	e8 31 ff ff ff       	call   8ff <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 9ce:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 9d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9d6:	79 d9                	jns    9b1 <printint+0x8a>
    putc(fd, buf[i]);
}
 9d8:	83 c4 30             	add    $0x30,%esp
 9db:	5b                   	pop    %ebx
 9dc:	5e                   	pop    %esi
 9dd:	5d                   	pop    %ebp
 9de:	c3                   	ret    

000009df <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 9df:	55                   	push   %ebp
 9e0:	89 e5                	mov    %esp,%ebp
 9e2:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 9e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 9ec:	8d 45 0c             	lea    0xc(%ebp),%eax
 9ef:	83 c0 04             	add    $0x4,%eax
 9f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 9f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 9fc:	e9 7c 01 00 00       	jmp    b7d <printf+0x19e>
    c = fmt[i] & 0xff;
 a01:	8b 55 0c             	mov    0xc(%ebp),%edx
 a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a07:	01 d0                	add    %edx,%eax
 a09:	0f b6 00             	movzbl (%eax),%eax
 a0c:	0f be c0             	movsbl %al,%eax
 a0f:	25 ff 00 00 00       	and    $0xff,%eax
 a14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a17:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a1b:	75 2c                	jne    a49 <printf+0x6a>
      if(c == '%'){
 a1d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a21:	75 0c                	jne    a2f <printf+0x50>
        state = '%';
 a23:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a2a:	e9 4a 01 00 00       	jmp    b79 <printf+0x19a>
      } else {
        putc(fd, c);
 a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a32:	0f be c0             	movsbl %al,%eax
 a35:	89 44 24 04          	mov    %eax,0x4(%esp)
 a39:	8b 45 08             	mov    0x8(%ebp),%eax
 a3c:	89 04 24             	mov    %eax,(%esp)
 a3f:	e8 bb fe ff ff       	call   8ff <putc>
 a44:	e9 30 01 00 00       	jmp    b79 <printf+0x19a>
      }
    } else if(state == '%'){
 a49:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a4d:	0f 85 26 01 00 00    	jne    b79 <printf+0x19a>
      if(c == 'd'){
 a53:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a57:	75 2d                	jne    a86 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 a59:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a5c:	8b 00                	mov    (%eax),%eax
 a5e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 a65:	00 
 a66:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 a6d:	00 
 a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
 a72:	8b 45 08             	mov    0x8(%ebp),%eax
 a75:	89 04 24             	mov    %eax,(%esp)
 a78:	e8 aa fe ff ff       	call   927 <printint>
        ap++;
 a7d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a81:	e9 ec 00 00 00       	jmp    b72 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 a86:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a8a:	74 06                	je     a92 <printf+0xb3>
 a8c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 a90:	75 2d                	jne    abf <printf+0xe0>
        printint(fd, *ap, 16, 0);
 a92:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a95:	8b 00                	mov    (%eax),%eax
 a97:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 a9e:	00 
 a9f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 aa6:	00 
 aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
 aab:	8b 45 08             	mov    0x8(%ebp),%eax
 aae:	89 04 24             	mov    %eax,(%esp)
 ab1:	e8 71 fe ff ff       	call   927 <printint>
        ap++;
 ab6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 aba:	e9 b3 00 00 00       	jmp    b72 <printf+0x193>
      } else if(c == 's'){
 abf:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 ac3:	75 45                	jne    b0a <printf+0x12b>
        s = (char*)*ap;
 ac5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ac8:	8b 00                	mov    (%eax),%eax
 aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 acd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 ad1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ad5:	75 09                	jne    ae0 <printf+0x101>
          s = "(null)";
 ad7:	c7 45 f4 f5 0d 00 00 	movl   $0xdf5,-0xc(%ebp)
        while(*s != 0){
 ade:	eb 1e                	jmp    afe <printf+0x11f>
 ae0:	eb 1c                	jmp    afe <printf+0x11f>
          putc(fd, *s);
 ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae5:	0f b6 00             	movzbl (%eax),%eax
 ae8:	0f be c0             	movsbl %al,%eax
 aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
 aef:	8b 45 08             	mov    0x8(%ebp),%eax
 af2:	89 04 24             	mov    %eax,(%esp)
 af5:	e8 05 fe ff ff       	call   8ff <putc>
          s++;
 afa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b01:	0f b6 00             	movzbl (%eax),%eax
 b04:	84 c0                	test   %al,%al
 b06:	75 da                	jne    ae2 <printf+0x103>
 b08:	eb 68                	jmp    b72 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b0a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b0e:	75 1d                	jne    b2d <printf+0x14e>
        putc(fd, *ap);
 b10:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b13:	8b 00                	mov    (%eax),%eax
 b15:	0f be c0             	movsbl %al,%eax
 b18:	89 44 24 04          	mov    %eax,0x4(%esp)
 b1c:	8b 45 08             	mov    0x8(%ebp),%eax
 b1f:	89 04 24             	mov    %eax,(%esp)
 b22:	e8 d8 fd ff ff       	call   8ff <putc>
        ap++;
 b27:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b2b:	eb 45                	jmp    b72 <printf+0x193>
      } else if(c == '%'){
 b2d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b31:	75 17                	jne    b4a <printf+0x16b>
        putc(fd, c);
 b33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b36:	0f be c0             	movsbl %al,%eax
 b39:	89 44 24 04          	mov    %eax,0x4(%esp)
 b3d:	8b 45 08             	mov    0x8(%ebp),%eax
 b40:	89 04 24             	mov    %eax,(%esp)
 b43:	e8 b7 fd ff ff       	call   8ff <putc>
 b48:	eb 28                	jmp    b72 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b4a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 b51:	00 
 b52:	8b 45 08             	mov    0x8(%ebp),%eax
 b55:	89 04 24             	mov    %eax,(%esp)
 b58:	e8 a2 fd ff ff       	call   8ff <putc>
        putc(fd, c);
 b5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b60:	0f be c0             	movsbl %al,%eax
 b63:	89 44 24 04          	mov    %eax,0x4(%esp)
 b67:	8b 45 08             	mov    0x8(%ebp),%eax
 b6a:	89 04 24             	mov    %eax,(%esp)
 b6d:	e8 8d fd ff ff       	call   8ff <putc>
      }
      state = 0;
 b72:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b79:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
 b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b83:	01 d0                	add    %edx,%eax
 b85:	0f b6 00             	movzbl (%eax),%eax
 b88:	84 c0                	test   %al,%al
 b8a:	0f 85 71 fe ff ff    	jne    a01 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 b90:	c9                   	leave  
 b91:	c3                   	ret    

00000b92 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b92:	55                   	push   %ebp
 b93:	89 e5                	mov    %esp,%ebp
 b95:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b98:	8b 45 08             	mov    0x8(%ebp),%eax
 b9b:	83 e8 08             	sub    $0x8,%eax
 b9e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ba1:	a1 0c 11 00 00       	mov    0x110c,%eax
 ba6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ba9:	eb 24                	jmp    bcf <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bae:	8b 00                	mov    (%eax),%eax
 bb0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bb3:	77 12                	ja     bc7 <free+0x35>
 bb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bb8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bbb:	77 24                	ja     be1 <free+0x4f>
 bbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bc0:	8b 00                	mov    (%eax),%eax
 bc2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bc5:	77 1a                	ja     be1 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bca:	8b 00                	mov    (%eax),%eax
 bcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 bcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bd2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bd5:	76 d4                	jbe    bab <free+0x19>
 bd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bda:	8b 00                	mov    (%eax),%eax
 bdc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bdf:	76 ca                	jbe    bab <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 be1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 be4:	8b 40 04             	mov    0x4(%eax),%eax
 be7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 bee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bf1:	01 c2                	add    %eax,%edx
 bf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf6:	8b 00                	mov    (%eax),%eax
 bf8:	39 c2                	cmp    %eax,%edx
 bfa:	75 24                	jne    c20 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 bfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bff:	8b 50 04             	mov    0x4(%eax),%edx
 c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c05:	8b 00                	mov    (%eax),%eax
 c07:	8b 40 04             	mov    0x4(%eax),%eax
 c0a:	01 c2                	add    %eax,%edx
 c0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c0f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c12:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c15:	8b 00                	mov    (%eax),%eax
 c17:	8b 10                	mov    (%eax),%edx
 c19:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c1c:	89 10                	mov    %edx,(%eax)
 c1e:	eb 0a                	jmp    c2a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c20:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c23:	8b 10                	mov    (%eax),%edx
 c25:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c28:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c2d:	8b 40 04             	mov    0x4(%eax),%eax
 c30:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c37:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c3a:	01 d0                	add    %edx,%eax
 c3c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c3f:	75 20                	jne    c61 <free+0xcf>
    p->s.size += bp->s.size;
 c41:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c44:	8b 50 04             	mov    0x4(%eax),%edx
 c47:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c4a:	8b 40 04             	mov    0x4(%eax),%eax
 c4d:	01 c2                	add    %eax,%edx
 c4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c52:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c55:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c58:	8b 10                	mov    (%eax),%edx
 c5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c5d:	89 10                	mov    %edx,(%eax)
 c5f:	eb 08                	jmp    c69 <free+0xd7>
  } else
    p->s.ptr = bp;
 c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c64:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c67:	89 10                	mov    %edx,(%eax)
  freep = p;
 c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c6c:	a3 0c 11 00 00       	mov    %eax,0x110c
}
 c71:	c9                   	leave  
 c72:	c3                   	ret    

00000c73 <morecore>:

static Header*
morecore(uint nu)
{
 c73:	55                   	push   %ebp
 c74:	89 e5                	mov    %esp,%ebp
 c76:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c79:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c80:	77 07                	ja     c89 <morecore+0x16>
    nu = 4096;
 c82:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c89:	8b 45 08             	mov    0x8(%ebp),%eax
 c8c:	c1 e0 03             	shl    $0x3,%eax
 c8f:	89 04 24             	mov    %eax,(%esp)
 c92:	e8 30 fc ff ff       	call   8c7 <sbrk>
 c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 c9a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 c9e:	75 07                	jne    ca7 <morecore+0x34>
    return 0;
 ca0:	b8 00 00 00 00       	mov    $0x0,%eax
 ca5:	eb 22                	jmp    cc9 <morecore+0x56>
  hp = (Header*)p;
 ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 caa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cb0:	8b 55 08             	mov    0x8(%ebp),%edx
 cb3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cb9:	83 c0 08             	add    $0x8,%eax
 cbc:	89 04 24             	mov    %eax,(%esp)
 cbf:	e8 ce fe ff ff       	call   b92 <free>
  return freep;
 cc4:	a1 0c 11 00 00       	mov    0x110c,%eax
}
 cc9:	c9                   	leave  
 cca:	c3                   	ret    

00000ccb <malloc>:

void*
malloc(uint nbytes)
{
 ccb:	55                   	push   %ebp
 ccc:	89 e5                	mov    %esp,%ebp
 cce:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cd1:	8b 45 08             	mov    0x8(%ebp),%eax
 cd4:	83 c0 07             	add    $0x7,%eax
 cd7:	c1 e8 03             	shr    $0x3,%eax
 cda:	83 c0 01             	add    $0x1,%eax
 cdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ce0:	a1 0c 11 00 00       	mov    0x110c,%eax
 ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ce8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 cec:	75 23                	jne    d11 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 cee:	c7 45 f0 04 11 00 00 	movl   $0x1104,-0x10(%ebp)
 cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cf8:	a3 0c 11 00 00       	mov    %eax,0x110c
 cfd:	a1 0c 11 00 00       	mov    0x110c,%eax
 d02:	a3 04 11 00 00       	mov    %eax,0x1104
    base.s.size = 0;
 d07:	c7 05 08 11 00 00 00 	movl   $0x0,0x1108
 d0e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d14:	8b 00                	mov    (%eax),%eax
 d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1c:	8b 40 04             	mov    0x4(%eax),%eax
 d1f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d22:	72 4d                	jb     d71 <malloc+0xa6>
      if(p->s.size == nunits)
 d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d27:	8b 40 04             	mov    0x4(%eax),%eax
 d2a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d2d:	75 0c                	jne    d3b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d32:	8b 10                	mov    (%eax),%edx
 d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d37:	89 10                	mov    %edx,(%eax)
 d39:	eb 26                	jmp    d61 <malloc+0x96>
      else {
        p->s.size -= nunits;
 d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d3e:	8b 40 04             	mov    0x4(%eax),%eax
 d41:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d44:	89 c2                	mov    %eax,%edx
 d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d49:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d4f:	8b 40 04             	mov    0x4(%eax),%eax
 d52:	c1 e0 03             	shl    $0x3,%eax
 d55:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d5e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d64:	a3 0c 11 00 00       	mov    %eax,0x110c
      return (void*)(p + 1);
 d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d6c:	83 c0 08             	add    $0x8,%eax
 d6f:	eb 38                	jmp    da9 <malloc+0xde>
    }
    if(p == freep)
 d71:	a1 0c 11 00 00       	mov    0x110c,%eax
 d76:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d79:	75 1b                	jne    d96 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d7e:	89 04 24             	mov    %eax,(%esp)
 d81:	e8 ed fe ff ff       	call   c73 <morecore>
 d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d8d:	75 07                	jne    d96 <malloc+0xcb>
        return 0;
 d8f:	b8 00 00 00 00       	mov    $0x0,%eax
 d94:	eb 13                	jmp    da9 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d99:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d9f:	8b 00                	mov    (%eax),%eax
 da1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 da4:	e9 70 ff ff ff       	jmp    d19 <malloc+0x4e>
}
 da9:	c9                   	leave  
 daa:	c3                   	ret    
