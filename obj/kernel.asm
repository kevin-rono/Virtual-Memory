
obj/kernel.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000040000 <entry_from_boot>:
# The entry_from_boot routine sets the stack pointer to the top of the
# OS kernel stack, then jumps to the `kernel` routine.

.globl entry_from_boot
entry_from_boot:
        movq $0x80000, %rsp
   40000:	48 c7 c4 00 00 08 00 	mov    $0x80000,%rsp
        movq %rsp, %rbp
   40007:	48 89 e5             	mov    %rsp,%rbp
        pushq $0
   4000a:	6a 00                	pushq  $0x0
        popfq
   4000c:	9d                   	popfq  
        // Check for multiboot command line; if found pass it along.
        cmpl $0x2BADB002, %eax
   4000d:	3d 02 b0 ad 2b       	cmp    $0x2badb002,%eax
        jne 1f
   40012:	75 0d                	jne    40021 <entry_from_boot+0x21>
        testl $4, (%rbx)
   40014:	f7 03 04 00 00 00    	testl  $0x4,(%rbx)
        je 1f
   4001a:	74 05                	je     40021 <entry_from_boot+0x21>
        movl 16(%rbx), %edi
   4001c:	8b 7b 10             	mov    0x10(%rbx),%edi
        jmp 2f
   4001f:	eb 07                	jmp    40028 <entry_from_boot+0x28>
1:      movq $0, %rdi
   40021:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
2:      jmp kernel
   40028:	e9 3a 01 00 00       	jmpq   40167 <kernel>
   4002d:	90                   	nop

000000000004002e <gpf_int_handler>:
# Interrupt handlers
.align 2

        .globl gpf_int_handler
gpf_int_handler:
        pushq $13               // trap number
   4002e:	6a 0d                	pushq  $0xd
        jmp generic_exception_handler
   40030:	eb 6e                	jmp    400a0 <generic_exception_handler>

0000000000040032 <pagefault_int_handler>:

        .globl pagefault_int_handler
pagefault_int_handler:
        pushq $14
   40032:	6a 0e                	pushq  $0xe
        jmp generic_exception_handler
   40034:	eb 6a                	jmp    400a0 <generic_exception_handler>

0000000000040036 <timer_int_handler>:

        .globl timer_int_handler
timer_int_handler:
        pushq $0                // error code
   40036:	6a 00                	pushq  $0x0
        pushq $32
   40038:	6a 20                	pushq  $0x20
        jmp generic_exception_handler
   4003a:	eb 64                	jmp    400a0 <generic_exception_handler>

000000000004003c <sys48_int_handler>:

sys48_int_handler:
        pushq $0
   4003c:	6a 00                	pushq  $0x0
        pushq $48
   4003e:	6a 30                	pushq  $0x30
        jmp generic_exception_handler
   40040:	eb 5e                	jmp    400a0 <generic_exception_handler>

0000000000040042 <sys49_int_handler>:

sys49_int_handler:
        pushq $0
   40042:	6a 00                	pushq  $0x0
        pushq $49
   40044:	6a 31                	pushq  $0x31
        jmp generic_exception_handler
   40046:	eb 58                	jmp    400a0 <generic_exception_handler>

0000000000040048 <sys50_int_handler>:

sys50_int_handler:
        pushq $0
   40048:	6a 00                	pushq  $0x0
        pushq $50
   4004a:	6a 32                	pushq  $0x32
        jmp generic_exception_handler
   4004c:	eb 52                	jmp    400a0 <generic_exception_handler>

000000000004004e <sys51_int_handler>:

sys51_int_handler:
        pushq $0
   4004e:	6a 00                	pushq  $0x0
        pushq $51
   40050:	6a 33                	pushq  $0x33
        jmp generic_exception_handler
   40052:	eb 4c                	jmp    400a0 <generic_exception_handler>

0000000000040054 <sys52_int_handler>:

sys52_int_handler:
        pushq $0
   40054:	6a 00                	pushq  $0x0
        pushq $52
   40056:	6a 34                	pushq  $0x34
        jmp generic_exception_handler
   40058:	eb 46                	jmp    400a0 <generic_exception_handler>

000000000004005a <sys53_int_handler>:

sys53_int_handler:
        pushq $0
   4005a:	6a 00                	pushq  $0x0
        pushq $53
   4005c:	6a 35                	pushq  $0x35
        jmp generic_exception_handler
   4005e:	eb 40                	jmp    400a0 <generic_exception_handler>

0000000000040060 <sys54_int_handler>:

sys54_int_handler:
        pushq $0
   40060:	6a 00                	pushq  $0x0
        pushq $54
   40062:	6a 36                	pushq  $0x36
        jmp generic_exception_handler
   40064:	eb 3a                	jmp    400a0 <generic_exception_handler>

0000000000040066 <sys55_int_handler>:

sys55_int_handler:
        pushq $0
   40066:	6a 00                	pushq  $0x0
        pushq $55
   40068:	6a 37                	pushq  $0x37
        jmp generic_exception_handler
   4006a:	eb 34                	jmp    400a0 <generic_exception_handler>

000000000004006c <sys56_int_handler>:

sys56_int_handler:
        pushq $0
   4006c:	6a 00                	pushq  $0x0
        pushq $56
   4006e:	6a 38                	pushq  $0x38
        jmp generic_exception_handler
   40070:	eb 2e                	jmp    400a0 <generic_exception_handler>

0000000000040072 <sys57_int_handler>:

sys57_int_handler:
        pushq $0
   40072:	6a 00                	pushq  $0x0
        pushq $57
   40074:	6a 39                	pushq  $0x39
        jmp generic_exception_handler
   40076:	eb 28                	jmp    400a0 <generic_exception_handler>

0000000000040078 <sys58_int_handler>:

sys58_int_handler:
        pushq $0
   40078:	6a 00                	pushq  $0x0
        pushq $58
   4007a:	6a 3a                	pushq  $0x3a
        jmp generic_exception_handler
   4007c:	eb 22                	jmp    400a0 <generic_exception_handler>

000000000004007e <sys59_int_handler>:

sys59_int_handler:
        pushq $0
   4007e:	6a 00                	pushq  $0x0
        pushq $59
   40080:	6a 3b                	pushq  $0x3b
        jmp generic_exception_handler
   40082:	eb 1c                	jmp    400a0 <generic_exception_handler>

0000000000040084 <sys60_int_handler>:

sys60_int_handler:
        pushq $0
   40084:	6a 00                	pushq  $0x0
        pushq $60
   40086:	6a 3c                	pushq  $0x3c
        jmp generic_exception_handler
   40088:	eb 16                	jmp    400a0 <generic_exception_handler>

000000000004008a <sys61_int_handler>:

sys61_int_handler:
        pushq $0
   4008a:	6a 00                	pushq  $0x0
        pushq $61
   4008c:	6a 3d                	pushq  $0x3d
        jmp generic_exception_handler
   4008e:	eb 10                	jmp    400a0 <generic_exception_handler>

0000000000040090 <sys62_int_handler>:

sys62_int_handler:
        pushq $0
   40090:	6a 00                	pushq  $0x0
        pushq $62
   40092:	6a 3e                	pushq  $0x3e
        jmp generic_exception_handler
   40094:	eb 0a                	jmp    400a0 <generic_exception_handler>

0000000000040096 <sys63_int_handler>:

sys63_int_handler:
        pushq $0
   40096:	6a 00                	pushq  $0x0
        pushq $63
   40098:	6a 3f                	pushq  $0x3f
        jmp generic_exception_handler
   4009a:	eb 04                	jmp    400a0 <generic_exception_handler>

000000000004009c <default_int_handler>:

        .globl default_int_handler
default_int_handler:
        pushq $0
   4009c:	6a 00                	pushq  $0x0
        jmp generic_exception_handler
   4009e:	eb 00                	jmp    400a0 <generic_exception_handler>

00000000000400a0 <generic_exception_handler>:


generic_exception_handler:
        pushq %gs
   400a0:	0f a8                	pushq  %gs
        pushq %fs
   400a2:	0f a0                	pushq  %fs
        pushq %r15
   400a4:	41 57                	push   %r15
        pushq %r14
   400a6:	41 56                	push   %r14
        pushq %r13
   400a8:	41 55                	push   %r13
        pushq %r12
   400aa:	41 54                	push   %r12
        pushq %r11
   400ac:	41 53                	push   %r11
        pushq %r10
   400ae:	41 52                	push   %r10
        pushq %r9
   400b0:	41 51                	push   %r9
        pushq %r8
   400b2:	41 50                	push   %r8
        pushq %rdi
   400b4:	57                   	push   %rdi
        pushq %rsi
   400b5:	56                   	push   %rsi
        pushq %rbp
   400b6:	55                   	push   %rbp
        pushq %rbx
   400b7:	53                   	push   %rbx
        pushq %rdx
   400b8:	52                   	push   %rdx
        pushq %rcx
   400b9:	51                   	push   %rcx
        pushq %rax
   400ba:	50                   	push   %rax
        movq %rsp, %rdi
   400bb:	48 89 e7             	mov    %rsp,%rdi
        call exception
   400be:	e8 05 0c 00 00       	callq  40cc8 <exception>

00000000000400c3 <exception_return>:
        # `exception` should never return.


        .globl exception_return
exception_return:
        movq %rdi, %rsp
   400c3:	48 89 fc             	mov    %rdi,%rsp
        popq %rax
   400c6:	58                   	pop    %rax
        popq %rcx
   400c7:	59                   	pop    %rcx
        popq %rdx
   400c8:	5a                   	pop    %rdx
        popq %rbx
   400c9:	5b                   	pop    %rbx
        popq %rbp
   400ca:	5d                   	pop    %rbp
        popq %rsi
   400cb:	5e                   	pop    %rsi
        popq %rdi
   400cc:	5f                   	pop    %rdi
        popq %r8
   400cd:	41 58                	pop    %r8
        popq %r9
   400cf:	41 59                	pop    %r9
        popq %r10
   400d1:	41 5a                	pop    %r10
        popq %r11
   400d3:	41 5b                	pop    %r11
        popq %r12
   400d5:	41 5c                	pop    %r12
        popq %r13
   400d7:	41 5d                	pop    %r13
        popq %r14
   400d9:	41 5e                	pop    %r14
        popq %r15
   400db:	41 5f                	pop    %r15
        popq %fs
   400dd:	0f a1                	popq   %fs
        popq %gs
   400df:	0f a9                	popq   %gs
        addq $16, %rsp
   400e1:	48 83 c4 10          	add    $0x10,%rsp
        iretq
   400e5:	48 cf                	iretq  

00000000000400e7 <sys_int_handlers>:
   400e7:	3c 00                	cmp    $0x0,%al
   400e9:	04 00                	add    $0x0,%al
   400eb:	00 00                	add    %al,(%rax)
   400ed:	00 00                	add    %al,(%rax)
   400ef:	42 00 04 00          	add    %al,(%rax,%r8,1)
   400f3:	00 00                	add    %al,(%rax)
   400f5:	00 00                	add    %al,(%rax)
   400f7:	48 00 04 00          	rex.W add %al,(%rax,%rax,1)
   400fb:	00 00                	add    %al,(%rax)
   400fd:	00 00                	add    %al,(%rax)
   400ff:	4e 00 04 00          	rex.WRX add %r8b,(%rax,%r8,1)
   40103:	00 00                	add    %al,(%rax)
   40105:	00 00                	add    %al,(%rax)
   40107:	54                   	push   %rsp
   40108:	00 04 00             	add    %al,(%rax,%rax,1)
   4010b:	00 00                	add    %al,(%rax)
   4010d:	00 00                	add    %al,(%rax)
   4010f:	5a                   	pop    %rdx
   40110:	00 04 00             	add    %al,(%rax,%rax,1)
   40113:	00 00                	add    %al,(%rax)
   40115:	00 00                	add    %al,(%rax)
   40117:	60                   	(bad)  
   40118:	00 04 00             	add    %al,(%rax,%rax,1)
   4011b:	00 00                	add    %al,(%rax)
   4011d:	00 00                	add    %al,(%rax)
   4011f:	66 00 04 00          	data16 add %al,(%rax,%rax,1)
   40123:	00 00                	add    %al,(%rax)
   40125:	00 00                	add    %al,(%rax)
   40127:	6c                   	insb   (%dx),%es:(%rdi)
   40128:	00 04 00             	add    %al,(%rax,%rax,1)
   4012b:	00 00                	add    %al,(%rax)
   4012d:	00 00                	add    %al,(%rax)
   4012f:	72 00                	jb     40131 <sys_int_handlers+0x4a>
   40131:	04 00                	add    $0x0,%al
   40133:	00 00                	add    %al,(%rax)
   40135:	00 00                	add    %al,(%rax)
   40137:	78 00                	js     40139 <sys_int_handlers+0x52>
   40139:	04 00                	add    $0x0,%al
   4013b:	00 00                	add    %al,(%rax)
   4013d:	00 00                	add    %al,(%rax)
   4013f:	7e 00                	jle    40141 <sys_int_handlers+0x5a>
   40141:	04 00                	add    $0x0,%al
   40143:	00 00                	add    %al,(%rax)
   40145:	00 00                	add    %al,(%rax)
   40147:	84 00                	test   %al,(%rax)
   40149:	04 00                	add    $0x0,%al
   4014b:	00 00                	add    %al,(%rax)
   4014d:	00 00                	add    %al,(%rax)
   4014f:	8a 00                	mov    (%rax),%al
   40151:	04 00                	add    $0x0,%al
   40153:	00 00                	add    %al,(%rax)
   40155:	00 00                	add    %al,(%rax)
   40157:	90                   	nop
   40158:	00 04 00             	add    %al,(%rax,%rax,1)
   4015b:	00 00                	add    %al,(%rax)
   4015d:	00 00                	add    %al,(%rax)
   4015f:	96                   	xchg   %eax,%esi
   40160:	00 04 00             	add    %al,(%rax,%rax,1)
   40163:	00 00                	add    %al,(%rax)
	...

0000000000040167 <kernel>:
//    Initialize the hardware and processes and start running. The `command`
//    string is an optional string passed from the boot loader.

static void process_setup(pid_t pid, int program_number);

void kernel(const char* command) {
   40167:	55                   	push   %rbp
   40168:	48 89 e5             	mov    %rsp,%rbp
   4016b:	48 83 ec 20          	sub    $0x20,%rsp
   4016f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    hardware_init();
   40173:	e8 4a 1b 00 00       	callq  41cc2 <hardware_init>
    pageinfo_init();
   40178:	e8 34 11 00 00       	callq  412b1 <pageinfo_init>
    console_clear();
   4017d:	e8 45 3e 00 00       	callq  43fc7 <console_clear>
    timer_init(HZ);
   40182:	bf 64 00 00 00       	mov    $0x64,%edi
   40187:	e8 0a 20 00 00       	callq  42196 <timer_init>

    virtual_memory_map(kernel_pagetable, (uintptr_t) 0, (uintptr_t) 0,
   4018c:	48 8b 05 85 5e 01 00 	mov    0x15e85(%rip),%rax        # 56018 <kernel_pagetable>
   40193:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   40199:	41 b8 03 00 00 00    	mov    $0x3,%r8d
   4019f:	b9 00 00 10 00       	mov    $0x100000,%ecx
   401a4:	ba 00 00 00 00       	mov    $0x0,%edx
   401a9:	be 00 00 00 00       	mov    $0x0,%esi
   401ae:	48 89 c7             	mov    %rax,%rdi
   401b1:	e8 53 21 00 00       	callq  42309 <virtual_memory_map>
                       PROC_START_ADDR, PTE_P | PTE_W, NULL);

    virtual_memory_map(kernel_pagetable, CONSOLE_ADDR, CONSOLE_ADDR,
   401b6:	ba 00 80 0b 00       	mov    $0xb8000,%edx
   401bb:	be 00 80 0b 00       	mov    $0xb8000,%esi
   401c0:	48 8b 05 51 5e 01 00 	mov    0x15e51(%rip),%rax        # 56018 <kernel_pagetable>
   401c7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   401cd:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   401d3:	b9 00 10 00 00       	mov    $0x1000,%ecx
   401d8:	48 89 c7             	mov    %rax,%rdi
   401db:	e8 29 21 00 00       	callq  42309 <virtual_memory_map>
                       PAGESIZE, PTE_P | PTE_W | PTE_U, NULL);

    // Set up process descriptors
    memset(processes, 0, sizeof(processes));
   401e0:	ba 80 0d 00 00       	mov    $0xd80,%edx
   401e5:	be 00 00 00 00       	mov    $0x0,%esi
   401ea:	bf 00 d0 04 00       	mov    $0x4d000,%edi
   401ef:	e8 de 34 00 00       	callq  436d2 <memset>

    for (pid_t i = 0; i < NPROC; i++) {
   401f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   401fb:	eb 58                	jmp    40255 <kernel+0xee>
        processes[i].p_pid = i;
   401fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40200:	48 63 d0             	movslq %eax,%rdx
   40203:	48 89 d0             	mov    %rdx,%rax
   40206:	48 01 c0             	add    %rax,%rax
   40209:	48 01 d0             	add    %rdx,%rax
   4020c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40213:	00 
   40214:	48 01 d0             	add    %rdx,%rax
   40217:	48 c1 e0 03          	shl    $0x3,%rax
   4021b:	48 8d 90 00 d0 04 00 	lea    0x4d000(%rax),%rdx
   40222:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40225:	89 02                	mov    %eax,(%rdx)
        processes[i].p_state = P_FREE;
   40227:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4022a:	48 63 d0             	movslq %eax,%rdx
   4022d:	48 89 d0             	mov    %rdx,%rax
   40230:	48 01 c0             	add    %rax,%rax
   40233:	48 01 d0             	add    %rdx,%rax
   40236:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   4023d:	00 
   4023e:	48 01 d0             	add    %rdx,%rax
   40241:	48 c1 e0 03          	shl    $0x3,%rax
   40245:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   4024b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    for (pid_t i = 0; i < NPROC; i++) {
   40251:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   40255:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   40259:	7e a2                	jle    401fd <kernel+0x96>
    }

    if (command && strcmp(command, "fork") == 0) 
   4025b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   40260:	74 26                	je     40288 <kernel+0x121>
   40262:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40266:	be 00 40 04 00       	mov    $0x44000,%esi
   4026b:	48 89 c7             	mov    %rax,%rdi
   4026e:	e8 cc 34 00 00       	callq  4373f <strcmp>
   40273:	85 c0                	test   %eax,%eax
   40275:	75 11                	jne    40288 <kernel+0x121>
    {
        process_setup(1, 4);
   40277:	be 04 00 00 00       	mov    $0x4,%esi
   4027c:	bf 01 00 00 00       	mov    $0x1,%edi
   40281:	e8 32 04 00 00       	callq  406b8 <process_setup>
   40286:	eb 52                	jmp    402da <kernel+0x173>
    } 
    else if (command && strcmp(command, "forkexit") == 0) 
   40288:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   4028d:	74 26                	je     402b5 <kernel+0x14e>
   4028f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40293:	be 05 40 04 00       	mov    $0x44005,%esi
   40298:	48 89 c7             	mov    %rax,%rdi
   4029b:	e8 9f 34 00 00       	callq  4373f <strcmp>
   402a0:	85 c0                	test   %eax,%eax
   402a2:	75 11                	jne    402b5 <kernel+0x14e>
    {
        process_setup(1, 5);
   402a4:	be 05 00 00 00       	mov    $0x5,%esi
   402a9:	bf 01 00 00 00       	mov    $0x1,%edi
   402ae:	e8 05 04 00 00       	callq  406b8 <process_setup>
   402b3:	eb 25                	jmp    402da <kernel+0x173>
    } 
    else 
    {
        for (pid_t i = 1; i <= 4; ++i) 
   402b5:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
   402bc:	eb 16                	jmp    402d4 <kernel+0x16d>
        {
            process_setup(i, i - 1);
   402be:	8b 45 f8             	mov    -0x8(%rbp),%eax
   402c1:	8d 50 ff             	lea    -0x1(%rax),%edx
   402c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
   402c7:	89 d6                	mov    %edx,%esi
   402c9:	89 c7                	mov    %eax,%edi
   402cb:	e8 e8 03 00 00       	callq  406b8 <process_setup>
        for (pid_t i = 1; i <= 4; ++i) 
   402d0:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   402d4:	83 7d f8 04          	cmpl   $0x4,-0x8(%rbp)
   402d8:	7e e4                	jle    402be <kernel+0x157>
        }
    }

    // Switch to the first process using run()
    run(&processes[1]);
   402da:	bf d8 d0 04 00       	mov    $0x4d0d8,%edi
   402df:	e8 70 0f 00 00       	callq  41254 <run>

00000000000402e4 <my_alloc_page>:
// my_alloc_page(pid_t pid) 
//      function to allocate a page and assign it to a process (pid)
//      reset it to empty (memset to zero)
//      returns the address of the reserved page
void *my_alloc_page(pid_t pid)  
{
   402e4:	55                   	push   %rbp
   402e5:	48 89 e5             	mov    %rsp,%rbp
   402e8:	48 83 ec 20          	sub    $0x20,%rsp
   402ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
    int pn = 0;
   402ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

    // check if page is free
    for (pn = 1; pn < NPAGES; pn++)
   402f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
   402fd:	eb 25                	jmp    40324 <my_alloc_page+0x40>
    {
        if (pageinfo[pn].refcount == 0)
   402ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40302:	48 98                	cltq   
   40304:	0f b6 84 00 a1 dd 04 	movzbl 0x4dda1(%rax,%rax,1),%eax
   4030b:	00 
   4030c:	84 c0                	test   %al,%al
   4030e:	74 1f                	je     4032f <my_alloc_page+0x4b>
        {
            break;
        }
        else if (pn == NPAGES - 1)
   40310:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   40317:	75 07                	jne    40320 <my_alloc_page+0x3c>
        {
            return NULL;
   40319:	b8 00 00 00 00       	mov    $0x0,%eax
   4031e:	eb 43                	jmp    40363 <my_alloc_page+0x7f>
    for (pn = 1; pn < NPAGES; pn++)
   40320:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   40324:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   4032b:	7e d2                	jle    402ff <my_alloc_page+0x1b>
   4032d:	eb 01                	jmp    40330 <my_alloc_page+0x4c>
            break;
   4032f:	90                   	nop
        }
    }

    // assign it to the pid
    int r = assign_physical_page(PAGEADDRESS(pn), pid);
   40330:	8b 45 ec             	mov    -0x14(%rbp),%eax
   40333:	0f be c0             	movsbl %al,%eax
   40336:	8b 55 fc             	mov    -0x4(%rbp),%edx
   40339:	48 63 d2             	movslq %edx,%rdx
   4033c:	48 c1 e2 0c          	shl    $0xc,%rdx
   40340:	89 c6                	mov    %eax,%esi
   40342:	48 89 d7             	mov    %rdx,%rdi
   40345:	e8 16 05 00 00       	callq  40860 <assign_physical_page>
   4034a:	89 45 f8             	mov    %eax,-0x8(%rbp)

    // memset page to 0 
    // return the addr of the assigned page
    if (r >= 0)
   4034d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
   40351:	78 0b                	js     4035e <my_alloc_page+0x7a>
    {
        return (void *) PAGEADDRESS(pn);
   40353:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40356:	48 98                	cltq   
   40358:	48 c1 e0 0c          	shl    $0xc,%rax
   4035c:	eb 05                	jmp    40363 <my_alloc_page+0x7f>
    }
    else
    {
        return NULL;
   4035e:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
   40363:	c9                   	leaveq 
   40364:	c3                   	retq   

0000000000040365 <copy_pagetable>:

// copy_pagetable(x86_64_pagetable *pagetable, int8_t owner) 
//      function to allocate and return a new page table
//      the page table is a copy of 'pagetable'
x86_64_pagetable *copy_pagetable(x86_64_pagetable *pagetable, int8_t owner) 
{
   40365:	55                   	push   %rbp
   40366:	48 89 e5             	mov    %rsp,%rbp
   40369:	48 83 ec 60          	sub    $0x60,%rsp
   4036d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   40371:	89 f0                	mov    %esi,%eax
   40373:	88 45 a4             	mov    %al,-0x5c(%rbp)
    void *pml4, *pdpt, *pd, *pt, *pt2 = NULL;
   40376:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
   4037d:	00 

    pml4 = my_alloc_page(owner);
   4037e:	0f be 45 a4          	movsbl -0x5c(%rbp),%eax
   40382:	89 c7                	mov    %eax,%edi
   40384:	e8 5b ff ff ff       	callq  402e4 <my_alloc_page>
   40389:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    memset(pml4, 0, PAGESIZE);
   4038d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40391:	ba 00 10 00 00       	mov    $0x1000,%edx
   40396:	be 00 00 00 00       	mov    $0x0,%esi
   4039b:	48 89 c7             	mov    %rax,%rdi
   4039e:	e8 2f 33 00 00       	callq  436d2 <memset>

    pdpt = my_alloc_page(owner);
   403a3:	0f be 45 a4          	movsbl -0x5c(%rbp),%eax
   403a7:	89 c7                	mov    %eax,%edi
   403a9:	e8 36 ff ff ff       	callq  402e4 <my_alloc_page>
   403ae:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    memset(pdpt, 0, PAGESIZE);
   403b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   403b6:	ba 00 10 00 00       	mov    $0x1000,%edx
   403bb:	be 00 00 00 00       	mov    $0x0,%esi
   403c0:	48 89 c7             	mov    %rax,%rdi
   403c3:	e8 0a 33 00 00       	callq  436d2 <memset>

    pd = my_alloc_page(owner);
   403c8:	0f be 45 a4          	movsbl -0x5c(%rbp),%eax
   403cc:	89 c7                	mov    %eax,%edi
   403ce:	e8 11 ff ff ff       	callq  402e4 <my_alloc_page>
   403d3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    memset(pd, 0, PAGESIZE);
   403d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   403db:	ba 00 10 00 00       	mov    $0x1000,%edx
   403e0:	be 00 00 00 00       	mov    $0x0,%esi
   403e5:	48 89 c7             	mov    %rax,%rdi
   403e8:	e8 e5 32 00 00       	callq  436d2 <memset>

    pt = my_alloc_page(owner);
   403ed:	0f be 45 a4          	movsbl -0x5c(%rbp),%eax
   403f1:	89 c7                	mov    %eax,%edi
   403f3:	e8 ec fe ff ff       	callq  402e4 <my_alloc_page>
   403f8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    memset(pt, 0, PAGESIZE);
   403fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   40400:	ba 00 10 00 00       	mov    $0x1000,%edx
   40405:	be 00 00 00 00       	mov    $0x0,%esi
   4040a:	48 89 c7             	mov    %rax,%rdi
   4040d:	e8 c0 32 00 00       	callq  436d2 <memset>

    pt2 = my_alloc_page(owner);
   40412:	0f be 45 a4          	movsbl -0x5c(%rbp),%eax
   40416:	89 c7                	mov    %eax,%edi
   40418:	e8 c7 fe ff ff       	callq  402e4 <my_alloc_page>
   4041d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    memset(pt2, 0, PAGESIZE);
   40421:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   40425:	ba 00 10 00 00       	mov    $0x1000,%edx
   4042a:	be 00 00 00 00       	mov    $0x0,%esi
   4042f:	48 89 c7             	mov    %rax,%rdi
   40432:	e8 9b 32 00 00       	callq  436d2 <memset>
    
    if (pml4 && pdpt && pd && pt && pt2)
   40437:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   4043c:	0f 84 de 00 00 00    	je     40520 <copy_pagetable+0x1bb>
   40442:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   40447:	0f 84 d3 00 00 00    	je     40520 <copy_pagetable+0x1bb>
   4044d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
   40452:	0f 84 c8 00 00 00    	je     40520 <copy_pagetable+0x1bb>
   40458:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
   4045d:	0f 84 bd 00 00 00    	je     40520 <copy_pagetable+0x1bb>
   40463:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
   40468:	0f 84 b2 00 00 00    	je     40520 <copy_pagetable+0x1bb>
    {        
        ((x86_64_pagetable *) pml4)->entry[0] = (x86_64_pageentry_t) (uintptr_t) pdpt | PTE_P | PTE_W | PTE_U;
   4046e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   40472:	48 83 c8 07          	or     $0x7,%rax
   40476:	48 89 c2             	mov    %rax,%rdx
   40479:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4047d:	48 89 10             	mov    %rdx,(%rax)
        ((x86_64_pagetable *) pdpt)->entry[0] = (x86_64_pageentry_t) (uintptr_t) pd | PTE_P | PTE_W | PTE_U;
   40480:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40484:	48 83 c8 07          	or     $0x7,%rax
   40488:	48 89 c2             	mov    %rax,%rdx
   4048b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4048f:	48 89 10             	mov    %rdx,(%rax)
        ((x86_64_pagetable *) pd)->entry[0] = (x86_64_pageentry_t) (uintptr_t) pt | PTE_P | PTE_W | PTE_U;
   40492:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   40496:	48 83 c8 07          	or     $0x7,%rax
   4049a:	48 89 c2             	mov    %rax,%rdx
   4049d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   404a1:	48 89 10             	mov    %rdx,(%rax)
        ((x86_64_pagetable *) pd)->entry[1] = (x86_64_pageentry_t) (uintptr_t) pt2 | PTE_P | PTE_W | PTE_U;
   404a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   404a8:	48 83 c8 07          	or     $0x7,%rax
   404ac:	48 89 c2             	mov    %rax,%rdx
   404af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   404b3:	48 89 50 08          	mov    %rdx,0x8(%rax)

        x86_64_pagetable *process_pagetable = (x86_64_pagetable *) pml4;
   404b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   404bb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)

        vamapping my_map;

        for (uintptr_t va = 0; va < PROC_START_ADDR; va += PAGESIZE)
   404bf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   404c6:	00 
   404c7:	eb 44                	jmp    4050d <copy_pagetable+0x1a8>
        {
            my_map = virtual_memory_lookup(pagetable, va);
   404c9:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
   404cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   404d1:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
   404d5:	48 89 ce             	mov    %rcx,%rsi
   404d8:	48 89 c7             	mov    %rax,%rdi
   404db:	e8 20 22 00 00       	callq  42700 <virtual_memory_lookup>

            virtual_memory_map(process_pagetable, va, my_map.pa, PAGESIZE, my_map.perm, NULL);
   404e0:	8b 4d c0             	mov    -0x40(%rbp),%ecx
   404e3:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   404e7:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   404eb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   404ef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   404f5:	41 89 c8             	mov    %ecx,%r8d
   404f8:	b9 00 10 00 00       	mov    $0x1000,%ecx
   404fd:	48 89 c7             	mov    %rax,%rdi
   40500:	e8 04 1e 00 00       	callq  42309 <virtual_memory_map>
        for (uintptr_t va = 0; va < PROC_START_ADDR; va += PAGESIZE)
   40505:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   4050c:	00 
   4050d:	48 81 7d f8 ff ff 0f 	cmpq   $0xfffff,-0x8(%rbp)
   40514:	00 
   40515:	76 b2                	jbe    404c9 <copy_pagetable+0x164>
        }

        return process_pagetable;
   40517:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4051b:	e9 dc 00 00 00       	jmpq   405fc <copy_pagetable+0x297>
    }
    else
    {
        if (pml4)
   40520:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   40525:	74 24                	je     4054b <copy_pagetable+0x1e6>
        {
            pageinfo[PAGENUMBER((uintptr_t)pml4)].refcount = 0;
   40527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4052b:	48 c1 e8 0c          	shr    $0xc,%rax
   4052f:	48 98                	cltq   
   40531:	c6 84 00 a1 dd 04 00 	movb   $0x0,0x4dda1(%rax,%rax,1)
   40538:	00 
            pageinfo[PAGENUMBER((uintptr_t)pml4)].owner = P_FREE;
   40539:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4053d:	48 c1 e8 0c          	shr    $0xc,%rax
   40541:	48 98                	cltq   
   40543:	c6 84 00 a0 dd 04 00 	movb   $0x0,0x4dda0(%rax,%rax,1)
   4054a:	00 
        }

        if (pdpt)
   4054b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   40550:	74 24                	je     40576 <copy_pagetable+0x211>
        {
            pageinfo[PAGENUMBER((uintptr_t)pdpt)].refcount = 0;
   40552:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   40556:	48 c1 e8 0c          	shr    $0xc,%rax
   4055a:	48 98                	cltq   
   4055c:	c6 84 00 a1 dd 04 00 	movb   $0x0,0x4dda1(%rax,%rax,1)
   40563:	00 
            pageinfo[PAGENUMBER((uintptr_t)pdpt)].owner = P_FREE;
   40564:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   40568:	48 c1 e8 0c          	shr    $0xc,%rax
   4056c:	48 98                	cltq   
   4056e:	c6 84 00 a0 dd 04 00 	movb   $0x0,0x4dda0(%rax,%rax,1)
   40575:	00 
        }

        if (pd)
   40576:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
   4057b:	74 24                	je     405a1 <copy_pagetable+0x23c>
        {
            pageinfo[PAGENUMBER((uintptr_t)pd)].refcount = 0;
   4057d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40581:	48 c1 e8 0c          	shr    $0xc,%rax
   40585:	48 98                	cltq   
   40587:	c6 84 00 a1 dd 04 00 	movb   $0x0,0x4dda1(%rax,%rax,1)
   4058e:	00 
            pageinfo[PAGENUMBER((uintptr_t)pd)].owner = P_FREE;
   4058f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40593:	48 c1 e8 0c          	shr    $0xc,%rax
   40597:	48 98                	cltq   
   40599:	c6 84 00 a0 dd 04 00 	movb   $0x0,0x4dda0(%rax,%rax,1)
   405a0:	00 
        }
        
        if (pt)
   405a1:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
   405a6:	74 24                	je     405cc <copy_pagetable+0x267>
        {
            pageinfo[PAGENUMBER((uintptr_t)pt)].refcount = 0;
   405a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   405ac:	48 c1 e8 0c          	shr    $0xc,%rax
   405b0:	48 98                	cltq   
   405b2:	c6 84 00 a1 dd 04 00 	movb   $0x0,0x4dda1(%rax,%rax,1)
   405b9:	00 
            pageinfo[PAGENUMBER((uintptr_t)pt)].owner = P_FREE;
   405ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   405be:	48 c1 e8 0c          	shr    $0xc,%rax
   405c2:	48 98                	cltq   
   405c4:	c6 84 00 a0 dd 04 00 	movb   $0x0,0x4dda0(%rax,%rax,1)
   405cb:	00 
        }
        
        if (pt2)
   405cc:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
   405d1:	74 24                	je     405f7 <copy_pagetable+0x292>
        {
            pageinfo[PAGENUMBER((uintptr_t)pt2)].refcount = 0;
   405d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   405d7:	48 c1 e8 0c          	shr    $0xc,%rax
   405db:	48 98                	cltq   
   405dd:	c6 84 00 a1 dd 04 00 	movb   $0x0,0x4dda1(%rax,%rax,1)
   405e4:	00 
            pageinfo[PAGENUMBER((uintptr_t)pt2)].owner = P_FREE;
   405e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   405e9:	48 c1 e8 0c          	shr    $0xc,%rax
   405ed:	48 98                	cltq   
   405ef:	c6 84 00 a0 dd 04 00 	movb   $0x0,0x4dda0(%rax,%rax,1)
   405f6:	00 
        }
        
        return NULL;
   405f7:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
   405fc:	c9                   	leaveq 
   405fd:	c3                   	retq   

00000000000405fe <sys_page_alloc_help>:

//  sys_page_alloc_help(uintptr_t addr, pid_t pid, x86_64_pagetable *pagetable)
//      helper functions that works the same way as INT_SYS_PAGE_ALLOC
int sys_page_alloc_help(uintptr_t addr, pid_t pid, x86_64_pagetable *pagetable)
{
   405fe:	55                   	push   %rbp
   405ff:	48 89 e5             	mov    %rsp,%rbp
   40602:	48 83 ec 30          	sub    $0x30,%rsp
   40606:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   4060a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
   4060d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    int pn = 0;
   40611:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

    // check if page is free
    for (pn = 1; pn < NPAGES; pn++)
   40618:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
   4061f:	eb 25                	jmp    40646 <sys_page_alloc_help+0x48>
    {
        if (pageinfo[pn].refcount == 0)
   40621:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40624:	48 98                	cltq   
   40626:	0f b6 84 00 a1 dd 04 	movzbl 0x4dda1(%rax,%rax,1),%eax
   4062d:	00 
   4062e:	84 c0                	test   %al,%al
   40630:	74 1f                	je     40651 <sys_page_alloc_help+0x53>
        {
            break;
        }
        else if (pn == NPAGES - 1)
   40632:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   40639:	75 07                	jne    40642 <sys_page_alloc_help+0x44>
        {
            return -1;
   4063b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   40640:	eb 74                	jmp    406b6 <sys_page_alloc_help+0xb8>
    for (pn = 1; pn < NPAGES; pn++)
   40642:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   40646:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   4064d:	7e d2                	jle    40621 <sys_page_alloc_help+0x23>
   4064f:	eb 01                	jmp    40652 <sys_page_alloc_help+0x54>
            break;
   40651:	90                   	nop
        }
    }

    int r = assign_physical_page(PAGEADDRESS(pn), pid);
   40652:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   40655:	0f be c0             	movsbl %al,%eax
   40658:	8b 55 fc             	mov    -0x4(%rbp),%edx
   4065b:	48 63 d2             	movslq %edx,%rdx
   4065e:	48 c1 e2 0c          	shl    $0xc,%rdx
   40662:	89 c6                	mov    %eax,%esi
   40664:	48 89 d7             	mov    %rdx,%rdi
   40667:	e8 f4 01 00 00       	callq  40860 <assign_physical_page>
   4066c:	89 45 f8             	mov    %eax,-0x8(%rbp)

    if (addr < PROC_START_ADDR)
   4066f:	48 81 7d e8 ff ff 0f 	cmpq   $0xfffff,-0x18(%rbp)
   40676:	00 
   40677:	77 07                	ja     40680 <sys_page_alloc_help+0x82>
    {
        r = -1;
   40679:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
    }

    if (r >= 0) {
   40680:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
   40684:	78 2d                	js     406b3 <sys_page_alloc_help+0xb5>
        virtual_memory_map(pagetable, addr, PAGEADDRESS(pn),
   40686:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40689:	48 98                	cltq   
   4068b:	48 c1 e0 0c          	shl    $0xc,%rax
   4068f:	48 89 c2             	mov    %rax,%rdx
   40692:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
   40696:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4069a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   406a0:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   406a6:	b9 00 10 00 00       	mov    $0x1000,%ecx
   406ab:	48 89 c7             	mov    %rax,%rdi
   406ae:	e8 56 1c 00 00       	callq  42309 <virtual_memory_map>
                        PAGESIZE, PTE_P | PTE_W | PTE_U, NULL);
    }

    return r;
   406b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
   406b6:	c9                   	leaveq 
   406b7:	c3                   	retq   

00000000000406b8 <process_setup>:
// process_setup(pid, program_number)
//    Load application program `program_number` as process number `pid`.
//    This loads the application's code and data into memory, sets its
//    %rip and %rsp, gives it a stack page, and marks it as runnable.

void process_setup(pid_t pid, int program_number) {
   406b8:	55                   	push   %rbp
   406b9:	48 89 e5             	mov    %rsp,%rbp
   406bc:	48 83 ec 30          	sub    $0x30,%rsp
   406c0:	89 7d dc             	mov    %edi,-0x24(%rbp)
   406c3:	89 75 d8             	mov    %esi,-0x28(%rbp)
    process_init(&processes[pid], 0);
   406c6:	8b 45 dc             	mov    -0x24(%rbp),%eax
   406c9:	48 63 d0             	movslq %eax,%rdx
   406cc:	48 89 d0             	mov    %rdx,%rax
   406cf:	48 01 c0             	add    %rax,%rax
   406d2:	48 01 d0             	add    %rdx,%rax
   406d5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   406dc:	00 
   406dd:	48 01 d0             	add    %rdx,%rax
   406e0:	48 c1 e0 03          	shl    $0x3,%rax
   406e4:	48 05 00 d0 04 00    	add    $0x4d000,%rax
   406ea:	be 00 00 00 00       	mov    $0x0,%esi
   406ef:	48 89 c7             	mov    %rax,%rdi
   406f2:	e8 f6 23 00 00       	callq  42aed <process_init>

    x86_64_pagetable *process_pagetable = copy_pagetable(kernel_pagetable, pid);
   406f7:	8b 45 dc             	mov    -0x24(%rbp),%eax
   406fa:	0f be d0             	movsbl %al,%edx
   406fd:	48 8b 05 14 59 01 00 	mov    0x15914(%rip),%rax        # 56018 <kernel_pagetable>
   40704:	89 d6                	mov    %edx,%esi
   40706:	48 89 c7             	mov    %rax,%rdi
   40709:	e8 57 fc ff ff       	callq  40365 <copy_pagetable>
   4070e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

    if (process_pagetable == NULL)
   40712:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
   40717:	0f 84 40 01 00 00    	je     4085d <process_setup+0x1a5>
    {
        return;
    }

    processes[pid].p_pagetable = process_pagetable;
   4071d:	8b 45 dc             	mov    -0x24(%rbp),%eax
   40720:	48 63 d0             	movslq %eax,%rdx
   40723:	48 89 d0             	mov    %rdx,%rax
   40726:	48 01 c0             	add    %rax,%rax
   40729:	48 01 d0             	add    %rdx,%rax
   4072c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40733:	00 
   40734:	48 01 d0             	add    %rdx,%rax
   40737:	48 c1 e0 03          	shl    $0x3,%rax
   4073b:	48 8d 90 d0 d0 04 00 	lea    0x4d0d0(%rax),%rdx
   40742:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40746:	48 89 02             	mov    %rax,(%rdx)

    int r = program_load(&processes[pid], program_number, NULL);
   40749:	8b 45 dc             	mov    -0x24(%rbp),%eax
   4074c:	48 63 d0             	movslq %eax,%rdx
   4074f:	48 89 d0             	mov    %rdx,%rax
   40752:	48 01 c0             	add    %rax,%rax
   40755:	48 01 d0             	add    %rdx,%rax
   40758:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   4075f:	00 
   40760:	48 01 d0             	add    %rdx,%rax
   40763:	48 c1 e0 03          	shl    $0x3,%rax
   40767:	48 8d 88 00 d0 04 00 	lea    0x4d000(%rax),%rcx
   4076e:	8b 45 d8             	mov    -0x28(%rbp),%eax
   40771:	ba 00 00 00 00       	mov    $0x0,%edx
   40776:	89 c6                	mov    %eax,%esi
   40778:	48 89 cf             	mov    %rcx,%rdi
   4077b:	e8 2d 2b 00 00       	callq  432ad <program_load>
   40780:	89 45 f4             	mov    %eax,-0xc(%rbp)
    assert(r >= 0);
   40783:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   40787:	79 14                	jns    4079d <process_setup+0xe5>
   40789:	ba 0e 40 04 00       	mov    $0x4400e,%edx
   4078e:	be 21 01 00 00       	mov    $0x121,%esi
   40793:	bf 15 40 04 00       	mov    $0x44015,%edi
   40798:	e8 e0 2a 00 00       	callq  4327d <assert_fail>

    //  each process’s stack to start from address 0x300000 == MEMSIZE_VIRTUAL
    processes[pid].p_registers.reg_rsp = MEMSIZE_VIRTUAL;
   4079d:	8b 45 dc             	mov    -0x24(%rbp),%eax
   407a0:	48 63 d0             	movslq %eax,%rdx
   407a3:	48 89 d0             	mov    %rdx,%rax
   407a6:	48 01 c0             	add    %rax,%rax
   407a9:	48 01 d0             	add    %rdx,%rax
   407ac:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   407b3:	00 
   407b4:	48 01 d0             	add    %rdx,%rax
   407b7:	48 c1 e0 03          	shl    $0x3,%rax
   407bb:	48 05 b8 d0 04 00    	add    $0x4d0b8,%rax
   407c1:	48 c7 00 00 00 30 00 	movq   $0x300000,(%rax)

    uintptr_t stack_page = processes[pid].p_registers.reg_rsp - PAGESIZE;
   407c8:	8b 45 dc             	mov    -0x24(%rbp),%eax
   407cb:	48 63 d0             	movslq %eax,%rdx
   407ce:	48 89 d0             	mov    %rdx,%rax
   407d1:	48 01 c0             	add    %rax,%rax
   407d4:	48 01 d0             	add    %rdx,%rax
   407d7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   407de:	00 
   407df:	48 01 d0             	add    %rdx,%rax
   407e2:	48 c1 e0 03          	shl    $0x3,%rax
   407e6:	48 05 b8 d0 04 00    	add    $0x4d0b8,%rax
   407ec:	48 8b 00             	mov    (%rax),%rax
   407ef:	48 2d 00 10 00 00    	sub    $0x1000,%rax
   407f5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

    sys_page_alloc_help(stack_page, pid, processes[pid].p_pagetable);
   407f9:	8b 45 dc             	mov    -0x24(%rbp),%eax
   407fc:	48 63 d0             	movslq %eax,%rdx
   407ff:	48 89 d0             	mov    %rdx,%rax
   40802:	48 01 c0             	add    %rax,%rax
   40805:	48 01 d0             	add    %rdx,%rax
   40808:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   4080f:	00 
   40810:	48 01 d0             	add    %rdx,%rax
   40813:	48 c1 e0 03          	shl    $0x3,%rax
   40817:	48 05 d0 d0 04 00    	add    $0x4d0d0,%rax
   4081d:	48 8b 10             	mov    (%rax),%rdx
   40820:	8b 4d dc             	mov    -0x24(%rbp),%ecx
   40823:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40827:	89 ce                	mov    %ecx,%esi
   40829:	48 89 c7             	mov    %rax,%rdi
   4082c:	e8 cd fd ff ff       	callq  405fe <sys_page_alloc_help>

    processes[pid].p_state = P_RUNNABLE;
   40831:	8b 45 dc             	mov    -0x24(%rbp),%eax
   40834:	48 63 d0             	movslq %eax,%rdx
   40837:	48 89 d0             	mov    %rdx,%rax
   4083a:	48 01 c0             	add    %rax,%rax
   4083d:	48 01 d0             	add    %rdx,%rax
   40840:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40847:	00 
   40848:	48 01 d0             	add    %rdx,%rax
   4084b:	48 c1 e0 03          	shl    $0x3,%rax
   4084f:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   40855:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
   4085b:	eb 01                	jmp    4085e <process_setup+0x1a6>
        return;
   4085d:	90                   	nop
}
   4085e:	c9                   	leaveq 
   4085f:	c3                   	retq   

0000000000040860 <assign_physical_page>:
// assign_physical_page(addr, owner)
//    Allocates the page with physical address `addr` to the given owner.
//    Fails if physical page `addr` was already allocated. Returns 0 on
//    success and -1 on failure. Used by the program loader.

int assign_physical_page(uintptr_t addr, int8_t owner) {
   40860:	55                   	push   %rbp
   40861:	48 89 e5             	mov    %rsp,%rbp
   40864:	48 83 ec 10          	sub    $0x10,%rsp
   40868:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   4086c:	89 f0                	mov    %esi,%eax
   4086e:	88 45 f4             	mov    %al,-0xc(%rbp)
    if ((addr & 0xFFF) != 0 || pageinfo[PAGENUMBER(addr)].refcount != 0 || addr >= MEMSIZE_PHYSICAL) {
   40871:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40875:	25 ff 0f 00 00       	and    $0xfff,%eax
   4087a:	48 85 c0             	test   %rax,%rax
   4087d:	75 20                	jne    4089f <assign_physical_page+0x3f>
   4087f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40883:	48 c1 e8 0c          	shr    $0xc,%rax
   40887:	48 98                	cltq   
   40889:	0f b6 84 00 a1 dd 04 	movzbl 0x4dda1(%rax,%rax,1),%eax
   40890:	00 
   40891:	84 c0                	test   %al,%al
   40893:	75 0a                	jne    4089f <assign_physical_page+0x3f>
   40895:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   4089c:	00 
   4089d:	76 07                	jbe    408a6 <assign_physical_page+0x46>
        return -1;
   4089f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   408a4:	eb 2c                	jmp    408d2 <assign_physical_page+0x72>
    } else {
        pageinfo[PAGENUMBER(addr)].refcount = 1;
   408a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   408aa:	48 c1 e8 0c          	shr    $0xc,%rax
   408ae:	48 98                	cltq   
   408b0:	c6 84 00 a1 dd 04 00 	movb   $0x1,0x4dda1(%rax,%rax,1)
   408b7:	01 
        pageinfo[PAGENUMBER(addr)].owner = owner;
   408b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   408bc:	48 c1 e8 0c          	shr    $0xc,%rax
   408c0:	48 98                	cltq   
   408c2:	0f b6 55 f4          	movzbl -0xc(%rbp),%edx
   408c6:	88 94 00 a0 dd 04 00 	mov    %dl,0x4dda0(%rax,%rax,1)
        return 0;
   408cd:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
   408d2:	c9                   	leaveq 
   408d3:	c3                   	retq   

00000000000408d4 <process_clean>:

//  void process_clean(proc my_proc)
//    If there isn’t enough free memory to allocate a process, 
//    fork() should clean up after itself 
void process_clean(proc my_proc)
{
   408d4:	55                   	push   %rbp
   408d5:	48 89 e5             	mov    %rsp,%rbp
   408d8:	48 83 ec 20          	sub    $0x20,%rsp
    for (uintptr_t va = PROC_START_ADDR; va < MEMSIZE_VIRTUAL; va += PAGESIZE)
   408dc:	48 c7 45 f8 00 00 10 	movq   $0x100000,-0x8(%rbp)
   408e3:	00 
   408e4:	e9 99 00 00 00       	jmpq   40982 <process_clean+0xae>
    {       
        if (my_proc.p_pagetable) 
   408e9:	48 8b 85 e0 00 00 00 	mov    0xe0(%rbp),%rax
   408f0:	48 85 c0             	test   %rax,%rax
   408f3:	0f 84 81 00 00 00    	je     4097a <process_clean+0xa6>
        {
            vamapping my_map = virtual_memory_lookup(my_proc.p_pagetable, va);
   408f9:	48 8b 8d e0 00 00 00 	mov    0xe0(%rbp),%rcx
   40900:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
   40904:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   40908:	48 89 ce             	mov    %rcx,%rsi
   4090b:	48 89 c7             	mov    %rax,%rdi
   4090e:	e8 ed 1d 00 00       	callq  42700 <virtual_memory_lookup>

            // find all the process's virtual pages except pagetables
            if ((my_map.pn >= 0) && (pageinfo[my_map.pn].owner == my_proc.p_pid) && (pageinfo[my_map.pn].refcount))
   40913:	8b 45 e0             	mov    -0x20(%rbp),%eax
   40916:	85 c0                	test   %eax,%eax
   40918:	78 60                	js     4097a <process_clean+0xa6>
   4091a:	8b 45 e0             	mov    -0x20(%rbp),%eax
   4091d:	48 98                	cltq   
   4091f:	0f b6 84 00 a0 dd 04 	movzbl 0x4dda0(%rax,%rax,1),%eax
   40926:	00 
   40927:	0f be d0             	movsbl %al,%edx
   4092a:	8b 45 10             	mov    0x10(%rbp),%eax
   4092d:	39 c2                	cmp    %eax,%edx
   4092f:	75 49                	jne    4097a <process_clean+0xa6>
   40931:	8b 45 e0             	mov    -0x20(%rbp),%eax
   40934:	48 98                	cltq   
   40936:	0f b6 84 00 a1 dd 04 	movzbl 0x4dda1(%rax,%rax,1),%eax
   4093d:	00 
   4093e:	84 c0                	test   %al,%al
   40940:	74 38                	je     4097a <process_clean+0xa6>
            {
                // check if shared pages
                if (!(--pageinfo[my_map.pn].refcount))
   40942:	8b 45 e0             	mov    -0x20(%rbp),%eax
   40945:	48 63 d0             	movslq %eax,%rdx
   40948:	0f b6 94 12 a1 dd 04 	movzbl 0x4dda1(%rdx,%rdx,1),%edx
   4094f:	00 
   40950:	83 ea 01             	sub    $0x1,%edx
   40953:	89 d1                	mov    %edx,%ecx
   40955:	48 63 d0             	movslq %eax,%rdx
   40958:	88 8c 12 a1 dd 04 00 	mov    %cl,0x4dda1(%rdx,%rdx,1)
   4095f:	48 98                	cltq   
   40961:	0f b6 84 00 a1 dd 04 	movzbl 0x4dda1(%rax,%rax,1),%eax
   40968:	00 
   40969:	84 c0                	test   %al,%al
   4096b:	75 0d                	jne    4097a <process_clean+0xa6>
                {
                    pageinfo[my_map.pn].owner = P_FREE;
   4096d:	8b 45 e0             	mov    -0x20(%rbp),%eax
   40970:	48 98                	cltq   
   40972:	c6 84 00 a0 dd 04 00 	movb   $0x0,0x4dda0(%rax,%rax,1)
   40979:	00 
    for (uintptr_t va = PROC_START_ADDR; va < MEMSIZE_VIRTUAL; va += PAGESIZE)
   4097a:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   40981:	00 
   40982:	48 81 7d f8 ff ff 2f 	cmpq   $0x2fffff,-0x8(%rbp)
   40989:	00 
   4098a:	0f 86 59 ff ff ff    	jbe    408e9 <process_clean+0x15>
                }
            }
        } 
    }

    my_proc.p_state = P_FREE;
   40990:	c7 85 d8 00 00 00 00 	movl   $0x0,0xd8(%rbp)
   40997:	00 00 00 
}
   4099a:	90                   	nop
   4099b:	c9                   	leaveq 
   4099c:	c3                   	retq   

000000000004099d <process_fork>:
//  process_fork(void)
//    Starts a new process as a copy of an existing process.
//    To the child process, it returns 0. 
//    To the parent process, it returns the child’s process ID.
void process_fork(void)
{
   4099d:	55                   	push   %rbp
   4099e:	48 89 e5             	mov    %rsp,%rbp
   409a1:	48 83 ec 30          	sub    $0x30,%rsp
    int child_pid;

    //  look for a free process slot in the processes[] array
    //  Don’t use slot 0. 
    for (child_pid = 1; child_pid < NPROC; child_pid++) 
   409a5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
   409ac:	e9 0b 03 00 00       	jmpq   40cbc <process_fork+0x31f>
    {
        if (processes[child_pid].p_state == P_FREE)
   409b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
   409b4:	48 63 d0             	movslq %eax,%rdx
   409b7:	48 89 d0             	mov    %rdx,%rax
   409ba:	48 01 c0             	add    %rax,%rax
   409bd:	48 01 d0             	add    %rdx,%rax
   409c0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   409c7:	00 
   409c8:	48 01 d0             	add    %rdx,%rax
   409cb:	48 c1 e0 03          	shl    $0x3,%rax
   409cf:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   409d5:	8b 00                	mov    (%rax),%eax
   409d7:	85 c0                	test   %eax,%eax
   409d9:	0f 85 c4 02 00 00    	jne    40ca3 <process_fork+0x306>
        {
            // set process to RUNNABLE
            processes[child_pid].p_state = P_RUNNABLE;
   409df:	8b 45 fc             	mov    -0x4(%rbp),%eax
   409e2:	48 63 d0             	movslq %eax,%rdx
   409e5:	48 89 d0             	mov    %rdx,%rax
   409e8:	48 01 c0             	add    %rax,%rax
   409eb:	48 01 d0             	add    %rdx,%rax
   409ee:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   409f5:	00 
   409f6:	48 01 d0             	add    %rdx,%rax
   409f9:	48 c1 e0 03          	shl    $0x3,%rax
   409fd:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   40a03:	c7 00 01 00 00 00    	movl   $0x1,(%rax)

            processes[child_pid].p_pid = child_pid;
   40a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40a0c:	48 63 d0             	movslq %eax,%rdx
   40a0f:	48 89 d0             	mov    %rdx,%rax
   40a12:	48 01 c0             	add    %rax,%rax
   40a15:	48 01 d0             	add    %rdx,%rax
   40a18:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40a1f:	00 
   40a20:	48 01 d0             	add    %rdx,%rax
   40a23:	48 c1 e0 03          	shl    $0x3,%rax
   40a27:	48 8d 90 00 d0 04 00 	lea    0x4d000(%rax),%rdx
   40a2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40a31:	89 02                	mov    %eax,(%rdx)

            // make a copy of current->p_pagetable, the forking process’s page table
            processes[child_pid].p_pagetable = copy_pagetable(current->p_pagetable, child_pid);
   40a33:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40a36:	0f be d0             	movsbl %al,%edx
   40a39:	48 8b 05 d0 55 01 00 	mov    0x155d0(%rip),%rax        # 56010 <current>
   40a40:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   40a47:	89 d6                	mov    %edx,%esi
   40a49:	48 89 c7             	mov    %rax,%rdi
   40a4c:	e8 14 f9 ff ff       	callq  40365 <copy_pagetable>
   40a51:	48 89 c1             	mov    %rax,%rcx
   40a54:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40a57:	48 63 d0             	movslq %eax,%rdx
   40a5a:	48 89 d0             	mov    %rdx,%rax
   40a5d:	48 01 c0             	add    %rax,%rax
   40a60:	48 01 d0             	add    %rdx,%rax
   40a63:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40a6a:	00 
   40a6b:	48 01 d0             	add    %rdx,%rax
   40a6e:	48 c1 e0 03          	shl    $0x3,%rax
   40a72:	48 05 d0 d0 04 00    	add    $0x4d0d0,%rax
   40a78:	48 89 08             	mov    %rcx,(%rax)

            if (processes[child_pid].p_pagetable)
   40a7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40a7e:	48 63 d0             	movslq %eax,%rdx
   40a81:	48 89 d0             	mov    %rdx,%rax
   40a84:	48 01 c0             	add    %rax,%rax
   40a87:	48 01 d0             	add    %rdx,%rax
   40a8a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40a91:	00 
   40a92:	48 01 d0             	add    %rdx,%rax
   40a95:	48 c1 e0 03          	shl    $0x3,%rax
   40a99:	48 05 d0 d0 04 00    	add    $0x4d0d0,%rax
   40a9f:	48 8b 00             	mov    (%rax),%rax
   40aa2:	48 85 c0             	test   %rax,%rax
   40aa5:	0f 84 bd 01 00 00    	je     40c68 <process_fork+0x2cb>
            {
                //  examine every virtual address in the old page table
                vamapping my_map;

                for (uintptr_t va = PROC_START_ADDR; va < MEMSIZE_VIRTUAL; va += PAGESIZE)
   40aab:	48 c7 45 f0 00 00 10 	movq   $0x100000,-0x10(%rbp)
   40ab2:	00 
   40ab3:	e9 23 01 00 00       	jmpq   40bdb <process_fork+0x23e>
                {
                    my_map = virtual_memory_lookup(current->p_pagetable, va);
   40ab8:	48 8b 05 51 55 01 00 	mov    0x15551(%rip),%rax        # 56010 <current>
   40abf:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   40ac6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   40aca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   40ace:	48 89 ce             	mov    %rcx,%rsi
   40ad1:	48 89 c7             	mov    %rax,%rdi
   40ad4:	e8 27 1c 00 00       	callq  42700 <virtual_memory_lookup>

                    //  Whenever the parent process has an application-writable page at virtual address V, 
                    if ((my_map.perm & PTE_W) && my_map.pa != CONSOLE_ADDR)
   40ad9:	8b 45 e0             	mov    -0x20(%rbp),%eax
   40adc:	48 98                	cltq   
   40ade:	83 e0 02             	and    $0x2,%eax
   40ae1:	48 85 c0             	test   %rax,%rax
   40ae4:	0f 84 84 00 00 00    	je     40b6e <process_fork+0x1d1>
   40aea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40aee:	ba 00 80 0b 00       	mov    $0xb8000,%edx
   40af3:	48 39 d0             	cmp    %rdx,%rax
   40af6:	74 76                	je     40b6e <process_fork+0x1d1>
                    {
                        //  then fork must allocate a new physical page P;
                        void *P = my_alloc_page(child_pid);
   40af8:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40afb:	89 c7                	mov    %eax,%edi
   40afd:	e8 e2 f7 ff ff       	callq  402e4 <my_alloc_page>
   40b02:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

                        //  copy the data from the parent’s page into P, using memcpy; 
                        memcpy(P, (void *)my_map.pa, PAGESIZE);
   40b06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40b0a:	48 89 c1             	mov    %rax,%rcx
   40b0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40b11:	ba 00 10 00 00       	mov    $0x1000,%edx
   40b16:	48 89 ce             	mov    %rcx,%rsi
   40b19:	48 89 c7             	mov    %rax,%rdi
   40b1c:	e8 48 2b 00 00       	callq  43669 <memcpy>

                        //     return;
                        // }

                        //  and finally map page P at address V in the child process’s page table.
                        virtual_memory_map(processes[child_pid].p_pagetable, va, (uintptr_t)P, PAGESIZE, my_map.perm, NULL); 
   40b21:	8b 4d e0             	mov    -0x20(%rbp),%ecx
   40b24:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
   40b28:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40b2b:	48 63 d0             	movslq %eax,%rdx
   40b2e:	48 89 d0             	mov    %rdx,%rax
   40b31:	48 01 c0             	add    %rax,%rax
   40b34:	48 01 d0             	add    %rdx,%rax
   40b37:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40b3e:	00 
   40b3f:	48 01 d0             	add    %rdx,%rax
   40b42:	48 c1 e0 03          	shl    $0x3,%rax
   40b46:	48 05 d0 d0 04 00    	add    $0x4d0d0,%rax
   40b4c:	48 8b 00             	mov    (%rax),%rax
   40b4f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
   40b53:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   40b59:	41 89 c8             	mov    %ecx,%r8d
   40b5c:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40b61:	48 89 fa             	mov    %rdi,%rdx
   40b64:	48 89 c7             	mov    %rax,%rdi
   40b67:	e8 9d 17 00 00       	callq  42309 <virtual_memory_map>
                    {
   40b6c:	eb 65                	jmp    40bd3 <process_fork+0x236>
                        //++pageinfo[PAGENUMBER((uintptr_t)P)].refcount;                   
                    }
                    // share read-only pages
                    else
                    {
                        virtual_memory_map(processes[child_pid].p_pagetable, va, my_map.pa, PAGESIZE, my_map.perm, NULL);
   40b6e:	8b 4d e0             	mov    -0x20(%rbp),%ecx
   40b71:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
   40b75:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40b78:	48 63 d0             	movslq %eax,%rdx
   40b7b:	48 89 d0             	mov    %rdx,%rax
   40b7e:	48 01 c0             	add    %rax,%rax
   40b81:	48 01 d0             	add    %rdx,%rax
   40b84:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40b8b:	00 
   40b8c:	48 01 d0             	add    %rdx,%rax
   40b8f:	48 c1 e0 03          	shl    $0x3,%rax
   40b93:	48 05 d0 d0 04 00    	add    $0x4d0d0,%rax
   40b99:	48 8b 00             	mov    (%rax),%rax
   40b9c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
   40ba0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   40ba6:	41 89 c8             	mov    %ecx,%r8d
   40ba9:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40bae:	48 89 fa             	mov    %rdi,%rdx
   40bb1:	48 89 c7             	mov    %rax,%rdi
   40bb4:	e8 50 17 00 00       	callq  42309 <virtual_memory_map>
                        
                        ++pageinfo[my_map.pn].refcount;
   40bb9:	8b 45 d0             	mov    -0x30(%rbp),%eax
   40bbc:	48 63 d0             	movslq %eax,%rdx
   40bbf:	0f b6 94 12 a1 dd 04 	movzbl 0x4dda1(%rdx,%rdx,1),%edx
   40bc6:	00 
   40bc7:	83 c2 01             	add    $0x1,%edx
   40bca:	48 98                	cltq   
   40bcc:	88 94 00 a1 dd 04 00 	mov    %dl,0x4dda1(%rax,%rax,1)
                for (uintptr_t va = PROC_START_ADDR; va < MEMSIZE_VIRTUAL; va += PAGESIZE)
   40bd3:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
   40bda:	00 
   40bdb:	48 81 7d f0 ff ff 2f 	cmpq   $0x2fffff,-0x10(%rbp)
   40be2:	00 
   40be3:	0f 86 cf fe ff ff    	jbe    40ab8 <process_fork+0x11b>
                    }
                }

                // The child process’s registers are initialized as a copy of the parent process’s registers, except for reg_rax.
                processes[child_pid].p_registers = current->p_registers;
   40be9:	48 8b 0d 20 54 01 00 	mov    0x15420(%rip),%rcx        # 56010 <current>
   40bf0:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40bf3:	48 63 d0             	movslq %eax,%rdx
   40bf6:	48 89 d0             	mov    %rdx,%rax
   40bf9:	48 01 c0             	add    %rax,%rax
   40bfc:	48 01 d0             	add    %rdx,%rax
   40bff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40c06:	00 
   40c07:	48 01 d0             	add    %rdx,%rax
   40c0a:	48 c1 e0 03          	shl    $0x3,%rax
   40c0e:	48 05 00 d0 04 00    	add    $0x4d000,%rax
   40c14:	48 83 c0 08          	add    $0x8,%rax
   40c18:	48 8d 51 08          	lea    0x8(%rcx),%rdx
   40c1c:	b9 18 00 00 00       	mov    $0x18,%ecx
   40c21:	48 89 c7             	mov    %rax,%rdi
   40c24:	48 89 d6             	mov    %rdx,%rsi
   40c27:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)

                // To the child process, it returns 0.
                processes[child_pid].p_registers.reg_rax = 0;
   40c2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40c2d:	48 63 d0             	movslq %eax,%rdx
   40c30:	48 89 d0             	mov    %rdx,%rax
   40c33:	48 01 c0             	add    %rax,%rax
   40c36:	48 01 d0             	add    %rdx,%rax
   40c39:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40c40:	00 
   40c41:	48 01 d0             	add    %rdx,%rax
   40c44:	48 c1 e0 03          	shl    $0x3,%rax
   40c48:	48 05 08 d0 04 00    	add    $0x4d008,%rax
   40c4e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

                // To the parent process, it returns the child’s process ID.
                current->p_registers.reg_rax = child_pid;
   40c55:	48 8b 05 b4 53 01 00 	mov    0x153b4(%rip),%rax        # 56010 <current>
   40c5c:	8b 55 fc             	mov    -0x4(%rbp),%edx
   40c5f:	48 63 d2             	movslq %edx,%rdx
   40c62:	48 89 50 08          	mov    %rdx,0x8(%rax)

                break;
   40c66:	eb 5e                	jmp    40cc6 <process_fork+0x329>
            }
            // not enough memory to allocte page table
            else
            {                
                processes[child_pid].p_state = P_FREE;
   40c68:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40c6b:	48 63 d0             	movslq %eax,%rdx
   40c6e:	48 89 d0             	mov    %rdx,%rax
   40c71:	48 01 c0             	add    %rax,%rax
   40c74:	48 01 d0             	add    %rdx,%rax
   40c77:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   40c7e:	00 
   40c7f:	48 01 d0             	add    %rdx,%rax
   40c82:	48 c1 e0 03          	shl    $0x3,%rax
   40c86:	48 05 c8 d0 04 00    	add    $0x4d0c8,%rax
   40c8c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)

                // return -1 to the caller
                current->p_registers.reg_rax = -1;
   40c92:	48 8b 05 77 53 01 00 	mov    0x15377(%rip),%rax        # 56010 <current>
   40c99:	48 c7 40 08 ff ff ff 	movq   $0xffffffffffffffff,0x8(%rax)
   40ca0:	ff 

                return;
   40ca1:	eb 23                	jmp    40cc6 <process_fork+0x329>
            }
        }
        //  If no slot exists, return -1 to the caller.
        else if (child_pid == NPROC - 1)
   40ca3:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   40ca7:	75 0f                	jne    40cb8 <process_fork+0x31b>
        {
            current->p_registers.reg_rax = -1;
   40ca9:	48 8b 05 60 53 01 00 	mov    0x15360(%rip),%rax        # 56010 <current>
   40cb0:	48 c7 40 08 ff ff ff 	movq   $0xffffffffffffffff,0x8(%rax)
   40cb7:	ff 
    for (child_pid = 1; child_pid < NPROC; child_pid++) 
   40cb8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   40cbc:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   40cc0:	0f 8e eb fc ff ff    	jle    409b1 <process_fork+0x14>
        }
    }
}       
   40cc6:	c9                   	leaveq 
   40cc7:	c3                   	retq   

0000000000040cc8 <exception>:
//    k-exception.S). That code saves more registers on the kernel's stack,
//    then calls exception().
//
//    Note that hardware interrupts are disabled whenever the kernel is running.

void exception(x86_64_registers* reg) {
   40cc8:	55                   	push   %rbp
   40cc9:	48 89 e5             	mov    %rsp,%rbp
   40ccc:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
   40cd0:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
    // Copy the saved registers into the `current` process descriptor
    // and always use the kernel's page table.
    current->p_registers = *reg;
   40cd4:	48 8b 05 35 53 01 00 	mov    0x15335(%rip),%rax        # 56010 <current>
   40cdb:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
   40cdf:	48 83 c0 08 