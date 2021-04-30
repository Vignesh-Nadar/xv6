
_uniq:     file format elf32-i386


Disassembly of section .text:

00000000 <get_line>:
 * 3: only print duplicate lines
 */
int output_format = 1;
int ignore_case = 0;

int get_line(char *line_ptr, int max, int fd) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
    memset(line_ptr, DEFAULT, MAX_BUF);
   6:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
   d:	00 
   e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  15:	00 
  16:	8b 45 08             	mov    0x8(%ebp),%eax
  19:	89 04 24             	mov    %eax,(%esp)
  1c:	e8 a4 06 00 00       	call   6c5 <memset>
//    int n;
    char *dst = line_ptr;
  21:	8b 45 08             	mov    0x8(%ebp),%eax
  24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((read(fd, buf, 1)) > 0) {
  27:	eb 45                	jmp    6e <get_line+0x6e>
        if (buf[0] == '\n') {
  29:	0f b6 05 80 11 00 00 	movzbl 0x1180,%eax
  30:	3c 0a                	cmp    $0xa,%al
  32:	75 14                	jne    48 <get_line+0x48>
            *dst++ = buf[0];
  34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  37:	8d 50 01             	lea    0x1(%eax),%edx
  3a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  3d:	0f b6 15 80 11 00 00 	movzbl 0x1180,%edx
  44:	88 10                	mov    %dl,(%eax)
            break;
  46:	eb 45                	jmp    8d <get_line+0x8d>
        } else {
            *dst++ = buf[0];
  48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4b:	8d 50 01             	lea    0x1(%eax),%edx
  4e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  51:	0f b6 15 80 11 00 00 	movzbl 0x1180,%edx
  58:	88 10                	mov    %dl,(%eax)
            if ((dst - line_ptr) + 1 > max) {
  5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  5d:	8b 45 08             	mov    0x8(%ebp),%eax
  60:	29 c2                	sub    %eax,%edx
  62:	89 d0                	mov    %edx,%eax
  64:	83 c0 01             	add    $0x1,%eax
  67:	3b 45 0c             	cmp    0xc(%ebp),%eax
  6a:	7e 02                	jle    6e <get_line+0x6e>
                break;
  6c:	eb 1f                	jmp    8d <get_line+0x8d>

int get_line(char *line_ptr, int max, int fd) {
    memset(line_ptr, DEFAULT, MAX_BUF);
//    int n;
    char *dst = line_ptr;
    while ((read(fd, buf, 1)) > 0) {
  6e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  75:	00 
  76:	c7 44 24 04 80 11 00 	movl   $0x1180,0x4(%esp)
  7d:	00 
  7e:	8b 45 10             	mov    0x10(%ebp),%eax
  81:	89 04 24             	mov    %eax,(%esp)
  84:	e8 01 08 00 00       	call   88a <read>
  89:	85 c0                	test   %eax,%eax
  8b:	7f 9c                	jg     29 <get_line+0x29>
            }
        }

    }
    // If the last line doesn't have `\n`, add it manually
    if (*(dst - 1) != '\n') *dst = '\n';
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	83 e8 01             	sub    $0x1,%eax
  93:	0f b6 00             	movzbl (%eax),%eax
  96:	3c 0a                	cmp    $0xa,%al
  98:	74 06                	je     a0 <get_line+0xa0>
  9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  9d:	c6 00 0a             	movb   $0xa,(%eax)
    return dst - line_ptr;
  a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	29 c2                	sub    %eax,%edx
  a8:	89 d0                	mov    %edx,%eax
}
  aa:	c9                   	leave  
  ab:	c3                   	ret    

000000ac <tolower>:

uchar tolower(uchar ch) {
  ac:	55                   	push   %ebp
  ad:	89 e5                	mov    %esp,%ebp
  af:	83 ec 04             	sub    $0x4,%esp
  b2:	8b 45 08             	mov    0x8(%ebp),%eax
  b5:	88 45 fc             	mov    %al,-0x4(%ebp)
    if (ch >= 'A' && ch <= 'Z')
  b8:	80 7d fc 40          	cmpb   $0x40,-0x4(%ebp)
  bc:	76 0a                	jbe    c8 <tolower+0x1c>
  be:	80 7d fc 5a          	cmpb   $0x5a,-0x4(%ebp)
  c2:	77 04                	ja     c8 <tolower+0x1c>
        ch = 'a' + (ch - 'A');
  c4:	80 45 fc 20          	addb   $0x20,-0x4(%ebp)
    return ch;
  c8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
}
  cc:	c9                   	leave  
  cd:	c3                   	ret    

000000ce <strcicmp>:
 *  Comprea two case-insensentive strings
 * @param p
 * @param q
 * @return
 */
int strcicmp(const char *p, const char *q) {
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  d1:	53                   	push   %ebx
  d2:	83 ec 04             	sub    $0x4,%esp
    while (*p && tolower(*p) == tolower(*q))
  d5:	eb 08                	jmp    df <strcicmp+0x11>
        p++, q++;
  d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  db:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * @param p
 * @param q
 * @return
 */
int strcicmp(const char *p, const char *q) {
    while (*p && tolower(*p) == tolower(*q))
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 00             	movzbl (%eax),%eax
  e5:	84 c0                	test   %al,%al
  e7:	74 28                	je     111 <strcicmp+0x43>
  e9:	8b 45 08             	mov    0x8(%ebp),%eax
  ec:	0f b6 00             	movzbl (%eax),%eax
  ef:	0f b6 c0             	movzbl %al,%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 b2 ff ff ff       	call   ac <tolower>
  fa:	89 c3                	mov    %eax,%ebx
  fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  ff:	0f b6 00             	movzbl (%eax),%eax
 102:	0f b6 c0             	movzbl %al,%eax
 105:	89 04 24             	mov    %eax,(%esp)
 108:	e8 9f ff ff ff       	call   ac <tolower>
 10d:	38 c3                	cmp    %al,%bl
 10f:	74 c6                	je     d7 <strcicmp+0x9>
        p++, q++;
    return (uchar) *p - (uchar) *q;
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	0f b6 00             	movzbl (%eax),%eax
 117:	0f b6 d0             	movzbl %al,%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	0f b6 00             	movzbl (%eax),%eax
 120:	0f b6 c0             	movzbl %al,%eax
 123:	29 c2                	sub    %eax,%edx
 125:	89 d0                	mov    %edx,%eax
}
 127:	83 c4 04             	add    $0x4,%esp
 12a:	5b                   	pop    %ebx
 12b:	5d                   	pop    %ebp
 12c:	c3                   	ret    

0000012d <output>:

void output(int stdout, char *line, int count, int has_prefix) {
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	83 ec 18             	sub    $0x18,%esp
    if (has_prefix) {
 133:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 137:	74 23                	je     15c <output+0x2f>
        printf(stdout, "%d %s", count, line);
 139:	8b 45 0c             	mov    0xc(%ebp),%eax
 13c:	89 44 24 0c          	mov    %eax,0xc(%esp)
 140:	8b 45 10             	mov    0x10(%ebp),%eax
 143:	89 44 24 08          	mov    %eax,0x8(%esp)
 147:	c7 44 24 04 de 0d 00 	movl   $0xdde,0x4(%esp)
 14e:	00 
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	89 04 24             	mov    %eax,(%esp)
 155:	e8 b8 08 00 00       	call   a12 <printf>
 15a:	eb 1a                	jmp    176 <output+0x49>
    } else {
        printf(stdout, "%s", line);
 15c:	8b 45 0c             	mov    0xc(%ebp),%eax
 15f:	89 44 24 08          	mov    %eax,0x8(%esp)
 163:	c7 44 24 04 e4 0d 00 	movl   $0xde4,0x4(%esp)
 16a:	00 
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	89 04 24             	mov    %eax,(%esp)
 171:	e8 9c 08 00 00       	call   a12 <printf>
    }
}
 176:	c9                   	leave  
 177:	c3                   	ret    

00000178 <uniq>:

void uniq(int fd) {
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	83 ec 38             	sub    $0x38,%esp
    char *prev = NULL, *cur = NULL;
 17e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 185:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char *line_ptr = (char *) malloc(MAX_BUF * sizeof(char));
 18c:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
 193:	e8 66 0b 00 00       	call   cfe <malloc>
 198:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    int count = 0;
 19b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while ((get_line(line_ptr, MAX_BUF, fd)) > 0) {
 1a2:	e9 cc 01 00 00       	jmp    373 <uniq+0x1fb>
        if (prev == NULL) {
 1a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ab:	0f 85 8e 00 00 00    	jne    23f <uniq+0xc7>
            prev = (char *) malloc(MAX_BUF * sizeof(char));
 1b1:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
 1b8:	e8 41 0b 00 00       	call   cfe <malloc>
 1bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
            cur = (char *) malloc(MAX_BUF * sizeof(char));
 1c0:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
 1c7:	e8 32 0b 00 00       	call   cfe <malloc>
 1cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
            memmove(prev, line_ptr, MAX_BUF);
 1cf:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 1d6:	00 
 1d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1da:	89 44 24 04          	mov    %eax,0x4(%esp)
 1de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e1:	89 04 24             	mov    %eax,(%esp)
 1e4:	e8 44 06 00 00       	call   82d <memmove>
            memmove(cur, line_ptr, MAX_BUF);
 1e9:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 1f0:	00 
 1f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1fb:	89 04 24             	mov    %eax,(%esp)
 1fe:	e8 2a 06 00 00       	call   82d <memmove>
            count = 1;
 203:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
            if (output_format == 1) {
 20a:	a1 30 11 00 00       	mov    0x1130,%eax
 20f:	83 f8 01             	cmp    $0x1,%eax
 212:	0f 85 41 01 00 00    	jne    359 <uniq+0x1e1>
                output(1, cur, count, 0);
 218:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 21f:	00 
 220:	8b 45 ec             	mov    -0x14(%ebp),%eax
 223:	89 44 24 08          	mov    %eax,0x8(%esp)
 227:	8b 45 f0             	mov    -0x10(%ebp),%eax
 22a:	89 44 24 04          	mov    %eax,0x4(%esp)
 22e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 235:	e8 f3 fe ff ff       	call   12d <output>
 23a:	e9 1a 01 00 00       	jmp    359 <uniq+0x1e1>
            }
        } else {
            memmove(cur, line_ptr, MAX_BUF);
 23f:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 246:	00 
 247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 24a:	89 44 24 04          	mov    %eax,0x4(%esp)
 24e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 251:	89 04 24             	mov    %eax,(%esp)
 254:	e8 d4 05 00 00       	call   82d <memmove>
            int cmp_result;
            if (ignore_case) {
 259:	a1 60 11 00 00       	mov    0x1160,%eax
 25e:	85 c0                	test   %eax,%eax
 260:	74 17                	je     279 <uniq+0x101>
                cmp_result = strcicmp(cur, prev);
 262:	8b 45 f4             	mov    -0xc(%ebp),%eax
 265:	89 44 24 04          	mov    %eax,0x4(%esp)
 269:	8b 45 f0             	mov    -0x10(%ebp),%eax
 26c:	89 04 24             	mov    %eax,(%esp)
 26f:	e8 5a fe ff ff       	call   ce <strcicmp>
 274:	89 45 e8             	mov    %eax,-0x18(%ebp)
 277:	eb 15                	jmp    28e <uniq+0x116>
            } else {
                cmp_result = strcmp(cur, prev);
 279:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27c:	89 44 24 04          	mov    %eax,0x4(%esp)
 280:	8b 45 f0             	mov    -0x10(%ebp),%eax
 283:	89 04 24             	mov    %eax,(%esp)
 286:	e8 d4 03 00 00       	call   65f <strcmp>
 28b:	89 45 e8             	mov    %eax,-0x18(%ebp)
            }
            if (cmp_result == 0) {
 28e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 292:	75 30                	jne    2c4 <uniq+0x14c>
                count++;
 294:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
                if (ignore_case) {
 298:	a1 60 11 00 00       	mov    0x1160,%eax
 29d:	85 c0                	test   %eax,%eax
 29f:	0f 84 b4 00 00 00    	je     359 <uniq+0x1e1>
                    memmove(cur, prev, MAX_BUF);
 2a5:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 2ac:	00 
 2ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2b7:	89 04 24             	mov    %eax,(%esp)
 2ba:	e8 6e 05 00 00       	call   82d <memmove>
 2bf:	e9 95 00 00 00       	jmp    359 <uniq+0x1e1>
                }
            } else {
                if (output_format == 1) {
 2c4:	a1 30 11 00 00       	mov    0x1130,%eax
 2c9:	83 f8 01             	cmp    $0x1,%eax
 2cc:	75 24                	jne    2f2 <uniq+0x17a>
                    output(1, cur, count, 0);
 2ce:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 2d5:	00 
 2d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 2d9:	89 44 24 08          	mov    %eax,0x8(%esp)
 2dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2eb:	e8 3d fe ff ff       	call   12d <output>
 2f0:	eb 60                	jmp    352 <uniq+0x1da>
                } else if (output_format == 3 && count > 1) {
 2f2:	a1 30 11 00 00       	mov    0x1130,%eax
 2f7:	83 f8 03             	cmp    $0x3,%eax
 2fa:	75 2a                	jne    326 <uniq+0x1ae>
 2fc:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 300:	7e 24                	jle    326 <uniq+0x1ae>
                    output(1, prev, count, 0);
 302:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 309:	00 
 30a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 30d:	89 44 24 08          	mov    %eax,0x8(%esp)
 311:	8b 45 f4             	mov    -0xc(%ebp),%eax
 314:	89 44 24 04          	mov    %eax,0x4(%esp)
 318:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 31f:	e8 09 fe ff ff       	call   12d <output>
 324:	eb 2c                	jmp    352 <uniq+0x1da>
                } else if (output_format == 2) {
 326:	a1 30 11 00 00       	mov    0x1130,%eax
 32b:	83 f8 02             	cmp    $0x2,%eax
 32e:	75 22                	jne    352 <uniq+0x1da>
                    output(1, prev, count, 1);
 330:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 337:	00 
 338:	8b 45 ec             	mov    -0x14(%ebp),%eax
 33b:	89 44 24 08          	mov    %eax,0x8(%esp)
 33f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 342:	89 44 24 04          	mov    %eax,0x4(%esp)
 346:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 34d:	e8 db fd ff ff       	call   12d <output>
                }
                count = 1;
 352:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
            }
        }
        memmove(prev, cur, MAX_BUF);
 359:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 360:	00 
 361:	8b 45 f0             	mov    -0x10(%ebp),%eax
 364:	89 44 24 04          	mov    %eax,0x4(%esp)
 368:	8b 45 f4             	mov    -0xc(%ebp),%eax
 36b:	89 04 24             	mov    %eax,(%esp)
 36e:	e8 ba 04 00 00       	call   82d <memmove>

void uniq(int fd) {
    char *prev = NULL, *cur = NULL;
    char *line_ptr = (char *) malloc(MAX_BUF * sizeof(char));
    int count = 0;
    while ((get_line(line_ptr, MAX_BUF, fd)) > 0) {
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	89 44 24 08          	mov    %eax,0x8(%esp)
 37a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
 381:	00 
 382:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 385:	89 04 24             	mov    %eax,(%esp)
 388:	e8 73 fc ff ff       	call   0 <get_line>
 38d:	85 c0                	test   %eax,%eax
 38f:	0f 8f 12 fe ff ff    	jg     1a7 <uniq+0x2f>
                count = 1;
            }
        }
        memmove(prev, cur, MAX_BUF);
    }
    if ((output_format == 3 && count > 1)) {
 395:	a1 30 11 00 00       	mov    0x1130,%eax
 39a:	83 f8 03             	cmp    $0x3,%eax
 39d:	75 2a                	jne    3c9 <uniq+0x251>
 39f:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 3a3:	7e 24                	jle    3c9 <uniq+0x251>
        output(1, cur, count, 0);
 3a5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 3ac:	00 
 3ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b0:	89 44 24 08          	mov    %eax,0x8(%esp)
 3b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 3bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3c2:	e8 66 fd ff ff       	call   12d <output>
 3c7:	eb 2c                	jmp    3f5 <uniq+0x27d>
    } else if (output_format == 2) {
 3c9:	a1 30 11 00 00       	mov    0x1130,%eax
 3ce:	83 f8 02             	cmp    $0x2,%eax
 3d1:	75 22                	jne    3f5 <uniq+0x27d>
        output(1, cur, count, 1);
 3d3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 3da:	00 
 3db:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3de:	89 44 24 08          	mov    %eax,0x8(%esp)
 3e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 3e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3f0:	e8 38 fd ff ff       	call   12d <output>
    }
    free(prev);
 3f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f8:	89 04 24             	mov    %eax,(%esp)
 3fb:	e8 c5 07 00 00       	call   bc5 <free>
    free(cur);
 400:	8b 45 f0             	mov    -0x10(%ebp),%eax
 403:	89 04 24             	mov    %eax,(%esp)
 406:	e8 ba 07 00 00       	call   bc5 <free>
    free(line_ptr);
 40b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 40e:	89 04 24             	mov    %eax,(%esp)
 411:	e8 af 07 00 00       	call   bc5 <free>
}
 416:	c9                   	leave  
 417:	c3                   	ret    

00000418 <get_next_opt>:
 * @return
 *      -1: reach the end
 *      -2: invalid option
 *      others: ASCII
 */
int get_next_opt(int argc, char *argv[], char *opts) {
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	83 ec 28             	sub    $0x28,%esp
    if (argidx >= argc - 1) {
 41e:	8b 45 08             	mov    0x8(%ebp),%eax
 421:	8d 50 ff             	lea    -0x1(%eax),%edx
 424:	a1 2c 11 00 00       	mov    0x112c,%eax
 429:	39 c2                	cmp    %eax,%edx
 42b:	7f 07                	jg     434 <get_next_opt+0x1c>
        return -1;
 42d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 432:	eb 7a                	jmp    4ae <get_next_opt+0x96>
    }
    char *arg = argv[argidx];
 434:	a1 2c 11 00 00       	mov    0x112c,%eax
 439:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 440:	8b 45 0c             	mov    0xc(%ebp),%eax
 443:	01 d0                	add    %edx,%eax
 445:	8b 00                	mov    (%eax),%eax
 447:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (arg[0] != '-' || (strchr(opts, arg[1]) == 0)) {
 44a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44d:	0f b6 00             	movzbl (%eax),%eax
 450:	3c 2d                	cmp    $0x2d,%al
 452:	75 1f                	jne    473 <get_next_opt+0x5b>
 454:	8b 45 f4             	mov    -0xc(%ebp),%eax
 457:	83 c0 01             	add    $0x1,%eax
 45a:	0f b6 00             	movzbl (%eax),%eax
 45d:	0f be c0             	movsbl %al,%eax
 460:	89 44 24 04          	mov    %eax,0x4(%esp)
 464:	8b 45 10             	mov    0x10(%ebp),%eax
 467:	89 04 24             	mov    %eax,(%esp)
 46a:	e8 7a 02 00 00       	call   6e9 <strchr>
 46f:	85 c0                	test   %eax,%eax
 471:	75 22                	jne    495 <get_next_opt+0x7d>
        printf(1, "uniq: invalid option %s\n", arg);
 473:	8b 45 f4             	mov    -0xc(%ebp),%eax
 476:	89 44 24 08          	mov    %eax,0x8(%esp)
 47a:	c7 44 24 04 e7 0d 00 	movl   $0xde7,0x4(%esp)
 481:	00 
 482:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 489:	e8 84 05 00 00       	call   a12 <printf>
        return -2;
 48e:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
 493:	eb 19                	jmp    4ae <get_next_opt+0x96>
    } else {
        argidx++;
 495:	a1 2c 11 00 00       	mov    0x112c,%eax
 49a:	83 c0 01             	add    $0x1,%eax
 49d:	a3 2c 11 00 00       	mov    %eax,0x112c
        return arg[1];
 4a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a5:	83 c0 01             	add    $0x1,%eax
 4a8:	0f b6 00             	movzbl (%eax),%eax
 4ab:	0f be c0             	movsbl %al,%eax
    }
}
 4ae:	c9                   	leave  
 4af:	c3                   	ret    

000004b0 <main>:


int main(int argc, char *argv[]) {
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	83 e4 f0             	and    $0xfffffff0,%esp
 4b6:	83 ec 20             	sub    $0x20,%esp
    int fd;
    int c;
    char *options = "cdi";
 4b9:	c7 44 24 1c 00 0e 00 	movl   $0xe00,0x1c(%esp)
 4c0:	00 
    if (argc <= 1) {
 4c1:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 4c5:	7f 11                	jg     4d8 <main+0x28>
        uniq(0);
 4c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4ce:	e8 a5 fc ff ff       	call   178 <uniq>
        exit();
 4d3:	e8 9a 03 00 00       	call   872 <exit>
    } else if (argc == 2) {
 4d8:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 4dc:	75 59                	jne    537 <main+0x87>
        if ((fd = open(argv[1], 0)) < 0) {
 4de:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e1:	83 c0 04             	add    $0x4,%eax
 4e4:	8b 00                	mov    (%eax),%eax
 4e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4ed:	00 
 4ee:	89 04 24             	mov    %eax,(%esp)
 4f1:	e8 bc 03 00 00       	call   8b2 <open>
 4f6:	89 44 24 18          	mov    %eax,0x18(%esp)
 4fa:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 4ff:	79 25                	jns    526 <main+0x76>
            printf(1, "uniq: cannot open %s\n", argv[1]);
 501:	8b 45 0c             	mov    0xc(%ebp),%eax
 504:	83 c0 04             	add    $0x4,%eax
 507:	8b 00                	mov    (%eax),%eax
 509:	89 44 24 08          	mov    %eax,0x8(%esp)
 50d:	c7 44 24 04 04 0e 00 	movl   $0xe04,0x4(%esp)
 514:	00 
 515:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 51c:	e8 f1 04 00 00       	call   a12 <printf>
            exit();
 521:	e8 4c 03 00 00       	call   872 <exit>
        }
        uniq(fd);
 526:	8b 44 24 18          	mov    0x18(%esp),%eax
 52a:	89 04 24             	mov    %eax,(%esp)
 52d:	e8 46 fc ff ff       	call   178 <uniq>
        exit();
 532:	e8 3b 03 00 00       	call   872 <exit>
    } else if (argc >= 3) {
 537:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 53b:	0f 8e c4 00 00 00    	jle    605 <main+0x155>
        while ((c = get_next_opt(argc, argv, options)) > 0) {
 541:	eb 36                	jmp    579 <main+0xc9>
            switch (c) {
 543:	8b 44 24 14          	mov    0x14(%esp),%eax
 547:	83 f8 64             	cmp    $0x64,%eax
 54a:	74 16                	je     562 <main+0xb2>
 54c:	83 f8 69             	cmp    $0x69,%eax
 54f:	74 1d                	je     56e <main+0xbe>
 551:	83 f8 63             	cmp    $0x63,%eax
 554:	75 23                	jne    579 <main+0xc9>
                case 'c':
                    output_format = 2;
 556:	c7 05 30 11 00 00 02 	movl   $0x2,0x1130
 55d:	00 00 00 
                    break;
 560:	eb 17                	jmp    579 <main+0xc9>
                case 'd':
                    output_format = 3;
 562:	c7 05 30 11 00 00 03 	movl   $0x3,0x1130
 569:	00 00 00 
                    break;
 56c:	eb 0b                	jmp    579 <main+0xc9>
                case 'i':
                    ignore_case = 1;
 56e:	c7 05 60 11 00 00 01 	movl   $0x1,0x1160
 575:	00 00 00 
                    break;
 578:	90                   	nop
            exit();
        }
        uniq(fd);
        exit();
    } else if (argc >= 3) {
        while ((c = get_next_opt(argc, argv, options)) > 0) {
 579:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 57d:	89 44 24 08          	mov    %eax,0x8(%esp)
 581:	8b 45 0c             	mov    0xc(%ebp),%eax
 584:	89 44 24 04          	mov    %eax,0x4(%esp)
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	89 04 24             	mov    %eax,(%esp)
 58e:	e8 85 fe ff ff       	call   418 <get_next_opt>
 593:	89 44 24 14          	mov    %eax,0x14(%esp)
 597:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 59c:	7f a5                	jg     543 <main+0x93>
                case 'i':
                    ignore_case = 1;
                    break;
            }
        }
        if ((fd = open(argv[argc - 1], 0)) < 0) {
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
 5a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 5ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b0:	01 d0                	add    %edx,%eax
 5b2:	8b 00                	mov    (%eax),%eax
 5b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 5bb:	00 
 5bc:	89 04 24             	mov    %eax,(%esp)
 5bf:	e8 ee 02 00 00       	call   8b2 <open>
 5c4:	89 44 24 18          	mov    %eax,0x18(%esp)
 5c8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 5cd:	79 25                	jns    5f4 <main+0x144>
            printf(1, "uniq: cannot open %s\n", argv[1]);
 5cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d2:	83 c0 04             	add    $0x4,%eax
 5d5:	8b 00                	mov    (%eax),%eax
 5d7:	89 44 24 08          	mov    %eax,0x8(%esp)
 5db:	c7 44 24 04 04 0e 00 	movl   $0xe04,0x4(%esp)
 5e2:	00 
 5e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5ea:	e8 23 04 00 00       	call   a12 <printf>
            exit();
 5ef:	e8 7e 02 00 00       	call   872 <exit>
        }
        uniq(fd);
 5f4:	8b 44 24 18          	mov    0x18(%esp),%eax
 5f8:	89 04 24             	mov    %eax,(%esp)
 5fb:	e8 78 fb ff ff       	call   178 <uniq>
        exit();
 600:	e8 6d 02 00 00       	call   872 <exit>
    }
    exit();
 605:	e8 68 02 00 00       	call   872 <exit>

0000060a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 60a:	55                   	push   %ebp
 60b:	89 e5                	mov    %esp,%ebp
 60d:	57                   	push   %edi
 60e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 60f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 612:	8b 55 10             	mov    0x10(%ebp),%edx
 615:	8b 45 0c             	mov    0xc(%ebp),%eax
 618:	89 cb                	mov    %ecx,%ebx
 61a:	89 df                	mov    %ebx,%edi
 61c:	89 d1                	mov    %edx,%ecx
 61e:	fc                   	cld    
 61f:	f3 aa                	rep stos %al,%es:(%edi)
 621:	89 ca                	mov    %ecx,%edx
 623:	89 fb                	mov    %edi,%ebx
 625:	89 5d 08             	mov    %ebx,0x8(%ebp)
 628:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 62b:	5b                   	pop    %ebx
 62c:	5f                   	pop    %edi
 62d:	5d                   	pop    %ebp
 62e:	c3                   	ret    

0000062f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 62f:	55                   	push   %ebp
 630:	89 e5                	mov    %esp,%ebp
 632:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 63b:	90                   	nop
 63c:	8b 45 08             	mov    0x8(%ebp),%eax
 63f:	8d 50 01             	lea    0x1(%eax),%edx
 642:	89 55 08             	mov    %edx,0x8(%ebp)
 645:	8b 55 0c             	mov    0xc(%ebp),%edx
 648:	8d 4a 01             	lea    0x1(%edx),%ecx
 64b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 64e:	0f b6 12             	movzbl (%edx),%edx
 651:	88 10                	mov    %dl,(%eax)
 653:	0f b6 00             	movzbl (%eax),%eax
 656:	84 c0                	test   %al,%al
 658:	75 e2                	jne    63c <strcpy+0xd>
    ;
  return os;
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 65d:	c9                   	leave  
 65e:	c3                   	ret    

0000065f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 65f:	55                   	push   %ebp
 660:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 662:	eb 08                	jmp    66c <strcmp+0xd>
    p++, q++;
 664:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 668:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 66c:	8b 45 08             	mov    0x8(%ebp),%eax
 66f:	0f b6 00             	movzbl (%eax),%eax
 672:	84 c0                	test   %al,%al
 674:	74 10                	je     686 <strcmp+0x27>
 676:	8b 45 08             	mov    0x8(%ebp),%eax
 679:	0f b6 10             	movzbl (%eax),%edx
 67c:	8b 45 0c             	mov    0xc(%ebp),%eax
 67f:	0f b6 00             	movzbl (%eax),%eax
 682:	38 c2                	cmp    %al,%dl
 684:	74 de                	je     664 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 686:	8b 45 08             	mov    0x8(%ebp),%eax
 689:	0f b6 00             	movzbl (%eax),%eax
 68c:	0f b6 d0             	movzbl %al,%edx
 68f:	8b 45 0c             	mov    0xc(%ebp),%eax
 692:	0f b6 00             	movzbl (%eax),%eax
 695:	0f b6 c0             	movzbl %al,%eax
 698:	29 c2                	sub    %eax,%edx
 69a:	89 d0                	mov    %edx,%eax
}
 69c:	5d                   	pop    %ebp
 69d:	c3                   	ret    

0000069e <strlen>:

uint
strlen(char *s)
{
 69e:	55                   	push   %ebp
 69f:	89 e5                	mov    %esp,%ebp
 6a1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 6a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 6ab:	eb 04                	jmp    6b1 <strlen+0x13>
 6ad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 6b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6b4:	8b 45 08             	mov    0x8(%ebp),%eax
 6b7:	01 d0                	add    %edx,%eax
 6b9:	0f b6 00             	movzbl (%eax),%eax
 6bc:	84 c0                	test   %al,%al
 6be:	75 ed                	jne    6ad <strlen+0xf>
    ;
  return n;
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6c3:	c9                   	leave  
 6c4:	c3                   	ret    

000006c5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 6c5:	55                   	push   %ebp
 6c6:	89 e5                	mov    %esp,%ebp
 6c8:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 6cb:	8b 45 10             	mov    0x10(%ebp),%eax
 6ce:	89 44 24 08          	mov    %eax,0x8(%esp)
 6d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
 6dc:	89 04 24             	mov    %eax,(%esp)
 6df:	e8 26 ff ff ff       	call   60a <stosb>
  return dst;
 6e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6e7:	c9                   	leave  
 6e8:	c3                   	ret    

000006e9 <strchr>:

char*
strchr(const char *s, char c)
{
 6e9:	55                   	push   %ebp
 6ea:	89 e5                	mov    %esp,%ebp
 6ec:	83 ec 04             	sub    $0x4,%esp
 6ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 6f5:	eb 14                	jmp    70b <strchr+0x22>
    if(*s == c)
 6f7:	8b 45 08             	mov    0x8(%ebp),%eax
 6fa:	0f b6 00             	movzbl (%eax),%eax
 6fd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 700:	75 05                	jne    707 <strchr+0x1e>
      return (char*)s;
 702:	8b 45 08             	mov    0x8(%ebp),%eax
 705:	eb 13                	jmp    71a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 707:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 70b:	8b 45 08             	mov    0x8(%ebp),%eax
 70e:	0f b6 00             	movzbl (%eax),%eax
 711:	84 c0                	test   %al,%al
 713:	75 e2                	jne    6f7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 715:	b8 00 00 00 00       	mov    $0x0,%eax
}
 71a:	c9                   	leave  
 71b:	c3                   	ret    

0000071c <gets>:

char*
gets(char *buf, int max)
{
 71c:	55                   	push   %ebp
 71d:	89 e5                	mov    %esp,%ebp
 71f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 722:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 729:	eb 4c                	jmp    777 <gets+0x5b>
    cc = read(0, &c, 1);
 72b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 732:	00 
 733:	8d 45 ef             	lea    -0x11(%ebp),%eax
 736:	89 44 24 04          	mov    %eax,0x4(%esp)
 73a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 741:	e8 44 01 00 00       	call   88a <read>
 746:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 749:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74d:	7f 02                	jg     751 <gets+0x35>
      break;
 74f:	eb 31                	jmp    782 <gets+0x66>
    buf[i++] = c;
 751:	8b 45 f4             	mov    -0xc(%ebp),%eax
 754:	8d 50 01             	lea    0x1(%eax),%edx
 757:	89 55 f4             	mov    %edx,-0xc(%ebp)
 75a:	89 c2                	mov    %eax,%edx
 75c:	8b 45 08             	mov    0x8(%ebp),%eax
 75f:	01 c2                	add    %eax,%edx
 761:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 765:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 767:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 76b:	3c 0a                	cmp    $0xa,%al
 76d:	74 13                	je     782 <gets+0x66>
 76f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 773:	3c 0d                	cmp    $0xd,%al
 775:	74 0b                	je     782 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 777:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77a:	83 c0 01             	add    $0x1,%eax
 77d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 780:	7c a9                	jl     72b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 782:	8b 55 f4             	mov    -0xc(%ebp),%edx
 785:	8b 45 08             	mov    0x8(%ebp),%eax
 788:	01 d0                	add    %edx,%eax
 78a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 78d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 790:	c9                   	leave  
 791:	c3                   	ret    

00000792 <stat>:

int
stat(char *n, struct stat *st)
{
 792:	55                   	push   %ebp
 793:	89 e5                	mov    %esp,%ebp
 795:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 798:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 79f:	00 
 7a0:	8b 45 08             	mov    0x8(%ebp),%eax
 7a3:	89 04 24             	mov    %eax,(%esp)
 7a6:	e8 07 01 00 00       	call   8b2 <open>
 7ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b2:	79 07                	jns    7bb <stat+0x29>
    return -1;
 7b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7b9:	eb 23                	jmp    7de <stat+0x4c>
  r = fstat(fd, st);
 7bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 7be:	89 44 24 04          	mov    %eax,0x4(%esp)
 7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c5:	89 04 24             	mov    %eax,(%esp)
 7c8:	e8 fd 00 00 00       	call   8ca <fstat>
 7cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	89 04 24             	mov    %eax,(%esp)
 7d6:	e8 bf 00 00 00       	call   89a <close>
  return r;
 7db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7de:	c9                   	leave  
 7df:	c3                   	ret    

000007e0 <atoi>:

int
atoi(const char *s)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 7e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 7ed:	eb 25                	jmp    814 <atoi+0x34>
    n = n*10 + *s++ - '0';
 7ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7f2:	89 d0                	mov    %edx,%eax
 7f4:	c1 e0 02             	shl    $0x2,%eax
 7f7:	01 d0                	add    %edx,%eax
 7f9:	01 c0                	add    %eax,%eax
 7fb:	89 c1                	mov    %eax,%ecx
 7fd:	8b 45 08             	mov    0x8(%ebp),%eax
 800:	8d 50 01             	lea    0x1(%eax),%edx
 803:	89 55 08             	mov    %edx,0x8(%ebp)
 806:	0f b6 00             	movzbl (%eax),%eax
 809:	0f be c0             	movsbl %al,%eax
 80c:	01 c8                	add    %ecx,%eax
 80e:	83 e8 30             	sub    $0x30,%eax
 811:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 814:	8b 45 08             	mov    0x8(%ebp),%eax
 817:	0f b6 00             	movzbl (%eax),%eax
 81a:	3c 2f                	cmp    $0x2f,%al
 81c:	7e 0a                	jle    828 <atoi+0x48>
 81e:	8b 45 08             	mov    0x8(%ebp),%eax
 821:	0f b6 00             	movzbl (%eax),%eax
 824:	3c 39                	cmp    $0x39,%al
 826:	7e c7                	jle    7ef <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 82b:	c9                   	leave  
 82c:	c3                   	ret    

0000082d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 82d:	55                   	push   %ebp
 82e:	89 e5                	mov    %esp,%ebp
 830:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 833:	8b 45 08             	mov    0x8(%ebp),%eax
 836:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 839:	8b 45 0c             	mov    0xc(%ebp),%eax
 83c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 83f:	eb 17                	jmp    858 <memmove+0x2b>
    *dst++ = *src++;
 841:	8b 45 fc             	mov    -0x4(%ebp),%eax
 844:	8d 50 01             	lea    0x1(%eax),%edx
 847:	89 55 fc             	mov    %edx,-0x4(%ebp)
 84a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 84d:	8d 4a 01             	lea    0x1(%edx),%ecx
 850:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 853:	0f b6 12             	movzbl (%edx),%edx
 856:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 858:	8b 45 10             	mov    0x10(%ebp),%eax
 85b:	8d 50 ff             	lea    -0x1(%eax),%edx
 85e:	89 55 10             	mov    %edx,0x10(%ebp)
 861:	85 c0                	test   %eax,%eax
 863:	7f dc                	jg     841 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 865:	8b 45 08             	mov    0x8(%ebp),%eax
}
 868:	c9                   	leave  
 869:	c3                   	ret    

0000086a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 86a:	b8 01 00 00 00       	mov    $0x1,%eax
 86f:	cd 40                	int    $0x40
 871:	c3                   	ret    

00000872 <exit>:
SYSCALL(exit)
 872:	b8 02 00 00 00       	mov    $0x2,%eax
 877:	cd 40                	int    $0x40
 879:	c3                   	ret    

0000087a <wait>:
SYSCALL(wait)
 87a:	b8 03 00 00 00       	mov    $0x3,%eax
 87f:	cd 40                	int    $0x40
 881:	c3                   	ret    

00000882 <pipe>:
SYSCALL(pipe)
 882:	b8 04 00 00 00       	mov    $0x4,%eax
 887:	cd 40                	int    $0x40
 889:	c3                   	ret    

0000088a <read>:
SYSCALL(read)
 88a:	b8 05 00 00 00       	mov    $0x5,%eax
 88f:	cd 40                	int    $0x40
 891:	c3                   	ret    

00000892 <write>:
SYSCALL(write)
 892:	b8 10 00 00 00       	mov    $0x10,%eax
 897:	cd 40                	int    $0x40
 899:	c3                   	ret    

0000089a <close>:
SYSCALL(close)
 89a:	b8 15 00 00 00       	mov    $0x15,%eax
 89f:	cd 40                	int    $0x40
 8a1:	c3                   	ret    

000008a2 <kill>:
SYSCALL(kill)
 8a2:	b8 06 00 00 00       	mov    $0x6,%eax
 8a7:	cd 40                	int    $0x40
 8a9:	c3                   	ret    

000008aa <exec>:
SYSCALL(exec)
 8aa:	b8 07 00 00 00       	mov    $0x7,%eax
 8af:	cd 40                	int    $0x40
 8b1:	c3                   	ret    

000008b2 <open>:
SYSCALL(open)
 8b2:	b8 0f 00 00 00       	mov    $0xf,%eax
 8b7:	cd 40                	int    $0x40
 8b9:	c3                   	ret    

000008ba <mknod>:
SYSCALL(mknod)
 8ba:	b8 11 00 00 00       	mov    $0x11,%eax
 8bf:	cd 40                	int    $0x40
 8c1:	c3                   	ret    

000008c2 <unlink>:
SYSCALL(unlink)
 8c2:	b8 12 00 00 00       	mov    $0x12,%eax
 8c7:	cd 40                	int    $0x40
 8c9:	c3                   	ret    

000008ca <fstat>:
SYSCALL(fstat)
 8ca:	b8 08 00 00 00       	mov    $0x8,%eax
 8cf:	cd 40                	int    $0x40
 8d1:	c3                   	ret    

000008d2 <link>:
SYSCALL(link)
 8d2:	b8 13 00 00 00       	mov    $0x13,%eax
 8d7:	cd 40                	int    $0x40
 8d9:	c3                   	ret    

000008da <mkdir>:
SYSCALL(mkdir)
 8da:	b8 14 00 00 00       	mov    $0x14,%eax
 8df:	cd 40                	int    $0x40
 8e1:	c3                   	ret    

000008e2 <chdir>:
SYSCALL(chdir)
 8e2:	b8 09 00 00 00       	mov    $0x9,%eax
 8e7:	cd 40                	int    $0x40
 8e9:	c3                   	ret    

000008ea <dup>:
SYSCALL(dup)
 8ea:	b8 0a 00 00 00       	mov    $0xa,%eax
 8ef:	cd 40                	int    $0x40
 8f1:	c3                   	ret    

000008f2 <getpid>:
SYSCALL(getpid)
 8f2:	b8 0b 00 00 00       	mov    $0xb,%eax
 8f7:	cd 40                	int    $0x40
 8f9:	c3                   	ret    

000008fa <sbrk>:
SYSCALL(sbrk)
 8fa:	b8 0c 00 00 00       	mov    $0xc,%eax
 8ff:	cd 40                	int    $0x40
 901:	c3                   	ret    

00000902 <sleep>:
SYSCALL(sleep)
 902:	b8 0d 00 00 00       	mov    $0xd,%eax
 907:	cd 40                	int    $0x40
 909:	c3                   	ret    

0000090a <uptime>:
SYSCALL(uptime)
 90a:	b8 0e 00 00 00       	mov    $0xe,%eax
 90f:	cd 40                	int    $0x40
 911:	c3                   	ret    

00000912 <changepriority>:
SYSCALL(changepriority)
 912:	b8 16 00 00 00       	mov    $0x16,%eax
 917:	cd 40                	int    $0x40
 919:	c3                   	ret    

0000091a <processstatus>:
SYSCALL(processstatus)
 91a:	b8 17 00 00 00       	mov    $0x17,%eax
 91f:	cd 40                	int    $0x40
 921:	c3                   	ret    

00000922 <randomgen>:
SYSCALL(randomgen)
 922:	b8 18 00 00 00       	mov    $0x18,%eax
 927:	cd 40                	int    $0x40
 929:	c3                   	ret    

0000092a <randomgenrange>:
SYSCALL(randomgenrange)
 92a:	b8 19 00 00 00       	mov    $0x19,%eax
 92f:	cd 40                	int    $0x40
 931:	c3                   	ret    

00000932 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 932:	55                   	push   %ebp
 933:	89 e5                	mov    %esp,%ebp
 935:	83 ec 18             	sub    $0x18,%esp
 938:	8b 45 0c             	mov    0xc(%ebp),%eax
 93b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 93e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 945:	00 
 946:	8d 45 f4             	lea    -0xc(%ebp),%eax
 949:	89 44 24 04          	mov    %eax,0x4(%esp)
 94d:	8b 45 08             	mov    0x8(%ebp),%eax
 950:	89 04 24             	mov    %eax,(%esp)
 953:	e8 3a ff ff ff       	call   892 <write>
}
 958:	c9                   	leave  
 959:	c3                   	ret    

0000095a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 95a:	55                   	push   %ebp
 95b:	89 e5                	mov    %esp,%ebp
 95d:	56                   	push   %esi
 95e:	53                   	push   %ebx
 95f:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 962:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 969:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 96d:	74 17                	je     986 <printint+0x2c>
 96f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 973:	79 11                	jns    986 <printint+0x2c>
    neg = 1;
 975:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 97c:	8b 45 0c             	mov    0xc(%ebp),%eax
 97f:	f7 d8                	neg    %eax
 981:	89 45 ec             	mov    %eax,-0x14(%ebp)
 984:	eb 06                	jmp    98c <printint+0x32>
  } else {
    x = xx;
 986:	8b 45 0c             	mov    0xc(%ebp),%eax
 989:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 98c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 993:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 996:	8d 41 01             	lea    0x1(%ecx),%eax
 999:	89 45 f4             	mov    %eax,-0xc(%ebp)
 99c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 99f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9a2:	ba 00 00 00 00       	mov    $0x0,%edx
 9a7:	f7 f3                	div    %ebx
 9a9:	89 d0                	mov    %edx,%eax
 9ab:	0f b6 80 34 11 00 00 	movzbl 0x1134(%eax),%eax
 9b2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 9b6:	8b 75 10             	mov    0x10(%ebp),%esi
 9b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9bc:	ba 00 00 00 00       	mov    $0x0,%edx
 9c1:	f7 f6                	div    %esi
 9c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9ca:	75 c7                	jne    993 <printint+0x39>
  if(neg)
 9cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9d0:	74 10                	je     9e2 <printint+0x88>
    buf[i++] = '-';
 9d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d5:	8d 50 01             	lea    0x1(%eax),%edx
 9d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9db:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 9e0:	eb 1f                	jmp    a01 <printint+0xa7>
 9e2:	eb 1d                	jmp    a01 <printint+0xa7>
    putc(fd, buf[i]);
 9e4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 9e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ea:	01 d0                	add    %edx,%eax
 9ec:	0f b6 00             	movzbl (%eax),%eax
 9ef:	0f be c0             	movsbl %al,%eax
 9f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 9f6:	8b 45 08             	mov    0x8(%ebp),%eax
 9f9:	89 04 24             	mov    %eax,(%esp)
 9fc:	e8 31 ff ff ff       	call   932 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a01:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a09:	79 d9                	jns    9e4 <printint+0x8a>
    putc(fd, buf[i]);
}
 a0b:	83 c4 30             	add    $0x30,%esp
 a0e:	5b                   	pop    %ebx
 a0f:	5e                   	pop    %esi
 a10:	5d                   	pop    %ebp
 a11:	c3                   	ret    

00000a12 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a12:	55                   	push   %ebp
 a13:	89 e5                	mov    %esp,%ebp
 a15:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a18:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a1f:	8d 45 0c             	lea    0xc(%ebp),%eax
 a22:	83 c0 04             	add    $0x4,%eax
 a25:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 a28:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a2f:	e9 7c 01 00 00       	jmp    bb0 <printf+0x19e>
    c = fmt[i] & 0xff;
 a34:	8b 55 0c             	mov    0xc(%ebp),%edx
 a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3a:	01 d0                	add    %edx,%eax
 a3c:	0f b6 00             	movzbl (%eax),%eax
 a3f:	0f be c0             	movsbl %al,%eax
 a42:	25 ff 00 00 00       	and    $0xff,%eax
 a47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a4a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a4e:	75 2c                	jne    a7c <printf+0x6a>
      if(c == '%'){
 a50:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a54:	75 0c                	jne    a62 <printf+0x50>
        state = '%';
 a56:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a5d:	e9 4a 01 00 00       	jmp    bac <printf+0x19a>
      } else {
        putc(fd, c);
 a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a65:	0f be c0             	movsbl %al,%eax
 a68:	89 44 24 04          	mov    %eax,0x4(%esp)
 a6c:	8b 45 08             	mov    0x8(%ebp),%eax
 a6f:	89 04 24             	mov    %eax,(%esp)
 a72:	e8 bb fe ff ff       	call   932 <putc>
 a77:	e9 30 01 00 00       	jmp    bac <printf+0x19a>
      }
    } else if(state == '%'){
 a7c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a80:	0f 85 26 01 00 00    	jne    bac <printf+0x19a>
      if(c == 'd'){
 a86:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a8a:	75 2d                	jne    ab9 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 a8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a8f:	8b 00                	mov    (%eax),%eax
 a91:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 a98:	00 
 a99:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 aa0:	00 
 aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
 aa5:	8b 45 08             	mov    0x8(%ebp),%eax
 aa8:	89 04 24             	mov    %eax,(%esp)
 aab:	e8 aa fe ff ff       	call   95a <printint>
        ap++;
 ab0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ab4:	e9 ec 00 00 00       	jmp    ba5 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 ab9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 abd:	74 06                	je     ac5 <printf+0xb3>
 abf:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 ac3:	75 2d                	jne    af2 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 ac5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ac8:	8b 00                	mov    (%eax),%eax
 aca:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 ad1:	00 
 ad2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 ad9:	00 
 ada:	89 44 24 04          	mov    %eax,0x4(%esp)
 ade:	8b 45 08             	mov    0x8(%ebp),%eax
 ae1:	89 04 24             	mov    %eax,(%esp)
 ae4:	e8 71 fe ff ff       	call   95a <printint>
        ap++;
 ae9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 aed:	e9 b3 00 00 00       	jmp    ba5 <printf+0x193>
      } else if(c == 's'){
 af2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 af6:	75 45                	jne    b3d <printf+0x12b>
        s = (char*)*ap;
 af8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 afb:	8b 00                	mov    (%eax),%eax
 afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b00:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b08:	75 09                	jne    b13 <printf+0x101>
          s = "(null)";
 b0a:	c7 45 f4 1a 0e 00 00 	movl   $0xe1a,-0xc(%ebp)
        while(*s != 0){
 b11:	eb 1e                	jmp    b31 <printf+0x11f>
 b13:	eb 1c                	jmp    b31 <printf+0x11f>
          putc(fd, *s);
 b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b18:	0f b6 00             	movzbl (%eax),%eax
 b1b:	0f be c0             	movsbl %al,%eax
 b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
 b22:	8b 45 08             	mov    0x8(%ebp),%eax
 b25:	89 04 24             	mov    %eax,(%esp)
 b28:	e8 05 fe ff ff       	call   932 <putc>
          s++;
 b2d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b34:	0f b6 00             	movzbl (%eax),%eax
 b37:	84 c0                	test   %al,%al
 b39:	75 da                	jne    b15 <printf+0x103>
 b3b:	eb 68                	jmp    ba5 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b3d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b41:	75 1d                	jne    b60 <printf+0x14e>
        putc(fd, *ap);
 b43:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b46:	8b 00                	mov    (%eax),%eax
 b48:	0f be c0             	movsbl %al,%eax
 b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
 b4f:	8b 45 08             	mov    0x8(%ebp),%eax
 b52:	89 04 24             	mov    %eax,(%esp)
 b55:	e8 d8 fd ff ff       	call   932 <putc>
        ap++;
 b5a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b5e:	eb 45                	jmp    ba5 <printf+0x193>
      } else if(c == '%'){
 b60:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b64:	75 17                	jne    b7d <printf+0x16b>
        putc(fd, c);
 b66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b69:	0f be c0             	movsbl %al,%eax
 b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
 b70:	8b 45 08             	mov    0x8(%ebp),%eax
 b73:	89 04 24             	mov    %eax,(%esp)
 b76:	e8 b7 fd ff ff       	call   932 <putc>
 b7b:	eb 28                	jmp    ba5 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b7d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 b84:	00 
 b85:	8b 45 08             	mov    0x8(%ebp),%eax
 b88:	89 04 24             	mov    %eax,(%esp)
 b8b:	e8 a2 fd ff ff       	call   932 <putc>
        putc(fd, c);
 b90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b93:	0f be c0             	movsbl %al,%eax
 b96:	89 44 24 04          	mov    %eax,0x4(%esp)
 b9a:	8b 45 08             	mov    0x8(%ebp),%eax
 b9d:	89 04 24             	mov    %eax,(%esp)
 ba0:	e8 8d fd ff ff       	call   932 <putc>
      }
      state = 0;
 ba5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 bac:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
 bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bb6:	01 d0                	add    %edx,%eax
 bb8:	0f b6 00             	movzbl (%eax),%eax
 bbb:	84 c0                	test   %al,%al
 bbd:	0f 85 71 fe ff ff    	jne    a34 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 bc3:	c9                   	leave  
 bc4:	c3                   	ret    

00000bc5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bc5:	55                   	push   %ebp
 bc6:	89 e5                	mov    %esp,%ebp
 bc8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bcb:	8b 45 08             	mov    0x8(%ebp),%eax
 bce:	83 e8 08             	sub    $0x8,%eax
 bd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bd4:	a1 6c 11 00 00       	mov    0x116c,%eax
 bd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 bdc:	eb 24                	jmp    c02 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bde:	8b 45 fc             	mov    -0x4(%ebp),%eax
 be1:	8b 00                	mov    (%eax),%eax
 be3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 be6:	77 12                	ja     bfa <free+0x35>
 be8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 beb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bee:	77 24                	ja     c14 <free+0x4f>
 bf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf3:	8b 00                	mov    (%eax),%eax
 bf5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bf8:	77 1a                	ja     c14 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bfd:	8b 00                	mov    (%eax),%eax
 bff:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c02:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c05:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c08:	76 d4                	jbe    bde <free+0x19>
 c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c0d:	8b 00                	mov    (%eax),%eax
 c0f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c12:	76 ca                	jbe    bde <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c14:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c17:	8b 40 04             	mov    0x4(%eax),%eax
 c1a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c21:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c24:	01 c2                	add    %eax,%edx
 c26:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c29:	8b 00                	mov    (%eax),%eax
 c2b:	39 c2                	cmp    %eax,%edx
 c2d:	75 24                	jne    c53 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c32:	8b 50 04             	mov    0x4(%eax),%edx
 c35:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c38:	8b 00                	mov    (%eax),%eax
 c3a:	8b 40 04             	mov    0x4(%eax),%eax
 c3d:	01 c2                	add    %eax,%edx
 c3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c42:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c48:	8b 00                	mov    (%eax),%eax
 c4a:	8b 10                	mov    (%eax),%edx
 c4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c4f:	89 10                	mov    %edx,(%eax)
 c51:	eb 0a                	jmp    c5d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c53:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c56:	8b 10                	mov    (%eax),%edx
 c58:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c5b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c60:	8b 40 04             	mov    0x4(%eax),%eax
 c63:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c6d:	01 d0                	add    %edx,%eax
 c6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c72:	75 20                	jne    c94 <free+0xcf>
    p->s.size += bp->s.size;
 c74:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c77:	8b 50 04             	mov    0x4(%eax),%edx
 c7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c7d:	8b 40 04             	mov    0x4(%eax),%eax
 c80:	01 c2                	add    %eax,%edx
 c82:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c85:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c88:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c8b:	8b 10                	mov    (%eax),%edx
 c8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c90:	89 10                	mov    %edx,(%eax)
 c92:	eb 08                	jmp    c9c <free+0xd7>
  } else
    p->s.ptr = bp;
 c94:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c97:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c9a:	89 10                	mov    %edx,(%eax)
  freep = p;
 c9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c9f:	a3 6c 11 00 00       	mov    %eax,0x116c
}
 ca4:	c9                   	leave  
 ca5:	c3                   	ret    

00000ca6 <morecore>:

static Header*
morecore(uint nu)
{
 ca6:	55                   	push   %ebp
 ca7:	89 e5                	mov    %esp,%ebp
 ca9:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 cac:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 cb3:	77 07                	ja     cbc <morecore+0x16>
    nu = 4096;
 cb5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 cbc:	8b 45 08             	mov    0x8(%ebp),%eax
 cbf:	c1 e0 03             	shl    $0x3,%eax
 cc2:	89 04 24             	mov    %eax,(%esp)
 cc5:	e8 30 fc ff ff       	call   8fa <sbrk>
 cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 ccd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 cd1:	75 07                	jne    cda <morecore+0x34>
    return 0;
 cd3:	b8 00 00 00 00       	mov    $0x0,%eax
 cd8:	eb 22                	jmp    cfc <morecore+0x56>
  hp = (Header*)p;
 cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ce3:	8b 55 08             	mov    0x8(%ebp),%edx
 ce6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cec:	83 c0 08             	add    $0x8,%eax
 cef:	89 04 24             	mov    %eax,(%esp)
 cf2:	e8 ce fe ff ff       	call   bc5 <free>
  return freep;
 cf7:	a1 6c 11 00 00       	mov    0x116c,%eax
}
 cfc:	c9                   	leave  
 cfd:	c3                   	ret    

00000cfe <malloc>:

void*
malloc(uint nbytes)
{
 cfe:	55                   	push   %ebp
 cff:	89 e5                	mov    %esp,%ebp
 d01:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d04:	8b 45 08             	mov    0x8(%ebp),%eax
 d07:	83 c0 07             	add    $0x7,%eax
 d0a:	c1 e8 03             	shr    $0x3,%eax
 d0d:	83 c0 01             	add    $0x1,%eax
 d10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d13:	a1 6c 11 00 00       	mov    0x116c,%eax
 d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d1f:	75 23                	jne    d44 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 d21:	c7 45 f0 64 11 00 00 	movl   $0x1164,-0x10(%ebp)
 d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d2b:	a3 6c 11 00 00       	mov    %eax,0x116c
 d30:	a1 6c 11 00 00       	mov    0x116c,%eax
 d35:	a3 64 11 00 00       	mov    %eax,0x1164
    base.s.size = 0;
 d3a:	c7 05 68 11 00 00 00 	movl   $0x0,0x1168
 d41:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d47:	8b 00                	mov    (%eax),%eax
 d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d4f:	8b 40 04             	mov    0x4(%eax),%eax
 d52:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d55:	72 4d                	jb     da4 <malloc+0xa6>
      if(p->s.size == nunits)
 d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d5a:	8b 40 04             	mov    0x4(%eax),%eax
 d5d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d60:	75 0c                	jne    d6e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d65:	8b 10                	mov    (%eax),%edx
 d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d6a:	89 10                	mov    %edx,(%eax)
 d6c:	eb 26                	jmp    d94 <malloc+0x96>
      else {
        p->s.size -= nunits;
 d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d71:	8b 40 04             	mov    0x4(%eax),%eax
 d74:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d77:	89 c2                	mov    %eax,%edx
 d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d7c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d82:	8b 40 04             	mov    0x4(%eax),%eax
 d85:	c1 e0 03             	shl    $0x3,%eax
 d88:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d91:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d97:	a3 6c 11 00 00       	mov    %eax,0x116c
      return (void*)(p + 1);
 d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d9f:	83 c0 08             	add    $0x8,%eax
 da2:	eb 38                	jmp    ddc <malloc+0xde>
    }
    if(p == freep)
 da4:	a1 6c 11 00 00       	mov    0x116c,%eax
 da9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 dac:	75 1b                	jne    dc9 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 dae:	8b 45 ec             	mov    -0x14(%ebp),%eax
 db1:	89 04 24             	mov    %eax,(%esp)
 db4:	e8 ed fe ff ff       	call   ca6 <morecore>
 db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 dbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 dc0:	75 07                	jne    dc9 <malloc+0xcb>
        return 0;
 dc2:	b8 00 00 00 00       	mov    $0x0,%eax
 dc7:	eb 13                	jmp    ddc <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dd2:	8b 00                	mov    (%eax),%eax
 dd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 dd7:	e9 70 ff ff ff       	jmp    d4c <malloc+0x4e>
}
 ddc:	c9                   	leave  
 ddd:	c3                   	ret    
