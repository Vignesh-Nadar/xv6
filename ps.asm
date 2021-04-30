
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(void){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
  processstatus();
   6:	e8 15 03 00 00       	call   320 <processstatus>
  exit();
   b:	e8 68 02 00 00       	call   278 <exit>

00000010 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	57                   	push   %edi
  14:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  18:	8b 55 10             	mov    0x10(%ebp),%edx
  1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  1e:	89 cb                	mov    %ecx,%ebx
  20:	89 df                	mov    %ebx,%edi
  22:	89 d1                	mov    %edx,%ecx
  24:	fc                   	cld    
  25:	f3 aa                	rep stos %al,%es:(%edi)
  27:	89 ca                	mov    %ecx,%edx
  29:	89 fb                	mov    %edi,%ebx
  2b:	89 5d 08             	mov    %ebx,0x8(%ebp)
  2e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  31:	5b                   	pop    %ebx
  32:	5f                   	pop    %edi
  33:	5d                   	pop    %ebp
  34:	c3                   	ret    

00000035 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  35:	55                   	push   %ebp
  36:	89 e5                	mov    %esp,%ebp
  38:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  3b:	8b 45 08             	mov    0x8(%ebp),%eax
  3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  41:	90                   	nop
  42:	8b 45 08             	mov    0x8(%ebp),%eax
  45:	8d 50 01             	lea    0x1(%eax),%edx
  48:	89 55 08             	mov    %edx,0x8(%ebp)
  4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  4e:	8d 4a 01             	lea    0x1(%edx),%ecx
  51:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  54:	0f b6 12             	movzbl (%edx),%edx
  57:	88 10                	mov    %dl,(%eax)
  59:	0f b6 00             	movzbl (%eax),%eax
  5c:	84 c0                	test   %al,%al
  5e:	75 e2                	jne    42 <strcpy+0xd>
    ;
  return os;
  60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  63:	c9                   	leave  
  64:	c3                   	ret    

00000065 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  68:	eb 08                	jmp    72 <strcmp+0xd>
    p++, q++;
  6a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  6e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  72:	8b 45 08             	mov    0x8(%ebp),%eax
  75:	0f b6 00             	movzbl (%eax),%eax
  78:	84 c0                	test   %al,%al
  7a:	74 10                	je     8c <strcmp+0x27>
  7c:	8b 45 08             	mov    0x8(%ebp),%eax
  7f:	0f b6 10             	movzbl (%eax),%edx
  82:	8b 45 0c             	mov    0xc(%ebp),%eax
  85:	0f b6 00             	movzbl (%eax),%eax
  88:	38 c2                	cmp    %al,%dl
  8a:	74 de                	je     6a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  8c:	8b 45 08             	mov    0x8(%ebp),%eax
  8f:	0f b6 00             	movzbl (%eax),%eax
  92:	0f b6 d0             	movzbl %al,%edx
  95:	8b 45 0c             	mov    0xc(%ebp),%eax
  98:	0f b6 00             	movzbl (%eax),%eax
  9b:	0f b6 c0             	movzbl %al,%eax
  9e:	29 c2                	sub    %eax,%edx
  a0:	89 d0                	mov    %edx,%eax
}
  a2:	5d                   	pop    %ebp
  a3:	c3                   	ret    

000000a4 <strlen>:

uint
strlen(char *s)
{
  a4:	55                   	push   %ebp
  a5:	89 e5                	mov    %esp,%ebp
  a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  b1:	eb 04                	jmp    b7 <strlen+0x13>
  b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  ba:	8b 45 08             	mov    0x8(%ebp),%eax
  bd:	01 d0                	add    %edx,%eax
  bf:	0f b6 00             	movzbl (%eax),%eax
  c2:	84 c0                	test   %al,%al
  c4:	75 ed                	jne    b3 <strlen+0xf>
    ;
  return n;
  c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c9:	c9                   	leave  
  ca:	c3                   	ret    

000000cb <memset>:

void*
memset(void *dst, int c, uint n)
{
  cb:	55                   	push   %ebp
  cc:	89 e5                	mov    %esp,%ebp
  ce:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  d1:	8b 45 10             	mov    0x10(%ebp),%eax
  d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	89 44 24 04          	mov    %eax,0x4(%esp)
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	89 04 24             	mov    %eax,(%esp)
  e5:	e8 26 ff ff ff       	call   10 <stosb>
  return dst;
  ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  ed:	c9                   	leave  
  ee:	c3                   	ret    

000000ef <strchr>:

char*
strchr(const char *s, char c)
{
  ef:	55                   	push   %ebp
  f0:	89 e5                	mov    %esp,%ebp
  f2:	83 ec 04             	sub    $0x4,%esp
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
  fb:	eb 14                	jmp    111 <strchr+0x22>
    if(*s == c)
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
 100:	0f b6 00             	movzbl (%eax),%eax
 103:	3a 45 fc             	cmp    -0x4(%ebp),%al
 106:	75 05                	jne    10d <strchr+0x1e>
      return (char*)s;
 108:	8b 45 08             	mov    0x8(%ebp),%eax
 10b:	eb 13                	jmp    120 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 10d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	0f b6 00             	movzbl (%eax),%eax
 117:	84 c0                	test   %al,%al
 119:	75 e2                	jne    fd <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 11b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 120:	c9                   	leave  
 121:	c3                   	ret    

00000122 <gets>:

char*
gets(char *buf, int max)
{
 122:	55                   	push   %ebp
 123:	89 e5                	mov    %esp,%ebp
 125:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 128:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 12f:	eb 4c                	jmp    17d <gets+0x5b>
    cc = read(0, &c, 1);
 131:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 138:	00 
 139:	8d 45 ef             	lea    -0x11(%ebp),%eax
 13c:	89 44 24 04          	mov    %eax,0x4(%esp)
 140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 147:	e8 44 01 00 00       	call   290 <read>
 14c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 14f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 153:	7f 02                	jg     157 <gets+0x35>
      break;
 155:	eb 31                	jmp    188 <gets+0x66>
    buf[i++] = c;
 157:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15a:	8d 50 01             	lea    0x1(%eax),%edx
 15d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 160:	89 c2                	mov    %eax,%edx
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	01 c2                	add    %eax,%edx
 167:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 16d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 171:	3c 0a                	cmp    $0xa,%al
 173:	74 13                	je     188 <gets+0x66>
 175:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 179:	3c 0d                	cmp    $0xd,%al
 17b:	74 0b                	je     188 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 180:	83 c0 01             	add    $0x1,%eax
 183:	3b 45 0c             	cmp    0xc(%ebp),%eax
 186:	7c a9                	jl     131 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 188:	8b 55 f4             	mov    -0xc(%ebp),%edx
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	01 d0                	add    %edx,%eax
 190:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 193:	8b 45 08             	mov    0x8(%ebp),%eax
}
 196:	c9                   	leave  
 197:	c3                   	ret    

00000198 <stat>:

int
stat(char *n, struct stat *st)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1a5:	00 
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	89 04 24             	mov    %eax,(%esp)
 1ac:	e8 07 01 00 00       	call   2b8 <open>
 1b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b8:	79 07                	jns    1c1 <stat+0x29>
    return -1;
 1ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1bf:	eb 23                	jmp    1e4 <stat+0x4c>
  r = fstat(fd, st);
 1c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cb:	89 04 24             	mov    %eax,(%esp)
 1ce:	e8 fd 00 00 00       	call   2d0 <fstat>
 1d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d9:	89 04 24             	mov    %eax,(%esp)
 1dc:	e8 bf 00 00 00       	call   2a0 <close>
  return r;
 1e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e4:	c9                   	leave  
 1e5:	c3                   	ret    

000001e6 <atoi>:

int
atoi(const char *s)
{
 1e6:	55                   	push   %ebp
 1e7:	89 e5                	mov    %esp,%ebp
 1e9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1f3:	eb 25                	jmp    21a <atoi+0x34>
    n = n*10 + *s++ - '0';
 1f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f8:	89 d0                	mov    %edx,%eax
 1fa:	c1 e0 02             	shl    $0x2,%eax
 1fd:	01 d0                	add    %edx,%eax
 1ff:	01 c0                	add    %eax,%eax
 201:	89 c1                	mov    %eax,%ecx
 203:	8b 45 08             	mov    0x8(%ebp),%eax
 206:	8d 50 01             	lea    0x1(%eax),%edx
 209:	89 55 08             	mov    %edx,0x8(%ebp)
 20c:	0f b6 00             	movzbl (%eax),%eax
 20f:	0f be c0             	movsbl %al,%eax
 212:	01 c8                	add    %ecx,%eax
 214:	83 e8 30             	sub    $0x30,%eax
 217:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	0f b6 00             	movzbl (%eax),%eax
 220:	3c 2f                	cmp    $0x2f,%al
 222:	7e 0a                	jle    22e <atoi+0x48>
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	0f b6 00             	movzbl (%eax),%eax
 22a:	3c 39                	cmp    $0x39,%al
 22c:	7e c7                	jle    1f5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 22e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 231:	c9                   	leave  
 232:	c3                   	ret    

00000233 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
 236:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 23f:	8b 45 0c             	mov    0xc(%ebp),%eax
 242:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 245:	eb 17                	jmp    25e <memmove+0x2b>
    *dst++ = *src++;
 247:	8b 45 fc             	mov    -0x4(%ebp),%eax
 24a:	8d 50 01             	lea    0x1(%eax),%edx
 24d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 250:	8b 55 f8             	mov    -0x8(%ebp),%edx
 253:	8d 4a 01             	lea    0x1(%edx),%ecx
 256:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 259:	0f b6 12             	movzbl (%edx),%edx
 25c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25e:	8b 45 10             	mov    0x10(%ebp),%eax
 261:	8d 50 ff             	lea    -0x1(%eax),%edx
 264:	89 55 10             	mov    %edx,0x10(%ebp)
 267:	85 c0                	test   %eax,%eax
 269:	7f dc                	jg     247 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26e:	c9                   	leave  
 26f:	c3                   	ret    

00000270 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 270:	b8 01 00 00 00       	mov    $0x1,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <exit>:
SYSCALL(exit)
 278:	b8 02 00 00 00       	mov    $0x2,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <wait>:
SYSCALL(wait)
 280:	b8 03 00 00 00       	mov    $0x3,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <pipe>:
SYSCALL(pipe)
 288:	b8 04 00 00 00       	mov    $0x4,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <read>:
SYSCALL(read)
 290:	b8 05 00 00 00       	mov    $0x5,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <write>:
SYSCALL(write)
 298:	b8 10 00 00 00       	mov    $0x10,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <close>:
SYSCALL(close)
 2a0:	b8 15 00 00 00       	mov    $0x15,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <kill>:
SYSCALL(kill)
 2a8:	b8 06 00 00 00       	mov    $0x6,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <exec>:
SYSCALL(exec)
 2b0:	b8 07 00 00 00       	mov    $0x7,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <open>:
SYSCALL(open)
 2b8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <mknod>:
SYSCALL(mknod)
 2c0:	b8 11 00 00 00       	mov    $0x11,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <unlink>:
SYSCALL(unlink)
 2c8:	b8 12 00 00 00       	mov    $0x12,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <fstat>:
SYSCALL(fstat)
 2d0:	b8 08 00 00 00       	mov    $0x8,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <link>:
SYSCALL(link)
 2d8:	b8 13 00 00 00       	mov    $0x13,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <mkdir>:
SYSCALL(mkdir)
 2e0:	b8 14 00 00 00       	mov    $0x14,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <chdir>:
SYSCALL(chdir)
 2e8:	b8 09 00 00 00       	mov    $0x9,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <dup>:
SYSCALL(dup)
 2f0:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <getpid>:
SYSCALL(getpid)
 2f8:	b8 0b 00 00 00       	mov    $0xb,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <sbrk>:
SYSCALL(sbrk)
 300:	b8 0c 00 00 00       	mov    $0xc,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <sleep>:
SYSCALL(sleep)
 308:	b8 0d 00 00 00       	mov    $0xd,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <uptime>:
SYSCALL(uptime)
 310:	b8 0e 00 00 00       	mov    $0xe,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <changepriority>:
SYSCALL(changepriority)
 318:	b8 16 00 00 00       	mov    $0x16,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <processstatus>:
SYSCALL(processstatus)
 320:	b8 17 00 00 00       	mov    $0x17,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <randomgen>:
SYSCALL(randomgen)
 328:	b8 18 00 00 00       	mov    $0x18,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <randomgenrange>:
SYSCALL(randomgenrange)
 330:	b8 19 00 00 00       	mov    $0x19,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	83 ec 18             	sub    $0x18,%esp
 33e:	8b 45 0c             	mov    0xc(%ebp),%eax
 341:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 344:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 34b:	00 
 34c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 34f:	89 44 24 04          	mov    %eax,0x4(%esp)
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	89 04 24             	mov    %eax,(%esp)
 359:	e8 3a ff ff ff       	call   298 <write>
}
 35e:	c9                   	leave  
 35f:	c3                   	ret    

00000360 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	56                   	push   %esi
 364:	53                   	push   %ebx
 365:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 368:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 36f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 373:	74 17                	je     38c <printint+0x2c>
 375:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 379:	79 11                	jns    38c <printint+0x2c>
    neg = 1;
 37b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 382:	8b 45 0c             	mov    0xc(%ebp),%eax
 385:	f7 d8                	neg    %eax
 387:	89 45 ec             	mov    %eax,-0x14(%ebp)
 38a:	eb 06                	jmp    392 <printint+0x32>
  } else {
    x = xx;
 38c:	8b 45 0c             	mov    0xc(%ebp),%eax
 38f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 392:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 399:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 39c:	8d 41 01             	lea    0x1(%ecx),%eax
 39f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a8:	ba 00 00 00 00       	mov    $0x0,%edx
 3ad:	f7 f3                	div    %ebx
 3af:	89 d0                	mov    %edx,%eax
 3b1:	0f b6 80 30 0a 00 00 	movzbl 0xa30(%eax),%eax
 3b8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3bc:	8b 75 10             	mov    0x10(%ebp),%esi
 3bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c2:	ba 00 00 00 00       	mov    $0x0,%edx
 3c7:	f7 f6                	div    %esi
 3c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3d0:	75 c7                	jne    399 <printint+0x39>
  if(neg)
 3d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3d6:	74 10                	je     3e8 <printint+0x88>
    buf[i++] = '-';
 3d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3db:	8d 50 01             	lea    0x1(%eax),%edx
 3de:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3e1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3e6:	eb 1f                	jmp    407 <printint+0xa7>
 3e8:	eb 1d                	jmp    407 <printint+0xa7>
    putc(fd, buf[i]);
 3ea:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f0:	01 d0                	add    %edx,%eax
 3f2:	0f b6 00             	movzbl (%eax),%eax
 3f5:	0f be c0             	movsbl %al,%eax
 3f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
 3ff:	89 04 24             	mov    %eax,(%esp)
 402:	e8 31 ff ff ff       	call   338 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 407:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 40b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 40f:	79 d9                	jns    3ea <printint+0x8a>
    putc(fd, buf[i]);
}
 411:	83 c4 30             	add    $0x30,%esp
 414:	5b                   	pop    %ebx
 415:	5e                   	pop    %esi
 416:	5d                   	pop    %ebp
 417:	c3                   	ret    

00000418 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 41e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 425:	8d 45 0c             	lea    0xc(%ebp),%eax
 428:	83 c0 04             	add    $0x4,%eax
 42b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 42e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 435:	e9 7c 01 00 00       	jmp    5b6 <printf+0x19e>
    c = fmt[i] & 0xff;
 43a:	8b 55 0c             	mov    0xc(%ebp),%edx
 43d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 440:	01 d0                	add    %edx,%eax
 442:	0f b6 00             	movzbl (%eax),%eax
 445:	0f be c0             	movsbl %al,%eax
 448:	25 ff 00 00 00       	and    $0xff,%eax
 44d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 450:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 454:	75 2c                	jne    482 <printf+0x6a>
      if(c == '%'){
 456:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 45a:	75 0c                	jne    468 <printf+0x50>
        state = '%';
 45c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 463:	e9 4a 01 00 00       	jmp    5b2 <printf+0x19a>
      } else {
        putc(fd, c);
 468:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 46b:	0f be c0             	movsbl %al,%eax
 46e:	89 44 24 04          	mov    %eax,0x4(%esp)
 472:	8b 45 08             	mov    0x8(%ebp),%eax
 475:	89 04 24             	mov    %eax,(%esp)
 478:	e8 bb fe ff ff       	call   338 <putc>
 47d:	e9 30 01 00 00       	jmp    5b2 <printf+0x19a>
      }
    } else if(state == '%'){
 482:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 486:	0f 85 26 01 00 00    	jne    5b2 <printf+0x19a>
      if(c == 'd'){
 48c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 490:	75 2d                	jne    4bf <printf+0xa7>
        printint(fd, *ap, 10, 1);
 492:	8b 45 e8             	mov    -0x18(%ebp),%eax
 495:	8b 00                	mov    (%eax),%eax
 497:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 49e:	00 
 49f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4a6:	00 
 4a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ab:	8b 45 08             	mov    0x8(%ebp),%eax
 4ae:	89 04 24             	mov    %eax,(%esp)
 4b1:	e8 aa fe ff ff       	call   360 <printint>
        ap++;
 4b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ba:	e9 ec 00 00 00       	jmp    5ab <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 4bf:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4c3:	74 06                	je     4cb <printf+0xb3>
 4c5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4c9:	75 2d                	jne    4f8 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 4cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ce:	8b 00                	mov    (%eax),%eax
 4d0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4d7:	00 
 4d8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4df:	00 
 4e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	89 04 24             	mov    %eax,(%esp)
 4ea:	e8 71 fe ff ff       	call   360 <printint>
        ap++;
 4ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f3:	e9 b3 00 00 00       	jmp    5ab <printf+0x193>
      } else if(c == 's'){
 4f8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4fc:	75 45                	jne    543 <printf+0x12b>
        s = (char*)*ap;
 4fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 501:	8b 00                	mov    (%eax),%eax
 503:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 506:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 50a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 50e:	75 09                	jne    519 <printf+0x101>
          s = "(null)";
 510:	c7 45 f4 e4 07 00 00 	movl   $0x7e4,-0xc(%ebp)
        while(*s != 0){
 517:	eb 1e                	jmp    537 <printf+0x11f>
 519:	eb 1c                	jmp    537 <printf+0x11f>
          putc(fd, *s);
 51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51e:	0f b6 00             	movzbl (%eax),%eax
 521:	0f be c0             	movsbl %al,%eax
 524:	89 44 24 04          	mov    %eax,0x4(%esp)
 528:	8b 45 08             	mov    0x8(%ebp),%eax
 52b:	89 04 24             	mov    %eax,(%esp)
 52e:	e8 05 fe ff ff       	call   338 <putc>
          s++;
 533:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 537:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53a:	0f b6 00             	movzbl (%eax),%eax
 53d:	84 c0                	test   %al,%al
 53f:	75 da                	jne    51b <printf+0x103>
 541:	eb 68                	jmp    5ab <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 543:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 547:	75 1d                	jne    566 <printf+0x14e>
        putc(fd, *ap);
 549:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54c:	8b 00                	mov    (%eax),%eax
 54e:	0f be c0             	movsbl %al,%eax
 551:	89 44 24 04          	mov    %eax,0x4(%esp)
 555:	8b 45 08             	mov    0x8(%ebp),%eax
 558:	89 04 24             	mov    %eax,(%esp)
 55b:	e8 d8 fd ff ff       	call   338 <putc>
        ap++;
 560:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 564:	eb 45                	jmp    5ab <printf+0x193>
      } else if(c == '%'){
 566:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 56a:	75 17                	jne    583 <printf+0x16b>
        putc(fd, c);
 56c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56f:	0f be c0             	movsbl %al,%eax
 572:	89 44 24 04          	mov    %eax,0x4(%esp)
 576:	8b 45 08             	mov    0x8(%ebp),%eax
 579:	89 04 24             	mov    %eax,(%esp)
 57c:	e8 b7 fd ff ff       	call   338 <putc>
 581:	eb 28                	jmp    5ab <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 583:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 58a:	00 
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	89 04 24             	mov    %eax,(%esp)
 591:	e8 a2 fd ff ff       	call   338 <putc>
        putc(fd, c);
 596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 599:	0f be c0             	movsbl %al,%eax
 59c:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a0:	8b 45 08             	mov    0x8(%ebp),%eax
 5a3:	89 04 24             	mov    %eax,(%esp)
 5a6:	e8 8d fd ff ff       	call   338 <putc>
      }
      state = 0;
 5ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5b6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5bc:	01 d0                	add    %edx,%eax
 5be:	0f b6 00             	movzbl (%eax),%eax
 5c1:	84 c0                	test   %al,%al
 5c3:	0f 85 71 fe ff ff    	jne    43a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5c9:	c9                   	leave  
 5ca:	c3                   	ret    

000005cb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5cb:	55                   	push   %ebp
 5cc:	89 e5                	mov    %esp,%ebp
 5ce:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d1:	8b 45 08             	mov    0x8(%ebp),%eax
 5d4:	83 e8 08             	sub    $0x8,%eax
 5d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5da:	a1 4c 0a 00 00       	mov    0xa4c,%eax
 5df:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e2:	eb 24                	jmp    608 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e7:	8b 00                	mov    (%eax),%eax
 5e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ec:	77 12                	ja     600 <free+0x35>
 5ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f4:	77 24                	ja     61a <free+0x4f>
 5f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f9:	8b 00                	mov    (%eax),%eax
 5fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5fe:	77 1a                	ja     61a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 600:	8b 45 fc             	mov    -0x4(%ebp),%eax
 603:	8b 00                	mov    (%eax),%eax
 605:	89 45 fc             	mov    %eax,-0x4(%ebp)
 608:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60e:	76 d4                	jbe    5e4 <free+0x19>
 610:	8b 45 fc             	mov    -0x4(%ebp),%eax
 613:	8b 00                	mov    (%eax),%eax
 615:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 618:	76 ca                	jbe    5e4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 61a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61d:	8b 40 04             	mov    0x4(%eax),%eax
 620:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 627:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62a:	01 c2                	add    %eax,%edx
 62c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62f:	8b 00                	mov    (%eax),%eax
 631:	39 c2                	cmp    %eax,%edx
 633:	75 24                	jne    659 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 635:	8b 45 f8             	mov    -0x8(%ebp),%eax
 638:	8b 50 04             	mov    0x4(%eax),%edx
 63b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63e:	8b 00                	mov    (%eax),%eax
 640:	8b 40 04             	mov    0x4(%eax),%eax
 643:	01 c2                	add    %eax,%edx
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 64b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64e:	8b 00                	mov    (%eax),%eax
 650:	8b 10                	mov    (%eax),%edx
 652:	8b 45 f8             	mov    -0x8(%ebp),%eax
 655:	89 10                	mov    %edx,(%eax)
 657:	eb 0a                	jmp    663 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 10                	mov    (%eax),%edx
 65e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 661:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	8b 40 04             	mov    0x4(%eax),%eax
 669:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 670:	8b 45 fc             	mov    -0x4(%ebp),%eax
 673:	01 d0                	add    %edx,%eax
 675:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 678:	75 20                	jne    69a <free+0xcf>
    p->s.size += bp->s.size;
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	8b 50 04             	mov    0x4(%eax),%edx
 680:	8b 45 f8             	mov    -0x8(%ebp),%eax
 683:	8b 40 04             	mov    0x4(%eax),%eax
 686:	01 c2                	add    %eax,%edx
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 68e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 691:	8b 10                	mov    (%eax),%edx
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	89 10                	mov    %edx,(%eax)
 698:	eb 08                	jmp    6a2 <free+0xd7>
  } else
    p->s.ptr = bp;
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6a0:	89 10                	mov    %edx,(%eax)
  freep = p;
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	a3 4c 0a 00 00       	mov    %eax,0xa4c
}
 6aa:	c9                   	leave  
 6ab:	c3                   	ret    

000006ac <morecore>:

static Header*
morecore(uint nu)
{
 6ac:	55                   	push   %ebp
 6ad:	89 e5                	mov    %esp,%ebp
 6af:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6b2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6b9:	77 07                	ja     6c2 <morecore+0x16>
    nu = 4096;
 6bb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6c2:	8b 45 08             	mov    0x8(%ebp),%eax
 6c5:	c1 e0 03             	shl    $0x3,%eax
 6c8:	89 04 24             	mov    %eax,(%esp)
 6cb:	e8 30 fc ff ff       	call   300 <sbrk>
 6d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6d3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6d7:	75 07                	jne    6e0 <morecore+0x34>
    return 0;
 6d9:	b8 00 00 00 00       	mov    $0x0,%eax
 6de:	eb 22                	jmp    702 <morecore+0x56>
  hp = (Header*)p;
 6e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e9:	8b 55 08             	mov    0x8(%ebp),%edx
 6ec:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f2:	83 c0 08             	add    $0x8,%eax
 6f5:	89 04 24             	mov    %eax,(%esp)
 6f8:	e8 ce fe ff ff       	call   5cb <free>
  return freep;
 6fd:	a1 4c 0a 00 00       	mov    0xa4c,%eax
}
 702:	c9                   	leave  
 703:	c3                   	ret    

00000704 <malloc>:

void*
malloc(uint nbytes)
{
 704:	55                   	push   %ebp
 705:	89 e5                	mov    %esp,%ebp
 707:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 70a:	8b 45 08             	mov    0x8(%ebp),%eax
 70d:	83 c0 07             	add    $0x7,%eax
 710:	c1 e8 03             	shr    $0x3,%eax
 713:	83 c0 01             	add    $0x1,%eax
 716:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 719:	a1 4c 0a 00 00       	mov    0xa4c,%eax
 71e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 721:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 725:	75 23                	jne    74a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 727:	c7 45 f0 44 0a 00 00 	movl   $0xa44,-0x10(%ebp)
 72e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 731:	a3 4c 0a 00 00       	mov    %eax,0xa4c
 736:	a1 4c 0a 00 00       	mov    0xa4c,%eax
 73b:	a3 44 0a 00 00       	mov    %eax,0xa44
    base.s.size = 0;
 740:	c7 05 48 0a 00 00 00 	movl   $0x0,0xa48
 747:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74d:	8b 00                	mov    (%eax),%eax
 74f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	8b 40 04             	mov    0x4(%eax),%eax
 758:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 75b:	72 4d                	jb     7aa <malloc+0xa6>
      if(p->s.size == nunits)
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	8b 40 04             	mov    0x4(%eax),%eax
 763:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 766:	75 0c                	jne    774 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 768:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76b:	8b 10                	mov    (%eax),%edx
 76d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 770:	89 10                	mov    %edx,(%eax)
 772:	eb 26                	jmp    79a <malloc+0x96>
      else {
        p->s.size -= nunits;
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	8b 40 04             	mov    0x4(%eax),%eax
 77a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 77d:	89 c2                	mov    %eax,%edx
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 785:	8b 45 f4             	mov    -0xc(%ebp),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	c1 e0 03             	shl    $0x3,%eax
 78e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 791:	8b 45 f4             	mov    -0xc(%ebp),%eax
 794:	8b 55 ec             	mov    -0x14(%ebp),%edx
 797:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 79a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79d:	a3 4c 0a 00 00       	mov    %eax,0xa4c
      return (void*)(p + 1);
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	83 c0 08             	add    $0x8,%eax
 7a8:	eb 38                	jmp    7e2 <malloc+0xde>
    }
    if(p == freep)
 7aa:	a1 4c 0a 00 00       	mov    0xa4c,%eax
 7af:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7b2:	75 1b                	jne    7cf <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7b7:	89 04 24             	mov    %eax,(%esp)
 7ba:	e8 ed fe ff ff       	call   6ac <morecore>
 7bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c6:	75 07                	jne    7cf <malloc+0xcb>
        return 0;
 7c8:	b8 00 00 00 00       	mov    $0x0,%eax
 7cd:	eb 13                	jmp    7e2 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	8b 00                	mov    (%eax),%eax
 7da:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7dd:	e9 70 ff ff ff       	jmp    752 <malloc+0x4e>
}
 7e2:	c9                   	leave  
 7e3:	c3                   	ret    
