
_testTask1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[]) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 30             	sub    $0x30,%esp
  int pid;
  int k, numChild;
  double x, z;

  if(argc < 2)
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 0a                	jg     19 <main+0x19>
	numChild = 1; //Default
   f:	c7 44 24 28 01 00 00 	movl   $0x1,0x28(%esp)
  16:	00 
  17:	eb 14                	jmp    2d <main+0x2d>
  else
	numChild = atoi(argv[1]);
  19:	8b 45 0c             	mov    0xc(%ebp),%eax
  1c:	83 c0 04             	add    $0x4,%eax
  1f:	8b 00                	mov    (%eax),%eax
  21:	89 04 24             	mov    %eax,(%esp)
  24:	e8 f7 02 00 00       	call   320 <atoi>
  29:	89 44 24 28          	mov    %eax,0x28(%esp)
  if (numChild < 0 ||numChild > 20)
  2d:	83 7c 24 28 00       	cmpl   $0x0,0x28(%esp)
  32:	78 07                	js     3b <main+0x3b>
  34:	83 7c 24 28 14       	cmpl   $0x14,0x28(%esp)
  39:	7e 08                	jle    43 <main+0x43>
	numChild = 2;
  3b:	c7 44 24 28 02 00 00 	movl   $0x2,0x28(%esp)
  42:	00 
  if (argc>=3)
  43:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  47:	7e 14                	jle    5d <main+0x5d>
  	numChild = atoi(argv[2]);
  49:	8b 45 0c             	mov    0xc(%ebp),%eax
  4c:	83 c0 08             	add    $0x8,%eax
  4f:	8b 00                	mov    (%eax),%eax
  51:	89 04 24             	mov    %eax,(%esp)
  54:	e8 c7 02 00 00       	call   320 <atoi>
  59:	89 44 24 28          	mov    %eax,0x28(%esp)
  x = 0;
  5d:	d9 ee                	fldz   
  5f:	dd 5c 24 20          	fstpl  0x20(%esp)
  pid = 0;
  63:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  6a:	00 

  for ( k = 0; k < numChild; k++ ) {
  6b:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  72:	00 
  73:	e9 bf 00 00 00       	jmp    137 <main+0x137>
    pid = fork ();
  78:	e8 2d 03 00 00       	call   3aa <fork>
  7d:	89 44 24 14          	mov    %eax,0x14(%esp)
    if ( pid < 0 ) {
  81:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
  86:	79 22                	jns    aa <main+0xaa>
      printf(1, "%d failed in fork!\n", getpid());
  88:	e8 a5 03 00 00       	call   432 <getpid>
  8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  91:	c7 44 24 04 20 09 00 	movl   $0x920,0x4(%esp)
  98:	00 
  99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a0:	e8 ad 04 00 00       	call   552 <printf>
  a5:	e9 88 00 00 00       	jmp    132 <main+0x132>
    } else if (pid > 0) {
  aa:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
  af:	7e 2c                	jle    dd <main+0xdd>
      // parent
      printf(1, "Parent %d creating child %d\n",getpid(), pid);
  b1:	e8 7c 03 00 00       	call   432 <getpid>
  b6:	8b 54 24 14          	mov    0x14(%esp),%edx
  ba:	89 54 24 0c          	mov    %edx,0xc(%esp)
  be:	89 44 24 08          	mov    %eax,0x8(%esp)
  c2:	c7 44 24 04 34 09 00 	movl   $0x934,0x4(%esp)
  c9:	00 
  ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d1:	e8 7c 04 00 00       	call   552 <printf>
      wait();
  d6:	e8 df 02 00 00       	call   3ba <wait>
  db:	eb 55                	jmp    132 <main+0x132>
      }
      else{
	printf(1,"Child %d created\n",getpid());
  dd:	e8 50 03 00 00       	call   432 <getpid>
  e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  e6:	c7 44 24 04 51 09 00 	movl   $0x951,0x4(%esp)
  ed:	00 
  ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f5:	e8 58 04 00 00       	call   552 <printf>
	//Wasting CPU time around 10 seconds	
	for(z = 0.0; z < 80000000.0; z+=1.0)
  fa:	d9 ee                	fldz   
  fc:	dd 5c 24 18          	fstpl  0x18(%esp)
 100:	eb 1c                	jmp    11e <main+0x11e>
	    x = x + 3.14*89.64;
 102:	dd 44 24 20          	fldl   0x20(%esp)
 106:	dd 05 68 09 00 00    	fldl   0x968
 10c:	de c1                	faddp  %st,%st(1)
 10e:	dd 5c 24 20          	fstpl  0x20(%esp)
      wait();
      }
      else{
	printf(1,"Child %d created\n",getpid());
	//Wasting CPU time around 10 seconds	
	for(z = 0.0; z < 80000000.0; z+=1.0)
 112:	dd 44 24 18          	fldl   0x18(%esp)
 116:	d9 e8                	fld1   
 118:	de c1                	faddp  %st,%st(1)
 11a:	dd 5c 24 18          	fstpl  0x18(%esp)
 11e:	dd 05 70 09 00 00    	fldl   0x970
 124:	dd 44 24 18          	fldl   0x18(%esp)
 128:	d9 c9                	fxch   %st(1)
 12a:	df e9                	fucomip %st(1),%st
 12c:	dd d8                	fstp   %st(0)
 12e:	77 d2                	ja     102 <main+0x102>
	    x = x + 3.14*89.64;
	break;
 130:	eb 13                	jmp    145 <main+0x145>
  if (argc>=3)
  	numChild = atoi(argv[2]);
  x = 0;
  pid = 0;

  for ( k = 0; k < numChild; k++ ) {
 132:	83 44 24 2c 01       	addl   $0x1,0x2c(%esp)
 137:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 13b:	3b 44 24 28          	cmp    0x28(%esp),%eax
 13f:	0f 8c 33 ff ff ff    	jl     78 <main+0x78>
	for(z = 0.0; z < 80000000.0; z+=1.0)
	    x = x + 3.14*89.64;
	break;
      }
  }
  exit();
 145:	e8 68 02 00 00       	call   3b2 <exit>

0000014a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	57                   	push   %edi
 14e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 14f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 152:	8b 55 10             	mov    0x10(%ebp),%edx
 155:	8b 45 0c             	mov    0xc(%ebp),%eax
 158:	89 cb                	mov    %ecx,%ebx
 15a:	89 df                	mov    %ebx,%edi
 15c:	89 d1                	mov    %edx,%ecx
 15e:	fc                   	cld    
 15f:	f3 aa                	rep stos %al,%es:(%edi)
 161:	89 ca                	mov    %ecx,%edx
 163:	89 fb                	mov    %edi,%ebx
 165:	89 5d 08             	mov    %ebx,0x8(%ebp)
 168:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 16b:	5b                   	pop    %ebx
 16c:	5f                   	pop    %edi
 16d:	5d                   	pop    %ebp
 16e:	c3                   	ret    

0000016f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 16f:	55                   	push   %ebp
 170:	89 e5                	mov    %esp,%ebp
 172:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 17b:	90                   	nop
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	8d 50 01             	lea    0x1(%eax),%edx
 182:	89 55 08             	mov    %edx,0x8(%ebp)
 185:	8b 55 0c             	mov    0xc(%ebp),%edx
 188:	8d 4a 01             	lea    0x1(%edx),%ecx
 18b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 18e:	0f b6 12             	movzbl (%edx),%edx
 191:	88 10                	mov    %dl,(%eax)
 193:	0f b6 00             	movzbl (%eax),%eax
 196:	84 c0                	test   %al,%al
 198:	75 e2                	jne    17c <strcpy+0xd>
    ;
  return os;
 19a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 19d:	c9                   	leave  
 19e:	c3                   	ret    

0000019f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 19f:	55                   	push   %ebp
 1a0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1a2:	eb 08                	jmp    1ac <strcmp+0xd>
    p++, q++;
 1a4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	0f b6 00             	movzbl (%eax),%eax
 1b2:	84 c0                	test   %al,%al
 1b4:	74 10                	je     1c6 <strcmp+0x27>
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	0f b6 10             	movzbl (%eax),%edx
 1bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	38 c2                	cmp    %al,%dl
 1c4:	74 de                	je     1a4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1c6:	8b 45 08             	mov    0x8(%ebp),%eax
 1c9:	0f b6 00             	movzbl (%eax),%eax
 1cc:	0f b6 d0             	movzbl %al,%edx
 1cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d2:	0f b6 00             	movzbl (%eax),%eax
 1d5:	0f b6 c0             	movzbl %al,%eax
 1d8:	29 c2                	sub    %eax,%edx
 1da:	89 d0                	mov    %edx,%eax
}
 1dc:	5d                   	pop    %ebp
 1dd:	c3                   	ret    

000001de <strlen>:

uint
strlen(char *s)
{
 1de:	55                   	push   %ebp
 1df:	89 e5                	mov    %esp,%ebp
 1e1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1eb:	eb 04                	jmp    1f1 <strlen+0x13>
 1ed:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	01 d0                	add    %edx,%eax
 1f9:	0f b6 00             	movzbl (%eax),%eax
 1fc:	84 c0                	test   %al,%al
 1fe:	75 ed                	jne    1ed <strlen+0xf>
    ;
  return n;
 200:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 203:	c9                   	leave  
 204:	c3                   	ret    

00000205 <memset>:

void*
memset(void *dst, int c, uint n)
{
 205:	55                   	push   %ebp
 206:	89 e5                	mov    %esp,%ebp
 208:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 20b:	8b 45 10             	mov    0x10(%ebp),%eax
 20e:	89 44 24 08          	mov    %eax,0x8(%esp)
 212:	8b 45 0c             	mov    0xc(%ebp),%eax
 215:	89 44 24 04          	mov    %eax,0x4(%esp)
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	89 04 24             	mov    %eax,(%esp)
 21f:	e8 26 ff ff ff       	call   14a <stosb>
  return dst;
 224:	8b 45 08             	mov    0x8(%ebp),%eax
}
 227:	c9                   	leave  
 228:	c3                   	ret    

00000229 <strchr>:

char*
strchr(const char *s, char c)
{
 229:	55                   	push   %ebp
 22a:	89 e5                	mov    %esp,%ebp
 22c:	83 ec 04             	sub    $0x4,%esp
 22f:	8b 45 0c             	mov    0xc(%ebp),%eax
 232:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 235:	eb 14                	jmp    24b <strchr+0x22>
    if(*s == c)
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 240:	75 05                	jne    247 <strchr+0x1e>
      return (char*)s;
 242:	8b 45 08             	mov    0x8(%ebp),%eax
 245:	eb 13                	jmp    25a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 247:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	0f b6 00             	movzbl (%eax),%eax
 251:	84 c0                	test   %al,%al
 253:	75 e2                	jne    237 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 255:	b8 00 00 00 00       	mov    $0x0,%eax
}
 25a:	c9                   	leave  
 25b:	c3                   	ret    

0000025c <gets>:

char*
gets(char *buf, int max)
{
 25c:	55                   	push   %ebp
 25d:	89 e5                	mov    %esp,%ebp
 25f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 262:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 269:	eb 4c                	jmp    2b7 <gets+0x5b>
    cc = read(0, &c, 1);
 26b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 272:	00 
 273:	8d 45 ef             	lea    -0x11(%ebp),%eax
 276:	89 44 24 04          	mov    %eax,0x4(%esp)
 27a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 281:	e8 44 01 00 00       	call   3ca <read>
 286:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 289:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 28d:	7f 02                	jg     291 <gets+0x35>
      break;
 28f:	eb 31                	jmp    2c2 <gets+0x66>
    buf[i++] = c;
 291:	8b 45 f4             	mov    -0xc(%ebp),%eax
 294:	8d 50 01             	lea    0x1(%eax),%edx
 297:	89 55 f4             	mov    %edx,-0xc(%ebp)
 29a:	89 c2                	mov    %eax,%edx
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	01 c2                	add    %eax,%edx
 2a1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2a7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ab:	3c 0a                	cmp    $0xa,%al
 2ad:	74 13                	je     2c2 <gets+0x66>
 2af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b3:	3c 0d                	cmp    $0xd,%al
 2b5:	74 0b                	je     2c2 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ba:	83 c0 01             	add    $0x1,%eax
 2bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2c0:	7c a9                	jl     26b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
 2c8:	01 d0                	add    %edx,%eax
 2ca:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d0:	c9                   	leave  
 2d1:	c3                   	ret    

000002d2 <stat>:

int
stat(char *n, struct stat *st)
{
 2d2:	55                   	push   %ebp
 2d3:	89 e5                	mov    %esp,%ebp
 2d5:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2df:	00 
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	89 04 24             	mov    %eax,(%esp)
 2e6:	e8 07 01 00 00       	call   3f2 <open>
 2eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2f2:	79 07                	jns    2fb <stat+0x29>
    return -1;
 2f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f9:	eb 23                	jmp    31e <stat+0x4c>
  r = fstat(fd, st);
 2fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 302:	8b 45 f4             	mov    -0xc(%ebp),%eax
 305:	89 04 24             	mov    %eax,(%esp)
 308:	e8 fd 00 00 00       	call   40a <fstat>
 30d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 310:	8b 45 f4             	mov    -0xc(%ebp),%eax
 313:	89 04 24             	mov    %eax,(%esp)
 316:	e8 bf 00 00 00       	call   3da <close>
  return r;
 31b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 31e:	c9                   	leave  
 31f:	c3                   	ret    

00000320 <atoi>:

int
atoi(const char *s)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 326:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 32d:	eb 25                	jmp    354 <atoi+0x34>
    n = n*10 + *s++ - '0';
 32f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 332:	89 d0                	mov    %edx,%eax
 334:	c1 e0 02             	shl    $0x2,%eax
 337:	01 d0                	add    %edx,%eax
 339:	01 c0                	add    %eax,%eax
 33b:	89 c1                	mov    %eax,%ecx
 33d:	8b 45 08             	mov    0x8(%ebp),%eax
 340:	8d 50 01             	lea    0x1(%eax),%edx
 343:	89 55 08             	mov    %edx,0x8(%ebp)
 346:	0f b6 00             	movzbl (%eax),%eax
 349:	0f be c0             	movsbl %al,%eax
 34c:	01 c8                	add    %ecx,%eax
 34e:	83 e8 30             	sub    $0x30,%eax
 351:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 354:	8b 45 08             	mov    0x8(%ebp),%eax
 357:	0f b6 00             	movzbl (%eax),%eax
 35a:	3c 2f                	cmp    $0x2f,%al
 35c:	7e 0a                	jle    368 <atoi+0x48>
 35e:	8b 45 08             	mov    0x8(%ebp),%eax
 361:	0f b6 00             	movzbl (%eax),%eax
 364:	3c 39                	cmp    $0x39,%al
 366:	7e c7                	jle    32f <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 368:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 36b:	c9                   	leave  
 36c:	c3                   	ret    

0000036d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 36d:	55                   	push   %ebp
 36e:	89 e5                	mov    %esp,%ebp
 370:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 379:	8b 45 0c             	mov    0xc(%ebp),%eax
 37c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 37f:	eb 17                	jmp    398 <memmove+0x2b>
    *dst++ = *src++;
 381:	8b 45 fc             	mov    -0x4(%ebp),%eax
 384:	8d 50 01             	lea    0x1(%eax),%edx
 387:	89 55 fc             	mov    %edx,-0x4(%ebp)
 38a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 38d:	8d 4a 01             	lea    0x1(%edx),%ecx
 390:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 393:	0f b6 12             	movzbl (%edx),%edx
 396:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 398:	8b 45 10             	mov    0x10(%ebp),%eax
 39b:	8d 50 ff             	lea    -0x1(%eax),%edx
 39e:	89 55 10             	mov    %edx,0x10(%ebp)
 3a1:	85 c0                	test   %eax,%eax
 3a3:	7f dc                	jg     381 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3a8:	c9                   	leave  
 3a9:	c3                   	ret    

000003aa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3aa:	b8 01 00 00 00       	mov    $0x1,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <exit>:
SYSCALL(exit)
 3b2:	b8 02 00 00 00       	mov    $0x2,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <wait>:
SYSCALL(wait)
 3ba:	b8 03 00 00 00       	mov    $0x3,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <pipe>:
SYSCALL(pipe)
 3c2:	b8 04 00 00 00       	mov    $0x4,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <read>:
SYSCALL(read)
 3ca:	b8 05 00 00 00       	mov    $0x5,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <write>:
SYSCALL(write)
 3d2:	b8 10 00 00 00       	mov    $0x10,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <close>:
SYSCALL(close)
 3da:	b8 15 00 00 00       	mov    $0x15,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <kill>:
SYSCALL(kill)
 3e2:	b8 06 00 00 00       	mov    $0x6,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <exec>:
SYSCALL(exec)
 3ea:	b8 07 00 00 00       	mov    $0x7,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <open>:
SYSCALL(open)
 3f2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <mknod>:
SYSCALL(mknod)
 3fa:	b8 11 00 00 00       	mov    $0x11,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <unlink>:
SYSCALL(unlink)
 402:	b8 12 00 00 00       	mov    $0x12,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <fstat>:
SYSCALL(fstat)
 40a:	b8 08 00 00 00       	mov    $0x8,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <link>:
SYSCALL(link)
 412:	b8 13 00 00 00       	mov    $0x13,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <mkdir>:
SYSCALL(mkdir)
 41a:	b8 14 00 00 00       	mov    $0x14,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <chdir>:
SYSCALL(chdir)
 422:	b8 09 00 00 00       	mov    $0x9,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <dup>:
SYSCALL(dup)
 42a:	b8 0a 00 00 00       	mov    $0xa,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <getpid>:
SYSCALL(getpid)
 432:	b8 0b 00 00 00       	mov    $0xb,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <sbrk>:
SYSCALL(sbrk)
 43a:	b8 0c 00 00 00       	mov    $0xc,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <sleep>:
SYSCALL(sleep)
 442:	b8 0d 00 00 00       	mov    $0xd,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <uptime>:
SYSCALL(uptime)
 44a:	b8 0e 00 00 00       	mov    $0xe,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <changepriority>:
SYSCALL(changepriority)
 452:	b8 16 00 00 00       	mov    $0x16,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <processstatus>:
SYSCALL(processstatus)
 45a:	b8 17 00 00 00       	mov    $0x17,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <randomgen>:
SYSCALL(randomgen)
 462:	b8 18 00 00 00       	mov    $0x18,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <randomgenrange>:
SYSCALL(randomgenrange)
 46a:	b8 19 00 00 00       	mov    $0x19,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 472:	55                   	push   %ebp
 473:	89 e5                	mov    %esp,%ebp
 475:	83 ec 18             	sub    $0x18,%esp
 478:	8b 45 0c             	mov    0xc(%ebp),%eax
 47b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 47e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 485:	00 
 486:	8d 45 f4             	lea    -0xc(%ebp),%eax
 489:	89 44 24 04          	mov    %eax,0x4(%esp)
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
 490:	89 04 24             	mov    %eax,(%esp)
 493:	e8 3a ff ff ff       	call   3d2 <write>
}
 498:	c9                   	leave  
 499:	c3                   	ret    

0000049a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 49a:	55                   	push   %ebp
 49b:	89 e5                	mov    %esp,%ebp
 49d:	56                   	push   %esi
 49e:	53                   	push   %ebx
 49f:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4a9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4ad:	74 17                	je     4c6 <printint+0x2c>
 4af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4b3:	79 11                	jns    4c6 <printint+0x2c>
    neg = 1;
 4b5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bf:	f7 d8                	neg    %eax
 4c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c4:	eb 06                	jmp    4cc <printint+0x32>
  } else {
    x = xx;
 4c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4d3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4d6:	8d 41 01             	lea    0x1(%ecx),%eax
 4d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4df:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e2:	ba 00 00 00 00       	mov    $0x0,%edx
 4e7:	f7 f3                	div    %ebx
 4e9:	89 d0                	mov    %edx,%eax
 4eb:	0f b6 80 c4 0b 00 00 	movzbl 0xbc4(%eax),%eax
 4f2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4f6:	8b 75 10             	mov    0x10(%ebp),%esi
 4f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4fc:	ba 00 00 00 00       	mov    $0x0,%edx
 501:	f7 f6                	div    %esi
 503:	89 45 ec             	mov    %eax,-0x14(%ebp)
 506:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 50a:	75 c7                	jne    4d3 <printint+0x39>
  if(neg)
 50c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 510:	74 10                	je     522 <printint+0x88>
    buf[i++] = '-';
 512:	8b 45 f4             	mov    -0xc(%ebp),%eax
 515:	8d 50 01             	lea    0x1(%eax),%edx
 518:	89 55 f4             	mov    %edx,-0xc(%ebp)
 51b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 520:	eb 1f                	jmp    541 <printint+0xa7>
 522:	eb 1d                	jmp    541 <printint+0xa7>
    putc(fd, buf[i]);
 524:	8d 55 dc             	lea    -0x24(%ebp),%edx
 527:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52a:	01 d0                	add    %edx,%eax
 52c:	0f b6 00             	movzbl (%eax),%eax
 52f:	0f be c0             	movsbl %al,%eax
 532:	89 44 24 04          	mov    %eax,0x4(%esp)
 536:	8b 45 08             	mov    0x8(%ebp),%eax
 539:	89 04 24             	mov    %eax,(%esp)
 53c:	e8 31 ff ff ff       	call   472 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 541:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 545:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 549:	79 d9                	jns    524 <printint+0x8a>
    putc(fd, buf[i]);
}
 54b:	83 c4 30             	add    $0x30,%esp
 54e:	5b                   	pop    %ebx
 54f:	5e                   	pop    %esi
 550:	5d                   	pop    %ebp
 551:	c3                   	ret    

00000552 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 552:	55                   	push   %ebp
 553:	89 e5                	mov    %esp,%ebp
 555:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 558:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 55f:	8d 45 0c             	lea    0xc(%ebp),%eax
 562:	83 c0 04             	add    $0x4,%eax
 565:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 568:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 56f:	e9 7c 01 00 00       	jmp    6f0 <printf+0x19e>
    c = fmt[i] & 0xff;
 574:	8b 55 0c             	mov    0xc(%ebp),%edx
 577:	8b 45 f0             	mov    -0x10(%ebp),%eax
 57a:	01 d0                	add    %edx,%eax
 57c:	0f b6 00             	movzbl (%eax),%eax
 57f:	0f be c0             	movsbl %al,%eax
 582:	25 ff 00 00 00       	and    $0xff,%eax
 587:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 58a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 58e:	75 2c                	jne    5bc <printf+0x6a>
      if(c == '%'){
 590:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 594:	75 0c                	jne    5a2 <printf+0x50>
        state = '%';
 596:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 59d:	e9 4a 01 00 00       	jmp    6ec <printf+0x19a>
      } else {
        putc(fd, c);
 5a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a5:	0f be c0             	movsbl %al,%eax
 5a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ac:	8b 45 08             	mov    0x8(%ebp),%eax
 5af:	89 04 24             	mov    %eax,(%esp)
 5b2:	e8 bb fe ff ff       	call   472 <putc>
 5b7:	e9 30 01 00 00       	jmp    6ec <printf+0x19a>
      }
    } else if(state == '%'){
 5bc:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5c0:	0f 85 26 01 00 00    	jne    6ec <printf+0x19a>
      if(c == 'd'){
 5c6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5ca:	75 2d                	jne    5f9 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cf:	8b 00                	mov    (%eax),%eax
 5d1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5d8:	00 
 5d9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5e0:	00 
 5e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	89 04 24             	mov    %eax,(%esp)
 5eb:	e8 aa fe ff ff       	call   49a <printint>
        ap++;
 5f0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f4:	e9 ec 00 00 00       	jmp    6e5 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5f9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5fd:	74 06                	je     605 <printf+0xb3>
 5ff:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 603:	75 2d                	jne    632 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 605:	8b 45 e8             	mov    -0x18(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 611:	00 
 612:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 619:	00 
 61a:	89 44 24 04          	mov    %eax,0x4(%esp)
 61e:	8b 45 08             	mov    0x8(%ebp),%eax
 621:	89 04 24             	mov    %eax,(%esp)
 624:	e8 71 fe ff ff       	call   49a <printint>
        ap++;
 629:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 62d:	e9 b3 00 00 00       	jmp    6e5 <printf+0x193>
      } else if(c == 's'){
 632:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 636:	75 45                	jne    67d <printf+0x12b>
        s = (char*)*ap;
 638:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63b:	8b 00                	mov    (%eax),%eax
 63d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 640:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 644:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 648:	75 09                	jne    653 <printf+0x101>
          s = "(null)";
 64a:	c7 45 f4 78 09 00 00 	movl   $0x978,-0xc(%ebp)
        while(*s != 0){
 651:	eb 1e                	jmp    671 <printf+0x11f>
 653:	eb 1c                	jmp    671 <printf+0x11f>
          putc(fd, *s);
 655:	8b 45 f4             	mov    -0xc(%ebp),%eax
 658:	0f b6 00             	movzbl (%eax),%eax
 65b:	0f be c0             	movsbl %al,%eax
 65e:	89 44 24 04          	mov    %eax,0x4(%esp)
 662:	8b 45 08             	mov    0x8(%ebp),%eax
 665:	89 04 24             	mov    %eax,(%esp)
 668:	e8 05 fe ff ff       	call   472 <putc>
          s++;
 66d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 671:	8b 45 f4             	mov    -0xc(%ebp),%eax
 674:	0f b6 00             	movzbl (%eax),%eax
 677:	84 c0                	test   %al,%al
 679:	75 da                	jne    655 <printf+0x103>
 67b:	eb 68                	jmp    6e5 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 67d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 681:	75 1d                	jne    6a0 <printf+0x14e>
        putc(fd, *ap);
 683:	8b 45 e8             	mov    -0x18(%ebp),%eax
 686:	8b 00                	mov    (%eax),%eax
 688:	0f be c0             	movsbl %al,%eax
 68b:	89 44 24 04          	mov    %eax,0x4(%esp)
 68f:	8b 45 08             	mov    0x8(%ebp),%eax
 692:	89 04 24             	mov    %eax,(%esp)
 695:	e8 d8 fd ff ff       	call   472 <putc>
        ap++;
 69a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69e:	eb 45                	jmp    6e5 <printf+0x193>
      } else if(c == '%'){
 6a0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6a4:	75 17                	jne    6bd <printf+0x16b>
        putc(fd, c);
 6a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a9:	0f be c0             	movsbl %al,%eax
 6ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b0:	8b 45 08             	mov    0x8(%ebp),%eax
 6b3:	89 04 24             	mov    %eax,(%esp)
 6b6:	e8 b7 fd ff ff       	call   472 <putc>
 6bb:	eb 28                	jmp    6e5 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6bd:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6c4:	00 
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
 6c8:	89 04 24             	mov    %eax,(%esp)
 6cb:	e8 a2 fd ff ff       	call   472 <putc>
        putc(fd, c);
 6d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d3:	0f be c0             	movsbl %al,%eax
 6d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 6da:	8b 45 08             	mov    0x8(%ebp),%eax
 6dd:	89 04 24             	mov    %eax,(%esp)
 6e0:	e8 8d fd ff ff       	call   472 <putc>
      }
      state = 0;
 6e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ec:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6f0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f6:	01 d0                	add    %edx,%eax
 6f8:	0f b6 00             	movzbl (%eax),%eax
 6fb:	84 c0                	test   %al,%al
 6fd:	0f 85 71 fe ff ff    	jne    574 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 703:	c9                   	leave  
 704:	c3                   	ret    

00000705 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 705:	55                   	push   %ebp
 706:	89 e5                	mov    %esp,%ebp
 708:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 70b:	8b 45 08             	mov    0x8(%ebp),%eax
 70e:	83 e8 08             	sub    $0x8,%eax
 711:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 714:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 719:	89 45 fc             	mov    %eax,-0x4(%ebp)
 71c:	eb 24                	jmp    742 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 00                	mov    (%eax),%eax
 723:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 726:	77 12                	ja     73a <free+0x35>
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72e:	77 24                	ja     754 <free+0x4f>
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	8b 00                	mov    (%eax),%eax
 735:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 738:	77 1a                	ja     754 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	8b 00                	mov    (%eax),%eax
 73f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 742:	8b 45 f8             	mov    -0x8(%ebp),%eax
 745:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 748:	76 d4                	jbe    71e <free+0x19>
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	8b 00                	mov    (%eax),%eax
 74f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 752:	76 ca                	jbe    71e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 754:	8b 45 f8             	mov    -0x8(%ebp),%eax
 757:	8b 40 04             	mov    0x4(%eax),%eax
 75a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	01 c2                	add    %eax,%edx
 766:	8b 45 fc             	mov    -0x4(%ebp),%eax
 769:	8b 00                	mov    (%eax),%eax
 76b:	39 c2                	cmp    %eax,%edx
 76d:	75 24                	jne    793 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	8b 50 04             	mov    0x4(%eax),%edx
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	8b 00                	mov    (%eax),%eax
 77a:	8b 40 04             	mov    0x4(%eax),%eax
 77d:	01 c2                	add    %eax,%edx
 77f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 782:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	8b 10                	mov    (%eax),%edx
 78c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78f:	89 10                	mov    %edx,(%eax)
 791:	eb 0a                	jmp    79d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 40 04             	mov    0x4(%eax),%eax
 7a3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	01 d0                	add    %edx,%eax
 7af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b2:	75 20                	jne    7d4 <free+0xcf>
    p->s.size += bp->s.size;
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	8b 50 04             	mov    0x4(%eax),%edx
 7ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bd:	8b 40 04             	mov    0x4(%eax),%eax
 7c0:	01 c2                	add    %eax,%edx
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cb:	8b 10                	mov    (%eax),%edx
 7cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d0:	89 10                	mov    %edx,(%eax)
 7d2:	eb 08                	jmp    7dc <free+0xd7>
  } else
    p->s.ptr = bp;
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7da:	89 10                	mov    %edx,(%eax)
  freep = p;
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	a3 e0 0b 00 00       	mov    %eax,0xbe0
}
 7e4:	c9                   	leave  
 7e5:	c3                   	ret    

000007e6 <morecore>:

static Header*
morecore(uint nu)
{
 7e6:	55                   	push   %ebp
 7e7:	89 e5                	mov    %esp,%ebp
 7e9:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7ec:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7f3:	77 07                	ja     7fc <morecore+0x16>
    nu = 4096;
 7f5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7fc:	8b 45 08             	mov    0x8(%ebp),%eax
 7ff:	c1 e0 03             	shl    $0x3,%eax
 802:	89 04 24             	mov    %eax,(%esp)
 805:	e8 30 fc ff ff       	call   43a <sbrk>
 80a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 80d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 811:	75 07                	jne    81a <morecore+0x34>
    return 0;
 813:	b8 00 00 00 00       	mov    $0x0,%eax
 818:	eb 22                	jmp    83c <morecore+0x56>
  hp = (Header*)p;
 81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 820:	8b 45 f0             	mov    -0x10(%ebp),%eax
 823:	8b 55 08             	mov    0x8(%ebp),%edx
 826:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 829:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82c:	83 c0 08             	add    $0x8,%eax
 82f:	89 04 24             	mov    %eax,(%esp)
 832:	e8 ce fe ff ff       	call   705 <free>
  return freep;
 837:	a1 e0 0b 00 00       	mov    0xbe0,%eax
}
 83c:	c9                   	leave  
 83d:	c3                   	ret    

0000083e <malloc>:

void*
malloc(uint nbytes)
{
 83e:	55                   	push   %ebp
 83f:	89 e5                	mov    %esp,%ebp
 841:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 844:	8b 45 08             	mov    0x8(%ebp),%eax
 847:	83 c0 07             	add    $0x7,%eax
 84a:	c1 e8 03             	shr    $0x3,%eax
 84d:	83 c0 01             	add    $0x1,%eax
 850:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 853:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 858:	89 45 f0             	mov    %eax,-0x10(%ebp)
 85b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 85f:	75 23                	jne    884 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 861:	c7 45 f0 d8 0b 00 00 	movl   $0xbd8,-0x10(%ebp)
 868:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86b:	a3 e0 0b 00 00       	mov    %eax,0xbe0
 870:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 875:	a3 d8 0b 00 00       	mov    %eax,0xbd8
    base.s.size = 0;
 87a:	c7 05 dc 0b 00 00 00 	movl   $0x0,0xbdc
 881:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 884:	8b 45 f0             	mov    -0x10(%ebp),%eax
 887:	8b 00                	mov    (%eax),%eax
 889:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	8b 40 04             	mov    0x4(%eax),%eax
 892:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 895:	72 4d                	jb     8e4 <malloc+0xa6>
      if(p->s.size == nunits)
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	8b 40 04             	mov    0x4(%eax),%eax
 89d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a0:	75 0c                	jne    8ae <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a5:	8b 10                	mov    (%eax),%edx
 8a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8aa:	89 10                	mov    %edx,(%eax)
 8ac:	eb 26                	jmp    8d4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b1:	8b 40 04             	mov    0x4(%eax),%eax
 8b4:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8b7:	89 c2                	mov    %eax,%edx
 8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c2:	8b 40 04             	mov    0x4(%eax),%eax
 8c5:	c1 e0 03             	shl    $0x3,%eax
 8c8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8d1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d7:	a3 e0 0b 00 00       	mov    %eax,0xbe0
      return (void*)(p + 1);
 8dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8df:	83 c0 08             	add    $0x8,%eax
 8e2:	eb 38                	jmp    91c <malloc+0xde>
    }
    if(p == freep)
 8e4:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 8e9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8ec:	75 1b                	jne    909 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8f1:	89 04 24             	mov    %eax,(%esp)
 8f4:	e8 ed fe ff ff       	call   7e6 <morecore>
 8f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 900:	75 07                	jne    909 <malloc+0xcb>
        return 0;
 902:	b8 00 00 00 00       	mov    $0x0,%eax
 907:	eb 13                	jmp    91c <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 909:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 912:	8b 00                	mov    (%eax),%eax
 914:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 917:	e9 70 ff ff ff       	jmp    88c <malloc+0x4e>
}
 91c:	c9                   	leave  
 91d:	c3                   	ret    
