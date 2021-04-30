
_testrandom:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"
#include "fcntl.h"


int main(int argc, char *argv[]) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp

  int r,i;
  
  printf(1,"Printing 5 random numbers [default between 0 and (2^32 - 1) / 2, which is 2147483647] : \n");
   9:	c7 44 24 04 a4 08 00 	movl   $0x8a4,0x4(%esp)
  10:	00 
  11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  18:	e8 ba 04 00 00       	call   4d7 <printf>
  for(i=0;i<5;i++)
  1d:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  24:	00 
  25:	eb 2a                	jmp    51 <main+0x51>
  {
  	r = randomgen();
  27:	e8 bb 03 00 00       	call   3e7 <randomgen>
  2c:	89 44 24 18          	mov    %eax,0x18(%esp)
	printf(1,"%d  ",r);
  30:	8b 44 24 18          	mov    0x18(%esp),%eax
  34:	89 44 24 08          	mov    %eax,0x8(%esp)
  38:	c7 44 24 04 fe 08 00 	movl   $0x8fe,0x4(%esp)
  3f:	00 
  40:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  47:	e8 8b 04 00 00       	call   4d7 <printf>
int main(int argc, char *argv[]) {

  int r,i;
  
  printf(1,"Printing 5 random numbers [default between 0 and (2^32 - 1) / 2, which is 2147483647] : \n");
  for(i=0;i<5;i++)
  4c:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  51:	83 7c 24 1c 04       	cmpl   $0x4,0x1c(%esp)
  56:	7e cf                	jle    27 <main+0x27>
	printf(1,"%d  ",r);
         
  }

 
  printf(1,"\nPrinting 5 random numbers between 50 and 100 : \n");
  58:	c7 44 24 04 04 09 00 	movl   $0x904,0x4(%esp)
  5f:	00 
  60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  67:	e8 6b 04 00 00       	call   4d7 <printf>
  for(i=0;i<5;i++)
  6c:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  73:	00 
  74:	eb 39                	jmp    af <main+0xaf>
  {
  	r = randomgenrange(50,100);
  76:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  7d:	00 
  7e:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
  85:	e8 65 03 00 00       	call   3ef <randomgenrange>
  8a:	89 44 24 18          	mov    %eax,0x18(%esp)
	printf(1,"%d  ",r);
  8e:	8b 44 24 18          	mov    0x18(%esp),%eax
  92:	89 44 24 08          	mov    %eax,0x8(%esp)
  96:	c7 44 24 04 fe 08 00 	movl   $0x8fe,0x4(%esp)
  9d:	00 
  9e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a5:	e8 2d 04 00 00       	call   4d7 <printf>
         
  }

 
  printf(1,"\nPrinting 5 random numbers between 50 and 100 : \n");
  for(i=0;i<5;i++)
  aa:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  af:	83 7c 24 1c 04       	cmpl   $0x4,0x1c(%esp)
  b4:	7e c0                	jle    76 <main+0x76>
  {
  	r = randomgenrange(50,100);
	printf(1,"%d  ",r);
         
  }
  printf(1,"\n");
  b6:	c7 44 24 04 36 09 00 	movl   $0x936,0x4(%esp)
  bd:	00 
  be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c5:	e8 0d 04 00 00       	call   4d7 <printf>
  exit();
  ca:	e8 68 02 00 00       	call   337 <exit>

000000cf <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  cf:	55                   	push   %ebp
  d0:	89 e5                	mov    %esp,%ebp
  d2:	57                   	push   %edi
  d3:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  d7:	8b 55 10             	mov    0x10(%ebp),%edx
  da:	8b 45 0c             	mov    0xc(%ebp),%eax
  dd:	89 cb                	mov    %ecx,%ebx
  df:	89 df                	mov    %ebx,%edi
  e1:	89 d1                	mov    %edx,%ecx
  e3:	fc                   	cld    
  e4:	f3 aa                	rep stos %al,%es:(%edi)
  e6:	89 ca                	mov    %ecx,%edx
  e8:	89 fb                	mov    %edi,%ebx
  ea:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ed:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  f0:	5b                   	pop    %ebx
  f1:	5f                   	pop    %edi
  f2:	5d                   	pop    %ebp
  f3:	c3                   	ret    

000000f4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  f4:	55                   	push   %ebp
  f5:	89 e5                	mov    %esp,%ebp
  f7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  fa:	8b 45 08             	mov    0x8(%ebp),%eax
  fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 100:	90                   	nop
 101:	8b 45 08             	mov    0x8(%ebp),%eax
 104:	8d 50 01             	lea    0x1(%eax),%edx
 107:	89 55 08             	mov    %edx,0x8(%ebp)
 10a:	8b 55 0c             	mov    0xc(%ebp),%edx
 10d:	8d 4a 01             	lea    0x1(%edx),%ecx
 110:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 113:	0f b6 12             	movzbl (%edx),%edx
 116:	88 10                	mov    %dl,(%eax)
 118:	0f b6 00             	movzbl (%eax),%eax
 11b:	84 c0                	test   %al,%al
 11d:	75 e2                	jne    101 <strcpy+0xd>
    ;
  return os;
 11f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 122:	c9                   	leave  
 123:	c3                   	ret    

00000124 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 127:	eb 08                	jmp    131 <strcmp+0xd>
    p++, q++;
 129:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 12d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	0f b6 00             	movzbl (%eax),%eax
 137:	84 c0                	test   %al,%al
 139:	74 10                	je     14b <strcmp+0x27>
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	0f b6 10             	movzbl (%eax),%edx
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	0f b6 00             	movzbl (%eax),%eax
 147:	38 c2                	cmp    %al,%dl
 149:	74 de                	je     129 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	0f b6 00             	movzbl (%eax),%eax
 151:	0f b6 d0             	movzbl %al,%edx
 154:	8b 45 0c             	mov    0xc(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	0f b6 c0             	movzbl %al,%eax
 15d:	29 c2                	sub    %eax,%edx
 15f:	89 d0                	mov    %edx,%eax
}
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    

00000163 <strlen>:

uint
strlen(char *s)
{
 163:	55                   	push   %ebp
 164:	89 e5                	mov    %esp,%ebp
 166:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 169:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 170:	eb 04                	jmp    176 <strlen+0x13>
 172:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 176:	8b 55 fc             	mov    -0x4(%ebp),%edx
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	01 d0                	add    %edx,%eax
 17e:	0f b6 00             	movzbl (%eax),%eax
 181:	84 c0                	test   %al,%al
 183:	75 ed                	jne    172 <strlen+0xf>
    ;
  return n;
 185:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 188:	c9                   	leave  
 189:	c3                   	ret    

0000018a <memset>:

void*
memset(void *dst, int c, uint n)
{
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 190:	8b 45 10             	mov    0x10(%ebp),%eax
 193:	89 44 24 08          	mov    %eax,0x8(%esp)
 197:	8b 45 0c             	mov    0xc(%ebp),%eax
 19a:	89 44 24 04          	mov    %eax,0x4(%esp)
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	89 04 24             	mov    %eax,(%esp)
 1a4:	e8 26 ff ff ff       	call   cf <stosb>
  return dst;
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ac:	c9                   	leave  
 1ad:	c3                   	ret    

000001ae <strchr>:

char*
strchr(const char *s, char c)
{
 1ae:	55                   	push   %ebp
 1af:	89 e5                	mov    %esp,%ebp
 1b1:	83 ec 04             	sub    $0x4,%esp
 1b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ba:	eb 14                	jmp    1d0 <strchr+0x22>
    if(*s == c)
 1bc:	8b 45 08             	mov    0x8(%ebp),%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1c5:	75 05                	jne    1cc <strchr+0x1e>
      return (char*)s;
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	eb 13                	jmp    1df <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	84 c0                	test   %al,%al
 1d8:	75 e2                	jne    1bc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1da:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1df:	c9                   	leave  
 1e0:	c3                   	ret    

000001e1 <gets>:

char*
gets(char *buf, int max)
{
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ee:	eb 4c                	jmp    23c <gets+0x5b>
    cc = read(0, &c, 1);
 1f0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1f7:	00 
 1f8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 206:	e8 44 01 00 00       	call   34f <read>
 20b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 20e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 212:	7f 02                	jg     216 <gets+0x35>
      break;
 214:	eb 31                	jmp    247 <gets+0x66>
    buf[i++] = c;
 216:	8b 45 f4             	mov    -0xc(%ebp),%eax
 219:	8d 50 01             	lea    0x1(%eax),%edx
 21c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 21f:	89 c2                	mov    %eax,%edx
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	01 c2                	add    %eax,%edx
 226:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 22c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 230:	3c 0a                	cmp    $0xa,%al
 232:	74 13                	je     247 <gets+0x66>
 234:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 238:	3c 0d                	cmp    $0xd,%al
 23a:	74 0b                	je     247 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23f:	83 c0 01             	add    $0x1,%eax
 242:	3b 45 0c             	cmp    0xc(%ebp),%eax
 245:	7c a9                	jl     1f0 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 247:	8b 55 f4             	mov    -0xc(%ebp),%edx
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	01 d0                	add    %edx,%eax
 24f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 252:	8b 45 08             	mov    0x8(%ebp),%eax
}
 255:	c9                   	leave  
 256:	c3                   	ret    

00000257 <stat>:

int
stat(char *n, struct stat *st)
{
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
 25a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 264:	00 
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	89 04 24             	mov    %eax,(%esp)
 26b:	e8 07 01 00 00       	call   377 <open>
 270:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 273:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 277:	79 07                	jns    280 <stat+0x29>
    return -1;
 279:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 27e:	eb 23                	jmp    2a3 <stat+0x4c>
  r = fstat(fd, st);
 280:	8b 45 0c             	mov    0xc(%ebp),%eax
 283:	89 44 24 04          	mov    %eax,0x4(%esp)
 287:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28a:	89 04 24             	mov    %eax,(%esp)
 28d:	e8 fd 00 00 00       	call   38f <fstat>
 292:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 295:	8b 45 f4             	mov    -0xc(%ebp),%eax
 298:	89 04 24             	mov    %eax,(%esp)
 29b:	e8 bf 00 00 00       	call   35f <close>
  return r;
 2a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2a3:	c9                   	leave  
 2a4:	c3                   	ret    

000002a5 <atoi>:

int
atoi(const char *s)
{
 2a5:	55                   	push   %ebp
 2a6:	89 e5                	mov    %esp,%ebp
 2a8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2b2:	eb 25                	jmp    2d9 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2b7:	89 d0                	mov    %edx,%eax
 2b9:	c1 e0 02             	shl    $0x2,%eax
 2bc:	01 d0                	add    %edx,%eax
 2be:	01 c0                	add    %eax,%eax
 2c0:	89 c1                	mov    %eax,%ecx
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	8d 50 01             	lea    0x1(%eax),%edx
 2c8:	89 55 08             	mov    %edx,0x8(%ebp)
 2cb:	0f b6 00             	movzbl (%eax),%eax
 2ce:	0f be c0             	movsbl %al,%eax
 2d1:	01 c8                	add    %ecx,%eax
 2d3:	83 e8 30             	sub    $0x30,%eax
 2d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	0f b6 00             	movzbl (%eax),%eax
 2df:	3c 2f                	cmp    $0x2f,%al
 2e1:	7e 0a                	jle    2ed <atoi+0x48>
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	0f b6 00             	movzbl (%eax),%eax
 2e9:	3c 39                	cmp    $0x39,%al
 2eb:	7e c7                	jle    2b4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f0:	c9                   	leave  
 2f1:	c3                   	ret    

000002f2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2f2:	55                   	push   %ebp
 2f3:	89 e5                	mov    %esp,%ebp
 2f5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2f8:	8b 45 08             	mov    0x8(%ebp),%eax
 2fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 301:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 304:	eb 17                	jmp    31d <memmove+0x2b>
    *dst++ = *src++;
 306:	8b 45 fc             	mov    -0x4(%ebp),%eax
 309:	8d 50 01             	lea    0x1(%eax),%edx
 30c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 30f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 312:	8d 4a 01             	lea    0x1(%edx),%ecx
 315:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 318:	0f b6 12             	movzbl (%edx),%edx
 31b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 31d:	8b 45 10             	mov    0x10(%ebp),%eax
 320:	8d 50 ff             	lea    -0x1(%eax),%edx
 323:	89 55 10             	mov    %edx,0x10(%ebp)
 326:	85 c0                	test   %eax,%eax
 328:	7f dc                	jg     306 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 32d:	c9                   	leave  
 32e:	c3                   	ret    

0000032f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 32f:	b8 01 00 00 00       	mov    $0x1,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <exit>:
SYSCALL(exit)
 337:	b8 02 00 00 00       	mov    $0x2,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <wait>:
SYSCALL(wait)
 33f:	b8 03 00 00 00       	mov    $0x3,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <pipe>:
SYSCALL(pipe)
 347:	b8 04 00 00 00       	mov    $0x4,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <read>:
SYSCALL(read)
 34f:	b8 05 00 00 00       	mov    $0x5,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <write>:
SYSCALL(write)
 357:	b8 10 00 00 00       	mov    $0x10,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <close>:
SYSCALL(close)
 35f:	b8 15 00 00 00       	mov    $0x15,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <kill>:
SYSCALL(kill)
 367:	b8 06 00 00 00       	mov    $0x6,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <exec>:
SYSCALL(exec)
 36f:	b8 07 00 00 00       	mov    $0x7,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <open>:
SYSCALL(open)
 377:	b8 0f 00 00 00       	mov    $0xf,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <mknod>:
SYSCALL(mknod)
 37f:	b8 11 00 00 00       	mov    $0x11,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <unlink>:
SYSCALL(unlink)
 387:	b8 12 00 00 00       	mov    $0x12,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <fstat>:
SYSCALL(fstat)
 38f:	b8 08 00 00 00       	mov    $0x8,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <link>:
SYSCALL(link)
 397:	b8 13 00 00 00       	mov    $0x13,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <mkdir>:
SYSCALL(mkdir)
 39f:	b8 14 00 00 00       	mov    $0x14,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <chdir>:
SYSCALL(chdir)
 3a7:	b8 09 00 00 00       	mov    $0x9,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <dup>:
SYSCALL(dup)
 3af:	b8 0a 00 00 00       	mov    $0xa,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <getpid>:
SYSCALL(getpid)
 3b7:	b8 0b 00 00 00       	mov    $0xb,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <sbrk>:
SYSCALL(sbrk)
 3bf:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <sleep>:
SYSCALL(sleep)
 3c7:	b8 0d 00 00 00       	mov    $0xd,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <uptime>:
SYSCALL(uptime)
 3cf:	b8 0e 00 00 00       	mov    $0xe,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <changepriority>:
SYSCALL(changepriority)
 3d7:	b8 16 00 00 00       	mov    $0x16,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <processstatus>:
SYSCALL(processstatus)
 3df:	b8 17 00 00 00       	mov    $0x17,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <randomgen>:
SYSCALL(randomgen)
 3e7:	b8 18 00 00 00       	mov    $0x18,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <randomgenrange>:
SYSCALL(randomgenrange)
 3ef:	b8 19 00 00 00       	mov    $0x19,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3f7:	55                   	push   %ebp
 3f8:	89 e5                	mov    %esp,%ebp
 3fa:	83 ec 18             	sub    $0x18,%esp
 3fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 400:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 403:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 40a:	00 
 40b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 40e:	89 44 24 04          	mov    %eax,0x4(%esp)
 412:	8b 45 08             	mov    0x8(%ebp),%eax
 415:	89 04 24             	mov    %eax,(%esp)
 418:	e8 3a ff ff ff       	call   357 <write>
}
 41d:	c9                   	leave  
 41e:	c3                   	ret    

0000041f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41f:	55                   	push   %ebp
 420:	89 e5                	mov    %esp,%ebp
 422:	56                   	push   %esi
 423:	53                   	push   %ebx
 424:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 427:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 42e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 432:	74 17                	je     44b <printint+0x2c>
 434:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 438:	79 11                	jns    44b <printint+0x2c>
    neg = 1;
 43a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 441:	8b 45 0c             	mov    0xc(%ebp),%eax
 444:	f7 d8                	neg    %eax
 446:	89 45 ec             	mov    %eax,-0x14(%ebp)
 449:	eb 06                	jmp    451 <printint+0x32>
  } else {
    x = xx;
 44b:	8b 45 0c             	mov    0xc(%ebp),%eax
 44e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 451:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 458:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 45b:	8d 41 01             	lea    0x1(%ecx),%eax
 45e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 461:	8b 5d 10             	mov    0x10(%ebp),%ebx
 464:	8b 45 ec             	mov    -0x14(%ebp),%eax
 467:	ba 00 00 00 00       	mov    $0x0,%edx
 46c:	f7 f3                	div    %ebx
 46e:	89 d0                	mov    %edx,%eax
 470:	0f b6 80 84 0b 00 00 	movzbl 0xb84(%eax),%eax
 477:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 47b:	8b 75 10             	mov    0x10(%ebp),%esi
 47e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 481:	ba 00 00 00 00       	mov    $0x0,%edx
 486:	f7 f6                	div    %esi
 488:	89 45 ec             	mov    %eax,-0x14(%ebp)
 48b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48f:	75 c7                	jne    458 <printint+0x39>
  if(neg)
 491:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 495:	74 10                	je     4a7 <printint+0x88>
    buf[i++] = '-';
 497:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49a:	8d 50 01             	lea    0x1(%eax),%edx
 49d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4a5:	eb 1f                	jmp    4c6 <printint+0xa7>
 4a7:	eb 1d                	jmp    4c6 <printint+0xa7>
    putc(fd, buf[i]);
 4a9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4af:	01 d0                	add    %edx,%eax
 4b1:	0f b6 00             	movzbl (%eax),%eax
 4b4:	0f be c0             	movsbl %al,%eax
 4b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
 4be:	89 04 24             	mov    %eax,(%esp)
 4c1:	e8 31 ff ff ff       	call   3f7 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4c6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ce:	79 d9                	jns    4a9 <printint+0x8a>
    putc(fd, buf[i]);
}
 4d0:	83 c4 30             	add    $0x30,%esp
 4d3:	5b                   	pop    %ebx
 4d4:	5e                   	pop    %esi
 4d5:	5d                   	pop    %ebp
 4d6:	c3                   	ret    

000004d7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d7:	55                   	push   %ebp
 4d8:	89 e5                	mov    %esp,%ebp
 4da:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4dd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e4:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e7:	83 c0 04             	add    $0x4,%eax
 4ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f4:	e9 7c 01 00 00       	jmp    675 <printf+0x19e>
    c = fmt[i] & 0xff;
 4f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ff:	01 d0                	add    %edx,%eax
 501:	0f b6 00             	movzbl (%eax),%eax
 504:	0f be c0             	movsbl %al,%eax
 507:	25 ff 00 00 00       	and    $0xff,%eax
 50c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 50f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 513:	75 2c                	jne    541 <printf+0x6a>
      if(c == '%'){
 515:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 519:	75 0c                	jne    527 <printf+0x50>
        state = '%';
 51b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 522:	e9 4a 01 00 00       	jmp    671 <printf+0x19a>
      } else {
        putc(fd, c);
 527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 52a:	0f be c0             	movsbl %al,%eax
 52d:	89 44 24 04          	mov    %eax,0x4(%esp)
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	89 04 24             	mov    %eax,(%esp)
 537:	e8 bb fe ff ff       	call   3f7 <putc>
 53c:	e9 30 01 00 00       	jmp    671 <printf+0x19a>
      }
    } else if(state == '%'){
 541:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 545:	0f 85 26 01 00 00    	jne    671 <printf+0x19a>
      if(c == 'd'){
 54b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 54f:	75 2d                	jne    57e <printf+0xa7>
        printint(fd, *ap, 10, 1);
 551:	8b 45 e8             	mov    -0x18(%ebp),%eax
 554:	8b 00                	mov    (%eax),%eax
 556:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 55d:	00 
 55e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 565:	00 
 566:	89 44 24 04          	mov    %eax,0x4(%esp)
 56a:	8b 45 08             	mov    0x8(%ebp),%eax
 56d:	89 04 24             	mov    %eax,(%esp)
 570:	e8 aa fe ff ff       	call   41f <printint>
        ap++;
 575:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 579:	e9 ec 00 00 00       	jmp    66a <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 57e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 582:	74 06                	je     58a <printf+0xb3>
 584:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 588:	75 2d                	jne    5b7 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 58a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58d:	8b 00                	mov    (%eax),%eax
 58f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 596:	00 
 597:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 59e:	00 
 59f:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a3:	8b 45 08             	mov    0x8(%ebp),%eax
 5a6:	89 04 24             	mov    %eax,(%esp)
 5a9:	e8 71 fe ff ff       	call   41f <printint>
        ap++;
 5ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b2:	e9 b3 00 00 00       	jmp    66a <printf+0x193>
      } else if(c == 's'){
 5b7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5bb:	75 45                	jne    602 <printf+0x12b>
        s = (char*)*ap;
 5bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c0:	8b 00                	mov    (%eax),%eax
 5c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5cd:	75 09                	jne    5d8 <printf+0x101>
          s = "(null)";
 5cf:	c7 45 f4 38 09 00 00 	movl   $0x938,-0xc(%ebp)
        while(*s != 0){
 5d6:	eb 1e                	jmp    5f6 <printf+0x11f>
 5d8:	eb 1c                	jmp    5f6 <printf+0x11f>
          putc(fd, *s);
 5da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5dd:	0f b6 00             	movzbl (%eax),%eax
 5e0:	0f be c0             	movsbl %al,%eax
 5e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ea:	89 04 24             	mov    %eax,(%esp)
 5ed:	e8 05 fe ff ff       	call   3f7 <putc>
          s++;
 5f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f9:	0f b6 00             	movzbl (%eax),%eax
 5fc:	84 c0                	test   %al,%al
 5fe:	75 da                	jne    5da <printf+0x103>
 600:	eb 68                	jmp    66a <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 602:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 606:	75 1d                	jne    625 <printf+0x14e>
        putc(fd, *ap);
 608:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	0f be c0             	movsbl %al,%eax
 610:	89 44 24 04          	mov    %eax,0x4(%esp)
 614:	8b 45 08             	mov    0x8(%ebp),%eax
 617:	89 04 24             	mov    %eax,(%esp)
 61a:	e8 d8 fd ff ff       	call   3f7 <putc>
        ap++;
 61f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 623:	eb 45                	jmp    66a <printf+0x193>
      } else if(c == '%'){
 625:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 629:	75 17                	jne    642 <printf+0x16b>
        putc(fd, c);
 62b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62e:	0f be c0             	movsbl %al,%eax
 631:	89 44 24 04          	mov    %eax,0x4(%esp)
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	89 04 24             	mov    %eax,(%esp)
 63b:	e8 b7 fd ff ff       	call   3f7 <putc>
 640:	eb 28                	jmp    66a <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 642:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 649:	00 
 64a:	8b 45 08             	mov    0x8(%ebp),%eax
 64d:	89 04 24             	mov    %eax,(%esp)
 650:	e8 a2 fd ff ff       	call   3f7 <putc>
        putc(fd, c);
 655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 658:	0f be c0             	movsbl %al,%eax
 65b:	89 44 24 04          	mov    %eax,0x4(%esp)
 65f:	8b 45 08             	mov    0x8(%ebp),%eax
 662:	89 04 24             	mov    %eax,(%esp)
 665:	e8 8d fd ff ff       	call   3f7 <putc>
      }
      state = 0;
 66a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 671:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 675:	8b 55 0c             	mov    0xc(%ebp),%edx
 678:	8b 45 f0             	mov    -0x10(%ebp),%eax
 67b:	01 d0                	add    %edx,%eax
 67d:	0f b6 00             	movzbl (%eax),%eax
 680:	84 c0                	test   %al,%al
 682:	0f 85 71 fe ff ff    	jne    4f9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 688:	c9                   	leave  
 689:	c3                   	ret    

0000068a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 68a:	55                   	push   %ebp
 68b:	89 e5                	mov    %esp,%ebp
 68d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 690:	8b 45 08             	mov    0x8(%ebp),%eax
 693:	83 e8 08             	sub    $0x8,%eax
 696:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 699:	a1 a0 0b 00 00       	mov    0xba0,%eax
 69e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a1:	eb 24                	jmp    6c7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a6:	8b 00                	mov    (%eax),%eax
 6a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ab:	77 12                	ja     6bf <free+0x35>
 6ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b3:	77 24                	ja     6d9 <free+0x4f>
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 00                	mov    (%eax),%eax
 6ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bd:	77 1a                	ja     6d9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	8b 00                	mov    (%eax),%eax
 6c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cd:	76 d4                	jbe    6a3 <free+0x19>
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	8b 00                	mov    (%eax),%eax
 6d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d7:	76 ca                	jbe    6a3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dc:	8b 40 04             	mov    0x4(%eax),%eax
 6df:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e9:	01 c2                	add    %eax,%edx
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	8b 00                	mov    (%eax),%eax
 6f0:	39 c2                	cmp    %eax,%edx
 6f2:	75 24                	jne    718 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f7:	8b 50 04             	mov    0x4(%eax),%edx
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	8b 00                	mov    (%eax),%eax
 6ff:	8b 40 04             	mov    0x4(%eax),%eax
 702:	01 c2                	add    %eax,%edx
 704:	8b 45 f8             	mov    -0x8(%ebp),%eax
 707:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	8b 00                	mov    (%eax),%eax
 70f:	8b 10                	mov    (%eax),%edx
 711:	8b 45 f8             	mov    -0x8(%ebp),%eax
 714:	89 10                	mov    %edx,(%eax)
 716:	eb 0a                	jmp    722 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	8b 10                	mov    (%eax),%edx
 71d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 720:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	8b 40 04             	mov    0x4(%eax),%eax
 728:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 72f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 732:	01 d0                	add    %edx,%eax
 734:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 737:	75 20                	jne    759 <free+0xcf>
    p->s.size += bp->s.size;
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	8b 50 04             	mov    0x4(%eax),%edx
 73f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 742:	8b 40 04             	mov    0x4(%eax),%eax
 745:	01 c2                	add    %eax,%edx
 747:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 74d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 750:	8b 10                	mov    (%eax),%edx
 752:	8b 45 fc             	mov    -0x4(%ebp),%eax
 755:	89 10                	mov    %edx,(%eax)
 757:	eb 08                	jmp    761 <free+0xd7>
  } else
    p->s.ptr = bp;
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 75f:	89 10                	mov    %edx,(%eax)
  freep = p;
 761:	8b 45 fc             	mov    -0x4(%ebp),%eax
 764:	a3 a0 0b 00 00       	mov    %eax,0xba0
}
 769:	c9                   	leave  
 76a:	c3                   	ret    

0000076b <morecore>:

static Header*
morecore(uint nu)
{
 76b:	55                   	push   %ebp
 76c:	89 e5                	mov    %esp,%ebp
 76e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 771:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 778:	77 07                	ja     781 <morecore+0x16>
    nu = 4096;
 77a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 781:	8b 45 08             	mov    0x8(%ebp),%eax
 784:	c1 e0 03             	shl    $0x3,%eax
 787:	89 04 24             	mov    %eax,(%esp)
 78a:	e8 30 fc ff ff       	call   3bf <sbrk>
 78f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 792:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 796:	75 07                	jne    79f <morecore+0x34>
    return 0;
 798:	b8 00 00 00 00       	mov    $0x0,%eax
 79d:	eb 22                	jmp    7c1 <morecore+0x56>
  hp = (Header*)p;
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a8:	8b 55 08             	mov    0x8(%ebp),%edx
 7ab:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b1:	83 c0 08             	add    $0x8,%eax
 7b4:	89 04 24             	mov    %eax,(%esp)
 7b7:	e8 ce fe ff ff       	call   68a <free>
  return freep;
 7bc:	a1 a0 0b 00 00       	mov    0xba0,%eax
}
 7c1:	c9                   	leave  
 7c2:	c3                   	ret    

000007c3 <malloc>:

void*
malloc(uint nbytes)
{
 7c3:	55                   	push   %ebp
 7c4:	89 e5                	mov    %esp,%ebp
 7c6:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c9:	8b 45 08             	mov    0x8(%ebp),%eax
 7cc:	83 c0 07             	add    $0x7,%eax
 7cf:	c1 e8 03             	shr    $0x3,%eax
 7d2:	83 c0 01             	add    $0x1,%eax
 7d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7d8:	a1 a0 0b 00 00       	mov    0xba0,%eax
 7dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e4:	75 23                	jne    809 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7e6:	c7 45 f0 98 0b 00 00 	movl   $0xb98,-0x10(%ebp)
 7ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f0:	a3 a0 0b 00 00       	mov    %eax,0xba0
 7f5:	a1 a0 0b 00 00       	mov    0xba0,%eax
 7fa:	a3 98 0b 00 00       	mov    %eax,0xb98
    base.s.size = 0;
 7ff:	c7 05 9c 0b 00 00 00 	movl   $0x0,0xb9c
 806:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 809:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80c:	8b 00                	mov    (%eax),%eax
 80e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	8b 40 04             	mov    0x4(%eax),%eax
 817:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 81a:	72 4d                	jb     869 <malloc+0xa6>
      if(p->s.size == nunits)
 81c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81f:	8b 40 04             	mov    0x4(%eax),%eax
 822:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 825:	75 0c                	jne    833 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 827:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82a:	8b 10                	mov    (%eax),%edx
 82c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82f:	89 10                	mov    %edx,(%eax)
 831:	eb 26                	jmp    859 <malloc+0x96>
      else {
        p->s.size -= nunits;
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	8b 40 04             	mov    0x4(%eax),%eax
 839:	2b 45 ec             	sub    -0x14(%ebp),%eax
 83c:	89 c2                	mov    %eax,%edx
 83e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 841:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 844:	8b 45 f4             	mov    -0xc(%ebp),%eax
 847:	8b 40 04             	mov    0x4(%eax),%eax
 84a:	c1 e0 03             	shl    $0x3,%eax
 84d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 850:	8b 45 f4             	mov    -0xc(%ebp),%eax
 853:	8b 55 ec             	mov    -0x14(%ebp),%edx
 856:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 859:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85c:	a3 a0 0b 00 00       	mov    %eax,0xba0
      return (void*)(p + 1);
 861:	8b 45 f4             	mov    -0xc(%ebp),%eax
 864:	83 c0 08             	add    $0x8,%eax
 867:	eb 38                	jmp    8a1 <malloc+0xde>
    }
    if(p == freep)
 869:	a1 a0 0b 00 00       	mov    0xba0,%eax
 86e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 871:	75 1b                	jne    88e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 873:	8b 45 ec             	mov    -0x14(%ebp),%eax
 876:	89 04 24             	mov    %eax,(%esp)
 879:	e8 ed fe ff ff       	call   76b <morecore>
 87e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 881:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 885:	75 07                	jne    88e <malloc+0xcb>
        return 0;
 887:	b8 00 00 00 00       	mov    $0x0,%eax
 88c:	eb 13                	jmp    8a1 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 891:	89 45 f0             	mov    %eax,-0x10(%ebp)
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	8b 00                	mov    (%eax),%eax
 899:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 89c:	e9 70 ff ff ff       	jmp    811 <malloc+0x4e>
}
 8a1:	c9                   	leave  
 8a2:	c3                   	ret    
