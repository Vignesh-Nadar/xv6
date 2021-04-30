
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc b0 d6 10 80       	mov    $0x8010d6b0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d0 37 10 80       	mov    $0x801037d0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 2c 8b 10 	movl   $0x80108b2c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 c0 d6 10 80 	movl   $0x8010d6c0,(%esp)
80100049:	e8 15 53 00 00       	call   80105363 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 d0 15 11 80 c4 	movl   $0x801115c4,0x801115d0
80100055:	15 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 d4 15 11 80 c4 	movl   $0x801115c4,0x801115d4
8010005f:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 f4 d6 10 80 	movl   $0x8010d6f4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 d4 15 11 80    	mov    0x801115d4,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c c4 15 11 80 	movl   $0x801115c4,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 d4 15 11 80       	mov    0x801115d4,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 d4 15 11 80       	mov    %eax,0x801115d4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 c4 15 11 80 	cmpl   $0x801115c4,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 c0 d6 10 80 	movl   $0x8010d6c0,(%esp)
801000bd:	e8 c2 52 00 00       	call   80105384 <acquire>

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 d4 15 11 80       	mov    0x801115d4,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->blockno == blockno){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	83 c8 01             	or     $0x1,%eax
801000f6:	89 c2                	mov    %eax,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 c0 d6 10 80 	movl   $0x8010d6c0,(%esp)
80100104:	e8 dd 52 00 00       	call   801053e6 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 c0 d6 10 	movl   $0x8010d6c0,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 70 4c 00 00       	call   80104d94 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 c4 15 11 80 	cmpl   $0x801115c4,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 d0 15 11 80       	mov    0x801115d0,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 c0 d6 10 80 	movl   $0x8010d6c0,(%esp)
8010017c:	e8 65 52 00 00       	call   801053e6 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 c4 15 11 80 	cmpl   $0x801115c4,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 33 8b 10 80 	movl   $0x80108b33,(%esp)
8010019f:	e8 96 03 00 00       	call   8010053a <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 8c 26 00 00       	call   80102864 <iderw>
  }
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 44 8b 10 80 	movl   $0x80108b44,(%esp)
801001f6:	e8 3f 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	83 c8 04             	or     $0x4,%eax
80100203:	89 c2                	mov    %eax,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 4f 26 00 00       	call   80102864 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 4b 8b 10 80 	movl   $0x80108b4b,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 c0 d6 10 80 	movl   $0x8010d6c0,(%esp)
8010023c:	e8 43 51 00 00       	call   80105384 <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 d4 15 11 80    	mov    0x801115d4,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c c4 15 11 80 	movl   $0x801115c4,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 d4 15 11 80       	mov    0x801115d4,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 d4 15 11 80       	mov    %eax,0x801115d4

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	83 e0 fe             	and    $0xfffffffe,%eax
80100290:	89 c2                	mov    %eax,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 cb 4b 00 00       	call   80104e6d <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 c0 d6 10 80 	movl   $0x8010d6c0,(%esp)
801002a9:	e8 38 51 00 00       	call   801053e6 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	83 ec 14             	sub    $0x14,%esp
801002b6:	8b 45 08             	mov    0x8(%ebp),%eax
801002b9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002bd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c1:	89 c2                	mov    %eax,%edx
801002c3:	ec                   	in     (%dx),%al
801002c4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002c7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cb:	c9                   	leave  
801002cc:	c3                   	ret    

801002cd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002cd:	55                   	push   %ebp
801002ce:	89 e5                	mov    %esp,%ebp
801002d0:	83 ec 08             	sub    $0x8,%esp
801002d3:	8b 55 08             	mov    0x8(%ebp),%edx
801002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002d9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002dd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002e8:	ee                   	out    %al,(%dx)
}
801002e9:	c9                   	leave  
801002ea:	c3                   	ret    

801002eb <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002eb:	55                   	push   %ebp
801002ec:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002ee:	fa                   	cli    
}
801002ef:	5d                   	pop    %ebp
801002f0:	c3                   	ret    

801002f1 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	56                   	push   %esi
801002f5:	53                   	push   %ebx
801002f6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801002fd:	74 1c                	je     8010031b <printint+0x2a>
801002ff:	8b 45 08             	mov    0x8(%ebp),%eax
80100302:	c1 e8 1f             	shr    $0x1f,%eax
80100305:	0f b6 c0             	movzbl %al,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x2a>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100319:	eb 06                	jmp    80100321 <printint+0x30>
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100321:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010032b:	8d 41 01             	lea    0x1(%ecx),%eax
8010032e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100334:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100337:	ba 00 00 00 00       	mov    $0x0,%edx
8010033c:	f7 f3                	div    %ebx
8010033e:	89 d0                	mov    %edx,%eax
80100340:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
80100347:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010034b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100351:	ba 00 00 00 00       	mov    $0x0,%edx
80100356:	f7 f6                	div    %esi
80100358:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010035b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010035f:	75 c7                	jne    80100328 <printint+0x37>

  if(sign)
80100361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100365:	74 10                	je     80100377 <printint+0x86>
    buf[i++] = '-';
80100367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010036a:	8d 50 01             	lea    0x1(%eax),%edx
8010036d:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100370:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100375:	eb 18                	jmp    8010038f <printint+0x9e>
80100377:	eb 16                	jmp    8010038f <printint+0x9e>
    consputc(buf[i]);
80100379:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037f:	01 d0                	add    %edx,%eax
80100381:	0f b6 00             	movzbl (%eax),%eax
80100384:	0f be c0             	movsbl %al,%eax
80100387:	89 04 24             	mov    %eax,(%esp)
8010038a:	e8 dc 03 00 00       	call   8010076b <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100397:	79 e0                	jns    80100379 <printint+0x88>
    consputc(buf[i]);
}
80100399:	83 c4 30             	add    $0x30,%esp
8010039c:	5b                   	pop    %ebx
8010039d:	5e                   	pop    %esi
8010039e:	5d                   	pop    %ebp
8010039f:	c3                   	ret    

801003a0 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a6:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801003bb:	e8 c4 4f 00 00       	call   80105384 <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 52 8b 10 80 	movl   $0x80108b52,(%esp)
801003ce:	e8 67 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d3:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e0:	e9 21 01 00 00       	jmp    80100506 <cprintf+0x166>
    if(c != '%'){
801003e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003e9:	74 10                	je     801003fb <cprintf+0x5b>
      consputc(c);
801003eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ee:	89 04 24             	mov    %eax,(%esp)
801003f1:	e8 75 03 00 00       	call   8010076b <consputc>
      continue;
801003f6:	e9 07 01 00 00       	jmp    80100502 <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
801003fb:	8b 55 08             	mov    0x8(%ebp),%edx
801003fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	0f b6 00             	movzbl (%eax),%eax
8010040a:	0f be c0             	movsbl %al,%eax
8010040d:	25 ff 00 00 00       	and    $0xff,%eax
80100412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100415:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100419:	75 05                	jne    80100420 <cprintf+0x80>
      break;
8010041b:	e9 06 01 00 00       	jmp    80100526 <cprintf+0x186>
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4f                	je     80100477 <cprintf+0xd7>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0xa0>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13c>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xaf>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x14a>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 57                	je     8010049c <cprintf+0xfc>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2d                	je     80100477 <cprintf+0xd7>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8d 50 04             	lea    0x4(%eax),%edx
80100455:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100458:	8b 00                	mov    (%eax),%eax
8010045a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100461:	00 
80100462:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100469:	00 
8010046a:	89 04 24             	mov    %eax,(%esp)
8010046d:	e8 7f fe ff ff       	call   801002f1 <printint>
      break;
80100472:	e9 8b 00 00 00       	jmp    80100502 <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 57 fe ff ff       	call   801002f1 <printint>
      break;
8010049a:	eb 66                	jmp    80100502 <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ae:	75 09                	jne    801004b9 <cprintf+0x119>
        s = "(null)";
801004b0:	c7 45 ec 5b 8b 10 80 	movl   $0x80108b5b,-0x14(%ebp)
      for(; *s; s++)
801004b7:	eb 17                	jmp    801004d0 <cprintf+0x130>
801004b9:	eb 15                	jmp    801004d0 <cprintf+0x130>
        consputc(*s);
801004bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004be:	0f b6 00             	movzbl (%eax),%eax
801004c1:	0f be c0             	movsbl %al,%eax
801004c4:	89 04 24             	mov    %eax,(%esp)
801004c7:	e8 9f 02 00 00       	call   8010076b <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004cc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 e1                	jne    801004bb <cprintf+0x11b>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x162>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 83 02 00 00       	call   8010076b <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 75 02 00 00       	call   8010076b <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 6a 02 00 00       	call   8010076b <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 bf fe ff ff    	jne    801003e5 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x198>
    release(&cons.lock);
8010052c:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80100533:	e8 ae 4e 00 00       	call   801053e6 <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 a6 fd ff ff       	call   801002eb <cli>
  cons.locking = 0;
80100545:	c7 05 54 c6 10 80 00 	movl   $0x0,0x8010c654
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 62 8b 10 80 	movl   $0x80108b62,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 71 8b 10 80 	movl   $0x80108b71,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 a1 4e 00 00       	call   80105435 <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 73 8b 10 80 	movl   $0x80108b73,(%esp)
801005af:	e8 ec fd ff ff       	call   801003a0 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005b8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bc:	7e df                	jle    8010059d <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005be:	c7 05 00 c6 10 80 01 	movl   $0x1,0x8010c600
801005c5:	00 00 00 
  for(;;)
    ;
801005c8:	eb fe                	jmp    801005c8 <panic+0x8e>

801005ca <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d7:	00 
801005d8:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005df:	e8 e9 fc ff ff       	call   801002cd <outb>
  pos = inb(CRTPORT+1) << 8;
801005e4:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005eb:	e8 c0 fc ff ff       	call   801002b0 <inb>
801005f0:	0f b6 c0             	movzbl %al,%eax
801005f3:	c1 e0 08             	shl    $0x8,%eax
801005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100600:	00 
80100601:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100608:	e8 c0 fc ff ff       	call   801002cd <outb>
  pos |= inb(CRTPORT+1);
8010060d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100614:	e8 97 fc ff ff       	call   801002b0 <inb>
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010061f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100623:	75 30                	jne    80100655 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100625:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100628:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	f7 ea                	imul   %edx
80100631:	c1 fa 05             	sar    $0x5,%edx
80100634:	89 c8                	mov    %ecx,%eax
80100636:	c1 f8 1f             	sar    $0x1f,%eax
80100639:	29 c2                	sub    %eax,%edx
8010063b:	89 d0                	mov    %edx,%eax
8010063d:	c1 e0 02             	shl    $0x2,%eax
80100640:	01 d0                	add    %edx,%eax
80100642:	c1 e0 04             	shl    $0x4,%eax
80100645:	29 c1                	sub    %eax,%ecx
80100647:	89 ca                	mov    %ecx,%edx
80100649:	b8 50 00 00 00       	mov    $0x50,%eax
8010064e:	29 d0                	sub    %edx,%eax
80100650:	01 45 f4             	add    %eax,-0xc(%ebp)
80100653:	eb 35                	jmp    8010068a <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100655:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065c:	75 0c                	jne    8010066a <cgaputc+0xa0>
    if(pos > 0) --pos;
8010065e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100662:	7e 26                	jle    8010068a <cgaputc+0xc0>
80100664:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100668:	eb 20                	jmp    8010068a <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066a:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
80100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100673:	8d 50 01             	lea    0x1(%eax),%edx
80100676:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100679:	01 c0                	add    %eax,%eax
8010067b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010067e:	8b 45 08             	mov    0x8(%ebp),%eax
80100681:	0f b6 c0             	movzbl %al,%eax
80100684:	80 cc 07             	or     $0x7,%ah
80100687:	66 89 02             	mov    %ax,(%edx)

  if(pos < 0 || pos > 25*80)
8010068a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010068e:	78 09                	js     80100699 <cgaputc+0xcf>
80100690:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
80100697:	7e 0c                	jle    801006a5 <cgaputc+0xdb>
    panic("pos under/overflow");
80100699:	c7 04 24 77 8b 10 80 	movl   $0x80108b77,(%esp)
801006a0:	e8 95 fe ff ff       	call   8010053a <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006a5:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006ac:	7e 53                	jle    80100701 <cgaputc+0x137>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006ae:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006b3:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006b9:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006be:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006c5:	00 
801006c6:	89 54 24 04          	mov    %edx,0x4(%esp)
801006ca:	89 04 24             	mov    %eax,(%esp)
801006cd:	e8 d5 4f 00 00       	call   801056a7 <memmove>
    pos -= 80;
801006d2:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006d6:	b8 80 07 00 00       	mov    $0x780,%eax
801006db:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006de:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006e1:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006e6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006e9:	01 c9                	add    %ecx,%ecx
801006eb:	01 c8                	add    %ecx,%eax
801006ed:	89 54 24 08          	mov    %edx,0x8(%esp)
801006f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006f8:	00 
801006f9:	89 04 24             	mov    %eax,(%esp)
801006fc:	e8 d7 4e 00 00       	call   801055d8 <memset>
  }
  
  outb(CRTPORT, 14);
80100701:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
80100708:	00 
80100709:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100710:	e8 b8 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos>>8);
80100715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100718:	c1 f8 08             	sar    $0x8,%eax
8010071b:	0f b6 c0             	movzbl %al,%eax
8010071e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100722:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100729:	e8 9f fb ff ff       	call   801002cd <outb>
  outb(CRTPORT, 15);
8010072e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100735:	00 
80100736:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010073d:	e8 8b fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos);
80100742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100745:	0f b6 c0             	movzbl %al,%eax
80100748:	89 44 24 04          	mov    %eax,0x4(%esp)
8010074c:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100753:	e8 75 fb ff ff       	call   801002cd <outb>
  crt[pos] = ' ' | 0x0700;
80100758:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010075d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100760:	01 d2                	add    %edx,%edx
80100762:	01 d0                	add    %edx,%eax
80100764:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100769:	c9                   	leave  
8010076a:	c3                   	ret    

8010076b <consputc>:

void
consputc(int c)
{
8010076b:	55                   	push   %ebp
8010076c:	89 e5                	mov    %esp,%ebp
8010076e:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100771:	a1 00 c6 10 80       	mov    0x8010c600,%eax
80100776:	85 c0                	test   %eax,%eax
80100778:	74 07                	je     80100781 <consputc+0x16>
    cli();
8010077a:	e8 6c fb ff ff       	call   801002eb <cli>
    for(;;)
      ;
8010077f:	eb fe                	jmp    8010077f <consputc+0x14>
  }

  if(c == BACKSPACE){
80100781:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100788:	75 26                	jne    801007b0 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010078a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100791:	e8 bf 68 00 00       	call   80107055 <uartputc>
80100796:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010079d:	e8 b3 68 00 00       	call   80107055 <uartputc>
801007a2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007a9:	e8 a7 68 00 00       	call   80107055 <uartputc>
801007ae:	eb 0b                	jmp    801007bb <consputc+0x50>
  } else
    uartputc(c);
801007b0:	8b 45 08             	mov    0x8(%ebp),%eax
801007b3:	89 04 24             	mov    %eax,(%esp)
801007b6:	e8 9a 68 00 00       	call   80107055 <uartputc>
  cgaputc(c);
801007bb:	8b 45 08             	mov    0x8(%ebp),%eax
801007be:	89 04 24             	mov    %eax,(%esp)
801007c1:	e8 04 fe ff ff       	call   801005ca <cgaputc>
}
801007c6:	c9                   	leave  
801007c7:	c3                   	ret    

801007c8 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007c8:	55                   	push   %ebp
801007c9:	89 e5                	mov    %esp,%ebp
801007cb:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0;
801007ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801007d5:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801007dc:	e8 a3 4b 00 00       	call   80105384 <acquire>
  while((c = getc()) >= 0){
801007e1:	e9 39 01 00 00       	jmp    8010091f <consoleintr+0x157>
    switch(c){
801007e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801007e9:	83 f8 10             	cmp    $0x10,%eax
801007ec:	74 1e                	je     8010080c <consoleintr+0x44>
801007ee:	83 f8 10             	cmp    $0x10,%eax
801007f1:	7f 0a                	jg     801007fd <consoleintr+0x35>
801007f3:	83 f8 08             	cmp    $0x8,%eax
801007f6:	74 66                	je     8010085e <consoleintr+0x96>
801007f8:	e9 93 00 00 00       	jmp    80100890 <consoleintr+0xc8>
801007fd:	83 f8 15             	cmp    $0x15,%eax
80100800:	74 31                	je     80100833 <consoleintr+0x6b>
80100802:	83 f8 7f             	cmp    $0x7f,%eax
80100805:	74 57                	je     8010085e <consoleintr+0x96>
80100807:	e9 84 00 00 00       	jmp    80100890 <consoleintr+0xc8>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
8010080c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100813:	e9 07 01 00 00       	jmp    8010091f <consoleintr+0x157>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100818:	a1 68 18 11 80       	mov    0x80111868,%eax
8010081d:	83 e8 01             	sub    $0x1,%eax
80100820:	a3 68 18 11 80       	mov    %eax,0x80111868
        consputc(BACKSPACE);
80100825:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010082c:	e8 3a ff ff ff       	call   8010076b <consputc>
80100831:	eb 01                	jmp    80100834 <consoleintr+0x6c>
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100833:	90                   	nop
80100834:	8b 15 68 18 11 80    	mov    0x80111868,%edx
8010083a:	a1 64 18 11 80       	mov    0x80111864,%eax
8010083f:	39 c2                	cmp    %eax,%edx
80100841:	74 16                	je     80100859 <consoleintr+0x91>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100843:	a1 68 18 11 80       	mov    0x80111868,%eax
80100848:	83 e8 01             	sub    $0x1,%eax
8010084b:	83 e0 7f             	and    $0x7f,%eax
8010084e:	0f b6 80 e0 17 11 80 	movzbl -0x7feee820(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100855:	3c 0a                	cmp    $0xa,%al
80100857:	75 bf                	jne    80100818 <consoleintr+0x50>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100859:	e9 c1 00 00 00       	jmp    8010091f <consoleintr+0x157>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010085e:	8b 15 68 18 11 80    	mov    0x80111868,%edx
80100864:	a1 64 18 11 80       	mov    0x80111864,%eax
80100869:	39 c2                	cmp    %eax,%edx
8010086b:	74 1e                	je     8010088b <consoleintr+0xc3>
        input.e--;
8010086d:	a1 68 18 11 80       	mov    0x80111868,%eax
80100872:	83 e8 01             	sub    $0x1,%eax
80100875:	a3 68 18 11 80       	mov    %eax,0x80111868
        consputc(BACKSPACE);
8010087a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100881:	e8 e5 fe ff ff       	call   8010076b <consputc>
      }
      break;
80100886:	e9 94 00 00 00       	jmp    8010091f <consoleintr+0x157>
8010088b:	e9 8f 00 00 00       	jmp    8010091f <consoleintr+0x157>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100890:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100894:	0f 84 84 00 00 00    	je     8010091e <consoleintr+0x156>
8010089a:	8b 15 68 18 11 80    	mov    0x80111868,%edx
801008a0:	a1 60 18 11 80       	mov    0x80111860,%eax
801008a5:	29 c2                	sub    %eax,%edx
801008a7:	89 d0                	mov    %edx,%eax
801008a9:	83 f8 7f             	cmp    $0x7f,%eax
801008ac:	77 70                	ja     8010091e <consoleintr+0x156>
        c = (c == '\r') ? '\n' : c;
801008ae:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008b2:	74 05                	je     801008b9 <consoleintr+0xf1>
801008b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008b7:	eb 05                	jmp    801008be <consoleintr+0xf6>
801008b9:	b8 0a 00 00 00       	mov    $0xa,%eax
801008be:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008c1:	a1 68 18 11 80       	mov    0x80111868,%eax
801008c6:	8d 50 01             	lea    0x1(%eax),%edx
801008c9:	89 15 68 18 11 80    	mov    %edx,0x80111868
801008cf:	83 e0 7f             	and    $0x7f,%eax
801008d2:	89 c2                	mov    %eax,%edx
801008d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008d7:	88 82 e0 17 11 80    	mov    %al,-0x7feee820(%edx)
        consputc(c);
801008dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008e0:	89 04 24             	mov    %eax,(%esp)
801008e3:	e8 83 fe ff ff       	call   8010076b <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801008ec:	74 18                	je     80100906 <consoleintr+0x13e>
801008ee:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801008f2:	74 12                	je     80100906 <consoleintr+0x13e>
801008f4:	a1 68 18 11 80       	mov    0x80111868,%eax
801008f9:	8b 15 60 18 11 80    	mov    0x80111860,%edx
801008ff:	83 ea 80             	sub    $0xffffff80,%edx
80100902:	39 d0                	cmp    %edx,%eax
80100904:	75 18                	jne    8010091e <consoleintr+0x156>
          input.w = input.e;
80100906:	a1 68 18 11 80       	mov    0x80111868,%eax
8010090b:	a3 64 18 11 80       	mov    %eax,0x80111864
          wakeup(&input.r);
80100910:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100917:	e8 51 45 00 00       	call   80104e6d <wakeup>
        }
      }
      break;
8010091c:	eb 00                	jmp    8010091e <consoleintr+0x156>
8010091e:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
8010091f:	8b 45 08             	mov    0x8(%ebp),%eax
80100922:	ff d0                	call   *%eax
80100924:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100927:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010092b:	0f 89 b5 fe ff ff    	jns    801007e6 <consoleintr+0x1e>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100931:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80100938:	e8 a9 4a 00 00       	call   801053e6 <release>
  if(doprocdump) {
8010093d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100941:	74 05                	je     80100948 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
80100943:	e8 c8 45 00 00       	call   80104f10 <procdump>
  }
}
80100948:	c9                   	leave  
80100949:	c3                   	ret    

8010094a <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010094a:	55                   	push   %ebp
8010094b:	89 e5                	mov    %esp,%ebp
8010094d:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100950:	8b 45 08             	mov    0x8(%ebp),%eax
80100953:	89 04 24             	mov    %eax,(%esp)
80100956:	e8 da 10 00 00       	call   80101a35 <iunlock>
  target = n;
8010095b:	8b 45 10             	mov    0x10(%ebp),%eax
8010095e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100961:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80100968:	e8 17 4a 00 00       	call   80105384 <acquire>
  while(n > 0){
8010096d:	e9 aa 00 00 00       	jmp    80100a1c <consoleread+0xd2>
    while(input.r == input.w){
80100972:	eb 42                	jmp    801009b6 <consoleread+0x6c>
      if(proc->killed){
80100974:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010097a:	8b 40 24             	mov    0x24(%eax),%eax
8010097d:	85 c0                	test   %eax,%eax
8010097f:	74 21                	je     801009a2 <consoleread+0x58>
        release(&cons.lock);
80100981:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80100988:	e8 59 4a 00 00       	call   801053e6 <release>
        ilock(ip);
8010098d:	8b 45 08             	mov    0x8(%ebp),%eax
80100990:	89 04 24             	mov    %eax,(%esp)
80100993:	e8 49 0f 00 00       	call   801018e1 <ilock>
        return -1;
80100998:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010099d:	e9 a5 00 00 00       	jmp    80100a47 <consoleread+0xfd>
      }
      sleep(&input.r, &cons.lock);
801009a2:	c7 44 24 04 20 c6 10 	movl   $0x8010c620,0x4(%esp)
801009a9:	80 
801009aa:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
801009b1:	e8 de 43 00 00       	call   80104d94 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801009b6:	8b 15 60 18 11 80    	mov    0x80111860,%edx
801009bc:	a1 64 18 11 80       	mov    0x80111864,%eax
801009c1:	39 c2                	cmp    %eax,%edx
801009c3:	74 af                	je     80100974 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009c5:	a1 60 18 11 80       	mov    0x80111860,%eax
801009ca:	8d 50 01             	lea    0x1(%eax),%edx
801009cd:	89 15 60 18 11 80    	mov    %edx,0x80111860
801009d3:	83 e0 7f             	and    $0x7f,%eax
801009d6:	0f b6 80 e0 17 11 80 	movzbl -0x7feee820(%eax),%eax
801009dd:	0f be c0             	movsbl %al,%eax
801009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009e3:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009e7:	75 19                	jne    80100a02 <consoleread+0xb8>
      if(n < target){
801009e9:	8b 45 10             	mov    0x10(%ebp),%eax
801009ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009ef:	73 0f                	jae    80100a00 <consoleread+0xb6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009f1:	a1 60 18 11 80       	mov    0x80111860,%eax
801009f6:	83 e8 01             	sub    $0x1,%eax
801009f9:	a3 60 18 11 80       	mov    %eax,0x80111860
      }
      break;
801009fe:	eb 26                	jmp    80100a26 <consoleread+0xdc>
80100a00:	eb 24                	jmp    80100a26 <consoleread+0xdc>
    }
    *dst++ = c;
80100a02:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a05:	8d 50 01             	lea    0x1(%eax),%edx
80100a08:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a0e:	88 10                	mov    %dl,(%eax)
    --n;
80100a10:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a14:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a18:	75 02                	jne    80100a1c <consoleread+0xd2>
      break;
80100a1a:	eb 0a                	jmp    80100a26 <consoleread+0xdc>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100a1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a20:	0f 8f 4c ff ff ff    	jg     80100972 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100a26:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80100a2d:	e8 b4 49 00 00       	call   801053e6 <release>
  ilock(ip);
80100a32:	8b 45 08             	mov    0x8(%ebp),%eax
80100a35:	89 04 24             	mov    %eax,(%esp)
80100a38:	e8 a4 0e 00 00       	call   801018e1 <ilock>

  return target - n;
80100a3d:	8b 45 10             	mov    0x10(%ebp),%eax
80100a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a43:	29 c2                	sub    %eax,%edx
80100a45:	89 d0                	mov    %edx,%eax
}
80100a47:	c9                   	leave  
80100a48:	c3                   	ret    

80100a49 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a49:	55                   	push   %ebp
80100a4a:	89 e5                	mov    %esp,%ebp
80100a4c:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a4f:	8b 45 08             	mov    0x8(%ebp),%eax
80100a52:	89 04 24             	mov    %eax,(%esp)
80100a55:	e8 db 0f 00 00       	call   80101a35 <iunlock>
  acquire(&cons.lock);
80100a5a:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80100a61:	e8 1e 49 00 00       	call   80105384 <acquire>
  for(i = 0; i < n; i++)
80100a66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a6d:	eb 1d                	jmp    80100a8c <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a72:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a75:	01 d0                	add    %edx,%eax
80100a77:	0f b6 00             	movzbl (%eax),%eax
80100a7a:	0f be c0             	movsbl %al,%eax
80100a7d:	0f b6 c0             	movzbl %al,%eax
80100a80:	89 04 24             	mov    %eax,(%esp)
80100a83:	e8 e3 fc ff ff       	call   8010076b <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a88:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a8f:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a92:	7c db                	jl     80100a6f <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a94:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80100a9b:	e8 46 49 00 00       	call   801053e6 <release>
  ilock(ip);
80100aa0:	8b 45 08             	mov    0x8(%ebp),%eax
80100aa3:	89 04 24             	mov    %eax,(%esp)
80100aa6:	e8 36 0e 00 00       	call   801018e1 <ilock>

  return n;
80100aab:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100aae:	c9                   	leave  
80100aaf:	c3                   	ret    

80100ab0 <consoleinit>:

void
consoleinit(void)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100ab6:	c7 44 24 04 8a 8b 10 	movl   $0x80108b8a,0x4(%esp)
80100abd:	80 
80100abe:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80100ac5:	e8 99 48 00 00       	call   80105363 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aca:	c7 05 2c 22 11 80 49 	movl   $0x80100a49,0x8011222c
80100ad1:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ad4:	c7 05 28 22 11 80 4a 	movl   $0x8010094a,0x80112228
80100adb:	09 10 80 
  cons.locking = 1;
80100ade:	c7 05 54 c6 10 80 01 	movl   $0x1,0x8010c654
80100ae5:	00 00 00 

  picenable(IRQ_KBD);
80100ae8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aef:	e8 74 33 00 00       	call   80103e68 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100af4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100afb:	00 
80100afc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100b03:	e8 18 1f 00 00       	call   80102a20 <ioapicenable>
}
80100b08:	c9                   	leave  
80100b09:	c3                   	ret    

80100b0a <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b0a:	55                   	push   %ebp
80100b0b:	89 e5                	mov    %esp,%ebp
80100b0d:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b13:	e8 b1 29 00 00       	call   801034c9 <begin_op>
  if((ip = namei(path)) == 0){
80100b18:	8b 45 08             	mov    0x8(%ebp),%eax
80100b1b:	89 04 24             	mov    %eax,(%esp)
80100b1e:	e8 6f 19 00 00       	call   80102492 <namei>
80100b23:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b26:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b2a:	75 0f                	jne    80100b3b <exec+0x31>
    end_op();
80100b2c:	e8 1c 2a 00 00       	call   8010354d <end_op>
    return -1;
80100b31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b36:	e9 f5 03 00 00       	jmp    80100f30 <exec+0x426>
  }
  ilock(ip);
80100b3b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b3e:	89 04 24             	mov    %eax,(%esp)
80100b41:	e8 9b 0d 00 00       	call   801018e1 <ilock>
  pgdir = 0;
80100b46:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b4d:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b54:	00 
80100b55:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b5c:	00 
80100b5d:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b63:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b67:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b6a:	89 04 24             	mov    %eax,(%esp)
80100b6d:	e8 82 12 00 00       	call   80101df4 <readi>
80100b72:	83 f8 33             	cmp    $0x33,%eax
80100b75:	77 05                	ja     80100b7c <exec+0x72>
    goto bad;
80100b77:	e9 88 03 00 00       	jmp    80100f04 <exec+0x3fa>
  if(elf.magic != ELF_MAGIC)
80100b7c:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b82:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b87:	74 05                	je     80100b8e <exec+0x84>
    goto bad;
80100b89:	e9 76 03 00 00       	jmp    80100f04 <exec+0x3fa>

  if((pgdir = setupkvm()) == 0)
80100b8e:	e8 13 76 00 00       	call   801081a6 <setupkvm>
80100b93:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b96:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b9a:	75 05                	jne    80100ba1 <exec+0x97>
    goto bad;
80100b9c:	e9 63 03 00 00       	jmp    80100f04 <exec+0x3fa>

  // Load program into memory.
  sz = 0;
80100ba1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ba8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100baf:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bb5:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100bb8:	e9 cb 00 00 00       	jmp    80100c88 <exec+0x17e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bc0:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bc7:	00 
80100bc8:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bcc:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bd6:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bd9:	89 04 24             	mov    %eax,(%esp)
80100bdc:	e8 13 12 00 00       	call   80101df4 <readi>
80100be1:	83 f8 20             	cmp    $0x20,%eax
80100be4:	74 05                	je     80100beb <exec+0xe1>
      goto bad;
80100be6:	e9 19 03 00 00       	jmp    80100f04 <exec+0x3fa>
    if(ph.type != ELF_PROG_LOAD)
80100beb:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bf1:	83 f8 01             	cmp    $0x1,%eax
80100bf4:	74 05                	je     80100bfb <exec+0xf1>
      continue;
80100bf6:	e9 80 00 00 00       	jmp    80100c7b <exec+0x171>
    if(ph.memsz < ph.filesz)
80100bfb:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c01:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c07:	39 c2                	cmp    %eax,%edx
80100c09:	73 05                	jae    80100c10 <exec+0x106>
      goto bad;
80100c0b:	e9 f4 02 00 00       	jmp    80100f04 <exec+0x3fa>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c10:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c16:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c1c:	01 d0                	add    %edx,%eax
80100c1e:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c22:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c25:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c2c:	89 04 24             	mov    %eax,(%esp)
80100c2f:	e8 40 79 00 00       	call   80108574 <allocuvm>
80100c34:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c37:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c3b:	75 05                	jne    80100c42 <exec+0x138>
      goto bad;
80100c3d:	e9 c2 02 00 00       	jmp    80100f04 <exec+0x3fa>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c42:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c48:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c4e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c54:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c58:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c5c:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c5f:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c63:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c6a:	89 04 24             	mov    %eax,(%esp)
80100c6d:	e8 17 78 00 00       	call   80108489 <loaduvm>
80100c72:	85 c0                	test   %eax,%eax
80100c74:	79 05                	jns    80100c7b <exec+0x171>
      goto bad;
80100c76:	e9 89 02 00 00       	jmp    80100f04 <exec+0x3fa>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c7b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c82:	83 c0 20             	add    $0x20,%eax
80100c85:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c88:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c8f:	0f b7 c0             	movzwl %ax,%eax
80100c92:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c95:	0f 8f 22 ff ff ff    	jg     80100bbd <exec+0xb3>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c9b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c9e:	89 04 24             	mov    %eax,(%esp)
80100ca1:	e8 c5 0e 00 00       	call   80101b6b <iunlockput>
  end_op();
80100ca6:	e8 a2 28 00 00       	call   8010354d <end_op>
  ip = 0;
80100cab:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb5:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cbf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cc5:	05 00 20 00 00       	add    $0x2000,%eax
80100cca:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cce:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cd5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cd8:	89 04 24             	mov    %eax,(%esp)
80100cdb:	e8 94 78 00 00       	call   80108574 <allocuvm>
80100ce0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ce3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ce7:	75 05                	jne    80100cee <exec+0x1e4>
    goto bad;
80100ce9:	e9 16 02 00 00       	jmp    80100f04 <exec+0x3fa>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cee:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cf1:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cf6:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cfa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cfd:	89 04 24             	mov    %eax,(%esp)
80100d00:	e8 9f 7a 00 00       	call   801087a4 <clearpteu>
  sp = sz;
80100d05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d08:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d0b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d12:	e9 9a 00 00 00       	jmp    80100db1 <exec+0x2a7>
    if(argc >= MAXARG)
80100d17:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d1b:	76 05                	jbe    80100d22 <exec+0x218>
      goto bad;
80100d1d:	e9 e2 01 00 00       	jmp    80100f04 <exec+0x3fa>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d2f:	01 d0                	add    %edx,%eax
80100d31:	8b 00                	mov    (%eax),%eax
80100d33:	89 04 24             	mov    %eax,(%esp)
80100d36:	e8 07 4b 00 00       	call   80105842 <strlen>
80100d3b:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d3e:	29 c2                	sub    %eax,%edx
80100d40:	89 d0                	mov    %edx,%eax
80100d42:	83 e8 01             	sub    $0x1,%eax
80100d45:	83 e0 fc             	and    $0xfffffffc,%eax
80100d48:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d4e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d58:	01 d0                	add    %edx,%eax
80100d5a:	8b 00                	mov    (%eax),%eax
80100d5c:	89 04 24             	mov    %eax,(%esp)
80100d5f:	e8 de 4a 00 00       	call   80105842 <strlen>
80100d64:	83 c0 01             	add    $0x1,%eax
80100d67:	89 c2                	mov    %eax,%edx
80100d69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d6c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d73:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d76:	01 c8                	add    %ecx,%eax
80100d78:	8b 00                	mov    (%eax),%eax
80100d7a:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d7e:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d82:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d85:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d8c:	89 04 24             	mov    %eax,(%esp)
80100d8f:	e8 d5 7b 00 00       	call   80108969 <copyout>
80100d94:	85 c0                	test   %eax,%eax
80100d96:	79 05                	jns    80100d9d <exec+0x293>
      goto bad;
80100d98:	e9 67 01 00 00       	jmp    80100f04 <exec+0x3fa>
    ustack[3+argc] = sp;
80100d9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da0:	8d 50 03             	lea    0x3(%eax),%edx
80100da3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100da6:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dad:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dbe:	01 d0                	add    %edx,%eax
80100dc0:	8b 00                	mov    (%eax),%eax
80100dc2:	85 c0                	test   %eax,%eax
80100dc4:	0f 85 4d ff ff ff    	jne    80100d17 <exec+0x20d>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dcd:	83 c0 03             	add    $0x3,%eax
80100dd0:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100dd7:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100ddb:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100de2:	ff ff ff 
  ustack[1] = argc;
80100de5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de8:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df1:	83 c0 01             	add    $0x1,%eax
80100df4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dfb:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dfe:	29 d0                	sub    %edx,%eax
80100e00:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e09:	83 c0 04             	add    $0x4,%eax
80100e0c:	c1 e0 02             	shl    $0x2,%eax
80100e0f:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e15:	83 c0 04             	add    $0x4,%eax
80100e18:	c1 e0 02             	shl    $0x2,%eax
80100e1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e1f:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e25:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e29:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e33:	89 04 24             	mov    %eax,(%esp)
80100e36:	e8 2e 7b 00 00       	call   80108969 <copyout>
80100e3b:	85 c0                	test   %eax,%eax
80100e3d:	79 05                	jns    80100e44 <exec+0x33a>
    goto bad;
80100e3f:	e9 c0 00 00 00       	jmp    80100f04 <exec+0x3fa>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e44:	8b 45 08             	mov    0x8(%ebp),%eax
80100e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e50:	eb 17                	jmp    80100e69 <exec+0x35f>
    if(*s == '/')
80100e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e55:	0f b6 00             	movzbl (%eax),%eax
80100e58:	3c 2f                	cmp    $0x2f,%al
80100e5a:	75 09                	jne    80100e65 <exec+0x35b>
      last = s+1;
80100e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e5f:	83 c0 01             	add    $0x1,%eax
80100e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e6c:	0f b6 00             	movzbl (%eax),%eax
80100e6f:	84 c0                	test   %al,%al
80100e71:	75 df                	jne    80100e52 <exec+0x348>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e79:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e7c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e83:	00 
80100e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e8b:	89 14 24             	mov    %edx,(%esp)
80100e8e:	e8 65 49 00 00       	call   801057f8 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e99:	8b 40 04             	mov    0x4(%eax),%eax
80100e9c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->priority = 4;
80100e9f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea5:	c7 40 7c 04 00 00 00 	movl   $0x4,0x7c(%eax)
  proc->pgdir = pgdir;
80100eac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100eb5:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100eb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebe:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ec1:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ec3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec9:	8b 40 18             	mov    0x18(%eax),%eax
80100ecc:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ed2:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ed5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100edb:	8b 40 18             	mov    0x18(%eax),%eax
80100ede:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ee1:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ee4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eea:	89 04 24             	mov    %eax,(%esp)
80100eed:	e8 a5 73 00 00       	call   80108297 <switchuvm>
  freevm(oldpgdir);
80100ef2:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ef5:	89 04 24             	mov    %eax,(%esp)
80100ef8:	e8 0d 78 00 00       	call   8010870a <freevm>
  return 0;
80100efd:	b8 00 00 00 00       	mov    $0x0,%eax
80100f02:	eb 2c                	jmp    80100f30 <exec+0x426>

 bad:
  if(pgdir)
80100f04:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f08:	74 0b                	je     80100f15 <exec+0x40b>
    freevm(pgdir);
80100f0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f0d:	89 04 24             	mov    %eax,(%esp)
80100f10:	e8 f5 77 00 00       	call   8010870a <freevm>
  if(ip){
80100f15:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f19:	74 10                	je     80100f2b <exec+0x421>
    iunlockput(ip);
80100f1b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f1e:	89 04 24             	mov    %eax,(%esp)
80100f21:	e8 45 0c 00 00       	call   80101b6b <iunlockput>
    end_op();
80100f26:	e8 22 26 00 00       	call   8010354d <end_op>
  }
  return -1;
80100f2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f30:	c9                   	leave  
80100f31:	c3                   	ret    

80100f32 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f32:	55                   	push   %ebp
80100f33:	89 e5                	mov    %esp,%ebp
80100f35:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f38:	c7 44 24 04 92 8b 10 	movl   $0x80108b92,0x4(%esp)
80100f3f:	80 
80100f40:	c7 04 24 80 18 11 80 	movl   $0x80111880,(%esp)
80100f47:	e8 17 44 00 00       	call   80105363 <initlock>
}
80100f4c:	c9                   	leave  
80100f4d:	c3                   	ret    

80100f4e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f4e:	55                   	push   %ebp
80100f4f:	89 e5                	mov    %esp,%ebp
80100f51:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f54:	c7 04 24 80 18 11 80 	movl   $0x80111880,(%esp)
80100f5b:	e8 24 44 00 00       	call   80105384 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f60:	c7 45 f4 b4 18 11 80 	movl   $0x801118b4,-0xc(%ebp)
80100f67:	eb 29                	jmp    80100f92 <filealloc+0x44>
    if(f->ref == 0){
80100f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f6c:	8b 40 04             	mov    0x4(%eax),%eax
80100f6f:	85 c0                	test   %eax,%eax
80100f71:	75 1b                	jne    80100f8e <filealloc+0x40>
      f->ref = 1;
80100f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f76:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f7d:	c7 04 24 80 18 11 80 	movl   $0x80111880,(%esp)
80100f84:	e8 5d 44 00 00       	call   801053e6 <release>
      return f;
80100f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f8c:	eb 1e                	jmp    80100fac <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f8e:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f92:	81 7d f4 14 22 11 80 	cmpl   $0x80112214,-0xc(%ebp)
80100f99:	72 ce                	jb     80100f69 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f9b:	c7 04 24 80 18 11 80 	movl   $0x80111880,(%esp)
80100fa2:	e8 3f 44 00 00       	call   801053e6 <release>
  return 0;
80100fa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fac:	c9                   	leave  
80100fad:	c3                   	ret    

80100fae <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fae:	55                   	push   %ebp
80100faf:	89 e5                	mov    %esp,%ebp
80100fb1:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100fb4:	c7 04 24 80 18 11 80 	movl   $0x80111880,(%esp)
80100fbb:	e8 c4 43 00 00       	call   80105384 <acquire>
  if(f->ref < 1)
80100fc0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc3:	8b 40 04             	mov    0x4(%eax),%eax
80100fc6:	85 c0                	test   %eax,%eax
80100fc8:	7f 0c                	jg     80100fd6 <filedup+0x28>
    panic("filedup");
80100fca:	c7 04 24 99 8b 10 80 	movl   $0x80108b99,(%esp)
80100fd1:	e8 64 f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fd6:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd9:	8b 40 04             	mov    0x4(%eax),%eax
80100fdc:	8d 50 01             	lea    0x1(%eax),%edx
80100fdf:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe2:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fe5:	c7 04 24 80 18 11 80 	movl   $0x80111880,(%esp)
80100fec:	e8 f5 43 00 00       	call   801053e6 <release>
  return f;
80100ff1:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100ff4:	c9                   	leave  
80100ff5:	c3                   	ret    

80100ff6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ff6:	55                   	push   %ebp
80100ff7:	89 e5                	mov    %esp,%ebp
80100ff9:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100ffc:	c7 04 24 80 18 11 80 	movl   $0x80111880,(%esp)
80101003:	e8 7c 43 00 00       	call   80105384 <acquire>
  if(f->ref < 1)
80101008:	8b 45 08             	mov    0x8(%ebp),%eax
8010100b:	8b 40 04             	mov    0x4(%eax),%eax
8010100e:	85 c0                	test   %eax,%eax
80101010:	7f 0c                	jg     8010101e <fileclose+0x28>
    panic("fileclose");
80101012:	c7 04 24 a1 8b 10 80 	movl   $0x80108ba1,(%esp)
80101019:	e8 1c f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
8010101e:	8b 45 08             	mov    0x8(%ebp),%eax
80101021:	8b 40 04             	mov    0x4(%eax),%eax
80101024:	8d 50 ff             	lea    -0x1(%eax),%edx
80101027:	8b 45 08             	mov    0x8(%ebp),%eax
8010102a:	89 50 04             	mov    %edx,0x4(%eax)
8010102d:	8b 45 08             	mov    0x8(%ebp),%eax
80101030:	8b 40 04             	mov    0x4(%eax),%eax
80101033:	85 c0                	test   %eax,%eax
80101035:	7e 11                	jle    80101048 <fileclose+0x52>
    release(&ftable.lock);
80101037:	c7 04 24 80 18 11 80 	movl   $0x80111880,(%esp)
8010103e:	e8 a3 43 00 00       	call   801053e6 <release>
80101043:	e9 82 00 00 00       	jmp    801010ca <fileclose+0xd4>
    return;
  }
  ff = *f;
80101048:	8b 45 08             	mov    0x8(%ebp),%eax
8010104b:	8b 10                	mov    (%eax),%edx
8010104d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101050:	8b 50 04             	mov    0x4(%eax),%edx
80101053:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101056:	8b 50 08             	mov    0x8(%eax),%edx
80101059:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010105c:	8b 50 0c             	mov    0xc(%eax),%edx
8010105f:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101062:	8b 50 10             	mov    0x10(%eax),%edx
80101065:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101068:	8b 40 14             	mov    0x14(%eax),%eax
8010106b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010106e:	8b 45 08             	mov    0x8(%ebp),%eax
80101071:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101078:	8b 45 08             	mov    0x8(%ebp),%eax
8010107b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101081:	c7 04 24 80 18 11 80 	movl   $0x80111880,(%esp)
80101088:	e8 59 43 00 00       	call   801053e6 <release>
  
  if(ff.type == FD_PIPE)
8010108d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101090:	83 f8 01             	cmp    $0x1,%eax
80101093:	75 18                	jne    801010ad <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
80101095:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101099:	0f be d0             	movsbl %al,%edx
8010109c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010109f:	89 54 24 04          	mov    %edx,0x4(%esp)
801010a3:	89 04 24             	mov    %eax,(%esp)
801010a6:	e8 6d 30 00 00       	call   80104118 <pipeclose>
801010ab:	eb 1d                	jmp    801010ca <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b0:	83 f8 02             	cmp    $0x2,%eax
801010b3:	75 15                	jne    801010ca <fileclose+0xd4>
    begin_op();
801010b5:	e8 0f 24 00 00       	call   801034c9 <begin_op>
    iput(ff.ip);
801010ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010bd:	89 04 24             	mov    %eax,(%esp)
801010c0:	e8 d5 09 00 00       	call   80101a9a <iput>
    end_op();
801010c5:	e8 83 24 00 00       	call   8010354d <end_op>
  }
}
801010ca:	c9                   	leave  
801010cb:	c3                   	ret    

801010cc <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010cc:	55                   	push   %ebp
801010cd:	89 e5                	mov    %esp,%ebp
801010cf:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010d2:	8b 45 08             	mov    0x8(%ebp),%eax
801010d5:	8b 00                	mov    (%eax),%eax
801010d7:	83 f8 02             	cmp    $0x2,%eax
801010da:	75 38                	jne    80101114 <filestat+0x48>
    ilock(f->ip);
801010dc:	8b 45 08             	mov    0x8(%ebp),%eax
801010df:	8b 40 10             	mov    0x10(%eax),%eax
801010e2:	89 04 24             	mov    %eax,(%esp)
801010e5:	e8 f7 07 00 00       	call   801018e1 <ilock>
    stati(f->ip, st);
801010ea:	8b 45 08             	mov    0x8(%ebp),%eax
801010ed:	8b 40 10             	mov    0x10(%eax),%eax
801010f0:	8b 55 0c             	mov    0xc(%ebp),%edx
801010f3:	89 54 24 04          	mov    %edx,0x4(%esp)
801010f7:	89 04 24             	mov    %eax,(%esp)
801010fa:	e8 b0 0c 00 00       	call   80101daf <stati>
    iunlock(f->ip);
801010ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101102:	8b 40 10             	mov    0x10(%eax),%eax
80101105:	89 04 24             	mov    %eax,(%esp)
80101108:	e8 28 09 00 00       	call   80101a35 <iunlock>
    return 0;
8010110d:	b8 00 00 00 00       	mov    $0x0,%eax
80101112:	eb 05                	jmp    80101119 <filestat+0x4d>
  }
  return -1;
80101114:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101119:	c9                   	leave  
8010111a:	c3                   	ret    

8010111b <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010111b:	55                   	push   %ebp
8010111c:	89 e5                	mov    %esp,%ebp
8010111e:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
80101121:	8b 45 08             	mov    0x8(%ebp),%eax
80101124:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101128:	84 c0                	test   %al,%al
8010112a:	75 0a                	jne    80101136 <fileread+0x1b>
    return -1;
8010112c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101131:	e9 9f 00 00 00       	jmp    801011d5 <fileread+0xba>
  if(f->type == FD_PIPE)
80101136:	8b 45 08             	mov    0x8(%ebp),%eax
80101139:	8b 00                	mov    (%eax),%eax
8010113b:	83 f8 01             	cmp    $0x1,%eax
8010113e:	75 1e                	jne    8010115e <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101140:	8b 45 08             	mov    0x8(%ebp),%eax
80101143:	8b 40 0c             	mov    0xc(%eax),%eax
80101146:	8b 55 10             	mov    0x10(%ebp),%edx
80101149:	89 54 24 08          	mov    %edx,0x8(%esp)
8010114d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101150:	89 54 24 04          	mov    %edx,0x4(%esp)
80101154:	89 04 24             	mov    %eax,(%esp)
80101157:	e8 3d 31 00 00       	call   80104299 <piperead>
8010115c:	eb 77                	jmp    801011d5 <fileread+0xba>
  if(f->type == FD_INODE){
8010115e:	8b 45 08             	mov    0x8(%ebp),%eax
80101161:	8b 00                	mov    (%eax),%eax
80101163:	83 f8 02             	cmp    $0x2,%eax
80101166:	75 61                	jne    801011c9 <fileread+0xae>
    ilock(f->ip);
80101168:	8b 45 08             	mov    0x8(%ebp),%eax
8010116b:	8b 40 10             	mov    0x10(%eax),%eax
8010116e:	89 04 24             	mov    %eax,(%esp)
80101171:	e8 6b 07 00 00       	call   801018e1 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101176:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101179:	8b 45 08             	mov    0x8(%ebp),%eax
8010117c:	8b 50 14             	mov    0x14(%eax),%edx
8010117f:	8b 45 08             	mov    0x8(%ebp),%eax
80101182:	8b 40 10             	mov    0x10(%eax),%eax
80101185:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101189:	89 54 24 08          	mov    %edx,0x8(%esp)
8010118d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101190:	89 54 24 04          	mov    %edx,0x4(%esp)
80101194:	89 04 24             	mov    %eax,(%esp)
80101197:	e8 58 0c 00 00       	call   80101df4 <readi>
8010119c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010119f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011a3:	7e 11                	jle    801011b6 <fileread+0x9b>
      f->off += r;
801011a5:	8b 45 08             	mov    0x8(%ebp),%eax
801011a8:	8b 50 14             	mov    0x14(%eax),%edx
801011ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011ae:	01 c2                	add    %eax,%edx
801011b0:	8b 45 08             	mov    0x8(%ebp),%eax
801011b3:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011b6:	8b 45 08             	mov    0x8(%ebp),%eax
801011b9:	8b 40 10             	mov    0x10(%eax),%eax
801011bc:	89 04 24             	mov    %eax,(%esp)
801011bf:	e8 71 08 00 00       	call   80101a35 <iunlock>
    return r;
801011c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011c7:	eb 0c                	jmp    801011d5 <fileread+0xba>
  }
  panic("fileread");
801011c9:	c7 04 24 ab 8b 10 80 	movl   $0x80108bab,(%esp)
801011d0:	e8 65 f3 ff ff       	call   8010053a <panic>
}
801011d5:	c9                   	leave  
801011d6:	c3                   	ret    

801011d7 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011d7:	55                   	push   %ebp
801011d8:	89 e5                	mov    %esp,%ebp
801011da:	53                   	push   %ebx
801011db:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011de:	8b 45 08             	mov    0x8(%ebp),%eax
801011e1:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011e5:	84 c0                	test   %al,%al
801011e7:	75 0a                	jne    801011f3 <filewrite+0x1c>
    return -1;
801011e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011ee:	e9 20 01 00 00       	jmp    80101313 <filewrite+0x13c>
  if(f->type == FD_PIPE)
801011f3:	8b 45 08             	mov    0x8(%ebp),%eax
801011f6:	8b 00                	mov    (%eax),%eax
801011f8:	83 f8 01             	cmp    $0x1,%eax
801011fb:	75 21                	jne    8010121e <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101200:	8b 40 0c             	mov    0xc(%eax),%eax
80101203:	8b 55 10             	mov    0x10(%ebp),%edx
80101206:	89 54 24 08          	mov    %edx,0x8(%esp)
8010120a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010120d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101211:	89 04 24             	mov    %eax,(%esp)
80101214:	e8 91 2f 00 00       	call   801041aa <pipewrite>
80101219:	e9 f5 00 00 00       	jmp    80101313 <filewrite+0x13c>
  if(f->type == FD_INODE){
8010121e:	8b 45 08             	mov    0x8(%ebp),%eax
80101221:	8b 00                	mov    (%eax),%eax
80101223:	83 f8 02             	cmp    $0x2,%eax
80101226:	0f 85 db 00 00 00    	jne    80101307 <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010122c:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101233:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010123a:	e9 a8 00 00 00       	jmp    801012e7 <filewrite+0x110>
      int n1 = n - i;
8010123f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101242:	8b 55 10             	mov    0x10(%ebp),%edx
80101245:	29 c2                	sub    %eax,%edx
80101247:	89 d0                	mov    %edx,%eax
80101249:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010124c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010124f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101252:	7e 06                	jle    8010125a <filewrite+0x83>
        n1 = max;
80101254:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101257:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010125a:	e8 6a 22 00 00       	call   801034c9 <begin_op>
      ilock(f->ip);
8010125f:	8b 45 08             	mov    0x8(%ebp),%eax
80101262:	8b 40 10             	mov    0x10(%eax),%eax
80101265:	89 04 24             	mov    %eax,(%esp)
80101268:	e8 74 06 00 00       	call   801018e1 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010126d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101270:	8b 45 08             	mov    0x8(%ebp),%eax
80101273:	8b 50 14             	mov    0x14(%eax),%edx
80101276:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101279:	8b 45 0c             	mov    0xc(%ebp),%eax
8010127c:	01 c3                	add    %eax,%ebx
8010127e:	8b 45 08             	mov    0x8(%ebp),%eax
80101281:	8b 40 10             	mov    0x10(%eax),%eax
80101284:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101288:	89 54 24 08          	mov    %edx,0x8(%esp)
8010128c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101290:	89 04 24             	mov    %eax,(%esp)
80101293:	e8 c0 0c 00 00       	call   80101f58 <writei>
80101298:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010129b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010129f:	7e 11                	jle    801012b2 <filewrite+0xdb>
        f->off += r;
801012a1:	8b 45 08             	mov    0x8(%ebp),%eax
801012a4:	8b 50 14             	mov    0x14(%eax),%edx
801012a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012aa:	01 c2                	add    %eax,%edx
801012ac:	8b 45 08             	mov    0x8(%ebp),%eax
801012af:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012b2:	8b 45 08             	mov    0x8(%ebp),%eax
801012b5:	8b 40 10             	mov    0x10(%eax),%eax
801012b8:	89 04 24             	mov    %eax,(%esp)
801012bb:	e8 75 07 00 00       	call   80101a35 <iunlock>
      end_op();
801012c0:	e8 88 22 00 00       	call   8010354d <end_op>

      if(r < 0)
801012c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012c9:	79 02                	jns    801012cd <filewrite+0xf6>
        break;
801012cb:	eb 26                	jmp    801012f3 <filewrite+0x11c>
      if(r != n1)
801012cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012d3:	74 0c                	je     801012e1 <filewrite+0x10a>
        panic("short filewrite");
801012d5:	c7 04 24 b4 8b 10 80 	movl   $0x80108bb4,(%esp)
801012dc:	e8 59 f2 ff ff       	call   8010053a <panic>
      i += r;
801012e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012e4:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ea:	3b 45 10             	cmp    0x10(%ebp),%eax
801012ed:	0f 8c 4c ff ff ff    	jl     8010123f <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012f6:	3b 45 10             	cmp    0x10(%ebp),%eax
801012f9:	75 05                	jne    80101300 <filewrite+0x129>
801012fb:	8b 45 10             	mov    0x10(%ebp),%eax
801012fe:	eb 05                	jmp    80101305 <filewrite+0x12e>
80101300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101305:	eb 0c                	jmp    80101313 <filewrite+0x13c>
  }
  panic("filewrite");
80101307:	c7 04 24 c4 8b 10 80 	movl   $0x80108bc4,(%esp)
8010130e:	e8 27 f2 ff ff       	call   8010053a <panic>
}
80101313:	83 c4 24             	add    $0x24,%esp
80101316:	5b                   	pop    %ebx
80101317:	5d                   	pop    %ebp
80101318:	c3                   	ret    

80101319 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101319:	55                   	push   %ebp
8010131a:	89 e5                	mov    %esp,%ebp
8010131c:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010131f:	8b 45 08             	mov    0x8(%ebp),%eax
80101322:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101329:	00 
8010132a:	89 04 24             	mov    %eax,(%esp)
8010132d:	e8 74 ee ff ff       	call   801001a6 <bread>
80101332:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101338:	83 c0 18             	add    $0x18,%eax
8010133b:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101342:	00 
80101343:	89 44 24 04          	mov    %eax,0x4(%esp)
80101347:	8b 45 0c             	mov    0xc(%ebp),%eax
8010134a:	89 04 24             	mov    %eax,(%esp)
8010134d:	e8 55 43 00 00       	call   801056a7 <memmove>
  brelse(bp);
80101352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101355:	89 04 24             	mov    %eax,(%esp)
80101358:	e8 ba ee ff ff       	call   80100217 <brelse>
}
8010135d:	c9                   	leave  
8010135e:	c3                   	ret    

8010135f <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010135f:	55                   	push   %ebp
80101360:	89 e5                	mov    %esp,%ebp
80101362:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101365:	8b 55 0c             	mov    0xc(%ebp),%edx
80101368:	8b 45 08             	mov    0x8(%ebp),%eax
8010136b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010136f:	89 04 24             	mov    %eax,(%esp)
80101372:	e8 2f ee ff ff       	call   801001a6 <bread>
80101377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010137a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010137d:	83 c0 18             	add    $0x18,%eax
80101380:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101387:	00 
80101388:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010138f:	00 
80101390:	89 04 24             	mov    %eax,(%esp)
80101393:	e8 40 42 00 00       	call   801055d8 <memset>
  log_write(bp);
80101398:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010139b:	89 04 24             	mov    %eax,(%esp)
8010139e:	e8 31 23 00 00       	call   801036d4 <log_write>
  brelse(bp);
801013a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a6:	89 04 24             	mov    %eax,(%esp)
801013a9:	e8 69 ee ff ff       	call   80100217 <brelse>
}
801013ae:	c9                   	leave  
801013af:	c3                   	ret    

801013b0 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801013b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801013bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013c4:	e9 07 01 00 00       	jmp    801014d0 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
801013c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013cc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013d2:	85 c0                	test   %eax,%eax
801013d4:	0f 48 c2             	cmovs  %edx,%eax
801013d7:	c1 f8 0c             	sar    $0xc,%eax
801013da:	89 c2                	mov    %eax,%edx
801013dc:	a1 98 22 11 80       	mov    0x80112298,%eax
801013e1:	01 d0                	add    %edx,%eax
801013e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801013e7:	8b 45 08             	mov    0x8(%ebp),%eax
801013ea:	89 04 24             	mov    %eax,(%esp)
801013ed:	e8 b4 ed ff ff       	call   801001a6 <bread>
801013f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013fc:	e9 9d 00 00 00       	jmp    8010149e <balloc+0xee>
      m = 1 << (bi % 8);
80101401:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101404:	99                   	cltd   
80101405:	c1 ea 1d             	shr    $0x1d,%edx
80101408:	01 d0                	add    %edx,%eax
8010140a:	83 e0 07             	and    $0x7,%eax
8010140d:	29 d0                	sub    %edx,%eax
8010140f:	ba 01 00 00 00       	mov    $0x1,%edx
80101414:	89 c1                	mov    %eax,%ecx
80101416:	d3 e2                	shl    %cl,%edx
80101418:	89 d0                	mov    %edx,%eax
8010141a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010141d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101420:	8d 50 07             	lea    0x7(%eax),%edx
80101423:	85 c0                	test   %eax,%eax
80101425:	0f 48 c2             	cmovs  %edx,%eax
80101428:	c1 f8 03             	sar    $0x3,%eax
8010142b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010142e:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101433:	0f b6 c0             	movzbl %al,%eax
80101436:	23 45 e8             	and    -0x18(%ebp),%eax
80101439:	85 c0                	test   %eax,%eax
8010143b:	75 5d                	jne    8010149a <balloc+0xea>
        bp->data[bi/8] |= m;  // Mark block in use.
8010143d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101440:	8d 50 07             	lea    0x7(%eax),%edx
80101443:	85 c0                	test   %eax,%eax
80101445:	0f 48 c2             	cmovs  %edx,%eax
80101448:	c1 f8 03             	sar    $0x3,%eax
8010144b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010144e:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101453:	89 d1                	mov    %edx,%ecx
80101455:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101458:	09 ca                	or     %ecx,%edx
8010145a:	89 d1                	mov    %edx,%ecx
8010145c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010145f:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101463:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101466:	89 04 24             	mov    %eax,(%esp)
80101469:	e8 66 22 00 00       	call   801036d4 <log_write>
        brelse(bp);
8010146e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101471:	89 04 24             	mov    %eax,(%esp)
80101474:	e8 9e ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101479:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010147c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010147f:	01 c2                	add    %eax,%edx
80101481:	8b 45 08             	mov    0x8(%ebp),%eax
80101484:	89 54 24 04          	mov    %edx,0x4(%esp)
80101488:	89 04 24             	mov    %eax,(%esp)
8010148b:	e8 cf fe ff ff       	call   8010135f <bzero>
        return b + bi;
80101490:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101493:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101496:	01 d0                	add    %edx,%eax
80101498:	eb 52                	jmp    801014ec <balloc+0x13c>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010149a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010149e:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014a5:	7f 17                	jg     801014be <balloc+0x10e>
801014a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ad:	01 d0                	add    %edx,%eax
801014af:	89 c2                	mov    %eax,%edx
801014b1:	a1 80 22 11 80       	mov    0x80112280,%eax
801014b6:	39 c2                	cmp    %eax,%edx
801014b8:	0f 82 43 ff ff ff    	jb     80101401 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014c1:	89 04 24             	mov    %eax,(%esp)
801014c4:	e8 4e ed ff ff       	call   80100217 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801014c9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014d3:	a1 80 22 11 80       	mov    0x80112280,%eax
801014d8:	39 c2                	cmp    %eax,%edx
801014da:	0f 82 e9 fe ff ff    	jb     801013c9 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014e0:	c7 04 24 d0 8b 10 80 	movl   $0x80108bd0,(%esp)
801014e7:	e8 4e f0 ff ff       	call   8010053a <panic>
}
801014ec:	c9                   	leave  
801014ed:	c3                   	ret    

801014ee <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014ee:	55                   	push   %ebp
801014ef:	89 e5                	mov    %esp,%ebp
801014f1:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801014f4:	c7 44 24 04 80 22 11 	movl   $0x80112280,0x4(%esp)
801014fb:	80 
801014fc:	8b 45 08             	mov    0x8(%ebp),%eax
801014ff:	89 04 24             	mov    %eax,(%esp)
80101502:	e8 12 fe ff ff       	call   80101319 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101507:	8b 45 0c             	mov    0xc(%ebp),%eax
8010150a:	c1 e8 0c             	shr    $0xc,%eax
8010150d:	89 c2                	mov    %eax,%edx
8010150f:	a1 98 22 11 80       	mov    0x80112298,%eax
80101514:	01 c2                	add    %eax,%edx
80101516:	8b 45 08             	mov    0x8(%ebp),%eax
80101519:	89 54 24 04          	mov    %edx,0x4(%esp)
8010151d:	89 04 24             	mov    %eax,(%esp)
80101520:	e8 81 ec ff ff       	call   801001a6 <bread>
80101525:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101528:	8b 45 0c             	mov    0xc(%ebp),%eax
8010152b:	25 ff 0f 00 00       	and    $0xfff,%eax
80101530:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101533:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101536:	99                   	cltd   
80101537:	c1 ea 1d             	shr    $0x1d,%edx
8010153a:	01 d0                	add    %edx,%eax
8010153c:	83 e0 07             	and    $0x7,%eax
8010153f:	29 d0                	sub    %edx,%eax
80101541:	ba 01 00 00 00       	mov    $0x1,%edx
80101546:	89 c1                	mov    %eax,%ecx
80101548:	d3 e2                	shl    %cl,%edx
8010154a:	89 d0                	mov    %edx,%eax
8010154c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010154f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101552:	8d 50 07             	lea    0x7(%eax),%edx
80101555:	85 c0                	test   %eax,%eax
80101557:	0f 48 c2             	cmovs  %edx,%eax
8010155a:	c1 f8 03             	sar    $0x3,%eax
8010155d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101560:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101565:	0f b6 c0             	movzbl %al,%eax
80101568:	23 45 ec             	and    -0x14(%ebp),%eax
8010156b:	85 c0                	test   %eax,%eax
8010156d:	75 0c                	jne    8010157b <bfree+0x8d>
    panic("freeing free block");
8010156f:	c7 04 24 e6 8b 10 80 	movl   $0x80108be6,(%esp)
80101576:	e8 bf ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
8010157b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010157e:	8d 50 07             	lea    0x7(%eax),%edx
80101581:	85 c0                	test   %eax,%eax
80101583:	0f 48 c2             	cmovs  %edx,%eax
80101586:	c1 f8 03             	sar    $0x3,%eax
80101589:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010158c:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101591:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101594:	f7 d1                	not    %ecx
80101596:	21 ca                	and    %ecx,%edx
80101598:	89 d1                	mov    %edx,%ecx
8010159a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010159d:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015a4:	89 04 24             	mov    %eax,(%esp)
801015a7:	e8 28 21 00 00       	call   801036d4 <log_write>
  brelse(bp);
801015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015af:	89 04 24             	mov    %eax,(%esp)
801015b2:	e8 60 ec ff ff       	call   80100217 <brelse>
}
801015b7:	c9                   	leave  
801015b8:	c3                   	ret    

801015b9 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801015b9:	55                   	push   %ebp
801015ba:	89 e5                	mov    %esp,%ebp
801015bc:	57                   	push   %edi
801015bd:	56                   	push   %esi
801015be:	53                   	push   %ebx
801015bf:	83 ec 3c             	sub    $0x3c,%esp
  initlock(&icache.lock, "icache");
801015c2:	c7 44 24 04 f9 8b 10 	movl   $0x80108bf9,0x4(%esp)
801015c9:	80 
801015ca:	c7 04 24 a0 22 11 80 	movl   $0x801122a0,(%esp)
801015d1:	e8 8d 3d 00 00       	call   80105363 <initlock>
  readsb(dev, &sb);
801015d6:	c7 44 24 04 80 22 11 	movl   $0x80112280,0x4(%esp)
801015dd:	80 
801015de:	8b 45 08             	mov    0x8(%ebp),%eax
801015e1:	89 04 24             	mov    %eax,(%esp)
801015e4:	e8 30 fd ff ff       	call   80101319 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
801015e9:	a1 98 22 11 80       	mov    0x80112298,%eax
801015ee:	8b 3d 94 22 11 80    	mov    0x80112294,%edi
801015f4:	8b 35 90 22 11 80    	mov    0x80112290,%esi
801015fa:	8b 1d 8c 22 11 80    	mov    0x8011228c,%ebx
80101600:	8b 0d 88 22 11 80    	mov    0x80112288,%ecx
80101606:	8b 15 84 22 11 80    	mov    0x80112284,%edx
8010160c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010160f:	8b 15 80 22 11 80    	mov    0x80112280,%edx
80101615:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101619:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010161d:	89 74 24 14          	mov    %esi,0x14(%esp)
80101621:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80101625:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010162c:	89 44 24 08          	mov    %eax,0x8(%esp)
80101630:	89 d0                	mov    %edx,%eax
80101632:	89 44 24 04          	mov    %eax,0x4(%esp)
80101636:	c7 04 24 00 8c 10 80 	movl   $0x80108c00,(%esp)
8010163d:	e8 5e ed ff ff       	call   801003a0 <cprintf>
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
80101642:	83 c4 3c             	add    $0x3c,%esp
80101645:	5b                   	pop    %ebx
80101646:	5e                   	pop    %esi
80101647:	5f                   	pop    %edi
80101648:	5d                   	pop    %ebp
80101649:	c3                   	ret    

8010164a <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010164a:	55                   	push   %ebp
8010164b:	89 e5                	mov    %esp,%ebp
8010164d:	83 ec 28             	sub    $0x28,%esp
80101650:	8b 45 0c             	mov    0xc(%ebp),%eax
80101653:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101657:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010165e:	e9 9e 00 00 00       	jmp    80101701 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101663:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101666:	c1 e8 03             	shr    $0x3,%eax
80101669:	89 c2                	mov    %eax,%edx
8010166b:	a1 94 22 11 80       	mov    0x80112294,%eax
80101670:	01 d0                	add    %edx,%eax
80101672:	89 44 24 04          	mov    %eax,0x4(%esp)
80101676:	8b 45 08             	mov    0x8(%ebp),%eax
80101679:	89 04 24             	mov    %eax,(%esp)
8010167c:	e8 25 eb ff ff       	call   801001a6 <bread>
80101681:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101684:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101687:	8d 50 18             	lea    0x18(%eax),%edx
8010168a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010168d:	83 e0 07             	and    $0x7,%eax
80101690:	c1 e0 06             	shl    $0x6,%eax
80101693:	01 d0                	add    %edx,%eax
80101695:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101698:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010169b:	0f b7 00             	movzwl (%eax),%eax
8010169e:	66 85 c0             	test   %ax,%ax
801016a1:	75 4f                	jne    801016f2 <ialloc+0xa8>
      memset(dip, 0, sizeof(*dip));
801016a3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801016aa:	00 
801016ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801016b2:	00 
801016b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016b6:	89 04 24             	mov    %eax,(%esp)
801016b9:	e8 1a 3f 00 00       	call   801055d8 <memset>
      dip->type = type;
801016be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016c1:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801016c5:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801016c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016cb:	89 04 24             	mov    %eax,(%esp)
801016ce:	e8 01 20 00 00       	call   801036d4 <log_write>
      brelse(bp);
801016d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016d6:	89 04 24             	mov    %eax,(%esp)
801016d9:	e8 39 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
801016de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801016e5:	8b 45 08             	mov    0x8(%ebp),%eax
801016e8:	89 04 24             	mov    %eax,(%esp)
801016eb:	e8 ed 00 00 00       	call   801017dd <iget>
801016f0:	eb 2b                	jmp    8010171d <ialloc+0xd3>
    }
    brelse(bp);
801016f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f5:	89 04 24             	mov    %eax,(%esp)
801016f8:	e8 1a eb ff ff       	call   80100217 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101701:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101704:	a1 88 22 11 80       	mov    0x80112288,%eax
80101709:	39 c2                	cmp    %eax,%edx
8010170b:	0f 82 52 ff ff ff    	jb     80101663 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101711:	c7 04 24 53 8c 10 80 	movl   $0x80108c53,(%esp)
80101718:	e8 1d ee ff ff       	call   8010053a <panic>
}
8010171d:	c9                   	leave  
8010171e:	c3                   	ret    

8010171f <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010171f:	55                   	push   %ebp
80101720:	89 e5                	mov    %esp,%ebp
80101722:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101725:	8b 45 08             	mov    0x8(%ebp),%eax
80101728:	8b 40 04             	mov    0x4(%eax),%eax
8010172b:	c1 e8 03             	shr    $0x3,%eax
8010172e:	89 c2                	mov    %eax,%edx
80101730:	a1 94 22 11 80       	mov    0x80112294,%eax
80101735:	01 c2                	add    %eax,%edx
80101737:	8b 45 08             	mov    0x8(%ebp),%eax
8010173a:	8b 00                	mov    (%eax),%eax
8010173c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101740:	89 04 24             	mov    %eax,(%esp)
80101743:	e8 5e ea ff ff       	call   801001a6 <bread>
80101748:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010174b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010174e:	8d 50 18             	lea    0x18(%eax),%edx
80101751:	8b 45 08             	mov    0x8(%ebp),%eax
80101754:	8b 40 04             	mov    0x4(%eax),%eax
80101757:	83 e0 07             	and    $0x7,%eax
8010175a:	c1 e0 06             	shl    $0x6,%eax
8010175d:	01 d0                	add    %edx,%eax
8010175f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101762:	8b 45 08             	mov    0x8(%ebp),%eax
80101765:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101769:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010176c:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010176f:	8b 45 08             	mov    0x8(%ebp),%eax
80101772:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101776:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101779:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010177d:	8b 45 08             	mov    0x8(%ebp),%eax
80101780:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101784:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101787:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010178b:	8b 45 08             	mov    0x8(%ebp),%eax
8010178e:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101792:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101795:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101799:	8b 45 08             	mov    0x8(%ebp),%eax
8010179c:	8b 50 18             	mov    0x18(%eax),%edx
8010179f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a2:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017a5:	8b 45 08             	mov    0x8(%ebp),%eax
801017a8:	8d 50 1c             	lea    0x1c(%eax),%edx
801017ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017ae:	83 c0 0c             	add    $0xc,%eax
801017b1:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801017b8:	00 
801017b9:	89 54 24 04          	mov    %edx,0x4(%esp)
801017bd:	89 04 24             	mov    %eax,(%esp)
801017c0:	e8 e2 3e 00 00       	call   801056a7 <memmove>
  log_write(bp);
801017c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c8:	89 04 24             	mov    %eax,(%esp)
801017cb:	e8 04 1f 00 00       	call   801036d4 <log_write>
  brelse(bp);
801017d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d3:	89 04 24             	mov    %eax,(%esp)
801017d6:	e8 3c ea ff ff       	call   80100217 <brelse>
}
801017db:	c9                   	leave  
801017dc:	c3                   	ret    

801017dd <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017dd:	55                   	push   %ebp
801017de:	89 e5                	mov    %esp,%ebp
801017e0:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801017e3:	c7 04 24 a0 22 11 80 	movl   $0x801122a0,(%esp)
801017ea:	e8 95 3b 00 00       	call   80105384 <acquire>

  // Is the inode already cached?
  empty = 0;
801017ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017f6:	c7 45 f4 d4 22 11 80 	movl   $0x801122d4,-0xc(%ebp)
801017fd:	eb 59                	jmp    80101858 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101802:	8b 40 08             	mov    0x8(%eax),%eax
80101805:	85 c0                	test   %eax,%eax
80101807:	7e 35                	jle    8010183e <iget+0x61>
80101809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010180c:	8b 00                	mov    (%eax),%eax
8010180e:	3b 45 08             	cmp    0x8(%ebp),%eax
80101811:	75 2b                	jne    8010183e <iget+0x61>
80101813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101816:	8b 40 04             	mov    0x4(%eax),%eax
80101819:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010181c:	75 20                	jne    8010183e <iget+0x61>
      ip->ref++;
8010181e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101821:	8b 40 08             	mov    0x8(%eax),%eax
80101824:	8d 50 01             	lea    0x1(%eax),%edx
80101827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010182a:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010182d:	c7 04 24 a0 22 11 80 	movl   $0x801122a0,(%esp)
80101834:	e8 ad 3b 00 00       	call   801053e6 <release>
      return ip;
80101839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183c:	eb 6f                	jmp    801018ad <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010183e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101842:	75 10                	jne    80101854 <iget+0x77>
80101844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101847:	8b 40 08             	mov    0x8(%eax),%eax
8010184a:	85 c0                	test   %eax,%eax
8010184c:	75 06                	jne    80101854 <iget+0x77>
      empty = ip;
8010184e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101851:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101854:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101858:	81 7d f4 74 32 11 80 	cmpl   $0x80113274,-0xc(%ebp)
8010185f:	72 9e                	jb     801017ff <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101861:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101865:	75 0c                	jne    80101873 <iget+0x96>
    panic("iget: no inodes");
80101867:	c7 04 24 65 8c 10 80 	movl   $0x80108c65,(%esp)
8010186e:	e8 c7 ec ff ff       	call   8010053a <panic>

  ip = empty;
80101873:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101876:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101879:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010187c:	8b 55 08             	mov    0x8(%ebp),%edx
8010187f:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101884:	8b 55 0c             	mov    0xc(%ebp),%edx
80101887:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
8010188a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101897:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
8010189e:	c7 04 24 a0 22 11 80 	movl   $0x801122a0,(%esp)
801018a5:	e8 3c 3b 00 00       	call   801053e6 <release>

  return ip;
801018aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801018ad:	c9                   	leave  
801018ae:	c3                   	ret    

801018af <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018af:	55                   	push   %ebp
801018b0:	89 e5                	mov    %esp,%ebp
801018b2:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
801018b5:	c7 04 24 a0 22 11 80 	movl   $0x801122a0,(%esp)
801018bc:	e8 c3 3a 00 00       	call   80105384 <acquire>
  ip->ref++;
801018c1:	8b 45 08             	mov    0x8(%ebp),%eax
801018c4:	8b 40 08             	mov    0x8(%eax),%eax
801018c7:	8d 50 01             	lea    0x1(%eax),%edx
801018ca:	8b 45 08             	mov    0x8(%ebp),%eax
801018cd:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801018d0:	c7 04 24 a0 22 11 80 	movl   $0x801122a0,(%esp)
801018d7:	e8 0a 3b 00 00       	call   801053e6 <release>
  return ip;
801018dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
801018df:	c9                   	leave  
801018e0:	c3                   	ret    

801018e1 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018e1:	55                   	push   %ebp
801018e2:	89 e5                	mov    %esp,%ebp
801018e4:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801018eb:	74 0a                	je     801018f7 <ilock+0x16>
801018ed:	8b 45 08             	mov    0x8(%ebp),%eax
801018f0:	8b 40 08             	mov    0x8(%eax),%eax
801018f3:	85 c0                	test   %eax,%eax
801018f5:	7f 0c                	jg     80101903 <ilock+0x22>
    panic("ilock");
801018f7:	c7 04 24 75 8c 10 80 	movl   $0x80108c75,(%esp)
801018fe:	e8 37 ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101903:	c7 04 24 a0 22 11 80 	movl   $0x801122a0,(%esp)
8010190a:	e8 75 3a 00 00       	call   80105384 <acquire>
  while(ip->flags & I_BUSY)
8010190f:	eb 13                	jmp    80101924 <ilock+0x43>
    sleep(ip, &icache.lock);
80101911:	c7 44 24 04 a0 22 11 	movl   $0x801122a0,0x4(%esp)
80101918:	80 
80101919:	8b 45 08             	mov    0x8(%ebp),%eax
8010191c:	89 04 24             	mov    %eax,(%esp)
8010191f:	e8 70 34 00 00       	call   80104d94 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101924:	8b 45 08             	mov    0x8(%ebp),%eax
80101927:	8b 40 0c             	mov    0xc(%eax),%eax
8010192a:	83 e0 01             	and    $0x1,%eax
8010192d:	85 c0                	test   %eax,%eax
8010192f:	75 e0                	jne    80101911 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101931:	8b 45 08             	mov    0x8(%ebp),%eax
80101934:	8b 40 0c             	mov    0xc(%eax),%eax
80101937:	83 c8 01             	or     $0x1,%eax
8010193a:	89 c2                	mov    %eax,%edx
8010193c:	8b 45 08             	mov    0x8(%ebp),%eax
8010193f:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101942:	c7 04 24 a0 22 11 80 	movl   $0x801122a0,(%esp)
80101949:	e8 98 3a 00 00       	call   801053e6 <release>

  if(!(ip->flags & I_VALID)){
8010194e:	8b 45 08             	mov    0x8(%ebp),%eax
80101951:	8b 40 0c             	mov    0xc(%eax),%eax
80101954:	83 e0 02             	and    $0x2,%eax
80101957:	85 c0                	test   %eax,%eax
80101959:	0f 85 d4 00 00 00    	jne    80101a33 <ilock+0x152>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010195f:	8b 45 08             	mov    0x8(%ebp),%eax
80101962:	8b 40 04             	mov    0x4(%eax),%eax
80101965:	c1 e8 03             	shr    $0x3,%eax
80101968:	89 c2                	mov    %eax,%edx
8010196a:	a1 94 22 11 80       	mov    0x80112294,%eax
8010196f:	01 c2                	add    %eax,%edx
80101971:	8b 45 08             	mov    0x8(%ebp),%eax
80101974:	8b 00                	mov    (%eax),%eax
80101976:	89 54 24 04          	mov    %edx,0x4(%esp)
8010197a:	89 04 24             	mov    %eax,(%esp)
8010197d:	e8 24 e8 ff ff       	call   801001a6 <bread>
80101982:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101985:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101988:	8d 50 18             	lea    0x18(%eax),%edx
8010198b:	8b 45 08             	mov    0x8(%ebp),%eax
8010198e:	8b 40 04             	mov    0x4(%eax),%eax
80101991:	83 e0 07             	and    $0x7,%eax
80101994:	c1 e0 06             	shl    $0x6,%eax
80101997:	01 d0                	add    %edx,%eax
80101999:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
8010199c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010199f:	0f b7 10             	movzwl (%eax),%edx
801019a2:	8b 45 08             	mov    0x8(%ebp),%eax
801019a5:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
801019a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ac:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801019b0:	8b 45 08             	mov    0x8(%ebp),%eax
801019b3:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
801019b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ba:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801019be:	8b 45 08             	mov    0x8(%ebp),%eax
801019c1:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
801019c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019c8:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801019cc:	8b 45 08             	mov    0x8(%ebp),%eax
801019cf:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
801019d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019d6:	8b 50 08             	mov    0x8(%eax),%edx
801019d9:	8b 45 08             	mov    0x8(%ebp),%eax
801019dc:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019e2:	8d 50 0c             	lea    0xc(%eax),%edx
801019e5:	8b 45 08             	mov    0x8(%ebp),%eax
801019e8:	83 c0 1c             	add    $0x1c,%eax
801019eb:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801019f2:	00 
801019f3:	89 54 24 04          	mov    %edx,0x4(%esp)
801019f7:	89 04 24             	mov    %eax,(%esp)
801019fa:	e8 a8 3c 00 00       	call   801056a7 <memmove>
    brelse(bp);
801019ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a02:	89 04 24             	mov    %eax,(%esp)
80101a05:	e8 0d e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
80101a0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0d:	8b 40 0c             	mov    0xc(%eax),%eax
80101a10:	83 c8 02             	or     $0x2,%eax
80101a13:	89 c2                	mov    %eax,%edx
80101a15:	8b 45 08             	mov    0x8(%ebp),%eax
80101a18:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a22:	66 85 c0             	test   %ax,%ax
80101a25:	75 0c                	jne    80101a33 <ilock+0x152>
      panic("ilock: no type");
80101a27:	c7 04 24 7b 8c 10 80 	movl   $0x80108c7b,(%esp)
80101a2e:	e8 07 eb ff ff       	call   8010053a <panic>
  }
}
80101a33:	c9                   	leave  
80101a34:	c3                   	ret    

80101a35 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a35:	55                   	push   %ebp
80101a36:	89 e5                	mov    %esp,%ebp
80101a38:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a3f:	74 17                	je     80101a58 <iunlock+0x23>
80101a41:	8b 45 08             	mov    0x8(%ebp),%eax
80101a44:	8b 40 0c             	mov    0xc(%eax),%eax
80101a47:	83 e0 01             	and    $0x1,%eax
80101a4a:	85 c0                	test   %eax,%eax
80101a4c:	74 0a                	je     80101a58 <iunlock+0x23>
80101a4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a51:	8b 40 08             	mov    0x8(%eax),%eax
80101a54:	85 c0                	test   %eax,%eax
80101a56:	7f 0c                	jg     80101a64 <iunlock+0x2f>
    panic("iunlock");
80101a58:	c7 04 24 8a 8c 10 80 	movl   $0x80108c8a,(%esp)
80101a5f:	e8 d6 ea ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101a64:	c7 04 24 a0 22 11 80 	movl   $0x801122a0,(%esp)
80101a6b:	e8 14 39 00 00       	call   80105384 <acquire>
  ip->flags &= ~I_BUSY;
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 40 0c             	mov    0xc(%eax),%eax
80101a76:	83 e0 fe             	and    $0xfffffffe,%eax
80101a79:	89 c2                	mov    %eax,%edx
80101a7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7e:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a81:	8b 45 08             	mov    0x8(%ebp),%eax
80101a84:	89 04 24             	mov    %eax,(%esp)
80101a87:	e8 e1 33 00 00       	call   80104e6d <wakeup>
  release(&icache.lock);
80101a8c:	c7 04 24 a0 22 11 80 	movl   $0x801122a0,(%esp)
80101a93:	e8 4e 39 00 00       	call   801053e6 <release>
}
80101a98:	c9                   	leave  
80101a99:	c3                   	ret    

80101a9a <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a9a:	55                   	push   %ebp
80101a9b:	89 e5                	mov    %esp,%ebp
80101a9d:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101aa0:	c7 04 24 a0 22 11 80 	movl   $0x801122a0,(%esp)
80101aa7:	e8 d8 38 00 00       	call   80105384 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101aac:	8b 45 08             	mov    0x8(%ebp),%eax
80101aaf:	8b 40 08             	mov    0x8(%eax),%eax
80101ab2:	83 f8 01             	cmp    $0x1,%eax
80101ab5:	0f 85 93 00 00 00    	jne    80101b4e <iput+0xb4>
80101abb:	8b 45 08             	mov    0x8(%ebp),%eax
80101abe:	8b 40 0c             	mov    0xc(%eax),%eax
80101ac1:	83 e0 02             	and    $0x2,%eax
80101ac4:	85 c0                	test   %eax,%eax
80101ac6:	0f 84 82 00 00 00    	je     80101b4e <iput+0xb4>
80101acc:	8b 45 08             	mov    0x8(%ebp),%eax
80101acf:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101ad3:	66 85 c0             	test   %ax,%ax
80101ad6:	75 76                	jne    80101b4e <iput+0xb4>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80101adb:	8b 40 0c             	mov    0xc(%eax),%eax
80101ade:	83 e0 01             	and    $0x1,%eax
80101ae1:	85 c0                	test   %eax,%eax
80101ae3:	74 0c                	je     80101af1 <iput+0x57>
      panic("iput busy");
80101ae5:	c7 04 24 92 8c 10 80 	movl   $0x80108c92,(%esp)
80101aec:	e8 49 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101af1:	8b 45 08             	mov    0x8(%ebp),%eax
80101af4:	8b 40 0c             	mov    0xc(%eax),%eax
80101af7:	83 c8 01             	or     $0x1,%eax
80101afa:	89 c2                	mov    %eax,%edx
80101afc:	8b 45 08             	mov    0x8(%ebp),%eax
80101aff:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b02:	c7 04 24 a0 22 11 80 	movl   $0x801122a0,(%esp)
80101b09:	e8 d8 38 00 00       	call   801053e6 <release>
    itrunc(ip);
80101b0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b11:	89 04 24             	mov    %eax,(%esp)
80101b14:	e8 7d 01 00 00       	call   80101c96 <itrunc>
    ip->type = 0;
80101b19:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1c:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b22:	8b 45 08             	mov    0x8(%ebp),%eax
80101b25:	89 04 24             	mov    %eax,(%esp)
80101b28:	e8 f2 fb ff ff       	call   8010171f <iupdate>
    acquire(&icache.lock);
80101b2d:	c7 04 24 a0 22 11 80 	movl   $0x801122a0,(%esp)
80101b34:	e8 4b 38 00 00       	call   80105384 <acquire>
    ip->flags = 0;
80101b39:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b43:	8b 45 08             	mov    0x8(%ebp),%eax
80101b46:	89 04 24             	mov    %eax,(%esp)
80101b49:	e8 1f 33 00 00       	call   80104e6d <wakeup>
  }
  ip->ref--;
80101b4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b51:	8b 40 08             	mov    0x8(%eax),%eax
80101b54:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b57:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5a:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b5d:	c7 04 24 a0 22 11 80 	movl   $0x801122a0,(%esp)
80101b64:	e8 7d 38 00 00       	call   801053e6 <release>
}
80101b69:	c9                   	leave  
80101b6a:	c3                   	ret    

80101b6b <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b6b:	55                   	push   %ebp
80101b6c:	89 e5                	mov    %esp,%ebp
80101b6e:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b71:	8b 45 08             	mov    0x8(%ebp),%eax
80101b74:	89 04 24             	mov    %eax,(%esp)
80101b77:	e8 b9 fe ff ff       	call   80101a35 <iunlock>
  iput(ip);
80101b7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7f:	89 04 24             	mov    %eax,(%esp)
80101b82:	e8 13 ff ff ff       	call   80101a9a <iput>
}
80101b87:	c9                   	leave  
80101b88:	c3                   	ret    

80101b89 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b89:	55                   	push   %ebp
80101b8a:	89 e5                	mov    %esp,%ebp
80101b8c:	53                   	push   %ebx
80101b8d:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b90:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b94:	77 3e                	ja     80101bd4 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b96:	8b 45 08             	mov    0x8(%ebp),%eax
80101b99:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b9c:	83 c2 04             	add    $0x4,%edx
80101b9f:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ba6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101baa:	75 20                	jne    80101bcc <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101bac:	8b 45 08             	mov    0x8(%ebp),%eax
80101baf:	8b 00                	mov    (%eax),%eax
80101bb1:	89 04 24             	mov    %eax,(%esp)
80101bb4:	e8 f7 f7 ff ff       	call   801013b0 <balloc>
80101bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bbc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bc2:	8d 4a 04             	lea    0x4(%edx),%ecx
80101bc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bc8:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bcf:	e9 bc 00 00 00       	jmp    80101c90 <bmap+0x107>
  }
  bn -= NDIRECT;
80101bd4:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101bd8:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101bdc:	0f 87 a2 00 00 00    	ja     80101c84 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101be2:	8b 45 08             	mov    0x8(%ebp),%eax
80101be5:	8b 40 4c             	mov    0x4c(%eax),%eax
80101be8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101beb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bef:	75 19                	jne    80101c0a <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101bf1:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf4:	8b 00                	mov    (%eax),%eax
80101bf6:	89 04 24             	mov    %eax,(%esp)
80101bf9:	e8 b2 f7 ff ff       	call   801013b0 <balloc>
80101bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c01:	8b 45 08             	mov    0x8(%ebp),%eax
80101c04:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c07:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0d:	8b 00                	mov    (%eax),%eax
80101c0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c12:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c16:	89 04 24             	mov    %eax,(%esp)
80101c19:	e8 88 e5 ff ff       	call   801001a6 <bread>
80101c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c24:	83 c0 18             	add    $0x18,%eax
80101c27:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c37:	01 d0                	add    %edx,%eax
80101c39:	8b 00                	mov    (%eax),%eax
80101c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c42:	75 30                	jne    80101c74 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101c44:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c47:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c51:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c54:	8b 45 08             	mov    0x8(%ebp),%eax
80101c57:	8b 00                	mov    (%eax),%eax
80101c59:	89 04 24             	mov    %eax,(%esp)
80101c5c:	e8 4f f7 ff ff       	call   801013b0 <balloc>
80101c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c67:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c6c:	89 04 24             	mov    %eax,(%esp)
80101c6f:	e8 60 1a 00 00       	call   801036d4 <log_write>
    }
    brelse(bp);
80101c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c77:	89 04 24             	mov    %eax,(%esp)
80101c7a:	e8 98 e5 ff ff       	call   80100217 <brelse>
    return addr;
80101c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c82:	eb 0c                	jmp    80101c90 <bmap+0x107>
  }

  panic("bmap: out of range");
80101c84:	c7 04 24 9c 8c 10 80 	movl   $0x80108c9c,(%esp)
80101c8b:	e8 aa e8 ff ff       	call   8010053a <panic>
}
80101c90:	83 c4 24             	add    $0x24,%esp
80101c93:	5b                   	pop    %ebx
80101c94:	5d                   	pop    %ebp
80101c95:	c3                   	ret    

80101c96 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c96:	55                   	push   %ebp
80101c97:	89 e5                	mov    %esp,%ebp
80101c99:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ca3:	eb 44                	jmp    80101ce9 <itrunc+0x53>
    if(ip->addrs[i]){
80101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cab:	83 c2 04             	add    $0x4,%edx
80101cae:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cb2:	85 c0                	test   %eax,%eax
80101cb4:	74 2f                	je     80101ce5 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cbc:	83 c2 04             	add    $0x4,%edx
80101cbf:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101cc3:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc6:	8b 00                	mov    (%eax),%eax
80101cc8:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ccc:	89 04 24             	mov    %eax,(%esp)
80101ccf:	e8 1a f8 ff ff       	call   801014ee <bfree>
      ip->addrs[i] = 0;
80101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cda:	83 c2 04             	add    $0x4,%edx
80101cdd:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101ce4:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ce5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101ce9:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101ced:	7e b6                	jle    80101ca5 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101cef:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf2:	8b 40 4c             	mov    0x4c(%eax),%eax
80101cf5:	85 c0                	test   %eax,%eax
80101cf7:	0f 84 9b 00 00 00    	je     80101d98 <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101d00:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d03:	8b 45 08             	mov    0x8(%ebp),%eax
80101d06:	8b 00                	mov    (%eax),%eax
80101d08:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d0c:	89 04 24             	mov    %eax,(%esp)
80101d0f:	e8 92 e4 ff ff       	call   801001a6 <bread>
80101d14:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d1a:	83 c0 18             	add    $0x18,%eax
80101d1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d20:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d27:	eb 3b                	jmp    80101d64 <itrunc+0xce>
      if(a[j])
80101d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d33:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d36:	01 d0                	add    %edx,%eax
80101d38:	8b 00                	mov    (%eax),%eax
80101d3a:	85 c0                	test   %eax,%eax
80101d3c:	74 22                	je     80101d60 <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d41:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d48:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d4b:	01 d0                	add    %edx,%eax
80101d4d:	8b 10                	mov    (%eax),%edx
80101d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d52:	8b 00                	mov    (%eax),%eax
80101d54:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d58:	89 04 24             	mov    %eax,(%esp)
80101d5b:	e8 8e f7 ff ff       	call   801014ee <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d60:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d67:	83 f8 7f             	cmp    $0x7f,%eax
80101d6a:	76 bd                	jbe    80101d29 <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d6f:	89 04 24             	mov    %eax,(%esp)
80101d72:	e8 a0 e4 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d77:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7a:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d80:	8b 00                	mov    (%eax),%eax
80101d82:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d86:	89 04 24             	mov    %eax,(%esp)
80101d89:	e8 60 f7 ff ff       	call   801014ee <bfree>
    ip->addrs[NDIRECT] = 0;
80101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d91:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d98:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9b:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101da2:	8b 45 08             	mov    0x8(%ebp),%eax
80101da5:	89 04 24             	mov    %eax,(%esp)
80101da8:	e8 72 f9 ff ff       	call   8010171f <iupdate>
}
80101dad:	c9                   	leave  
80101dae:	c3                   	ret    

80101daf <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101daf:	55                   	push   %ebp
80101db0:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101db2:	8b 45 08             	mov    0x8(%ebp),%eax
80101db5:	8b 00                	mov    (%eax),%eax
80101db7:	89 c2                	mov    %eax,%edx
80101db9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dbc:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101dbf:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc2:	8b 50 04             	mov    0x4(%eax),%edx
80101dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dc8:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dce:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dd5:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101dd8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ddb:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101de2:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101de6:	8b 45 08             	mov    0x8(%ebp),%eax
80101de9:	8b 50 18             	mov    0x18(%eax),%edx
80101dec:	8b 45 0c             	mov    0xc(%ebp),%eax
80101def:	89 50 10             	mov    %edx,0x10(%eax)
}
80101df2:	5d                   	pop    %ebp
80101df3:	c3                   	ret    

80101df4 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101df4:	55                   	push   %ebp
80101df5:	89 e5                	mov    %esp,%ebp
80101df7:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101dfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e01:	66 83 f8 03          	cmp    $0x3,%ax
80101e05:	75 60                	jne    80101e67 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e07:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e0e:	66 85 c0             	test   %ax,%ax
80101e11:	78 20                	js     80101e33 <readi+0x3f>
80101e13:	8b 45 08             	mov    0x8(%ebp),%eax
80101e16:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e1a:	66 83 f8 09          	cmp    $0x9,%ax
80101e1e:	7f 13                	jg     80101e33 <readi+0x3f>
80101e20:	8b 45 08             	mov    0x8(%ebp),%eax
80101e23:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e27:	98                   	cwtl   
80101e28:	8b 04 c5 20 22 11 80 	mov    -0x7feedde0(,%eax,8),%eax
80101e2f:	85 c0                	test   %eax,%eax
80101e31:	75 0a                	jne    80101e3d <readi+0x49>
      return -1;
80101e33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e38:	e9 19 01 00 00       	jmp    80101f56 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101e3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e40:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e44:	98                   	cwtl   
80101e45:	8b 04 c5 20 22 11 80 	mov    -0x7feedde0(,%eax,8),%eax
80101e4c:	8b 55 14             	mov    0x14(%ebp),%edx
80101e4f:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e53:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e56:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e5a:	8b 55 08             	mov    0x8(%ebp),%edx
80101e5d:	89 14 24             	mov    %edx,(%esp)
80101e60:	ff d0                	call   *%eax
80101e62:	e9 ef 00 00 00       	jmp    80101f56 <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101e67:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6a:	8b 40 18             	mov    0x18(%eax),%eax
80101e6d:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e70:	72 0d                	jb     80101e7f <readi+0x8b>
80101e72:	8b 45 14             	mov    0x14(%ebp),%eax
80101e75:	8b 55 10             	mov    0x10(%ebp),%edx
80101e78:	01 d0                	add    %edx,%eax
80101e7a:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e7d:	73 0a                	jae    80101e89 <readi+0x95>
    return -1;
80101e7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e84:	e9 cd 00 00 00       	jmp    80101f56 <readi+0x162>
  if(off + n > ip->size)
80101e89:	8b 45 14             	mov    0x14(%ebp),%eax
80101e8c:	8b 55 10             	mov    0x10(%ebp),%edx
80101e8f:	01 c2                	add    %eax,%edx
80101e91:	8b 45 08             	mov    0x8(%ebp),%eax
80101e94:	8b 40 18             	mov    0x18(%eax),%eax
80101e97:	39 c2                	cmp    %eax,%edx
80101e99:	76 0c                	jbe    80101ea7 <readi+0xb3>
    n = ip->size - off;
80101e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9e:	8b 40 18             	mov    0x18(%eax),%eax
80101ea1:	2b 45 10             	sub    0x10(%ebp),%eax
80101ea4:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ea7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101eae:	e9 94 00 00 00       	jmp    80101f47 <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101eb3:	8b 45 10             	mov    0x10(%ebp),%eax
80101eb6:	c1 e8 09             	shr    $0x9,%eax
80101eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ebd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec0:	89 04 24             	mov    %eax,(%esp)
80101ec3:	e8 c1 fc ff ff       	call   80101b89 <bmap>
80101ec8:	8b 55 08             	mov    0x8(%ebp),%edx
80101ecb:	8b 12                	mov    (%edx),%edx
80101ecd:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ed1:	89 14 24             	mov    %edx,(%esp)
80101ed4:	e8 cd e2 ff ff       	call   801001a6 <bread>
80101ed9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101edc:	8b 45 10             	mov    0x10(%ebp),%eax
80101edf:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ee4:	89 c2                	mov    %eax,%edx
80101ee6:	b8 00 02 00 00       	mov    $0x200,%eax
80101eeb:	29 d0                	sub    %edx,%eax
80101eed:	89 c2                	mov    %eax,%edx
80101eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ef2:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101ef5:	29 c1                	sub    %eax,%ecx
80101ef7:	89 c8                	mov    %ecx,%eax
80101ef9:	39 c2                	cmp    %eax,%edx
80101efb:	0f 46 c2             	cmovbe %edx,%eax
80101efe:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f01:	8b 45 10             	mov    0x10(%ebp),%eax
80101f04:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f09:	8d 50 10             	lea    0x10(%eax),%edx
80101f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f0f:	01 d0                	add    %edx,%eax
80101f11:	8d 50 08             	lea    0x8(%eax),%edx
80101f14:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f17:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f1b:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f22:	89 04 24             	mov    %eax,(%esp)
80101f25:	e8 7d 37 00 00       	call   801056a7 <memmove>
    brelse(bp);
80101f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f2d:	89 04 24             	mov    %eax,(%esp)
80101f30:	e8 e2 e2 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f35:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f38:	01 45 f4             	add    %eax,-0xc(%ebp)
80101f3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f3e:	01 45 10             	add    %eax,0x10(%ebp)
80101f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f44:	01 45 0c             	add    %eax,0xc(%ebp)
80101f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f4a:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f4d:	0f 82 60 ff ff ff    	jb     80101eb3 <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f53:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f56:	c9                   	leave  
80101f57:	c3                   	ret    

80101f58 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f58:	55                   	push   %ebp
80101f59:	89 e5                	mov    %esp,%ebp
80101f5b:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f61:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f65:	66 83 f8 03          	cmp    $0x3,%ax
80101f69:	75 60                	jne    80101fcb <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f72:	66 85 c0             	test   %ax,%ax
80101f75:	78 20                	js     80101f97 <writei+0x3f>
80101f77:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f7e:	66 83 f8 09          	cmp    $0x9,%ax
80101f82:	7f 13                	jg     80101f97 <writei+0x3f>
80101f84:	8b 45 08             	mov    0x8(%ebp),%eax
80101f87:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f8b:	98                   	cwtl   
80101f8c:	8b 04 c5 24 22 11 80 	mov    -0x7feedddc(,%eax,8),%eax
80101f93:	85 c0                	test   %eax,%eax
80101f95:	75 0a                	jne    80101fa1 <writei+0x49>
      return -1;
80101f97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f9c:	e9 44 01 00 00       	jmp    801020e5 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa4:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fa8:	98                   	cwtl   
80101fa9:	8b 04 c5 24 22 11 80 	mov    -0x7feedddc(,%eax,8),%eax
80101fb0:	8b 55 14             	mov    0x14(%ebp),%edx
80101fb3:	89 54 24 08          	mov    %edx,0x8(%esp)
80101fb7:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fba:	89 54 24 04          	mov    %edx,0x4(%esp)
80101fbe:	8b 55 08             	mov    0x8(%ebp),%edx
80101fc1:	89 14 24             	mov    %edx,(%esp)
80101fc4:	ff d0                	call   *%eax
80101fc6:	e9 1a 01 00 00       	jmp    801020e5 <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101fce:	8b 40 18             	mov    0x18(%eax),%eax
80101fd1:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fd4:	72 0d                	jb     80101fe3 <writei+0x8b>
80101fd6:	8b 45 14             	mov    0x14(%ebp),%eax
80101fd9:	8b 55 10             	mov    0x10(%ebp),%edx
80101fdc:	01 d0                	add    %edx,%eax
80101fde:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fe1:	73 0a                	jae    80101fed <writei+0x95>
    return -1;
80101fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fe8:	e9 f8 00 00 00       	jmp    801020e5 <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101fed:	8b 45 14             	mov    0x14(%ebp),%eax
80101ff0:	8b 55 10             	mov    0x10(%ebp),%edx
80101ff3:	01 d0                	add    %edx,%eax
80101ff5:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ffa:	76 0a                	jbe    80102006 <writei+0xae>
    return -1;
80101ffc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102001:	e9 df 00 00 00       	jmp    801020e5 <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102006:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010200d:	e9 9f 00 00 00       	jmp    801020b1 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102012:	8b 45 10             	mov    0x10(%ebp),%eax
80102015:	c1 e8 09             	shr    $0x9,%eax
80102018:	89 44 24 04          	mov    %eax,0x4(%esp)
8010201c:	8b 45 08             	mov    0x8(%ebp),%eax
8010201f:	89 04 24             	mov    %eax,(%esp)
80102022:	e8 62 fb ff ff       	call   80101b89 <bmap>
80102027:	8b 55 08             	mov    0x8(%ebp),%edx
8010202a:	8b 12                	mov    (%edx),%edx
8010202c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102030:	89 14 24             	mov    %edx,(%esp)
80102033:	e8 6e e1 ff ff       	call   801001a6 <bread>
80102038:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010203b:	8b 45 10             	mov    0x10(%ebp),%eax
8010203e:	25 ff 01 00 00       	and    $0x1ff,%eax
80102043:	89 c2                	mov    %eax,%edx
80102045:	b8 00 02 00 00       	mov    $0x200,%eax
8010204a:	29 d0                	sub    %edx,%eax
8010204c:	89 c2                	mov    %eax,%edx
8010204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102051:	8b 4d 14             	mov    0x14(%ebp),%ecx
80102054:	29 c1                	sub    %eax,%ecx
80102056:	89 c8                	mov    %ecx,%eax
80102058:	39 c2                	cmp    %eax,%edx
8010205a:	0f 46 c2             	cmovbe %edx,%eax
8010205d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102060:	8b 45 10             	mov    0x10(%ebp),%eax
80102063:	25 ff 01 00 00       	and    $0x1ff,%eax
80102068:	8d 50 10             	lea    0x10(%eax),%edx
8010206b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010206e:	01 d0                	add    %edx,%eax
80102070:	8d 50 08             	lea    0x8(%eax),%edx
80102073:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102076:	89 44 24 08          	mov    %eax,0x8(%esp)
8010207a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010207d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102081:	89 14 24             	mov    %edx,(%esp)
80102084:	e8 1e 36 00 00       	call   801056a7 <memmove>
    log_write(bp);
80102089:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010208c:	89 04 24             	mov    %eax,(%esp)
8010208f:	e8 40 16 00 00       	call   801036d4 <log_write>
    brelse(bp);
80102094:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102097:	89 04 24             	mov    %eax,(%esp)
8010209a:	e8 78 e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010209f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020a2:	01 45 f4             	add    %eax,-0xc(%ebp)
801020a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020a8:	01 45 10             	add    %eax,0x10(%ebp)
801020ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020ae:	01 45 0c             	add    %eax,0xc(%ebp)
801020b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020b4:	3b 45 14             	cmp    0x14(%ebp),%eax
801020b7:	0f 82 55 ff ff ff    	jb     80102012 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801020bd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801020c1:	74 1f                	je     801020e2 <writei+0x18a>
801020c3:	8b 45 08             	mov    0x8(%ebp),%eax
801020c6:	8b 40 18             	mov    0x18(%eax),%eax
801020c9:	3b 45 10             	cmp    0x10(%ebp),%eax
801020cc:	73 14                	jae    801020e2 <writei+0x18a>
    ip->size = off;
801020ce:	8b 45 08             	mov    0x8(%ebp),%eax
801020d1:	8b 55 10             	mov    0x10(%ebp),%edx
801020d4:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801020d7:	8b 45 08             	mov    0x8(%ebp),%eax
801020da:	89 04 24             	mov    %eax,(%esp)
801020dd:	e8 3d f6 ff ff       	call   8010171f <iupdate>
  }
  return n;
801020e2:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020e5:	c9                   	leave  
801020e6:	c3                   	ret    

801020e7 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020e7:	55                   	push   %ebp
801020e8:	89 e5                	mov    %esp,%ebp
801020ea:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801020ed:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801020f4:	00 
801020f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801020f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801020fc:	8b 45 08             	mov    0x8(%ebp),%eax
801020ff:	89 04 24             	mov    %eax,(%esp)
80102102:	e8 43 36 00 00       	call   8010574a <strncmp>
}
80102107:	c9                   	leave  
80102108:	c3                   	ret    

80102109 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102109:	55                   	push   %ebp
8010210a:	89 e5                	mov    %esp,%ebp
8010210c:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010210f:	8b 45 08             	mov    0x8(%ebp),%eax
80102112:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102116:	66 83 f8 01          	cmp    $0x1,%ax
8010211a:	74 0c                	je     80102128 <dirlookup+0x1f>
    panic("dirlookup not DIR");
8010211c:	c7 04 24 af 8c 10 80 	movl   $0x80108caf,(%esp)
80102123:	e8 12 e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102128:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010212f:	e9 88 00 00 00       	jmp    801021bc <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102134:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010213b:	00 
8010213c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010213f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102143:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102146:	89 44 24 04          	mov    %eax,0x4(%esp)
8010214a:	8b 45 08             	mov    0x8(%ebp),%eax
8010214d:	89 04 24             	mov    %eax,(%esp)
80102150:	e8 9f fc ff ff       	call   80101df4 <readi>
80102155:	83 f8 10             	cmp    $0x10,%eax
80102158:	74 0c                	je     80102166 <dirlookup+0x5d>
      panic("dirlink read");
8010215a:	c7 04 24 c1 8c 10 80 	movl   $0x80108cc1,(%esp)
80102161:	e8 d4 e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
80102166:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010216a:	66 85 c0             	test   %ax,%ax
8010216d:	75 02                	jne    80102171 <dirlookup+0x68>
      continue;
8010216f:	eb 47                	jmp    801021b8 <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
80102171:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102174:	83 c0 02             	add    $0x2,%eax
80102177:	89 44 24 04          	mov    %eax,0x4(%esp)
8010217b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010217e:	89 04 24             	mov    %eax,(%esp)
80102181:	e8 61 ff ff ff       	call   801020e7 <namecmp>
80102186:	85 c0                	test   %eax,%eax
80102188:	75 2e                	jne    801021b8 <dirlookup+0xaf>
      // entry matches path element
      if(poff)
8010218a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010218e:	74 08                	je     80102198 <dirlookup+0x8f>
        *poff = off;
80102190:	8b 45 10             	mov    0x10(%ebp),%eax
80102193:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102196:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102198:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010219c:	0f b7 c0             	movzwl %ax,%eax
8010219f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801021a2:	8b 45 08             	mov    0x8(%ebp),%eax
801021a5:	8b 00                	mov    (%eax),%eax
801021a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801021aa:	89 54 24 04          	mov    %edx,0x4(%esp)
801021ae:	89 04 24             	mov    %eax,(%esp)
801021b1:	e8 27 f6 ff ff       	call   801017dd <iget>
801021b6:	eb 18                	jmp    801021d0 <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021b8:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801021bc:	8b 45 08             	mov    0x8(%ebp),%eax
801021bf:	8b 40 18             	mov    0x18(%eax),%eax
801021c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801021c5:	0f 87 69 ff ff ff    	ja     80102134 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801021cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801021d0:	c9                   	leave  
801021d1:	c3                   	ret    

801021d2 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021d2:	55                   	push   %ebp
801021d3:	89 e5                	mov    %esp,%ebp
801021d5:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801021df:	00 
801021e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801021e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801021e7:	8b 45 08             	mov    0x8(%ebp),%eax
801021ea:	89 04 24             	mov    %eax,(%esp)
801021ed:	e8 17 ff ff ff       	call   80102109 <dirlookup>
801021f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801021f9:	74 15                	je     80102210 <dirlink+0x3e>
    iput(ip);
801021fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021fe:	89 04 24             	mov    %eax,(%esp)
80102201:	e8 94 f8 ff ff       	call   80101a9a <iput>
    return -1;
80102206:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010220b:	e9 b7 00 00 00       	jmp    801022c7 <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102217:	eb 46                	jmp    8010225f <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010221c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102223:	00 
80102224:	89 44 24 08          	mov    %eax,0x8(%esp)
80102228:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010222b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010222f:	8b 45 08             	mov    0x8(%ebp),%eax
80102232:	89 04 24             	mov    %eax,(%esp)
80102235:	e8 ba fb ff ff       	call   80101df4 <readi>
8010223a:	83 f8 10             	cmp    $0x10,%eax
8010223d:	74 0c                	je     8010224b <dirlink+0x79>
      panic("dirlink read");
8010223f:	c7 04 24 c1 8c 10 80 	movl   $0x80108cc1,(%esp)
80102246:	e8 ef e2 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
8010224b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010224f:	66 85 c0             	test   %ax,%ax
80102252:	75 02                	jne    80102256 <dirlink+0x84>
      break;
80102254:	eb 16                	jmp    8010226c <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102256:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102259:	83 c0 10             	add    $0x10,%eax
8010225c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010225f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102262:	8b 45 08             	mov    0x8(%ebp),%eax
80102265:	8b 40 18             	mov    0x18(%eax),%eax
80102268:	39 c2                	cmp    %eax,%edx
8010226a:	72 ad                	jb     80102219 <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
8010226c:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102273:	00 
80102274:	8b 45 0c             	mov    0xc(%ebp),%eax
80102277:	89 44 24 04          	mov    %eax,0x4(%esp)
8010227b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010227e:	83 c0 02             	add    $0x2,%eax
80102281:	89 04 24             	mov    %eax,(%esp)
80102284:	e8 17 35 00 00       	call   801057a0 <strncpy>
  de.inum = inum;
80102289:	8b 45 10             	mov    0x10(%ebp),%eax
8010228c:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102290:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102293:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010229a:	00 
8010229b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010229f:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801022a6:	8b 45 08             	mov    0x8(%ebp),%eax
801022a9:	89 04 24             	mov    %eax,(%esp)
801022ac:	e8 a7 fc ff ff       	call   80101f58 <writei>
801022b1:	83 f8 10             	cmp    $0x10,%eax
801022b4:	74 0c                	je     801022c2 <dirlink+0xf0>
    panic("dirlink");
801022b6:	c7 04 24 ce 8c 10 80 	movl   $0x80108cce,(%esp)
801022bd:	e8 78 e2 ff ff       	call   8010053a <panic>
  
  return 0;
801022c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022c7:	c9                   	leave  
801022c8:	c3                   	ret    

801022c9 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022c9:	55                   	push   %ebp
801022ca:	89 e5                	mov    %esp,%ebp
801022cc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
801022cf:	eb 04                	jmp    801022d5 <skipelem+0xc>
    path++;
801022d1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801022d5:	8b 45 08             	mov    0x8(%ebp),%eax
801022d8:	0f b6 00             	movzbl (%eax),%eax
801022db:	3c 2f                	cmp    $0x2f,%al
801022dd:	74 f2                	je     801022d1 <skipelem+0x8>
    path++;
  if(*path == 0)
801022df:	8b 45 08             	mov    0x8(%ebp),%eax
801022e2:	0f b6 00             	movzbl (%eax),%eax
801022e5:	84 c0                	test   %al,%al
801022e7:	75 0a                	jne    801022f3 <skipelem+0x2a>
    return 0;
801022e9:	b8 00 00 00 00       	mov    $0x0,%eax
801022ee:	e9 86 00 00 00       	jmp    80102379 <skipelem+0xb0>
  s = path;
801022f3:	8b 45 08             	mov    0x8(%ebp),%eax
801022f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801022f9:	eb 04                	jmp    801022ff <skipelem+0x36>
    path++;
801022fb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801022ff:	8b 45 08             	mov    0x8(%ebp),%eax
80102302:	0f b6 00             	movzbl (%eax),%eax
80102305:	3c 2f                	cmp    $0x2f,%al
80102307:	74 0a                	je     80102313 <skipelem+0x4a>
80102309:	8b 45 08             	mov    0x8(%ebp),%eax
8010230c:	0f b6 00             	movzbl (%eax),%eax
8010230f:	84 c0                	test   %al,%al
80102311:	75 e8                	jne    801022fb <skipelem+0x32>
    path++;
  len = path - s;
80102313:	8b 55 08             	mov    0x8(%ebp),%edx
80102316:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102319:	29 c2                	sub    %eax,%edx
8010231b:	89 d0                	mov    %edx,%eax
8010231d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102320:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102324:	7e 1c                	jle    80102342 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
80102326:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010232d:	00 
8010232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102331:	89 44 24 04          	mov    %eax,0x4(%esp)
80102335:	8b 45 0c             	mov    0xc(%ebp),%eax
80102338:	89 04 24             	mov    %eax,(%esp)
8010233b:	e8 67 33 00 00       	call   801056a7 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102340:	eb 2a                	jmp    8010236c <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102342:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102345:	89 44 24 08          	mov    %eax,0x8(%esp)
80102349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010234c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102350:	8b 45 0c             	mov    0xc(%ebp),%eax
80102353:	89 04 24             	mov    %eax,(%esp)
80102356:	e8 4c 33 00 00       	call   801056a7 <memmove>
    name[len] = 0;
8010235b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010235e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102361:	01 d0                	add    %edx,%eax
80102363:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102366:	eb 04                	jmp    8010236c <skipelem+0xa3>
    path++;
80102368:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010236c:	8b 45 08             	mov    0x8(%ebp),%eax
8010236f:	0f b6 00             	movzbl (%eax),%eax
80102372:	3c 2f                	cmp    $0x2f,%al
80102374:	74 f2                	je     80102368 <skipelem+0x9f>
    path++;
  return path;
80102376:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102379:	c9                   	leave  
8010237a:	c3                   	ret    

8010237b <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
8010237b:	55                   	push   %ebp
8010237c:	89 e5                	mov    %esp,%ebp
8010237e:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102381:	8b 45 08             	mov    0x8(%ebp),%eax
80102384:	0f b6 00             	movzbl (%eax),%eax
80102387:	3c 2f                	cmp    $0x2f,%al
80102389:	75 1c                	jne    801023a7 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
8010238b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102392:	00 
80102393:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010239a:	e8 3e f4 ff ff       	call   801017dd <iget>
8010239f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023a2:	e9 af 00 00 00       	jmp    80102456 <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
801023a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023ad:	8b 40 68             	mov    0x68(%eax),%eax
801023b0:	89 04 24             	mov    %eax,(%esp)
801023b3:	e8 f7 f4 ff ff       	call   801018af <idup>
801023b8:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801023bb:	e9 96 00 00 00       	jmp    80102456 <namex+0xdb>
    ilock(ip);
801023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023c3:	89 04 24             	mov    %eax,(%esp)
801023c6:	e8 16 f5 ff ff       	call   801018e1 <ilock>
    if(ip->type != T_DIR){
801023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ce:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023d2:	66 83 f8 01          	cmp    $0x1,%ax
801023d6:	74 15                	je     801023ed <namex+0x72>
      iunlockput(ip);
801023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023db:	89 04 24             	mov    %eax,(%esp)
801023de:	e8 88 f7 ff ff       	call   80101b6b <iunlockput>
      return 0;
801023e3:	b8 00 00 00 00       	mov    $0x0,%eax
801023e8:	e9 a3 00 00 00       	jmp    80102490 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
801023ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023f1:	74 1d                	je     80102410 <namex+0x95>
801023f3:	8b 45 08             	mov    0x8(%ebp),%eax
801023f6:	0f b6 00             	movzbl (%eax),%eax
801023f9:	84 c0                	test   %al,%al
801023fb:	75 13                	jne    80102410 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
801023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102400:	89 04 24             	mov    %eax,(%esp)
80102403:	e8 2d f6 ff ff       	call   80101a35 <iunlock>
      return ip;
80102408:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010240b:	e9 80 00 00 00       	jmp    80102490 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102410:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102417:	00 
80102418:	8b 45 10             	mov    0x10(%ebp),%eax
8010241b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102422:	89 04 24             	mov    %eax,(%esp)
80102425:	e8 df fc ff ff       	call   80102109 <dirlookup>
8010242a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010242d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102431:	75 12                	jne    80102445 <namex+0xca>
      iunlockput(ip);
80102433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102436:	89 04 24             	mov    %eax,(%esp)
80102439:	e8 2d f7 ff ff       	call   80101b6b <iunlockput>
      return 0;
8010243e:	b8 00 00 00 00       	mov    $0x0,%eax
80102443:	eb 4b                	jmp    80102490 <namex+0x115>
    }
    iunlockput(ip);
80102445:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102448:	89 04 24             	mov    %eax,(%esp)
8010244b:	e8 1b f7 ff ff       	call   80101b6b <iunlockput>
    ip = next;
80102450:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102453:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102456:	8b 45 10             	mov    0x10(%ebp),%eax
80102459:	89 44 24 04          	mov    %eax,0x4(%esp)
8010245d:	8b 45 08             	mov    0x8(%ebp),%eax
80102460:	89 04 24             	mov    %eax,(%esp)
80102463:	e8 61 fe ff ff       	call   801022c9 <skipelem>
80102468:	89 45 08             	mov    %eax,0x8(%ebp)
8010246b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010246f:	0f 85 4b ff ff ff    	jne    801023c0 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102475:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102479:	74 12                	je     8010248d <namex+0x112>
    iput(ip);
8010247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010247e:	89 04 24             	mov    %eax,(%esp)
80102481:	e8 14 f6 ff ff       	call   80101a9a <iput>
    return 0;
80102486:	b8 00 00 00 00       	mov    $0x0,%eax
8010248b:	eb 03                	jmp    80102490 <namex+0x115>
  }
  return ip;
8010248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102490:	c9                   	leave  
80102491:	c3                   	ret    

80102492 <namei>:

struct inode*
namei(char *path)
{
80102492:	55                   	push   %ebp
80102493:	89 e5                	mov    %esp,%ebp
80102495:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102498:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010249b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010249f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801024a6:	00 
801024a7:	8b 45 08             	mov    0x8(%ebp),%eax
801024aa:	89 04 24             	mov    %eax,(%esp)
801024ad:	e8 c9 fe ff ff       	call   8010237b <namex>
}
801024b2:	c9                   	leave  
801024b3:	c3                   	ret    

801024b4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024b4:	55                   	push   %ebp
801024b5:	89 e5                	mov    %esp,%ebp
801024b7:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
801024ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801024bd:	89 44 24 08          	mov    %eax,0x8(%esp)
801024c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801024c8:	00 
801024c9:	8b 45 08             	mov    0x8(%ebp),%eax
801024cc:	89 04 24             	mov    %eax,(%esp)
801024cf:	e8 a7 fe ff ff       	call   8010237b <namex>
}
801024d4:	c9                   	leave  
801024d5:	c3                   	ret    

801024d6 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801024d6:	55                   	push   %ebp
801024d7:	89 e5                	mov    %esp,%ebp
801024d9:	83 ec 14             	sub    $0x14,%esp
801024dc:	8b 45 08             	mov    0x8(%ebp),%eax
801024df:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024e3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801024e7:	89 c2                	mov    %eax,%edx
801024e9:	ec                   	in     (%dx),%al
801024ea:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801024ed:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801024f1:	c9                   	leave  
801024f2:	c3                   	ret    

801024f3 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024f3:	55                   	push   %ebp
801024f4:	89 e5                	mov    %esp,%ebp
801024f6:	57                   	push   %edi
801024f7:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024f8:	8b 55 08             	mov    0x8(%ebp),%edx
801024fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024fe:	8b 45 10             	mov    0x10(%ebp),%eax
80102501:	89 cb                	mov    %ecx,%ebx
80102503:	89 df                	mov    %ebx,%edi
80102505:	89 c1                	mov    %eax,%ecx
80102507:	fc                   	cld    
80102508:	f3 6d                	rep insl (%dx),%es:(%edi)
8010250a:	89 c8                	mov    %ecx,%eax
8010250c:	89 fb                	mov    %edi,%ebx
8010250e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102511:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102514:	5b                   	pop    %ebx
80102515:	5f                   	pop    %edi
80102516:	5d                   	pop    %ebp
80102517:	c3                   	ret    

80102518 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102518:	55                   	push   %ebp
80102519:	89 e5                	mov    %esp,%ebp
8010251b:	83 ec 08             	sub    $0x8,%esp
8010251e:	8b 55 08             	mov    0x8(%ebp),%edx
80102521:	8b 45 0c             	mov    0xc(%ebp),%eax
80102524:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102528:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010252b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010252f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102533:	ee                   	out    %al,(%dx)
}
80102534:	c9                   	leave  
80102535:	c3                   	ret    

80102536 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102536:	55                   	push   %ebp
80102537:	89 e5                	mov    %esp,%ebp
80102539:	56                   	push   %esi
8010253a:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010253b:	8b 55 08             	mov    0x8(%ebp),%edx
8010253e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102541:	8b 45 10             	mov    0x10(%ebp),%eax
80102544:	89 cb                	mov    %ecx,%ebx
80102546:	89 de                	mov    %ebx,%esi
80102548:	89 c1                	mov    %eax,%ecx
8010254a:	fc                   	cld    
8010254b:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010254d:	89 c8                	mov    %ecx,%eax
8010254f:	89 f3                	mov    %esi,%ebx
80102551:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102554:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102557:	5b                   	pop    %ebx
80102558:	5e                   	pop    %esi
80102559:	5d                   	pop    %ebp
8010255a:	c3                   	ret    

8010255b <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010255b:	55                   	push   %ebp
8010255c:	89 e5                	mov    %esp,%ebp
8010255e:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102561:	90                   	nop
80102562:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102569:	e8 68 ff ff ff       	call   801024d6 <inb>
8010256e:	0f b6 c0             	movzbl %al,%eax
80102571:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102574:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102577:	25 c0 00 00 00       	and    $0xc0,%eax
8010257c:	83 f8 40             	cmp    $0x40,%eax
8010257f:	75 e1                	jne    80102562 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102581:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102585:	74 11                	je     80102598 <idewait+0x3d>
80102587:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010258a:	83 e0 21             	and    $0x21,%eax
8010258d:	85 c0                	test   %eax,%eax
8010258f:	74 07                	je     80102598 <idewait+0x3d>
    return -1;
80102591:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102596:	eb 05                	jmp    8010259d <idewait+0x42>
  return 0;
80102598:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010259d:	c9                   	leave  
8010259e:	c3                   	ret    

8010259f <ideinit>:

void
ideinit(void)
{
8010259f:	55                   	push   %ebp
801025a0:	89 e5                	mov    %esp,%ebp
801025a2:	83 ec 28             	sub    $0x28,%esp
  int i;
  
  initlock(&idelock, "ide");
801025a5:	c7 44 24 04 d6 8c 10 	movl   $0x80108cd6,0x4(%esp)
801025ac:	80 
801025ad:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801025b4:	e8 aa 2d 00 00       	call   80105363 <initlock>
  picenable(IRQ_IDE);
801025b9:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025c0:	e8 a3 18 00 00       	call   80103e68 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
801025c5:	a1 a0 39 11 80       	mov    0x801139a0,%eax
801025ca:	83 e8 01             	sub    $0x1,%eax
801025cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801025d1:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025d8:	e8 43 04 00 00       	call   80102a20 <ioapicenable>
  idewait(0);
801025dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025e4:	e8 72 ff ff ff       	call   8010255b <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025e9:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801025f0:	00 
801025f1:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025f8:	e8 1b ff ff ff       	call   80102518 <outb>
  for(i=0; i<1000; i++){
801025fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102604:	eb 20                	jmp    80102626 <ideinit+0x87>
    if(inb(0x1f7) != 0){
80102606:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010260d:	e8 c4 fe ff ff       	call   801024d6 <inb>
80102612:	84 c0                	test   %al,%al
80102614:	74 0c                	je     80102622 <ideinit+0x83>
      havedisk1 = 1;
80102616:	c7 05 98 c6 10 80 01 	movl   $0x1,0x8010c698
8010261d:	00 00 00 
      break;
80102620:	eb 0d                	jmp    8010262f <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102622:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102626:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010262d:	7e d7                	jle    80102606 <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010262f:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
80102636:	00 
80102637:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010263e:	e8 d5 fe ff ff       	call   80102518 <outb>
}
80102643:	c9                   	leave  
80102644:	c3                   	ret    

80102645 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102645:	55                   	push   %ebp
80102646:	89 e5                	mov    %esp,%ebp
80102648:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
8010264b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010264f:	75 0c                	jne    8010265d <idestart+0x18>
    panic("idestart");
80102651:	c7 04 24 da 8c 10 80 	movl   $0x80108cda,(%esp)
80102658:	e8 dd de ff ff       	call   8010053a <panic>
  if(b->blockno >= FSSIZE)
8010265d:	8b 45 08             	mov    0x8(%ebp),%eax
80102660:	8b 40 08             	mov    0x8(%eax),%eax
80102663:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102668:	76 0c                	jbe    80102676 <idestart+0x31>
    panic("incorrect blockno");
8010266a:	c7 04 24 e3 8c 10 80 	movl   $0x80108ce3,(%esp)
80102671:	e8 c4 de ff ff       	call   8010053a <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102676:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010267d:	8b 45 08             	mov    0x8(%ebp),%eax
80102680:	8b 50 08             	mov    0x8(%eax),%edx
80102683:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102686:	0f af c2             	imul   %edx,%eax
80102689:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
8010268c:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102690:	7e 0c                	jle    8010269e <idestart+0x59>
80102692:	c7 04 24 da 8c 10 80 	movl   $0x80108cda,(%esp)
80102699:	e8 9c de ff ff       	call   8010053a <panic>
  
  idewait(0);
8010269e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801026a5:	e8 b1 fe ff ff       	call   8010255b <idewait>
  outb(0x3f6, 0);  // generate interrupt
801026aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801026b1:	00 
801026b2:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801026b9:	e8 5a fe ff ff       	call   80102518 <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
801026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026c1:	0f b6 c0             	movzbl %al,%eax
801026c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801026c8:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801026cf:	e8 44 fe ff ff       	call   80102518 <outb>
  outb(0x1f3, sector & 0xff);
801026d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026d7:	0f b6 c0             	movzbl %al,%eax
801026da:	89 44 24 04          	mov    %eax,0x4(%esp)
801026de:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
801026e5:	e8 2e fe ff ff       	call   80102518 <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
801026ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026ed:	c1 f8 08             	sar    $0x8,%eax
801026f0:	0f b6 c0             	movzbl %al,%eax
801026f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801026f7:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
801026fe:	e8 15 fe ff ff       	call   80102518 <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
80102703:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102706:	c1 f8 10             	sar    $0x10,%eax
80102709:	0f b6 c0             	movzbl %al,%eax
8010270c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102710:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102717:	e8 fc fd ff ff       	call   80102518 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010271c:	8b 45 08             	mov    0x8(%ebp),%eax
8010271f:	8b 40 04             	mov    0x4(%eax),%eax
80102722:	83 e0 01             	and    $0x1,%eax
80102725:	c1 e0 04             	shl    $0x4,%eax
80102728:	89 c2                	mov    %eax,%edx
8010272a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010272d:	c1 f8 18             	sar    $0x18,%eax
80102730:	83 e0 0f             	and    $0xf,%eax
80102733:	09 d0                	or     %edx,%eax
80102735:	83 c8 e0             	or     $0xffffffe0,%eax
80102738:	0f b6 c0             	movzbl %al,%eax
8010273b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010273f:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102746:	e8 cd fd ff ff       	call   80102518 <outb>
  if(b->flags & B_DIRTY){
8010274b:	8b 45 08             	mov    0x8(%ebp),%eax
8010274e:	8b 00                	mov    (%eax),%eax
80102750:	83 e0 04             	and    $0x4,%eax
80102753:	85 c0                	test   %eax,%eax
80102755:	74 34                	je     8010278b <idestart+0x146>
    outb(0x1f7, IDE_CMD_WRITE);
80102757:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
8010275e:	00 
8010275f:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102766:	e8 ad fd ff ff       	call   80102518 <outb>
    outsl(0x1f0, b->data, BSIZE/4);
8010276b:	8b 45 08             	mov    0x8(%ebp),%eax
8010276e:	83 c0 18             	add    $0x18,%eax
80102771:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102778:	00 
80102779:	89 44 24 04          	mov    %eax,0x4(%esp)
8010277d:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102784:	e8 ad fd ff ff       	call   80102536 <outsl>
80102789:	eb 14                	jmp    8010279f <idestart+0x15a>
  } else {
    outb(0x1f7, IDE_CMD_READ);
8010278b:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80102792:	00 
80102793:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010279a:	e8 79 fd ff ff       	call   80102518 <outb>
  }
}
8010279f:	c9                   	leave  
801027a0:	c3                   	ret    

801027a1 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027a1:	55                   	push   %ebp
801027a2:	89 e5                	mov    %esp,%ebp
801027a4:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027a7:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801027ae:	e8 d1 2b 00 00       	call   80105384 <acquire>
  if((b = idequeue) == 0){
801027b3:	a1 94 c6 10 80       	mov    0x8010c694,%eax
801027b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027bf:	75 11                	jne    801027d2 <ideintr+0x31>
    release(&idelock);
801027c1:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801027c8:	e8 19 2c 00 00       	call   801053e6 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
801027cd:	e9 90 00 00 00       	jmp    80102862 <ideintr+0xc1>
  }
  idequeue = b->qnext;
801027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d5:	8b 40 14             	mov    0x14(%eax),%eax
801027d8:	a3 94 c6 10 80       	mov    %eax,0x8010c694

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027e0:	8b 00                	mov    (%eax),%eax
801027e2:	83 e0 04             	and    $0x4,%eax
801027e5:	85 c0                	test   %eax,%eax
801027e7:	75 2e                	jne    80102817 <ideintr+0x76>
801027e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801027f0:	e8 66 fd ff ff       	call   8010255b <idewait>
801027f5:	85 c0                	test   %eax,%eax
801027f7:	78 1e                	js     80102817 <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
801027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fc:	83 c0 18             	add    $0x18,%eax
801027ff:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102806:	00 
80102807:	89 44 24 04          	mov    %eax,0x4(%esp)
8010280b:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102812:	e8 dc fc ff ff       	call   801024f3 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102817:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010281a:	8b 00                	mov    (%eax),%eax
8010281c:	83 c8 02             	or     $0x2,%eax
8010281f:	89 c2                	mov    %eax,%edx
80102821:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102824:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102826:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102829:	8b 00                	mov    (%eax),%eax
8010282b:	83 e0 fb             	and    $0xfffffffb,%eax
8010282e:	89 c2                	mov    %eax,%edx
80102830:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102833:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102835:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102838:	89 04 24             	mov    %eax,(%esp)
8010283b:	e8 2d 26 00 00       	call   80104e6d <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102840:	a1 94 c6 10 80       	mov    0x8010c694,%eax
80102845:	85 c0                	test   %eax,%eax
80102847:	74 0d                	je     80102856 <ideintr+0xb5>
    idestart(idequeue);
80102849:	a1 94 c6 10 80       	mov    0x8010c694,%eax
8010284e:	89 04 24             	mov    %eax,(%esp)
80102851:	e8 ef fd ff ff       	call   80102645 <idestart>

  release(&idelock);
80102856:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010285d:	e8 84 2b 00 00       	call   801053e6 <release>
}
80102862:	c9                   	leave  
80102863:	c3                   	ret    

80102864 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102864:	55                   	push   %ebp
80102865:	89 e5                	mov    %esp,%ebp
80102867:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
8010286a:	8b 45 08             	mov    0x8(%ebp),%eax
8010286d:	8b 00                	mov    (%eax),%eax
8010286f:	83 e0 01             	and    $0x1,%eax
80102872:	85 c0                	test   %eax,%eax
80102874:	75 0c                	jne    80102882 <iderw+0x1e>
    panic("iderw: buf not busy");
80102876:	c7 04 24 f5 8c 10 80 	movl   $0x80108cf5,(%esp)
8010287d:	e8 b8 dc ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102882:	8b 45 08             	mov    0x8(%ebp),%eax
80102885:	8b 00                	mov    (%eax),%eax
80102887:	83 e0 06             	and    $0x6,%eax
8010288a:	83 f8 02             	cmp    $0x2,%eax
8010288d:	75 0c                	jne    8010289b <iderw+0x37>
    panic("iderw: nothing to do");
8010288f:	c7 04 24 09 8d 10 80 	movl   $0x80108d09,(%esp)
80102896:	e8 9f dc ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
8010289b:	8b 45 08             	mov    0x8(%ebp),%eax
8010289e:	8b 40 04             	mov    0x4(%eax),%eax
801028a1:	85 c0                	test   %eax,%eax
801028a3:	74 15                	je     801028ba <iderw+0x56>
801028a5:	a1 98 c6 10 80       	mov    0x8010c698,%eax
801028aa:	85 c0                	test   %eax,%eax
801028ac:	75 0c                	jne    801028ba <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801028ae:	c7 04 24 1e 8d 10 80 	movl   $0x80108d1e,(%esp)
801028b5:	e8 80 dc ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028ba:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801028c1:	e8 be 2a 00 00       	call   80105384 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801028c6:	8b 45 08             	mov    0x8(%ebp),%eax
801028c9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028d0:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
801028d7:	eb 0b                	jmp    801028e4 <iderw+0x80>
801028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028dc:	8b 00                	mov    (%eax),%eax
801028de:	83 c0 14             	add    $0x14,%eax
801028e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028e7:	8b 00                	mov    (%eax),%eax
801028e9:	85 c0                	test   %eax,%eax
801028eb:	75 ec                	jne    801028d9 <iderw+0x75>
    ;
  *pp = b;
801028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f0:	8b 55 08             	mov    0x8(%ebp),%edx
801028f3:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801028f5:	a1 94 c6 10 80       	mov    0x8010c694,%eax
801028fa:	3b 45 08             	cmp    0x8(%ebp),%eax
801028fd:	75 0d                	jne    8010290c <iderw+0xa8>
    idestart(b);
801028ff:	8b 45 08             	mov    0x8(%ebp),%eax
80102902:	89 04 24             	mov    %eax,(%esp)
80102905:	e8 3b fd ff ff       	call   80102645 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010290a:	eb 15                	jmp    80102921 <iderw+0xbd>
8010290c:	eb 13                	jmp    80102921 <iderw+0xbd>
    sleep(b, &idelock);
8010290e:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80102915:	80 
80102916:	8b 45 08             	mov    0x8(%ebp),%eax
80102919:	89 04 24             	mov    %eax,(%esp)
8010291c:	e8 73 24 00 00       	call   80104d94 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102921:	8b 45 08             	mov    0x8(%ebp),%eax
80102924:	8b 00                	mov    (%eax),%eax
80102926:	83 e0 06             	and    $0x6,%eax
80102929:	83 f8 02             	cmp    $0x2,%eax
8010292c:	75 e0                	jne    8010290e <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
8010292e:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80102935:	e8 ac 2a 00 00       	call   801053e6 <release>
}
8010293a:	c9                   	leave  
8010293b:	c3                   	ret    

8010293c <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
8010293c:	55                   	push   %ebp
8010293d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010293f:	a1 74 32 11 80       	mov    0x80113274,%eax
80102944:	8b 55 08             	mov    0x8(%ebp),%edx
80102947:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102949:	a1 74 32 11 80       	mov    0x80113274,%eax
8010294e:	8b 40 10             	mov    0x10(%eax),%eax
}
80102951:	5d                   	pop    %ebp
80102952:	c3                   	ret    

80102953 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102953:	55                   	push   %ebp
80102954:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102956:	a1 74 32 11 80       	mov    0x80113274,%eax
8010295b:	8b 55 08             	mov    0x8(%ebp),%edx
8010295e:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102960:	a1 74 32 11 80       	mov    0x80113274,%eax
80102965:	8b 55 0c             	mov    0xc(%ebp),%edx
80102968:	89 50 10             	mov    %edx,0x10(%eax)
}
8010296b:	5d                   	pop    %ebp
8010296c:	c3                   	ret    

8010296d <ioapicinit>:

void
ioapicinit(void)
{
8010296d:	55                   	push   %ebp
8010296e:	89 e5                	mov    %esp,%ebp
80102970:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
80102973:	a1 a4 33 11 80       	mov    0x801133a4,%eax
80102978:	85 c0                	test   %eax,%eax
8010297a:	75 05                	jne    80102981 <ioapicinit+0x14>
    return;
8010297c:	e9 9d 00 00 00       	jmp    80102a1e <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
80102981:	c7 05 74 32 11 80 00 	movl   $0xfec00000,0x80113274
80102988:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010298b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102992:	e8 a5 ff ff ff       	call   8010293c <ioapicread>
80102997:	c1 e8 10             	shr    $0x10,%eax
8010299a:	25 ff 00 00 00       	and    $0xff,%eax
8010299f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801029a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801029a9:	e8 8e ff ff ff       	call   8010293c <ioapicread>
801029ae:	c1 e8 18             	shr    $0x18,%eax
801029b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801029b4:	0f b6 05 a0 33 11 80 	movzbl 0x801133a0,%eax
801029bb:	0f b6 c0             	movzbl %al,%eax
801029be:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801029c1:	74 0c                	je     801029cf <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029c3:	c7 04 24 3c 8d 10 80 	movl   $0x80108d3c,(%esp)
801029ca:	e8 d1 d9 ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029d6:	eb 3e                	jmp    80102a16 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029db:	83 c0 20             	add    $0x20,%eax
801029de:	0d 00 00 01 00       	or     $0x10000,%eax
801029e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801029e6:	83 c2 08             	add    $0x8,%edx
801029e9:	01 d2                	add    %edx,%edx
801029eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801029ef:	89 14 24             	mov    %edx,(%esp)
801029f2:	e8 5c ff ff ff       	call   80102953 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
801029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029fa:	83 c0 08             	add    $0x8,%eax
801029fd:	01 c0                	add    %eax,%eax
801029ff:	83 c0 01             	add    $0x1,%eax
80102a02:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102a09:	00 
80102a0a:	89 04 24             	mov    %eax,(%esp)
80102a0d:	e8 41 ff ff ff       	call   80102953 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a12:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a19:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a1c:	7e ba                	jle    801029d8 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a1e:	c9                   	leave  
80102a1f:	c3                   	ret    

80102a20 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102a26:	a1 a4 33 11 80       	mov    0x801133a4,%eax
80102a2b:	85 c0                	test   %eax,%eax
80102a2d:	75 02                	jne    80102a31 <ioapicenable+0x11>
    return;
80102a2f:	eb 37                	jmp    80102a68 <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a31:	8b 45 08             	mov    0x8(%ebp),%eax
80102a34:	83 c0 20             	add    $0x20,%eax
80102a37:	8b 55 08             	mov    0x8(%ebp),%edx
80102a3a:	83 c2 08             	add    $0x8,%edx
80102a3d:	01 d2                	add    %edx,%edx
80102a3f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a43:	89 14 24             	mov    %edx,(%esp)
80102a46:	e8 08 ff ff ff       	call   80102953 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a4e:	c1 e0 18             	shl    $0x18,%eax
80102a51:	8b 55 08             	mov    0x8(%ebp),%edx
80102a54:	83 c2 08             	add    $0x8,%edx
80102a57:	01 d2                	add    %edx,%edx
80102a59:	83 c2 01             	add    $0x1,%edx
80102a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a60:	89 14 24             	mov    %edx,(%esp)
80102a63:	e8 eb fe ff ff       	call   80102953 <ioapicwrite>
}
80102a68:	c9                   	leave  
80102a69:	c3                   	ret    

80102a6a <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a6a:	55                   	push   %ebp
80102a6b:	89 e5                	mov    %esp,%ebp
80102a6d:	8b 45 08             	mov    0x8(%ebp),%eax
80102a70:	05 00 00 00 80       	add    $0x80000000,%eax
80102a75:	5d                   	pop    %ebp
80102a76:	c3                   	ret    

80102a77 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a77:	55                   	push   %ebp
80102a78:	89 e5                	mov    %esp,%ebp
80102a7a:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102a7d:	c7 44 24 04 6e 8d 10 	movl   $0x80108d6e,0x4(%esp)
80102a84:	80 
80102a85:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80102a8c:	e8 d2 28 00 00       	call   80105363 <initlock>
  kmem.use_lock = 0;
80102a91:	c7 05 b4 32 11 80 00 	movl   $0x0,0x801132b4
80102a98:	00 00 00 
  freerange(vstart, vend);
80102a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102aa2:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa5:	89 04 24             	mov    %eax,(%esp)
80102aa8:	e8 26 00 00 00       	call   80102ad3 <freerange>
}
80102aad:	c9                   	leave  
80102aae:	c3                   	ret    

80102aaf <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102aaf:	55                   	push   %ebp
80102ab0:	89 e5                	mov    %esp,%ebp
80102ab2:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
80102abc:	8b 45 08             	mov    0x8(%ebp),%eax
80102abf:	89 04 24             	mov    %eax,(%esp)
80102ac2:	e8 0c 00 00 00       	call   80102ad3 <freerange>
  kmem.use_lock = 1;
80102ac7:	c7 05 b4 32 11 80 01 	movl   $0x1,0x801132b4
80102ace:	00 00 00 
}
80102ad1:	c9                   	leave  
80102ad2:	c3                   	ret    

80102ad3 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102ad3:	55                   	push   %ebp
80102ad4:	89 e5                	mov    %esp,%ebp
80102ad6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102ad9:	8b 45 08             	mov    0x8(%ebp),%eax
80102adc:	05 ff 0f 00 00       	add    $0xfff,%eax
80102ae1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ae9:	eb 12                	jmp    80102afd <freerange+0x2a>
    kfree(p);
80102aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aee:	89 04 24             	mov    %eax,(%esp)
80102af1:	e8 16 00 00 00       	call   80102b0c <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102af6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b00:	05 00 10 00 00       	add    $0x1000,%eax
80102b05:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102b08:	76 e1                	jbe    80102aeb <freerange+0x18>
    kfree(p);
}
80102b0a:	c9                   	leave  
80102b0b:	c3                   	ret    

80102b0c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b0c:	55                   	push   %ebp
80102b0d:	89 e5                	mov    %esp,%ebp
80102b0f:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102b12:	8b 45 08             	mov    0x8(%ebp),%eax
80102b15:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b1a:	85 c0                	test   %eax,%eax
80102b1c:	75 1b                	jne    80102b39 <kfree+0x2d>
80102b1e:	81 7d 08 9c 62 11 80 	cmpl   $0x8011629c,0x8(%ebp)
80102b25:	72 12                	jb     80102b39 <kfree+0x2d>
80102b27:	8b 45 08             	mov    0x8(%ebp),%eax
80102b2a:	89 04 24             	mov    %eax,(%esp)
80102b2d:	e8 38 ff ff ff       	call   80102a6a <v2p>
80102b32:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b37:	76 0c                	jbe    80102b45 <kfree+0x39>
    panic("kfree");
80102b39:	c7 04 24 73 8d 10 80 	movl   $0x80108d73,(%esp)
80102b40:	e8 f5 d9 ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b45:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102b4c:	00 
80102b4d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102b54:	00 
80102b55:	8b 45 08             	mov    0x8(%ebp),%eax
80102b58:	89 04 24             	mov    %eax,(%esp)
80102b5b:	e8 78 2a 00 00       	call   801055d8 <memset>

  if(kmem.use_lock)
80102b60:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80102b65:	85 c0                	test   %eax,%eax
80102b67:	74 0c                	je     80102b75 <kfree+0x69>
    acquire(&kmem.lock);
80102b69:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80102b70:	e8 0f 28 00 00       	call   80105384 <acquire>
  r = (struct run*)v;
80102b75:	8b 45 08             	mov    0x8(%ebp),%eax
80102b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b7b:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
80102b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b84:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b89:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  if(kmem.use_lock)
80102b8e:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80102b93:	85 c0                	test   %eax,%eax
80102b95:	74 0c                	je     80102ba3 <kfree+0x97>
    release(&kmem.lock);
80102b97:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80102b9e:	e8 43 28 00 00       	call   801053e6 <release>
}
80102ba3:	c9                   	leave  
80102ba4:	c3                   	ret    

80102ba5 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ba5:	55                   	push   %ebp
80102ba6:	89 e5                	mov    %esp,%ebp
80102ba8:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102bab:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80102bb0:	85 c0                	test   %eax,%eax
80102bb2:	74 0c                	je     80102bc0 <kalloc+0x1b>
    acquire(&kmem.lock);
80102bb4:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80102bbb:	e8 c4 27 00 00       	call   80105384 <acquire>
  r = kmem.freelist;
80102bc0:	a1 b8 32 11 80       	mov    0x801132b8,%eax
80102bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102bc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102bcc:	74 0a                	je     80102bd8 <kalloc+0x33>
    kmem.freelist = r->next;
80102bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bd1:	8b 00                	mov    (%eax),%eax
80102bd3:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  if(kmem.use_lock)
80102bd8:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80102bdd:	85 c0                	test   %eax,%eax
80102bdf:	74 0c                	je     80102bed <kalloc+0x48>
    release(&kmem.lock);
80102be1:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80102be8:	e8 f9 27 00 00       	call   801053e6 <release>
  return (char*)r;
80102bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102bf0:	c9                   	leave  
80102bf1:	c3                   	ret    

80102bf2 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102bf2:	55                   	push   %ebp
80102bf3:	89 e5                	mov    %esp,%ebp
80102bf5:	83 ec 14             	sub    $0x14,%esp
80102bf8:	8b 45 08             	mov    0x8(%ebp),%eax
80102bfb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bff:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c03:	89 c2                	mov    %eax,%edx
80102c05:	ec                   	in     (%dx),%al
80102c06:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c09:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c0d:	c9                   	leave  
80102c0e:	c3                   	ret    

80102c0f <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c0f:	55                   	push   %ebp
80102c10:	89 e5                	mov    %esp,%ebp
80102c12:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c15:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102c1c:	e8 d1 ff ff ff       	call   80102bf2 <inb>
80102c21:	0f b6 c0             	movzbl %al,%eax
80102c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c2a:	83 e0 01             	and    $0x1,%eax
80102c2d:	85 c0                	test   %eax,%eax
80102c2f:	75 0a                	jne    80102c3b <kbdgetc+0x2c>
    return -1;
80102c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c36:	e9 25 01 00 00       	jmp    80102d60 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102c3b:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102c42:	e8 ab ff ff ff       	call   80102bf2 <inb>
80102c47:	0f b6 c0             	movzbl %al,%eax
80102c4a:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c4d:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c54:	75 17                	jne    80102c6d <kbdgetc+0x5e>
    shift |= E0ESC;
80102c56:	a1 9c c6 10 80       	mov    0x8010c69c,%eax
80102c5b:	83 c8 40             	or     $0x40,%eax
80102c5e:	a3 9c c6 10 80       	mov    %eax,0x8010c69c
    return 0;
80102c63:	b8 00 00 00 00       	mov    $0x0,%eax
80102c68:	e9 f3 00 00 00       	jmp    80102d60 <kbdgetc+0x151>
  } else if(data & 0x80){
80102c6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c70:	25 80 00 00 00       	and    $0x80,%eax
80102c75:	85 c0                	test   %eax,%eax
80102c77:	74 45                	je     80102cbe <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c79:	a1 9c c6 10 80       	mov    0x8010c69c,%eax
80102c7e:	83 e0 40             	and    $0x40,%eax
80102c81:	85 c0                	test   %eax,%eax
80102c83:	75 08                	jne    80102c8d <kbdgetc+0x7e>
80102c85:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c88:	83 e0 7f             	and    $0x7f,%eax
80102c8b:	eb 03                	jmp    80102c90 <kbdgetc+0x81>
80102c8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c90:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c93:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c96:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c9b:	0f b6 00             	movzbl (%eax),%eax
80102c9e:	83 c8 40             	or     $0x40,%eax
80102ca1:	0f b6 c0             	movzbl %al,%eax
80102ca4:	f7 d0                	not    %eax
80102ca6:	89 c2                	mov    %eax,%edx
80102ca8:	a1 9c c6 10 80       	mov    0x8010c69c,%eax
80102cad:	21 d0                	and    %edx,%eax
80102caf:	a3 9c c6 10 80       	mov    %eax,0x8010c69c
    return 0;
80102cb4:	b8 00 00 00 00       	mov    $0x0,%eax
80102cb9:	e9 a2 00 00 00       	jmp    80102d60 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102cbe:	a1 9c c6 10 80       	mov    0x8010c69c,%eax
80102cc3:	83 e0 40             	and    $0x40,%eax
80102cc6:	85 c0                	test   %eax,%eax
80102cc8:	74 14                	je     80102cde <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102cca:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102cd1:	a1 9c c6 10 80       	mov    0x8010c69c,%eax
80102cd6:	83 e0 bf             	and    $0xffffffbf,%eax
80102cd9:	a3 9c c6 10 80       	mov    %eax,0x8010c69c
  }

  shift |= shiftcode[data];
80102cde:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ce1:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102ce6:	0f b6 00             	movzbl (%eax),%eax
80102ce9:	0f b6 d0             	movzbl %al,%edx
80102cec:	a1 9c c6 10 80       	mov    0x8010c69c,%eax
80102cf1:	09 d0                	or     %edx,%eax
80102cf3:	a3 9c c6 10 80       	mov    %eax,0x8010c69c
  shift ^= togglecode[data];
80102cf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cfb:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102d00:	0f b6 00             	movzbl (%eax),%eax
80102d03:	0f b6 d0             	movzbl %al,%edx
80102d06:	a1 9c c6 10 80       	mov    0x8010c69c,%eax
80102d0b:	31 d0                	xor    %edx,%eax
80102d0d:	a3 9c c6 10 80       	mov    %eax,0x8010c69c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d12:	a1 9c c6 10 80       	mov    0x8010c69c,%eax
80102d17:	83 e0 03             	and    $0x3,%eax
80102d1a:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102d21:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d24:	01 d0                	add    %edx,%eax
80102d26:	0f b6 00             	movzbl (%eax),%eax
80102d29:	0f b6 c0             	movzbl %al,%eax
80102d2c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d2f:	a1 9c c6 10 80       	mov    0x8010c69c,%eax
80102d34:	83 e0 08             	and    $0x8,%eax
80102d37:	85 c0                	test   %eax,%eax
80102d39:	74 22                	je     80102d5d <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102d3b:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d3f:	76 0c                	jbe    80102d4d <kbdgetc+0x13e>
80102d41:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d45:	77 06                	ja     80102d4d <kbdgetc+0x13e>
      c += 'A' - 'a';
80102d47:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d4b:	eb 10                	jmp    80102d5d <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102d4d:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d51:	76 0a                	jbe    80102d5d <kbdgetc+0x14e>
80102d53:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d57:	77 04                	ja     80102d5d <kbdgetc+0x14e>
      c += 'a' - 'A';
80102d59:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d60:	c9                   	leave  
80102d61:	c3                   	ret    

80102d62 <kbdintr>:

void
kbdintr(void)
{
80102d62:	55                   	push   %ebp
80102d63:	89 e5                	mov    %esp,%ebp
80102d65:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102d68:	c7 04 24 0f 2c 10 80 	movl   $0x80102c0f,(%esp)
80102d6f:	e8 54 da ff ff       	call   801007c8 <consoleintr>
}
80102d74:	c9                   	leave  
80102d75:	c3                   	ret    

80102d76 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102d76:	55                   	push   %ebp
80102d77:	89 e5                	mov    %esp,%ebp
80102d79:	83 ec 14             	sub    $0x14,%esp
80102d7c:	8b 45 08             	mov    0x8(%ebp),%eax
80102d7f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d83:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d87:	89 c2                	mov    %eax,%edx
80102d89:	ec                   	in     (%dx),%al
80102d8a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d8d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d91:	c9                   	leave  
80102d92:	c3                   	ret    

80102d93 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d93:	55                   	push   %ebp
80102d94:	89 e5                	mov    %esp,%ebp
80102d96:	83 ec 08             	sub    $0x8,%esp
80102d99:	8b 55 08             	mov    0x8(%ebp),%edx
80102d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d9f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102da3:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102da6:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102daa:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102dae:	ee                   	out    %al,(%dx)
}
80102daf:	c9                   	leave  
80102db0:	c3                   	ret    

80102db1 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102db1:	55                   	push   %ebp
80102db2:	89 e5                	mov    %esp,%ebp
80102db4:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102db7:	9c                   	pushf  
80102db8:	58                   	pop    %eax
80102db9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102dbf:	c9                   	leave  
80102dc0:	c3                   	ret    

80102dc1 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102dc1:	55                   	push   %ebp
80102dc2:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102dc4:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80102dc9:	8b 55 08             	mov    0x8(%ebp),%edx
80102dcc:	c1 e2 02             	shl    $0x2,%edx
80102dcf:	01 c2                	add    %eax,%edx
80102dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dd4:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102dd6:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80102ddb:	83 c0 20             	add    $0x20,%eax
80102dde:	8b 00                	mov    (%eax),%eax
}
80102de0:	5d                   	pop    %ebp
80102de1:	c3                   	ret    

80102de2 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102de2:	55                   	push   %ebp
80102de3:	89 e5                	mov    %esp,%ebp
80102de5:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102de8:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80102ded:	85 c0                	test   %eax,%eax
80102def:	75 05                	jne    80102df6 <lapicinit+0x14>
    return;
80102df1:	e9 43 01 00 00       	jmp    80102f39 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102df6:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102dfd:	00 
80102dfe:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102e05:	e8 b7 ff ff ff       	call   80102dc1 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e0a:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102e11:	00 
80102e12:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102e19:	e8 a3 ff ff ff       	call   80102dc1 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e1e:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102e25:	00 
80102e26:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102e2d:	e8 8f ff ff ff       	call   80102dc1 <lapicw>
  lapicw(TICR, 10000000); 
80102e32:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102e39:	00 
80102e3a:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102e41:	e8 7b ff ff ff       	call   80102dc1 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e46:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e4d:	00 
80102e4e:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102e55:	e8 67 ff ff ff       	call   80102dc1 <lapicw>
  lapicw(LINT1, MASKED);
80102e5a:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e61:	00 
80102e62:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102e69:	e8 53 ff ff ff       	call   80102dc1 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e6e:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80102e73:	83 c0 30             	add    $0x30,%eax
80102e76:	8b 00                	mov    (%eax),%eax
80102e78:	c1 e8 10             	shr    $0x10,%eax
80102e7b:	0f b6 c0             	movzbl %al,%eax
80102e7e:	83 f8 03             	cmp    $0x3,%eax
80102e81:	76 14                	jbe    80102e97 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102e83:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e8a:	00 
80102e8b:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e92:	e8 2a ff ff ff       	call   80102dc1 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e97:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e9e:	00 
80102e9f:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102ea6:	e8 16 ff ff ff       	call   80102dc1 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102eab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eb2:	00 
80102eb3:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102eba:	e8 02 ff ff ff       	call   80102dc1 <lapicw>
  lapicw(ESR, 0);
80102ebf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ec6:	00 
80102ec7:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102ece:	e8 ee fe ff ff       	call   80102dc1 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102ed3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eda:	00 
80102edb:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102ee2:	e8 da fe ff ff       	call   80102dc1 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ee7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eee:	00 
80102eef:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102ef6:	e8 c6 fe ff ff       	call   80102dc1 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102efb:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102f02:	00 
80102f03:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f0a:	e8 b2 fe ff ff       	call   80102dc1 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102f0f:	90                   	nop
80102f10:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80102f15:	05 00 03 00 00       	add    $0x300,%eax
80102f1a:	8b 00                	mov    (%eax),%eax
80102f1c:	25 00 10 00 00       	and    $0x1000,%eax
80102f21:	85 c0                	test   %eax,%eax
80102f23:	75 eb                	jne    80102f10 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f25:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f2c:	00 
80102f2d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102f34:	e8 88 fe ff ff       	call   80102dc1 <lapicw>
}
80102f39:	c9                   	leave  
80102f3a:	c3                   	ret    

80102f3b <cpunum>:

int
cpunum(void)
{
80102f3b:	55                   	push   %ebp
80102f3c:	89 e5                	mov    %esp,%ebp
80102f3e:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f41:	e8 6b fe ff ff       	call   80102db1 <readeflags>
80102f46:	25 00 02 00 00       	and    $0x200,%eax
80102f4b:	85 c0                	test   %eax,%eax
80102f4d:	74 25                	je     80102f74 <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102f4f:	a1 a0 c6 10 80       	mov    0x8010c6a0,%eax
80102f54:	8d 50 01             	lea    0x1(%eax),%edx
80102f57:	89 15 a0 c6 10 80    	mov    %edx,0x8010c6a0
80102f5d:	85 c0                	test   %eax,%eax
80102f5f:	75 13                	jne    80102f74 <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f61:	8b 45 04             	mov    0x4(%ebp),%eax
80102f64:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f68:	c7 04 24 7c 8d 10 80 	movl   $0x80108d7c,(%esp)
80102f6f:	e8 2c d4 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102f74:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80102f79:	85 c0                	test   %eax,%eax
80102f7b:	74 0f                	je     80102f8c <cpunum+0x51>
    return lapic[ID]>>24;
80102f7d:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80102f82:	83 c0 20             	add    $0x20,%eax
80102f85:	8b 00                	mov    (%eax),%eax
80102f87:	c1 e8 18             	shr    $0x18,%eax
80102f8a:	eb 05                	jmp    80102f91 <cpunum+0x56>
  return 0;
80102f8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f91:	c9                   	leave  
80102f92:	c3                   	ret    

80102f93 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f93:	55                   	push   %ebp
80102f94:	89 e5                	mov    %esp,%ebp
80102f96:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102f99:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80102f9e:	85 c0                	test   %eax,%eax
80102fa0:	74 14                	je     80102fb6 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102fa2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102fa9:	00 
80102faa:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102fb1:	e8 0b fe ff ff       	call   80102dc1 <lapicw>
}
80102fb6:	c9                   	leave  
80102fb7:	c3                   	ret    

80102fb8 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102fb8:	55                   	push   %ebp
80102fb9:	89 e5                	mov    %esp,%ebp
}
80102fbb:	5d                   	pop    %ebp
80102fbc:	c3                   	ret    

80102fbd <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fbd:	55                   	push   %ebp
80102fbe:	89 e5                	mov    %esp,%ebp
80102fc0:	83 ec 1c             	sub    $0x1c,%esp
80102fc3:	8b 45 08             	mov    0x8(%ebp),%eax
80102fc6:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102fc9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102fd0:	00 
80102fd1:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102fd8:	e8 b6 fd ff ff       	call   80102d93 <outb>
  outb(CMOS_PORT+1, 0x0A);
80102fdd:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102fe4:	00 
80102fe5:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102fec:	e8 a2 fd ff ff       	call   80102d93 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102ff1:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102ff8:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102ffb:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103000:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103003:	8d 50 02             	lea    0x2(%eax),%edx
80103006:	8b 45 0c             	mov    0xc(%ebp),%eax
80103009:	c1 e8 04             	shr    $0x4,%eax
8010300c:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010300f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103013:	c1 e0 18             	shl    $0x18,%eax
80103016:	89 44 24 04          	mov    %eax,0x4(%esp)
8010301a:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103021:	e8 9b fd ff ff       	call   80102dc1 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103026:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
8010302d:	00 
8010302e:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103035:	e8 87 fd ff ff       	call   80102dc1 <lapicw>
  microdelay(200);
8010303a:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103041:	e8 72 ff ff ff       	call   80102fb8 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80103046:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
8010304d:	00 
8010304e:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103055:	e8 67 fd ff ff       	call   80102dc1 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010305a:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80103061:	e8 52 ff ff ff       	call   80102fb8 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103066:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010306d:	eb 40                	jmp    801030af <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
8010306f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103073:	c1 e0 18             	shl    $0x18,%eax
80103076:	89 44 24 04          	mov    %eax,0x4(%esp)
8010307a:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103081:	e8 3b fd ff ff       	call   80102dc1 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80103086:	8b 45 0c             	mov    0xc(%ebp),%eax
80103089:	c1 e8 0c             	shr    $0xc,%eax
8010308c:	80 cc 06             	or     $0x6,%ah
8010308f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103093:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010309a:	e8 22 fd ff ff       	call   80102dc1 <lapicw>
    microdelay(200);
8010309f:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801030a6:	e8 0d ff ff ff       	call   80102fb8 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030ab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801030af:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801030b3:	7e ba                	jle    8010306f <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801030b5:	c9                   	leave  
801030b6:	c3                   	ret    

801030b7 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801030b7:	55                   	push   %ebp
801030b8:	89 e5                	mov    %esp,%ebp
801030ba:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
801030bd:	8b 45 08             	mov    0x8(%ebp),%eax
801030c0:	0f b6 c0             	movzbl %al,%eax
801030c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801030c7:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801030ce:	e8 c0 fc ff ff       	call   80102d93 <outb>
  microdelay(200);
801030d3:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801030da:	e8 d9 fe ff ff       	call   80102fb8 <microdelay>

  return inb(CMOS_RETURN);
801030df:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
801030e6:	e8 8b fc ff ff       	call   80102d76 <inb>
801030eb:	0f b6 c0             	movzbl %al,%eax
}
801030ee:	c9                   	leave  
801030ef:	c3                   	ret    

801030f0 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
801030f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801030fd:	e8 b5 ff ff ff       	call   801030b7 <cmos_read>
80103102:	8b 55 08             	mov    0x8(%ebp),%edx
80103105:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103107:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010310e:	e8 a4 ff ff ff       	call   801030b7 <cmos_read>
80103113:	8b 55 08             	mov    0x8(%ebp),%edx
80103116:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103119:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80103120:	e8 92 ff ff ff       	call   801030b7 <cmos_read>
80103125:	8b 55 08             	mov    0x8(%ebp),%edx
80103128:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
8010312b:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80103132:	e8 80 ff ff ff       	call   801030b7 <cmos_read>
80103137:	8b 55 08             	mov    0x8(%ebp),%edx
8010313a:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010313d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80103144:	e8 6e ff ff ff       	call   801030b7 <cmos_read>
80103149:	8b 55 08             	mov    0x8(%ebp),%edx
8010314c:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010314f:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
80103156:	e8 5c ff ff ff       	call   801030b7 <cmos_read>
8010315b:	8b 55 08             	mov    0x8(%ebp),%edx
8010315e:	89 42 14             	mov    %eax,0x14(%edx)
}
80103161:	c9                   	leave  
80103162:	c3                   	ret    

80103163 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103163:	55                   	push   %ebp
80103164:	89 e5                	mov    %esp,%ebp
80103166:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103169:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
80103170:	e8 42 ff ff ff       	call   801030b7 <cmos_read>
80103175:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010317b:	83 e0 04             	and    $0x4,%eax
8010317e:	85 c0                	test   %eax,%eax
80103180:	0f 94 c0             	sete   %al
80103183:	0f b6 c0             	movzbl %al,%eax
80103186:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103189:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010318c:	89 04 24             	mov    %eax,(%esp)
8010318f:	e8 5c ff ff ff       	call   801030f0 <fill_rtcdate>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103194:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
8010319b:	e8 17 ff ff ff       	call   801030b7 <cmos_read>
801031a0:	25 80 00 00 00       	and    $0x80,%eax
801031a5:	85 c0                	test   %eax,%eax
801031a7:	74 02                	je     801031ab <cmostime+0x48>
        continue;
801031a9:	eb 36                	jmp    801031e1 <cmostime+0x7e>
    fill_rtcdate(&t2);
801031ab:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031ae:	89 04 24             	mov    %eax,(%esp)
801031b1:	e8 3a ff ff ff       	call   801030f0 <fill_rtcdate>
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801031b6:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801031bd:	00 
801031be:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801031c5:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031c8:	89 04 24             	mov    %eax,(%esp)
801031cb:	e8 7f 24 00 00       	call   8010564f <memcmp>
801031d0:	85 c0                	test   %eax,%eax
801031d2:	75 0d                	jne    801031e1 <cmostime+0x7e>
      break;
801031d4:	90                   	nop
  }

  // convert
  if (bcd) {
801031d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801031d9:	0f 84 ac 00 00 00    	je     8010328b <cmostime+0x128>
801031df:	eb 02                	jmp    801031e3 <cmostime+0x80>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801031e1:	eb a6                	jmp    80103189 <cmostime+0x26>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
801031e6:	c1 e8 04             	shr    $0x4,%eax
801031e9:	89 c2                	mov    %eax,%edx
801031eb:	89 d0                	mov    %edx,%eax
801031ed:	c1 e0 02             	shl    $0x2,%eax
801031f0:	01 d0                	add    %edx,%eax
801031f2:	01 c0                	add    %eax,%eax
801031f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
801031f7:	83 e2 0f             	and    $0xf,%edx
801031fa:	01 d0                	add    %edx,%eax
801031fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801031ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103202:	c1 e8 04             	shr    $0x4,%eax
80103205:	89 c2                	mov    %eax,%edx
80103207:	89 d0                	mov    %edx,%eax
80103209:	c1 e0 02             	shl    $0x2,%eax
8010320c:	01 d0                	add    %edx,%eax
8010320e:	01 c0                	add    %eax,%eax
80103210:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103213:	83 e2 0f             	and    $0xf,%edx
80103216:	01 d0                	add    %edx,%eax
80103218:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010321b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010321e:	c1 e8 04             	shr    $0x4,%eax
80103221:	89 c2                	mov    %eax,%edx
80103223:	89 d0                	mov    %edx,%eax
80103225:	c1 e0 02             	shl    $0x2,%eax
80103228:	01 d0                	add    %edx,%eax
8010322a:	01 c0                	add    %eax,%eax
8010322c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010322f:	83 e2 0f             	and    $0xf,%edx
80103232:	01 d0                	add    %edx,%eax
80103234:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103237:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010323a:	c1 e8 04             	shr    $0x4,%eax
8010323d:	89 c2                	mov    %eax,%edx
8010323f:	89 d0                	mov    %edx,%eax
80103241:	c1 e0 02             	shl    $0x2,%eax
80103244:	01 d0                	add    %edx,%eax
80103246:	01 c0                	add    %eax,%eax
80103248:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010324b:	83 e2 0f             	and    $0xf,%edx
8010324e:	01 d0                	add    %edx,%eax
80103250:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103253:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103256:	c1 e8 04             	shr    $0x4,%eax
80103259:	89 c2                	mov    %eax,%edx
8010325b:	89 d0                	mov    %edx,%eax
8010325d:	c1 e0 02             	shl    $0x2,%eax
80103260:	01 d0                	add    %edx,%eax
80103262:	01 c0                	add    %eax,%eax
80103264:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103267:	83 e2 0f             	and    $0xf,%edx
8010326a:	01 d0                	add    %edx,%eax
8010326c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
8010326f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103272:	c1 e8 04             	shr    $0x4,%eax
80103275:	89 c2                	mov    %eax,%edx
80103277:	89 d0                	mov    %edx,%eax
80103279:	c1 e0 02             	shl    $0x2,%eax
8010327c:	01 d0                	add    %edx,%eax
8010327e:	01 c0                	add    %eax,%eax
80103280:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103283:	83 e2 0f             	and    $0xf,%edx
80103286:	01 d0                	add    %edx,%eax
80103288:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010328b:	8b 45 08             	mov    0x8(%ebp),%eax
8010328e:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103291:	89 10                	mov    %edx,(%eax)
80103293:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103296:	89 50 04             	mov    %edx,0x4(%eax)
80103299:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010329c:	89 50 08             	mov    %edx,0x8(%eax)
8010329f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032a2:	89 50 0c             	mov    %edx,0xc(%eax)
801032a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032a8:	89 50 10             	mov    %edx,0x10(%eax)
801032ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
801032ae:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801032b1:	8b 45 08             	mov    0x8(%ebp),%eax
801032b4:	8b 40 14             	mov    0x14(%eax),%eax
801032b7:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801032bd:	8b 45 08             	mov    0x8(%ebp),%eax
801032c0:	89 50 14             	mov    %edx,0x14(%eax)
}
801032c3:	c9                   	leave  
801032c4:	c3                   	ret    

801032c5 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801032c5:	55                   	push   %ebp
801032c6:	89 e5                	mov    %esp,%ebp
801032c8:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801032cb:	c7 44 24 04 a8 8d 10 	movl   $0x80108da8,0x4(%esp)
801032d2:	80 
801032d3:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
801032da:	e8 84 20 00 00       	call   80105363 <initlock>
  readsb(dev, &sb);
801032df:	8d 45 dc             	lea    -0x24(%ebp),%eax
801032e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801032e6:	8b 45 08             	mov    0x8(%ebp),%eax
801032e9:	89 04 24             	mov    %eax,(%esp)
801032ec:	e8 28 e0 ff ff       	call   80101319 <readsb>
  log.start = sb.logstart;
801032f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032f4:	a3 f4 32 11 80       	mov    %eax,0x801132f4
  log.size = sb.nlog;
801032f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032fc:	a3 f8 32 11 80       	mov    %eax,0x801132f8
  log.dev = dev;
80103301:	8b 45 08             	mov    0x8(%ebp),%eax
80103304:	a3 04 33 11 80       	mov    %eax,0x80113304
  recover_from_log();
80103309:	e8 9a 01 00 00       	call   801034a8 <recover_from_log>
}
8010330e:	c9                   	leave  
8010330f:	c3                   	ret    

80103310 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103310:	55                   	push   %ebp
80103311:	89 e5                	mov    %esp,%ebp
80103313:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103316:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010331d:	e9 8c 00 00 00       	jmp    801033ae <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103322:	8b 15 f4 32 11 80    	mov    0x801132f4,%edx
80103328:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010332b:	01 d0                	add    %edx,%eax
8010332d:	83 c0 01             	add    $0x1,%eax
80103330:	89 c2                	mov    %eax,%edx
80103332:	a1 04 33 11 80       	mov    0x80113304,%eax
80103337:	89 54 24 04          	mov    %edx,0x4(%esp)
8010333b:	89 04 24             	mov    %eax,(%esp)
8010333e:	e8 63 ce ff ff       	call   801001a6 <bread>
80103343:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103346:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103349:	83 c0 10             	add    $0x10,%eax
8010334c:	8b 04 85 cc 32 11 80 	mov    -0x7feecd34(,%eax,4),%eax
80103353:	89 c2                	mov    %eax,%edx
80103355:	a1 04 33 11 80       	mov    0x80113304,%eax
8010335a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010335e:	89 04 24             	mov    %eax,(%esp)
80103361:	e8 40 ce ff ff       	call   801001a6 <bread>
80103366:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103369:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010336c:	8d 50 18             	lea    0x18(%eax),%edx
8010336f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103372:	83 c0 18             	add    $0x18,%eax
80103375:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010337c:	00 
8010337d:	89 54 24 04          	mov    %edx,0x4(%esp)
80103381:	89 04 24             	mov    %eax,(%esp)
80103384:	e8 1e 23 00 00       	call   801056a7 <memmove>
    bwrite(dbuf);  // write dst to disk
80103389:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010338c:	89 04 24             	mov    %eax,(%esp)
8010338f:	e8 49 ce ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
80103394:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103397:	89 04 24             	mov    %eax,(%esp)
8010339a:	e8 78 ce ff ff       	call   80100217 <brelse>
    brelse(dbuf);
8010339f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033a2:	89 04 24             	mov    %eax,(%esp)
801033a5:	e8 6d ce ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033ae:	a1 08 33 11 80       	mov    0x80113308,%eax
801033b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033b6:	0f 8f 66 ff ff ff    	jg     80103322 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801033bc:	c9                   	leave  
801033bd:	c3                   	ret    

801033be <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801033be:	55                   	push   %ebp
801033bf:	89 e5                	mov    %esp,%ebp
801033c1:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801033c4:	a1 f4 32 11 80       	mov    0x801132f4,%eax
801033c9:	89 c2                	mov    %eax,%edx
801033cb:	a1 04 33 11 80       	mov    0x80113304,%eax
801033d0:	89 54 24 04          	mov    %edx,0x4(%esp)
801033d4:	89 04 24             	mov    %eax,(%esp)
801033d7:	e8 ca cd ff ff       	call   801001a6 <bread>
801033dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801033df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033e2:	83 c0 18             	add    $0x18,%eax
801033e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801033e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033eb:	8b 00                	mov    (%eax),%eax
801033ed:	a3 08 33 11 80       	mov    %eax,0x80113308
  for (i = 0; i < log.lh.n; i++) {
801033f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033f9:	eb 1b                	jmp    80103416 <read_head+0x58>
    log.lh.block[i] = lh->block[i];
801033fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103401:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103405:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103408:	83 c2 10             	add    $0x10,%edx
8010340b:	89 04 95 cc 32 11 80 	mov    %eax,-0x7feecd34(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103412:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103416:	a1 08 33 11 80       	mov    0x80113308,%eax
8010341b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010341e:	7f db                	jg     801033fb <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80103420:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103423:	89 04 24             	mov    %eax,(%esp)
80103426:	e8 ec cd ff ff       	call   80100217 <brelse>
}
8010342b:	c9                   	leave  
8010342c:	c3                   	ret    

8010342d <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010342d:	55                   	push   %ebp
8010342e:	89 e5                	mov    %esp,%ebp
80103430:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103433:	a1 f4 32 11 80       	mov    0x801132f4,%eax
80103438:	89 c2                	mov    %eax,%edx
8010343a:	a1 04 33 11 80       	mov    0x80113304,%eax
8010343f:	89 54 24 04          	mov    %edx,0x4(%esp)
80103443:	89 04 24             	mov    %eax,(%esp)
80103446:	e8 5b cd ff ff       	call   801001a6 <bread>
8010344b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010344e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103451:	83 c0 18             	add    $0x18,%eax
80103454:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103457:	8b 15 08 33 11 80    	mov    0x80113308,%edx
8010345d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103460:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103469:	eb 1b                	jmp    80103486 <write_head+0x59>
    hb->block[i] = log.lh.block[i];
8010346b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010346e:	83 c0 10             	add    $0x10,%eax
80103471:	8b 0c 85 cc 32 11 80 	mov    -0x7feecd34(,%eax,4),%ecx
80103478:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010347b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010347e:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103482:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103486:	a1 08 33 11 80       	mov    0x80113308,%eax
8010348b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010348e:	7f db                	jg     8010346b <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103490:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103493:	89 04 24             	mov    %eax,(%esp)
80103496:	e8 42 cd ff ff       	call   801001dd <bwrite>
  brelse(buf);
8010349b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010349e:	89 04 24             	mov    %eax,(%esp)
801034a1:	e8 71 cd ff ff       	call   80100217 <brelse>
}
801034a6:	c9                   	leave  
801034a7:	c3                   	ret    

801034a8 <recover_from_log>:

static void
recover_from_log(void)
{
801034a8:	55                   	push   %ebp
801034a9:	89 e5                	mov    %esp,%ebp
801034ab:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801034ae:	e8 0b ff ff ff       	call   801033be <read_head>
  install_trans(); // if committed, copy from log to disk
801034b3:	e8 58 fe ff ff       	call   80103310 <install_trans>
  log.lh.n = 0;
801034b8:	c7 05 08 33 11 80 00 	movl   $0x0,0x80113308
801034bf:	00 00 00 
  write_head(); // clear the log
801034c2:	e8 66 ff ff ff       	call   8010342d <write_head>
}
801034c7:	c9                   	leave  
801034c8:	c3                   	ret    

801034c9 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801034c9:	55                   	push   %ebp
801034ca:	89 e5                	mov    %esp,%ebp
801034cc:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801034cf:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
801034d6:	e8 a9 1e 00 00       	call   80105384 <acquire>
  while(1){
    if(log.committing){
801034db:	a1 00 33 11 80       	mov    0x80113300,%eax
801034e0:	85 c0                	test   %eax,%eax
801034e2:	74 16                	je     801034fa <begin_op+0x31>
      sleep(&log, &log.lock);
801034e4:	c7 44 24 04 c0 32 11 	movl   $0x801132c0,0x4(%esp)
801034eb:	80 
801034ec:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
801034f3:	e8 9c 18 00 00       	call   80104d94 <sleep>
801034f8:	eb 4f                	jmp    80103549 <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801034fa:	8b 0d 08 33 11 80    	mov    0x80113308,%ecx
80103500:	a1 fc 32 11 80       	mov    0x801132fc,%eax
80103505:	8d 50 01             	lea    0x1(%eax),%edx
80103508:	89 d0                	mov    %edx,%eax
8010350a:	c1 e0 02             	shl    $0x2,%eax
8010350d:	01 d0                	add    %edx,%eax
8010350f:	01 c0                	add    %eax,%eax
80103511:	01 c8                	add    %ecx,%eax
80103513:	83 f8 1e             	cmp    $0x1e,%eax
80103516:	7e 16                	jle    8010352e <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103518:	c7 44 24 04 c0 32 11 	movl   $0x801132c0,0x4(%esp)
8010351f:	80 
80103520:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
80103527:	e8 68 18 00 00       	call   80104d94 <sleep>
8010352c:	eb 1b                	jmp    80103549 <begin_op+0x80>
    } else {
      log.outstanding += 1;
8010352e:	a1 fc 32 11 80       	mov    0x801132fc,%eax
80103533:	83 c0 01             	add    $0x1,%eax
80103536:	a3 fc 32 11 80       	mov    %eax,0x801132fc
      release(&log.lock);
8010353b:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
80103542:	e8 9f 1e 00 00       	call   801053e6 <release>
      break;
80103547:	eb 02                	jmp    8010354b <begin_op+0x82>
    }
  }
80103549:	eb 90                	jmp    801034db <begin_op+0x12>
}
8010354b:	c9                   	leave  
8010354c:	c3                   	ret    

8010354d <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010354d:	55                   	push   %ebp
8010354e:	89 e5                	mov    %esp,%ebp
80103550:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
80103553:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010355a:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
80103561:	e8 1e 1e 00 00       	call   80105384 <acquire>
  log.outstanding -= 1;
80103566:	a1 fc 32 11 80       	mov    0x801132fc,%eax
8010356b:	83 e8 01             	sub    $0x1,%eax
8010356e:	a3 fc 32 11 80       	mov    %eax,0x801132fc
  if(log.committing)
80103573:	a1 00 33 11 80       	mov    0x80113300,%eax
80103578:	85 c0                	test   %eax,%eax
8010357a:	74 0c                	je     80103588 <end_op+0x3b>
    panic("log.committing");
8010357c:	c7 04 24 ac 8d 10 80 	movl   $0x80108dac,(%esp)
80103583:	e8 b2 cf ff ff       	call   8010053a <panic>
  if(log.outstanding == 0){
80103588:	a1 fc 32 11 80       	mov    0x801132fc,%eax
8010358d:	85 c0                	test   %eax,%eax
8010358f:	75 13                	jne    801035a4 <end_op+0x57>
    do_commit = 1;
80103591:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103598:	c7 05 00 33 11 80 01 	movl   $0x1,0x80113300
8010359f:	00 00 00 
801035a2:	eb 0c                	jmp    801035b0 <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801035a4:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
801035ab:	e8 bd 18 00 00       	call   80104e6d <wakeup>
  }
  release(&log.lock);
801035b0:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
801035b7:	e8 2a 1e 00 00       	call   801053e6 <release>

  if(do_commit){
801035bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035c0:	74 33                	je     801035f5 <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801035c2:	e8 de 00 00 00       	call   801036a5 <commit>
    acquire(&log.lock);
801035c7:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
801035ce:	e8 b1 1d 00 00       	call   80105384 <acquire>
    log.committing = 0;
801035d3:	c7 05 00 33 11 80 00 	movl   $0x0,0x80113300
801035da:	00 00 00 
    wakeup(&log);
801035dd:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
801035e4:	e8 84 18 00 00       	call   80104e6d <wakeup>
    release(&log.lock);
801035e9:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
801035f0:	e8 f1 1d 00 00       	call   801053e6 <release>
  }
}
801035f5:	c9                   	leave  
801035f6:	c3                   	ret    

801035f7 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801035f7:	55                   	push   %ebp
801035f8:	89 e5                	mov    %esp,%ebp
801035fa:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103604:	e9 8c 00 00 00       	jmp    80103695 <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103609:	8b 15 f4 32 11 80    	mov    0x801132f4,%edx
8010360f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103612:	01 d0                	add    %edx,%eax
80103614:	83 c0 01             	add    $0x1,%eax
80103617:	89 c2                	mov    %eax,%edx
80103619:	a1 04 33 11 80       	mov    0x80113304,%eax
8010361e:	89 54 24 04          	mov    %edx,0x4(%esp)
80103622:	89 04 24             	mov    %eax,(%esp)
80103625:	e8 7c cb ff ff       	call   801001a6 <bread>
8010362a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010362d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103630:	83 c0 10             	add    $0x10,%eax
80103633:	8b 04 85 cc 32 11 80 	mov    -0x7feecd34(,%eax,4),%eax
8010363a:	89 c2                	mov    %eax,%edx
8010363c:	a1 04 33 11 80       	mov    0x80113304,%eax
80103641:	89 54 24 04          	mov    %edx,0x4(%esp)
80103645:	89 04 24             	mov    %eax,(%esp)
80103648:	e8 59 cb ff ff       	call   801001a6 <bread>
8010364d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103650:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103653:	8d 50 18             	lea    0x18(%eax),%edx
80103656:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103659:	83 c0 18             	add    $0x18,%eax
8010365c:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103663:	00 
80103664:	89 54 24 04          	mov    %edx,0x4(%esp)
80103668:	89 04 24             	mov    %eax,(%esp)
8010366b:	e8 37 20 00 00       	call   801056a7 <memmove>
    bwrite(to);  // write the log
80103670:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103673:	89 04 24             	mov    %eax,(%esp)
80103676:	e8 62 cb ff ff       	call   801001dd <bwrite>
    brelse(from); 
8010367b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010367e:	89 04 24             	mov    %eax,(%esp)
80103681:	e8 91 cb ff ff       	call   80100217 <brelse>
    brelse(to);
80103686:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103689:	89 04 24             	mov    %eax,(%esp)
8010368c:	e8 86 cb ff ff       	call   80100217 <brelse>
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103691:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103695:	a1 08 33 11 80       	mov    0x80113308,%eax
8010369a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010369d:	0f 8f 66 ff ff ff    	jg     80103609 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801036a3:	c9                   	leave  
801036a4:	c3                   	ret    

801036a5 <commit>:

static void
commit()
{
801036a5:	55                   	push   %ebp
801036a6:	89 e5                	mov    %esp,%ebp
801036a8:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801036ab:	a1 08 33 11 80       	mov    0x80113308,%eax
801036b0:	85 c0                	test   %eax,%eax
801036b2:	7e 1e                	jle    801036d2 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801036b4:	e8 3e ff ff ff       	call   801035f7 <write_log>
    write_head();    // Write header to disk -- the real commit
801036b9:	e8 6f fd ff ff       	call   8010342d <write_head>
    install_trans(); // Now install writes to home locations
801036be:	e8 4d fc ff ff       	call   80103310 <install_trans>
    log.lh.n = 0; 
801036c3:	c7 05 08 33 11 80 00 	movl   $0x0,0x80113308
801036ca:	00 00 00 
    write_head();    // Erase the transaction from the log
801036cd:	e8 5b fd ff ff       	call   8010342d <write_head>
  }
}
801036d2:	c9                   	leave  
801036d3:	c3                   	ret    

801036d4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801036d4:	55                   	push   %ebp
801036d5:	89 e5                	mov    %esp,%ebp
801036d7:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801036da:	a1 08 33 11 80       	mov    0x80113308,%eax
801036df:	83 f8 1d             	cmp    $0x1d,%eax
801036e2:	7f 12                	jg     801036f6 <log_write+0x22>
801036e4:	a1 08 33 11 80       	mov    0x80113308,%eax
801036e9:	8b 15 f8 32 11 80    	mov    0x801132f8,%edx
801036ef:	83 ea 01             	sub    $0x1,%edx
801036f2:	39 d0                	cmp    %edx,%eax
801036f4:	7c 0c                	jl     80103702 <log_write+0x2e>
    panic("too big a transaction");
801036f6:	c7 04 24 bb 8d 10 80 	movl   $0x80108dbb,(%esp)
801036fd:	e8 38 ce ff ff       	call   8010053a <panic>
  if (log.outstanding < 1)
80103702:	a1 fc 32 11 80       	mov    0x801132fc,%eax
80103707:	85 c0                	test   %eax,%eax
80103709:	7f 0c                	jg     80103717 <log_write+0x43>
    panic("log_write outside of trans");
8010370b:	c7 04 24 d1 8d 10 80 	movl   $0x80108dd1,(%esp)
80103712:	e8 23 ce ff ff       	call   8010053a <panic>

  acquire(&log.lock);
80103717:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
8010371e:	e8 61 1c 00 00       	call   80105384 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103723:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010372a:	eb 1f                	jmp    8010374b <log_write+0x77>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010372c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010372f:	83 c0 10             	add    $0x10,%eax
80103732:	8b 04 85 cc 32 11 80 	mov    -0x7feecd34(,%eax,4),%eax
80103739:	89 c2                	mov    %eax,%edx
8010373b:	8b 45 08             	mov    0x8(%ebp),%eax
8010373e:	8b 40 08             	mov    0x8(%eax),%eax
80103741:	39 c2                	cmp    %eax,%edx
80103743:	75 02                	jne    80103747 <log_write+0x73>
      break;
80103745:	eb 0e                	jmp    80103755 <log_write+0x81>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103747:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010374b:	a1 08 33 11 80       	mov    0x80113308,%eax
80103750:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103753:	7f d7                	jg     8010372c <log_write+0x58>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103755:	8b 45 08             	mov    0x8(%ebp),%eax
80103758:	8b 40 08             	mov    0x8(%eax),%eax
8010375b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010375e:	83 c2 10             	add    $0x10,%edx
80103761:	89 04 95 cc 32 11 80 	mov    %eax,-0x7feecd34(,%edx,4)
  if (i == log.lh.n)
80103768:	a1 08 33 11 80       	mov    0x80113308,%eax
8010376d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103770:	75 0d                	jne    8010377f <log_write+0xab>
    log.lh.n++;
80103772:	a1 08 33 11 80       	mov    0x80113308,%eax
80103777:	83 c0 01             	add    $0x1,%eax
8010377a:	a3 08 33 11 80       	mov    %eax,0x80113308
  b->flags |= B_DIRTY; // prevent eviction
8010377f:	8b 45 08             	mov    0x8(%ebp),%eax
80103782:	8b 00                	mov    (%eax),%eax
80103784:	83 c8 04             	or     $0x4,%eax
80103787:	89 c2                	mov    %eax,%edx
80103789:	8b 45 08             	mov    0x8(%ebp),%eax
8010378c:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010378e:	c7 04 24 c0 32 11 80 	movl   $0x801132c0,(%esp)
80103795:	e8 4c 1c 00 00       	call   801053e6 <release>
}
8010379a:	c9                   	leave  
8010379b:	c3                   	ret    

8010379c <v2p>:
8010379c:	55                   	push   %ebp
8010379d:	89 e5                	mov    %esp,%ebp
8010379f:	8b 45 08             	mov    0x8(%ebp),%eax
801037a2:	05 00 00 00 80       	add    $0x80000000,%eax
801037a7:	5d                   	pop    %ebp
801037a8:	c3                   	ret    

801037a9 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801037a9:	55                   	push   %ebp
801037aa:	89 e5                	mov    %esp,%ebp
801037ac:	8b 45 08             	mov    0x8(%ebp),%eax
801037af:	05 00 00 00 80       	add    $0x80000000,%eax
801037b4:	5d                   	pop    %ebp
801037b5:	c3                   	ret    

801037b6 <xchg>:
  asm volatile("hlt");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801037b6:	55                   	push   %ebp
801037b7:	89 e5                	mov    %esp,%ebp
801037b9:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801037bc:	8b 55 08             	mov    0x8(%ebp),%edx
801037bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801037c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801037c5:	f0 87 02             	lock xchg %eax,(%edx)
801037c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801037cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801037ce:	c9                   	leave  
801037cf:	c3                   	ret    

801037d0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	83 e4 f0             	and    $0xfffffff0,%esp
801037d6:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801037d9:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801037e0:	80 
801037e1:	c7 04 24 9c 62 11 80 	movl   $0x8011629c,(%esp)
801037e8:	e8 8a f2 ff ff       	call   80102a77 <kinit1>
  kvmalloc();      // kernel page table
801037ed:	e8 71 4a 00 00       	call   80108263 <kvmalloc>
  mpinit();        // collect info about this machine
801037f2:	e8 41 04 00 00       	call   80103c38 <mpinit>
  lapicinit();
801037f7:	e8 e6 f5 ff ff       	call   80102de2 <lapicinit>
  seginit();       // set up segments
801037fc:	e8 f5 43 00 00       	call   80107bf6 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103801:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103807:	0f b6 00             	movzbl (%eax),%eax
8010380a:	0f b6 c0             	movzbl %al,%eax
8010380d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103811:	c7 04 24 ec 8d 10 80 	movl   $0x80108dec,(%esp)
80103818:	e8 83 cb ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
8010381d:	e8 74 06 00 00       	call   80103e96 <picinit>
  ioapicinit();    // another interrupt controller
80103822:	e8 46 f1 ff ff       	call   8010296d <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103827:	e8 84 d2 ff ff       	call   80100ab0 <consoleinit>
  uartinit();      // serial port
8010382c:	e8 14 37 00 00       	call   80106f45 <uartinit>
  pinit();         // process table
80103831:	e8 70 0b 00 00       	call   801043a6 <pinit>
  tvinit();        // trap vectors
80103836:	e8 bc 32 00 00       	call   80106af7 <tvinit>
  binit();         // buffer cache
8010383b:	e8 f4 c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103840:	e8 ed d6 ff ff       	call   80100f32 <fileinit>
  ideinit();       // disk
80103845:	e8 55 ed ff ff       	call   8010259f <ideinit>
  if(!ismp)
8010384a:	a1 a4 33 11 80       	mov    0x801133a4,%eax
8010384f:	85 c0                	test   %eax,%eax
80103851:	75 05                	jne    80103858 <main+0x88>
    timerinit();   // uniprocessor timer
80103853:	e8 ea 31 00 00       	call   80106a42 <timerinit>
  startothers();   // start other processors
80103858:	e8 7f 00 00 00       	call   801038dc <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010385d:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103864:	8e 
80103865:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
8010386c:	e8 3e f2 ff ff       	call   80102aaf <kinit2>
  userinit();      // first user process
80103871:	e8 d6 0c 00 00       	call   8010454c <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103876:	e8 1a 00 00 00       	call   80103895 <mpmain>

8010387b <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010387b:	55                   	push   %ebp
8010387c:	89 e5                	mov    %esp,%ebp
8010387e:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103881:	e8 f4 49 00 00       	call   8010827a <switchkvm>
  seginit();
80103886:	e8 6b 43 00 00       	call   80107bf6 <seginit>
  lapicinit();
8010388b:	e8 52 f5 ff ff       	call   80102de2 <lapicinit>
  mpmain();
80103890:	e8 00 00 00 00       	call   80103895 <mpmain>

80103895 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103895:	55                   	push   %ebp
80103896:	89 e5                	mov    %esp,%ebp
80103898:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
8010389b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038a1:	0f b6 00             	movzbl (%eax),%eax
801038a4:	0f b6 c0             	movzbl %al,%eax
801038a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801038ab:	c7 04 24 03 8e 10 80 	movl   $0x80108e03,(%esp)
801038b2:	e8 e9 ca ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
801038b7:	e8 af 33 00 00       	call   80106c6b <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801038bc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038c2:	05 a8 00 00 00       	add    $0xa8,%eax
801038c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801038ce:	00 
801038cf:	89 04 24             	mov    %eax,(%esp)
801038d2:	e8 df fe ff ff       	call   801037b6 <xchg>
  scheduler();     // start running processes
801038d7:	e8 e1 11 00 00       	call   80104abd <scheduler>

801038dc <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801038dc:	55                   	push   %ebp
801038dd:	89 e5                	mov    %esp,%ebp
801038df:	53                   	push   %ebx
801038e0:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801038e3:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
801038ea:	e8 ba fe ff ff       	call   801037a9 <p2v>
801038ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801038f2:	b8 8a 00 00 00       	mov    $0x8a,%eax
801038f7:	89 44 24 08          	mov    %eax,0x8(%esp)
801038fb:	c7 44 24 04 5c c5 10 	movl   $0x8010c55c,0x4(%esp)
80103902:	80 
80103903:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103906:	89 04 24             	mov    %eax,(%esp)
80103909:	e8 99 1d 00 00       	call   801056a7 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010390e:	c7 45 f4 c0 33 11 80 	movl   $0x801133c0,-0xc(%ebp)
80103915:	e9 85 00 00 00       	jmp    8010399f <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
8010391a:	e8 1c f6 ff ff       	call   80102f3b <cpunum>
8010391f:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103925:	05 c0 33 11 80       	add    $0x801133c0,%eax
8010392a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010392d:	75 02                	jne    80103931 <startothers+0x55>
      continue;
8010392f:	eb 67                	jmp    80103998 <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103931:	e8 6f f2 ff ff       	call   80102ba5 <kalloc>
80103936:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103939:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010393c:	83 e8 04             	sub    $0x4,%eax
8010393f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103942:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103948:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010394a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010394d:	83 e8 08             	sub    $0x8,%eax
80103950:	c7 00 7b 38 10 80    	movl   $0x8010387b,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103956:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103959:	8d 58 f4             	lea    -0xc(%eax),%ebx
8010395c:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
80103963:	e8 34 fe ff ff       	call   8010379c <v2p>
80103968:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
8010396a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010396d:	89 04 24             	mov    %eax,(%esp)
80103970:	e8 27 fe ff ff       	call   8010379c <v2p>
80103975:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103978:	0f b6 12             	movzbl (%edx),%edx
8010397b:	0f b6 d2             	movzbl %dl,%edx
8010397e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103982:	89 14 24             	mov    %edx,(%esp)
80103985:	e8 33 f6 ff ff       	call   80102fbd <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010398a:	90                   	nop
8010398b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010398e:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103994:	85 c0                	test   %eax,%eax
80103996:	74 f3                	je     8010398b <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103998:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
8010399f:	a1 a0 39 11 80       	mov    0x801139a0,%eax
801039a4:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039aa:	05 c0 33 11 80       	add    $0x801133c0,%eax
801039af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039b2:	0f 87 62 ff ff ff    	ja     8010391a <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801039b8:	83 c4 24             	add    $0x24,%esp
801039bb:	5b                   	pop    %ebx
801039bc:	5d                   	pop    %ebp
801039bd:	c3                   	ret    

801039be <p2v>:
801039be:	55                   	push   %ebp
801039bf:	89 e5                	mov    %esp,%ebp
801039c1:	8b 45 08             	mov    0x8(%ebp),%eax
801039c4:	05 00 00 00 80       	add    $0x80000000,%eax
801039c9:	5d                   	pop    %ebp
801039ca:	c3                   	ret    

801039cb <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801039cb:	55                   	push   %ebp
801039cc:	89 e5                	mov    %esp,%ebp
801039ce:	83 ec 14             	sub    $0x14,%esp
801039d1:	8b 45 08             	mov    0x8(%ebp),%eax
801039d4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039d8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801039dc:	89 c2                	mov    %eax,%edx
801039de:	ec                   	in     (%dx),%al
801039df:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801039e2:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801039e6:	c9                   	leave  
801039e7:	c3                   	ret    

801039e8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801039e8:	55                   	push   %ebp
801039e9:	89 e5                	mov    %esp,%ebp
801039eb:	83 ec 08             	sub    $0x8,%esp
801039ee:	8b 55 08             	mov    0x8(%ebp),%edx
801039f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801039f4:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801039f8:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039fb:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801039ff:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a03:	ee                   	out    %al,(%dx)
}
80103a04:	c9                   	leave  
80103a05:	c3                   	ret    

80103a06 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103a06:	55                   	push   %ebp
80103a07:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103a09:	a1 a4 c6 10 80       	mov    0x8010c6a4,%eax
80103a0e:	89 c2                	mov    %eax,%edx
80103a10:	b8 c0 33 11 80       	mov    $0x801133c0,%eax
80103a15:	29 c2                	sub    %eax,%edx
80103a17:	89 d0                	mov    %edx,%eax
80103a19:	c1 f8 02             	sar    $0x2,%eax
80103a1c:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103a22:	5d                   	pop    %ebp
80103a23:	c3                   	ret    

80103a24 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103a24:	55                   	push   %ebp
80103a25:	89 e5                	mov    %esp,%ebp
80103a27:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a2a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a38:	eb 15                	jmp    80103a4f <sum+0x2b>
    sum += addr[i];
80103a3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a3d:	8b 45 08             	mov    0x8(%ebp),%eax
80103a40:	01 d0                	add    %edx,%eax
80103a42:	0f b6 00             	movzbl (%eax),%eax
80103a45:	0f b6 c0             	movzbl %al,%eax
80103a48:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103a4b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103a4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a52:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a55:	7c e3                	jl     80103a3a <sum+0x16>
    sum += addr[i];
  return sum;
80103a57:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103a5a:	c9                   	leave  
80103a5b:	c3                   	ret    

80103a5c <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a5c:	55                   	push   %ebp
80103a5d:	89 e5                	mov    %esp,%ebp
80103a5f:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103a62:	8b 45 08             	mov    0x8(%ebp),%eax
80103a65:	89 04 24             	mov    %eax,(%esp)
80103a68:	e8 51 ff ff ff       	call   801039be <p2v>
80103a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103a70:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a76:	01 d0                	add    %edx,%eax
80103a78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103a81:	eb 3f                	jmp    80103ac2 <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a83:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103a8a:	00 
80103a8b:	c7 44 24 04 14 8e 10 	movl   $0x80108e14,0x4(%esp)
80103a92:	80 
80103a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a96:	89 04 24             	mov    %eax,(%esp)
80103a99:	e8 b1 1b 00 00       	call   8010564f <memcmp>
80103a9e:	85 c0                	test   %eax,%eax
80103aa0:	75 1c                	jne    80103abe <mpsearch1+0x62>
80103aa2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103aa9:	00 
80103aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aad:	89 04 24             	mov    %eax,(%esp)
80103ab0:	e8 6f ff ff ff       	call   80103a24 <sum>
80103ab5:	84 c0                	test   %al,%al
80103ab7:	75 05                	jne    80103abe <mpsearch1+0x62>
      return (struct mp*)p;
80103ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103abc:	eb 11                	jmp    80103acf <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103abe:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ac5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ac8:	72 b9                	jb     80103a83 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103aca:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103acf:	c9                   	leave  
80103ad0:	c3                   	ret    

80103ad1 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103ad1:	55                   	push   %ebp
80103ad2:	89 e5                	mov    %esp,%ebp
80103ad4:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103ad7:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae1:	83 c0 0f             	add    $0xf,%eax
80103ae4:	0f b6 00             	movzbl (%eax),%eax
80103ae7:	0f b6 c0             	movzbl %al,%eax
80103aea:	c1 e0 08             	shl    $0x8,%eax
80103aed:	89 c2                	mov    %eax,%edx
80103aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103af2:	83 c0 0e             	add    $0xe,%eax
80103af5:	0f b6 00             	movzbl (%eax),%eax
80103af8:	0f b6 c0             	movzbl %al,%eax
80103afb:	09 d0                	or     %edx,%eax
80103afd:	c1 e0 04             	shl    $0x4,%eax
80103b00:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b07:	74 21                	je     80103b2a <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b09:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103b10:	00 
80103b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b14:	89 04 24             	mov    %eax,(%esp)
80103b17:	e8 40 ff ff ff       	call   80103a5c <mpsearch1>
80103b1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b23:	74 50                	je     80103b75 <mpsearch+0xa4>
      return mp;
80103b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b28:	eb 5f                	jmp    80103b89 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b2d:	83 c0 14             	add    $0x14,%eax
80103b30:	0f b6 00             	movzbl (%eax),%eax
80103b33:	0f b6 c0             	movzbl %al,%eax
80103b36:	c1 e0 08             	shl    $0x8,%eax
80103b39:	89 c2                	mov    %eax,%edx
80103b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b3e:	83 c0 13             	add    $0x13,%eax
80103b41:	0f b6 00             	movzbl (%eax),%eax
80103b44:	0f b6 c0             	movzbl %al,%eax
80103b47:	09 d0                	or     %edx,%eax
80103b49:	c1 e0 0a             	shl    $0xa,%eax
80103b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b52:	2d 00 04 00 00       	sub    $0x400,%eax
80103b57:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103b5e:	00 
80103b5f:	89 04 24             	mov    %eax,(%esp)
80103b62:	e8 f5 fe ff ff       	call   80103a5c <mpsearch1>
80103b67:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b6e:	74 05                	je     80103b75 <mpsearch+0xa4>
      return mp;
80103b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b73:	eb 14                	jmp    80103b89 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103b75:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103b7c:	00 
80103b7d:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103b84:	e8 d3 fe ff ff       	call   80103a5c <mpsearch1>
}
80103b89:	c9                   	leave  
80103b8a:	c3                   	ret    

80103b8b <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103b8b:	55                   	push   %ebp
80103b8c:	89 e5                	mov    %esp,%ebp
80103b8e:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b91:	e8 3b ff ff ff       	call   80103ad1 <mpsearch>
80103b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b9d:	74 0a                	je     80103ba9 <mpconfig+0x1e>
80103b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ba2:	8b 40 04             	mov    0x4(%eax),%eax
80103ba5:	85 c0                	test   %eax,%eax
80103ba7:	75 0a                	jne    80103bb3 <mpconfig+0x28>
    return 0;
80103ba9:	b8 00 00 00 00       	mov    $0x0,%eax
80103bae:	e9 83 00 00 00       	jmp    80103c36 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb6:	8b 40 04             	mov    0x4(%eax),%eax
80103bb9:	89 04 24             	mov    %eax,(%esp)
80103bbc:	e8 fd fd ff ff       	call   801039be <p2v>
80103bc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103bc4:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103bcb:	00 
80103bcc:	c7 44 24 04 19 8e 10 	movl   $0x80108e19,0x4(%esp)
80103bd3:	80 
80103bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bd7:	89 04 24             	mov    %eax,(%esp)
80103bda:	e8 70 1a 00 00       	call   8010564f <memcmp>
80103bdf:	85 c0                	test   %eax,%eax
80103be1:	74 07                	je     80103bea <mpconfig+0x5f>
    return 0;
80103be3:	b8 00 00 00 00       	mov    $0x0,%eax
80103be8:	eb 4c                	jmp    80103c36 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bed:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103bf1:	3c 01                	cmp    $0x1,%al
80103bf3:	74 12                	je     80103c07 <mpconfig+0x7c>
80103bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bf8:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103bfc:	3c 04                	cmp    $0x4,%al
80103bfe:	74 07                	je     80103c07 <mpconfig+0x7c>
    return 0;
80103c00:	b8 00 00 00 00       	mov    $0x0,%eax
80103c05:	eb 2f                	jmp    80103c36 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c0a:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c0e:	0f b7 c0             	movzwl %ax,%eax
80103c11:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c18:	89 04 24             	mov    %eax,(%esp)
80103c1b:	e8 04 fe ff ff       	call   80103a24 <sum>
80103c20:	84 c0                	test   %al,%al
80103c22:	74 07                	je     80103c2b <mpconfig+0xa0>
    return 0;
80103c24:	b8 00 00 00 00       	mov    $0x0,%eax
80103c29:	eb 0b                	jmp    80103c36 <mpconfig+0xab>
  *pmp = mp;
80103c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c31:	89 10                	mov    %edx,(%eax)
  return conf;
80103c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c36:	c9                   	leave  
80103c37:	c3                   	ret    

80103c38 <mpinit>:

void
mpinit(void)
{
80103c38:	55                   	push   %ebp
80103c39:	89 e5                	mov    %esp,%ebp
80103c3b:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103c3e:	c7 05 a4 c6 10 80 c0 	movl   $0x801133c0,0x8010c6a4
80103c45:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103c48:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103c4b:	89 04 24             	mov    %eax,(%esp)
80103c4e:	e8 38 ff ff ff       	call   80103b8b <mpconfig>
80103c53:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c5a:	75 05                	jne    80103c61 <mpinit+0x29>
    return;
80103c5c:	e9 9c 01 00 00       	jmp    80103dfd <mpinit+0x1c5>
  ismp = 1;
80103c61:	c7 05 a4 33 11 80 01 	movl   $0x1,0x801133a4
80103c68:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c6e:	8b 40 24             	mov    0x24(%eax),%eax
80103c71:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c79:	83 c0 2c             	add    $0x2c,%eax
80103c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c82:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c86:	0f b7 d0             	movzwl %ax,%edx
80103c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c8c:	01 d0                	add    %edx,%eax
80103c8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c91:	e9 f4 00 00 00       	jmp    80103d8a <mpinit+0x152>
    switch(*p){
80103c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c99:	0f b6 00             	movzbl (%eax),%eax
80103c9c:	0f b6 c0             	movzbl %al,%eax
80103c9f:	83 f8 04             	cmp    $0x4,%eax
80103ca2:	0f 87 bf 00 00 00    	ja     80103d67 <mpinit+0x12f>
80103ca8:	8b 04 85 5c 8e 10 80 	mov    -0x7fef71a4(,%eax,4),%eax
80103caf:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103cb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cba:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cbe:	0f b6 d0             	movzbl %al,%edx
80103cc1:	a1 a0 39 11 80       	mov    0x801139a0,%eax
80103cc6:	39 c2                	cmp    %eax,%edx
80103cc8:	74 2d                	je     80103cf7 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103cca:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103ccd:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cd1:	0f b6 d0             	movzbl %al,%edx
80103cd4:	a1 a0 39 11 80       	mov    0x801139a0,%eax
80103cd9:	89 54 24 08          	mov    %edx,0x8(%esp)
80103cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ce1:	c7 04 24 1e 8e 10 80 	movl   $0x80108e1e,(%esp)
80103ce8:	e8 b3 c6 ff ff       	call   801003a0 <cprintf>
        ismp = 0;
80103ced:	c7 05 a4 33 11 80 00 	movl   $0x0,0x801133a4
80103cf4:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103cf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cfa:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103cfe:	0f b6 c0             	movzbl %al,%eax
80103d01:	83 e0 02             	and    $0x2,%eax
80103d04:	85 c0                	test   %eax,%eax
80103d06:	74 15                	je     80103d1d <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103d08:	a1 a0 39 11 80       	mov    0x801139a0,%eax
80103d0d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d13:	05 c0 33 11 80       	add    $0x801133c0,%eax
80103d18:	a3 a4 c6 10 80       	mov    %eax,0x8010c6a4
      cpus[ncpu].id = ncpu;
80103d1d:	8b 15 a0 39 11 80    	mov    0x801139a0,%edx
80103d23:	a1 a0 39 11 80       	mov    0x801139a0,%eax
80103d28:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103d2e:	81 c2 c0 33 11 80    	add    $0x801133c0,%edx
80103d34:	88 02                	mov    %al,(%edx)
      ncpu++;
80103d36:	a1 a0 39 11 80       	mov    0x801139a0,%eax
80103d3b:	83 c0 01             	add    $0x1,%eax
80103d3e:	a3 a0 39 11 80       	mov    %eax,0x801139a0
      p += sizeof(struct mpproc);
80103d43:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103d47:	eb 41                	jmp    80103d8a <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103d4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d52:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d56:	a2 a0 33 11 80       	mov    %al,0x801133a0
      p += sizeof(struct mpioapic);
80103d5b:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d5f:	eb 29                	jmp    80103d8a <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d61:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d65:	eb 23                	jmp    80103d8a <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d6a:	0f b6 00             	movzbl (%eax),%eax
80103d6d:	0f b6 c0             	movzbl %al,%eax
80103d70:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d74:	c7 04 24 3c 8e 10 80 	movl   $0x80108e3c,(%esp)
80103d7b:	e8 20 c6 ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103d80:	c7 05 a4 33 11 80 00 	movl   $0x0,0x801133a4
80103d87:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d8d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103d90:	0f 82 00 ff ff ff    	jb     80103c96 <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103d96:	a1 a4 33 11 80       	mov    0x801133a4,%eax
80103d9b:	85 c0                	test   %eax,%eax
80103d9d:	75 1d                	jne    80103dbc <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103d9f:	c7 05 a0 39 11 80 01 	movl   $0x1,0x801139a0
80103da6:	00 00 00 
    lapic = 0;
80103da9:	c7 05 bc 32 11 80 00 	movl   $0x0,0x801132bc
80103db0:	00 00 00 
    ioapicid = 0;
80103db3:	c6 05 a0 33 11 80 00 	movb   $0x0,0x801133a0
    return;
80103dba:	eb 41                	jmp    80103dfd <mpinit+0x1c5>
  }

  if(mp->imcrp){
80103dbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103dbf:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103dc3:	84 c0                	test   %al,%al
80103dc5:	74 36                	je     80103dfd <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103dc7:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103dce:	00 
80103dcf:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103dd6:	e8 0d fc ff ff       	call   801039e8 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103ddb:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103de2:	e8 e4 fb ff ff       	call   801039cb <inb>
80103de7:	83 c8 01             	or     $0x1,%eax
80103dea:	0f b6 c0             	movzbl %al,%eax
80103ded:	89 44 24 04          	mov    %eax,0x4(%esp)
80103df1:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103df8:	e8 eb fb ff ff       	call   801039e8 <outb>
  }
}
80103dfd:	c9                   	leave  
80103dfe:	c3                   	ret    

80103dff <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103dff:	55                   	push   %ebp
80103e00:	89 e5                	mov    %esp,%ebp
80103e02:	83 ec 08             	sub    $0x8,%esp
80103e05:	8b 55 08             	mov    0x8(%ebp),%edx
80103e08:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e0b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e0f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e12:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e16:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e1a:	ee                   	out    %al,(%dx)
}
80103e1b:	c9                   	leave  
80103e1c:	c3                   	ret    

80103e1d <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103e1d:	55                   	push   %ebp
80103e1e:	89 e5                	mov    %esp,%ebp
80103e20:	83 ec 0c             	sub    $0xc,%esp
80103e23:	8b 45 08             	mov    0x8(%ebp),%eax
80103e26:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e2a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e2e:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103e34:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e38:	0f b6 c0             	movzbl %al,%eax
80103e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e3f:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e46:	e8 b4 ff ff ff       	call   80103dff <outb>
  outb(IO_PIC2+1, mask >> 8);
80103e4b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e4f:	66 c1 e8 08          	shr    $0x8,%ax
80103e53:	0f b6 c0             	movzbl %al,%eax
80103e56:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e5a:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e61:	e8 99 ff ff ff       	call   80103dff <outb>
}
80103e66:	c9                   	leave  
80103e67:	c3                   	ret    

80103e68 <picenable>:

void
picenable(int irq)
{
80103e68:	55                   	push   %ebp
80103e69:	89 e5                	mov    %esp,%ebp
80103e6b:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103e6e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e71:	ba 01 00 00 00       	mov    $0x1,%edx
80103e76:	89 c1                	mov    %eax,%ecx
80103e78:	d3 e2                	shl    %cl,%edx
80103e7a:	89 d0                	mov    %edx,%eax
80103e7c:	f7 d0                	not    %eax
80103e7e:	89 c2                	mov    %eax,%edx
80103e80:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103e87:	21 d0                	and    %edx,%eax
80103e89:	0f b7 c0             	movzwl %ax,%eax
80103e8c:	89 04 24             	mov    %eax,(%esp)
80103e8f:	e8 89 ff ff ff       	call   80103e1d <picsetmask>
}
80103e94:	c9                   	leave  
80103e95:	c3                   	ret    

80103e96 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103e96:	55                   	push   %ebp
80103e97:	89 e5                	mov    %esp,%ebp
80103e99:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103e9c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103ea3:	00 
80103ea4:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103eab:	e8 4f ff ff ff       	call   80103dff <outb>
  outb(IO_PIC2+1, 0xFF);
80103eb0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103eb7:	00 
80103eb8:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ebf:	e8 3b ff ff ff       	call   80103dff <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103ec4:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103ecb:	00 
80103ecc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ed3:	e8 27 ff ff ff       	call   80103dff <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103ed8:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103edf:	00 
80103ee0:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ee7:	e8 13 ff ff ff       	call   80103dff <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103eec:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103ef3:	00 
80103ef4:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103efb:	e8 ff fe ff ff       	call   80103dff <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103f00:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103f07:	00 
80103f08:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103f0f:	e8 eb fe ff ff       	call   80103dff <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103f14:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103f1b:	00 
80103f1c:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f23:	e8 d7 fe ff ff       	call   80103dff <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f28:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103f2f:	00 
80103f30:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f37:	e8 c3 fe ff ff       	call   80103dff <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f3c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103f43:	00 
80103f44:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f4b:	e8 af fe ff ff       	call   80103dff <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103f50:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103f57:	00 
80103f58:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f5f:	e8 9b fe ff ff       	call   80103dff <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f64:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103f6b:	00 
80103f6c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103f73:	e8 87 fe ff ff       	call   80103dff <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103f78:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103f7f:	00 
80103f80:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103f87:	e8 73 fe ff ff       	call   80103dff <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103f8c:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103f93:	00 
80103f94:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f9b:	e8 5f fe ff ff       	call   80103dff <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103fa0:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103fa7:	00 
80103fa8:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103faf:	e8 4b fe ff ff       	call   80103dff <outb>

  if(irqmask != 0xFFFF)
80103fb4:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103fbb:	66 83 f8 ff          	cmp    $0xffff,%ax
80103fbf:	74 12                	je     80103fd3 <picinit+0x13d>
    picsetmask(irqmask);
80103fc1:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103fc8:	0f b7 c0             	movzwl %ax,%eax
80103fcb:	89 04 24             	mov    %eax,(%esp)
80103fce:	e8 4a fe ff ff       	call   80103e1d <picsetmask>
}
80103fd3:	c9                   	leave  
80103fd4:	c3                   	ret    

80103fd5 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103fd5:	55                   	push   %ebp
80103fd6:	89 e5                	mov    %esp,%ebp
80103fd8:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103fdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fe5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103feb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fee:	8b 10                	mov    (%eax),%edx
80103ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff3:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103ff5:	e8 54 cf ff ff       	call   80100f4e <filealloc>
80103ffa:	8b 55 08             	mov    0x8(%ebp),%edx
80103ffd:	89 02                	mov    %eax,(%edx)
80103fff:	8b 45 08             	mov    0x8(%ebp),%eax
80104002:	8b 00                	mov    (%eax),%eax
80104004:	85 c0                	test   %eax,%eax
80104006:	0f 84 c8 00 00 00    	je     801040d4 <pipealloc+0xff>
8010400c:	e8 3d cf ff ff       	call   80100f4e <filealloc>
80104011:	8b 55 0c             	mov    0xc(%ebp),%edx
80104014:	89 02                	mov    %eax,(%edx)
80104016:	8b 45 0c             	mov    0xc(%ebp),%eax
80104019:	8b 00                	mov    (%eax),%eax
8010401b:	85 c0                	test   %eax,%eax
8010401d:	0f 84 b1 00 00 00    	je     801040d4 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104023:	e8 7d eb ff ff       	call   80102ba5 <kalloc>
80104028:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010402b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010402f:	75 05                	jne    80104036 <pipealloc+0x61>
    goto bad;
80104031:	e9 9e 00 00 00       	jmp    801040d4 <pipealloc+0xff>
  p->readopen = 1;
80104036:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104039:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104040:	00 00 00 
  p->writeopen = 1;
80104043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104046:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010404d:	00 00 00 
  p->nwrite = 0;
80104050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104053:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010405a:	00 00 00 
  p->nread = 0;
8010405d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104060:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104067:	00 00 00 
  initlock(&p->lock, "pipe");
8010406a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406d:	c7 44 24 04 70 8e 10 	movl   $0x80108e70,0x4(%esp)
80104074:	80 
80104075:	89 04 24             	mov    %eax,(%esp)
80104078:	e8 e6 12 00 00       	call   80105363 <initlock>
  (*f0)->type = FD_PIPE;
8010407d:	8b 45 08             	mov    0x8(%ebp),%eax
80104080:	8b 00                	mov    (%eax),%eax
80104082:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104088:	8b 45 08             	mov    0x8(%ebp),%eax
8010408b:	8b 00                	mov    (%eax),%eax
8010408d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104091:	8b 45 08             	mov    0x8(%ebp),%eax
80104094:	8b 00                	mov    (%eax),%eax
80104096:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010409a:	8b 45 08             	mov    0x8(%ebp),%eax
8010409d:	8b 00                	mov    (%eax),%eax
8010409f:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040a2:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801040a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801040a8:	8b 00                	mov    (%eax),%eax
801040aa:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801040b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801040b3:	8b 00                	mov    (%eax),%eax
801040b5:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801040b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801040bc:	8b 00                	mov    (%eax),%eax
801040be:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c5:	8b 00                	mov    (%eax),%eax
801040c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040ca:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801040cd:	b8 00 00 00 00       	mov    $0x0,%eax
801040d2:	eb 42                	jmp    80104116 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
801040d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040d8:	74 0b                	je     801040e5 <pipealloc+0x110>
    kfree((char*)p);
801040da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040dd:	89 04 24             	mov    %eax,(%esp)
801040e0:	e8 27 ea ff ff       	call   80102b0c <kfree>
  if(*f0)
801040e5:	8b 45 08             	mov    0x8(%ebp),%eax
801040e8:	8b 00                	mov    (%eax),%eax
801040ea:	85 c0                	test   %eax,%eax
801040ec:	74 0d                	je     801040fb <pipealloc+0x126>
    fileclose(*f0);
801040ee:	8b 45 08             	mov    0x8(%ebp),%eax
801040f1:	8b 00                	mov    (%eax),%eax
801040f3:	89 04 24             	mov    %eax,(%esp)
801040f6:	e8 fb ce ff ff       	call   80100ff6 <fileclose>
  if(*f1)
801040fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801040fe:	8b 00                	mov    (%eax),%eax
80104100:	85 c0                	test   %eax,%eax
80104102:	74 0d                	je     80104111 <pipealloc+0x13c>
    fileclose(*f1);
80104104:	8b 45 0c             	mov    0xc(%ebp),%eax
80104107:	8b 00                	mov    (%eax),%eax
80104109:	89 04 24             	mov    %eax,(%esp)
8010410c:	e8 e5 ce ff ff       	call   80100ff6 <fileclose>
  return -1;
80104111:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104116:	c9                   	leave  
80104117:	c3                   	ret    

80104118 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104118:	55                   	push   %ebp
80104119:	89 e5                	mov    %esp,%ebp
8010411b:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
8010411e:	8b 45 08             	mov    0x8(%ebp),%eax
80104121:	89 04 24             	mov    %eax,(%esp)
80104124:	e8 5b 12 00 00       	call   80105384 <acquire>
  if(writable){
80104129:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010412d:	74 1f                	je     8010414e <pipeclose+0x36>
    p->writeopen = 0;
8010412f:	8b 45 08             	mov    0x8(%ebp),%eax
80104132:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104139:	00 00 00 
    wakeup(&p->nread);
8010413c:	8b 45 08             	mov    0x8(%ebp),%eax
8010413f:	05 34 02 00 00       	add    $0x234,%eax
80104144:	89 04 24             	mov    %eax,(%esp)
80104147:	e8 21 0d 00 00       	call   80104e6d <wakeup>
8010414c:	eb 1d                	jmp    8010416b <pipeclose+0x53>
  } else {
    p->readopen = 0;
8010414e:	8b 45 08             	mov    0x8(%ebp),%eax
80104151:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104158:	00 00 00 
    wakeup(&p->nwrite);
8010415b:	8b 45 08             	mov    0x8(%ebp),%eax
8010415e:	05 38 02 00 00       	add    $0x238,%eax
80104163:	89 04 24             	mov    %eax,(%esp)
80104166:	e8 02 0d 00 00       	call   80104e6d <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010416b:	8b 45 08             	mov    0x8(%ebp),%eax
8010416e:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104174:	85 c0                	test   %eax,%eax
80104176:	75 25                	jne    8010419d <pipeclose+0x85>
80104178:	8b 45 08             	mov    0x8(%ebp),%eax
8010417b:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104181:	85 c0                	test   %eax,%eax
80104183:	75 18                	jne    8010419d <pipeclose+0x85>
    release(&p->lock);
80104185:	8b 45 08             	mov    0x8(%ebp),%eax
80104188:	89 04 24             	mov    %eax,(%esp)
8010418b:	e8 56 12 00 00       	call   801053e6 <release>
    kfree((char*)p);
80104190:	8b 45 08             	mov    0x8(%ebp),%eax
80104193:	89 04 24             	mov    %eax,(%esp)
80104196:	e8 71 e9 ff ff       	call   80102b0c <kfree>
8010419b:	eb 0b                	jmp    801041a8 <pipeclose+0x90>
  } else
    release(&p->lock);
8010419d:	8b 45 08             	mov    0x8(%ebp),%eax
801041a0:	89 04 24             	mov    %eax,(%esp)
801041a3:	e8 3e 12 00 00       	call   801053e6 <release>
}
801041a8:	c9                   	leave  
801041a9:	c3                   	ret    

801041aa <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801041aa:	55                   	push   %ebp
801041ab:	89 e5                	mov    %esp,%ebp
801041ad:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
801041b0:	8b 45 08             	mov    0x8(%ebp),%eax
801041b3:	89 04 24             	mov    %eax,(%esp)
801041b6:	e8 c9 11 00 00       	call   80105384 <acquire>
  for(i = 0; i < n; i++){
801041bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041c2:	e9 a6 00 00 00       	jmp    8010426d <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801041c7:	eb 57                	jmp    80104220 <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
801041c9:	8b 45 08             	mov    0x8(%ebp),%eax
801041cc:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041d2:	85 c0                	test   %eax,%eax
801041d4:	74 0d                	je     801041e3 <pipewrite+0x39>
801041d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041dc:	8b 40 24             	mov    0x24(%eax),%eax
801041df:	85 c0                	test   %eax,%eax
801041e1:	74 15                	je     801041f8 <pipewrite+0x4e>
        release(&p->lock);
801041e3:	8b 45 08             	mov    0x8(%ebp),%eax
801041e6:	89 04 24             	mov    %eax,(%esp)
801041e9:	e8 f8 11 00 00       	call   801053e6 <release>
        return -1;
801041ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041f3:	e9 9f 00 00 00       	jmp    80104297 <pipewrite+0xed>
      }
      wakeup(&p->nread);
801041f8:	8b 45 08             	mov    0x8(%ebp),%eax
801041fb:	05 34 02 00 00       	add    $0x234,%eax
80104200:	89 04 24             	mov    %eax,(%esp)
80104203:	e8 65 0c 00 00       	call   80104e6d <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104208:	8b 45 08             	mov    0x8(%ebp),%eax
8010420b:	8b 55 08             	mov    0x8(%ebp),%edx
8010420e:	81 c2 38 02 00 00    	add    $0x238,%edx
80104214:	89 44 24 04          	mov    %eax,0x4(%esp)
80104218:	89 14 24             	mov    %edx,(%esp)
8010421b:	e8 74 0b 00 00       	call   80104d94 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104220:	8b 45 08             	mov    0x8(%ebp),%eax
80104223:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104229:	8b 45 08             	mov    0x8(%ebp),%eax
8010422c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104232:	05 00 02 00 00       	add    $0x200,%eax
80104237:	39 c2                	cmp    %eax,%edx
80104239:	74 8e                	je     801041c9 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010423b:	8b 45 08             	mov    0x8(%ebp),%eax
8010423e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104244:	8d 48 01             	lea    0x1(%eax),%ecx
80104247:	8b 55 08             	mov    0x8(%ebp),%edx
8010424a:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104250:	25 ff 01 00 00       	and    $0x1ff,%eax
80104255:	89 c1                	mov    %eax,%ecx
80104257:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010425a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010425d:	01 d0                	add    %edx,%eax
8010425f:	0f b6 10             	movzbl (%eax),%edx
80104262:	8b 45 08             	mov    0x8(%ebp),%eax
80104265:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104269:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010426d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104270:	3b 45 10             	cmp    0x10(%ebp),%eax
80104273:	0f 8c 4e ff ff ff    	jl     801041c7 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104279:	8b 45 08             	mov    0x8(%ebp),%eax
8010427c:	05 34 02 00 00       	add    $0x234,%eax
80104281:	89 04 24             	mov    %eax,(%esp)
80104284:	e8 e4 0b 00 00       	call   80104e6d <wakeup>
  release(&p->lock);
80104289:	8b 45 08             	mov    0x8(%ebp),%eax
8010428c:	89 04 24             	mov    %eax,(%esp)
8010428f:	e8 52 11 00 00       	call   801053e6 <release>
  return n;
80104294:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104297:	c9                   	leave  
80104298:	c3                   	ret    

80104299 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104299:	55                   	push   %ebp
8010429a:	89 e5                	mov    %esp,%ebp
8010429c:	53                   	push   %ebx
8010429d:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
801042a0:	8b 45 08             	mov    0x8(%ebp),%eax
801042a3:	89 04 24             	mov    %eax,(%esp)
801042a6:	e8 d9 10 00 00       	call   80105384 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042ab:	eb 3a                	jmp    801042e7 <piperead+0x4e>
    if(proc->killed){
801042ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042b3:	8b 40 24             	mov    0x24(%eax),%eax
801042b6:	85 c0                	test   %eax,%eax
801042b8:	74 15                	je     801042cf <piperead+0x36>
      release(&p->lock);
801042ba:	8b 45 08             	mov    0x8(%ebp),%eax
801042bd:	89 04 24             	mov    %eax,(%esp)
801042c0:	e8 21 11 00 00       	call   801053e6 <release>
      return -1;
801042c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042ca:	e9 b5 00 00 00       	jmp    80104384 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801042cf:	8b 45 08             	mov    0x8(%ebp),%eax
801042d2:	8b 55 08             	mov    0x8(%ebp),%edx
801042d5:	81 c2 34 02 00 00    	add    $0x234,%edx
801042db:	89 44 24 04          	mov    %eax,0x4(%esp)
801042df:	89 14 24             	mov    %edx,(%esp)
801042e2:	e8 ad 0a 00 00       	call   80104d94 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042e7:	8b 45 08             	mov    0x8(%ebp),%eax
801042ea:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801042f0:	8b 45 08             	mov    0x8(%ebp),%eax
801042f3:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042f9:	39 c2                	cmp    %eax,%edx
801042fb:	75 0d                	jne    8010430a <piperead+0x71>
801042fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104300:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104306:	85 c0                	test   %eax,%eax
80104308:	75 a3                	jne    801042ad <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010430a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104311:	eb 4b                	jmp    8010435e <piperead+0xc5>
    if(p->nread == p->nwrite)
80104313:	8b 45 08             	mov    0x8(%ebp),%eax
80104316:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010431c:	8b 45 08             	mov    0x8(%ebp),%eax
8010431f:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104325:	39 c2                	cmp    %eax,%edx
80104327:	75 02                	jne    8010432b <piperead+0x92>
      break;
80104329:	eb 3b                	jmp    80104366 <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010432b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010432e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104331:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104334:	8b 45 08             	mov    0x8(%ebp),%eax
80104337:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010433d:	8d 48 01             	lea    0x1(%eax),%ecx
80104340:	8b 55 08             	mov    0x8(%ebp),%edx
80104343:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104349:	25 ff 01 00 00       	and    $0x1ff,%eax
8010434e:	89 c2                	mov    %eax,%edx
80104350:	8b 45 08             	mov    0x8(%ebp),%eax
80104353:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104358:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010435a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010435e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104361:	3b 45 10             	cmp    0x10(%ebp),%eax
80104364:	7c ad                	jl     80104313 <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104366:	8b 45 08             	mov    0x8(%ebp),%eax
80104369:	05 38 02 00 00       	add    $0x238,%eax
8010436e:	89 04 24             	mov    %eax,(%esp)
80104371:	e8 f7 0a 00 00       	call   80104e6d <wakeup>
  release(&p->lock);
80104376:	8b 45 08             	mov    0x8(%ebp),%eax
80104379:	89 04 24             	mov    %eax,(%esp)
8010437c:	e8 65 10 00 00       	call   801053e6 <release>
  return i;
80104381:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104384:	83 c4 24             	add    $0x24,%esp
80104387:	5b                   	pop    %ebx
80104388:	5d                   	pop    %ebp
80104389:	c3                   	ret    

8010438a <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010438a:	55                   	push   %ebp
8010438b:	89 e5                	mov    %esp,%ebp
8010438d:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104390:	9c                   	pushf  
80104391:	58                   	pop    %eax
80104392:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104395:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104398:	c9                   	leave  
80104399:	c3                   	ret    

8010439a <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010439a:	55                   	push   %ebp
8010439b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010439d:	fb                   	sti    
}
8010439e:	5d                   	pop    %ebp
8010439f:	c3                   	ret    

801043a0 <hlt>:

static inline void
hlt(void)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
801043a3:	f4                   	hlt    
}
801043a4:	5d                   	pop    %ebp
801043a5:	c3                   	ret    

801043a6 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801043a6:	55                   	push   %ebp
801043a7:	89 e5                	mov    %esp,%ebp
801043a9:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801043ac:	c7 44 24 04 78 8e 10 	movl   $0x80108e78,0x4(%esp)
801043b3:	80 
801043b4:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
801043bb:	e8 a3 0f 00 00       	call   80105363 <initlock>
}
801043c0:	c9                   	leave  
801043c1:	c3                   	ret    

801043c2 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801043c2:	55                   	push   %ebp
801043c3:	89 e5                	mov    %esp,%ebp
801043c5:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801043c8:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
801043cf:	e8 b0 0f 00 00       	call   80105384 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043d4:	c7 45 f4 f4 39 11 80 	movl   $0x801139f4,-0xc(%ebp)
801043db:	eb 5a                	jmp    80104437 <allocproc+0x75>
    if(p->state == UNUSED)
801043dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e0:	8b 40 0c             	mov    0xc(%eax),%eax
801043e3:	85 c0                	test   %eax,%eax
801043e5:	75 4c                	jne    80104433 <allocproc+0x71>
      goto found;
801043e7:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801043e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043eb:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801043f2:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801043f7:	8d 50 01             	lea    0x1(%eax),%edx
801043fa:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
80104400:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104403:	89 42 10             	mov    %eax,0x10(%edx)

  //Adding the default priority
  p->priority = 10;
80104406:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104409:	c7 40 7c 0a 00 00 00 	movl   $0xa,0x7c(%eax)

  release(&ptable.lock);
80104410:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104417:	e8 ca 0f 00 00       	call   801053e6 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010441c:	e8 84 e7 ff ff       	call   80102ba5 <kalloc>
80104421:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104424:	89 42 08             	mov    %eax,0x8(%edx)
80104427:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010442a:	8b 40 08             	mov    0x8(%eax),%eax
8010442d:	85 c0                	test   %eax,%eax
8010442f:	75 33                	jne    80104464 <allocproc+0xa2>
80104431:	eb 20                	jmp    80104453 <allocproc+0x91>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104433:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104437:	81 7d f4 f4 59 11 80 	cmpl   $0x801159f4,-0xc(%ebp)
8010443e:	72 9d                	jb     801043dd <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104440:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104447:	e8 9a 0f 00 00       	call   801053e6 <release>
  return 0;
8010444c:	b8 00 00 00 00       	mov    $0x0,%eax
80104451:	eb 76                	jmp    801044c9 <allocproc+0x107>

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80104453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104456:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010445d:	b8 00 00 00 00       	mov    $0x0,%eax
80104462:	eb 65                	jmp    801044c9 <allocproc+0x107>
  }
  sp = p->kstack + KSTACKSIZE;
80104464:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104467:	8b 40 08             	mov    0x8(%eax),%eax
8010446a:	05 00 10 00 00       	add    $0x1000,%eax
8010446f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104472:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104476:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104479:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010447c:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010447f:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104483:	ba b2 6a 10 80       	mov    $0x80106ab2,%edx
80104488:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010448b:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010448d:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104491:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104494:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104497:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010449a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010449d:	8b 40 1c             	mov    0x1c(%eax),%eax
801044a0:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801044a7:	00 
801044a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801044af:	00 
801044b0:	89 04 24             	mov    %eax,(%esp)
801044b3:	e8 20 11 00 00       	call   801055d8 <memset>
  p->context->eip = (uint)forkret;
801044b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044bb:	8b 40 1c             	mov    0x1c(%eax),%eax
801044be:	ba 55 4d 10 80       	mov    $0x80104d55,%edx
801044c3:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801044c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044c9:	c9                   	leave  
801044ca:	c3                   	ret    

801044cb <numtickets>:
//Since lower the value, higher the actual priority,
//I'm calculating num of ticks as 2^(20-nice/priority) 
//Hence lower the nice value, higher the number of tickets. 
uint
numtickets(int priority)
{
801044cb:	55                   	push   %ebp
801044cc:	89 e5                	mov    %esp,%ebp
801044ce:	83 ec 10             	sub    $0x10,%esp
  int n = 20-priority;
801044d1:	b8 14 00 00 00       	mov    $0x14,%eax
801044d6:	2b 45 08             	sub    0x8(%ebp),%eax
801044d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int tickets = 1;
801044dc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
  int i;
  for (i = 0; i < n; i++) {
801044e3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801044ea:	eb 07                	jmp    801044f3 <numtickets+0x28>
    tickets = tickets * 2;
801044ec:	d1 65 fc             	shll   -0x4(%ebp)
numtickets(int priority)
{
  int n = 20-priority;
  int tickets = 1;
  int i;
  for (i = 0; i < n; i++) {
801044ef:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801044f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801044f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801044f9:	7c f1                	jl     801044ec <numtickets+0x21>
    tickets = tickets * 2;
  }
  return tickets;
801044fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801044fe:	c9                   	leave  
801044ff:	c3                   	ret    

80104500 <totaltickets>:

//Calculating total available tickets
uint
totaltickets(void)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  uint total = 0;
80104506:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010450d:	c7 45 fc f4 39 11 80 	movl   $0x801139f4,-0x4(%ebp)
80104514:	eb 28                	jmp    8010453e <totaltickets+0x3e>
    if(p->state != RUNNABLE)
80104516:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104519:	8b 40 0c             	mov    0xc(%eax),%eax
8010451c:	83 f8 03             	cmp    $0x3,%eax
8010451f:	74 02                	je     80104523 <totaltickets+0x23>
      continue;
80104521:	eb 17                	jmp    8010453a <totaltickets+0x3a>
      int nice = p->priority;
80104523:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104526:	8b 40 7c             	mov    0x7c(%eax),%eax
80104529:	89 45 f4             	mov    %eax,-0xc(%ebp)
      total += numtickets(nice);
8010452c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010452f:	89 04 24             	mov    %eax,(%esp)
80104532:	e8 94 ff ff ff       	call   801044cb <numtickets>
80104537:	01 45 f8             	add    %eax,-0x8(%ebp)
totaltickets(void)
{
  struct proc *p;
  uint total = 0;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010453a:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
8010453e:	81 7d fc f4 59 11 80 	cmpl   $0x801159f4,-0x4(%ebp)
80104545:	72 cf                	jb     80104516 <totaltickets+0x16>
      continue;
      int nice = p->priority;
      total += numtickets(nice);
      //printf("%d numtickets: %d\n", p->pid, numtickets(nice));
  }
  return total;
80104547:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010454a:	c9                   	leave  
8010454b:	c3                   	ret    

8010454c <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010454c:	55                   	push   %ebp
8010454d:	89 e5                	mov    %esp,%ebp
8010454f:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104552:	e8 6b fe ff ff       	call   801043c2 <allocproc>
80104557:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010455a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455d:	a3 a8 c6 10 80       	mov    %eax,0x8010c6a8
  if((p->pgdir = setupkvm()) == 0)
80104562:	e8 3f 3c 00 00       	call   801081a6 <setupkvm>
80104567:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010456a:	89 42 04             	mov    %eax,0x4(%edx)
8010456d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104570:	8b 40 04             	mov    0x4(%eax),%eax
80104573:	85 c0                	test   %eax,%eax
80104575:	75 0c                	jne    80104583 <userinit+0x37>
    panic("userinit: out of memory?");
80104577:	c7 04 24 7f 8e 10 80 	movl   $0x80108e7f,(%esp)
8010457e:	e8 b7 bf ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104583:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104588:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458b:	8b 40 04             	mov    0x4(%eax),%eax
8010458e:	89 54 24 08          	mov    %edx,0x8(%esp)
80104592:	c7 44 24 04 30 c5 10 	movl   $0x8010c530,0x4(%esp)
80104599:	80 
8010459a:	89 04 24             	mov    %eax,(%esp)
8010459d:	e8 5c 3e 00 00       	call   801083fe <inituvm>
  p->sz = PGSIZE;
801045a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a5:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801045ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ae:	8b 40 18             	mov    0x18(%eax),%eax
801045b1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801045b8:	00 
801045b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801045c0:	00 
801045c1:	89 04 24             	mov    %eax,(%esp)
801045c4:	e8 0f 10 00 00       	call   801055d8 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801045c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045cc:	8b 40 18             	mov    0x18(%eax),%eax
801045cf:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801045d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d8:	8b 40 18             	mov    0x18(%eax),%eax
801045db:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801045e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e4:	8b 40 18             	mov    0x18(%eax),%eax
801045e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045ea:	8b 52 18             	mov    0x18(%edx),%edx
801045ed:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045f1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801045f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f8:	8b 40 18             	mov    0x18(%eax),%eax
801045fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045fe:	8b 52 18             	mov    0x18(%edx),%edx
80104601:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104605:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104609:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460c:	8b 40 18             	mov    0x18(%eax),%eax
8010460f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104616:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104619:	8b 40 18             	mov    0x18(%eax),%eax
8010461c:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104623:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104626:	8b 40 18             	mov    0x18(%eax),%eax
80104629:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104630:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104633:	83 c0 6c             	add    $0x6c,%eax
80104636:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010463d:	00 
8010463e:	c7 44 24 04 98 8e 10 	movl   $0x80108e98,0x4(%esp)
80104645:	80 
80104646:	89 04 24             	mov    %eax,(%esp)
80104649:	e8 aa 11 00 00       	call   801057f8 <safestrcpy>
  p->cwd = namei("/");
8010464e:	c7 04 24 a1 8e 10 80 	movl   $0x80108ea1,(%esp)
80104655:	e8 38 de ff ff       	call   80102492 <namei>
8010465a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010465d:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
80104660:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104663:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
8010466a:	c9                   	leave  
8010466b:	c3                   	ret    

8010466c <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010466c:	55                   	push   %ebp
8010466d:	89 e5                	mov    %esp,%ebp
8010466f:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
80104672:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104678:	8b 00                	mov    (%eax),%eax
8010467a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010467d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104681:	7e 34                	jle    801046b7 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104683:	8b 55 08             	mov    0x8(%ebp),%edx
80104686:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104689:	01 c2                	add    %eax,%edx
8010468b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104691:	8b 40 04             	mov    0x4(%eax),%eax
80104694:	89 54 24 08          	mov    %edx,0x8(%esp)
80104698:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010469b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010469f:	89 04 24             	mov    %eax,(%esp)
801046a2:	e8 cd 3e 00 00       	call   80108574 <allocuvm>
801046a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801046ae:	75 41                	jne    801046f1 <growproc+0x85>
      return -1;
801046b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046b5:	eb 58                	jmp    8010470f <growproc+0xa3>
  } else if(n < 0){
801046b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801046bb:	79 34                	jns    801046f1 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801046bd:	8b 55 08             	mov    0x8(%ebp),%edx
801046c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c3:	01 c2                	add    %eax,%edx
801046c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046cb:	8b 40 04             	mov    0x4(%eax),%eax
801046ce:	89 54 24 08          	mov    %edx,0x8(%esp)
801046d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046d5:	89 54 24 04          	mov    %edx,0x4(%esp)
801046d9:	89 04 24             	mov    %eax,(%esp)
801046dc:	e8 6d 3f 00 00       	call   8010864e <deallocuvm>
801046e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801046e8:	75 07                	jne    801046f1 <growproc+0x85>
      return -1;
801046ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046ef:	eb 1e                	jmp    8010470f <growproc+0xa3>
  }
  proc->sz = sz;
801046f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046fa:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801046fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104702:	89 04 24             	mov    %eax,(%esp)
80104705:	e8 8d 3b 00 00       	call   80108297 <switchuvm>
  return 0;
8010470a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010470f:	c9                   	leave  
80104710:	c3                   	ret    

80104711 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104711:	55                   	push   %ebp
80104712:	89 e5                	mov    %esp,%ebp
80104714:	57                   	push   %edi
80104715:	56                   	push   %esi
80104716:	53                   	push   %ebx
80104717:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010471a:	e8 a3 fc ff ff       	call   801043c2 <allocproc>
8010471f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104722:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104726:	75 0a                	jne    80104732 <fork+0x21>
    return -1;
80104728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010472d:	e9 52 01 00 00       	jmp    80104884 <fork+0x173>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104732:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104738:	8b 10                	mov    (%eax),%edx
8010473a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104740:	8b 40 04             	mov    0x4(%eax),%eax
80104743:	89 54 24 04          	mov    %edx,0x4(%esp)
80104747:	89 04 24             	mov    %eax,(%esp)
8010474a:	e8 9b 40 00 00       	call   801087ea <copyuvm>
8010474f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104752:	89 42 04             	mov    %eax,0x4(%edx)
80104755:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104758:	8b 40 04             	mov    0x4(%eax),%eax
8010475b:	85 c0                	test   %eax,%eax
8010475d:	75 2c                	jne    8010478b <fork+0x7a>
    kfree(np->kstack);
8010475f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104762:	8b 40 08             	mov    0x8(%eax),%eax
80104765:	89 04 24             	mov    %eax,(%esp)
80104768:	e8 9f e3 ff ff       	call   80102b0c <kfree>
    np->kstack = 0;
8010476d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104770:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104777:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010477a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104781:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104786:	e9 f9 00 00 00       	jmp    80104884 <fork+0x173>
  }
  np->sz = proc->sz;
8010478b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104791:	8b 10                	mov    (%eax),%edx
80104793:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104796:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104798:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010479f:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047a2:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801047a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047a8:	8b 50 18             	mov    0x18(%eax),%edx
801047ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047b1:	8b 40 18             	mov    0x18(%eax),%eax
801047b4:	89 c3                	mov    %eax,%ebx
801047b6:	b8 13 00 00 00       	mov    $0x13,%eax
801047bb:	89 d7                	mov    %edx,%edi
801047bd:	89 de                	mov    %ebx,%esi
801047bf:	89 c1                	mov    %eax,%ecx
801047c1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801047c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047c6:	8b 40 18             	mov    0x18(%eax),%eax
801047c9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801047d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801047d7:	eb 3d                	jmp    80104816 <fork+0x105>
    if(proc->ofile[i])
801047d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047e2:	83 c2 08             	add    $0x8,%edx
801047e5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047e9:	85 c0                	test   %eax,%eax
801047eb:	74 25                	je     80104812 <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
801047ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047f6:	83 c2 08             	add    $0x8,%edx
801047f9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047fd:	89 04 24             	mov    %eax,(%esp)
80104800:	e8 a9 c7 ff ff       	call   80100fae <filedup>
80104805:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104808:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010480b:	83 c1 08             	add    $0x8,%ecx
8010480e:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104812:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104816:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010481a:	7e bd                	jle    801047d9 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
8010481c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104822:	8b 40 68             	mov    0x68(%eax),%eax
80104825:	89 04 24             	mov    %eax,(%esp)
80104828:	e8 82 d0 ff ff       	call   801018af <idup>
8010482d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104830:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104833:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104839:	8d 50 6c             	lea    0x6c(%eax),%edx
8010483c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010483f:	83 c0 6c             	add    $0x6c,%eax
80104842:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104849:	00 
8010484a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010484e:	89 04 24             	mov    %eax,(%esp)
80104851:	e8 a2 0f 00 00       	call   801057f8 <safestrcpy>
 
  pid = np->pid;
80104856:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104859:	8b 40 10             	mov    0x10(%eax),%eax
8010485c:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
8010485f:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104866:	e8 19 0b 00 00       	call   80105384 <acquire>
  np->state = RUNNABLE;
8010486b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010486e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104875:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
8010487c:	e8 65 0b 00 00       	call   801053e6 <release>
  
  return pid;
80104881:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104884:	83 c4 2c             	add    $0x2c,%esp
80104887:	5b                   	pop    %ebx
80104888:	5e                   	pop    %esi
80104889:	5f                   	pop    %edi
8010488a:	5d                   	pop    %ebp
8010488b:	c3                   	ret    

8010488c <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010488c:	55                   	push   %ebp
8010488d:	89 e5                	mov    %esp,%ebp
8010488f:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104892:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104899:	a1 a8 c6 10 80       	mov    0x8010c6a8,%eax
8010489e:	39 c2                	cmp    %eax,%edx
801048a0:	75 0c                	jne    801048ae <exit+0x22>
    panic("init exiting");
801048a2:	c7 04 24 a3 8e 10 80 	movl   $0x80108ea3,(%esp)
801048a9:	e8 8c bc ff ff       	call   8010053a <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801048b5:	eb 44                	jmp    801048fb <exit+0x6f>
    if(proc->ofile[fd]){
801048b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048c0:	83 c2 08             	add    $0x8,%edx
801048c3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048c7:	85 c0                	test   %eax,%eax
801048c9:	74 2c                	je     801048f7 <exit+0x6b>
      fileclose(proc->ofile[fd]);
801048cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048d4:	83 c2 08             	add    $0x8,%edx
801048d7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048db:	89 04 24             	mov    %eax,(%esp)
801048de:	e8 13 c7 ff ff       	call   80100ff6 <fileclose>
      proc->ofile[fd] = 0;
801048e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048ec:	83 c2 08             	add    $0x8,%edx
801048ef:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801048f6:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048f7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801048fb:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801048ff:	7e b6                	jle    801048b7 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104901:	e8 c3 eb ff ff       	call   801034c9 <begin_op>
  iput(proc->cwd);
80104906:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010490c:	8b 40 68             	mov    0x68(%eax),%eax
8010490f:	89 04 24             	mov    %eax,(%esp)
80104912:	e8 83 d1 ff ff       	call   80101a9a <iput>
  end_op();
80104917:	e8 31 ec ff ff       	call   8010354d <end_op>
  proc->cwd = 0;
8010491c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104922:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104929:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104930:	e8 4f 0a 00 00       	call   80105384 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104935:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010493b:	8b 40 14             	mov    0x14(%eax),%eax
8010493e:	89 04 24             	mov    %eax,(%esp)
80104941:	e8 e9 04 00 00       	call   80104e2f <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104946:	c7 45 f4 f4 39 11 80 	movl   $0x801139f4,-0xc(%ebp)
8010494d:	eb 38                	jmp    80104987 <exit+0xfb>
    if(p->parent == proc){
8010494f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104952:	8b 50 14             	mov    0x14(%eax),%edx
80104955:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010495b:	39 c2                	cmp    %eax,%edx
8010495d:	75 24                	jne    80104983 <exit+0xf7>
      p->parent = initproc;
8010495f:	8b 15 a8 c6 10 80    	mov    0x8010c6a8,%edx
80104965:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104968:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010496b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010496e:	8b 40 0c             	mov    0xc(%eax),%eax
80104971:	83 f8 05             	cmp    $0x5,%eax
80104974:	75 0d                	jne    80104983 <exit+0xf7>
        wakeup1(initproc);
80104976:	a1 a8 c6 10 80       	mov    0x8010c6a8,%eax
8010497b:	89 04 24             	mov    %eax,(%esp)
8010497e:	e8 ac 04 00 00       	call   80104e2f <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104983:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104987:	81 7d f4 f4 59 11 80 	cmpl   $0x801159f4,-0xc(%ebp)
8010498e:	72 bf                	jb     8010494f <exit+0xc3>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104990:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104996:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010499d:	e8 cf 02 00 00       	call   80104c71 <sched>
  panic("zombie exit");
801049a2:	c7 04 24 b0 8e 10 80 	movl   $0x80108eb0,(%esp)
801049a9:	e8 8c bb ff ff       	call   8010053a <panic>

801049ae <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801049ae:	55                   	push   %ebp
801049af:	89 e5                	mov    %esp,%ebp
801049b1:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801049b4:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
801049bb:	e8 c4 09 00 00       	call   80105384 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801049c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049c7:	c7 45 f4 f4 39 11 80 	movl   $0x801139f4,-0xc(%ebp)
801049ce:	e9 9a 00 00 00       	jmp    80104a6d <wait+0xbf>
      if(p->parent != proc)
801049d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d6:	8b 50 14             	mov    0x14(%eax),%edx
801049d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049df:	39 c2                	cmp    %eax,%edx
801049e1:	74 05                	je     801049e8 <wait+0x3a>
        continue;
801049e3:	e9 81 00 00 00       	jmp    80104a69 <wait+0xbb>
      havekids = 1;
801049e8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801049ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f2:	8b 40 0c             	mov    0xc(%eax),%eax
801049f5:	83 f8 05             	cmp    $0x5,%eax
801049f8:	75 6f                	jne    80104a69 <wait+0xbb>
        // Found one.
        pid = p->pid;
801049fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049fd:	8b 40 10             	mov    0x10(%eax),%eax
80104a00:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a06:	8b 40 08             	mov    0x8(%eax),%eax
80104a09:	89 04 24             	mov    %eax,(%esp)
80104a0c:	e8 fb e0 ff ff       	call   80102b0c <kfree>
        p->kstack = 0;
80104a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a14:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a1e:	8b 40 04             	mov    0x4(%eax),%eax
80104a21:	89 04 24             	mov    %eax,(%esp)
80104a24:	e8 e1 3c 00 00       	call   8010870a <freevm>
        p->state = UNUSED;
80104a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a2c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a36:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a40:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a4a:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a51:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104a58:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104a5f:	e8 82 09 00 00       	call   801053e6 <release>
        return pid;
80104a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a67:	eb 52                	jmp    80104abb <wait+0x10d>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a69:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104a6d:	81 7d f4 f4 59 11 80 	cmpl   $0x801159f4,-0xc(%ebp)
80104a74:	0f 82 59 ff ff ff    	jb     801049d3 <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104a7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a7e:	74 0d                	je     80104a8d <wait+0xdf>
80104a80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a86:	8b 40 24             	mov    0x24(%eax),%eax
80104a89:	85 c0                	test   %eax,%eax
80104a8b:	74 13                	je     80104aa0 <wait+0xf2>
      release(&ptable.lock);
80104a8d:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104a94:	e8 4d 09 00 00       	call   801053e6 <release>
      return -1;
80104a99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a9e:	eb 1b                	jmp    80104abb <wait+0x10d>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104aa0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aa6:	c7 44 24 04 c0 39 11 	movl   $0x801139c0,0x4(%esp)
80104aad:	80 
80104aae:	89 04 24             	mov    %eax,(%esp)
80104ab1:	e8 de 02 00 00       	call   80104d94 <sleep>
  }
80104ab6:	e9 05 ff ff ff       	jmp    801049c0 <wait+0x12>
}
80104abb:	c9                   	leave  
80104abc:	c3                   	ret    

80104abd <scheduler>:
//  - eventually that process transfers control
//      via swtch back to the scheduler.

void
scheduler(void)
{
80104abd:	55                   	push   %ebp
80104abe:	89 e5                	mov    %esp,%ebp
80104ac0:	83 ec 38             	sub    $0x38,%esp
  struct proc *p;
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104ac3:	e8 d2 f8 ff ff       	call   8010439a <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104ac8:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104acf:	e8 b0 08 00 00       	call   80105384 <acquire>

    // get total number of tickets by iterating through every process
    uint total = totaltickets();
80104ad4:	e8 27 fa ff ff       	call   80104500 <totaltickets>
80104ad9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (total == 0) {
80104adc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80104ae0:	75 0f                	jne    80104af1 <scheduler+0x34>
      release(&ptable.lock);
80104ae2:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104ae9:	e8 f8 08 00 00       	call   801053e6 <release>
      continue;
80104aee:	90                   	nop
      // It should have changed its p->state before coming back.
      proc = 0;
      break;
    }
    release(&ptable.lock);
  }  
80104aef:	eb d2                	jmp    80104ac3 <scheduler+0x6>
      continue;
    }
    //cprintf("total tickets: %d\n", total);

    // hold lottery
    uint counter = 0; // used to track if we've found the winner yet
80104af1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    uint winner = randomgenrange(1, (int) total);
80104af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104afb:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b06:	e8 12 07 00 00       	call   8010521d <randomgenrange>
80104b0b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    //cprintf("winner ticket: %d\n", winner);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b0e:	c7 45 f4 f4 39 11 80 	movl   $0x801139f4,-0xc(%ebp)
80104b15:	e9 81 00 00 00       	jmp    80104b9b <scheduler+0xde>
      if(p->state != RUNNABLE)
80104b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1d:	8b 40 0c             	mov    0xc(%eax),%eax
80104b20:	83 f8 03             	cmp    $0x3,%eax
80104b23:	74 02                	je     80104b27 <scheduler+0x6a>
        continue;
80104b25:	eb 70                	jmp    80104b97 <scheduler+0xda>

      int priority = p->priority;
80104b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b2a:	8b 40 7c             	mov    0x7c(%eax),%eax
80104b2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      counter += numtickets(priority);
80104b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104b33:	89 04 24             	mov    %eax,(%esp)
80104b36:	e8 90 f9 ff ff       	call   801044cb <numtickets>
80104b3b:	01 45 f0             	add    %eax,-0x10(%ebp)
      if (counter < winner)
80104b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b41:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80104b44:	73 02                	jae    80104b48 <scheduler+0x8b>
        continue;
80104b46:	eb 4f                	jmp    80104b97 <scheduler+0xda>
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b4b:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4

      switchuvm(p);
80104b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b54:	89 04 24             	mov    %eax,(%esp)
80104b57:	e8 3b 37 00 00       	call   80108297 <switchuvm>
      p->state = RUNNING;
80104b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b5f:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&cpu->scheduler, proc->context);
80104b66:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b6c:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b6f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104b76:	83 c2 04             	add    $0x4,%edx
80104b79:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b7d:	89 14 24             	mov    %edx,(%esp)
80104b80:	e8 e4 0c 00 00       	call   80105869 <swtch>
      switchkvm();
80104b85:	e8 f0 36 00 00       	call   8010827a <switchkvm>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104b8a:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104b91:	00 00 00 00 
      break;
80104b95:	eb 11                	jmp    80104ba8 <scheduler+0xeb>
    // hold lottery
    uint counter = 0; // used to track if we've found the winner yet
    uint winner = randomgenrange(1, (int) total);
    //cprintf("winner ticket: %d\n", winner);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b97:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104b9b:	81 7d f4 f4 59 11 80 	cmpl   $0x801159f4,-0xc(%ebp)
80104ba2:	0f 82 72 ff ff ff    	jb     80104b1a <scheduler+0x5d>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
      break;
    }
    release(&ptable.lock);
80104ba8:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104baf:	e8 32 08 00 00       	call   801053e6 <release>
  }  
80104bb4:	e9 0a ff ff ff       	jmp    80104ac3 <scheduler+0x6>

80104bb9 <scheduler_ROUNDROBIN>:
}

void
scheduler_ROUNDROBIN(void)
{
80104bb9:	55                   	push   %ebp
80104bba:	89 e5                	mov    %esp,%ebp
80104bbc:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int foundproc = 1;
80104bbf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104bc6:	e8 cf f7 ff ff       	call   8010439a <sti>

    if (!foundproc) hlt();
80104bcb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104bcf:	75 05                	jne    80104bd6 <scheduler_ROUNDROBIN+0x1d>
80104bd1:	e8 ca f7 ff ff       	call   801043a0 <hlt>

    foundproc = 0;
80104bd6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104bdd:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104be4:	e8 9b 07 00 00       	call   80105384 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104be9:	c7 45 f4 f4 39 11 80 	movl   $0x801139f4,-0xc(%ebp)
80104bf0:	eb 65                	jmp    80104c57 <scheduler_ROUNDROBIN+0x9e>
      if(p->state != RUNNABLE)
80104bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bf5:	8b 40 0c             	mov    0xc(%eax),%eax
80104bf8:	83 f8 03             	cmp    $0x3,%eax
80104bfb:	74 02                	je     80104bff <scheduler_ROUNDROBIN+0x46>
        continue;
80104bfd:	eb 54                	jmp    80104c53 <scheduler_ROUNDROBIN+0x9a>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      foundproc = 1;
80104bff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      proc = p;
80104c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c09:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c12:	89 04 24             	mov    %eax,(%esp)
80104c15:	e8 7d 36 00 00       	call   80108297 <switchuvm>
      p->state = RUNNING;
80104c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c1d:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104c24:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c2a:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c2d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c34:	83 c2 04             	add    $0x4,%edx
80104c37:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c3b:	89 14 24             	mov    %edx,(%esp)
80104c3e:	e8 26 0c 00 00       	call   80105869 <swtch>
      switchkvm();
80104c43:	e8 32 36 00 00       	call   8010827a <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104c48:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104c4f:	00 00 00 00 

    foundproc = 0;

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c53:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104c57:	81 7d f4 f4 59 11 80 	cmpl   $0x801159f4,-0xc(%ebp)
80104c5e:	72 92                	jb     80104bf2 <scheduler_ROUNDROBIN+0x39>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104c60:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104c67:	e8 7a 07 00 00       	call   801053e6 <release>

  }
80104c6c:	e9 55 ff ff ff       	jmp    80104bc6 <scheduler_ROUNDROBIN+0xd>

80104c71 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104c71:	55                   	push   %ebp
80104c72:	89 e5                	mov    %esp,%ebp
80104c74:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104c77:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104c7e:	e8 2b 08 00 00       	call   801054ae <holding>
80104c83:	85 c0                	test   %eax,%eax
80104c85:	75 0c                	jne    80104c93 <sched+0x22>
    panic("sched ptable.lock");
80104c87:	c7 04 24 bc 8e 10 80 	movl   $0x80108ebc,(%esp)
80104c8e:	e8 a7 b8 ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
80104c93:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c99:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104c9f:	83 f8 01             	cmp    $0x1,%eax
80104ca2:	74 0c                	je     80104cb0 <sched+0x3f>
    panic("sched locks");
80104ca4:	c7 04 24 ce 8e 10 80 	movl   $0x80108ece,(%esp)
80104cab:	e8 8a b8 ff ff       	call   8010053a <panic>
  if(proc->state == RUNNING)
80104cb0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cb6:	8b 40 0c             	mov    0xc(%eax),%eax
80104cb9:	83 f8 04             	cmp    $0x4,%eax
80104cbc:	75 0c                	jne    80104cca <sched+0x59>
    panic("sched running");
80104cbe:	c7 04 24 da 8e 10 80 	movl   $0x80108eda,(%esp)
80104cc5:	e8 70 b8 ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
80104cca:	e8 bb f6 ff ff       	call   8010438a <readeflags>
80104ccf:	25 00 02 00 00       	and    $0x200,%eax
80104cd4:	85 c0                	test   %eax,%eax
80104cd6:	74 0c                	je     80104ce4 <sched+0x73>
    panic("sched interruptible");
80104cd8:	c7 04 24 e8 8e 10 80 	movl   $0x80108ee8,(%esp)
80104cdf:	e8 56 b8 ff ff       	call   8010053a <panic>
  intena = cpu->intena;
80104ce4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cea:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104cf3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cf9:	8b 40 04             	mov    0x4(%eax),%eax
80104cfc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d03:	83 c2 1c             	add    $0x1c,%edx
80104d06:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d0a:	89 14 24             	mov    %edx,(%esp)
80104d0d:	e8 57 0b 00 00       	call   80105869 <swtch>
  cpu->intena = intena;
80104d12:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d18:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d1b:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104d21:	c9                   	leave  
80104d22:	c3                   	ret    

80104d23 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104d23:	55                   	push   %ebp
80104d24:	89 e5                	mov    %esp,%ebp
80104d26:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104d29:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104d30:	e8 4f 06 00 00       	call   80105384 <acquire>
  proc->state = RUNNABLE;
80104d35:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d3b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104d42:	e8 2a ff ff ff       	call   80104c71 <sched>
  release(&ptable.lock);
80104d47:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104d4e:	e8 93 06 00 00       	call   801053e6 <release>
}
80104d53:	c9                   	leave  
80104d54:	c3                   	ret    

80104d55 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104d55:	55                   	push   %ebp
80104d56:	89 e5                	mov    %esp,%ebp
80104d58:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104d5b:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104d62:	e8 7f 06 00 00       	call   801053e6 <release>

  if (first) {
80104d67:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104d6c:	85 c0                	test   %eax,%eax
80104d6e:	74 22                	je     80104d92 <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104d70:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104d77:	00 00 00 
    iinit(ROOTDEV);
80104d7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104d81:	e8 33 c8 ff ff       	call   801015b9 <iinit>
    initlog(ROOTDEV);
80104d86:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104d8d:	e8 33 e5 ff ff       	call   801032c5 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104d92:	c9                   	leave  
80104d93:	c3                   	ret    

80104d94 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104d94:	55                   	push   %ebp
80104d95:	89 e5                	mov    %esp,%ebp
80104d97:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104d9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104da0:	85 c0                	test   %eax,%eax
80104da2:	75 0c                	jne    80104db0 <sleep+0x1c>
    panic("sleep");
80104da4:	c7 04 24 fc 8e 10 80 	movl   $0x80108efc,(%esp)
80104dab:	e8 8a b7 ff ff       	call   8010053a <panic>

  if(lk == 0)
80104db0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104db4:	75 0c                	jne    80104dc2 <sleep+0x2e>
    panic("sleep without lk");
80104db6:	c7 04 24 02 8f 10 80 	movl   $0x80108f02,(%esp)
80104dbd:	e8 78 b7 ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104dc2:	81 7d 0c c0 39 11 80 	cmpl   $0x801139c0,0xc(%ebp)
80104dc9:	74 17                	je     80104de2 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104dcb:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104dd2:	e8 ad 05 00 00       	call   80105384 <acquire>
    release(lk);
80104dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dda:	89 04 24             	mov    %eax,(%esp)
80104ddd:	e8 04 06 00 00       	call   801053e6 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104de2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de8:	8b 55 08             	mov    0x8(%ebp),%edx
80104deb:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104dee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104df4:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104dfb:	e8 71 fe ff ff       	call   80104c71 <sched>

  // Tidy up.
  proc->chan = 0;
80104e00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e06:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104e0d:	81 7d 0c c0 39 11 80 	cmpl   $0x801139c0,0xc(%ebp)
80104e14:	74 17                	je     80104e2d <sleep+0x99>
    release(&ptable.lock);
80104e16:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104e1d:	e8 c4 05 00 00       	call   801053e6 <release>
    acquire(lk);
80104e22:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e25:	89 04 24             	mov    %eax,(%esp)
80104e28:	e8 57 05 00 00       	call   80105384 <acquire>
  }
}
80104e2d:	c9                   	leave  
80104e2e:	c3                   	ret    

80104e2f <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104e2f:	55                   	push   %ebp
80104e30:	89 e5                	mov    %esp,%ebp
80104e32:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e35:	c7 45 fc f4 39 11 80 	movl   $0x801139f4,-0x4(%ebp)
80104e3c:	eb 24                	jmp    80104e62 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104e3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e41:	8b 40 0c             	mov    0xc(%eax),%eax
80104e44:	83 f8 02             	cmp    $0x2,%eax
80104e47:	75 15                	jne    80104e5e <wakeup1+0x2f>
80104e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e4c:	8b 40 20             	mov    0x20(%eax),%eax
80104e4f:	3b 45 08             	cmp    0x8(%ebp),%eax
80104e52:	75 0a                	jne    80104e5e <wakeup1+0x2f>
      p->state = RUNNABLE;
80104e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e57:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e5e:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
80104e62:	81 7d fc f4 59 11 80 	cmpl   $0x801159f4,-0x4(%ebp)
80104e69:	72 d3                	jb     80104e3e <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104e6b:	c9                   	leave  
80104e6c:	c3                   	ret    

80104e6d <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104e6d:	55                   	push   %ebp
80104e6e:	89 e5                	mov    %esp,%ebp
80104e70:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104e73:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104e7a:	e8 05 05 00 00       	call   80105384 <acquire>
  wakeup1(chan);
80104e7f:	8b 45 08             	mov    0x8(%ebp),%eax
80104e82:	89 04 24             	mov    %eax,(%esp)
80104e85:	e8 a5 ff ff ff       	call   80104e2f <wakeup1>
  release(&ptable.lock);
80104e8a:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104e91:	e8 50 05 00 00       	call   801053e6 <release>
}
80104e96:	c9                   	leave  
80104e97:	c3                   	ret    

80104e98 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104e98:	55                   	push   %ebp
80104e99:	89 e5                	mov    %esp,%ebp
80104e9b:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104e9e:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104ea5:	e8 da 04 00 00       	call   80105384 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104eaa:	c7 45 f4 f4 39 11 80 	movl   $0x801139f4,-0xc(%ebp)
80104eb1:	eb 41                	jmp    80104ef4 <kill+0x5c>
    if(p->pid == pid){
80104eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb6:	8b 40 10             	mov    0x10(%eax),%eax
80104eb9:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ebc:	75 32                	jne    80104ef0 <kill+0x58>
      p->killed = 1;
80104ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec1:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ecb:	8b 40 0c             	mov    0xc(%eax),%eax
80104ece:	83 f8 02             	cmp    $0x2,%eax
80104ed1:	75 0a                	jne    80104edd <kill+0x45>
        p->state = RUNNABLE;
80104ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104edd:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104ee4:	e8 fd 04 00 00       	call   801053e6 <release>
      return 0;
80104ee9:	b8 00 00 00 00       	mov    $0x0,%eax
80104eee:	eb 1e                	jmp    80104f0e <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ef0:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104ef4:	81 7d f4 f4 59 11 80 	cmpl   $0x801159f4,-0xc(%ebp)
80104efb:	72 b6                	jb     80104eb3 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104efd:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80104f04:	e8 dd 04 00 00       	call   801053e6 <release>
  return -1;
80104f09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f0e:	c9                   	leave  
80104f0f:	c3                   	ret    

80104f10 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f16:	c7 45 f0 f4 39 11 80 	movl   $0x801139f4,-0x10(%ebp)
80104f1d:	e9 d6 00 00 00       	jmp    80104ff8 <procdump+0xe8>
    if(p->state == UNUSED)
80104f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f25:	8b 40 0c             	mov    0xc(%eax),%eax
80104f28:	85 c0                	test   %eax,%eax
80104f2a:	75 05                	jne    80104f31 <procdump+0x21>
      continue;
80104f2c:	e9 c3 00 00 00       	jmp    80104ff4 <procdump+0xe4>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f34:	8b 40 0c             	mov    0xc(%eax),%eax
80104f37:	83 f8 05             	cmp    $0x5,%eax
80104f3a:	77 23                	ja     80104f5f <procdump+0x4f>
80104f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f3f:	8b 40 0c             	mov    0xc(%eax),%eax
80104f42:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104f49:	85 c0                	test   %eax,%eax
80104f4b:	74 12                	je     80104f5f <procdump+0x4f>
      state = states[p->state];
80104f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f50:	8b 40 0c             	mov    0xc(%eax),%eax
80104f53:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104f5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104f5d:	eb 07                	jmp    80104f66 <procdump+0x56>
    else
      state = "???";
80104f5f:	c7 45 ec 13 8f 10 80 	movl   $0x80108f13,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f69:	8d 50 6c             	lea    0x6c(%eax),%edx
80104f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f6f:	8b 40 10             	mov    0x10(%eax),%eax
80104f72:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104f76:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104f79:	89 54 24 08          	mov    %edx,0x8(%esp)
80104f7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f81:	c7 04 24 17 8f 10 80 	movl   $0x80108f17,(%esp)
80104f88:	e8 13 b4 ff ff       	call   801003a0 <cprintf>
    if(p->state == SLEEPING){
80104f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f90:	8b 40 0c             	mov    0xc(%eax),%eax
80104f93:	83 f8 02             	cmp    $0x2,%eax
80104f96:	75 50                	jne    80104fe8 <procdump+0xd8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f9b:	8b 40 1c             	mov    0x1c(%eax),%eax
80104f9e:	8b 40 0c             	mov    0xc(%eax),%eax
80104fa1:	83 c0 08             	add    $0x8,%eax
80104fa4:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104fa7:	89 54 24 04          	mov    %edx,0x4(%esp)
80104fab:	89 04 24             	mov    %eax,(%esp)
80104fae:	e8 82 04 00 00       	call   80105435 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104fb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104fba:	eb 1b                	jmp    80104fd7 <procdump+0xc7>
        cprintf(" %p", pc[i]);
80104fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fbf:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104fc3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fc7:	c7 04 24 20 8f 10 80 	movl   $0x80108f20,(%esp)
80104fce:	e8 cd b3 ff ff       	call   801003a0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104fd3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104fd7:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104fdb:	7f 0b                	jg     80104fe8 <procdump+0xd8>
80104fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fe0:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104fe4:	85 c0                	test   %eax,%eax
80104fe6:	75 d4                	jne    80104fbc <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104fe8:	c7 04 24 24 8f 10 80 	movl   $0x80108f24,(%esp)
80104fef:	e8 ac b3 ff ff       	call   801003a0 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ff4:	83 6d f0 80          	subl   $0xffffff80,-0x10(%ebp)
80104ff8:	81 7d f0 f4 59 11 80 	cmpl   $0x801159f4,-0x10(%ebp)
80104fff:	0f 82 1d ff ff ff    	jb     80104f22 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105005:	c9                   	leave  
80105006:	c3                   	ret    

80105007 <changepriority>:

//Adding the definition for priority change
int 
changepriority(int pid, int priority)
{
80105007:	55                   	push   %ebp
80105008:	89 e5                	mov    %esp,%ebp
8010500a:	83 ec 28             	sub    $0x28,%esp
	struct proc *process;
	acquire(&ptable.lock);
8010500d:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80105014:	e8 6b 03 00 00       	call   80105384 <acquire>
	for(process = ptable.proc; process < &ptable.proc[NPROC]; process++){
80105019:	c7 45 f4 f4 39 11 80 	movl   $0x801139f4,-0xc(%ebp)
80105020:	eb 1a                	jmp    8010503c <changepriority+0x35>
	  if(process->pid == pid){
80105022:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105025:	8b 40 10             	mov    0x10(%eax),%eax
80105028:	3b 45 08             	cmp    0x8(%ebp),%eax
8010502b:	75 0b                	jne    80105038 <changepriority+0x31>
			process->priority = priority;
8010502d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105030:	8b 55 0c             	mov    0xc(%ebp),%edx
80105033:	89 50 7c             	mov    %edx,0x7c(%eax)
			break;
80105036:	eb 0d                	jmp    80105045 <changepriority+0x3e>
int 
changepriority(int pid, int priority)
{
	struct proc *process;
	acquire(&ptable.lock);
	for(process = ptable.proc; process < &ptable.proc[NPROC]; process++){
80105038:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
8010503c:	81 7d f4 f4 59 11 80 	cmpl   $0x801159f4,-0xc(%ebp)
80105043:	72 dd                	jb     80105022 <changepriority+0x1b>
	  if(process->pid == pid){
			process->priority = priority;
			break;
		}
	}
	release(&ptable.lock);
80105045:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
8010504c:	e8 95 03 00 00       	call   801053e6 <release>
	return pid;
80105051:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105054:	c9                   	leave  
80105055:	c3                   	ret    

80105056 <processstatus>:

//Adding the definition for process status
int
processstatus(void)
{
80105056:	55                   	push   %ebp
80105057:	89 e5                	mov    %esp,%ebp
80105059:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;
	
	//Enable interrupt on the processor
	sti();
8010505c:	e8 39 f3 ff ff       	call   8010439a <sti>

	//Looping over processes to match with the pid
	acquire(&ptable.lock);
80105061:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80105068:	e8 17 03 00 00       	call   80105384 <acquire>
	cprintf("Name \t PID \t State \t Priority \n");
8010506d:	c7 04 24 28 8f 10 80 	movl   $0x80108f28,(%esp)
80105074:	e8 27 b3 ff ff       	call   801003a0 <cprintf>
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105079:	c7 45 f4 f4 39 11 80 	movl   $0x801139f4,-0xc(%ebp)
80105080:	e9 a7 00 00 00       	jmp    8010512c <processstatus+0xd6>
		if(p->state == SLEEPING)
80105085:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105088:	8b 40 0c             	mov    0xc(%eax),%eax
8010508b:	83 f8 02             	cmp    $0x2,%eax
8010508e:	75 2c                	jne    801050bc <processstatus+0x66>
			cprintf("%s \t %d \t SLEEPING \t %d \n ", p->name,p->pid,p->priority);
80105090:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105093:	8b 50 7c             	mov    0x7c(%eax),%edx
80105096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105099:	8b 40 10             	mov    0x10(%eax),%eax
8010509c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010509f:	83 c1 6c             	add    $0x6c,%ecx
801050a2:	89 54 24 0c          	mov    %edx,0xc(%esp)
801050a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801050aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801050ae:	c7 04 24 48 8f 10 80 	movl   $0x80108f48,(%esp)
801050b5:	e8 e6 b2 ff ff       	call   801003a0 <cprintf>
801050ba:	eb 6c                	jmp    80105128 <processstatus+0xd2>
		  else if(p->state == RUNNING)
801050bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050bf:	8b 40 0c             	mov    0xc(%eax),%eax
801050c2:	83 f8 04             	cmp    $0x4,%eax
801050c5:	75 2c                	jne    801050f3 <processstatus+0x9d>
 	  	  	cprintf("%s \t %d \t RUNNING \t %d \n ", p->name,p->pid,p->priority);
801050c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ca:	8b 50 7c             	mov    0x7c(%eax),%edx
801050cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050d0:	8b 40 10             	mov    0x10(%eax),%eax
801050d3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801050d6:	83 c1 6c             	add    $0x6c,%ecx
801050d9:	89 54 24 0c          	mov    %edx,0xc(%esp)
801050dd:	89 44 24 08          	mov    %eax,0x8(%esp)
801050e1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801050e5:	c7 04 24 63 8f 10 80 	movl   $0x80108f63,(%esp)
801050ec:	e8 af b2 ff ff       	call   801003a0 <cprintf>
801050f1:	eb 35                	jmp    80105128 <processstatus+0xd2>
		  else if(p->state == RUNNABLE)
801050f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f6:	8b 40 0c             	mov    0xc(%eax),%eax
801050f9:	83 f8 03             	cmp    $0x3,%eax
801050fc:	75 2a                	jne    80105128 <processstatus+0xd2>
 	 	  	cprintf("%s \t %d \t RUNNABLE \t %d \n ", p->name,p->pid,p->priority);	
801050fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105101:	8b 50 7c             	mov    0x7c(%eax),%edx
80105104:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105107:	8b 40 10             	mov    0x10(%eax),%eax
8010510a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010510d:	83 c1 6c             	add    $0x6c,%ecx
80105110:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105114:	89 44 24 08          	mov    %eax,0x8(%esp)
80105118:	89 4c 24 04          	mov    %ecx,0x4(%esp)
8010511c:	c7 04 24 7d 8f 10 80 	movl   $0x80108f7d,(%esp)
80105123:	e8 78 b2 ff ff       	call   801003a0 <cprintf>
	sti();

	//Looping over processes to match with the pid
	acquire(&ptable.lock);
	cprintf("Name \t PID \t State \t Priority \n");
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105128:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
8010512c:	81 7d f4 f4 59 11 80 	cmpl   $0x801159f4,-0xc(%ebp)
80105133:	0f 82 4c ff ff ff    	jb     80105085 <processstatus+0x2f>
		  else if(p->state == RUNNING)
 	  	  	cprintf("%s \t %d \t RUNNING \t %d \n ", p->name,p->pid,p->priority);
		  else if(p->state == RUNNABLE)
 	 	  	cprintf("%s \t %d \t RUNNABLE \t %d \n ", p->name,p->pid,p->priority);	
	}
	release(&ptable.lock);
80105139:	c7 04 24 c0 39 11 80 	movl   $0x801139c0,(%esp)
80105140:	e8 a1 02 00 00       	call   801053e6 <release>
	return 23;
80105145:	b8 17 00 00 00       	mov    $0x17,%eax
}
8010514a:	c9                   	leave  
8010514b:	c3                   	ret    

8010514c <randomgen>:

uint
randomgen(void)
{
8010514c:	55                   	push   %ebp
8010514d:	89 e5                	mov    %esp,%ebp
8010514f:	83 ec 10             	sub    $0x10,%esp
  static unsigned int z1 = 12345, z2 = 12345, z3 = 12345, z4 = 12345;
  unsigned int b;
  b  = ((z1 << 6) ^ z1) >> 13;
80105152:	a1 24 c0 10 80       	mov    0x8010c024,%eax
80105157:	c1 e0 06             	shl    $0x6,%eax
8010515a:	89 c2                	mov    %eax,%edx
8010515c:	a1 24 c0 10 80       	mov    0x8010c024,%eax
80105161:	31 d0                	xor    %edx,%eax
80105163:	c1 e8 0d             	shr    $0xd,%eax
80105166:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z1 = ((z1 & 4294967294U) << 18) ^ b;
80105169:	a1 24 c0 10 80       	mov    0x8010c024,%eax
8010516e:	83 e0 fe             	and    $0xfffffffe,%eax
80105171:	c1 e0 12             	shl    $0x12,%eax
80105174:	33 45 fc             	xor    -0x4(%ebp),%eax
80105177:	a3 24 c0 10 80       	mov    %eax,0x8010c024
  b  = ((z2 << 2) ^ z2) >> 27; 
8010517c:	a1 28 c0 10 80       	mov    0x8010c028,%eax
80105181:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105188:	a1 28 c0 10 80       	mov    0x8010c028,%eax
8010518d:	31 d0                	xor    %edx,%eax
8010518f:	c1 e8 1b             	shr    $0x1b,%eax
80105192:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z2 = ((z2 & 4294967288U) << 2) ^ b;
80105195:	a1 28 c0 10 80       	mov    0x8010c028,%eax
8010519a:	83 e0 f8             	and    $0xfffffff8,%eax
8010519d:	c1 e0 02             	shl    $0x2,%eax
801051a0:	33 45 fc             	xor    -0x4(%ebp),%eax
801051a3:	a3 28 c0 10 80       	mov    %eax,0x8010c028
  b  = ((z3 << 13) ^ z3) >> 21;
801051a8:	a1 2c c0 10 80       	mov    0x8010c02c,%eax
801051ad:	c1 e0 0d             	shl    $0xd,%eax
801051b0:	89 c2                	mov    %eax,%edx
801051b2:	a1 2c c0 10 80       	mov    0x8010c02c,%eax
801051b7:	31 d0                	xor    %edx,%eax
801051b9:	c1 e8 15             	shr    $0x15,%eax
801051bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z3 = ((z3 & 4294967280U) << 7) ^ b;
801051bf:	a1 2c c0 10 80       	mov    0x8010c02c,%eax
801051c4:	83 e0 f0             	and    $0xfffffff0,%eax
801051c7:	c1 e0 07             	shl    $0x7,%eax
801051ca:	33 45 fc             	xor    -0x4(%ebp),%eax
801051cd:	a3 2c c0 10 80       	mov    %eax,0x8010c02c
  b  = ((z4 << 3) ^ z4) >> 12;
801051d2:	a1 30 c0 10 80       	mov    0x8010c030,%eax
801051d7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801051de:	a1 30 c0 10 80       	mov    0x8010c030,%eax
801051e3:	31 d0                	xor    %edx,%eax
801051e5:	c1 e8 0c             	shr    $0xc,%eax
801051e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z4 = ((z4 & 4294967168U) << 13) ^ b;
801051eb:	a1 30 c0 10 80       	mov    0x8010c030,%eax
801051f0:	83 e0 80             	and    $0xffffff80,%eax
801051f3:	c1 e0 0d             	shl    $0xd,%eax
801051f6:	33 45 fc             	xor    -0x4(%ebp),%eax
801051f9:	a3 30 c0 10 80       	mov    %eax,0x8010c030

  return (z1 ^ z2 ^ z3 ^ z4) / 2;
801051fe:	8b 15 24 c0 10 80    	mov    0x8010c024,%edx
80105204:	a1 28 c0 10 80       	mov    0x8010c028,%eax
80105209:	31 c2                	xor    %eax,%edx
8010520b:	a1 2c c0 10 80       	mov    0x8010c02c,%eax
80105210:	31 c2                	xor    %eax,%edx
80105212:	a1 30 c0 10 80       	mov    0x8010c030,%eax
80105217:	31 d0                	xor    %edx,%eax
80105219:	d1 e8                	shr    %eax
}
8010521b:	c9                   	leave  
8010521c:	c3                   	ret    

8010521d <randomgenrange>:

int
randomgenrange(int low, int high)
{
8010521d:	55                   	push   %ebp
8010521e:	89 e5                	mov    %esp,%ebp
80105220:	83 ec 10             	sub    $0x10,%esp
  static unsigned int z1 = 12345, z2 = 12345, z3 = 12345, z4 = 12345;
  unsigned int b;
  b  = ((z1 << 6) ^ z1) >> 13;
80105223:	a1 34 c0 10 80       	mov    0x8010c034,%eax
80105228:	c1 e0 06             	shl    $0x6,%eax
8010522b:	89 c2                	mov    %eax,%edx
8010522d:	a1 34 c0 10 80       	mov    0x8010c034,%eax
80105232:	31 d0                	xor    %edx,%eax
80105234:	c1 e8 0d             	shr    $0xd,%eax
80105237:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z1 = ((z1 & 4294967294U) << 18) ^ b;
8010523a:	a1 34 c0 10 80       	mov    0x8010c034,%eax
8010523f:	83 e0 fe             	and    $0xfffffffe,%eax
80105242:	c1 e0 12             	shl    $0x12,%eax
80105245:	33 45 fc             	xor    -0x4(%ebp),%eax
80105248:	a3 34 c0 10 80       	mov    %eax,0x8010c034
  b  = ((z2 << 2) ^ z2) >> 27; 
8010524d:	a1 38 c0 10 80       	mov    0x8010c038,%eax
80105252:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105259:	a1 38 c0 10 80       	mov    0x8010c038,%eax
8010525e:	31 d0                	xor    %edx,%eax
80105260:	c1 e8 1b             	shr    $0x1b,%eax
80105263:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z2 = ((z2 & 4294967288U) << 2) ^ b;
80105266:	a1 38 c0 10 80       	mov    0x8010c038,%eax
8010526b:	83 e0 f8             	and    $0xfffffff8,%eax
8010526e:	c1 e0 02             	shl    $0x2,%eax
80105271:	33 45 fc             	xor    -0x4(%ebp),%eax
80105274:	a3 38 c0 10 80       	mov    %eax,0x8010c038
  b  = ((z3 << 13) ^ z3) >> 21;
80105279:	a1 3c c0 10 80       	mov    0x8010c03c,%eax
8010527e:	c1 e0 0d             	shl    $0xd,%eax
80105281:	89 c2                	mov    %eax,%edx
80105283:	a1 3c c0 10 80       	mov    0x8010c03c,%eax
80105288:	31 d0                	xor    %edx,%eax
8010528a:	c1 e8 15             	shr    $0x15,%eax
8010528d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z3 = ((z3 & 4294967280U) << 7) ^ b;
80105290:	a1 3c c0 10 80       	mov    0x8010c03c,%eax
80105295:	83 e0 f0             	and    $0xfffffff0,%eax
80105298:	c1 e0 07             	shl    $0x7,%eax
8010529b:	33 45 fc             	xor    -0x4(%ebp),%eax
8010529e:	a3 3c c0 10 80       	mov    %eax,0x8010c03c
  b  = ((z4 << 3) ^ z4) >> 12;
801052a3:	a1 40 c0 10 80       	mov    0x8010c040,%eax
801052a8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801052af:	a1 40 c0 10 80       	mov    0x8010c040,%eax
801052b4:	31 d0                	xor    %edx,%eax
801052b6:	c1 e8 0c             	shr    $0xc,%eax
801052b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z4 = ((z4 & 4294967168U) << 13) ^ b;
801052bc:	a1 40 c0 10 80       	mov    0x8010c040,%eax
801052c1:	83 e0 80             	and    $0xffffff80,%eax
801052c4:	c1 e0 0d             	shl    $0xd,%eax
801052c7:	33 45 fc             	xor    -0x4(%ebp),%eax
801052ca:	a3 40 c0 10 80       	mov    %eax,0x8010c040

  uint randomnumber = (z1 ^ z2 ^ z3 ^ z4) / 2;
801052cf:	8b 15 34 c0 10 80    	mov    0x8010c034,%edx
801052d5:	a1 38 c0 10 80       	mov    0x8010c038,%eax
801052da:	31 c2                	xor    %eax,%edx
801052dc:	a1 3c c0 10 80       	mov    0x8010c03c,%eax
801052e1:	31 c2                	xor    %eax,%edx
801052e3:	a1 40 c0 10 80       	mov    0x8010c040,%eax
801052e8:	31 d0                	xor    %edx,%eax
801052ea:	d1 e8                	shr    %eax
801052ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (high < low) {
801052ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801052f2:	3b 45 08             	cmp    0x8(%ebp),%eax
801052f5:	7d 12                	jge    80105309 <randomgenrange+0xec>
    int temp = low;
801052f7:	8b 45 08             	mov    0x8(%ebp),%eax
801052fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    low = high;
801052fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80105300:	89 45 08             	mov    %eax,0x8(%ebp)
    high = temp;
80105303:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105306:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  int range = high - low + 1;
80105309:	8b 45 08             	mov    0x8(%ebp),%eax
8010530c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010530f:	29 c2                	sub    %eax,%edx
80105311:	89 d0                	mov    %edx,%eax
80105313:	83 c0 01             	add    $0x1,%eax
80105316:	89 45 f0             	mov    %eax,-0x10(%ebp)
  return randomnumber % (range) + low;
80105319:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010531c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010531f:	ba 00 00 00 00       	mov    $0x0,%edx
80105324:	f7 f1                	div    %ecx
80105326:	8b 45 08             	mov    0x8(%ebp),%eax
80105329:	01 d0                	add    %edx,%eax
}
8010532b:	c9                   	leave  
8010532c:	c3                   	ret    

8010532d <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010532d:	55                   	push   %ebp
8010532e:	89 e5                	mov    %esp,%ebp
80105330:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105333:	9c                   	pushf  
80105334:	58                   	pop    %eax
80105335:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105338:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010533b:	c9                   	leave  
8010533c:	c3                   	ret    

8010533d <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010533d:	55                   	push   %ebp
8010533e:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105340:	fa                   	cli    
}
80105341:	5d                   	pop    %ebp
80105342:	c3                   	ret    

80105343 <sti>:

static inline void
sti(void)
{
80105343:	55                   	push   %ebp
80105344:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105346:	fb                   	sti    
}
80105347:	5d                   	pop    %ebp
80105348:	c3                   	ret    

80105349 <xchg>:
  asm volatile("hlt");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105349:	55                   	push   %ebp
8010534a:	89 e5                	mov    %esp,%ebp
8010534c:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010534f:	8b 55 08             	mov    0x8(%ebp),%edx
80105352:	8b 45 0c             	mov    0xc(%ebp),%eax
80105355:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105358:	f0 87 02             	lock xchg %eax,(%edx)
8010535b:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010535e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105361:	c9                   	leave  
80105362:	c3                   	ret    

80105363 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105363:	55                   	push   %ebp
80105364:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105366:	8b 45 08             	mov    0x8(%ebp),%eax
80105369:	8b 55 0c             	mov    0xc(%ebp),%edx
8010536c:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010536f:	8b 45 08             	mov    0x8(%ebp),%eax
80105372:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105378:	8b 45 08             	mov    0x8(%ebp),%eax
8010537b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105382:	5d                   	pop    %ebp
80105383:	c3                   	ret    

80105384 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105384:	55                   	push   %ebp
80105385:	89 e5                	mov    %esp,%ebp
80105387:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010538a:	e8 49 01 00 00       	call   801054d8 <pushcli>
  if(holding(lk))
8010538f:	8b 45 08             	mov    0x8(%ebp),%eax
80105392:	89 04 24             	mov    %eax,(%esp)
80105395:	e8 14 01 00 00       	call   801054ae <holding>
8010539a:	85 c0                	test   %eax,%eax
8010539c:	74 0c                	je     801053aa <acquire+0x26>
    panic("acquire");
8010539e:	c7 04 24 c2 8f 10 80 	movl   $0x80108fc2,(%esp)
801053a5:	e8 90 b1 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801053aa:	90                   	nop
801053ab:	8b 45 08             	mov    0x8(%ebp),%eax
801053ae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801053b5:	00 
801053b6:	89 04 24             	mov    %eax,(%esp)
801053b9:	e8 8b ff ff ff       	call   80105349 <xchg>
801053be:	85 c0                	test   %eax,%eax
801053c0:	75 e9                	jne    801053ab <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801053c2:	8b 45 08             	mov    0x8(%ebp),%eax
801053c5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801053cc:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801053cf:	8b 45 08             	mov    0x8(%ebp),%eax
801053d2:	83 c0 0c             	add    $0xc,%eax
801053d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801053d9:	8d 45 08             	lea    0x8(%ebp),%eax
801053dc:	89 04 24             	mov    %eax,(%esp)
801053df:	e8 51 00 00 00       	call   80105435 <getcallerpcs>
}
801053e4:	c9                   	leave  
801053e5:	c3                   	ret    

801053e6 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801053e6:	55                   	push   %ebp
801053e7:	89 e5                	mov    %esp,%ebp
801053e9:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
801053ec:	8b 45 08             	mov    0x8(%ebp),%eax
801053ef:	89 04 24             	mov    %eax,(%esp)
801053f2:	e8 b7 00 00 00       	call   801054ae <holding>
801053f7:	85 c0                	test   %eax,%eax
801053f9:	75 0c                	jne    80105407 <release+0x21>
    panic("release");
801053fb:	c7 04 24 ca 8f 10 80 	movl   $0x80108fca,(%esp)
80105402:	e8 33 b1 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80105407:	8b 45 08             	mov    0x8(%ebp),%eax
8010540a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105411:	8b 45 08             	mov    0x8(%ebp),%eax
80105414:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010541b:	8b 45 08             	mov    0x8(%ebp),%eax
8010541e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105425:	00 
80105426:	89 04 24             	mov    %eax,(%esp)
80105429:	e8 1b ff ff ff       	call   80105349 <xchg>

  popcli();
8010542e:	e8 e9 00 00 00       	call   8010551c <popcli>
}
80105433:	c9                   	leave  
80105434:	c3                   	ret    

80105435 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105435:	55                   	push   %ebp
80105436:	89 e5                	mov    %esp,%ebp
80105438:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010543b:	8b 45 08             	mov    0x8(%ebp),%eax
8010543e:	83 e8 08             	sub    $0x8,%eax
80105441:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105444:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010544b:	eb 38                	jmp    80105485 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010544d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105451:	74 38                	je     8010548b <getcallerpcs+0x56>
80105453:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010545a:	76 2f                	jbe    8010548b <getcallerpcs+0x56>
8010545c:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105460:	74 29                	je     8010548b <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105462:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105465:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010546c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010546f:	01 c2                	add    %eax,%edx
80105471:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105474:	8b 40 04             	mov    0x4(%eax),%eax
80105477:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105479:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010547c:	8b 00                	mov    (%eax),%eax
8010547e:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105481:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105485:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105489:	7e c2                	jle    8010544d <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010548b:	eb 19                	jmp    801054a6 <getcallerpcs+0x71>
    pcs[i] = 0;
8010548d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105490:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105497:	8b 45 0c             	mov    0xc(%ebp),%eax
8010549a:	01 d0                	add    %edx,%eax
8010549c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801054a2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801054a6:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801054aa:	7e e1                	jle    8010548d <getcallerpcs+0x58>
    pcs[i] = 0;
}
801054ac:	c9                   	leave  
801054ad:	c3                   	ret    

801054ae <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801054ae:	55                   	push   %ebp
801054af:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801054b1:	8b 45 08             	mov    0x8(%ebp),%eax
801054b4:	8b 00                	mov    (%eax),%eax
801054b6:	85 c0                	test   %eax,%eax
801054b8:	74 17                	je     801054d1 <holding+0x23>
801054ba:	8b 45 08             	mov    0x8(%ebp),%eax
801054bd:	8b 50 08             	mov    0x8(%eax),%edx
801054c0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054c6:	39 c2                	cmp    %eax,%edx
801054c8:	75 07                	jne    801054d1 <holding+0x23>
801054ca:	b8 01 00 00 00       	mov    $0x1,%eax
801054cf:	eb 05                	jmp    801054d6 <holding+0x28>
801054d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054d6:	5d                   	pop    %ebp
801054d7:	c3                   	ret    

801054d8 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801054d8:	55                   	push   %ebp
801054d9:	89 e5                	mov    %esp,%ebp
801054db:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801054de:	e8 4a fe ff ff       	call   8010532d <readeflags>
801054e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801054e6:	e8 52 fe ff ff       	call   8010533d <cli>
  if(cpu->ncli++ == 0)
801054eb:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801054f2:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801054f8:	8d 48 01             	lea    0x1(%eax),%ecx
801054fb:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105501:	85 c0                	test   %eax,%eax
80105503:	75 15                	jne    8010551a <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105505:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010550b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010550e:	81 e2 00 02 00 00    	and    $0x200,%edx
80105514:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010551a:	c9                   	leave  
8010551b:	c3                   	ret    

8010551c <popcli>:

void
popcli(void)
{
8010551c:	55                   	push   %ebp
8010551d:	89 e5                	mov    %esp,%ebp
8010551f:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105522:	e8 06 fe ff ff       	call   8010532d <readeflags>
80105527:	25 00 02 00 00       	and    $0x200,%eax
8010552c:	85 c0                	test   %eax,%eax
8010552e:	74 0c                	je     8010553c <popcli+0x20>
    panic("popcli - interruptible");
80105530:	c7 04 24 d2 8f 10 80 	movl   $0x80108fd2,(%esp)
80105537:	e8 fe af ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
8010553c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105542:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105548:	83 ea 01             	sub    $0x1,%edx
8010554b:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105551:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105557:	85 c0                	test   %eax,%eax
80105559:	79 0c                	jns    80105567 <popcli+0x4b>
    panic("popcli");
8010555b:	c7 04 24 e9 8f 10 80 	movl   $0x80108fe9,(%esp)
80105562:	e8 d3 af ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105567:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010556d:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105573:	85 c0                	test   %eax,%eax
80105575:	75 15                	jne    8010558c <popcli+0x70>
80105577:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010557d:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105583:	85 c0                	test   %eax,%eax
80105585:	74 05                	je     8010558c <popcli+0x70>
    sti();
80105587:	e8 b7 fd ff ff       	call   80105343 <sti>
}
8010558c:	c9                   	leave  
8010558d:	c3                   	ret    

8010558e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010558e:	55                   	push   %ebp
8010558f:	89 e5                	mov    %esp,%ebp
80105591:	57                   	push   %edi
80105592:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105593:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105596:	8b 55 10             	mov    0x10(%ebp),%edx
80105599:	8b 45 0c             	mov    0xc(%ebp),%eax
8010559c:	89 cb                	mov    %ecx,%ebx
8010559e:	89 df                	mov    %ebx,%edi
801055a0:	89 d1                	mov    %edx,%ecx
801055a2:	fc                   	cld    
801055a3:	f3 aa                	rep stos %al,%es:(%edi)
801055a5:	89 ca                	mov    %ecx,%edx
801055a7:	89 fb                	mov    %edi,%ebx
801055a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801055ac:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801055af:	5b                   	pop    %ebx
801055b0:	5f                   	pop    %edi
801055b1:	5d                   	pop    %ebp
801055b2:	c3                   	ret    

801055b3 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801055b3:	55                   	push   %ebp
801055b4:	89 e5                	mov    %esp,%ebp
801055b6:	57                   	push   %edi
801055b7:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801055b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801055bb:	8b 55 10             	mov    0x10(%ebp),%edx
801055be:	8b 45 0c             	mov    0xc(%ebp),%eax
801055c1:	89 cb                	mov    %ecx,%ebx
801055c3:	89 df                	mov    %ebx,%edi
801055c5:	89 d1                	mov    %edx,%ecx
801055c7:	fc                   	cld    
801055c8:	f3 ab                	rep stos %eax,%es:(%edi)
801055ca:	89 ca                	mov    %ecx,%edx
801055cc:	89 fb                	mov    %edi,%ebx
801055ce:	89 5d 08             	mov    %ebx,0x8(%ebp)
801055d1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801055d4:	5b                   	pop    %ebx
801055d5:	5f                   	pop    %edi
801055d6:	5d                   	pop    %ebp
801055d7:	c3                   	ret    

801055d8 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801055d8:	55                   	push   %ebp
801055d9:	89 e5                	mov    %esp,%ebp
801055db:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801055de:	8b 45 08             	mov    0x8(%ebp),%eax
801055e1:	83 e0 03             	and    $0x3,%eax
801055e4:	85 c0                	test   %eax,%eax
801055e6:	75 49                	jne    80105631 <memset+0x59>
801055e8:	8b 45 10             	mov    0x10(%ebp),%eax
801055eb:	83 e0 03             	and    $0x3,%eax
801055ee:	85 c0                	test   %eax,%eax
801055f0:	75 3f                	jne    80105631 <memset+0x59>
    c &= 0xFF;
801055f2:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801055f9:	8b 45 10             	mov    0x10(%ebp),%eax
801055fc:	c1 e8 02             	shr    $0x2,%eax
801055ff:	89 c2                	mov    %eax,%edx
80105601:	8b 45 0c             	mov    0xc(%ebp),%eax
80105604:	c1 e0 18             	shl    $0x18,%eax
80105607:	89 c1                	mov    %eax,%ecx
80105609:	8b 45 0c             	mov    0xc(%ebp),%eax
8010560c:	c1 e0 10             	shl    $0x10,%eax
8010560f:	09 c1                	or     %eax,%ecx
80105611:	8b 45 0c             	mov    0xc(%ebp),%eax
80105614:	c1 e0 08             	shl    $0x8,%eax
80105617:	09 c8                	or     %ecx,%eax
80105619:	0b 45 0c             	or     0xc(%ebp),%eax
8010561c:	89 54 24 08          	mov    %edx,0x8(%esp)
80105620:	89 44 24 04          	mov    %eax,0x4(%esp)
80105624:	8b 45 08             	mov    0x8(%ebp),%eax
80105627:	89 04 24             	mov    %eax,(%esp)
8010562a:	e8 84 ff ff ff       	call   801055b3 <stosl>
8010562f:	eb 19                	jmp    8010564a <memset+0x72>
  } else
    stosb(dst, c, n);
80105631:	8b 45 10             	mov    0x10(%ebp),%eax
80105634:	89 44 24 08          	mov    %eax,0x8(%esp)
80105638:	8b 45 0c             	mov    0xc(%ebp),%eax
8010563b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010563f:	8b 45 08             	mov    0x8(%ebp),%eax
80105642:	89 04 24             	mov    %eax,(%esp)
80105645:	e8 44 ff ff ff       	call   8010558e <stosb>
  return dst;
8010564a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010564d:	c9                   	leave  
8010564e:	c3                   	ret    

8010564f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010564f:	55                   	push   %ebp
80105650:	89 e5                	mov    %esp,%ebp
80105652:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105655:	8b 45 08             	mov    0x8(%ebp),%eax
80105658:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010565b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010565e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105661:	eb 30                	jmp    80105693 <memcmp+0x44>
    if(*s1 != *s2)
80105663:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105666:	0f b6 10             	movzbl (%eax),%edx
80105669:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010566c:	0f b6 00             	movzbl (%eax),%eax
8010566f:	38 c2                	cmp    %al,%dl
80105671:	74 18                	je     8010568b <memcmp+0x3c>
      return *s1 - *s2;
80105673:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105676:	0f b6 00             	movzbl (%eax),%eax
80105679:	0f b6 d0             	movzbl %al,%edx
8010567c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010567f:	0f b6 00             	movzbl (%eax),%eax
80105682:	0f b6 c0             	movzbl %al,%eax
80105685:	29 c2                	sub    %eax,%edx
80105687:	89 d0                	mov    %edx,%eax
80105689:	eb 1a                	jmp    801056a5 <memcmp+0x56>
    s1++, s2++;
8010568b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010568f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105693:	8b 45 10             	mov    0x10(%ebp),%eax
80105696:	8d 50 ff             	lea    -0x1(%eax),%edx
80105699:	89 55 10             	mov    %edx,0x10(%ebp)
8010569c:	85 c0                	test   %eax,%eax
8010569e:	75 c3                	jne    80105663 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801056a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056a5:	c9                   	leave  
801056a6:	c3                   	ret    

801056a7 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801056a7:	55                   	push   %ebp
801056a8:	89 e5                	mov    %esp,%ebp
801056aa:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801056ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801056b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801056b3:	8b 45 08             	mov    0x8(%ebp),%eax
801056b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801056b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801056bf:	73 3d                	jae    801056fe <memmove+0x57>
801056c1:	8b 45 10             	mov    0x10(%ebp),%eax
801056c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056c7:	01 d0                	add    %edx,%eax
801056c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801056cc:	76 30                	jbe    801056fe <memmove+0x57>
    s += n;
801056ce:	8b 45 10             	mov    0x10(%ebp),%eax
801056d1:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801056d4:	8b 45 10             	mov    0x10(%ebp),%eax
801056d7:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801056da:	eb 13                	jmp    801056ef <memmove+0x48>
      *--d = *--s;
801056dc:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801056e0:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801056e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056e7:	0f b6 10             	movzbl (%eax),%edx
801056ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056ed:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801056ef:	8b 45 10             	mov    0x10(%ebp),%eax
801056f2:	8d 50 ff             	lea    -0x1(%eax),%edx
801056f5:	89 55 10             	mov    %edx,0x10(%ebp)
801056f8:	85 c0                	test   %eax,%eax
801056fa:	75 e0                	jne    801056dc <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801056fc:	eb 26                	jmp    80105724 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801056fe:	eb 17                	jmp    80105717 <memmove+0x70>
      *d++ = *s++;
80105700:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105703:	8d 50 01             	lea    0x1(%eax),%edx
80105706:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105709:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010570c:	8d 4a 01             	lea    0x1(%edx),%ecx
8010570f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105712:	0f b6 12             	movzbl (%edx),%edx
80105715:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105717:	8b 45 10             	mov    0x10(%ebp),%eax
8010571a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010571d:	89 55 10             	mov    %edx,0x10(%ebp)
80105720:	85 c0                	test   %eax,%eax
80105722:	75 dc                	jne    80105700 <memmove+0x59>
      *d++ = *s++;

  return dst;
80105724:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105727:	c9                   	leave  
80105728:	c3                   	ret    

80105729 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105729:	55                   	push   %ebp
8010572a:	89 e5                	mov    %esp,%ebp
8010572c:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
8010572f:	8b 45 10             	mov    0x10(%ebp),%eax
80105732:	89 44 24 08          	mov    %eax,0x8(%esp)
80105736:	8b 45 0c             	mov    0xc(%ebp),%eax
80105739:	89 44 24 04          	mov    %eax,0x4(%esp)
8010573d:	8b 45 08             	mov    0x8(%ebp),%eax
80105740:	89 04 24             	mov    %eax,(%esp)
80105743:	e8 5f ff ff ff       	call   801056a7 <memmove>
}
80105748:	c9                   	leave  
80105749:	c3                   	ret    

8010574a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010574a:	55                   	push   %ebp
8010574b:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010574d:	eb 0c                	jmp    8010575b <strncmp+0x11>
    n--, p++, q++;
8010574f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105753:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105757:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010575b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010575f:	74 1a                	je     8010577b <strncmp+0x31>
80105761:	8b 45 08             	mov    0x8(%ebp),%eax
80105764:	0f b6 00             	movzbl (%eax),%eax
80105767:	84 c0                	test   %al,%al
80105769:	74 10                	je     8010577b <strncmp+0x31>
8010576b:	8b 45 08             	mov    0x8(%ebp),%eax
8010576e:	0f b6 10             	movzbl (%eax),%edx
80105771:	8b 45 0c             	mov    0xc(%ebp),%eax
80105774:	0f b6 00             	movzbl (%eax),%eax
80105777:	38 c2                	cmp    %al,%dl
80105779:	74 d4                	je     8010574f <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010577b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010577f:	75 07                	jne    80105788 <strncmp+0x3e>
    return 0;
80105781:	b8 00 00 00 00       	mov    $0x0,%eax
80105786:	eb 16                	jmp    8010579e <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105788:	8b 45 08             	mov    0x8(%ebp),%eax
8010578b:	0f b6 00             	movzbl (%eax),%eax
8010578e:	0f b6 d0             	movzbl %al,%edx
80105791:	8b 45 0c             	mov    0xc(%ebp),%eax
80105794:	0f b6 00             	movzbl (%eax),%eax
80105797:	0f b6 c0             	movzbl %al,%eax
8010579a:	29 c2                	sub    %eax,%edx
8010579c:	89 d0                	mov    %edx,%eax
}
8010579e:	5d                   	pop    %ebp
8010579f:	c3                   	ret    

801057a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801057a6:	8b 45 08             	mov    0x8(%ebp),%eax
801057a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801057ac:	90                   	nop
801057ad:	8b 45 10             	mov    0x10(%ebp),%eax
801057b0:	8d 50 ff             	lea    -0x1(%eax),%edx
801057b3:	89 55 10             	mov    %edx,0x10(%ebp)
801057b6:	85 c0                	test   %eax,%eax
801057b8:	7e 1e                	jle    801057d8 <strncpy+0x38>
801057ba:	8b 45 08             	mov    0x8(%ebp),%eax
801057bd:	8d 50 01             	lea    0x1(%eax),%edx
801057c0:	89 55 08             	mov    %edx,0x8(%ebp)
801057c3:	8b 55 0c             	mov    0xc(%ebp),%edx
801057c6:	8d 4a 01             	lea    0x1(%edx),%ecx
801057c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801057cc:	0f b6 12             	movzbl (%edx),%edx
801057cf:	88 10                	mov    %dl,(%eax)
801057d1:	0f b6 00             	movzbl (%eax),%eax
801057d4:	84 c0                	test   %al,%al
801057d6:	75 d5                	jne    801057ad <strncpy+0xd>
    ;
  while(n-- > 0)
801057d8:	eb 0c                	jmp    801057e6 <strncpy+0x46>
    *s++ = 0;
801057da:	8b 45 08             	mov    0x8(%ebp),%eax
801057dd:	8d 50 01             	lea    0x1(%eax),%edx
801057e0:	89 55 08             	mov    %edx,0x8(%ebp)
801057e3:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801057e6:	8b 45 10             	mov    0x10(%ebp),%eax
801057e9:	8d 50 ff             	lea    -0x1(%eax),%edx
801057ec:	89 55 10             	mov    %edx,0x10(%ebp)
801057ef:	85 c0                	test   %eax,%eax
801057f1:	7f e7                	jg     801057da <strncpy+0x3a>
    *s++ = 0;
  return os;
801057f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801057f6:	c9                   	leave  
801057f7:	c3                   	ret    

801057f8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801057f8:	55                   	push   %ebp
801057f9:	89 e5                	mov    %esp,%ebp
801057fb:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801057fe:	8b 45 08             	mov    0x8(%ebp),%eax
80105801:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105804:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105808:	7f 05                	jg     8010580f <safestrcpy+0x17>
    return os;
8010580a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010580d:	eb 31                	jmp    80105840 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
8010580f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105813:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105817:	7e 1e                	jle    80105837 <safestrcpy+0x3f>
80105819:	8b 45 08             	mov    0x8(%ebp),%eax
8010581c:	8d 50 01             	lea    0x1(%eax),%edx
8010581f:	89 55 08             	mov    %edx,0x8(%ebp)
80105822:	8b 55 0c             	mov    0xc(%ebp),%edx
80105825:	8d 4a 01             	lea    0x1(%edx),%ecx
80105828:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010582b:	0f b6 12             	movzbl (%edx),%edx
8010582e:	88 10                	mov    %dl,(%eax)
80105830:	0f b6 00             	movzbl (%eax),%eax
80105833:	84 c0                	test   %al,%al
80105835:	75 d8                	jne    8010580f <safestrcpy+0x17>
    ;
  *s = 0;
80105837:	8b 45 08             	mov    0x8(%ebp),%eax
8010583a:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010583d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105840:	c9                   	leave  
80105841:	c3                   	ret    

80105842 <strlen>:

int
strlen(const char *s)
{
80105842:	55                   	push   %ebp
80105843:	89 e5                	mov    %esp,%ebp
80105845:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105848:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010584f:	eb 04                	jmp    80105855 <strlen+0x13>
80105851:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105855:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105858:	8b 45 08             	mov    0x8(%ebp),%eax
8010585b:	01 d0                	add    %edx,%eax
8010585d:	0f b6 00             	movzbl (%eax),%eax
80105860:	84 c0                	test   %al,%al
80105862:	75 ed                	jne    80105851 <strlen+0xf>
    ;
  return n;
80105864:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105867:	c9                   	leave  
80105868:	c3                   	ret    

80105869 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105869:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010586d:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105871:	55                   	push   %ebp
  pushl %ebx
80105872:	53                   	push   %ebx
  pushl %esi
80105873:	56                   	push   %esi
  pushl %edi
80105874:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105875:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105877:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105879:	5f                   	pop    %edi
  popl %esi
8010587a:	5e                   	pop    %esi
  popl %ebx
8010587b:	5b                   	pop    %ebx
  popl %ebp
8010587c:	5d                   	pop    %ebp
  ret
8010587d:	c3                   	ret    

8010587e <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010587e:	55                   	push   %ebp
8010587f:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105881:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105887:	8b 00                	mov    (%eax),%eax
80105889:	3b 45 08             	cmp    0x8(%ebp),%eax
8010588c:	76 12                	jbe    801058a0 <fetchint+0x22>
8010588e:	8b 45 08             	mov    0x8(%ebp),%eax
80105891:	8d 50 04             	lea    0x4(%eax),%edx
80105894:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010589a:	8b 00                	mov    (%eax),%eax
8010589c:	39 c2                	cmp    %eax,%edx
8010589e:	76 07                	jbe    801058a7 <fetchint+0x29>
    return -1;
801058a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a5:	eb 0f                	jmp    801058b6 <fetchint+0x38>
  *ip = *(int*)(addr);
801058a7:	8b 45 08             	mov    0x8(%ebp),%eax
801058aa:	8b 10                	mov    (%eax),%edx
801058ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801058af:	89 10                	mov    %edx,(%eax)
  return 0;
801058b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058b6:	5d                   	pop    %ebp
801058b7:	c3                   	ret    

801058b8 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801058b8:	55                   	push   %ebp
801058b9:	89 e5                	mov    %esp,%ebp
801058bb:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801058be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058c4:	8b 00                	mov    (%eax),%eax
801058c6:	3b 45 08             	cmp    0x8(%ebp),%eax
801058c9:	77 07                	ja     801058d2 <fetchstr+0x1a>
    return -1;
801058cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d0:	eb 46                	jmp    80105918 <fetchstr+0x60>
  *pp = (char*)addr;
801058d2:	8b 55 08             	mov    0x8(%ebp),%edx
801058d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801058d8:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801058da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058e0:	8b 00                	mov    (%eax),%eax
801058e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801058e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801058e8:	8b 00                	mov    (%eax),%eax
801058ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
801058ed:	eb 1c                	jmp    8010590b <fetchstr+0x53>
    if(*s == 0)
801058ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058f2:	0f b6 00             	movzbl (%eax),%eax
801058f5:	84 c0                	test   %al,%al
801058f7:	75 0e                	jne    80105907 <fetchstr+0x4f>
      return s - *pp;
801058f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801058ff:	8b 00                	mov    (%eax),%eax
80105901:	29 c2                	sub    %eax,%edx
80105903:	89 d0                	mov    %edx,%eax
80105905:	eb 11                	jmp    80105918 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105907:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010590b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010590e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105911:	72 dc                	jb     801058ef <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105913:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105918:	c9                   	leave  
80105919:	c3                   	ret    

8010591a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010591a:	55                   	push   %ebp
8010591b:	89 e5                	mov    %esp,%ebp
8010591d:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105920:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105926:	8b 40 18             	mov    0x18(%eax),%eax
80105929:	8b 50 44             	mov    0x44(%eax),%edx
8010592c:	8b 45 08             	mov    0x8(%ebp),%eax
8010592f:	c1 e0 02             	shl    $0x2,%eax
80105932:	01 d0                	add    %edx,%eax
80105934:	8d 50 04             	lea    0x4(%eax),%edx
80105937:	8b 45 0c             	mov    0xc(%ebp),%eax
8010593a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010593e:	89 14 24             	mov    %edx,(%esp)
80105941:	e8 38 ff ff ff       	call   8010587e <fetchint>
}
80105946:	c9                   	leave  
80105947:	c3                   	ret    

80105948 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105948:	55                   	push   %ebp
80105949:	89 e5                	mov    %esp,%ebp
8010594b:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
8010594e:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105951:	89 44 24 04          	mov    %eax,0x4(%esp)
80105955:	8b 45 08             	mov    0x8(%ebp),%eax
80105958:	89 04 24             	mov    %eax,(%esp)
8010595b:	e8 ba ff ff ff       	call   8010591a <argint>
80105960:	85 c0                	test   %eax,%eax
80105962:	79 07                	jns    8010596b <argptr+0x23>
    return -1;
80105964:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105969:	eb 3d                	jmp    801059a8 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010596b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010596e:	89 c2                	mov    %eax,%edx
80105970:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105976:	8b 00                	mov    (%eax),%eax
80105978:	39 c2                	cmp    %eax,%edx
8010597a:	73 16                	jae    80105992 <argptr+0x4a>
8010597c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010597f:	89 c2                	mov    %eax,%edx
80105981:	8b 45 10             	mov    0x10(%ebp),%eax
80105984:	01 c2                	add    %eax,%edx
80105986:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010598c:	8b 00                	mov    (%eax),%eax
8010598e:	39 c2                	cmp    %eax,%edx
80105990:	76 07                	jbe    80105999 <argptr+0x51>
    return -1;
80105992:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105997:	eb 0f                	jmp    801059a8 <argptr+0x60>
  *pp = (char*)i;
80105999:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010599c:	89 c2                	mov    %eax,%edx
8010599e:	8b 45 0c             	mov    0xc(%ebp),%eax
801059a1:	89 10                	mov    %edx,(%eax)
  return 0;
801059a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059a8:	c9                   	leave  
801059a9:	c3                   	ret    

801059aa <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801059aa:	55                   	push   %ebp
801059ab:	89 e5                	mov    %esp,%ebp
801059ad:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
801059b0:	8d 45 fc             	lea    -0x4(%ebp),%eax
801059b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801059b7:	8b 45 08             	mov    0x8(%ebp),%eax
801059ba:	89 04 24             	mov    %eax,(%esp)
801059bd:	e8 58 ff ff ff       	call   8010591a <argint>
801059c2:	85 c0                	test   %eax,%eax
801059c4:	79 07                	jns    801059cd <argstr+0x23>
    return -1;
801059c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059cb:	eb 12                	jmp    801059df <argstr+0x35>
  return fetchstr(addr, pp);
801059cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059d0:	8b 55 0c             	mov    0xc(%ebp),%edx
801059d3:	89 54 24 04          	mov    %edx,0x4(%esp)
801059d7:	89 04 24             	mov    %eax,(%esp)
801059da:	e8 d9 fe ff ff       	call   801058b8 <fetchstr>
}
801059df:	c9                   	leave  
801059e0:	c3                   	ret    

801059e1 <syscall>:
[SYS_randomgenrange] sys_randomgenrange,
};

void
syscall(void)
{
801059e1:	55                   	push   %ebp
801059e2:	89 e5                	mov    %esp,%ebp
801059e4:	53                   	push   %ebx
801059e5:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
801059e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059ee:	8b 40 18             	mov    0x18(%eax),%eax
801059f1:	8b 40 1c             	mov    0x1c(%eax),%eax
801059f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801059f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059fb:	7e 30                	jle    80105a2d <syscall+0x4c>
801059fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a00:	83 f8 19             	cmp    $0x19,%eax
80105a03:	77 28                	ja     80105a2d <syscall+0x4c>
80105a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a08:	8b 04 85 60 c0 10 80 	mov    -0x7fef3fa0(,%eax,4),%eax
80105a0f:	85 c0                	test   %eax,%eax
80105a11:	74 1a                	je     80105a2d <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105a13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a19:	8b 58 18             	mov    0x18(%eax),%ebx
80105a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a1f:	8b 04 85 60 c0 10 80 	mov    -0x7fef3fa0(,%eax,4),%eax
80105a26:	ff d0                	call   *%eax
80105a28:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105a2b:	eb 3d                	jmp    80105a6a <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105a2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a33:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105a36:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105a3c:	8b 40 10             	mov    0x10(%eax),%eax
80105a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a42:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105a46:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a4e:	c7 04 24 f0 8f 10 80 	movl   $0x80108ff0,(%esp)
80105a55:	e8 46 a9 ff ff       	call   801003a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105a5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a60:	8b 40 18             	mov    0x18(%eax),%eax
80105a63:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105a6a:	83 c4 24             	add    $0x24,%esp
80105a6d:	5b                   	pop    %ebx
80105a6e:	5d                   	pop    %ebp
80105a6f:	c3                   	ret    

80105a70 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105a76:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a79:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a7d:	8b 45 08             	mov    0x8(%ebp),%eax
80105a80:	89 04 24             	mov    %eax,(%esp)
80105a83:	e8 92 fe ff ff       	call   8010591a <argint>
80105a88:	85 c0                	test   %eax,%eax
80105a8a:	79 07                	jns    80105a93 <argfd+0x23>
    return -1;
80105a8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a91:	eb 50                	jmp    80105ae3 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a96:	85 c0                	test   %eax,%eax
80105a98:	78 21                	js     80105abb <argfd+0x4b>
80105a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a9d:	83 f8 0f             	cmp    $0xf,%eax
80105aa0:	7f 19                	jg     80105abb <argfd+0x4b>
80105aa2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105aa8:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105aab:	83 c2 08             	add    $0x8,%edx
80105aae:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ab5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ab9:	75 07                	jne    80105ac2 <argfd+0x52>
    return -1;
80105abb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ac0:	eb 21                	jmp    80105ae3 <argfd+0x73>
  if(pfd)
80105ac2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105ac6:	74 08                	je     80105ad0 <argfd+0x60>
    *pfd = fd;
80105ac8:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105acb:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ace:	89 10                	mov    %edx,(%eax)
  if(pf)
80105ad0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105ad4:	74 08                	je     80105ade <argfd+0x6e>
    *pf = f;
80105ad6:	8b 45 10             	mov    0x10(%ebp),%eax
80105ad9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105adc:	89 10                	mov    %edx,(%eax)
  return 0;
80105ade:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ae3:	c9                   	leave  
80105ae4:	c3                   	ret    

80105ae5 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105ae5:	55                   	push   %ebp
80105ae6:	89 e5                	mov    %esp,%ebp
80105ae8:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105aeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105af2:	eb 30                	jmp    80105b24 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105af4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105afa:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105afd:	83 c2 08             	add    $0x8,%edx
80105b00:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105b04:	85 c0                	test   %eax,%eax
80105b06:	75 18                	jne    80105b20 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105b08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b11:	8d 4a 08             	lea    0x8(%edx),%ecx
80105b14:	8b 55 08             	mov    0x8(%ebp),%edx
80105b17:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105b1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b1e:	eb 0f                	jmp    80105b2f <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105b20:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105b24:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105b28:	7e ca                	jle    80105af4 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105b2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b2f:	c9                   	leave  
80105b30:	c3                   	ret    

80105b31 <sys_dup>:

int
sys_dup(void)
{
80105b31:	55                   	push   %ebp
80105b32:	89 e5                	mov    %esp,%ebp
80105b34:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105b37:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b3a:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b3e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b45:	00 
80105b46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b4d:	e8 1e ff ff ff       	call   80105a70 <argfd>
80105b52:	85 c0                	test   %eax,%eax
80105b54:	79 07                	jns    80105b5d <sys_dup+0x2c>
    return -1;
80105b56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5b:	eb 29                	jmp    80105b86 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b60:	89 04 24             	mov    %eax,(%esp)
80105b63:	e8 7d ff ff ff       	call   80105ae5 <fdalloc>
80105b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b6f:	79 07                	jns    80105b78 <sys_dup+0x47>
    return -1;
80105b71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b76:	eb 0e                	jmp    80105b86 <sys_dup+0x55>
  filedup(f);
80105b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b7b:	89 04 24             	mov    %eax,(%esp)
80105b7e:	e8 2b b4 ff ff       	call   80100fae <filedup>
  return fd;
80105b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105b86:	c9                   	leave  
80105b87:	c3                   	ret    

80105b88 <sys_read>:

int
sys_read(void)
{
80105b88:	55                   	push   %ebp
80105b89:	89 e5                	mov    %esp,%ebp
80105b8b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b91:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b95:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b9c:	00 
80105b9d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ba4:	e8 c7 fe ff ff       	call   80105a70 <argfd>
80105ba9:	85 c0                	test   %eax,%eax
80105bab:	78 35                	js     80105be2 <sys_read+0x5a>
80105bad:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bb4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105bbb:	e8 5a fd ff ff       	call   8010591a <argint>
80105bc0:	85 c0                	test   %eax,%eax
80105bc2:	78 1e                	js     80105be2 <sys_read+0x5a>
80105bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc7:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bcb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105bce:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bd2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105bd9:	e8 6a fd ff ff       	call   80105948 <argptr>
80105bde:	85 c0                	test   %eax,%eax
80105be0:	79 07                	jns    80105be9 <sys_read+0x61>
    return -1;
80105be2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be7:	eb 19                	jmp    80105c02 <sys_read+0x7a>
  return fileread(f, p, n);
80105be9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105bec:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105bf6:	89 54 24 04          	mov    %edx,0x4(%esp)
80105bfa:	89 04 24             	mov    %eax,(%esp)
80105bfd:	e8 19 b5 ff ff       	call   8010111b <fileread>
}
80105c02:	c9                   	leave  
80105c03:	c3                   	ret    

80105c04 <sys_write>:

int
sys_write(void)
{
80105c04:	55                   	push   %ebp
80105c05:	89 e5                	mov    %esp,%ebp
80105c07:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c0d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c11:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c18:	00 
80105c19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c20:	e8 4b fe ff ff       	call   80105a70 <argfd>
80105c25:	85 c0                	test   %eax,%eax
80105c27:	78 35                	js     80105c5e <sys_write+0x5a>
80105c29:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c30:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105c37:	e8 de fc ff ff       	call   8010591a <argint>
80105c3c:	85 c0                	test   %eax,%eax
80105c3e:	78 1e                	js     80105c5e <sys_write+0x5a>
80105c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c43:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c47:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c4e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105c55:	e8 ee fc ff ff       	call   80105948 <argptr>
80105c5a:	85 c0                	test   %eax,%eax
80105c5c:	79 07                	jns    80105c65 <sys_write+0x61>
    return -1;
80105c5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c63:	eb 19                	jmp    80105c7e <sys_write+0x7a>
  return filewrite(f, p, n);
80105c65:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105c68:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c6e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105c72:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c76:	89 04 24             	mov    %eax,(%esp)
80105c79:	e8 59 b5 ff ff       	call   801011d7 <filewrite>
}
80105c7e:	c9                   	leave  
80105c7f:	c3                   	ret    

80105c80 <sys_close>:

int
sys_close(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105c86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c89:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c90:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c9b:	e8 d0 fd ff ff       	call   80105a70 <argfd>
80105ca0:	85 c0                	test   %eax,%eax
80105ca2:	79 07                	jns    80105cab <sys_close+0x2b>
    return -1;
80105ca4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca9:	eb 24                	jmp    80105ccf <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105cab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cb4:	83 c2 08             	add    $0x8,%edx
80105cb7:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105cbe:	00 
  fileclose(f);
80105cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cc2:	89 04 24             	mov    %eax,(%esp)
80105cc5:	e8 2c b3 ff ff       	call   80100ff6 <fileclose>
  return 0;
80105cca:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ccf:	c9                   	leave  
80105cd0:	c3                   	ret    

80105cd1 <sys_fstat>:

int
sys_fstat(void)
{
80105cd1:	55                   	push   %ebp
80105cd2:	89 e5                	mov    %esp,%ebp
80105cd4:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105cd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cda:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cde:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105ce5:	00 
80105ce6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ced:	e8 7e fd ff ff       	call   80105a70 <argfd>
80105cf2:	85 c0                	test   %eax,%eax
80105cf4:	78 1f                	js     80105d15 <sys_fstat+0x44>
80105cf6:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105cfd:	00 
80105cfe:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d01:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105d0c:	e8 37 fc ff ff       	call   80105948 <argptr>
80105d11:	85 c0                	test   %eax,%eax
80105d13:	79 07                	jns    80105d1c <sys_fstat+0x4b>
    return -1;
80105d15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d1a:	eb 12                	jmp    80105d2e <sys_fstat+0x5d>
  return filestat(f, st);
80105d1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d22:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d26:	89 04 24             	mov    %eax,(%esp)
80105d29:	e8 9e b3 ff ff       	call   801010cc <filestat>
}
80105d2e:	c9                   	leave  
80105d2f:	c3                   	ret    

80105d30 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105d36:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105d39:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d3d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d44:	e8 61 fc ff ff       	call   801059aa <argstr>
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	78 17                	js     80105d64 <sys_link+0x34>
80105d4d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105d50:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105d5b:	e8 4a fc ff ff       	call   801059aa <argstr>
80105d60:	85 c0                	test   %eax,%eax
80105d62:	79 0a                	jns    80105d6e <sys_link+0x3e>
    return -1;
80105d64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d69:	e9 42 01 00 00       	jmp    80105eb0 <sys_link+0x180>

  begin_op();
80105d6e:	e8 56 d7 ff ff       	call   801034c9 <begin_op>
  if((ip = namei(old)) == 0){
80105d73:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105d76:	89 04 24             	mov    %eax,(%esp)
80105d79:	e8 14 c7 ff ff       	call   80102492 <namei>
80105d7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d85:	75 0f                	jne    80105d96 <sys_link+0x66>
    end_op();
80105d87:	e8 c1 d7 ff ff       	call   8010354d <end_op>
    return -1;
80105d8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d91:	e9 1a 01 00 00       	jmp    80105eb0 <sys_link+0x180>
  }

  ilock(ip);
80105d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d99:	89 04 24             	mov    %eax,(%esp)
80105d9c:	e8 40 bb ff ff       	call   801018e1 <ilock>
  if(ip->type == T_DIR){
80105da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da4:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105da8:	66 83 f8 01          	cmp    $0x1,%ax
80105dac:	75 1a                	jne    80105dc8 <sys_link+0x98>
    iunlockput(ip);
80105dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db1:	89 04 24             	mov    %eax,(%esp)
80105db4:	e8 b2 bd ff ff       	call   80101b6b <iunlockput>
    end_op();
80105db9:	e8 8f d7 ff ff       	call   8010354d <end_op>
    return -1;
80105dbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dc3:	e9 e8 00 00 00       	jmp    80105eb0 <sys_link+0x180>
  }

  ip->nlink++;
80105dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dcb:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105dcf:	8d 50 01             	lea    0x1(%eax),%edx
80105dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dd5:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ddc:	89 04 24             	mov    %eax,(%esp)
80105ddf:	e8 3b b9 ff ff       	call   8010171f <iupdate>
  iunlock(ip);
80105de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105de7:	89 04 24             	mov    %eax,(%esp)
80105dea:	e8 46 bc ff ff       	call   80101a35 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105def:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105df2:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105df5:	89 54 24 04          	mov    %edx,0x4(%esp)
80105df9:	89 04 24             	mov    %eax,(%esp)
80105dfc:	e8 b3 c6 ff ff       	call   801024b4 <nameiparent>
80105e01:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e08:	75 02                	jne    80105e0c <sys_link+0xdc>
    goto bad;
80105e0a:	eb 68                	jmp    80105e74 <sys_link+0x144>
  ilock(dp);
80105e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e0f:	89 04 24             	mov    %eax,(%esp)
80105e12:	e8 ca ba ff ff       	call   801018e1 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e1a:	8b 10                	mov    (%eax),%edx
80105e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1f:	8b 00                	mov    (%eax),%eax
80105e21:	39 c2                	cmp    %eax,%edx
80105e23:	75 20                	jne    80105e45 <sys_link+0x115>
80105e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e28:	8b 40 04             	mov    0x4(%eax),%eax
80105e2b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e2f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105e32:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e39:	89 04 24             	mov    %eax,(%esp)
80105e3c:	e8 91 c3 ff ff       	call   801021d2 <dirlink>
80105e41:	85 c0                	test   %eax,%eax
80105e43:	79 0d                	jns    80105e52 <sys_link+0x122>
    iunlockput(dp);
80105e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e48:	89 04 24             	mov    %eax,(%esp)
80105e4b:	e8 1b bd ff ff       	call   80101b6b <iunlockput>
    goto bad;
80105e50:	eb 22                	jmp    80105e74 <sys_link+0x144>
  }
  iunlockput(dp);
80105e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e55:	89 04 24             	mov    %eax,(%esp)
80105e58:	e8 0e bd ff ff       	call   80101b6b <iunlockput>
  iput(ip);
80105e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e60:	89 04 24             	mov    %eax,(%esp)
80105e63:	e8 32 bc ff ff       	call   80101a9a <iput>

  end_op();
80105e68:	e8 e0 d6 ff ff       	call   8010354d <end_op>

  return 0;
80105e6d:	b8 00 00 00 00       	mov    $0x0,%eax
80105e72:	eb 3c                	jmp    80105eb0 <sys_link+0x180>

bad:
  ilock(ip);
80105e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e77:	89 04 24             	mov    %eax,(%esp)
80105e7a:	e8 62 ba ff ff       	call   801018e1 <ilock>
  ip->nlink--;
80105e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e82:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e86:	8d 50 ff             	lea    -0x1(%eax),%edx
80105e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e8c:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e93:	89 04 24             	mov    %eax,(%esp)
80105e96:	e8 84 b8 ff ff       	call   8010171f <iupdate>
  iunlockput(ip);
80105e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e9e:	89 04 24             	mov    %eax,(%esp)
80105ea1:	e8 c5 bc ff ff       	call   80101b6b <iunlockput>
  end_op();
80105ea6:	e8 a2 d6 ff ff       	call   8010354d <end_op>
  return -1;
80105eab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eb0:	c9                   	leave  
80105eb1:	c3                   	ret    

80105eb2 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105eb2:	55                   	push   %ebp
80105eb3:	89 e5                	mov    %esp,%ebp
80105eb5:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105eb8:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105ebf:	eb 4b                	jmp    80105f0c <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ec4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105ecb:	00 
80105ecc:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ed0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ed3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ed7:	8b 45 08             	mov    0x8(%ebp),%eax
80105eda:	89 04 24             	mov    %eax,(%esp)
80105edd:	e8 12 bf ff ff       	call   80101df4 <readi>
80105ee2:	83 f8 10             	cmp    $0x10,%eax
80105ee5:	74 0c                	je     80105ef3 <isdirempty+0x41>
      panic("isdirempty: readi");
80105ee7:	c7 04 24 0c 90 10 80 	movl   $0x8010900c,(%esp)
80105eee:	e8 47 a6 ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80105ef3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105ef7:	66 85 c0             	test   %ax,%ax
80105efa:	74 07                	je     80105f03 <isdirempty+0x51>
      return 0;
80105efc:	b8 00 00 00 00       	mov    $0x0,%eax
80105f01:	eb 1b                	jmp    80105f1e <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f06:	83 c0 10             	add    $0x10,%eax
80105f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80105f12:	8b 40 18             	mov    0x18(%eax),%eax
80105f15:	39 c2                	cmp    %eax,%edx
80105f17:	72 a8                	jb     80105ec1 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105f19:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105f1e:	c9                   	leave  
80105f1f:	c3                   	ret    

80105f20 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105f26:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105f29:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f34:	e8 71 fa ff ff       	call   801059aa <argstr>
80105f39:	85 c0                	test   %eax,%eax
80105f3b:	79 0a                	jns    80105f47 <sys_unlink+0x27>
    return -1;
80105f3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f42:	e9 af 01 00 00       	jmp    801060f6 <sys_unlink+0x1d6>

  begin_op();
80105f47:	e8 7d d5 ff ff       	call   801034c9 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105f4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105f4f:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105f52:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f56:	89 04 24             	mov    %eax,(%esp)
80105f59:	e8 56 c5 ff ff       	call   801024b4 <nameiparent>
80105f5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f65:	75 0f                	jne    80105f76 <sys_unlink+0x56>
    end_op();
80105f67:	e8 e1 d5 ff ff       	call   8010354d <end_op>
    return -1;
80105f6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f71:	e9 80 01 00 00       	jmp    801060f6 <sys_unlink+0x1d6>
  }

  ilock(dp);
80105f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f79:	89 04 24             	mov    %eax,(%esp)
80105f7c:	e8 60 b9 ff ff       	call   801018e1 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105f81:	c7 44 24 04 1e 90 10 	movl   $0x8010901e,0x4(%esp)
80105f88:	80 
80105f89:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f8c:	89 04 24             	mov    %eax,(%esp)
80105f8f:	e8 53 c1 ff ff       	call   801020e7 <namecmp>
80105f94:	85 c0                	test   %eax,%eax
80105f96:	0f 84 45 01 00 00    	je     801060e1 <sys_unlink+0x1c1>
80105f9c:	c7 44 24 04 20 90 10 	movl   $0x80109020,0x4(%esp)
80105fa3:	80 
80105fa4:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105fa7:	89 04 24             	mov    %eax,(%esp)
80105faa:	e8 38 c1 ff ff       	call   801020e7 <namecmp>
80105faf:	85 c0                	test   %eax,%eax
80105fb1:	0f 84 2a 01 00 00    	je     801060e1 <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105fb7:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105fba:	89 44 24 08          	mov    %eax,0x8(%esp)
80105fbe:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105fc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc8:	89 04 24             	mov    %eax,(%esp)
80105fcb:	e8 39 c1 ff ff       	call   80102109 <dirlookup>
80105fd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fd7:	75 05                	jne    80105fde <sys_unlink+0xbe>
    goto bad;
80105fd9:	e9 03 01 00 00       	jmp    801060e1 <sys_unlink+0x1c1>
  ilock(ip);
80105fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe1:	89 04 24             	mov    %eax,(%esp)
80105fe4:	e8 f8 b8 ff ff       	call   801018e1 <ilock>

  if(ip->nlink < 1)
80105fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fec:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ff0:	66 85 c0             	test   %ax,%ax
80105ff3:	7f 0c                	jg     80106001 <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105ff5:	c7 04 24 23 90 10 80 	movl   $0x80109023,(%esp)
80105ffc:	e8 39 a5 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106001:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106004:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106008:	66 83 f8 01          	cmp    $0x1,%ax
8010600c:	75 1f                	jne    8010602d <sys_unlink+0x10d>
8010600e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106011:	89 04 24             	mov    %eax,(%esp)
80106014:	e8 99 fe ff ff       	call   80105eb2 <isdirempty>
80106019:	85 c0                	test   %eax,%eax
8010601b:	75 10                	jne    8010602d <sys_unlink+0x10d>
    iunlockput(ip);
8010601d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106020:	89 04 24             	mov    %eax,(%esp)
80106023:	e8 43 bb ff ff       	call   80101b6b <iunlockput>
    goto bad;
80106028:	e9 b4 00 00 00       	jmp    801060e1 <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
8010602d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80106034:	00 
80106035:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010603c:	00 
8010603d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106040:	89 04 24             	mov    %eax,(%esp)
80106043:	e8 90 f5 ff ff       	call   801055d8 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106048:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010604b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80106052:	00 
80106053:	89 44 24 08          	mov    %eax,0x8(%esp)
80106057:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010605a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010605e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106061:	89 04 24             	mov    %eax,(%esp)
80106064:	e8 ef be ff ff       	call   80101f58 <writei>
80106069:	83 f8 10             	cmp    $0x10,%eax
8010606c:	74 0c                	je     8010607a <sys_unlink+0x15a>
    panic("unlink: writei");
8010606e:	c7 04 24 35 90 10 80 	movl   $0x80109035,(%esp)
80106075:	e8 c0 a4 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
8010607a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010607d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106081:	66 83 f8 01          	cmp    $0x1,%ax
80106085:	75 1c                	jne    801060a3 <sys_unlink+0x183>
    dp->nlink--;
80106087:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010608a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010608e:	8d 50 ff             	lea    -0x1(%eax),%edx
80106091:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106094:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106098:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010609b:	89 04 24             	mov    %eax,(%esp)
8010609e:	e8 7c b6 ff ff       	call   8010171f <iupdate>
  }
  iunlockput(dp);
801060a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a6:	89 04 24             	mov    %eax,(%esp)
801060a9:	e8 bd ba ff ff       	call   80101b6b <iunlockput>

  ip->nlink--;
801060ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060b1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801060b5:	8d 50 ff             	lea    -0x1(%eax),%edx
801060b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060bb:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801060bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060c2:	89 04 24             	mov    %eax,(%esp)
801060c5:	e8 55 b6 ff ff       	call   8010171f <iupdate>
  iunlockput(ip);
801060ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060cd:	89 04 24             	mov    %eax,(%esp)
801060d0:	e8 96 ba ff ff       	call   80101b6b <iunlockput>

  end_op();
801060d5:	e8 73 d4 ff ff       	call   8010354d <end_op>

  return 0;
801060da:	b8 00 00 00 00       	mov    $0x0,%eax
801060df:	eb 15                	jmp    801060f6 <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
801060e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e4:	89 04 24             	mov    %eax,(%esp)
801060e7:	e8 7f ba ff ff       	call   80101b6b <iunlockput>
  end_op();
801060ec:	e8 5c d4 ff ff       	call   8010354d <end_op>
  return -1;
801060f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060f6:	c9                   	leave  
801060f7:	c3                   	ret    

801060f8 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801060f8:	55                   	push   %ebp
801060f9:	89 e5                	mov    %esp,%ebp
801060fb:	83 ec 48             	sub    $0x48,%esp
801060fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106101:	8b 55 10             	mov    0x10(%ebp),%edx
80106104:	8b 45 14             	mov    0x14(%ebp),%eax
80106107:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010610b:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010610f:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106113:	8d 45 de             	lea    -0x22(%ebp),%eax
80106116:	89 44 24 04          	mov    %eax,0x4(%esp)
8010611a:	8b 45 08             	mov    0x8(%ebp),%eax
8010611d:	89 04 24             	mov    %eax,(%esp)
80106120:	e8 8f c3 ff ff       	call   801024b4 <nameiparent>
80106125:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106128:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010612c:	75 0a                	jne    80106138 <create+0x40>
    return 0;
8010612e:	b8 00 00 00 00       	mov    $0x0,%eax
80106133:	e9 7e 01 00 00       	jmp    801062b6 <create+0x1be>
  ilock(dp);
80106138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010613b:	89 04 24             	mov    %eax,(%esp)
8010613e:	e8 9e b7 ff ff       	call   801018e1 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80106143:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106146:	89 44 24 08          	mov    %eax,0x8(%esp)
8010614a:	8d 45 de             	lea    -0x22(%ebp),%eax
8010614d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106154:	89 04 24             	mov    %eax,(%esp)
80106157:	e8 ad bf ff ff       	call   80102109 <dirlookup>
8010615c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010615f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106163:	74 47                	je     801061ac <create+0xb4>
    iunlockput(dp);
80106165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106168:	89 04 24             	mov    %eax,(%esp)
8010616b:	e8 fb b9 ff ff       	call   80101b6b <iunlockput>
    ilock(ip);
80106170:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106173:	89 04 24             	mov    %eax,(%esp)
80106176:	e8 66 b7 ff ff       	call   801018e1 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010617b:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106180:	75 15                	jne    80106197 <create+0x9f>
80106182:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106185:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106189:	66 83 f8 02          	cmp    $0x2,%ax
8010618d:	75 08                	jne    80106197 <create+0x9f>
      return ip;
8010618f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106192:	e9 1f 01 00 00       	jmp    801062b6 <create+0x1be>
    iunlockput(ip);
80106197:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010619a:	89 04 24             	mov    %eax,(%esp)
8010619d:	e8 c9 b9 ff ff       	call   80101b6b <iunlockput>
    return 0;
801061a2:	b8 00 00 00 00       	mov    $0x0,%eax
801061a7:	e9 0a 01 00 00       	jmp    801062b6 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801061ac:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801061b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b3:	8b 00                	mov    (%eax),%eax
801061b5:	89 54 24 04          	mov    %edx,0x4(%esp)
801061b9:	89 04 24             	mov    %eax,(%esp)
801061bc:	e8 89 b4 ff ff       	call   8010164a <ialloc>
801061c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061c8:	75 0c                	jne    801061d6 <create+0xde>
    panic("create: ialloc");
801061ca:	c7 04 24 44 90 10 80 	movl   $0x80109044,(%esp)
801061d1:	e8 64 a3 ff ff       	call   8010053a <panic>

  ilock(ip);
801061d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061d9:	89 04 24             	mov    %eax,(%esp)
801061dc:	e8 00 b7 ff ff       	call   801018e1 <ilock>
  ip->major = major;
801061e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061e4:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801061e8:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801061ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ef:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801061f3:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
801061f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061fa:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106200:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106203:	89 04 24             	mov    %eax,(%esp)
80106206:	e8 14 b5 ff ff       	call   8010171f <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
8010620b:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106210:	75 6a                	jne    8010627c <create+0x184>
    dp->nlink++;  // for ".."
80106212:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106215:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106219:	8d 50 01             	lea    0x1(%eax),%edx
8010621c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010621f:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106223:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106226:	89 04 24             	mov    %eax,(%esp)
80106229:	e8 f1 b4 ff ff       	call   8010171f <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010622e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106231:	8b 40 04             	mov    0x4(%eax),%eax
80106234:	89 44 24 08          	mov    %eax,0x8(%esp)
80106238:	c7 44 24 04 1e 90 10 	movl   $0x8010901e,0x4(%esp)
8010623f:	80 
80106240:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106243:	89 04 24             	mov    %eax,(%esp)
80106246:	e8 87 bf ff ff       	call   801021d2 <dirlink>
8010624b:	85 c0                	test   %eax,%eax
8010624d:	78 21                	js     80106270 <create+0x178>
8010624f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106252:	8b 40 04             	mov    0x4(%eax),%eax
80106255:	89 44 24 08          	mov    %eax,0x8(%esp)
80106259:	c7 44 24 04 20 90 10 	movl   $0x80109020,0x4(%esp)
80106260:	80 
80106261:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106264:	89 04 24             	mov    %eax,(%esp)
80106267:	e8 66 bf ff ff       	call   801021d2 <dirlink>
8010626c:	85 c0                	test   %eax,%eax
8010626e:	79 0c                	jns    8010627c <create+0x184>
      panic("create dots");
80106270:	c7 04 24 53 90 10 80 	movl   $0x80109053,(%esp)
80106277:	e8 be a2 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010627c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010627f:	8b 40 04             	mov    0x4(%eax),%eax
80106282:	89 44 24 08          	mov    %eax,0x8(%esp)
80106286:	8d 45 de             	lea    -0x22(%ebp),%eax
80106289:	89 44 24 04          	mov    %eax,0x4(%esp)
8010628d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106290:	89 04 24             	mov    %eax,(%esp)
80106293:	e8 3a bf ff ff       	call   801021d2 <dirlink>
80106298:	85 c0                	test   %eax,%eax
8010629a:	79 0c                	jns    801062a8 <create+0x1b0>
    panic("create: dirlink");
8010629c:	c7 04 24 5f 90 10 80 	movl   $0x8010905f,(%esp)
801062a3:	e8 92 a2 ff ff       	call   8010053a <panic>

  iunlockput(dp);
801062a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ab:	89 04 24             	mov    %eax,(%esp)
801062ae:	e8 b8 b8 ff ff       	call   80101b6b <iunlockput>

  return ip;
801062b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801062b6:	c9                   	leave  
801062b7:	c3                   	ret    

801062b8 <sys_open>:

int
sys_open(void)
{
801062b8:	55                   	push   %ebp
801062b9:	89 e5                	mov    %esp,%ebp
801062bb:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801062be:	8d 45 e8             	lea    -0x18(%ebp),%eax
801062c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801062c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062cc:	e8 d9 f6 ff ff       	call   801059aa <argstr>
801062d1:	85 c0                	test   %eax,%eax
801062d3:	78 17                	js     801062ec <sys_open+0x34>
801062d5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801062d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801062dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801062e3:	e8 32 f6 ff ff       	call   8010591a <argint>
801062e8:	85 c0                	test   %eax,%eax
801062ea:	79 0a                	jns    801062f6 <sys_open+0x3e>
    return -1;
801062ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062f1:	e9 5c 01 00 00       	jmp    80106452 <sys_open+0x19a>

  begin_op();
801062f6:	e8 ce d1 ff ff       	call   801034c9 <begin_op>

  if(omode & O_CREATE){
801062fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062fe:	25 00 02 00 00       	and    $0x200,%eax
80106303:	85 c0                	test   %eax,%eax
80106305:	74 3b                	je     80106342 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80106307:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010630a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106311:	00 
80106312:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106319:	00 
8010631a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80106321:	00 
80106322:	89 04 24             	mov    %eax,(%esp)
80106325:	e8 ce fd ff ff       	call   801060f8 <create>
8010632a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010632d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106331:	75 6b                	jne    8010639e <sys_open+0xe6>
      end_op();
80106333:	e8 15 d2 ff ff       	call   8010354d <end_op>
      return -1;
80106338:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010633d:	e9 10 01 00 00       	jmp    80106452 <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
80106342:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106345:	89 04 24             	mov    %eax,(%esp)
80106348:	e8 45 c1 ff ff       	call   80102492 <namei>
8010634d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106350:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106354:	75 0f                	jne    80106365 <sys_open+0xad>
      end_op();
80106356:	e8 f2 d1 ff ff       	call   8010354d <end_op>
      return -1;
8010635b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106360:	e9 ed 00 00 00       	jmp    80106452 <sys_open+0x19a>
    }
    ilock(ip);
80106365:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106368:	89 04 24             	mov    %eax,(%esp)
8010636b:	e8 71 b5 ff ff       	call   801018e1 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106370:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106373:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106377:	66 83 f8 01          	cmp    $0x1,%ax
8010637b:	75 21                	jne    8010639e <sys_open+0xe6>
8010637d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106380:	85 c0                	test   %eax,%eax
80106382:	74 1a                	je     8010639e <sys_open+0xe6>
      iunlockput(ip);
80106384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106387:	89 04 24             	mov    %eax,(%esp)
8010638a:	e8 dc b7 ff ff       	call   80101b6b <iunlockput>
      end_op();
8010638f:	e8 b9 d1 ff ff       	call   8010354d <end_op>
      return -1;
80106394:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106399:	e9 b4 00 00 00       	jmp    80106452 <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010639e:	e8 ab ab ff ff       	call   80100f4e <filealloc>
801063a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063aa:	74 14                	je     801063c0 <sys_open+0x108>
801063ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063af:	89 04 24             	mov    %eax,(%esp)
801063b2:	e8 2e f7 ff ff       	call   80105ae5 <fdalloc>
801063b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801063ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801063be:	79 28                	jns    801063e8 <sys_open+0x130>
    if(f)
801063c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063c4:	74 0b                	je     801063d1 <sys_open+0x119>
      fileclose(f);
801063c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063c9:	89 04 24             	mov    %eax,(%esp)
801063cc:	e8 25 ac ff ff       	call   80100ff6 <fileclose>
    iunlockput(ip);
801063d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063d4:	89 04 24             	mov    %eax,(%esp)
801063d7:	e8 8f b7 ff ff       	call   80101b6b <iunlockput>
    end_op();
801063dc:	e8 6c d1 ff ff       	call   8010354d <end_op>
    return -1;
801063e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063e6:	eb 6a                	jmp    80106452 <sys_open+0x19a>
  }
  iunlock(ip);
801063e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063eb:	89 04 24             	mov    %eax,(%esp)
801063ee:	e8 42 b6 ff ff       	call   80101a35 <iunlock>
  end_op();
801063f3:	e8 55 d1 ff ff       	call   8010354d <end_op>

  f->type = FD_INODE;
801063f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063fb:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106401:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106404:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106407:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010640a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010640d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106414:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106417:	83 e0 01             	and    $0x1,%eax
8010641a:	85 c0                	test   %eax,%eax
8010641c:	0f 94 c0             	sete   %al
8010641f:	89 c2                	mov    %eax,%edx
80106421:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106424:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010642a:	83 e0 01             	and    $0x1,%eax
8010642d:	85 c0                	test   %eax,%eax
8010642f:	75 0a                	jne    8010643b <sys_open+0x183>
80106431:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106434:	83 e0 02             	and    $0x2,%eax
80106437:	85 c0                	test   %eax,%eax
80106439:	74 07                	je     80106442 <sys_open+0x18a>
8010643b:	b8 01 00 00 00       	mov    $0x1,%eax
80106440:	eb 05                	jmp    80106447 <sys_open+0x18f>
80106442:	b8 00 00 00 00       	mov    $0x0,%eax
80106447:	89 c2                	mov    %eax,%edx
80106449:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010644c:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010644f:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106452:	c9                   	leave  
80106453:	c3                   	ret    

80106454 <sys_mkdir>:

int
sys_mkdir(void)
{
80106454:	55                   	push   %ebp
80106455:	89 e5                	mov    %esp,%ebp
80106457:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010645a:	e8 6a d0 ff ff       	call   801034c9 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010645f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106462:	89 44 24 04          	mov    %eax,0x4(%esp)
80106466:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010646d:	e8 38 f5 ff ff       	call   801059aa <argstr>
80106472:	85 c0                	test   %eax,%eax
80106474:	78 2c                	js     801064a2 <sys_mkdir+0x4e>
80106476:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106479:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106480:	00 
80106481:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106488:	00 
80106489:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106490:	00 
80106491:	89 04 24             	mov    %eax,(%esp)
80106494:	e8 5f fc ff ff       	call   801060f8 <create>
80106499:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010649c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064a0:	75 0c                	jne    801064ae <sys_mkdir+0x5a>
    end_op();
801064a2:	e8 a6 d0 ff ff       	call   8010354d <end_op>
    return -1;
801064a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064ac:	eb 15                	jmp    801064c3 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801064ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064b1:	89 04 24             	mov    %eax,(%esp)
801064b4:	e8 b2 b6 ff ff       	call   80101b6b <iunlockput>
  end_op();
801064b9:	e8 8f d0 ff ff       	call   8010354d <end_op>
  return 0;
801064be:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064c3:	c9                   	leave  
801064c4:	c3                   	ret    

801064c5 <sys_mknod>:

int
sys_mknod(void)
{
801064c5:	55                   	push   %ebp
801064c6:	89 e5                	mov    %esp,%ebp
801064c8:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801064cb:	e8 f9 cf ff ff       	call   801034c9 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801064d0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801064d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064de:	e8 c7 f4 ff ff       	call   801059aa <argstr>
801064e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064ea:	78 5e                	js     8010654a <sys_mknod+0x85>
     argint(1, &major) < 0 ||
801064ec:	8d 45 e8             	lea    -0x18(%ebp),%eax
801064ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801064f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801064fa:	e8 1b f4 ff ff       	call   8010591a <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801064ff:	85 c0                	test   %eax,%eax
80106501:	78 47                	js     8010654a <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106503:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106506:	89 44 24 04          	mov    %eax,0x4(%esp)
8010650a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106511:	e8 04 f4 ff ff       	call   8010591a <argint>
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106516:	85 c0                	test   %eax,%eax
80106518:	78 30                	js     8010654a <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010651a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010651d:	0f bf c8             	movswl %ax,%ecx
80106520:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106523:	0f bf d0             	movswl %ax,%edx
80106526:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106529:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010652d:	89 54 24 08          	mov    %edx,0x8(%esp)
80106531:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106538:	00 
80106539:	89 04 24             	mov    %eax,(%esp)
8010653c:	e8 b7 fb ff ff       	call   801060f8 <create>
80106541:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106544:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106548:	75 0c                	jne    80106556 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
8010654a:	e8 fe cf ff ff       	call   8010354d <end_op>
    return -1;
8010654f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106554:	eb 15                	jmp    8010656b <sys_mknod+0xa6>
  }
  iunlockput(ip);
80106556:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106559:	89 04 24             	mov    %eax,(%esp)
8010655c:	e8 0a b6 ff ff       	call   80101b6b <iunlockput>
  end_op();
80106561:	e8 e7 cf ff ff       	call   8010354d <end_op>
  return 0;
80106566:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010656b:	c9                   	leave  
8010656c:	c3                   	ret    

8010656d <sys_chdir>:

int
sys_chdir(void)
{
8010656d:	55                   	push   %ebp
8010656e:	89 e5                	mov    %esp,%ebp
80106570:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106573:	e8 51 cf ff ff       	call   801034c9 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106578:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010657b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010657f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106586:	e8 1f f4 ff ff       	call   801059aa <argstr>
8010658b:	85 c0                	test   %eax,%eax
8010658d:	78 14                	js     801065a3 <sys_chdir+0x36>
8010658f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106592:	89 04 24             	mov    %eax,(%esp)
80106595:	e8 f8 be ff ff       	call   80102492 <namei>
8010659a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010659d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065a1:	75 0c                	jne    801065af <sys_chdir+0x42>
    end_op();
801065a3:	e8 a5 cf ff ff       	call   8010354d <end_op>
    return -1;
801065a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ad:	eb 61                	jmp    80106610 <sys_chdir+0xa3>
  }
  ilock(ip);
801065af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065b2:	89 04 24             	mov    %eax,(%esp)
801065b5:	e8 27 b3 ff ff       	call   801018e1 <ilock>
  if(ip->type != T_DIR){
801065ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065bd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801065c1:	66 83 f8 01          	cmp    $0x1,%ax
801065c5:	74 17                	je     801065de <sys_chdir+0x71>
    iunlockput(ip);
801065c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ca:	89 04 24             	mov    %eax,(%esp)
801065cd:	e8 99 b5 ff ff       	call   80101b6b <iunlockput>
    end_op();
801065d2:	e8 76 cf ff ff       	call   8010354d <end_op>
    return -1;
801065d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065dc:	eb 32                	jmp    80106610 <sys_chdir+0xa3>
  }
  iunlock(ip);
801065de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e1:	89 04 24             	mov    %eax,(%esp)
801065e4:	e8 4c b4 ff ff       	call   80101a35 <iunlock>
  iput(proc->cwd);
801065e9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065ef:	8b 40 68             	mov    0x68(%eax),%eax
801065f2:	89 04 24             	mov    %eax,(%esp)
801065f5:	e8 a0 b4 ff ff       	call   80101a9a <iput>
  end_op();
801065fa:	e8 4e cf ff ff       	call   8010354d <end_op>
  proc->cwd = ip;
801065ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106605:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106608:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010660b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106610:	c9                   	leave  
80106611:	c3                   	ret    

80106612 <sys_exec>:

int
sys_exec(void)
{
80106612:	55                   	push   %ebp
80106613:	89 e5                	mov    %esp,%ebp
80106615:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010661b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010661e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106622:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106629:	e8 7c f3 ff ff       	call   801059aa <argstr>
8010662e:	85 c0                	test   %eax,%eax
80106630:	78 1a                	js     8010664c <sys_exec+0x3a>
80106632:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106638:	89 44 24 04          	mov    %eax,0x4(%esp)
8010663c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106643:	e8 d2 f2 ff ff       	call   8010591a <argint>
80106648:	85 c0                	test   %eax,%eax
8010664a:	79 0a                	jns    80106656 <sys_exec+0x44>
    return -1;
8010664c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106651:	e9 c8 00 00 00       	jmp    8010671e <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
80106656:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010665d:	00 
8010665e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106665:	00 
80106666:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010666c:	89 04 24             	mov    %eax,(%esp)
8010666f:	e8 64 ef ff ff       	call   801055d8 <memset>
  for(i=0;; i++){
80106674:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010667b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010667e:	83 f8 1f             	cmp    $0x1f,%eax
80106681:	76 0a                	jbe    8010668d <sys_exec+0x7b>
      return -1;
80106683:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106688:	e9 91 00 00 00       	jmp    8010671e <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010668d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106690:	c1 e0 02             	shl    $0x2,%eax
80106693:	89 c2                	mov    %eax,%edx
80106695:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010669b:	01 c2                	add    %eax,%edx
8010669d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801066a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801066a7:	89 14 24             	mov    %edx,(%esp)
801066aa:	e8 cf f1 ff ff       	call   8010587e <fetchint>
801066af:	85 c0                	test   %eax,%eax
801066b1:	79 07                	jns    801066ba <sys_exec+0xa8>
      return -1;
801066b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066b8:	eb 64                	jmp    8010671e <sys_exec+0x10c>
    if(uarg == 0){
801066ba:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801066c0:	85 c0                	test   %eax,%eax
801066c2:	75 26                	jne    801066ea <sys_exec+0xd8>
      argv[i] = 0;
801066c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c7:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801066ce:	00 00 00 00 
      break;
801066d2:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801066d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066d6:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801066dc:	89 54 24 04          	mov    %edx,0x4(%esp)
801066e0:	89 04 24             	mov    %eax,(%esp)
801066e3:	e8 22 a4 ff ff       	call   80100b0a <exec>
801066e8:	eb 34                	jmp    8010671e <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801066ea:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801066f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066f3:	c1 e2 02             	shl    $0x2,%edx
801066f6:	01 c2                	add    %eax,%edx
801066f8:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801066fe:	89 54 24 04          	mov    %edx,0x4(%esp)
80106702:	89 04 24             	mov    %eax,(%esp)
80106705:	e8 ae f1 ff ff       	call   801058b8 <fetchstr>
8010670a:	85 c0                	test   %eax,%eax
8010670c:	79 07                	jns    80106715 <sys_exec+0x103>
      return -1;
8010670e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106713:	eb 09                	jmp    8010671e <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106715:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106719:	e9 5d ff ff ff       	jmp    8010667b <sys_exec+0x69>
  return exec(path, argv);
}
8010671e:	c9                   	leave  
8010671f:	c3                   	ret    

80106720 <sys_pipe>:

int
sys_pipe(void)
{
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
80106723:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106726:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
8010672d:	00 
8010672e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106731:	89 44 24 04          	mov    %eax,0x4(%esp)
80106735:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010673c:	e8 07 f2 ff ff       	call   80105948 <argptr>
80106741:	85 c0                	test   %eax,%eax
80106743:	79 0a                	jns    8010674f <sys_pipe+0x2f>
    return -1;
80106745:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010674a:	e9 9b 00 00 00       	jmp    801067ea <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
8010674f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106752:	89 44 24 04          	mov    %eax,0x4(%esp)
80106756:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106759:	89 04 24             	mov    %eax,(%esp)
8010675c:	e8 74 d8 ff ff       	call   80103fd5 <pipealloc>
80106761:	85 c0                	test   %eax,%eax
80106763:	79 07                	jns    8010676c <sys_pipe+0x4c>
    return -1;
80106765:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010676a:	eb 7e                	jmp    801067ea <sys_pipe+0xca>
  fd0 = -1;
8010676c:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106773:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106776:	89 04 24             	mov    %eax,(%esp)
80106779:	e8 67 f3 ff ff       	call   80105ae5 <fdalloc>
8010677e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106785:	78 14                	js     8010679b <sys_pipe+0x7b>
80106787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010678a:	89 04 24             	mov    %eax,(%esp)
8010678d:	e8 53 f3 ff ff       	call   80105ae5 <fdalloc>
80106792:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106795:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106799:	79 37                	jns    801067d2 <sys_pipe+0xb2>
    if(fd0 >= 0)
8010679b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010679f:	78 14                	js     801067b5 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
801067a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067aa:	83 c2 08             	add    $0x8,%edx
801067ad:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801067b4:	00 
    fileclose(rf);
801067b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801067b8:	89 04 24             	mov    %eax,(%esp)
801067bb:	e8 36 a8 ff ff       	call   80100ff6 <fileclose>
    fileclose(wf);
801067c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067c3:	89 04 24             	mov    %eax,(%esp)
801067c6:	e8 2b a8 ff ff       	call   80100ff6 <fileclose>
    return -1;
801067cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067d0:	eb 18                	jmp    801067ea <sys_pipe+0xca>
  }
  fd[0] = fd0;
801067d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801067d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067d8:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801067da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801067dd:	8d 50 04             	lea    0x4(%eax),%edx
801067e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067e3:	89 02                	mov    %eax,(%edx)
  return 0;
801067e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067ea:	c9                   	leave  
801067eb:	c3                   	ret    

801067ec <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801067ec:	55                   	push   %ebp
801067ed:	89 e5                	mov    %esp,%ebp
801067ef:	83 ec 08             	sub    $0x8,%esp
  return fork();
801067f2:	e8 1a df ff ff       	call   80104711 <fork>
}
801067f7:	c9                   	leave  
801067f8:	c3                   	ret    

801067f9 <sys_exit>:

int
sys_exit(void)
{
801067f9:	55                   	push   %ebp
801067fa:	89 e5                	mov    %esp,%ebp
801067fc:	83 ec 08             	sub    $0x8,%esp
  exit();
801067ff:	e8 88 e0 ff ff       	call   8010488c <exit>
  return 0;  // not reached
80106804:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106809:	c9                   	leave  
8010680a:	c3                   	ret    

8010680b <sys_wait>:

int
sys_wait(void)
{
8010680b:	55                   	push   %ebp
8010680c:	89 e5                	mov    %esp,%ebp
8010680e:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106811:	e8 98 e1 ff ff       	call   801049ae <wait>
}
80106816:	c9                   	leave  
80106817:	c3                   	ret    

80106818 <sys_kill>:

int
sys_kill(void)
{
80106818:	55                   	push   %ebp
80106819:	89 e5                	mov    %esp,%ebp
8010681b:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010681e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106821:	89 44 24 04          	mov    %eax,0x4(%esp)
80106825:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010682c:	e8 e9 f0 ff ff       	call   8010591a <argint>
80106831:	85 c0                	test   %eax,%eax
80106833:	79 07                	jns    8010683c <sys_kill+0x24>
    return -1;
80106835:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010683a:	eb 0b                	jmp    80106847 <sys_kill+0x2f>
  return kill(pid);
8010683c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010683f:	89 04 24             	mov    %eax,(%esp)
80106842:	e8 51 e6 ff ff       	call   80104e98 <kill>
}
80106847:	c9                   	leave  
80106848:	c3                   	ret    

80106849 <sys_getpid>:

int
sys_getpid(void)
{
80106849:	55                   	push   %ebp
8010684a:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010684c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106852:	8b 40 10             	mov    0x10(%eax),%eax
}
80106855:	5d                   	pop    %ebp
80106856:	c3                   	ret    

80106857 <sys_sbrk>:

int
sys_sbrk(void)
{
80106857:	55                   	push   %ebp
80106858:	89 e5                	mov    %esp,%ebp
8010685a:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010685d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106860:	89 44 24 04          	mov    %eax,0x4(%esp)
80106864:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010686b:	e8 aa f0 ff ff       	call   8010591a <argint>
80106870:	85 c0                	test   %eax,%eax
80106872:	79 07                	jns    8010687b <sys_sbrk+0x24>
    return -1;
80106874:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106879:	eb 24                	jmp    8010689f <sys_sbrk+0x48>
  addr = proc->sz;
8010687b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106881:	8b 00                	mov    (%eax),%eax
80106883:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106886:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106889:	89 04 24             	mov    %eax,(%esp)
8010688c:	e8 db dd ff ff       	call   8010466c <growproc>
80106891:	85 c0                	test   %eax,%eax
80106893:	79 07                	jns    8010689c <sys_sbrk+0x45>
    return -1;
80106895:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010689a:	eb 03                	jmp    8010689f <sys_sbrk+0x48>
  return addr;
8010689c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010689f:	c9                   	leave  
801068a0:	c3                   	ret    

801068a1 <sys_sleep>:

int
sys_sleep(void)
{
801068a1:	55                   	push   %ebp
801068a2:	89 e5                	mov    %esp,%ebp
801068a4:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801068a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801068ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068b5:	e8 60 f0 ff ff       	call   8010591a <argint>
801068ba:	85 c0                	test   %eax,%eax
801068bc:	79 07                	jns    801068c5 <sys_sleep+0x24>
    return -1;
801068be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068c3:	eb 6c                	jmp    80106931 <sys_sleep+0x90>
  acquire(&tickslock);
801068c5:	c7 04 24 00 5a 11 80 	movl   $0x80115a00,(%esp)
801068cc:	e8 b3 ea ff ff       	call   80105384 <acquire>
  ticks0 = ticks;
801068d1:	a1 40 62 11 80       	mov    0x80116240,%eax
801068d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801068d9:	eb 34                	jmp    8010690f <sys_sleep+0x6e>
    if(proc->killed){
801068db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068e1:	8b 40 24             	mov    0x24(%eax),%eax
801068e4:	85 c0                	test   %eax,%eax
801068e6:	74 13                	je     801068fb <sys_sleep+0x5a>
      release(&tickslock);
801068e8:	c7 04 24 00 5a 11 80 	movl   $0x80115a00,(%esp)
801068ef:	e8 f2 ea ff ff       	call   801053e6 <release>
      return -1;
801068f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068f9:	eb 36                	jmp    80106931 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
801068fb:	c7 44 24 04 00 5a 11 	movl   $0x80115a00,0x4(%esp)
80106902:	80 
80106903:	c7 04 24 40 62 11 80 	movl   $0x80116240,(%esp)
8010690a:	e8 85 e4 ff ff       	call   80104d94 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010690f:	a1 40 62 11 80       	mov    0x80116240,%eax
80106914:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106917:	89 c2                	mov    %eax,%edx
80106919:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010691c:	39 c2                	cmp    %eax,%edx
8010691e:	72 bb                	jb     801068db <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106920:	c7 04 24 00 5a 11 80 	movl   $0x80115a00,(%esp)
80106927:	e8 ba ea ff ff       	call   801053e6 <release>
  return 0;
8010692c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106931:	c9                   	leave  
80106932:	c3                   	ret    

80106933 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106933:	55                   	push   %ebp
80106934:	89 e5                	mov    %esp,%ebp
80106936:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106939:	c7 04 24 00 5a 11 80 	movl   $0x80115a00,(%esp)
80106940:	e8 3f ea ff ff       	call   80105384 <acquire>
  xticks = ticks;
80106945:	a1 40 62 11 80       	mov    0x80116240,%eax
8010694a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010694d:	c7 04 24 00 5a 11 80 	movl   $0x80115a00,(%esp)
80106954:	e8 8d ea ff ff       	call   801053e6 <release>
  return xticks;
80106959:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010695c:	c9                   	leave  
8010695d:	c3                   	ret    

8010695e <sys_changepriority>:

int
sys_changepriority(void)
{
8010695e:	55                   	push   %ebp
8010695f:	89 e5                	mov    %esp,%ebp
80106961:	83 ec 28             	sub    $0x28,%esp
  int pid, pr;
  if(argint(0, &pid) < 0)
80106964:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106967:	89 44 24 04          	mov    %eax,0x4(%esp)
8010696b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106972:	e8 a3 ef ff ff       	call   8010591a <argint>
80106977:	85 c0                	test   %eax,%eax
80106979:	79 07                	jns    80106982 <sys_changepriority+0x24>
    return -1;
8010697b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106980:	eb 30                	jmp    801069b2 <sys_changepriority+0x54>
  if(argint(1, &pr) < 0)
80106982:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106985:	89 44 24 04          	mov    %eax,0x4(%esp)
80106989:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106990:	e8 85 ef ff ff       	call   8010591a <argint>
80106995:	85 c0                	test   %eax,%eax
80106997:	79 07                	jns    801069a0 <sys_changepriority+0x42>
    return -1;
80106999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010699e:	eb 12                	jmp    801069b2 <sys_changepriority+0x54>

  return changepriority(pid, pr);
801069a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801069a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069a6:	89 54 24 04          	mov    %edx,0x4(%esp)
801069aa:	89 04 24             	mov    %eax,(%esp)
801069ad:	e8 55 e6 ff ff       	call   80105007 <changepriority>
}
801069b2:	c9                   	leave  
801069b3:	c3                   	ret    

801069b4 <sys_processstatus>:

int
sys_processstatus(void)
{
801069b4:	55                   	push   %ebp
801069b5:	89 e5                	mov    %esp,%ebp
801069b7:	83 ec 08             	sub    $0x8,%esp
  return processstatus();
801069ba:	e8 97 e6 ff ff       	call   80105056 <processstatus>
}
801069bf:	c9                   	leave  
801069c0:	c3                   	ret    

801069c1 <sys_randomgen>:

uint
sys_randomgen(void)
{
801069c1:	55                   	push   %ebp
801069c2:	89 e5                	mov    %esp,%ebp
801069c4:	83 ec 08             	sub    $0x8,%esp
  return randomgen();
801069c7:	e8 80 e7 ff ff       	call   8010514c <randomgen>
}
801069cc:	c9                   	leave  
801069cd:	c3                   	ret    

801069ce <sys_randomgenrange>:

int
sys_randomgenrange(void)
{
801069ce:	55                   	push   %ebp
801069cf:	89 e5                	mov    %esp,%ebp
801069d1:	83 ec 28             	sub    $0x28,%esp
  int low, high;
  if(argint(0, &low) < 0)
801069d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801069db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069e2:	e8 33 ef ff ff       	call   8010591a <argint>
801069e7:	85 c0                	test   %eax,%eax
801069e9:	79 07                	jns    801069f2 <sys_randomgenrange+0x24>
    return -1;
801069eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069f0:	eb 30                	jmp    80106a22 <sys_randomgenrange+0x54>
  if(argint(1, &high) < 0)
801069f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801069f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106a00:	e8 15 ef ff ff       	call   8010591a <argint>
80106a05:	85 c0                	test   %eax,%eax
80106a07:	79 07                	jns    80106a10 <sys_randomgenrange+0x42>
    return -1;
80106a09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a0e:	eb 12                	jmp    80106a22 <sys_randomgenrange+0x54>
  return randomgenrange(low,high);
80106a10:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a16:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a1a:	89 04 24             	mov    %eax,(%esp)
80106a1d:	e8 fb e7 ff ff       	call   8010521d <randomgenrange>
}
80106a22:	c9                   	leave  
80106a23:	c3                   	ret    

80106a24 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106a24:	55                   	push   %ebp
80106a25:	89 e5                	mov    %esp,%ebp
80106a27:	83 ec 08             	sub    $0x8,%esp
80106a2a:	8b 55 08             	mov    0x8(%ebp),%edx
80106a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a30:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106a34:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a37:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106a3b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106a3f:	ee                   	out    %al,(%dx)
}
80106a40:	c9                   	leave  
80106a41:	c3                   	ret    

80106a42 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106a42:	55                   	push   %ebp
80106a43:	89 e5                	mov    %esp,%ebp
80106a45:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106a48:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106a4f:	00 
80106a50:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106a57:	e8 c8 ff ff ff       	call   80106a24 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106a5c:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106a63:	00 
80106a64:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106a6b:	e8 b4 ff ff ff       	call   80106a24 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106a70:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106a77:	00 
80106a78:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106a7f:	e8 a0 ff ff ff       	call   80106a24 <outb>
  picenable(IRQ_TIMER);
80106a84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a8b:	e8 d8 d3 ff ff       	call   80103e68 <picenable>
}
80106a90:	c9                   	leave  
80106a91:	c3                   	ret    

80106a92 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106a92:	1e                   	push   %ds
  pushl %es
80106a93:	06                   	push   %es
  pushl %fs
80106a94:	0f a0                	push   %fs
  pushl %gs
80106a96:	0f a8                	push   %gs
  pushal
80106a98:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106a99:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106a9d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106a9f:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106aa1:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106aa5:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106aa7:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106aa9:	54                   	push   %esp
  call trap
80106aaa:	e8 d8 01 00 00       	call   80106c87 <trap>
  addl $4, %esp
80106aaf:	83 c4 04             	add    $0x4,%esp

80106ab2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106ab2:	61                   	popa   
  popl %gs
80106ab3:	0f a9                	pop    %gs
  popl %fs
80106ab5:	0f a1                	pop    %fs
  popl %es
80106ab7:	07                   	pop    %es
  popl %ds
80106ab8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106ab9:	83 c4 08             	add    $0x8,%esp
  iret
80106abc:	cf                   	iret   

80106abd <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106abd:	55                   	push   %ebp
80106abe:	89 e5                	mov    %esp,%ebp
80106ac0:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ac6:	83 e8 01             	sub    $0x1,%eax
80106ac9:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106acd:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106ad4:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad7:	c1 e8 10             	shr    $0x10,%eax
80106ada:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106ade:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106ae1:	0f 01 18             	lidtl  (%eax)
}
80106ae4:	c9                   	leave  
80106ae5:	c3                   	ret    

80106ae6 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106ae6:	55                   	push   %ebp
80106ae7:	89 e5                	mov    %esp,%ebp
80106ae9:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106aec:	0f 20 d0             	mov    %cr2,%eax
80106aef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106af2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106af5:	c9                   	leave  
80106af6:	c3                   	ret    

80106af7 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106af7:	55                   	push   %ebp
80106af8:	89 e5                	mov    %esp,%ebp
80106afa:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106afd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106b04:	e9 c3 00 00 00       	jmp    80106bcc <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b0c:	8b 04 85 c8 c0 10 80 	mov    -0x7fef3f38(,%eax,4),%eax
80106b13:	89 c2                	mov    %eax,%edx
80106b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b18:	66 89 14 c5 40 5a 11 	mov    %dx,-0x7feea5c0(,%eax,8)
80106b1f:	80 
80106b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b23:	66 c7 04 c5 42 5a 11 	movw   $0x8,-0x7feea5be(,%eax,8)
80106b2a:	80 08 00 
80106b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b30:	0f b6 14 c5 44 5a 11 	movzbl -0x7feea5bc(,%eax,8),%edx
80106b37:	80 
80106b38:	83 e2 e0             	and    $0xffffffe0,%edx
80106b3b:	88 14 c5 44 5a 11 80 	mov    %dl,-0x7feea5bc(,%eax,8)
80106b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b45:	0f b6 14 c5 44 5a 11 	movzbl -0x7feea5bc(,%eax,8),%edx
80106b4c:	80 
80106b4d:	83 e2 1f             	and    $0x1f,%edx
80106b50:	88 14 c5 44 5a 11 80 	mov    %dl,-0x7feea5bc(,%eax,8)
80106b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b5a:	0f b6 14 c5 45 5a 11 	movzbl -0x7feea5bb(,%eax,8),%edx
80106b61:	80 
80106b62:	83 e2 f0             	and    $0xfffffff0,%edx
80106b65:	83 ca 0e             	or     $0xe,%edx
80106b68:	88 14 c5 45 5a 11 80 	mov    %dl,-0x7feea5bb(,%eax,8)
80106b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b72:	0f b6 14 c5 45 5a 11 	movzbl -0x7feea5bb(,%eax,8),%edx
80106b79:	80 
80106b7a:	83 e2 ef             	and    $0xffffffef,%edx
80106b7d:	88 14 c5 45 5a 11 80 	mov    %dl,-0x7feea5bb(,%eax,8)
80106b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b87:	0f b6 14 c5 45 5a 11 	movzbl -0x7feea5bb(,%eax,8),%edx
80106b8e:	80 
80106b8f:	83 e2 9f             	and    $0xffffff9f,%edx
80106b92:	88 14 c5 45 5a 11 80 	mov    %dl,-0x7feea5bb(,%eax,8)
80106b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b9c:	0f b6 14 c5 45 5a 11 	movzbl -0x7feea5bb(,%eax,8),%edx
80106ba3:	80 
80106ba4:	83 ca 80             	or     $0xffffff80,%edx
80106ba7:	88 14 c5 45 5a 11 80 	mov    %dl,-0x7feea5bb(,%eax,8)
80106bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bb1:	8b 04 85 c8 c0 10 80 	mov    -0x7fef3f38(,%eax,4),%eax
80106bb8:	c1 e8 10             	shr    $0x10,%eax
80106bbb:	89 c2                	mov    %eax,%edx
80106bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bc0:	66 89 14 c5 46 5a 11 	mov    %dx,-0x7feea5ba(,%eax,8)
80106bc7:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106bc8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106bcc:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106bd3:	0f 8e 30 ff ff ff    	jle    80106b09 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106bd9:	a1 c8 c1 10 80       	mov    0x8010c1c8,%eax
80106bde:	66 a3 40 5c 11 80    	mov    %ax,0x80115c40
80106be4:	66 c7 05 42 5c 11 80 	movw   $0x8,0x80115c42
80106beb:	08 00 
80106bed:	0f b6 05 44 5c 11 80 	movzbl 0x80115c44,%eax
80106bf4:	83 e0 e0             	and    $0xffffffe0,%eax
80106bf7:	a2 44 5c 11 80       	mov    %al,0x80115c44
80106bfc:	0f b6 05 44 5c 11 80 	movzbl 0x80115c44,%eax
80106c03:	83 e0 1f             	and    $0x1f,%eax
80106c06:	a2 44 5c 11 80       	mov    %al,0x80115c44
80106c0b:	0f b6 05 45 5c 11 80 	movzbl 0x80115c45,%eax
80106c12:	83 c8 0f             	or     $0xf,%eax
80106c15:	a2 45 5c 11 80       	mov    %al,0x80115c45
80106c1a:	0f b6 05 45 5c 11 80 	movzbl 0x80115c45,%eax
80106c21:	83 e0 ef             	and    $0xffffffef,%eax
80106c24:	a2 45 5c 11 80       	mov    %al,0x80115c45
80106c29:	0f b6 05 45 5c 11 80 	movzbl 0x80115c45,%eax
80106c30:	83 c8 60             	or     $0x60,%eax
80106c33:	a2 45 5c 11 80       	mov    %al,0x80115c45
80106c38:	0f b6 05 45 5c 11 80 	movzbl 0x80115c45,%eax
80106c3f:	83 c8 80             	or     $0xffffff80,%eax
80106c42:	a2 45 5c 11 80       	mov    %al,0x80115c45
80106c47:	a1 c8 c1 10 80       	mov    0x8010c1c8,%eax
80106c4c:	c1 e8 10             	shr    $0x10,%eax
80106c4f:	66 a3 46 5c 11 80    	mov    %ax,0x80115c46
  
  initlock(&tickslock, "time");
80106c55:	c7 44 24 04 70 90 10 	movl   $0x80109070,0x4(%esp)
80106c5c:	80 
80106c5d:	c7 04 24 00 5a 11 80 	movl   $0x80115a00,(%esp)
80106c64:	e8 fa e6 ff ff       	call   80105363 <initlock>
}
80106c69:	c9                   	leave  
80106c6a:	c3                   	ret    

80106c6b <idtinit>:

void
idtinit(void)
{
80106c6b:	55                   	push   %ebp
80106c6c:	89 e5                	mov    %esp,%ebp
80106c6e:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106c71:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106c78:	00 
80106c79:	c7 04 24 40 5a 11 80 	movl   $0x80115a40,(%esp)
80106c80:	e8 38 fe ff ff       	call   80106abd <lidt>
}
80106c85:	c9                   	leave  
80106c86:	c3                   	ret    

80106c87 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106c87:	55                   	push   %ebp
80106c88:	89 e5                	mov    %esp,%ebp
80106c8a:	57                   	push   %edi
80106c8b:	56                   	push   %esi
80106c8c:	53                   	push   %ebx
80106c8d:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106c90:	8b 45 08             	mov    0x8(%ebp),%eax
80106c93:	8b 40 30             	mov    0x30(%eax),%eax
80106c96:	83 f8 40             	cmp    $0x40,%eax
80106c99:	75 3f                	jne    80106cda <trap+0x53>
    if(proc->killed)
80106c9b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ca1:	8b 40 24             	mov    0x24(%eax),%eax
80106ca4:	85 c0                	test   %eax,%eax
80106ca6:	74 05                	je     80106cad <trap+0x26>
      exit();
80106ca8:	e8 df db ff ff       	call   8010488c <exit>
    proc->tf = tf;
80106cad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cb3:	8b 55 08             	mov    0x8(%ebp),%edx
80106cb6:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106cb9:	e8 23 ed ff ff       	call   801059e1 <syscall>
    if(proc->killed)
80106cbe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cc4:	8b 40 24             	mov    0x24(%eax),%eax
80106cc7:	85 c0                	test   %eax,%eax
80106cc9:	74 0a                	je     80106cd5 <trap+0x4e>
      exit();
80106ccb:	e8 bc db ff ff       	call   8010488c <exit>
    return;
80106cd0:	e9 2d 02 00 00       	jmp    80106f02 <trap+0x27b>
80106cd5:	e9 28 02 00 00       	jmp    80106f02 <trap+0x27b>
  }

  switch(tf->trapno){
80106cda:	8b 45 08             	mov    0x8(%ebp),%eax
80106cdd:	8b 40 30             	mov    0x30(%eax),%eax
80106ce0:	83 e8 20             	sub    $0x20,%eax
80106ce3:	83 f8 1f             	cmp    $0x1f,%eax
80106ce6:	0f 87 bc 00 00 00    	ja     80106da8 <trap+0x121>
80106cec:	8b 04 85 18 91 10 80 	mov    -0x7fef6ee8(,%eax,4),%eax
80106cf3:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106cf5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106cfb:	0f b6 00             	movzbl (%eax),%eax
80106cfe:	84 c0                	test   %al,%al
80106d00:	75 31                	jne    80106d33 <trap+0xac>
      acquire(&tickslock);
80106d02:	c7 04 24 00 5a 11 80 	movl   $0x80115a00,(%esp)
80106d09:	e8 76 e6 ff ff       	call   80105384 <acquire>
      ticks++;
80106d0e:	a1 40 62 11 80       	mov    0x80116240,%eax
80106d13:	83 c0 01             	add    $0x1,%eax
80106d16:	a3 40 62 11 80       	mov    %eax,0x80116240
      wakeup(&ticks);
80106d1b:	c7 04 24 40 62 11 80 	movl   $0x80116240,(%esp)
80106d22:	e8 46 e1 ff ff       	call   80104e6d <wakeup>
      release(&tickslock);
80106d27:	c7 04 24 00 5a 11 80 	movl   $0x80115a00,(%esp)
80106d2e:	e8 b3 e6 ff ff       	call   801053e6 <release>
    }
    lapiceoi();
80106d33:	e8 5b c2 ff ff       	call   80102f93 <lapiceoi>
    break;
80106d38:	e9 41 01 00 00       	jmp    80106e7e <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106d3d:	e8 5f ba ff ff       	call   801027a1 <ideintr>
    lapiceoi();
80106d42:	e8 4c c2 ff ff       	call   80102f93 <lapiceoi>
    break;
80106d47:	e9 32 01 00 00       	jmp    80106e7e <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106d4c:	e8 11 c0 ff ff       	call   80102d62 <kbdintr>
    lapiceoi();
80106d51:	e8 3d c2 ff ff       	call   80102f93 <lapiceoi>
    break;
80106d56:	e9 23 01 00 00       	jmp    80106e7e <trap+0x1f7>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106d5b:	e8 97 03 00 00       	call   801070f7 <uartintr>
    lapiceoi();
80106d60:	e8 2e c2 ff ff       	call   80102f93 <lapiceoi>
    break;
80106d65:	e9 14 01 00 00       	jmp    80106e7e <trap+0x1f7>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d6a:	8b 45 08             	mov    0x8(%ebp),%eax
80106d6d:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106d70:	8b 45 08             	mov    0x8(%ebp),%eax
80106d73:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d77:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106d7a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106d80:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d83:	0f b6 c0             	movzbl %al,%eax
80106d86:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106d8a:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d92:	c7 04 24 78 90 10 80 	movl   $0x80109078,(%esp)
80106d99:	e8 02 96 ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106d9e:	e8 f0 c1 ff ff       	call   80102f93 <lapiceoi>
    break;
80106da3:	e9 d6 00 00 00       	jmp    80106e7e <trap+0x1f7>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106da8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dae:	85 c0                	test   %eax,%eax
80106db0:	74 11                	je     80106dc3 <trap+0x13c>
80106db2:	8b 45 08             	mov    0x8(%ebp),%eax
80106db5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106db9:	0f b7 c0             	movzwl %ax,%eax
80106dbc:	83 e0 03             	and    $0x3,%eax
80106dbf:	85 c0                	test   %eax,%eax
80106dc1:	75 46                	jne    80106e09 <trap+0x182>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106dc3:	e8 1e fd ff ff       	call   80106ae6 <rcr2>
80106dc8:	8b 55 08             	mov    0x8(%ebp),%edx
80106dcb:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106dce:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106dd5:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106dd8:	0f b6 ca             	movzbl %dl,%ecx
80106ddb:	8b 55 08             	mov    0x8(%ebp),%edx
80106dde:	8b 52 30             	mov    0x30(%edx),%edx
80106de1:	89 44 24 10          	mov    %eax,0x10(%esp)
80106de5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106de9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106ded:	89 54 24 04          	mov    %edx,0x4(%esp)
80106df1:	c7 04 24 9c 90 10 80 	movl   $0x8010909c,(%esp)
80106df8:	e8 a3 95 ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106dfd:	c7 04 24 ce 90 10 80 	movl   $0x801090ce,(%esp)
80106e04:	e8 31 97 ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e09:	e8 d8 fc ff ff       	call   80106ae6 <rcr2>
80106e0e:	89 c2                	mov    %eax,%edx
80106e10:	8b 45 08             	mov    0x8(%ebp),%eax
80106e13:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106e16:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e1c:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e1f:	0f b6 f0             	movzbl %al,%esi
80106e22:	8b 45 08             	mov    0x8(%ebp),%eax
80106e25:	8b 58 34             	mov    0x34(%eax),%ebx
80106e28:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2b:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106e2e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e34:	83 c0 6c             	add    $0x6c,%eax
80106e37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e40:	8b 40 10             	mov    0x10(%eax),%eax
80106e43:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106e47:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106e4b:	89 74 24 14          	mov    %esi,0x14(%esp)
80106e4f:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106e53:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106e57:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80106e5a:	89 74 24 08          	mov    %esi,0x8(%esp)
80106e5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e62:	c7 04 24 d4 90 10 80 	movl   $0x801090d4,(%esp)
80106e69:	e8 32 95 ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106e6e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e74:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106e7b:	eb 01                	jmp    80106e7e <trap+0x1f7>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106e7d:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106e7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e84:	85 c0                	test   %eax,%eax
80106e86:	74 24                	je     80106eac <trap+0x225>
80106e88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e8e:	8b 40 24             	mov    0x24(%eax),%eax
80106e91:	85 c0                	test   %eax,%eax
80106e93:	74 17                	je     80106eac <trap+0x225>
80106e95:	8b 45 08             	mov    0x8(%ebp),%eax
80106e98:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e9c:	0f b7 c0             	movzwl %ax,%eax
80106e9f:	83 e0 03             	and    $0x3,%eax
80106ea2:	83 f8 03             	cmp    $0x3,%eax
80106ea5:	75 05                	jne    80106eac <trap+0x225>
    exit();
80106ea7:	e8 e0 d9 ff ff       	call   8010488c <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106eac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106eb2:	85 c0                	test   %eax,%eax
80106eb4:	74 1e                	je     80106ed4 <trap+0x24d>
80106eb6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ebc:	8b 40 0c             	mov    0xc(%eax),%eax
80106ebf:	83 f8 04             	cmp    $0x4,%eax
80106ec2:	75 10                	jne    80106ed4 <trap+0x24d>
80106ec4:	8b 45 08             	mov    0x8(%ebp),%eax
80106ec7:	8b 40 30             	mov    0x30(%eax),%eax
80106eca:	83 f8 20             	cmp    $0x20,%eax
80106ecd:	75 05                	jne    80106ed4 <trap+0x24d>
    yield();
80106ecf:	e8 4f de ff ff       	call   80104d23 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106ed4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106eda:	85 c0                	test   %eax,%eax
80106edc:	74 24                	je     80106f02 <trap+0x27b>
80106ede:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ee4:	8b 40 24             	mov    0x24(%eax),%eax
80106ee7:	85 c0                	test   %eax,%eax
80106ee9:	74 17                	je     80106f02 <trap+0x27b>
80106eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80106eee:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106ef2:	0f b7 c0             	movzwl %ax,%eax
80106ef5:	83 e0 03             	and    $0x3,%eax
80106ef8:	83 f8 03             	cmp    $0x3,%eax
80106efb:	75 05                	jne    80106f02 <trap+0x27b>
    exit();
80106efd:	e8 8a d9 ff ff       	call   8010488c <exit>
}
80106f02:	83 c4 3c             	add    $0x3c,%esp
80106f05:	5b                   	pop    %ebx
80106f06:	5e                   	pop    %esi
80106f07:	5f                   	pop    %edi
80106f08:	5d                   	pop    %ebp
80106f09:	c3                   	ret    

80106f0a <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106f0a:	55                   	push   %ebp
80106f0b:	89 e5                	mov    %esp,%ebp
80106f0d:	83 ec 14             	sub    $0x14,%esp
80106f10:	8b 45 08             	mov    0x8(%ebp),%eax
80106f13:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106f17:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106f1b:	89 c2                	mov    %eax,%edx
80106f1d:	ec                   	in     (%dx),%al
80106f1e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106f21:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106f25:	c9                   	leave  
80106f26:	c3                   	ret    

80106f27 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106f27:	55                   	push   %ebp
80106f28:	89 e5                	mov    %esp,%ebp
80106f2a:	83 ec 08             	sub    $0x8,%esp
80106f2d:	8b 55 08             	mov    0x8(%ebp),%edx
80106f30:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f33:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106f37:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106f3a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106f3e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106f42:	ee                   	out    %al,(%dx)
}
80106f43:	c9                   	leave  
80106f44:	c3                   	ret    

80106f45 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106f45:	55                   	push   %ebp
80106f46:	89 e5                	mov    %esp,%ebp
80106f48:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106f4b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106f52:	00 
80106f53:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106f5a:	e8 c8 ff ff ff       	call   80106f27 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106f5f:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106f66:	00 
80106f67:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106f6e:	e8 b4 ff ff ff       	call   80106f27 <outb>
  outb(COM1+0, 115200/9600);
80106f73:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106f7a:	00 
80106f7b:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106f82:	e8 a0 ff ff ff       	call   80106f27 <outb>
  outb(COM1+1, 0);
80106f87:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106f8e:	00 
80106f8f:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106f96:	e8 8c ff ff ff       	call   80106f27 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106f9b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106fa2:	00 
80106fa3:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106faa:	e8 78 ff ff ff       	call   80106f27 <outb>
  outb(COM1+4, 0);
80106faf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106fb6:	00 
80106fb7:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106fbe:	e8 64 ff ff ff       	call   80106f27 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106fc3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106fca:	00 
80106fcb:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106fd2:	e8 50 ff ff ff       	call   80106f27 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106fd7:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106fde:	e8 27 ff ff ff       	call   80106f0a <inb>
80106fe3:	3c ff                	cmp    $0xff,%al
80106fe5:	75 02                	jne    80106fe9 <uartinit+0xa4>
    return;
80106fe7:	eb 6a                	jmp    80107053 <uartinit+0x10e>
  uart = 1;
80106fe9:	c7 05 ac c6 10 80 01 	movl   $0x1,0x8010c6ac
80106ff0:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106ff3:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106ffa:	e8 0b ff ff ff       	call   80106f0a <inb>
  inb(COM1+0);
80106fff:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107006:	e8 ff fe ff ff       	call   80106f0a <inb>
  picenable(IRQ_COM1);
8010700b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107012:	e8 51 ce ff ff       	call   80103e68 <picenable>
  ioapicenable(IRQ_COM1, 0);
80107017:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010701e:	00 
8010701f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107026:	e8 f5 b9 ff ff       	call   80102a20 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010702b:	c7 45 f4 98 91 10 80 	movl   $0x80109198,-0xc(%ebp)
80107032:	eb 15                	jmp    80107049 <uartinit+0x104>
    uartputc(*p);
80107034:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107037:	0f b6 00             	movzbl (%eax),%eax
8010703a:	0f be c0             	movsbl %al,%eax
8010703d:	89 04 24             	mov    %eax,(%esp)
80107040:	e8 10 00 00 00       	call   80107055 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107045:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107049:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010704c:	0f b6 00             	movzbl (%eax),%eax
8010704f:	84 c0                	test   %al,%al
80107051:	75 e1                	jne    80107034 <uartinit+0xef>
    uartputc(*p);
}
80107053:	c9                   	leave  
80107054:	c3                   	ret    

80107055 <uartputc>:

void
uartputc(int c)
{
80107055:	55                   	push   %ebp
80107056:	89 e5                	mov    %esp,%ebp
80107058:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
8010705b:	a1 ac c6 10 80       	mov    0x8010c6ac,%eax
80107060:	85 c0                	test   %eax,%eax
80107062:	75 02                	jne    80107066 <uartputc+0x11>
    return;
80107064:	eb 4b                	jmp    801070b1 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107066:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010706d:	eb 10                	jmp    8010707f <uartputc+0x2a>
    microdelay(10);
8010706f:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80107076:	e8 3d bf ff ff       	call   80102fb8 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010707b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010707f:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107083:	7f 16                	jg     8010709b <uartputc+0x46>
80107085:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010708c:	e8 79 fe ff ff       	call   80106f0a <inb>
80107091:	0f b6 c0             	movzbl %al,%eax
80107094:	83 e0 20             	and    $0x20,%eax
80107097:	85 c0                	test   %eax,%eax
80107099:	74 d4                	je     8010706f <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
8010709b:	8b 45 08             	mov    0x8(%ebp),%eax
8010709e:	0f b6 c0             	movzbl %al,%eax
801070a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801070a5:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801070ac:	e8 76 fe ff ff       	call   80106f27 <outb>
}
801070b1:	c9                   	leave  
801070b2:	c3                   	ret    

801070b3 <uartgetc>:

static int
uartgetc(void)
{
801070b3:	55                   	push   %ebp
801070b4:	89 e5                	mov    %esp,%ebp
801070b6:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801070b9:	a1 ac c6 10 80       	mov    0x8010c6ac,%eax
801070be:	85 c0                	test   %eax,%eax
801070c0:	75 07                	jne    801070c9 <uartgetc+0x16>
    return -1;
801070c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070c7:	eb 2c                	jmp    801070f5 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
801070c9:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801070d0:	e8 35 fe ff ff       	call   80106f0a <inb>
801070d5:	0f b6 c0             	movzbl %al,%eax
801070d8:	83 e0 01             	and    $0x1,%eax
801070db:	85 c0                	test   %eax,%eax
801070dd:	75 07                	jne    801070e6 <uartgetc+0x33>
    return -1;
801070df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070e4:	eb 0f                	jmp    801070f5 <uartgetc+0x42>
  return inb(COM1+0);
801070e6:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801070ed:	e8 18 fe ff ff       	call   80106f0a <inb>
801070f2:	0f b6 c0             	movzbl %al,%eax
}
801070f5:	c9                   	leave  
801070f6:	c3                   	ret    

801070f7 <uartintr>:

void
uartintr(void)
{
801070f7:	55                   	push   %ebp
801070f8:	89 e5                	mov    %esp,%ebp
801070fa:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801070fd:	c7 04 24 b3 70 10 80 	movl   $0x801070b3,(%esp)
80107104:	e8 bf 96 ff ff       	call   801007c8 <consoleintr>
}
80107109:	c9                   	leave  
8010710a:	c3                   	ret    

8010710b <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $0
8010710d:	6a 00                	push   $0x0
  jmp alltraps
8010710f:	e9 7e f9 ff ff       	jmp    80106a92 <alltraps>

80107114 <vector1>:
.globl vector1
vector1:
  pushl $0
80107114:	6a 00                	push   $0x0
  pushl $1
80107116:	6a 01                	push   $0x1
  jmp alltraps
80107118:	e9 75 f9 ff ff       	jmp    80106a92 <alltraps>

8010711d <vector2>:
.globl vector2
vector2:
  pushl $0
8010711d:	6a 00                	push   $0x0
  pushl $2
8010711f:	6a 02                	push   $0x2
  jmp alltraps
80107121:	e9 6c f9 ff ff       	jmp    80106a92 <alltraps>

80107126 <vector3>:
.globl vector3
vector3:
  pushl $0
80107126:	6a 00                	push   $0x0
  pushl $3
80107128:	6a 03                	push   $0x3
  jmp alltraps
8010712a:	e9 63 f9 ff ff       	jmp    80106a92 <alltraps>

8010712f <vector4>:
.globl vector4
vector4:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $4
80107131:	6a 04                	push   $0x4
  jmp alltraps
80107133:	e9 5a f9 ff ff       	jmp    80106a92 <alltraps>

80107138 <vector5>:
.globl vector5
vector5:
  pushl $0
80107138:	6a 00                	push   $0x0
  pushl $5
8010713a:	6a 05                	push   $0x5
  jmp alltraps
8010713c:	e9 51 f9 ff ff       	jmp    80106a92 <alltraps>

80107141 <vector6>:
.globl vector6
vector6:
  pushl $0
80107141:	6a 00                	push   $0x0
  pushl $6
80107143:	6a 06                	push   $0x6
  jmp alltraps
80107145:	e9 48 f9 ff ff       	jmp    80106a92 <alltraps>

8010714a <vector7>:
.globl vector7
vector7:
  pushl $0
8010714a:	6a 00                	push   $0x0
  pushl $7
8010714c:	6a 07                	push   $0x7
  jmp alltraps
8010714e:	e9 3f f9 ff ff       	jmp    80106a92 <alltraps>

80107153 <vector8>:
.globl vector8
vector8:
  pushl $8
80107153:	6a 08                	push   $0x8
  jmp alltraps
80107155:	e9 38 f9 ff ff       	jmp    80106a92 <alltraps>

8010715a <vector9>:
.globl vector9
vector9:
  pushl $0
8010715a:	6a 00                	push   $0x0
  pushl $9
8010715c:	6a 09                	push   $0x9
  jmp alltraps
8010715e:	e9 2f f9 ff ff       	jmp    80106a92 <alltraps>

80107163 <vector10>:
.globl vector10
vector10:
  pushl $10
80107163:	6a 0a                	push   $0xa
  jmp alltraps
80107165:	e9 28 f9 ff ff       	jmp    80106a92 <alltraps>

8010716a <vector11>:
.globl vector11
vector11:
  pushl $11
8010716a:	6a 0b                	push   $0xb
  jmp alltraps
8010716c:	e9 21 f9 ff ff       	jmp    80106a92 <alltraps>

80107171 <vector12>:
.globl vector12
vector12:
  pushl $12
80107171:	6a 0c                	push   $0xc
  jmp alltraps
80107173:	e9 1a f9 ff ff       	jmp    80106a92 <alltraps>

80107178 <vector13>:
.globl vector13
vector13:
  pushl $13
80107178:	6a 0d                	push   $0xd
  jmp alltraps
8010717a:	e9 13 f9 ff ff       	jmp    80106a92 <alltraps>

8010717f <vector14>:
.globl vector14
vector14:
  pushl $14
8010717f:	6a 0e                	push   $0xe
  jmp alltraps
80107181:	e9 0c f9 ff ff       	jmp    80106a92 <alltraps>

80107186 <vector15>:
.globl vector15
vector15:
  pushl $0
80107186:	6a 00                	push   $0x0
  pushl $15
80107188:	6a 0f                	push   $0xf
  jmp alltraps
8010718a:	e9 03 f9 ff ff       	jmp    80106a92 <alltraps>

8010718f <vector16>:
.globl vector16
vector16:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $16
80107191:	6a 10                	push   $0x10
  jmp alltraps
80107193:	e9 fa f8 ff ff       	jmp    80106a92 <alltraps>

80107198 <vector17>:
.globl vector17
vector17:
  pushl $17
80107198:	6a 11                	push   $0x11
  jmp alltraps
8010719a:	e9 f3 f8 ff ff       	jmp    80106a92 <alltraps>

8010719f <vector18>:
.globl vector18
vector18:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $18
801071a1:	6a 12                	push   $0x12
  jmp alltraps
801071a3:	e9 ea f8 ff ff       	jmp    80106a92 <alltraps>

801071a8 <vector19>:
.globl vector19
vector19:
  pushl $0
801071a8:	6a 00                	push   $0x0
  pushl $19
801071aa:	6a 13                	push   $0x13
  jmp alltraps
801071ac:	e9 e1 f8 ff ff       	jmp    80106a92 <alltraps>

801071b1 <vector20>:
.globl vector20
vector20:
  pushl $0
801071b1:	6a 00                	push   $0x0
  pushl $20
801071b3:	6a 14                	push   $0x14
  jmp alltraps
801071b5:	e9 d8 f8 ff ff       	jmp    80106a92 <alltraps>

801071ba <vector21>:
.globl vector21
vector21:
  pushl $0
801071ba:	6a 00                	push   $0x0
  pushl $21
801071bc:	6a 15                	push   $0x15
  jmp alltraps
801071be:	e9 cf f8 ff ff       	jmp    80106a92 <alltraps>

801071c3 <vector22>:
.globl vector22
vector22:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $22
801071c5:	6a 16                	push   $0x16
  jmp alltraps
801071c7:	e9 c6 f8 ff ff       	jmp    80106a92 <alltraps>

801071cc <vector23>:
.globl vector23
vector23:
  pushl $0
801071cc:	6a 00                	push   $0x0
  pushl $23
801071ce:	6a 17                	push   $0x17
  jmp alltraps
801071d0:	e9 bd f8 ff ff       	jmp    80106a92 <alltraps>

801071d5 <vector24>:
.globl vector24
vector24:
  pushl $0
801071d5:	6a 00                	push   $0x0
  pushl $24
801071d7:	6a 18                	push   $0x18
  jmp alltraps
801071d9:	e9 b4 f8 ff ff       	jmp    80106a92 <alltraps>

801071de <vector25>:
.globl vector25
vector25:
  pushl $0
801071de:	6a 00                	push   $0x0
  pushl $25
801071e0:	6a 19                	push   $0x19
  jmp alltraps
801071e2:	e9 ab f8 ff ff       	jmp    80106a92 <alltraps>

801071e7 <vector26>:
.globl vector26
vector26:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $26
801071e9:	6a 1a                	push   $0x1a
  jmp alltraps
801071eb:	e9 a2 f8 ff ff       	jmp    80106a92 <alltraps>

801071f0 <vector27>:
.globl vector27
vector27:
  pushl $0
801071f0:	6a 00                	push   $0x0
  pushl $27
801071f2:	6a 1b                	push   $0x1b
  jmp alltraps
801071f4:	e9 99 f8 ff ff       	jmp    80106a92 <alltraps>

801071f9 <vector28>:
.globl vector28
vector28:
  pushl $0
801071f9:	6a 00                	push   $0x0
  pushl $28
801071fb:	6a 1c                	push   $0x1c
  jmp alltraps
801071fd:	e9 90 f8 ff ff       	jmp    80106a92 <alltraps>

80107202 <vector29>:
.globl vector29
vector29:
  pushl $0
80107202:	6a 00                	push   $0x0
  pushl $29
80107204:	6a 1d                	push   $0x1d
  jmp alltraps
80107206:	e9 87 f8 ff ff       	jmp    80106a92 <alltraps>

8010720b <vector30>:
.globl vector30
vector30:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $30
8010720d:	6a 1e                	push   $0x1e
  jmp alltraps
8010720f:	e9 7e f8 ff ff       	jmp    80106a92 <alltraps>

80107214 <vector31>:
.globl vector31
vector31:
  pushl $0
80107214:	6a 00                	push   $0x0
  pushl $31
80107216:	6a 1f                	push   $0x1f
  jmp alltraps
80107218:	e9 75 f8 ff ff       	jmp    80106a92 <alltraps>

8010721d <vector32>:
.globl vector32
vector32:
  pushl $0
8010721d:	6a 00                	push   $0x0
  pushl $32
8010721f:	6a 20                	push   $0x20
  jmp alltraps
80107221:	e9 6c f8 ff ff       	jmp    80106a92 <alltraps>

80107226 <vector33>:
.globl vector33
vector33:
  pushl $0
80107226:	6a 00                	push   $0x0
  pushl $33
80107228:	6a 21                	push   $0x21
  jmp alltraps
8010722a:	e9 63 f8 ff ff       	jmp    80106a92 <alltraps>

8010722f <vector34>:
.globl vector34
vector34:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $34
80107231:	6a 22                	push   $0x22
  jmp alltraps
80107233:	e9 5a f8 ff ff       	jmp    80106a92 <alltraps>

80107238 <vector35>:
.globl vector35
vector35:
  pushl $0
80107238:	6a 00                	push   $0x0
  pushl $35
8010723a:	6a 23                	push   $0x23
  jmp alltraps
8010723c:	e9 51 f8 ff ff       	jmp    80106a92 <alltraps>

80107241 <vector36>:
.globl vector36
vector36:
  pushl $0
80107241:	6a 00                	push   $0x0
  pushl $36
80107243:	6a 24                	push   $0x24
  jmp alltraps
80107245:	e9 48 f8 ff ff       	jmp    80106a92 <alltraps>

8010724a <vector37>:
.globl vector37
vector37:
  pushl $0
8010724a:	6a 00                	push   $0x0
  pushl $37
8010724c:	6a 25                	push   $0x25
  jmp alltraps
8010724e:	e9 3f f8 ff ff       	jmp    80106a92 <alltraps>

80107253 <vector38>:
.globl vector38
vector38:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $38
80107255:	6a 26                	push   $0x26
  jmp alltraps
80107257:	e9 36 f8 ff ff       	jmp    80106a92 <alltraps>

8010725c <vector39>:
.globl vector39
vector39:
  pushl $0
8010725c:	6a 00                	push   $0x0
  pushl $39
8010725e:	6a 27                	push   $0x27
  jmp alltraps
80107260:	e9 2d f8 ff ff       	jmp    80106a92 <alltraps>

80107265 <vector40>:
.globl vector40
vector40:
  pushl $0
80107265:	6a 00                	push   $0x0
  pushl $40
80107267:	6a 28                	push   $0x28
  jmp alltraps
80107269:	e9 24 f8 ff ff       	jmp    80106a92 <alltraps>

8010726e <vector41>:
.globl vector41
vector41:
  pushl $0
8010726e:	6a 00                	push   $0x0
  pushl $41
80107270:	6a 29                	push   $0x29
  jmp alltraps
80107272:	e9 1b f8 ff ff       	jmp    80106a92 <alltraps>

80107277 <vector42>:
.globl vector42
vector42:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $42
80107279:	6a 2a                	push   $0x2a
  jmp alltraps
8010727b:	e9 12 f8 ff ff       	jmp    80106a92 <alltraps>

80107280 <vector43>:
.globl vector43
vector43:
  pushl $0
80107280:	6a 00                	push   $0x0
  pushl $43
80107282:	6a 2b                	push   $0x2b
  jmp alltraps
80107284:	e9 09 f8 ff ff       	jmp    80106a92 <alltraps>

80107289 <vector44>:
.globl vector44
vector44:
  pushl $0
80107289:	6a 00                	push   $0x0
  pushl $44
8010728b:	6a 2c                	push   $0x2c
  jmp alltraps
8010728d:	e9 00 f8 ff ff       	jmp    80106a92 <alltraps>

80107292 <vector45>:
.globl vector45
vector45:
  pushl $0
80107292:	6a 00                	push   $0x0
  pushl $45
80107294:	6a 2d                	push   $0x2d
  jmp alltraps
80107296:	e9 f7 f7 ff ff       	jmp    80106a92 <alltraps>

8010729b <vector46>:
.globl vector46
vector46:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $46
8010729d:	6a 2e                	push   $0x2e
  jmp alltraps
8010729f:	e9 ee f7 ff ff       	jmp    80106a92 <alltraps>

801072a4 <vector47>:
.globl vector47
vector47:
  pushl $0
801072a4:	6a 00                	push   $0x0
  pushl $47
801072a6:	6a 2f                	push   $0x2f
  jmp alltraps
801072a8:	e9 e5 f7 ff ff       	jmp    80106a92 <alltraps>

801072ad <vector48>:
.globl vector48
vector48:
  pushl $0
801072ad:	6a 00                	push   $0x0
  pushl $48
801072af:	6a 30                	push   $0x30
  jmp alltraps
801072b1:	e9 dc f7 ff ff       	jmp    80106a92 <alltraps>

801072b6 <vector49>:
.globl vector49
vector49:
  pushl $0
801072b6:	6a 00                	push   $0x0
  pushl $49
801072b8:	6a 31                	push   $0x31
  jmp alltraps
801072ba:	e9 d3 f7 ff ff       	jmp    80106a92 <alltraps>

801072bf <vector50>:
.globl vector50
vector50:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $50
801072c1:	6a 32                	push   $0x32
  jmp alltraps
801072c3:	e9 ca f7 ff ff       	jmp    80106a92 <alltraps>

801072c8 <vector51>:
.globl vector51
vector51:
  pushl $0
801072c8:	6a 00                	push   $0x0
  pushl $51
801072ca:	6a 33                	push   $0x33
  jmp alltraps
801072cc:	e9 c1 f7 ff ff       	jmp    80106a92 <alltraps>

801072d1 <vector52>:
.globl vector52
vector52:
  pushl $0
801072d1:	6a 00                	push   $0x0
  pushl $52
801072d3:	6a 34                	push   $0x34
  jmp alltraps
801072d5:	e9 b8 f7 ff ff       	jmp    80106a92 <alltraps>

801072da <vector53>:
.globl vector53
vector53:
  pushl $0
801072da:	6a 00                	push   $0x0
  pushl $53
801072dc:	6a 35                	push   $0x35
  jmp alltraps
801072de:	e9 af f7 ff ff       	jmp    80106a92 <alltraps>

801072e3 <vector54>:
.globl vector54
vector54:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $54
801072e5:	6a 36                	push   $0x36
  jmp alltraps
801072e7:	e9 a6 f7 ff ff       	jmp    80106a92 <alltraps>

801072ec <vector55>:
.globl vector55
vector55:
  pushl $0
801072ec:	6a 00                	push   $0x0
  pushl $55
801072ee:	6a 37                	push   $0x37
  jmp alltraps
801072f0:	e9 9d f7 ff ff       	jmp    80106a92 <alltraps>

801072f5 <vector56>:
.globl vector56
vector56:
  pushl $0
801072f5:	6a 00                	push   $0x0
  pushl $56
801072f7:	6a 38                	push   $0x38
  jmp alltraps
801072f9:	e9 94 f7 ff ff       	jmp    80106a92 <alltraps>

801072fe <vector57>:
.globl vector57
vector57:
  pushl $0
801072fe:	6a 00                	push   $0x0
  pushl $57
80107300:	6a 39                	push   $0x39
  jmp alltraps
80107302:	e9 8b f7 ff ff       	jmp    80106a92 <alltraps>

80107307 <vector58>:
.globl vector58
vector58:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $58
80107309:	6a 3a                	push   $0x3a
  jmp alltraps
8010730b:	e9 82 f7 ff ff       	jmp    80106a92 <alltraps>

80107310 <vector59>:
.globl vector59
vector59:
  pushl $0
80107310:	6a 00                	push   $0x0
  pushl $59
80107312:	6a 3b                	push   $0x3b
  jmp alltraps
80107314:	e9 79 f7 ff ff       	jmp    80106a92 <alltraps>

80107319 <vector60>:
.globl vector60
vector60:
  pushl $0
80107319:	6a 00                	push   $0x0
  pushl $60
8010731b:	6a 3c                	push   $0x3c
  jmp alltraps
8010731d:	e9 70 f7 ff ff       	jmp    80106a92 <alltraps>

80107322 <vector61>:
.globl vector61
vector61:
  pushl $0
80107322:	6a 00                	push   $0x0
  pushl $61
80107324:	6a 3d                	push   $0x3d
  jmp alltraps
80107326:	e9 67 f7 ff ff       	jmp    80106a92 <alltraps>

8010732b <vector62>:
.globl vector62
vector62:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $62
8010732d:	6a 3e                	push   $0x3e
  jmp alltraps
8010732f:	e9 5e f7 ff ff       	jmp    80106a92 <alltraps>

80107334 <vector63>:
.globl vector63
vector63:
  pushl $0
80107334:	6a 00                	push   $0x0
  pushl $63
80107336:	6a 3f                	push   $0x3f
  jmp alltraps
80107338:	e9 55 f7 ff ff       	jmp    80106a92 <alltraps>

8010733d <vector64>:
.globl vector64
vector64:
  pushl $0
8010733d:	6a 00                	push   $0x0
  pushl $64
8010733f:	6a 40                	push   $0x40
  jmp alltraps
80107341:	e9 4c f7 ff ff       	jmp    80106a92 <alltraps>

80107346 <vector65>:
.globl vector65
vector65:
  pushl $0
80107346:	6a 00                	push   $0x0
  pushl $65
80107348:	6a 41                	push   $0x41
  jmp alltraps
8010734a:	e9 43 f7 ff ff       	jmp    80106a92 <alltraps>

8010734f <vector66>:
.globl vector66
vector66:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $66
80107351:	6a 42                	push   $0x42
  jmp alltraps
80107353:	e9 3a f7 ff ff       	jmp    80106a92 <alltraps>

80107358 <vector67>:
.globl vector67
vector67:
  pushl $0
80107358:	6a 00                	push   $0x0
  pushl $67
8010735a:	6a 43                	push   $0x43
  jmp alltraps
8010735c:	e9 31 f7 ff ff       	jmp    80106a92 <alltraps>

80107361 <vector68>:
.globl vector68
vector68:
  pushl $0
80107361:	6a 00                	push   $0x0
  pushl $68
80107363:	6a 44                	push   $0x44
  jmp alltraps
80107365:	e9 28 f7 ff ff       	jmp    80106a92 <alltraps>

8010736a <vector69>:
.globl vector69
vector69:
  pushl $0
8010736a:	6a 00                	push   $0x0
  pushl $69
8010736c:	6a 45                	push   $0x45
  jmp alltraps
8010736e:	e9 1f f7 ff ff       	jmp    80106a92 <alltraps>

80107373 <vector70>:
.globl vector70
vector70:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $70
80107375:	6a 46                	push   $0x46
  jmp alltraps
80107377:	e9 16 f7 ff ff       	jmp    80106a92 <alltraps>

8010737c <vector71>:
.globl vector71
vector71:
  pushl $0
8010737c:	6a 00                	push   $0x0
  pushl $71
8010737e:	6a 47                	push   $0x47
  jmp alltraps
80107380:	e9 0d f7 ff ff       	jmp    80106a92 <alltraps>

80107385 <vector72>:
.globl vector72
vector72:
  pushl $0
80107385:	6a 00                	push   $0x0
  pushl $72
80107387:	6a 48                	push   $0x48
  jmp alltraps
80107389:	e9 04 f7 ff ff       	jmp    80106a92 <alltraps>

8010738e <vector73>:
.globl vector73
vector73:
  pushl $0
8010738e:	6a 00                	push   $0x0
  pushl $73
80107390:	6a 49                	push   $0x49
  jmp alltraps
80107392:	e9 fb f6 ff ff       	jmp    80106a92 <alltraps>

80107397 <vector74>:
.globl vector74
vector74:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $74
80107399:	6a 4a                	push   $0x4a
  jmp alltraps
8010739b:	e9 f2 f6 ff ff       	jmp    80106a92 <alltraps>

801073a0 <vector75>:
.globl vector75
vector75:
  pushl $0
801073a0:	6a 00                	push   $0x0
  pushl $75
801073a2:	6a 4b                	push   $0x4b
  jmp alltraps
801073a4:	e9 e9 f6 ff ff       	jmp    80106a92 <alltraps>

801073a9 <vector76>:
.globl vector76
vector76:
  pushl $0
801073a9:	6a 00                	push   $0x0
  pushl $76
801073ab:	6a 4c                	push   $0x4c
  jmp alltraps
801073ad:	e9 e0 f6 ff ff       	jmp    80106a92 <alltraps>

801073b2 <vector77>:
.globl vector77
vector77:
  pushl $0
801073b2:	6a 00                	push   $0x0
  pushl $77
801073b4:	6a 4d                	push   $0x4d
  jmp alltraps
801073b6:	e9 d7 f6 ff ff       	jmp    80106a92 <alltraps>

801073bb <vector78>:
.globl vector78
vector78:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $78
801073bd:	6a 4e                	push   $0x4e
  jmp alltraps
801073bf:	e9 ce f6 ff ff       	jmp    80106a92 <alltraps>

801073c4 <vector79>:
.globl vector79
vector79:
  pushl $0
801073c4:	6a 00                	push   $0x0
  pushl $79
801073c6:	6a 4f                	push   $0x4f
  jmp alltraps
801073c8:	e9 c5 f6 ff ff       	jmp    80106a92 <alltraps>

801073cd <vector80>:
.globl vector80
vector80:
  pushl $0
801073cd:	6a 00                	push   $0x0
  pushl $80
801073cf:	6a 50                	push   $0x50
  jmp alltraps
801073d1:	e9 bc f6 ff ff       	jmp    80106a92 <alltraps>

801073d6 <vector81>:
.globl vector81
vector81:
  pushl $0
801073d6:	6a 00                	push   $0x0
  pushl $81
801073d8:	6a 51                	push   $0x51
  jmp alltraps
801073da:	e9 b3 f6 ff ff       	jmp    80106a92 <alltraps>

801073df <vector82>:
.globl vector82
vector82:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $82
801073e1:	6a 52                	push   $0x52
  jmp alltraps
801073e3:	e9 aa f6 ff ff       	jmp    80106a92 <alltraps>

801073e8 <vector83>:
.globl vector83
vector83:
  pushl $0
801073e8:	6a 00                	push   $0x0
  pushl $83
801073ea:	6a 53                	push   $0x53
  jmp alltraps
801073ec:	e9 a1 f6 ff ff       	jmp    80106a92 <alltraps>

801073f1 <vector84>:
.globl vector84
vector84:
  pushl $0
801073f1:	6a 00                	push   $0x0
  pushl $84
801073f3:	6a 54                	push   $0x54
  jmp alltraps
801073f5:	e9 98 f6 ff ff       	jmp    80106a92 <alltraps>

801073fa <vector85>:
.globl vector85
vector85:
  pushl $0
801073fa:	6a 00                	push   $0x0
  pushl $85
801073fc:	6a 55                	push   $0x55
  jmp alltraps
801073fe:	e9 8f f6 ff ff       	jmp    80106a92 <alltraps>

80107403 <vector86>:
.globl vector86
vector86:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $86
80107405:	6a 56                	push   $0x56
  jmp alltraps
80107407:	e9 86 f6 ff ff       	jmp    80106a92 <alltraps>

8010740c <vector87>:
.globl vector87
vector87:
  pushl $0
8010740c:	6a 00                	push   $0x0
  pushl $87
8010740e:	6a 57                	push   $0x57
  jmp alltraps
80107410:	e9 7d f6 ff ff       	jmp    80106a92 <alltraps>

80107415 <vector88>:
.globl vector88
vector88:
  pushl $0
80107415:	6a 00                	push   $0x0
  pushl $88
80107417:	6a 58                	push   $0x58
  jmp alltraps
80107419:	e9 74 f6 ff ff       	jmp    80106a92 <alltraps>

8010741e <vector89>:
.globl vector89
vector89:
  pushl $0
8010741e:	6a 00                	push   $0x0
  pushl $89
80107420:	6a 59                	push   $0x59
  jmp alltraps
80107422:	e9 6b f6 ff ff       	jmp    80106a92 <alltraps>

80107427 <vector90>:
.globl vector90
vector90:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $90
80107429:	6a 5a                	push   $0x5a
  jmp alltraps
8010742b:	e9 62 f6 ff ff       	jmp    80106a92 <alltraps>

80107430 <vector91>:
.globl vector91
vector91:
  pushl $0
80107430:	6a 00                	push   $0x0
  pushl $91
80107432:	6a 5b                	push   $0x5b
  jmp alltraps
80107434:	e9 59 f6 ff ff       	jmp    80106a92 <alltraps>

80107439 <vector92>:
.globl vector92
vector92:
  pushl $0
80107439:	6a 00                	push   $0x0
  pushl $92
8010743b:	6a 5c                	push   $0x5c
  jmp alltraps
8010743d:	e9 50 f6 ff ff       	jmp    80106a92 <alltraps>

80107442 <vector93>:
.globl vector93
vector93:
  pushl $0
80107442:	6a 00                	push   $0x0
  pushl $93
80107444:	6a 5d                	push   $0x5d
  jmp alltraps
80107446:	e9 47 f6 ff ff       	jmp    80106a92 <alltraps>

8010744b <vector94>:
.globl vector94
vector94:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $94
8010744d:	6a 5e                	push   $0x5e
  jmp alltraps
8010744f:	e9 3e f6 ff ff       	jmp    80106a92 <alltraps>

80107454 <vector95>:
.globl vector95
vector95:
  pushl $0
80107454:	6a 00                	push   $0x0
  pushl $95
80107456:	6a 5f                	push   $0x5f
  jmp alltraps
80107458:	e9 35 f6 ff ff       	jmp    80106a92 <alltraps>

8010745d <vector96>:
.globl vector96
vector96:
  pushl $0
8010745d:	6a 00                	push   $0x0
  pushl $96
8010745f:	6a 60                	push   $0x60
  jmp alltraps
80107461:	e9 2c f6 ff ff       	jmp    80106a92 <alltraps>

80107466 <vector97>:
.globl vector97
vector97:
  pushl $0
80107466:	6a 00                	push   $0x0
  pushl $97
80107468:	6a 61                	push   $0x61
  jmp alltraps
8010746a:	e9 23 f6 ff ff       	jmp    80106a92 <alltraps>

8010746f <vector98>:
.globl vector98
vector98:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $98
80107471:	6a 62                	push   $0x62
  jmp alltraps
80107473:	e9 1a f6 ff ff       	jmp    80106a92 <alltraps>

80107478 <vector99>:
.globl vector99
vector99:
  pushl $0
80107478:	6a 00                	push   $0x0
  pushl $99
8010747a:	6a 63                	push   $0x63
  jmp alltraps
8010747c:	e9 11 f6 ff ff       	jmp    80106a92 <alltraps>

80107481 <vector100>:
.globl vector100
vector100:
  pushl $0
80107481:	6a 00                	push   $0x0
  pushl $100
80107483:	6a 64                	push   $0x64
  jmp alltraps
80107485:	e9 08 f6 ff ff       	jmp    80106a92 <alltraps>

8010748a <vector101>:
.globl vector101
vector101:
  pushl $0
8010748a:	6a 00                	push   $0x0
  pushl $101
8010748c:	6a 65                	push   $0x65
  jmp alltraps
8010748e:	e9 ff f5 ff ff       	jmp    80106a92 <alltraps>

80107493 <vector102>:
.globl vector102
vector102:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $102
80107495:	6a 66                	push   $0x66
  jmp alltraps
80107497:	e9 f6 f5 ff ff       	jmp    80106a92 <alltraps>

8010749c <vector103>:
.globl vector103
vector103:
  pushl $0
8010749c:	6a 00                	push   $0x0
  pushl $103
8010749e:	6a 67                	push   $0x67
  jmp alltraps
801074a0:	e9 ed f5 ff ff       	jmp    80106a92 <alltraps>

801074a5 <vector104>:
.globl vector104
vector104:
  pushl $0
801074a5:	6a 00                	push   $0x0
  pushl $104
801074a7:	6a 68                	push   $0x68
  jmp alltraps
801074a9:	e9 e4 f5 ff ff       	jmp    80106a92 <alltraps>

801074ae <vector105>:
.globl vector105
vector105:
  pushl $0
801074ae:	6a 00                	push   $0x0
  pushl $105
801074b0:	6a 69                	push   $0x69
  jmp alltraps
801074b2:	e9 db f5 ff ff       	jmp    80106a92 <alltraps>

801074b7 <vector106>:
.globl vector106
vector106:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $106
801074b9:	6a 6a                	push   $0x6a
  jmp alltraps
801074bb:	e9 d2 f5 ff ff       	jmp    80106a92 <alltraps>

801074c0 <vector107>:
.globl vector107
vector107:
  pushl $0
801074c0:	6a 00                	push   $0x0
  pushl $107
801074c2:	6a 6b                	push   $0x6b
  jmp alltraps
801074c4:	e9 c9 f5 ff ff       	jmp    80106a92 <alltraps>

801074c9 <vector108>:
.globl vector108
vector108:
  pushl $0
801074c9:	6a 00                	push   $0x0
  pushl $108
801074cb:	6a 6c                	push   $0x6c
  jmp alltraps
801074cd:	e9 c0 f5 ff ff       	jmp    80106a92 <alltraps>

801074d2 <vector109>:
.globl vector109
vector109:
  pushl $0
801074d2:	6a 00                	push   $0x0
  pushl $109
801074d4:	6a 6d                	push   $0x6d
  jmp alltraps
801074d6:	e9 b7 f5 ff ff       	jmp    80106a92 <alltraps>

801074db <vector110>:
.globl vector110
vector110:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $110
801074dd:	6a 6e                	push   $0x6e
  jmp alltraps
801074df:	e9 ae f5 ff ff       	jmp    80106a92 <alltraps>

801074e4 <vector111>:
.globl vector111
vector111:
  pushl $0
801074e4:	6a 00                	push   $0x0
  pushl $111
801074e6:	6a 6f                	push   $0x6f
  jmp alltraps
801074e8:	e9 a5 f5 ff ff       	jmp    80106a92 <alltraps>

801074ed <vector112>:
.globl vector112
vector112:
  pushl $0
801074ed:	6a 00                	push   $0x0
  pushl $112
801074ef:	6a 70                	push   $0x70
  jmp alltraps
801074f1:	e9 9c f5 ff ff       	jmp    80106a92 <alltraps>

801074f6 <vector113>:
.globl vector113
vector113:
  pushl $0
801074f6:	6a 00                	push   $0x0
  pushl $113
801074f8:	6a 71                	push   $0x71
  jmp alltraps
801074fa:	e9 93 f5 ff ff       	jmp    80106a92 <alltraps>

801074ff <vector114>:
.globl vector114
vector114:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $114
80107501:	6a 72                	push   $0x72
  jmp alltraps
80107503:	e9 8a f5 ff ff       	jmp    80106a92 <alltraps>

80107508 <vector115>:
.globl vector115
vector115:
  pushl $0
80107508:	6a 00                	push   $0x0
  pushl $115
8010750a:	6a 73                	push   $0x73
  jmp alltraps
8010750c:	e9 81 f5 ff ff       	jmp    80106a92 <alltraps>

80107511 <vector116>:
.globl vector116
vector116:
  pushl $0
80107511:	6a 00                	push   $0x0
  pushl $116
80107513:	6a 74                	push   $0x74
  jmp alltraps
80107515:	e9 78 f5 ff ff       	jmp    80106a92 <alltraps>

8010751a <vector117>:
.globl vector117
vector117:
  pushl $0
8010751a:	6a 00                	push   $0x0
  pushl $117
8010751c:	6a 75                	push   $0x75
  jmp alltraps
8010751e:	e9 6f f5 ff ff       	jmp    80106a92 <alltraps>

80107523 <vector118>:
.globl vector118
vector118:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $118
80107525:	6a 76                	push   $0x76
  jmp alltraps
80107527:	e9 66 f5 ff ff       	jmp    80106a92 <alltraps>

8010752c <vector119>:
.globl vector119
vector119:
  pushl $0
8010752c:	6a 00                	push   $0x0
  pushl $119
8010752e:	6a 77                	push   $0x77
  jmp alltraps
80107530:	e9 5d f5 ff ff       	jmp    80106a92 <alltraps>

80107535 <vector120>:
.globl vector120
vector120:
  pushl $0
80107535:	6a 00                	push   $0x0
  pushl $120
80107537:	6a 78                	push   $0x78
  jmp alltraps
80107539:	e9 54 f5 ff ff       	jmp    80106a92 <alltraps>

8010753e <vector121>:
.globl vector121
vector121:
  pushl $0
8010753e:	6a 00                	push   $0x0
  pushl $121
80107540:	6a 79                	push   $0x79
  jmp alltraps
80107542:	e9 4b f5 ff ff       	jmp    80106a92 <alltraps>

80107547 <vector122>:
.globl vector122
vector122:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $122
80107549:	6a 7a                	push   $0x7a
  jmp alltraps
8010754b:	e9 42 f5 ff ff       	jmp    80106a92 <alltraps>

80107550 <vector123>:
.globl vector123
vector123:
  pushl $0
80107550:	6a 00                	push   $0x0
  pushl $123
80107552:	6a 7b                	push   $0x7b
  jmp alltraps
80107554:	e9 39 f5 ff ff       	jmp    80106a92 <alltraps>

80107559 <vector124>:
.globl vector124
vector124:
  pushl $0
80107559:	6a 00                	push   $0x0
  pushl $124
8010755b:	6a 7c                	push   $0x7c
  jmp alltraps
8010755d:	e9 30 f5 ff ff       	jmp    80106a92 <alltraps>

80107562 <vector125>:
.globl vector125
vector125:
  pushl $0
80107562:	6a 00                	push   $0x0
  pushl $125
80107564:	6a 7d                	push   $0x7d
  jmp alltraps
80107566:	e9 27 f5 ff ff       	jmp    80106a92 <alltraps>

8010756b <vector126>:
.globl vector126
vector126:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $126
8010756d:	6a 7e                	push   $0x7e
  jmp alltraps
8010756f:	e9 1e f5 ff ff       	jmp    80106a92 <alltraps>

80107574 <vector127>:
.globl vector127
vector127:
  pushl $0
80107574:	6a 00                	push   $0x0
  pushl $127
80107576:	6a 7f                	push   $0x7f
  jmp alltraps
80107578:	e9 15 f5 ff ff       	jmp    80106a92 <alltraps>

8010757d <vector128>:
.globl vector128
vector128:
  pushl $0
8010757d:	6a 00                	push   $0x0
  pushl $128
8010757f:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107584:	e9 09 f5 ff ff       	jmp    80106a92 <alltraps>

80107589 <vector129>:
.globl vector129
vector129:
  pushl $0
80107589:	6a 00                	push   $0x0
  pushl $129
8010758b:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107590:	e9 fd f4 ff ff       	jmp    80106a92 <alltraps>

80107595 <vector130>:
.globl vector130
vector130:
  pushl $0
80107595:	6a 00                	push   $0x0
  pushl $130
80107597:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010759c:	e9 f1 f4 ff ff       	jmp    80106a92 <alltraps>

801075a1 <vector131>:
.globl vector131
vector131:
  pushl $0
801075a1:	6a 00                	push   $0x0
  pushl $131
801075a3:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801075a8:	e9 e5 f4 ff ff       	jmp    80106a92 <alltraps>

801075ad <vector132>:
.globl vector132
vector132:
  pushl $0
801075ad:	6a 00                	push   $0x0
  pushl $132
801075af:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801075b4:	e9 d9 f4 ff ff       	jmp    80106a92 <alltraps>

801075b9 <vector133>:
.globl vector133
vector133:
  pushl $0
801075b9:	6a 00                	push   $0x0
  pushl $133
801075bb:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801075c0:	e9 cd f4 ff ff       	jmp    80106a92 <alltraps>

801075c5 <vector134>:
.globl vector134
vector134:
  pushl $0
801075c5:	6a 00                	push   $0x0
  pushl $134
801075c7:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801075cc:	e9 c1 f4 ff ff       	jmp    80106a92 <alltraps>

801075d1 <vector135>:
.globl vector135
vector135:
  pushl $0
801075d1:	6a 00                	push   $0x0
  pushl $135
801075d3:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801075d8:	e9 b5 f4 ff ff       	jmp    80106a92 <alltraps>

801075dd <vector136>:
.globl vector136
vector136:
  pushl $0
801075dd:	6a 00                	push   $0x0
  pushl $136
801075df:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801075e4:	e9 a9 f4 ff ff       	jmp    80106a92 <alltraps>

801075e9 <vector137>:
.globl vector137
vector137:
  pushl $0
801075e9:	6a 00                	push   $0x0
  pushl $137
801075eb:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801075f0:	e9 9d f4 ff ff       	jmp    80106a92 <alltraps>

801075f5 <vector138>:
.globl vector138
vector138:
  pushl $0
801075f5:	6a 00                	push   $0x0
  pushl $138
801075f7:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801075fc:	e9 91 f4 ff ff       	jmp    80106a92 <alltraps>

80107601 <vector139>:
.globl vector139
vector139:
  pushl $0
80107601:	6a 00                	push   $0x0
  pushl $139
80107603:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107608:	e9 85 f4 ff ff       	jmp    80106a92 <alltraps>

8010760d <vector140>:
.globl vector140
vector140:
  pushl $0
8010760d:	6a 00                	push   $0x0
  pushl $140
8010760f:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107614:	e9 79 f4 ff ff       	jmp    80106a92 <alltraps>

80107619 <vector141>:
.globl vector141
vector141:
  pushl $0
80107619:	6a 00                	push   $0x0
  pushl $141
8010761b:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107620:	e9 6d f4 ff ff       	jmp    80106a92 <alltraps>

80107625 <vector142>:
.globl vector142
vector142:
  pushl $0
80107625:	6a 00                	push   $0x0
  pushl $142
80107627:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010762c:	e9 61 f4 ff ff       	jmp    80106a92 <alltraps>

80107631 <vector143>:
.globl vector143
vector143:
  pushl $0
80107631:	6a 00                	push   $0x0
  pushl $143
80107633:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107638:	e9 55 f4 ff ff       	jmp    80106a92 <alltraps>

8010763d <vector144>:
.globl vector144
vector144:
  pushl $0
8010763d:	6a 00                	push   $0x0
  pushl $144
8010763f:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107644:	e9 49 f4 ff ff       	jmp    80106a92 <alltraps>

80107649 <vector145>:
.globl vector145
vector145:
  pushl $0
80107649:	6a 00                	push   $0x0
  pushl $145
8010764b:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107650:	e9 3d f4 ff ff       	jmp    80106a92 <alltraps>

80107655 <vector146>:
.globl vector146
vector146:
  pushl $0
80107655:	6a 00                	push   $0x0
  pushl $146
80107657:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010765c:	e9 31 f4 ff ff       	jmp    80106a92 <alltraps>

80107661 <vector147>:
.globl vector147
vector147:
  pushl $0
80107661:	6a 00                	push   $0x0
  pushl $147
80107663:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107668:	e9 25 f4 ff ff       	jmp    80106a92 <alltraps>

8010766d <vector148>:
.globl vector148
vector148:
  pushl $0
8010766d:	6a 00                	push   $0x0
  pushl $148
8010766f:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107674:	e9 19 f4 ff ff       	jmp    80106a92 <alltraps>

80107679 <vector149>:
.globl vector149
vector149:
  pushl $0
80107679:	6a 00                	push   $0x0
  pushl $149
8010767b:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107680:	e9 0d f4 ff ff       	jmp    80106a92 <alltraps>

80107685 <vector150>:
.globl vector150
vector150:
  pushl $0
80107685:	6a 00                	push   $0x0
  pushl $150
80107687:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010768c:	e9 01 f4 ff ff       	jmp    80106a92 <alltraps>

80107691 <vector151>:
.globl vector151
vector151:
  pushl $0
80107691:	6a 00                	push   $0x0
  pushl $151
80107693:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107698:	e9 f5 f3 ff ff       	jmp    80106a92 <alltraps>

8010769d <vector152>:
.globl vector152
vector152:
  pushl $0
8010769d:	6a 00                	push   $0x0
  pushl $152
8010769f:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801076a4:	e9 e9 f3 ff ff       	jmp    80106a92 <alltraps>

801076a9 <vector153>:
.globl vector153
vector153:
  pushl $0
801076a9:	6a 00                	push   $0x0
  pushl $153
801076ab:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801076b0:	e9 dd f3 ff ff       	jmp    80106a92 <alltraps>

801076b5 <vector154>:
.globl vector154
vector154:
  pushl $0
801076b5:	6a 00                	push   $0x0
  pushl $154
801076b7:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801076bc:	e9 d1 f3 ff ff       	jmp    80106a92 <alltraps>

801076c1 <vector155>:
.globl vector155
vector155:
  pushl $0
801076c1:	6a 00                	push   $0x0
  pushl $155
801076c3:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801076c8:	e9 c5 f3 ff ff       	jmp    80106a92 <alltraps>

801076cd <vector156>:
.globl vector156
vector156:
  pushl $0
801076cd:	6a 00                	push   $0x0
  pushl $156
801076cf:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801076d4:	e9 b9 f3 ff ff       	jmp    80106a92 <alltraps>

801076d9 <vector157>:
.globl vector157
vector157:
  pushl $0
801076d9:	6a 00                	push   $0x0
  pushl $157
801076db:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801076e0:	e9 ad f3 ff ff       	jmp    80106a92 <alltraps>

801076e5 <vector158>:
.globl vector158
vector158:
  pushl $0
801076e5:	6a 00                	push   $0x0
  pushl $158
801076e7:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801076ec:	e9 a1 f3 ff ff       	jmp    80106a92 <alltraps>

801076f1 <vector159>:
.globl vector159
vector159:
  pushl $0
801076f1:	6a 00                	push   $0x0
  pushl $159
801076f3:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801076f8:	e9 95 f3 ff ff       	jmp    80106a92 <alltraps>

801076fd <vector160>:
.globl vector160
vector160:
  pushl $0
801076fd:	6a 00                	push   $0x0
  pushl $160
801076ff:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107704:	e9 89 f3 ff ff       	jmp    80106a92 <alltraps>

80107709 <vector161>:
.globl vector161
vector161:
  pushl $0
80107709:	6a 00                	push   $0x0
  pushl $161
8010770b:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107710:	e9 7d f3 ff ff       	jmp    80106a92 <alltraps>

80107715 <vector162>:
.globl vector162
vector162:
  pushl $0
80107715:	6a 00                	push   $0x0
  pushl $162
80107717:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010771c:	e9 71 f3 ff ff       	jmp    80106a92 <alltraps>

80107721 <vector163>:
.globl vector163
vector163:
  pushl $0
80107721:	6a 00                	push   $0x0
  pushl $163
80107723:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107728:	e9 65 f3 ff ff       	jmp    80106a92 <alltraps>

8010772d <vector164>:
.globl vector164
vector164:
  pushl $0
8010772d:	6a 00                	push   $0x0
  pushl $164
8010772f:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107734:	e9 59 f3 ff ff       	jmp    80106a92 <alltraps>

80107739 <vector165>:
.globl vector165
vector165:
  pushl $0
80107739:	6a 00                	push   $0x0
  pushl $165
8010773b:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107740:	e9 4d f3 ff ff       	jmp    80106a92 <alltraps>

80107745 <vector166>:
.globl vector166
vector166:
  pushl $0
80107745:	6a 00                	push   $0x0
  pushl $166
80107747:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010774c:	e9 41 f3 ff ff       	jmp    80106a92 <alltraps>

80107751 <vector167>:
.globl vector167
vector167:
  pushl $0
80107751:	6a 00                	push   $0x0
  pushl $167
80107753:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107758:	e9 35 f3 ff ff       	jmp    80106a92 <alltraps>

8010775d <vector168>:
.globl vector168
vector168:
  pushl $0
8010775d:	6a 00                	push   $0x0
  pushl $168
8010775f:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107764:	e9 29 f3 ff ff       	jmp    80106a92 <alltraps>

80107769 <vector169>:
.globl vector169
vector169:
  pushl $0
80107769:	6a 00                	push   $0x0
  pushl $169
8010776b:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107770:	e9 1d f3 ff ff       	jmp    80106a92 <alltraps>

80107775 <vector170>:
.globl vector170
vector170:
  pushl $0
80107775:	6a 00                	push   $0x0
  pushl $170
80107777:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010777c:	e9 11 f3 ff ff       	jmp    80106a92 <alltraps>

80107781 <vector171>:
.globl vector171
vector171:
  pushl $0
80107781:	6a 00                	push   $0x0
  pushl $171
80107783:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107788:	e9 05 f3 ff ff       	jmp    80106a92 <alltraps>

8010778d <vector172>:
.globl vector172
vector172:
  pushl $0
8010778d:	6a 00                	push   $0x0
  pushl $172
8010778f:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107794:	e9 f9 f2 ff ff       	jmp    80106a92 <alltraps>

80107799 <vector173>:
.globl vector173
vector173:
  pushl $0
80107799:	6a 00                	push   $0x0
  pushl $173
8010779b:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801077a0:	e9 ed f2 ff ff       	jmp    80106a92 <alltraps>

801077a5 <vector174>:
.globl vector174
vector174:
  pushl $0
801077a5:	6a 00                	push   $0x0
  pushl $174
801077a7:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801077ac:	e9 e1 f2 ff ff       	jmp    80106a92 <alltraps>

801077b1 <vector175>:
.globl vector175
vector175:
  pushl $0
801077b1:	6a 00                	push   $0x0
  pushl $175
801077b3:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801077b8:	e9 d5 f2 ff ff       	jmp    80106a92 <alltraps>

801077bd <vector176>:
.globl vector176
vector176:
  pushl $0
801077bd:	6a 00                	push   $0x0
  pushl $176
801077bf:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801077c4:	e9 c9 f2 ff ff       	jmp    80106a92 <alltraps>

801077c9 <vector177>:
.globl vector177
vector177:
  pushl $0
801077c9:	6a 00                	push   $0x0
  pushl $177
801077cb:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801077d0:	e9 bd f2 ff ff       	jmp    80106a92 <alltraps>

801077d5 <vector178>:
.globl vector178
vector178:
  pushl $0
801077d5:	6a 00                	push   $0x0
  pushl $178
801077d7:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801077dc:	e9 b1 f2 ff ff       	jmp    80106a92 <alltraps>

801077e1 <vector179>:
.globl vector179
vector179:
  pushl $0
801077e1:	6a 00                	push   $0x0
  pushl $179
801077e3:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801077e8:	e9 a5 f2 ff ff       	jmp    80106a92 <alltraps>

801077ed <vector180>:
.globl vector180
vector180:
  pushl $0
801077ed:	6a 00                	push   $0x0
  pushl $180
801077ef:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801077f4:	e9 99 f2 ff ff       	jmp    80106a92 <alltraps>

801077f9 <vector181>:
.globl vector181
vector181:
  pushl $0
801077f9:	6a 00                	push   $0x0
  pushl $181
801077fb:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107800:	e9 8d f2 ff ff       	jmp    80106a92 <alltraps>

80107805 <vector182>:
.globl vector182
vector182:
  pushl $0
80107805:	6a 00                	push   $0x0
  pushl $182
80107807:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010780c:	e9 81 f2 ff ff       	jmp    80106a92 <alltraps>

80107811 <vector183>:
.globl vector183
vector183:
  pushl $0
80107811:	6a 00                	push   $0x0
  pushl $183
80107813:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107818:	e9 75 f2 ff ff       	jmp    80106a92 <alltraps>

8010781d <vector184>:
.globl vector184
vector184:
  pushl $0
8010781d:	6a 00                	push   $0x0
  pushl $184
8010781f:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107824:	e9 69 f2 ff ff       	jmp    80106a92 <alltraps>

80107829 <vector185>:
.globl vector185
vector185:
  pushl $0
80107829:	6a 00                	push   $0x0
  pushl $185
8010782b:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107830:	e9 5d f2 ff ff       	jmp    80106a92 <alltraps>

80107835 <vector186>:
.globl vector186
vector186:
  pushl $0
80107835:	6a 00                	push   $0x0
  pushl $186
80107837:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010783c:	e9 51 f2 ff ff       	jmp    80106a92 <alltraps>

80107841 <vector187>:
.globl vector187
vector187:
  pushl $0
80107841:	6a 00                	push   $0x0
  pushl $187
80107843:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107848:	e9 45 f2 ff ff       	jmp    80106a92 <alltraps>

8010784d <vector188>:
.globl vector188
vector188:
  pushl $0
8010784d:	6a 00                	push   $0x0
  pushl $188
8010784f:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107854:	e9 39 f2 ff ff       	jmp    80106a92 <alltraps>

80107859 <vector189>:
.globl vector189
vector189:
  pushl $0
80107859:	6a 00                	push   $0x0
  pushl $189
8010785b:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107860:	e9 2d f2 ff ff       	jmp    80106a92 <alltraps>

80107865 <vector190>:
.globl vector190
vector190:
  pushl $0
80107865:	6a 00                	push   $0x0
  pushl $190
80107867:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010786c:	e9 21 f2 ff ff       	jmp    80106a92 <alltraps>

80107871 <vector191>:
.globl vector191
vector191:
  pushl $0
80107871:	6a 00                	push   $0x0
  pushl $191
80107873:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107878:	e9 15 f2 ff ff       	jmp    80106a92 <alltraps>

8010787d <vector192>:
.globl vector192
vector192:
  pushl $0
8010787d:	6a 00                	push   $0x0
  pushl $192
8010787f:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107884:	e9 09 f2 ff ff       	jmp    80106a92 <alltraps>

80107889 <vector193>:
.globl vector193
vector193:
  pushl $0
80107889:	6a 00                	push   $0x0
  pushl $193
8010788b:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107890:	e9 fd f1 ff ff       	jmp    80106a92 <alltraps>

80107895 <vector194>:
.globl vector194
vector194:
  pushl $0
80107895:	6a 00                	push   $0x0
  pushl $194
80107897:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010789c:	e9 f1 f1 ff ff       	jmp    80106a92 <alltraps>

801078a1 <vector195>:
.globl vector195
vector195:
  pushl $0
801078a1:	6a 00                	push   $0x0
  pushl $195
801078a3:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801078a8:	e9 e5 f1 ff ff       	jmp    80106a92 <alltraps>

801078ad <vector196>:
.globl vector196
vector196:
  pushl $0
801078ad:	6a 00                	push   $0x0
  pushl $196
801078af:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801078b4:	e9 d9 f1 ff ff       	jmp    80106a92 <alltraps>

801078b9 <vector197>:
.globl vector197
vector197:
  pushl $0
801078b9:	6a 00                	push   $0x0
  pushl $197
801078bb:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801078c0:	e9 cd f1 ff ff       	jmp    80106a92 <alltraps>

801078c5 <vector198>:
.globl vector198
vector198:
  pushl $0
801078c5:	6a 00                	push   $0x0
  pushl $198
801078c7:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801078cc:	e9 c1 f1 ff ff       	jmp    80106a92 <alltraps>

801078d1 <vector199>:
.globl vector199
vector199:
  pushl $0
801078d1:	6a 00                	push   $0x0
  pushl $199
801078d3:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801078d8:	e9 b5 f1 ff ff       	jmp    80106a92 <alltraps>

801078dd <vector200>:
.globl vector200
vector200:
  pushl $0
801078dd:	6a 00                	push   $0x0
  pushl $200
801078df:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801078e4:	e9 a9 f1 ff ff       	jmp    80106a92 <alltraps>

801078e9 <vector201>:
.globl vector201
vector201:
  pushl $0
801078e9:	6a 00                	push   $0x0
  pushl $201
801078eb:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801078f0:	e9 9d f1 ff ff       	jmp    80106a92 <alltraps>

801078f5 <vector202>:
.globl vector202
vector202:
  pushl $0
801078f5:	6a 00                	push   $0x0
  pushl $202
801078f7:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801078fc:	e9 91 f1 ff ff       	jmp    80106a92 <alltraps>

80107901 <vector203>:
.globl vector203
vector203:
  pushl $0
80107901:	6a 00                	push   $0x0
  pushl $203
80107903:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107908:	e9 85 f1 ff ff       	jmp    80106a92 <alltraps>

8010790d <vector204>:
.globl vector204
vector204:
  pushl $0
8010790d:	6a 00                	push   $0x0
  pushl $204
8010790f:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107914:	e9 79 f1 ff ff       	jmp    80106a92 <alltraps>

80107919 <vector205>:
.globl vector205
vector205:
  pushl $0
80107919:	6a 00                	push   $0x0
  pushl $205
8010791b:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107920:	e9 6d f1 ff ff       	jmp    80106a92 <alltraps>

80107925 <vector206>:
.globl vector206
vector206:
  pushl $0
80107925:	6a 00                	push   $0x0
  pushl $206
80107927:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010792c:	e9 61 f1 ff ff       	jmp    80106a92 <alltraps>

80107931 <vector207>:
.globl vector207
vector207:
  pushl $0
80107931:	6a 00                	push   $0x0
  pushl $207
80107933:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107938:	e9 55 f1 ff ff       	jmp    80106a92 <alltraps>

8010793d <vector208>:
.globl vector208
vector208:
  pushl $0
8010793d:	6a 00                	push   $0x0
  pushl $208
8010793f:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107944:	e9 49 f1 ff ff       	jmp    80106a92 <alltraps>

80107949 <vector209>:
.globl vector209
vector209:
  pushl $0
80107949:	6a 00                	push   $0x0
  pushl $209
8010794b:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107950:	e9 3d f1 ff ff       	jmp    80106a92 <alltraps>

80107955 <vector210>:
.globl vector210
vector210:
  pushl $0
80107955:	6a 00                	push   $0x0
  pushl $210
80107957:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010795c:	e9 31 f1 ff ff       	jmp    80106a92 <alltraps>

80107961 <vector211>:
.globl vector211
vector211:
  pushl $0
80107961:	6a 00                	push   $0x0
  pushl $211
80107963:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107968:	e9 25 f1 ff ff       	jmp    80106a92 <alltraps>

8010796d <vector212>:
.globl vector212
vector212:
  pushl $0
8010796d:	6a 00                	push   $0x0
  pushl $212
8010796f:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107974:	e9 19 f1 ff ff       	jmp    80106a92 <alltraps>

80107979 <vector213>:
.globl vector213
vector213:
  pushl $0
80107979:	6a 00                	push   $0x0
  pushl $213
8010797b:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107980:	e9 0d f1 ff ff       	jmp    80106a92 <alltraps>

80107985 <vector214>:
.globl vector214
vector214:
  pushl $0
80107985:	6a 00                	push   $0x0
  pushl $214
80107987:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010798c:	e9 01 f1 ff ff       	jmp    80106a92 <alltraps>

80107991 <vector215>:
.globl vector215
vector215:
  pushl $0
80107991:	6a 00                	push   $0x0
  pushl $215
80107993:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107998:	e9 f5 f0 ff ff       	jmp    80106a92 <alltraps>

8010799d <vector216>:
.globl vector216
vector216:
  pushl $0
8010799d:	6a 00                	push   $0x0
  pushl $216
8010799f:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801079a4:	e9 e9 f0 ff ff       	jmp    80106a92 <alltraps>

801079a9 <vector217>:
.globl vector217
vector217:
  pushl $0
801079a9:	6a 00                	push   $0x0
  pushl $217
801079ab:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801079b0:	e9 dd f0 ff ff       	jmp    80106a92 <alltraps>

801079b5 <vector218>:
.globl vector218
vector218:
  pushl $0
801079b5:	6a 00                	push   $0x0
  pushl $218
801079b7:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801079bc:	e9 d1 f0 ff ff       	jmp    80106a92 <alltraps>

801079c1 <vector219>:
.globl vector219
vector219:
  pushl $0
801079c1:	6a 00                	push   $0x0
  pushl $219
801079c3:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801079c8:	e9 c5 f0 ff ff       	jmp    80106a92 <alltraps>

801079cd <vector220>:
.globl vector220
vector220:
  pushl $0
801079cd:	6a 00                	push   $0x0
  pushl $220
801079cf:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801079d4:	e9 b9 f0 ff ff       	jmp    80106a92 <alltraps>

801079d9 <vector221>:
.globl vector221
vector221:
  pushl $0
801079d9:	6a 00                	push   $0x0
  pushl $221
801079db:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801079e0:	e9 ad f0 ff ff       	jmp    80106a92 <alltraps>

801079e5 <vector222>:
.globl vector222
vector222:
  pushl $0
801079e5:	6a 00                	push   $0x0
  pushl $222
801079e7:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801079ec:	e9 a1 f0 ff ff       	jmp    80106a92 <alltraps>

801079f1 <vector223>:
.globl vector223
vector223:
  pushl $0
801079f1:	6a 00                	push   $0x0
  pushl $223
801079f3:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801079f8:	e9 95 f0 ff ff       	jmp    80106a92 <alltraps>

801079fd <vector224>:
.globl vector224
vector224:
  pushl $0
801079fd:	6a 00                	push   $0x0
  pushl $224
801079ff:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107a04:	e9 89 f0 ff ff       	jmp    80106a92 <alltraps>

80107a09 <vector225>:
.globl vector225
vector225:
  pushl $0
80107a09:	6a 00                	push   $0x0
  pushl $225
80107a0b:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107a10:	e9 7d f0 ff ff       	jmp    80106a92 <alltraps>

80107a15 <vector226>:
.globl vector226
vector226:
  pushl $0
80107a15:	6a 00                	push   $0x0
  pushl $226
80107a17:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107a1c:	e9 71 f0 ff ff       	jmp    80106a92 <alltraps>

80107a21 <vector227>:
.globl vector227
vector227:
  pushl $0
80107a21:	6a 00                	push   $0x0
  pushl $227
80107a23:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107a28:	e9 65 f0 ff ff       	jmp    80106a92 <alltraps>

80107a2d <vector228>:
.globl vector228
vector228:
  pushl $0
80107a2d:	6a 00                	push   $0x0
  pushl $228
80107a2f:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107a34:	e9 59 f0 ff ff       	jmp    80106a92 <alltraps>

80107a39 <vector229>:
.globl vector229
vector229:
  pushl $0
80107a39:	6a 00                	push   $0x0
  pushl $229
80107a3b:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107a40:	e9 4d f0 ff ff       	jmp    80106a92 <alltraps>

80107a45 <vector230>:
.globl vector230
vector230:
  pushl $0
80107a45:	6a 00                	push   $0x0
  pushl $230
80107a47:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107a4c:	e9 41 f0 ff ff       	jmp    80106a92 <alltraps>

80107a51 <vector231>:
.globl vector231
vector231:
  pushl $0
80107a51:	6a 00                	push   $0x0
  pushl $231
80107a53:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107a58:	e9 35 f0 ff ff       	jmp    80106a92 <alltraps>

80107a5d <vector232>:
.globl vector232
vector232:
  pushl $0
80107a5d:	6a 00                	push   $0x0
  pushl $232
80107a5f:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107a64:	e9 29 f0 ff ff       	jmp    80106a92 <alltraps>

80107a69 <vector233>:
.globl vector233
vector233:
  pushl $0
80107a69:	6a 00                	push   $0x0
  pushl $233
80107a6b:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107a70:	e9 1d f0 ff ff       	jmp    80106a92 <alltraps>

80107a75 <vector234>:
.globl vector234
vector234:
  pushl $0
80107a75:	6a 00                	push   $0x0
  pushl $234
80107a77:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107a7c:	e9 11 f0 ff ff       	jmp    80106a92 <alltraps>

80107a81 <vector235>:
.globl vector235
vector235:
  pushl $0
80107a81:	6a 00                	push   $0x0
  pushl $235
80107a83:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107a88:	e9 05 f0 ff ff       	jmp    80106a92 <alltraps>

80107a8d <vector236>:
.globl vector236
vector236:
  pushl $0
80107a8d:	6a 00                	push   $0x0
  pushl $236
80107a8f:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107a94:	e9 f9 ef ff ff       	jmp    80106a92 <alltraps>

80107a99 <vector237>:
.globl vector237
vector237:
  pushl $0
80107a99:	6a 00                	push   $0x0
  pushl $237
80107a9b:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107aa0:	e9 ed ef ff ff       	jmp    80106a92 <alltraps>

80107aa5 <vector238>:
.globl vector238
vector238:
  pushl $0
80107aa5:	6a 00                	push   $0x0
  pushl $238
80107aa7:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107aac:	e9 e1 ef ff ff       	jmp    80106a92 <alltraps>

80107ab1 <vector239>:
.globl vector239
vector239:
  pushl $0
80107ab1:	6a 00                	push   $0x0
  pushl $239
80107ab3:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107ab8:	e9 d5 ef ff ff       	jmp    80106a92 <alltraps>

80107abd <vector240>:
.globl vector240
vector240:
  pushl $0
80107abd:	6a 00                	push   $0x0
  pushl $240
80107abf:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107ac4:	e9 c9 ef ff ff       	jmp    80106a92 <alltraps>

80107ac9 <vector241>:
.globl vector241
vector241:
  pushl $0
80107ac9:	6a 00                	push   $0x0
  pushl $241
80107acb:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107ad0:	e9 bd ef ff ff       	jmp    80106a92 <alltraps>

80107ad5 <vector242>:
.globl vector242
vector242:
  pushl $0
80107ad5:	6a 00                	push   $0x0
  pushl $242
80107ad7:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107adc:	e9 b1 ef ff ff       	jmp    80106a92 <alltraps>

80107ae1 <vector243>:
.globl vector243
vector243:
  pushl $0
80107ae1:	6a 00                	push   $0x0
  pushl $243
80107ae3:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107ae8:	e9 a5 ef ff ff       	jmp    80106a92 <alltraps>

80107aed <vector244>:
.globl vector244
vector244:
  pushl $0
80107aed:	6a 00                	push   $0x0
  pushl $244
80107aef:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107af4:	e9 99 ef ff ff       	jmp    80106a92 <alltraps>

80107af9 <vector245>:
.globl vector245
vector245:
  pushl $0
80107af9:	6a 00                	push   $0x0
  pushl $245
80107afb:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107b00:	e9 8d ef ff ff       	jmp    80106a92 <alltraps>

80107b05 <vector246>:
.globl vector246
vector246:
  pushl $0
80107b05:	6a 00                	push   $0x0
  pushl $246
80107b07:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107b0c:	e9 81 ef ff ff       	jmp    80106a92 <alltraps>

80107b11 <vector247>:
.globl vector247
vector247:
  pushl $0
80107b11:	6a 00                	push   $0x0
  pushl $247
80107b13:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107b18:	e9 75 ef ff ff       	jmp    80106a92 <alltraps>

80107b1d <vector248>:
.globl vector248
vector248:
  pushl $0
80107b1d:	6a 00                	push   $0x0
  pushl $248
80107b1f:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107b24:	e9 69 ef ff ff       	jmp    80106a92 <alltraps>

80107b29 <vector249>:
.globl vector249
vector249:
  pushl $0
80107b29:	6a 00                	push   $0x0
  pushl $249
80107b2b:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107b30:	e9 5d ef ff ff       	jmp    80106a92 <alltraps>

80107b35 <vector250>:
.globl vector250
vector250:
  pushl $0
80107b35:	6a 00                	push   $0x0
  pushl $250
80107b37:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107b3c:	e9 51 ef ff ff       	jmp    80106a92 <alltraps>

80107b41 <vector251>:
.globl vector251
vector251:
  pushl $0
80107b41:	6a 00                	push   $0x0
  pushl $251
80107b43:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107b48:	e9 45 ef ff ff       	jmp    80106a92 <alltraps>

80107b4d <vector252>:
.globl vector252
vector252:
  pushl $0
80107b4d:	6a 00                	push   $0x0
  pushl $252
80107b4f:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107b54:	e9 39 ef ff ff       	jmp    80106a92 <alltraps>

80107b59 <vector253>:
.globl vector253
vector253:
  pushl $0
80107b59:	6a 00                	push   $0x0
  pushl $253
80107b5b:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107b60:	e9 2d ef ff ff       	jmp    80106a92 <alltraps>

80107b65 <vector254>:
.globl vector254
vector254:
  pushl $0
80107b65:	6a 00                	push   $0x0
  pushl $254
80107b67:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107b6c:	e9 21 ef ff ff       	jmp    80106a92 <alltraps>

80107b71 <vector255>:
.globl vector255
vector255:
  pushl $0
80107b71:	6a 00                	push   $0x0
  pushl $255
80107b73:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107b78:	e9 15 ef ff ff       	jmp    80106a92 <alltraps>

80107b7d <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107b7d:	55                   	push   %ebp
80107b7e:	89 e5                	mov    %esp,%ebp
80107b80:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107b83:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b86:	83 e8 01             	sub    $0x1,%eax
80107b89:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107b8d:	8b 45 08             	mov    0x8(%ebp),%eax
80107b90:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107b94:	8b 45 08             	mov    0x8(%ebp),%eax
80107b97:	c1 e8 10             	shr    $0x10,%eax
80107b9a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107b9e:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107ba1:	0f 01 10             	lgdtl  (%eax)
}
80107ba4:	c9                   	leave  
80107ba5:	c3                   	ret    

80107ba6 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107ba6:	55                   	push   %ebp
80107ba7:	89 e5                	mov    %esp,%ebp
80107ba9:	83 ec 04             	sub    $0x4,%esp
80107bac:	8b 45 08             	mov    0x8(%ebp),%eax
80107baf:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107bb3:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107bb7:	0f 00 d8             	ltr    %ax
}
80107bba:	c9                   	leave  
80107bbb:	c3                   	ret    

80107bbc <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107bbc:	55                   	push   %ebp
80107bbd:	89 e5                	mov    %esp,%ebp
80107bbf:	83 ec 04             	sub    $0x4,%esp
80107bc2:	8b 45 08             	mov    0x8(%ebp),%eax
80107bc5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107bc9:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107bcd:	8e e8                	mov    %eax,%gs
}
80107bcf:	c9                   	leave  
80107bd0:	c3                   	ret    

80107bd1 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107bd1:	55                   	push   %ebp
80107bd2:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107bd4:	8b 45 08             	mov    0x8(%ebp),%eax
80107bd7:	0f 22 d8             	mov    %eax,%cr3
}
80107bda:	5d                   	pop    %ebp
80107bdb:	c3                   	ret    

80107bdc <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107bdc:	55                   	push   %ebp
80107bdd:	89 e5                	mov    %esp,%ebp
80107bdf:	8b 45 08             	mov    0x8(%ebp),%eax
80107be2:	05 00 00 00 80       	add    $0x80000000,%eax
80107be7:	5d                   	pop    %ebp
80107be8:	c3                   	ret    

80107be9 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107be9:	55                   	push   %ebp
80107bea:	89 e5                	mov    %esp,%ebp
80107bec:	8b 45 08             	mov    0x8(%ebp),%eax
80107bef:	05 00 00 00 80       	add    $0x80000000,%eax
80107bf4:	5d                   	pop    %ebp
80107bf5:	c3                   	ret    

80107bf6 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107bf6:	55                   	push   %ebp
80107bf7:	89 e5                	mov    %esp,%ebp
80107bf9:	53                   	push   %ebx
80107bfa:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107bfd:	e8 39 b3 ff ff       	call   80102f3b <cpunum>
80107c02:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107c08:	05 c0 33 11 80       	add    $0x801133c0,%eax
80107c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c13:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c1c:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c25:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c2c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c30:	83 e2 f0             	and    $0xfffffff0,%edx
80107c33:	83 ca 0a             	or     $0xa,%edx
80107c36:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c3c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c40:	83 ca 10             	or     $0x10,%edx
80107c43:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c49:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c4d:	83 e2 9f             	and    $0xffffff9f,%edx
80107c50:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c56:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c5a:	83 ca 80             	or     $0xffffff80,%edx
80107c5d:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c63:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c67:	83 ca 0f             	or     $0xf,%edx
80107c6a:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c70:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c74:	83 e2 ef             	and    $0xffffffef,%edx
80107c77:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c7d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c81:	83 e2 df             	and    $0xffffffdf,%edx
80107c84:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c8e:	83 ca 40             	or     $0x40,%edx
80107c91:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c97:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c9b:	83 ca 80             	or     $0xffffff80,%edx
80107c9e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca4:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cab:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107cb2:	ff ff 
80107cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb7:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107cbe:	00 00 
80107cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc3:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ccd:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107cd4:	83 e2 f0             	and    $0xfffffff0,%edx
80107cd7:	83 ca 02             	or     $0x2,%edx
80107cda:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce3:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107cea:	83 ca 10             	or     $0x10,%edx
80107ced:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf6:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107cfd:	83 e2 9f             	and    $0xffffff9f,%edx
80107d00:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d09:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d10:	83 ca 80             	or     $0xffffff80,%edx
80107d13:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d1c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d23:	83 ca 0f             	or     $0xf,%edx
80107d26:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d36:	83 e2 ef             	and    $0xffffffef,%edx
80107d39:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d42:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d49:	83 e2 df             	and    $0xffffffdf,%edx
80107d4c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d55:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d5c:	83 ca 40             	or     $0x40,%edx
80107d5f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d68:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d6f:	83 ca 80             	or     $0xffffff80,%edx
80107d72:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d7b:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d85:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107d8c:	ff ff 
80107d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d91:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107d98:	00 00 
80107d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9d:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da7:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107dae:	83 e2 f0             	and    $0xfffffff0,%edx
80107db1:	83 ca 0a             	or     $0xa,%edx
80107db4:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dbd:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107dc4:	83 ca 10             	or     $0x10,%edx
80107dc7:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd0:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107dd7:	83 ca 60             	or     $0x60,%edx
80107dda:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107dea:	83 ca 80             	or     $0xffffff80,%edx
80107ded:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df6:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107dfd:	83 ca 0f             	or     $0xf,%edx
80107e00:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e09:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e10:	83 e2 ef             	and    $0xffffffef,%edx
80107e13:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e23:	83 e2 df             	and    $0xffffffdf,%edx
80107e26:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e2f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e36:	83 ca 40             	or     $0x40,%edx
80107e39:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e42:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e49:	83 ca 80             	or     $0xffffff80,%edx
80107e4c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e55:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5f:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107e66:	ff ff 
80107e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e6b:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107e72:	00 00 
80107e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e77:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e81:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e88:	83 e2 f0             	and    $0xfffffff0,%edx
80107e8b:	83 ca 02             	or     $0x2,%edx
80107e8e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e97:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e9e:	83 ca 10             	or     $0x10,%edx
80107ea1:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eaa:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107eb1:	83 ca 60             	or     $0x60,%edx
80107eb4:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebd:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107ec4:	83 ca 80             	or     $0xffffff80,%edx
80107ec7:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed0:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ed7:	83 ca 0f             	or     $0xf,%edx
80107eda:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee3:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107eea:	83 e2 ef             	and    $0xffffffef,%edx
80107eed:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef6:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107efd:	83 e2 df             	and    $0xffffffdf,%edx
80107f00:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f09:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f10:	83 ca 40             	or     $0x40,%edx
80107f13:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f1c:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f23:	83 ca 80             	or     $0xffffff80,%edx
80107f26:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2f:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f39:	05 b4 00 00 00       	add    $0xb4,%eax
80107f3e:	89 c3                	mov    %eax,%ebx
80107f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f43:	05 b4 00 00 00       	add    $0xb4,%eax
80107f48:	c1 e8 10             	shr    $0x10,%eax
80107f4b:	89 c1                	mov    %eax,%ecx
80107f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f50:	05 b4 00 00 00       	add    $0xb4,%eax
80107f55:	c1 e8 18             	shr    $0x18,%eax
80107f58:	89 c2                	mov    %eax,%edx
80107f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5d:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107f64:	00 00 
80107f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f69:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f73:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f7c:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107f83:	83 e1 f0             	and    $0xfffffff0,%ecx
80107f86:	83 c9 02             	or     $0x2,%ecx
80107f89:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f92:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107f99:	83 c9 10             	or     $0x10,%ecx
80107f9c:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa5:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107fac:	83 e1 9f             	and    $0xffffff9f,%ecx
80107faf:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb8:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107fbf:	83 c9 80             	or     $0xffffff80,%ecx
80107fc2:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fcb:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107fd2:	83 e1 f0             	and    $0xfffffff0,%ecx
80107fd5:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fde:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107fe5:	83 e1 ef             	and    $0xffffffef,%ecx
80107fe8:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff1:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107ff8:	83 e1 df             	and    $0xffffffdf,%ecx
80107ffb:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108001:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108004:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010800b:	83 c9 40             	or     $0x40,%ecx
8010800e:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108014:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108017:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010801e:	83 c9 80             	or     $0xffffff80,%ecx
80108021:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108027:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802a:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108030:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108033:	83 c0 70             	add    $0x70,%eax
80108036:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
8010803d:	00 
8010803e:	89 04 24             	mov    %eax,(%esp)
80108041:	e8 37 fb ff ff       	call   80107b7d <lgdt>
  loadgs(SEG_KCPU << 3);
80108046:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
8010804d:	e8 6a fb ff ff       	call   80107bbc <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80108052:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108055:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010805b:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108062:	00 00 00 00 
}
80108066:	83 c4 24             	add    $0x24,%esp
80108069:	5b                   	pop    %ebx
8010806a:	5d                   	pop    %ebp
8010806b:	c3                   	ret    

8010806c <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010806c:	55                   	push   %ebp
8010806d:	89 e5                	mov    %esp,%ebp
8010806f:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108072:	8b 45 0c             	mov    0xc(%ebp),%eax
80108075:	c1 e8 16             	shr    $0x16,%eax
80108078:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010807f:	8b 45 08             	mov    0x8(%ebp),%eax
80108082:	01 d0                	add    %edx,%eax
80108084:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108087:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010808a:	8b 00                	mov    (%eax),%eax
8010808c:	83 e0 01             	and    $0x1,%eax
8010808f:	85 c0                	test   %eax,%eax
80108091:	74 17                	je     801080aa <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108093:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108096:	8b 00                	mov    (%eax),%eax
80108098:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010809d:	89 04 24             	mov    %eax,(%esp)
801080a0:	e8 44 fb ff ff       	call   80107be9 <p2v>
801080a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080a8:	eb 4b                	jmp    801080f5 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801080aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801080ae:	74 0e                	je     801080be <walkpgdir+0x52>
801080b0:	e8 f0 aa ff ff       	call   80102ba5 <kalloc>
801080b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801080bc:	75 07                	jne    801080c5 <walkpgdir+0x59>
      return 0;
801080be:	b8 00 00 00 00       	mov    $0x0,%eax
801080c3:	eb 47                	jmp    8010810c <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801080c5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080cc:	00 
801080cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801080d4:	00 
801080d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d8:	89 04 24             	mov    %eax,(%esp)
801080db:	e8 f8 d4 ff ff       	call   801055d8 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801080e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e3:	89 04 24             	mov    %eax,(%esp)
801080e6:	e8 f1 fa ff ff       	call   80107bdc <v2p>
801080eb:	83 c8 07             	or     $0x7,%eax
801080ee:	89 c2                	mov    %eax,%edx
801080f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080f3:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801080f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801080f8:	c1 e8 0c             	shr    $0xc,%eax
801080fb:	25 ff 03 00 00       	and    $0x3ff,%eax
80108100:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108107:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010810a:	01 d0                	add    %edx,%eax
}
8010810c:	c9                   	leave  
8010810d:	c3                   	ret    

8010810e <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010810e:	55                   	push   %ebp
8010810f:	89 e5                	mov    %esp,%ebp
80108111:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108114:	8b 45 0c             	mov    0xc(%ebp),%eax
80108117:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010811c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010811f:	8b 55 0c             	mov    0xc(%ebp),%edx
80108122:	8b 45 10             	mov    0x10(%ebp),%eax
80108125:	01 d0                	add    %edx,%eax
80108127:	83 e8 01             	sub    $0x1,%eax
8010812a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010812f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108132:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80108139:	00 
8010813a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108141:	8b 45 08             	mov    0x8(%ebp),%eax
80108144:	89 04 24             	mov    %eax,(%esp)
80108147:	e8 20 ff ff ff       	call   8010806c <walkpgdir>
8010814c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010814f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108153:	75 07                	jne    8010815c <mappages+0x4e>
      return -1;
80108155:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010815a:	eb 48                	jmp    801081a4 <mappages+0x96>
    if(*pte & PTE_P)
8010815c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010815f:	8b 00                	mov    (%eax),%eax
80108161:	83 e0 01             	and    $0x1,%eax
80108164:	85 c0                	test   %eax,%eax
80108166:	74 0c                	je     80108174 <mappages+0x66>
      panic("remap");
80108168:	c7 04 24 a0 91 10 80 	movl   $0x801091a0,(%esp)
8010816f:	e8 c6 83 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80108174:	8b 45 18             	mov    0x18(%ebp),%eax
80108177:	0b 45 14             	or     0x14(%ebp),%eax
8010817a:	83 c8 01             	or     $0x1,%eax
8010817d:	89 c2                	mov    %eax,%edx
8010817f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108182:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108184:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108187:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010818a:	75 08                	jne    80108194 <mappages+0x86>
      break;
8010818c:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010818d:	b8 00 00 00 00       	mov    $0x0,%eax
80108192:	eb 10                	jmp    801081a4 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80108194:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010819b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801081a2:	eb 8e                	jmp    80108132 <mappages+0x24>
  return 0;
}
801081a4:	c9                   	leave  
801081a5:	c3                   	ret    

801081a6 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801081a6:	55                   	push   %ebp
801081a7:	89 e5                	mov    %esp,%ebp
801081a9:	53                   	push   %ebx
801081aa:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801081ad:	e8 f3 a9 ff ff       	call   80102ba5 <kalloc>
801081b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801081b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081b9:	75 0a                	jne    801081c5 <setupkvm+0x1f>
    return 0;
801081bb:	b8 00 00 00 00       	mov    $0x0,%eax
801081c0:	e9 98 00 00 00       	jmp    8010825d <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
801081c5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801081cc:	00 
801081cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801081d4:	00 
801081d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081d8:	89 04 24             	mov    %eax,(%esp)
801081db:	e8 f8 d3 ff ff       	call   801055d8 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801081e0:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
801081e7:	e8 fd f9 ff ff       	call   80107be9 <p2v>
801081ec:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801081f1:	76 0c                	jbe    801081ff <setupkvm+0x59>
    panic("PHYSTOP too high");
801081f3:	c7 04 24 a6 91 10 80 	movl   $0x801091a6,(%esp)
801081fa:	e8 3b 83 ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801081ff:	c7 45 f4 e0 c4 10 80 	movl   $0x8010c4e0,-0xc(%ebp)
80108206:	eb 49                	jmp    80108251 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108208:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010820b:	8b 48 0c             	mov    0xc(%eax),%ecx
8010820e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108211:	8b 50 04             	mov    0x4(%eax),%edx
80108214:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108217:	8b 58 08             	mov    0x8(%eax),%ebx
8010821a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010821d:	8b 40 04             	mov    0x4(%eax),%eax
80108220:	29 c3                	sub    %eax,%ebx
80108222:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108225:	8b 00                	mov    (%eax),%eax
80108227:	89 4c 24 10          	mov    %ecx,0x10(%esp)
8010822b:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010822f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108233:	89 44 24 04          	mov    %eax,0x4(%esp)
80108237:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010823a:	89 04 24             	mov    %eax,(%esp)
8010823d:	e8 cc fe ff ff       	call   8010810e <mappages>
80108242:	85 c0                	test   %eax,%eax
80108244:	79 07                	jns    8010824d <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108246:	b8 00 00 00 00       	mov    $0x0,%eax
8010824b:	eb 10                	jmp    8010825d <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010824d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108251:	81 7d f4 20 c5 10 80 	cmpl   $0x8010c520,-0xc(%ebp)
80108258:	72 ae                	jb     80108208 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010825a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010825d:	83 c4 34             	add    $0x34,%esp
80108260:	5b                   	pop    %ebx
80108261:	5d                   	pop    %ebp
80108262:	c3                   	ret    

80108263 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108263:	55                   	push   %ebp
80108264:	89 e5                	mov    %esp,%ebp
80108266:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108269:	e8 38 ff ff ff       	call   801081a6 <setupkvm>
8010826e:	a3 98 62 11 80       	mov    %eax,0x80116298
  switchkvm();
80108273:	e8 02 00 00 00       	call   8010827a <switchkvm>
}
80108278:	c9                   	leave  
80108279:	c3                   	ret    

8010827a <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010827a:	55                   	push   %ebp
8010827b:	89 e5                	mov    %esp,%ebp
8010827d:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108280:	a1 98 62 11 80       	mov    0x80116298,%eax
80108285:	89 04 24             	mov    %eax,(%esp)
80108288:	e8 4f f9 ff ff       	call   80107bdc <v2p>
8010828d:	89 04 24             	mov    %eax,(%esp)
80108290:	e8 3c f9 ff ff       	call   80107bd1 <lcr3>
}
80108295:	c9                   	leave  
80108296:	c3                   	ret    

80108297 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108297:	55                   	push   %ebp
80108298:	89 e5                	mov    %esp,%ebp
8010829a:	53                   	push   %ebx
8010829b:	83 ec 14             	sub    $0x14,%esp
  pushcli();
8010829e:	e8 35 d2 ff ff       	call   801054d8 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801082a3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801082a9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801082b0:	83 c2 08             	add    $0x8,%edx
801082b3:	89 d3                	mov    %edx,%ebx
801082b5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801082bc:	83 c2 08             	add    $0x8,%edx
801082bf:	c1 ea 10             	shr    $0x10,%edx
801082c2:	89 d1                	mov    %edx,%ecx
801082c4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801082cb:	83 c2 08             	add    $0x8,%edx
801082ce:	c1 ea 18             	shr    $0x18,%edx
801082d1:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801082d8:	67 00 
801082da:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
801082e1:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
801082e7:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801082ee:	83 e1 f0             	and    $0xfffffff0,%ecx
801082f1:	83 c9 09             	or     $0x9,%ecx
801082f4:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801082fa:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108301:	83 c9 10             	or     $0x10,%ecx
80108304:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010830a:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108311:	83 e1 9f             	and    $0xffffff9f,%ecx
80108314:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010831a:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108321:	83 c9 80             	or     $0xffffff80,%ecx
80108324:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010832a:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108331:	83 e1 f0             	and    $0xfffffff0,%ecx
80108334:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010833a:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108341:	83 e1 ef             	and    $0xffffffef,%ecx
80108344:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010834a:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108351:	83 e1 df             	and    $0xffffffdf,%ecx
80108354:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010835a:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108361:	83 c9 40             	or     $0x40,%ecx
80108364:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010836a:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108371:	83 e1 7f             	and    $0x7f,%ecx
80108374:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010837a:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108380:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108386:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010838d:	83 e2 ef             	and    $0xffffffef,%edx
80108390:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108396:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010839c:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801083a2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083a8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801083af:	8b 52 08             	mov    0x8(%edx),%edx
801083b2:	81 c2 00 10 00 00    	add    $0x1000,%edx
801083b8:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801083bb:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
801083c2:	e8 df f7 ff ff       	call   80107ba6 <ltr>
  if(p->pgdir == 0)
801083c7:	8b 45 08             	mov    0x8(%ebp),%eax
801083ca:	8b 40 04             	mov    0x4(%eax),%eax
801083cd:	85 c0                	test   %eax,%eax
801083cf:	75 0c                	jne    801083dd <switchuvm+0x146>
    panic("switchuvm: no pgdir");
801083d1:	c7 04 24 b7 91 10 80 	movl   $0x801091b7,(%esp)
801083d8:	e8 5d 81 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801083dd:	8b 45 08             	mov    0x8(%ebp),%eax
801083e0:	8b 40 04             	mov    0x4(%eax),%eax
801083e3:	89 04 24             	mov    %eax,(%esp)
801083e6:	e8 f1 f7 ff ff       	call   80107bdc <v2p>
801083eb:	89 04 24             	mov    %eax,(%esp)
801083ee:	e8 de f7 ff ff       	call   80107bd1 <lcr3>
  popcli();
801083f3:	e8 24 d1 ff ff       	call   8010551c <popcli>
}
801083f8:	83 c4 14             	add    $0x14,%esp
801083fb:	5b                   	pop    %ebx
801083fc:	5d                   	pop    %ebp
801083fd:	c3                   	ret    

801083fe <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801083fe:	55                   	push   %ebp
801083ff:	89 e5                	mov    %esp,%ebp
80108401:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108404:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010840b:	76 0c                	jbe    80108419 <inituvm+0x1b>
    panic("inituvm: more than a page");
8010840d:	c7 04 24 cb 91 10 80 	movl   $0x801091cb,(%esp)
80108414:	e8 21 81 ff ff       	call   8010053a <panic>
  mem = kalloc();
80108419:	e8 87 a7 ff ff       	call   80102ba5 <kalloc>
8010841e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108421:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108428:	00 
80108429:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108430:	00 
80108431:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108434:	89 04 24             	mov    %eax,(%esp)
80108437:	e8 9c d1 ff ff       	call   801055d8 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010843c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010843f:	89 04 24             	mov    %eax,(%esp)
80108442:	e8 95 f7 ff ff       	call   80107bdc <v2p>
80108447:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010844e:	00 
8010844f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108453:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010845a:	00 
8010845b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108462:	00 
80108463:	8b 45 08             	mov    0x8(%ebp),%eax
80108466:	89 04 24             	mov    %eax,(%esp)
80108469:	e8 a0 fc ff ff       	call   8010810e <mappages>
  memmove(mem, init, sz);
8010846e:	8b 45 10             	mov    0x10(%ebp),%eax
80108471:	89 44 24 08          	mov    %eax,0x8(%esp)
80108475:	8b 45 0c             	mov    0xc(%ebp),%eax
80108478:	89 44 24 04          	mov    %eax,0x4(%esp)
8010847c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010847f:	89 04 24             	mov    %eax,(%esp)
80108482:	e8 20 d2 ff ff       	call   801056a7 <memmove>
}
80108487:	c9                   	leave  
80108488:	c3                   	ret    

80108489 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108489:	55                   	push   %ebp
8010848a:	89 e5                	mov    %esp,%ebp
8010848c:	53                   	push   %ebx
8010848d:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108490:	8b 45 0c             	mov    0xc(%ebp),%eax
80108493:	25 ff 0f 00 00       	and    $0xfff,%eax
80108498:	85 c0                	test   %eax,%eax
8010849a:	74 0c                	je     801084a8 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
8010849c:	c7 04 24 e8 91 10 80 	movl   $0x801091e8,(%esp)
801084a3:	e8 92 80 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
801084a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801084af:	e9 a9 00 00 00       	jmp    8010855d <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801084b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801084ba:	01 d0                	add    %edx,%eax
801084bc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801084c3:	00 
801084c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801084c8:	8b 45 08             	mov    0x8(%ebp),%eax
801084cb:	89 04 24             	mov    %eax,(%esp)
801084ce:	e8 99 fb ff ff       	call   8010806c <walkpgdir>
801084d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801084d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801084da:	75 0c                	jne    801084e8 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
801084dc:	c7 04 24 0b 92 10 80 	movl   $0x8010920b,(%esp)
801084e3:	e8 52 80 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
801084e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084eb:	8b 00                	mov    (%eax),%eax
801084ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801084f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084f8:	8b 55 18             	mov    0x18(%ebp),%edx
801084fb:	29 c2                	sub    %eax,%edx
801084fd:	89 d0                	mov    %edx,%eax
801084ff:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108504:	77 0f                	ja     80108515 <loaduvm+0x8c>
      n = sz - i;
80108506:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108509:	8b 55 18             	mov    0x18(%ebp),%edx
8010850c:	29 c2                	sub    %eax,%edx
8010850e:	89 d0                	mov    %edx,%eax
80108510:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108513:	eb 07                	jmp    8010851c <loaduvm+0x93>
    else
      n = PGSIZE;
80108515:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
8010851c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010851f:	8b 55 14             	mov    0x14(%ebp),%edx
80108522:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108525:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108528:	89 04 24             	mov    %eax,(%esp)
8010852b:	e8 b9 f6 ff ff       	call   80107be9 <p2v>
80108530:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108533:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108537:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010853b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010853f:	8b 45 10             	mov    0x10(%ebp),%eax
80108542:	89 04 24             	mov    %eax,(%esp)
80108545:	e8 aa 98 ff ff       	call   80101df4 <readi>
8010854a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010854d:	74 07                	je     80108556 <loaduvm+0xcd>
      return -1;
8010854f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108554:	eb 18                	jmp    8010856e <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108556:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010855d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108560:	3b 45 18             	cmp    0x18(%ebp),%eax
80108563:	0f 82 4b ff ff ff    	jb     801084b4 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108569:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010856e:	83 c4 24             	add    $0x24,%esp
80108571:	5b                   	pop    %ebx
80108572:	5d                   	pop    %ebp
80108573:	c3                   	ret    

80108574 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108574:	55                   	push   %ebp
80108575:	89 e5                	mov    %esp,%ebp
80108577:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010857a:	8b 45 10             	mov    0x10(%ebp),%eax
8010857d:	85 c0                	test   %eax,%eax
8010857f:	79 0a                	jns    8010858b <allocuvm+0x17>
    return 0;
80108581:	b8 00 00 00 00       	mov    $0x0,%eax
80108586:	e9 c1 00 00 00       	jmp    8010864c <allocuvm+0xd8>
  if(newsz < oldsz)
8010858b:	8b 45 10             	mov    0x10(%ebp),%eax
8010858e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108591:	73 08                	jae    8010859b <allocuvm+0x27>
    return oldsz;
80108593:	8b 45 0c             	mov    0xc(%ebp),%eax
80108596:	e9 b1 00 00 00       	jmp    8010864c <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
8010859b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010859e:	05 ff 0f 00 00       	add    $0xfff,%eax
801085a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801085ab:	e9 8d 00 00 00       	jmp    8010863d <allocuvm+0xc9>
    mem = kalloc();
801085b0:	e8 f0 a5 ff ff       	call   80102ba5 <kalloc>
801085b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801085b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801085bc:	75 2c                	jne    801085ea <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
801085be:	c7 04 24 29 92 10 80 	movl   $0x80109229,(%esp)
801085c5:	e8 d6 7d ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801085ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801085cd:	89 44 24 08          	mov    %eax,0x8(%esp)
801085d1:	8b 45 10             	mov    0x10(%ebp),%eax
801085d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801085d8:	8b 45 08             	mov    0x8(%ebp),%eax
801085db:	89 04 24             	mov    %eax,(%esp)
801085de:	e8 6b 00 00 00       	call   8010864e <deallocuvm>
      return 0;
801085e3:	b8 00 00 00 00       	mov    $0x0,%eax
801085e8:	eb 62                	jmp    8010864c <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
801085ea:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801085f1:	00 
801085f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801085f9:	00 
801085fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085fd:	89 04 24             	mov    %eax,(%esp)
80108600:	e8 d3 cf ff ff       	call   801055d8 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108605:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108608:	89 04 24             	mov    %eax,(%esp)
8010860b:	e8 cc f5 ff ff       	call   80107bdc <v2p>
80108610:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108613:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010861a:	00 
8010861b:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010861f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108626:	00 
80108627:	89 54 24 04          	mov    %edx,0x4(%esp)
8010862b:	8b 45 08             	mov    0x8(%ebp),%eax
8010862e:	89 04 24             	mov    %eax,(%esp)
80108631:	e8 d8 fa ff ff       	call   8010810e <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108636:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010863d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108640:	3b 45 10             	cmp    0x10(%ebp),%eax
80108643:	0f 82 67 ff ff ff    	jb     801085b0 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108649:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010864c:	c9                   	leave  
8010864d:	c3                   	ret    

8010864e <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010864e:	55                   	push   %ebp
8010864f:	89 e5                	mov    %esp,%ebp
80108651:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108654:	8b 45 10             	mov    0x10(%ebp),%eax
80108657:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010865a:	72 08                	jb     80108664 <deallocuvm+0x16>
    return oldsz;
8010865c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010865f:	e9 a4 00 00 00       	jmp    80108708 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80108664:	8b 45 10             	mov    0x10(%ebp),%eax
80108667:	05 ff 0f 00 00       	add    $0xfff,%eax
8010866c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108671:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108674:	e9 80 00 00 00       	jmp    801086f9 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108679:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010867c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108683:	00 
80108684:	89 44 24 04          	mov    %eax,0x4(%esp)
80108688:	8b 45 08             	mov    0x8(%ebp),%eax
8010868b:	89 04 24             	mov    %eax,(%esp)
8010868e:	e8 d9 f9 ff ff       	call   8010806c <walkpgdir>
80108693:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108696:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010869a:	75 09                	jne    801086a5 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
8010869c:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801086a3:	eb 4d                	jmp    801086f2 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
801086a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086a8:	8b 00                	mov    (%eax),%eax
801086aa:	83 e0 01             	and    $0x1,%eax
801086ad:	85 c0                	test   %eax,%eax
801086af:	74 41                	je     801086f2 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
801086b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086b4:	8b 00                	mov    (%eax),%eax
801086b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801086be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801086c2:	75 0c                	jne    801086d0 <deallocuvm+0x82>
        panic("kfree");
801086c4:	c7 04 24 41 92 10 80 	movl   $0x80109241,(%esp)
801086cb:	e8 6a 7e ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
801086d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086d3:	89 04 24             	mov    %eax,(%esp)
801086d6:	e8 0e f5 ff ff       	call   80107be9 <p2v>
801086db:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801086de:	8b 45 e8             	mov    -0x18(%ebp),%eax
801086e1:	89 04 24             	mov    %eax,(%esp)
801086e4:	e8 23 a4 ff ff       	call   80102b0c <kfree>
      *pte = 0;
801086e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801086f2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801086f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086ff:	0f 82 74 ff ff ff    	jb     80108679 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108705:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108708:	c9                   	leave  
80108709:	c3                   	ret    

8010870a <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010870a:	55                   	push   %ebp
8010870b:	89 e5                	mov    %esp,%ebp
8010870d:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108710:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108714:	75 0c                	jne    80108722 <freevm+0x18>
    panic("freevm: no pgdir");
80108716:	c7 04 24 47 92 10 80 	movl   $0x80109247,(%esp)
8010871d:	e8 18 7e ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108722:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108729:	00 
8010872a:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108731:	80 
80108732:	8b 45 08             	mov    0x8(%ebp),%eax
80108735:	89 04 24             	mov    %eax,(%esp)
80108738:	e8 11 ff ff ff       	call   8010864e <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
8010873d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108744:	eb 48                	jmp    8010878e <freevm+0x84>
    if(pgdir[i] & PTE_P){
80108746:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108749:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108750:	8b 45 08             	mov    0x8(%ebp),%eax
80108753:	01 d0                	add    %edx,%eax
80108755:	8b 00                	mov    (%eax),%eax
80108757:	83 e0 01             	and    $0x1,%eax
8010875a:	85 c0                	test   %eax,%eax
8010875c:	74 2c                	je     8010878a <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
8010875e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108761:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108768:	8b 45 08             	mov    0x8(%ebp),%eax
8010876b:	01 d0                	add    %edx,%eax
8010876d:	8b 00                	mov    (%eax),%eax
8010876f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108774:	89 04 24             	mov    %eax,(%esp)
80108777:	e8 6d f4 ff ff       	call   80107be9 <p2v>
8010877c:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010877f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108782:	89 04 24             	mov    %eax,(%esp)
80108785:	e8 82 a3 ff ff       	call   80102b0c <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010878a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010878e:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108795:	76 af                	jbe    80108746 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108797:	8b 45 08             	mov    0x8(%ebp),%eax
8010879a:	89 04 24             	mov    %eax,(%esp)
8010879d:	e8 6a a3 ff ff       	call   80102b0c <kfree>
}
801087a2:	c9                   	leave  
801087a3:	c3                   	ret    

801087a4 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801087a4:	55                   	push   %ebp
801087a5:	89 e5                	mov    %esp,%ebp
801087a7:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801087aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801087b1:	00 
801087b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801087b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801087b9:	8b 45 08             	mov    0x8(%ebp),%eax
801087bc:	89 04 24             	mov    %eax,(%esp)
801087bf:	e8 a8 f8 ff ff       	call   8010806c <walkpgdir>
801087c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801087c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801087cb:	75 0c                	jne    801087d9 <clearpteu+0x35>
    panic("clearpteu");
801087cd:	c7 04 24 58 92 10 80 	movl   $0x80109258,(%esp)
801087d4:	e8 61 7d ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
801087d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087dc:	8b 00                	mov    (%eax),%eax
801087de:	83 e0 fb             	and    $0xfffffffb,%eax
801087e1:	89 c2                	mov    %eax,%edx
801087e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087e6:	89 10                	mov    %edx,(%eax)
}
801087e8:	c9                   	leave  
801087e9:	c3                   	ret    

801087ea <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801087ea:	55                   	push   %ebp
801087eb:	89 e5                	mov    %esp,%ebp
801087ed:	53                   	push   %ebx
801087ee:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801087f1:	e8 b0 f9 ff ff       	call   801081a6 <setupkvm>
801087f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801087f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801087fd:	75 0a                	jne    80108809 <copyuvm+0x1f>
    return 0;
801087ff:	b8 00 00 00 00       	mov    $0x0,%eax
80108804:	e9 fd 00 00 00       	jmp    80108906 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108809:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108810:	e9 d0 00 00 00       	jmp    801088e5 <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108818:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010881f:	00 
80108820:	89 44 24 04          	mov    %eax,0x4(%esp)
80108824:	8b 45 08             	mov    0x8(%ebp),%eax
80108827:	89 04 24             	mov    %eax,(%esp)
8010882a:	e8 3d f8 ff ff       	call   8010806c <walkpgdir>
8010882f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108832:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108836:	75 0c                	jne    80108844 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108838:	c7 04 24 62 92 10 80 	movl   $0x80109262,(%esp)
8010883f:	e8 f6 7c ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
80108844:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108847:	8b 00                	mov    (%eax),%eax
80108849:	83 e0 01             	and    $0x1,%eax
8010884c:	85 c0                	test   %eax,%eax
8010884e:	75 0c                	jne    8010885c <copyuvm+0x72>
      panic("copyuvm: page not present");
80108850:	c7 04 24 7c 92 10 80 	movl   $0x8010927c,(%esp)
80108857:	e8 de 7c ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
8010885c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010885f:	8b 00                	mov    (%eax),%eax
80108861:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108866:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108869:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010886c:	8b 00                	mov    (%eax),%eax
8010886e:	25 ff 0f 00 00       	and    $0xfff,%eax
80108873:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108876:	e8 2a a3 ff ff       	call   80102ba5 <kalloc>
8010887b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010887e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108882:	75 02                	jne    80108886 <copyuvm+0x9c>
      goto bad;
80108884:	eb 70                	jmp    801088f6 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108886:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108889:	89 04 24             	mov    %eax,(%esp)
8010888c:	e8 58 f3 ff ff       	call   80107be9 <p2v>
80108891:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108898:	00 
80108899:	89 44 24 04          	mov    %eax,0x4(%esp)
8010889d:	8b 45 e0             	mov    -0x20(%ebp),%eax
801088a0:	89 04 24             	mov    %eax,(%esp)
801088a3:	e8 ff cd ff ff       	call   801056a7 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801088a8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801088ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801088ae:	89 04 24             	mov    %eax,(%esp)
801088b1:	e8 26 f3 ff ff       	call   80107bdc <v2p>
801088b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801088b9:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801088bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
801088c1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801088c8:	00 
801088c9:	89 54 24 04          	mov    %edx,0x4(%esp)
801088cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088d0:	89 04 24             	mov    %eax,(%esp)
801088d3:	e8 36 f8 ff ff       	call   8010810e <mappages>
801088d8:	85 c0                	test   %eax,%eax
801088da:	79 02                	jns    801088de <copyuvm+0xf4>
      goto bad;
801088dc:	eb 18                	jmp    801088f6 <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801088de:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801088e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
801088eb:	0f 82 24 ff ff ff    	jb     80108815 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801088f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088f4:	eb 10                	jmp    80108906 <copyuvm+0x11c>

bad:
  freevm(d);
801088f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088f9:	89 04 24             	mov    %eax,(%esp)
801088fc:	e8 09 fe ff ff       	call   8010870a <freevm>
  return 0;
80108901:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108906:	83 c4 44             	add    $0x44,%esp
80108909:	5b                   	pop    %ebx
8010890a:	5d                   	pop    %ebp
8010890b:	c3                   	ret    

8010890c <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010890c:	55                   	push   %ebp
8010890d:	89 e5                	mov    %esp,%ebp
8010890f:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108912:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108919:	00 
8010891a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010891d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108921:	8b 45 08             	mov    0x8(%ebp),%eax
80108924:	89 04 24             	mov    %eax,(%esp)
80108927:	e8 40 f7 ff ff       	call   8010806c <walkpgdir>
8010892c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010892f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108932:	8b 00                	mov    (%eax),%eax
80108934:	83 e0 01             	and    $0x1,%eax
80108937:	85 c0                	test   %eax,%eax
80108939:	75 07                	jne    80108942 <uva2ka+0x36>
    return 0;
8010893b:	b8 00 00 00 00       	mov    $0x0,%eax
80108940:	eb 25                	jmp    80108967 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108942:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108945:	8b 00                	mov    (%eax),%eax
80108947:	83 e0 04             	and    $0x4,%eax
8010894a:	85 c0                	test   %eax,%eax
8010894c:	75 07                	jne    80108955 <uva2ka+0x49>
    return 0;
8010894e:	b8 00 00 00 00       	mov    $0x0,%eax
80108953:	eb 12                	jmp    80108967 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108958:	8b 00                	mov    (%eax),%eax
8010895a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010895f:	89 04 24             	mov    %eax,(%esp)
80108962:	e8 82 f2 ff ff       	call   80107be9 <p2v>
}
80108967:	c9                   	leave  
80108968:	c3                   	ret    

80108969 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108969:	55                   	push   %ebp
8010896a:	89 e5                	mov    %esp,%ebp
8010896c:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010896f:	8b 45 10             	mov    0x10(%ebp),%eax
80108972:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108975:	e9 87 00 00 00       	jmp    80108a01 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
8010897a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010897d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108982:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108985:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108988:	89 44 24 04          	mov    %eax,0x4(%esp)
8010898c:	8b 45 08             	mov    0x8(%ebp),%eax
8010898f:	89 04 24             	mov    %eax,(%esp)
80108992:	e8 75 ff ff ff       	call   8010890c <uva2ka>
80108997:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010899a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010899e:	75 07                	jne    801089a7 <copyout+0x3e>
      return -1;
801089a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801089a5:	eb 69                	jmp    80108a10 <copyout+0xa7>
    n = PGSIZE - (va - va0);
801089a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801089aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
801089ad:	29 c2                	sub    %eax,%edx
801089af:	89 d0                	mov    %edx,%eax
801089b1:	05 00 10 00 00       	add    $0x1000,%eax
801089b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801089b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089bc:	3b 45 14             	cmp    0x14(%ebp),%eax
801089bf:	76 06                	jbe    801089c7 <copyout+0x5e>
      n = len;
801089c1:	8b 45 14             	mov    0x14(%ebp),%eax
801089c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801089c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089ca:	8b 55 0c             	mov    0xc(%ebp),%edx
801089cd:	29 c2                	sub    %eax,%edx
801089cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801089d2:	01 c2                	add    %eax,%edx
801089d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089d7:	89 44 24 08          	mov    %eax,0x8(%esp)
801089db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089de:	89 44 24 04          	mov    %eax,0x4(%esp)
801089e2:	89 14 24             	mov    %edx,(%esp)
801089e5:	e8 bd cc ff ff       	call   801056a7 <memmove>
    len -= n;
801089ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089ed:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801089f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089f3:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801089f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089f9:	05 00 10 00 00       	add    $0x1000,%eax
801089fe:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108a01:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108a05:	0f 85 6f ff ff ff    	jne    8010897a <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108a0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108a10:	c9                   	leave  
80108a11:	c3                   	ret    

80108a12 <randomgenerator>:
#include "defs.h"

// Return a integer between 0 and ((2^32 - 1) / 2), which is 2147483647.
uint
randomgenerator(void)
{
80108a12:	55                   	push   %ebp
80108a13:	89 e5                	mov    %esp,%ebp
80108a15:	83 ec 10             	sub    $0x10,%esp
  static unsigned int z1 = 12345, z2 = 12345, z3 = 12345, z4 = 12345;
  unsigned int b;
  b  = ((z1 << 6) ^ z1) >> 13;
80108a18:	a1 20 c5 10 80       	mov    0x8010c520,%eax
80108a1d:	c1 e0 06             	shl    $0x6,%eax
80108a20:	89 c2                	mov    %eax,%edx
80108a22:	a1 20 c5 10 80       	mov    0x8010c520,%eax
80108a27:	31 d0                	xor    %edx,%eax
80108a29:	c1 e8 0d             	shr    $0xd,%eax
80108a2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z1 = ((z1 & 4294967294U) << 18) ^ b;
80108a2f:	a1 20 c5 10 80       	mov    0x8010c520,%eax
80108a34:	83 e0 fe             	and    $0xfffffffe,%eax
80108a37:	c1 e0 12             	shl    $0x12,%eax
80108a3a:	33 45 fc             	xor    -0x4(%ebp),%eax
80108a3d:	a3 20 c5 10 80       	mov    %eax,0x8010c520
  b  = ((z2 << 2) ^ z2) >> 27; 
80108a42:	a1 24 c5 10 80       	mov    0x8010c524,%eax
80108a47:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108a4e:	a1 24 c5 10 80       	mov    0x8010c524,%eax
80108a53:	31 d0                	xor    %edx,%eax
80108a55:	c1 e8 1b             	shr    $0x1b,%eax
80108a58:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z2 = ((z2 & 4294967288U) << 2) ^ b;
80108a5b:	a1 24 c5 10 80       	mov    0x8010c524,%eax
80108a60:	83 e0 f8             	and    $0xfffffff8,%eax
80108a63:	c1 e0 02             	shl    $0x2,%eax
80108a66:	33 45 fc             	xor    -0x4(%ebp),%eax
80108a69:	a3 24 c5 10 80       	mov    %eax,0x8010c524
  b  = ((z3 << 13) ^ z3) >> 21;
80108a6e:	a1 28 c5 10 80       	mov    0x8010c528,%eax
80108a73:	c1 e0 0d             	shl    $0xd,%eax
80108a76:	89 c2                	mov    %eax,%edx
80108a78:	a1 28 c5 10 80       	mov    0x8010c528,%eax
80108a7d:	31 d0                	xor    %edx,%eax
80108a7f:	c1 e8 15             	shr    $0x15,%eax
80108a82:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z3 = ((z3 & 4294967280U) << 7) ^ b;
80108a85:	a1 28 c5 10 80       	mov    0x8010c528,%eax
80108a8a:	83 e0 f0             	and    $0xfffffff0,%eax
80108a8d:	c1 e0 07             	shl    $0x7,%eax
80108a90:	33 45 fc             	xor    -0x4(%ebp),%eax
80108a93:	a3 28 c5 10 80       	mov    %eax,0x8010c528
  b  = ((z4 << 3) ^ z4) >> 12;
80108a98:	a1 2c c5 10 80       	mov    0x8010c52c,%eax
80108a9d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80108aa4:	a1 2c c5 10 80       	mov    0x8010c52c,%eax
80108aa9:	31 d0                	xor    %edx,%eax
80108aab:	c1 e8 0c             	shr    $0xc,%eax
80108aae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  z4 = ((z4 & 4294967168U) << 13) ^ b;
80108ab1:	a1 2c c5 10 80       	mov    0x8010c52c,%eax
80108ab6:	83 e0 80             	and    $0xffffff80,%eax
80108ab9:	c1 e0 0d             	shl    $0xd,%eax
80108abc:	33 45 fc             	xor    -0x4(%ebp),%eax
80108abf:	a3 2c c5 10 80       	mov    %eax,0x8010c52c

  return (z1 ^ z2 ^ z3 ^ z4) / 2;
80108ac4:	8b 15 20 c5 10 80    	mov    0x8010c520,%edx
80108aca:	a1 24 c5 10 80       	mov    0x8010c524,%eax
80108acf:	31 c2                	xor    %eax,%edx
80108ad1:	a1 28 c5 10 80       	mov    0x8010c528,%eax
80108ad6:	31 c2                	xor    %eax,%edx
80108ad8:	a1 2c c5 10 80       	mov    0x8010c52c,%eax
80108add:	31 d0                	xor    %edx,%eax
80108adf:	d1 e8                	shr    %eax
}
80108ae1:	c9                   	leave  
80108ae2:	c3                   	ret    

80108ae3 <randomgeneratorrange>:

int
randomgeneratorrange(int low, int high)
{
80108ae3:	55                   	push   %ebp
80108ae4:	89 e5                	mov    %esp,%ebp
80108ae6:	83 ec 10             	sub    $0x10,%esp
  if (high < low) {
80108ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
80108aec:	3b 45 08             	cmp    0x8(%ebp),%eax
80108aef:	7d 12                	jge    80108b03 <randomgeneratorrange+0x20>
    int temp = low;
80108af1:	8b 45 08             	mov    0x8(%ebp),%eax
80108af4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    low = high;
80108af7:	8b 45 0c             	mov    0xc(%ebp),%eax
80108afa:	89 45 08             	mov    %eax,0x8(%ebp)
    high = temp;
80108afd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108b00:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  int range = high - low + 1;
80108b03:	8b 45 08             	mov    0x8(%ebp),%eax
80108b06:	8b 55 0c             	mov    0xc(%ebp),%edx
80108b09:	29 c2                	sub    %eax,%edx
80108b0b:	89 d0                	mov    %edx,%eax
80108b0d:	83 c0 01             	add    $0x1,%eax
80108b10:	89 45 f8             	mov    %eax,-0x8(%ebp)
  return randomgenerator() % (range) + low;
80108b13:	e8 fa fe ff ff       	call   80108a12 <randomgenerator>
80108b18:	8b 4d f8             	mov    -0x8(%ebp),%ecx
80108b1b:	ba 00 00 00 00       	mov    $0x0,%edx
80108b20:	f7 f1                	div    %ecx
80108b22:	8b 45 08             	mov    0x8(%ebp),%eax
80108b25:	01 d0                	add    %edx,%eax
}
80108b27:	c9                   	leave  
80108b28:	c3                   	ret    
