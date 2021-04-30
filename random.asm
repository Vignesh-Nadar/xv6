
_random:     file format elf32-i386


Disassembly of section .text:

00000000 <randomgenerator>:
#include "defs.h"

// Return a integer between 0 and ((2^32 - 1) / 2), which is 2147483647.
uint
randomgenerator(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 10             	sub    $0x10,%esp
  static unsigned int z1 = 12345, z2 = 12345, z3 = 12345, z4 = 12345;
  unsigned int b;
  b  = ((z1 << 6) ^ z1) >> 13;
   6:	a1 5c 0b 00 00       	mov    0xb5c,%eax
   b:	c1 e0 06             	shl    $0x6,%eax
   e:	89 c2                	mov    %eax,%edx
  10:	a1 5c 0b 00 00       	mov    0xb5c,%eax
  15:	31 d0                	xor    %edx,%eax
  17:	c1 e8 0d             	shr    $0xd,%eax
  1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z1 = ((z1 & 4294967294U) << 18) ^ b;
  1d:	a1 5c 0b 00 00       	mov    0xb5c,%eax
  22:	83 e0 fe             	and    $0xfffffffe,%eax
  25:	c1 e0 12             	shl    $0x12,%eax
  28:	33 45 fc             	xor    -0x4(%ebp),%eax
  2b:	a3 5c 0b 00 00       	mov    %eax,0xb5c
  b  = ((z2 << 2) ^ z2) >> 27; 
  30:	a1 60 0b 00 00       	mov    0xb60,%eax
  35:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3c:	a1 60 0b 00 00       	mov    0xb60,%eax
  41:	31 d0                	xor    %edx,%eax
  43:	c1 e8 1b             	shr    $0x1b,%eax
  46:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z2 = ((z2 & 4294967288U) << 2) ^ b;
  49:	a1 60 0b 00 00       	mov    0xb60,%eax
  4e:	83 e0 f8             	and    $0xfffffff8,%eax
  51:	c1 e0 02             	shl    $0x2,%eax
  54:	33 45 fc             	xor    -0x4(%ebp),%eax
  57:	a3 60 0b 00 00       	mov    %eax,0xb60
  b  = ((z3 << 13) ^ z3) >> 21;
  5c:	a1 64 0b 00 00       	mov    0xb64,%eax
  61:	c1 e0 0d             	shl    $0xd,%eax
  64:	89 c2                	mov    %eax,%edx
  66:	a1 64 0b 00 00       	mov    0xb64,%eax
  6b:	31 d0                	xor    %edx,%eax
  6d:	c1 e8 15             	shr    $0x15,%eax
  70:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z3 = ((z3 & 4294967280U) << 7) ^ b;
  73:	a1 64 0b 00 00       	mov    0xb64,%eax
  78:	83 e0 f0             	and    $0xfffffff0,%eax
  7b:	c1 e0 07             	shl    $0x7,%eax
  7e:	33 45 fc             	xor    -0x4(%ebp),%eax
  81:	a3 64 0b 00 00       	mov    %eax,0xb64
  b  = ((z4 << 3) ^ z4) >> 12;
  86:	a1 68 0b 00 00       	mov    0xb68,%eax
  8b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  92:	a1 68 0b 00 00       	mov    0xb68,%eax
  97:	31 d0                	xor    %edx,%eax
  99:	c1 e8 0c             	shr    $0xc,%eax
  9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z4 = ((z4 & 4294967168U) << 13) ^ b;
  9f:	a1 68 0b 00 00       	mov    0xb68,%eax
  a4:	83 e0 80             	and    $0xffffff80,%eax
  a7:	c1 e0 0d             	shl    $0xd,%eax
  aa:	33 45 fc             	xor    -0x4(%ebp),%eax
  ad:	a3 68 0b 00 00       	mov    %eax,0xb68

  return (z1 ^ z2 ^ z3 ^ z4) / 2;
  b2:	8b 15 5c 0b 00 00    	mov    0xb5c,%edx
  b8:	a1 60 0b 00 00       	mov    0xb60,%eax
  bd:	31 c2                	xor    %eax,%edx
  bf:	a1 64 0b 00 00       	mov    0xb64,%eax
  c4:	31 c2                	xor    %eax,%edx
  c6:	a1 68 0b 00 00       	mov    0xb68,%eax
  cb:	31 d0                	xor    %edx,%eax
  cd:	d1 e8                	shr    %eax
}
  cf:	c9                   	leave  
  d0:	c3                   	ret    

000000d1 <randomgeneratorrange>:

int
randomgeneratorrange(int low, int high)
{
  d1:	55                   	push   %ebp
  d2:	89 e5                	mov    %esp,%ebp
  d4:	83 ec 10             	sub    $0x10,%esp
  if (high < low) {
  d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  da:	3b 45 08             	cmp    0x8(%ebp),%eax
  dd:	7d 12                	jge    f1 <randomgeneratorrange+0x20>
    int temp = low;
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    low = high;
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	89 45 08             	mov    %eax,0x8(%ebp)
    high = temp;
  eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  ee:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  int range = high - low + 1;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  f7:	29 c2                	sub    %eax,%edx
  f9:	89 d0                	mov    %edx,%eax
  fb:	83 c0 01             	add    $0x1,%eax
  fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
  return randomgenerator() % (range) + low;
 101:	e8 fa fe ff ff       	call   0 <randomgenerator>
 106:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 109:	ba 00 00 00 00       	mov    $0x0,%edx
 10e:	f7 f1                	div    %ecx
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	01 d0                	add    %edx,%eax
}
 115:	c9                   	leave  
 116:	c3                   	ret    

00000117 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 117:	55                   	push   %ebp
 118:	89 e5                	mov    %esp,%ebp
 11a:	57                   	push   %edi
 11b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 11c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11f:	8b 55 10             	mov    0x10(%ebp),%edx
 122:	8b 45 0c             	mov    0xc(%ebp),%eax
 125:	89 cb                	mov    %ecx,%ebx
 127:	89 df                	mov    %ebx,%edi
 129:	89 d1                	mov    %edx,%ecx
 12b:	fc                   	cld    
 12c:	f3 aa                	rep stos %al,%es:(%edi)
 12e:	89 ca                	mov    %ecx,%edx
 130:	89 fb                	mov    %edi,%ebx
 132:	89 5d 08             	mov    %ebx,0x8(%ebp)
 135:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 138:	5b                   	pop    %ebx
 139:	5f                   	pop    %edi
 13a:	5d                   	pop    %ebp
 13b:	c3                   	ret    

0000013c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 142:	8b 45 08             	mov    0x8(%ebp),%eax
 145:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 148:	90                   	nop
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	8d 50 01             	lea    0x1(%eax),%edx
 14f:	89 55 08             	mov    %edx,0x8(%ebp)
 152:	8b 55 0c             	mov    0xc(%ebp),%edx
 155:	8d 4a 01             	lea    0x1(%edx),%ecx
 158:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 15b:	0f b6 12             	movzbl (%edx),%edx
 15e:	88 10                	mov    %dl,(%eax)
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	84 c0                	test   %al,%al
 165:	75 e2                	jne    149 <strcpy+0xd>
    ;
  return os;
 167:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16a:	c9                   	leave  
 16b:	c3                   	ret    

0000016c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 16c:	55                   	push   %ebp
 16d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16f:	eb 08                	jmp    179 <strcmp+0xd>
    p++, q++;
 171:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 175:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	0f b6 00             	movzbl (%eax),%eax
 17f:	84 c0                	test   %al,%al
 181:	74 10                	je     193 <strcmp+0x27>
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	0f b6 10             	movzbl (%eax),%edx
 189:	8b 45 0c             	mov    0xc(%ebp),%eax
 18c:	0f b6 00             	movzbl (%eax),%eax
 18f:	38 c2                	cmp    %al,%dl
 191:	74 de                	je     171 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	0f b6 00             	movzbl (%eax),%eax
 199:	0f b6 d0             	movzbl %al,%edx
 19c:	8b 45 0c             	mov    0xc(%ebp),%eax
 19f:	0f b6 00             	movzbl (%eax),%eax
 1a2:	0f b6 c0             	movzbl %al,%eax
 1a5:	29 c2                	sub    %eax,%edx
 1a7:	89 d0                	mov    %edx,%eax
}
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    

000001ab <strlen>:

uint
strlen(char *s)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b8:	eb 04                	jmp    1be <strlen+0x13>
 1ba:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1be:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1c1:	8b 45 08             	mov    0x8(%ebp),%eax
 1c4:	01 d0                	add    %edx,%eax
 1c6:	0f b6 00             	movzbl (%eax),%eax
 1c9:	84 c0                	test   %al,%al
 1cb:	75 ed                	jne    1ba <strlen+0xf>
    ;
  return n;
 1cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d0:	c9                   	leave  
 1d1:	c3                   	ret    

000001d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d2:	55                   	push   %ebp
 1d3:	89 e5                	mov    %esp,%ebp
 1d5:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d8:	8b 45 10             	mov    0x10(%ebp),%eax
 1db:	89 44 24 08          	mov    %eax,0x8(%esp)
 1df:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
 1e9:	89 04 24             	mov    %eax,(%esp)
 1ec:	e8 26 ff ff ff       	call   117 <stosb>
  return dst;
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f4:	c9                   	leave  
 1f5:	c3                   	ret    

000001f6 <strchr>:

char*
strchr(const char *s, char c)
{
 1f6:	55                   	push   %ebp
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	83 ec 04             	sub    $0x4,%esp
 1fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ff:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 202:	eb 14                	jmp    218 <strchr+0x22>
    if(*s == c)
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 20d:	75 05                	jne    214 <strchr+0x1e>
      return (char*)s;
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	eb 13                	jmp    227 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 214:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	0f b6 00             	movzbl (%eax),%eax
 21e:	84 c0                	test   %al,%al
 220:	75 e2                	jne    204 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 222:	b8 00 00 00 00       	mov    $0x0,%eax
}
 227:	c9                   	leave  
 228:	c3                   	ret    

00000229 <gets>:

char*
gets(char *buf, int max)
{
 229:	55                   	push   %ebp
 22a:	89 e5                	mov    %esp,%ebp
 22c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 236:	eb 4c                	jmp    284 <gets+0x5b>
    cc = read(0, &c, 1);
 238:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 23f:	00 
 240:	8d 45 ef             	lea    -0x11(%ebp),%eax
 243:	89 44 24 04          	mov    %eax,0x4(%esp)
 247:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 24e:	e8 44 01 00 00       	call   397 <read>
 253:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 256:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 25a:	7f 02                	jg     25e <gets+0x35>
      break;
 25c:	eb 31                	jmp    28f <gets+0x66>
    buf[i++] = c;
 25e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 261:	8d 50 01             	lea    0x1(%eax),%edx
 264:	89 55 f4             	mov    %edx,-0xc(%ebp)
 267:	89 c2                	mov    %eax,%edx
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	01 c2                	add    %eax,%edx
 26e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 272:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 278:	3c 0a                	cmp    $0xa,%al
 27a:	74 13                	je     28f <gets+0x66>
 27c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 280:	3c 0d                	cmp    $0xd,%al
 282:	74 0b                	je     28f <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 284:	8b 45 f4             	mov    -0xc(%ebp),%eax
 287:	83 c0 01             	add    $0x1,%eax
 28a:	3b 45 0c             	cmp    0xc(%ebp),%eax
 28d:	7c a9                	jl     238 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 28f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	01 d0                	add    %edx,%eax
 297:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29d:	c9                   	leave  
 29e:	c3                   	ret    

0000029f <stat>:

int
stat(char *n, struct stat *st)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
 2a2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2ac:	00 
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	89 04 24             	mov    %eax,(%esp)
 2b3:	e8 07 01 00 00       	call   3bf <open>
 2b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2bf:	79 07                	jns    2c8 <stat+0x29>
    return -1;
 2c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c6:	eb 23                	jmp    2eb <stat+0x4c>
  r = fstat(fd, st);
 2c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 2cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d2:	89 04 24             	mov    %eax,(%esp)
 2d5:	e8 fd 00 00 00       	call   3d7 <fstat>
 2da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e0:	89 04 24             	mov    %eax,(%esp)
 2e3:	e8 bf 00 00 00       	call   3a7 <close>
  return r;
 2e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    

000002ed <atoi>:

int
atoi(const char *s)
{
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
 2f0:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2fa:	eb 25                	jmp    321 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ff:	89 d0                	mov    %edx,%eax
 301:	c1 e0 02             	shl    $0x2,%eax
 304:	01 d0                	add    %edx,%eax
 306:	01 c0                	add    %eax,%eax
 308:	89 c1                	mov    %eax,%ecx
 30a:	8b 45 08             	mov    0x8(%ebp),%eax
 30d:	8d 50 01             	lea    0x1(%eax),%edx
 310:	89 55 08             	mov    %edx,0x8(%ebp)
 313:	0f b6 00             	movzbl (%eax),%eax
 316:	0f be c0             	movsbl %al,%eax
 319:	01 c8                	add    %ecx,%eax
 31b:	83 e8 30             	sub    $0x30,%eax
 31e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 321:	8b 45 08             	mov    0x8(%ebp),%eax
 324:	0f b6 00             	movzbl (%eax),%eax
 327:	3c 2f                	cmp    $0x2f,%al
 329:	7e 0a                	jle    335 <atoi+0x48>
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	0f b6 00             	movzbl (%eax),%eax
 331:	3c 39                	cmp    $0x39,%al
 333:	7e c7                	jle    2fc <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 335:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 338:	c9                   	leave  
 339:	c3                   	ret    

0000033a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 33a:	55                   	push   %ebp
 33b:	89 e5                	mov    %esp,%ebp
 33d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 346:	8b 45 0c             	mov    0xc(%ebp),%eax
 349:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 34c:	eb 17                	jmp    365 <memmove+0x2b>
    *dst++ = *src++;
 34e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 351:	8d 50 01             	lea    0x1(%eax),%edx
 354:	89 55 fc             	mov    %edx,-0x4(%ebp)
 357:	8b 55 f8             	mov    -0x8(%ebp),%edx
 35a:	8d 4a 01             	lea    0x1(%edx),%ecx
 35d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 360:	0f b6 12             	movzbl (%edx),%edx
 363:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 365:	8b 45 10             	mov    0x10(%ebp),%eax
 368:	8d 50 ff             	lea    -0x1(%eax),%edx
 36b:	89 55 10             	mov    %edx,0x10(%ebp)
 36e:	85 c0                	test   %eax,%eax
 370:	7f dc                	jg     34e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 372:	8b 45 08             	mov    0x8(%ebp),%eax
}
 375:	c9                   	leave  
 376:	c3                   	ret    

00000377 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 377:	b8 01 00 00 00       	mov    $0x1,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <exit>:
SYSCALL(exit)
 37f:	b8 02 00 00 00       	mov    $0x2,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <wait>:
SYSCALL(wait)
 387:	b8 03 00 00 00       	mov    $0x3,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <pipe>:
SYSCALL(pipe)
 38f:	b8 04 00 00 00       	mov    $0x4,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <read>:
SYSCALL(read)
 397:	b8 05 00 00 00       	mov    $0x5,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <write>:
SYSCALL(write)
 39f:	b8 10 00 00 00       	mov    $0x10,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <close>:
SYSCALL(close)
 3a7:	b8 15 00 00 00       	mov    $0x15,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <kill>:
SYSCALL(kill)
 3af:	b8 06 00 00 00       	mov    $0x6,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <exec>:
SYSCALL(exec)
 3b7:	b8 07 00 00 00       	mov    $0x7,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <open>:
SYSCALL(open)
 3bf:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <mknod>:
SYSCALL(mknod)
 3c7:	b8 11 00 00 00       	mov    $0x11,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <unlink>:
SYSCALL(unlink)
 3cf:	b8 12 00 00 00       	mov    $0x12,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <fstat>:
SYSCALL(fstat)
 3d7:	b8 08 00 00 00       	mov    $0x8,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <link>:
SYSCALL(link)
 3df:	b8 13 00 00 00       	mov    $0x13,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <mkdir>:
SYSCALL(mkdir)
 3e7:	b8 14 00 00 00       	mov    $0x14,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <chdir>:
SYSCALL(chdir)
 3ef:	b8 09 00 00 00       	mov    $0x9,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <dup>:
SYSCALL(dup)
 3f7:	b8 0a 00 00 00       	mov    $0xa,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <getpid>:
SYSCALL(getpid)
 3ff:	b8 0b 00 00 00       	mov    $0xb,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <sbrk>:
SYSCALL(sbrk)
 407:	b8 0c 00 00 00       	mov    $0xc,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <sleep>:
SYSCALL(sleep)
 40f:	b8 0d 00 00 00       	mov    $0xd,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <uptime>:
SYSCALL(uptime)
 417:	b8 0e 00 00 00       	mov    $0xe,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <changepriority>:
SYSCALL(changepriority)
 41f:	b8 16 00 00 00       	mov    $0x16,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <processstatus>:
SYSCALL(processstatus)
 427:	b8 17 00 00 00       	mov    $0x17,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <randomgen>:
SYSCALL(randomgen)
 42f:	b8 18 00 00 00       	mov    $0x18,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <randomgenrange>:
SYSCALL(randomgenrange)
 437:	b8 19 00 00 00       	mov    $0x19,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	83 ec 18             	sub    $0x18,%esp
 445:	8b 45 0c             	mov    0xc(%ebp),%eax
 448:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 44b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 452:	00 
 453:	8d 45 f4             	lea    -0xc(%ebp),%eax
 456:	89 44 24 04          	mov    %eax,0x4(%esp)
 45a:	8b 45 08             	mov    0x8(%ebp),%eax
 45d:	89 04 24             	mov    %eax,(%esp)
 460:	e8 3a ff ff ff       	call   39f <write>
}
 465:	c9                   	leave  
 466:	c3                   	ret    

00000467 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 467:	55                   	push   %ebp
 468:	89 e5                	mov    %esp,%ebp
 46a:	56                   	push   %esi
 46b:	53                   	push   %ebx
 46c:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 46f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 476:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 47a:	74 17                	je     493 <printint+0x2c>
 47c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 480:	79 11                	jns    493 <printint+0x2c>
    neg = 1;
 482:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 489:	8b 45 0c             	mov    0xc(%ebp),%eax
 48c:	f7 d8                	neg    %eax
 48e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 491:	eb 06                	jmp    499 <printint+0x32>
  } else {
    x = xx;
 493:	8b 45 0c             	mov    0xc(%ebp),%eax
 496:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 499:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4a0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4a3:	8d 41 01             	lea    0x1(%ecx),%eax
 4a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4af:	ba 00 00 00 00       	mov    $0x0,%edx
 4b4:	f7 f3                	div    %ebx
 4b6:	89 d0                	mov    %edx,%eax
 4b8:	0f b6 80 6c 0b 00 00 	movzbl 0xb6c(%eax),%eax
 4bf:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4c3:	8b 75 10             	mov    0x10(%ebp),%esi
 4c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c9:	ba 00 00 00 00       	mov    $0x0,%edx
 4ce:	f7 f6                	div    %esi
 4d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d7:	75 c7                	jne    4a0 <printint+0x39>
  if(neg)
 4d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4dd:	74 10                	je     4ef <printint+0x88>
    buf[i++] = '-';
 4df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e2:	8d 50 01             	lea    0x1(%eax),%edx
 4e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4e8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4ed:	eb 1f                	jmp    50e <printint+0xa7>
 4ef:	eb 1d                	jmp    50e <printint+0xa7>
    putc(fd, buf[i]);
 4f1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f7:	01 d0                	add    %edx,%eax
 4f9:	0f b6 00             	movzbl (%eax),%eax
 4fc:	0f be c0             	movsbl %al,%eax
 4ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	89 04 24             	mov    %eax,(%esp)
 509:	e8 31 ff ff ff       	call   43f <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 50e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 512:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 516:	79 d9                	jns    4f1 <printint+0x8a>
    putc(fd, buf[i]);
}
 518:	83 c4 30             	add    $0x30,%esp
 51b:	5b                   	pop    %ebx
 51c:	5e                   	pop    %esi
 51d:	5d                   	pop    %ebp
 51e:	c3                   	ret    

0000051f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 51f:	55                   	push   %ebp
 520:	89 e5                	mov    %esp,%ebp
 522:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 525:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 52c:	8d 45 0c             	lea    0xc(%ebp),%eax
 52f:	83 c0 04             	add    $0x4,%eax
 532:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 535:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 53c:	e9 7c 01 00 00       	jmp    6bd <printf+0x19e>
    c = fmt[i] & 0xff;
 541:	8b 55 0c             	mov    0xc(%ebp),%edx
 544:	8b 45 f0             	mov    -0x10(%ebp),%eax
 547:	01 d0                	add    %edx,%eax
 549:	0f b6 00             	movzbl (%eax),%eax
 54c:	0f be c0             	movsbl %al,%eax
 54f:	25 ff 00 00 00       	and    $0xff,%eax
 554:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 557:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55b:	75 2c                	jne    589 <printf+0x6a>
      if(c == '%'){
 55d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 561:	75 0c                	jne    56f <printf+0x50>
        state = '%';
 563:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 56a:	e9 4a 01 00 00       	jmp    6b9 <printf+0x19a>
      } else {
        putc(fd, c);
 56f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 572:	0f be c0             	movsbl %al,%eax
 575:	89 44 24 04          	mov    %eax,0x4(%esp)
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	89 04 24             	mov    %eax,(%esp)
 57f:	e8 bb fe ff ff       	call   43f <putc>
 584:	e9 30 01 00 00       	jmp    6b9 <printf+0x19a>
      }
    } else if(state == '%'){
 589:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 58d:	0f 85 26 01 00 00    	jne    6b9 <printf+0x19a>
      if(c == 'd'){
 593:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 597:	75 2d                	jne    5c6 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 599:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59c:	8b 00                	mov    (%eax),%eax
 59e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5a5:	00 
 5a6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5ad:	00 
 5ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b2:	8b 45 08             	mov    0x8(%ebp),%eax
 5b5:	89 04 24             	mov    %eax,(%esp)
 5b8:	e8 aa fe ff ff       	call   467 <printint>
        ap++;
 5bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c1:	e9 ec 00 00 00       	jmp    6b2 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5c6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ca:	74 06                	je     5d2 <printf+0xb3>
 5cc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5d0:	75 2d                	jne    5ff <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d5:	8b 00                	mov    (%eax),%eax
 5d7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5de:	00 
 5df:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5e6:	00 
 5e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5eb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ee:	89 04 24             	mov    %eax,(%esp)
 5f1:	e8 71 fe ff ff       	call   467 <printint>
        ap++;
 5f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fa:	e9 b3 00 00 00       	jmp    6b2 <printf+0x193>
      } else if(c == 's'){
 5ff:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 603:	75 45                	jne    64a <printf+0x12b>
        s = (char*)*ap;
 605:	8b 45 e8             	mov    -0x18(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 60d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 615:	75 09                	jne    620 <printf+0x101>
          s = "(null)";
 617:	c7 45 f4 eb 08 00 00 	movl   $0x8eb,-0xc(%ebp)
        while(*s != 0){
 61e:	eb 1e                	jmp    63e <printf+0x11f>
 620:	eb 1c                	jmp    63e <printf+0x11f>
          putc(fd, *s);
 622:	8b 45 f4             	mov    -0xc(%ebp),%eax
 625:	0f b6 00             	movzbl (%eax),%eax
 628:	0f be c0             	movsbl %al,%eax
 62b:	89 44 24 04          	mov    %eax,0x4(%esp)
 62f:	8b 45 08             	mov    0x8(%ebp),%eax
 632:	89 04 24             	mov    %eax,(%esp)
 635:	e8 05 fe ff ff       	call   43f <putc>
          s++;
 63a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 63e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 641:	0f b6 00             	movzbl (%eax),%eax
 644:	84 c0                	test   %al,%al
 646:	75 da                	jne    622 <printf+0x103>
 648:	eb 68                	jmp    6b2 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 64a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 64e:	75 1d                	jne    66d <printf+0x14e>
        putc(fd, *ap);
 650:	8b 45 e8             	mov    -0x18(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	0f be c0             	movsbl %al,%eax
 658:	89 44 24 04          	mov    %eax,0x4(%esp)
 65c:	8b 45 08             	mov    0x8(%ebp),%eax
 65f:	89 04 24             	mov    %eax,(%esp)
 662:	e8 d8 fd ff ff       	call   43f <putc>
        ap++;
 667:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 66b:	eb 45                	jmp    6b2 <printf+0x193>
      } else if(c == '%'){
 66d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 671:	75 17                	jne    68a <printf+0x16b>
        putc(fd, c);
 673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 676:	0f be c0             	movsbl %al,%eax
 679:	89 44 24 04          	mov    %eax,0x4(%esp)
 67d:	8b 45 08             	mov    0x8(%ebp),%eax
 680:	89 04 24             	mov    %eax,(%esp)
 683:	e8 b7 fd ff ff       	call   43f <putc>
 688:	eb 28                	jmp    6b2 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 68a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 691:	00 
 692:	8b 45 08             	mov    0x8(%ebp),%eax
 695:	89 04 24             	mov    %eax,(%esp)
 698:	e8 a2 fd ff ff       	call   43f <putc>
        putc(fd, c);
 69d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a0:	0f be c0             	movsbl %al,%eax
 6a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a7:	8b 45 08             	mov    0x8(%ebp),%eax
 6aa:	89 04 24             	mov    %eax,(%esp)
 6ad:	e8 8d fd ff ff       	call   43f <putc>
      }
      state = 0;
 6b2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6bd:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c3:	01 d0                	add    %edx,%eax
 6c5:	0f b6 00             	movzbl (%eax),%eax
 6c8:	84 c0                	test   %al,%al
 6ca:	0f 85 71 fe ff ff    	jne    541 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6d0:	c9                   	leave  
 6d1:	c3                   	ret    

000006d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d2:	55                   	push   %ebp
 6d3:	89 e5                	mov    %esp,%ebp
 6d5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d8:	8b 45 08             	mov    0x8(%ebp),%eax
 6db:	83 e8 08             	sub    $0x8,%eax
 6de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e1:	a1 88 0b 00 00       	mov    0xb88,%eax
 6e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e9:	eb 24                	jmp    70f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	8b 00                	mov    (%eax),%eax
 6f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f3:	77 12                	ja     707 <free+0x35>
 6f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6fb:	77 24                	ja     721 <free+0x4f>
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 00                	mov    (%eax),%eax
 702:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 705:	77 1a                	ja     721 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	8b 00                	mov    (%eax),%eax
 70c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 712:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 715:	76 d4                	jbe    6eb <free+0x19>
 717:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71a:	8b 00                	mov    (%eax),%eax
 71c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71f:	76 ca                	jbe    6eb <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 721:	8b 45 f8             	mov    -0x8(%ebp),%eax
 724:	8b 40 04             	mov    0x4(%eax),%eax
 727:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 72e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 731:	01 c2                	add    %eax,%edx
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	8b 00                	mov    (%eax),%eax
 738:	39 c2                	cmp    %eax,%edx
 73a:	75 24                	jne    760 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 73c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73f:	8b 50 04             	mov    0x4(%eax),%edx
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	8b 00                	mov    (%eax),%eax
 747:	8b 40 04             	mov    0x4(%eax),%eax
 74a:	01 c2                	add    %eax,%edx
 74c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 752:	8b 45 fc             	mov    -0x4(%ebp),%eax
 755:	8b 00                	mov    (%eax),%eax
 757:	8b 10                	mov    (%eax),%edx
 759:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75c:	89 10                	mov    %edx,(%eax)
 75e:	eb 0a                	jmp    76a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 760:	8b 45 fc             	mov    -0x4(%ebp),%eax
 763:	8b 10                	mov    (%eax),%edx
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 76a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76d:	8b 40 04             	mov    0x4(%eax),%eax
 770:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	01 d0                	add    %edx,%eax
 77c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 77f:	75 20                	jne    7a1 <free+0xcf>
    p->s.size += bp->s.size;
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	8b 50 04             	mov    0x4(%eax),%edx
 787:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78a:	8b 40 04             	mov    0x4(%eax),%eax
 78d:	01 c2                	add    %eax,%edx
 78f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 792:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 795:	8b 45 f8             	mov    -0x8(%ebp),%eax
 798:	8b 10                	mov    (%eax),%edx
 79a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79d:	89 10                	mov    %edx,(%eax)
 79f:	eb 08                	jmp    7a9 <free+0xd7>
  } else
    p->s.ptr = bp;
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a7:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ac:	a3 88 0b 00 00       	mov    %eax,0xb88
}
 7b1:	c9                   	leave  
 7b2:	c3                   	ret    

000007b3 <morecore>:

static Header*
morecore(uint nu)
{
 7b3:	55                   	push   %ebp
 7b4:	89 e5                	mov    %esp,%ebp
 7b6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7c0:	77 07                	ja     7c9 <morecore+0x16>
    nu = 4096;
 7c2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c9:	8b 45 08             	mov    0x8(%ebp),%eax
 7cc:	c1 e0 03             	shl    $0x3,%eax
 7cf:	89 04 24             	mov    %eax,(%esp)
 7d2:	e8 30 fc ff ff       	call   407 <sbrk>
 7d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7da:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7de:	75 07                	jne    7e7 <morecore+0x34>
    return 0;
 7e0:	b8 00 00 00 00       	mov    $0x0,%eax
 7e5:	eb 22                	jmp    809 <morecore+0x56>
  hp = (Header*)p;
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f0:	8b 55 08             	mov    0x8(%ebp),%edx
 7f3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f9:	83 c0 08             	add    $0x8,%eax
 7fc:	89 04 24             	mov    %eax,(%esp)
 7ff:	e8 ce fe ff ff       	call   6d2 <free>
  return freep;
 804:	a1 88 0b 00 00       	mov    0xb88,%eax
}
 809:	c9                   	leave  
 80a:	c3                   	ret    

0000080b <malloc>:

void*
malloc(uint nbytes)
{
 80b:	55                   	push   %ebp
 80c:	89 e5                	mov    %esp,%ebp
 80e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 811:	8b 45 08             	mov    0x8(%ebp),%eax
 814:	83 c0 07             	add    $0x7,%eax
 817:	c1 e8 03             	shr    $0x3,%eax
 81a:	83 c0 01             	add    $0x1,%eax
 81d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 820:	a1 88 0b 00 00       	mov    0xb88,%eax
 825:	89 45 f0             	mov    %eax,-0x10(%ebp)
 828:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 82c:	75 23                	jne    851 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 82e:	c7 45 f0 80 0b 00 00 	movl   $0xb80,-0x10(%ebp)
 835:	8b 45 f0             	mov    -0x10(%ebp),%eax
 838:	a3 88 0b 00 00       	mov    %eax,0xb88
 83d:	a1 88 0b 00 00       	mov    0xb88,%eax
 842:	a3 80 0b 00 00       	mov    %eax,0xb80
    base.s.size = 0;
 847:	c7 05 84 0b 00 00 00 	movl   $0x0,0xb84
 84e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 851:	8b 45 f0             	mov    -0x10(%ebp),%eax
 854:	8b 00                	mov    (%eax),%eax
 856:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 859:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85c:	8b 40 04             	mov    0x4(%eax),%eax
 85f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 862:	72 4d                	jb     8b1 <malloc+0xa6>
      if(p->s.size == nunits)
 864:	8b 45 f4             	mov    -0xc(%ebp),%eax
 867:	8b 40 04             	mov    0x4(%eax),%eax
 86a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 86d:	75 0c                	jne    87b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 872:	8b 10                	mov    (%eax),%edx
 874:	8b 45 f0             	mov    -0x10(%ebp),%eax
 877:	89 10                	mov    %edx,(%eax)
 879:	eb 26                	jmp    8a1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 87b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87e:	8b 40 04             	mov    0x4(%eax),%eax
 881:	2b 45 ec             	sub    -0x14(%ebp),%eax
 884:	89 c2                	mov    %eax,%edx
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	8b 40 04             	mov    0x4(%eax),%eax
 892:	c1 e0 03             	shl    $0x3,%eax
 895:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 89e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a4:	a3 88 0b 00 00       	mov    %eax,0xb88
      return (void*)(p + 1);
 8a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ac:	83 c0 08             	add    $0x8,%eax
 8af:	eb 38                	jmp    8e9 <malloc+0xde>
    }
    if(p == freep)
 8b1:	a1 88 0b 00 00       	mov    0xb88,%eax
 8b6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8b9:	75 1b                	jne    8d6 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8be:	89 04 24             	mov    %eax,(%esp)
 8c1:	e8 ed fe ff ff       	call   7b3 <morecore>
 8c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8cd:	75 07                	jne    8d6 <malloc+0xcb>
        return 0;
 8cf:	b8 00 00 00 00       	mov    $0x0,%eax
 8d4:	eb 13                	jmp    8e9 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8df:	8b 00                	mov    (%eax),%eax
 8e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8e4:	e9 70 ff ff ff       	jmp    859 <malloc+0x4e>
}
 8e9:	c9                   	leave  
 8ea:	c3                   	ret    
