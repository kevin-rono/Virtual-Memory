#include "kernel.h"
#include "lib.h"

// kernel.c
//
//    This is the kernel.


// INITIAL PHYSICAL MEMORY LAYOUT
//
//  +-------------- Base Memory --------------+
//  v                                         v
// +-----+--------------------+----------------+--------------------+---------/
// |     | Kernel      Kernel |       :    I/O | App 1        App 1 | App 2
// |     | Code + Data  Stack |  ...  : Memory | Code + Data  Stack | Code ...
// +-----+--------------------+----------------+--------------------+---------/
// 0  0x40000              0x80000 0xA0000 0x100000             0x140000
//                                             ^
//                                             | \___ PROC_SIZE ___/
//                                      PROC_START_ADDR

#define PROC_SIZE 0x40000       // initial state only

static proc processes[NPROC];   // array of process descriptors
                                // Note that `processes[0]` is never used.
proc* current;                  // pointer to currently executing proc

#define HZ 100                  // timer interrupt frequency (interrupts/sec)
static unsigned ticks;          // # timer interrupts so far

void schedule(void);
void run(proc* p) __attribute__((noreturn));


// PAGEINFO
//
//    The pageinfo[] array keeps track of information about each physical page.
//    There is one entry per physical page.
//    `pageinfo[pn]` holds the information for physical page number `pn`.
//    You can get a physical page number from a physical address `pa` using
//    `PAGENUMBER(pa)`. (This also works for page table entries.)
//    To change a physical page number `pn` into a physical address, use
//    `PAGEADDRESS(pn)`.
//
//    pageinfo[pn].refcount is the number of times physical page `pn` is
//      currently referenced. 0 means it's free.
//    pageinfo[pn].owner is a constant indicating who owns the page.
//      PO_KERNEL means the kernel, PO_RESERVED means reserved memory (such
//      as the console), and a number >=0 means that process ID.
//
//    pageinfo_init() sets up the initial pageinfo[] state.

typedef struct physical_pageinfo {
    int8_t owner;
    int8_t refcount;
} physical_pageinfo;

static physical_pageinfo pageinfo[PAGENUMBER(MEMSIZE_PHYSICAL)];

typedef enum pageowner {
    PO_FREE = 0,                // this page is free
    PO_RESERVED = -1,           // this page is reserved memory
    PO_KERNEL = -2              // this page is used by the kernel
} pageowner_t;

static void pageinfo_init(void);


// Memory functions

void check_virtual_memory(void);
void memshow_physical(void);
void memshow_virtual(x86_64_pagetable* pagetable, const char* name);
void memshow_virtual_animate(void);


// kernel(command)
//    Initialize the hardware and processes and start running. The `command`
//    string is an optional string passed from the boot loader.

static void process_setup(pid_t pid, int program_number);

void kernel(const char* command) {
    hardware_init();
    pageinfo_init();
    console_clear();
    timer_init(HZ);

    virtual_memory_map(kernel_pagetable, (uintptr_t) 0, (uintptr_t) 0,
                       PROC_START_ADDR, PTE_P | PTE_W, NULL);

    virtual_memory_map(kernel_pagetable, CONSOLE_ADDR, CONSOLE_ADDR,
                       PAGESIZE, PTE_P | PTE_W | PTE_U, NULL);

    // Set up process descriptors
    memset(processes, 0, sizeof(processes));

    for (pid_t i = 0; i < NPROC; i++) {
        processes[i].p_pid = i;
        processes[i].p_state = P_FREE;
    }

    if (command && strcmp(command, "fork") == 0) 
    {
        process_setup(1, 4);
    } 
    else if (command && strcmp(command, "forkexit") == 0) 
    {
        process_setup(1, 5);
    } 
    else 
    {
        for (pid_t i = 1; i <= 4; ++i) 
        {
            process_setup(i, i - 1);
        }
    }

    // Switch to the first process using run()
    run(&processes[1]);
}

// my_alloc_page(pid_t pid) 
//      function to allocate a page and assign it to a process (pid)
//      reset it to empty (memset to zero)
//      returns the address of the reserved page
void *my_alloc_page(pid_t pid)  
{
    int pn = 0;

    // check if page is free
    for (pn = 1; pn < NPAGES; pn++)
    {
        if (pageinfo[pn].refcount == 0)
        {
            break;
        }
        else if (pn == NPAGES - 1)
        {
            return NULL;
        }
    }

    // assign it to the pid
    int r = assign_physical_page(PAGEADDRESS(pn), pid);

    // memset page to 0 
    // return the addr of the assigned page
    if (r >= 0)
    {
        return (void *) PAGEADDRESS(pn);
    }
    else
    {
        return NULL;
    }
}

// copy_pagetable(x86_64_pagetable *pagetable, int8_t owner) 
//      function to allocate and return a new page table
//      the page table is a copy of 'pagetable'
x86_64_pagetable *copy_pagetable(x86_64_pagetable *pagetable, int8_t owner) 
{
    void *pml4, *pdpt, *pd, *pt, *pt2 = NULL;

    pml4 = my_alloc_page(owner);
    memset(pml4, 0, PAGESIZE);

    pdpt = my_alloc_page(owner);
    memset(pdpt, 0, PAGESIZE);

    pd = my_alloc_page(owner);
    memset(pd, 0, PAGESIZE);

    pt = my_alloc_page(owner);
    memset(pt, 0, PAGESIZE);

    pt2 = my_alloc_page(owner);
    memset(pt2, 0, PAGESIZE);
    
    if (pml4 && pdpt && pd && pt && pt2)
    {        
        ((x86_64_pagetable *) pml4)->entry[0] = (x86_64_pageentry_t) (uintptr_t) pdpt | PTE_P | PTE_W | PTE_U;
        ((x86_64_pagetable *) pdpt)->entry[0] = (x86_64_pageentry_t) (uintptr_t) pd | PTE_P | PTE_W | PTE_U;
        ((x86_64_pagetable *) pd)->entry[0] = (x86_64_pageentry_t) (uintptr_t) pt | PTE_P | PTE_W | PTE_U;
        ((x86_64_pagetable *) pd)->entry[1] = (x86_64_pageentry_t) (uintptr_t) pt2 | PTE_P | PTE_W | PTE_U;

        x86_64_pagetable *process_pagetable = (x86_64_pagetable *) pml4;

        vamapping my_map;

        for (uintptr_t va = 0; va < PROC_START_ADDR; va += PAGESIZE)
        {
            my_map = virtual_memory_lookup(pagetable, va);

            virtual_memory_map(process_pagetable, va, my_map.pa, PAGESIZE, my_map.perm, NULL);
        }

        return process_pagetable;
    }
    else
    {
        if (pml4)
        {
            pageinfo[PAGENUMBER((uintptr_t)pml4)].refcount = 0;
            pageinfo[PAGENUMBER((uintptr_t)pml4)].owner = P_FREE;
        }

        if (pdpt)
        {
            pageinfo[PAGENUMBER((uintptr_t)pdpt)].refcount = 0;
            pageinfo[PAGENUMBER((uintptr_t)pdpt)].owner = P_FREE;
        }

        if (pd)
        {
            pageinfo[PAGENUMBER((uintptr_t)pd)].refcount = 0;
            pageinfo[PAGENUMBER((uintptr_t)pd)].owner = P_FREE;
        }
        
        if (pt)
        {
            pageinfo[PAGENUMBER((uintptr_t)pt)].refcount = 0;
            pageinfo[PAGENUMBER((uintptr_t)pt)].owner = P_FREE;
        }
        
        if (pt2)
        {
            pageinfo[PAGENUMBER((uintptr_t)pt2)].refcount = 0;
            pageinfo[PAGENUMBER((uintptr_t)pt2)].owner = P_FREE;
        }
        
        return NULL;
    }
}

//  sys_page_alloc_help(uintptr_t addr, pid_t pid, x86_64_pagetable *pagetable)
//      helper functions that works the same way as INT_SYS_PAGE_ALLOC
int sys_page_alloc_help(uintptr_t addr, pid_t pid, x86_64_pagetable *pagetable)
{
    int pn = 0;

    // check if page is free
    for (pn = 1; pn < NPAGES; pn++)
    {
        if (pageinfo[pn].refcount == 0)
        {
            break;
        }
        else if (pn == NPAGES - 1)
        {
            return -1;
        }
    }

    int r = assign_physical_page(PAGEADDRESS(pn), pid);

    if (addr < PROC_START_ADDR)
    {
        r = -1;
    }

    if (r >= 0) {
        virtual_memory_map(pagetable, addr, PAGEADDRESS(pn),
                        PAGESIZE, PTE_P | PTE_W | PTE_U, NULL);
    }

    return r;
}

// process_setup(pid, program_number)
//    Load application program `program_number` as process number `pid`.
//    This loads the application's code and data into memory, sets its
//    %rip and %rsp, gives it a stack page, and marks it as runnable.

void process_setup(pid_t pid, int program_number) {
    process_init(&processes[pid], 0);

    x86_64_pagetable *process_pagetable = copy_pagetable(kernel_pagetable, pid);

    if (process_pagetable == NULL)
    {
        return;
    }

    processes[pid].p_pagetable = process_pagetable;

    int r = program_load(&processes[pid], program_number, NULL);
    assert(r >= 0);

    //  each process’s stack to start from address 0x300000 == MEMSIZE_VIRTUAL
    processes[pid].p_registers.reg_rsp = MEMSIZE_VIRTUAL;

    uintptr_t stack_page = processes[pid].p_registers.reg_rsp - PAGESIZE;

    sys_page_alloc_help(stack_page, pid, processes[pid].p_pagetable);

    processes[pid].p_state = P_RUNNABLE;
}


// assign_physical_page(addr, owner)
//    Allocates the page with physical address `addr` to the given owner.
//    Fails if physical page `addr` was already allocated. Returns 0 on
//    success and -1 on failure. Used by the program loader.

int assign_physical_page(uintptr_t addr, int8_t owner) {
    if ((addr & 0xFFF) != 0 || pageinfo[PAGENUMBER(addr)].refcount != 0 || addr >= MEMSIZE_PHYSICAL) {
        return -1;
    } else {
        pageinfo[PAGENUMBER(addr)].refcount = 1;
        pageinfo[PAGENUMBER(addr)].owner = owner;
        return 0;
    }
}

//  void process_clean(proc my_proc)
//    If there isn’t enough free memory to allocate a process, 
//    fork() should clean up after itself 
void process_clean(proc my_proc)
{
    for (uintptr_t va = PROC_START_ADDR; va < MEMSIZE_VIRTUAL; va += PAGESIZE)
    {       
        if (my_proc.p_pagetable) 
        {
            vamapping my_map = virtual_memory_lookup(my_proc.p_pagetable, va);

            // find all the process's virtual pages except pagetables
            if ((my_map.pn >= 0) && (pageinfo[my_map.pn].owner == my_proc.p_pid) && (pageinfo[my_map.pn].refcount))
            {
                // check if shared pages
                if (!(--pageinfo[my_map.pn].refcount))
                {
                    pageinfo[my_map.pn].owner = P_FREE;
                }
            }
        } 
    }

    my_proc.p_state = P_FREE;
}

//  process_fork(void)
//    Starts a new process as a copy of an existing process.
//    To the child process, it returns 0. 
//    To the parent process, it returns the child’s process ID.
void process_fork(void)
{
    int child_pid;

    //  look for a free process slot in the processes[] array
    //  Don’t use slot 0. 
    for (child_pid = 1; child_pid < NPROC; child_pid++) 
    {
        if (processes[child_pid].p_state == P_FREE)
        {
            // set process to RUNNABLE
            processes[child_pid].p_state = P_RUNNABLE;

            processes[child_pid].p_pid = child_pid;

            // make a copy of current->p_pagetable, the forking process’s page table
            processes[child_pid].p_pagetable = copy_pagetable(current->p_pagetable, child_pid);

            if (processes[child_pid].p_pagetable)
            {
                //  examine every virtual address in the old page table
                vamapping my_map;

                for (uintptr_t va = PROC_START_ADDR; va < MEMSIZE_VIRTUAL; va += PAGESIZE)
                {
                    my_map = virtual_memory_lookup(current->p_pagetable, va);

                    //  Whenever the parent process has an application-writable page at virtual address V, 
                    if ((my_map.perm & PTE_W) && my_map.pa != CONSOLE_ADDR)
                    {
                        //  then fork must allocate a new physical page P;
                        void *P = my_alloc_page(child_pid);

                        //  copy the data from the parent’s page into P, using memcpy; 
                        memcpy(P, (void *)my_map.pa, PAGESIZE);

                        // if (memcpy(P, (void *)my_map.pa, PAGESIZE) == NULL)
                        // {
                        //     process_clean(processes[child_pid]);

                        //     current->p_registers.reg_rax = -1;

                        //     return;
                        // }

                        //  and finally map page P at address V in the child process’s page table.
                        virtual_memory_map(processes[child_pid].p_pagetable, va, (uintptr_t)P, PAGESIZE, my_map.perm, NULL); 
                        //++pageinfo[PAGENUMBER((uintptr_t)P)].refcount;                   
                    }
                    // share read-only pages
                    else
                    {
                        virtual_memory_map(processes[child_pid].p_pagetable, va, my_map.pa, PAGESIZE, my_map.perm, NULL);
                        
                        ++pageinfo[my_map.pn].refcount;
                    }
                }

                // The child process’s registers are initialized as a copy of the parent process’s registers, except for reg_rax.
                processes[child_pid].p_registers = current->p_registers;

                // To the child process, it returns 0.
                processes[child_pid].p_registers.reg_rax = 0;

                // To the parent process, it returns the child’s process ID.
                current->p_registers.reg_rax = child_pid;

                break;
            }
            // not enough memory to allocte page table
            else
            {                
                processes[child_pid].p_state = P_FREE;

                // return -1 to the caller
                current->p_registers.reg_rax = -1;

                return;
            }
        }
        //  If no slot exists, return -1 to the caller.
        else if (child_pid == NPROC - 1)
        {
            current->p_registers.reg_rax = -1;
        }
    }
}       


//log_printf("PN: %d, Owner: %d, RC: %d, State: %d\n", my_map.pn, pageinfo[my_map.pn].owner, pageinfo[my_map.pn].refcount, current->p_state);

// exception(reg)
//    Exception handler (for interrupts, traps, and faults).
//
//    The register values from exception time are stored in `reg`.
//    The processor responds to an exception by saving application state on
//    the kernel's stack, then jumping to kernel assembly code (in
//    k-exception.S). That code saves more registers on the kernel's stack,
//    then calls exception().
//
//    Note that hardware interrupts are disabled whenever the kernel is running.

void exception(x86_64_registers* reg) {
    // Copy the saved registers into the `current` process descriptor
    // and always use the kernel's page table.
    current->p_registers = *reg;
    set_pagetable(kernel_pagetable);

    // It can be useful to log events using `log_printf`.
    // Events logged this way are stored in the host's `log.txt` file.
    /*log_printf("proc %d: exception %d\n", current->p_pid, reg->reg_intno);*/

    // Show the current cursor location and memory state
    // (unless this is a kernel fault).
    console_show_cursor(cursorpos);
    if (reg->reg_intno != INT_PAGEFAULT || (reg->reg_err & PFERR_USER)) {
        check_virtual_memory();
        memshow_physical();
        memshow_virtual_animate();
    }

    // If Control-C was typed, exit the virtual machine.
    check_keyboard();


    // Actually handle the exception.
    switch (reg->reg_intno) {

    case INT_SYS_PANIC:
        panic(NULL);
        break;                  // will not be reached

    case INT_SYS_GETPID:
        current->p_registers.reg_rax = current->p_pid;
        break;

    case INT_SYS_YIELD:
        schedule();
        break;                  /* will not be reached */

    case INT_SYS_PAGE_ALLOC: {
        uintptr_t addr = current->p_registers.reg_rdi;

        current->p_registers.reg_rax = sys_page_alloc_help(addr, current->p_pid, current->p_pagetable);

        break;
    }

    case INT_SYS_FORK: {

        // call process_fork()
        process_fork();

        break;
    }

    case INT_SYS_EXIT: {

        x86_64_pagetable *pml4 = current->p_pagetable;
        x86_64_pagetable *pdpt = (x86_64_pagetable *) PTE_ADDR(pml4->entry[0]);
        x86_64_pagetable *pd = (x86_64_pagetable *) PTE_ADDR(pdpt->entry[0]);
        x86_64_pagetable *pt = (x86_64_pagetable *) PTE_ADDR(pd->entry[0]);
        x86_64_pagetable *pt2 = (x86_64_pagetable *) PTE_ADDR(pd->entry[1]);

        for (uintptr_t va = PROC_START_ADDR; va < MEMSIZE_VIRTUAL; va += PAGESIZE)
        {
            if (current->p_pagetable)
            {
                vamapping my_map = virtual_memory_lookup(current->p_pagetable, va);

                // find all the process's virtual pages except pagetables
                if ((my_map.pn > 0) && (my_map.perm & PTE_W) && (pageinfo[my_map.pn].owner == current->p_pid) && pageinfo[my_map.pn].refcount
                    && (my_map.pn != PAGENUMBER(pml4)) && (my_map.pn != PAGENUMBER(pdpt)) && (my_map.pn != PAGENUMBER(pd)) && (my_map.pn != PAGENUMBER(pt))
                    && (my_map.pn != PAGENUMBER(pt2)))
                {
                    // check if shared pages
                    pageinfo[my_map.pn].refcount = 0;
                    pageinfo[my_map.pn].owner = P_FREE;
                }
                else if (!(my_map.perm & PTE_W) && (my_map.pn > 0) && pageinfo[my_map.pn].refcount)
                {
                    --pageinfo[my_map.pn].refcount;

                    if (pageinfo[my_map.pn].refcount == 0)
                    {
                        pageinfo[my_map.pn].owner = P_FREE;
                    }
                }        
            }       
        }

        pageinfo[PAGENUMBER(pml4)].owner = P_FREE;
        pageinfo[PAGENUMBER(pml4)].refcount = 0;

        pageinfo[PAGENUMBER(pdpt)].owner = P_FREE;
        pageinfo[PAGENUMBER(pdpt)].refcount = 0;

        pageinfo[PAGENUMBER(pd)].owner = P_FREE;
        pageinfo[PAGENUMBER(pd)].refcount = 0;

        pageinfo[PAGENUMBER(pt)].owner = P_FREE;
        pageinfo[PAGENUMBER(pt)].refcount = 0;

        pageinfo[PAGENUMBER(pt2)].owner = P_FREE;
        pageinfo[PAGENUMBER(pt2)].refcount = 0;

        current->p_state = P_FREE;

        break;
    }

    case INT_TIMER:
        ++ticks;
        schedule();
        break;                  /* will not be reached */

    case INT_PAGEFAULT: {
        // Analyze faulting address and access type.
        uintptr_t addr = rcr2();
        const char* operation = reg->reg_err & PFERR_WRITE
                ? "write" : "read";
        const char* problem = reg->reg_err & PFERR_PRESENT
                ? "protection problem" : "missing page";

        if (!(reg->reg_err & PFERR_USER)) {
            panic("Kernel page fault for %p (%s %s, rip=%p)!\n",
                  addr, operation, problem, reg->reg_rip);
        }
        console_printf(CPOS(24, 0), 0x0C00,
                       "Process %d page fault for %p (%s %s, rip=%p)!\n",
                       current->p_pid, addr, operation, problem, reg->reg_rip);
        current->p_state = P_BROKEN;
        break;
    }

    default:
        panic("Unexpected exception %d!\n", reg->reg_intno);
        break;                  /* will not be reached */

    }


    // Return to the current process (or run something else).
    if (current->p_state == P_RUNNABLE) {
        run(current);
    } else {
        schedule();
    }
}


// schedule
//    Pick the next process to run and then run it.
//    If there are no runnable processes, spins forever.

void schedule(void) {
    pid_t pid = current->p_pid;
    while (1) {
        pid = (pid + 1) % NPROC;
        if (processes[pid].p_state == P_RUNNABLE) {
            run(&processes[pid]);
        }
        // If Control-C was typed, exit the virtual machine.
        check_keyboard();
    }
}


// run(p)
//    Run process `p`. This means reloading all the registers from
//    `p->p_registers` using the `popal`, `popl`, and `iret` instructions.
//
//    As a side effect, sets `current = p`.

void run(proc* p) {
    assert(p->p_state == P_RUNNABLE);
    current = p;

    // Load the process's current pagetable.
    set_pagetable(p->p_pagetable);

    // This function is defined in k-exception.S. It restores the process's
    // registers then jumps back to user mode.
    exception_return(&p->p_registers);

 spinloop: goto spinloop;       // should never get here
}


// pageinfo_init
//    Initialize the `pageinfo[]` array.

void pageinfo_init(void) {
    extern char end[];

    for (uintptr_t addr = 0; addr < MEMSIZE_PHYSICAL; addr += PAGESIZE) {
        int owner;
        if (physical_memory_isreserved(addr)) {
            owner = PO_RESERVED;
        } else if ((addr >= KERNEL_START_ADDR && addr < (uintptr_t) end)
                   || addr == KERNEL_STACK_TOP - PAGESIZE) {
            owner = PO_KERNEL;
        } else {
            owner = PO_FREE;
        }
        pageinfo[PAGENUMBER(addr)].owner = owner;
        pageinfo[PAGENUMBER(addr)].refcount = (owner != PO_FREE);
    }
}


// check_page_table_mappings
//    Check operating system invariants about kernel mappings for page
//    table `pt`. Panic if any of the invariants are false.

void check_page_table_mappings(x86_64_pagetable* pt) {
    extern char start_data[], end[];
    assert(PTE_ADDR(pt) == (uintptr_t) pt);

    // kernel memory is identity mapped; data is writable
    for (uintptr_t va = KERNEL_START_ADDR; va < (uintptr_t) end;
         va += PAGESIZE) {
        vamapping vam = virtual_memory_lookup(pt, va);
        if (vam.pa != va) {
            console_printf(CPOS(22, 0), 0xC000, "%p vs %p\n", va, vam.pa);
        }
        assert(vam.pa == va);
        if (va >= (uintptr_t) start_data) {
            assert(vam.perm & PTE_W);
        }
    }

    // kernel stack is identity mapped and writable
    uintptr_t kstack = KERNEL_STACK_TOP - PAGESIZE;
    vamapping vam = virtual_memory_lookup(pt, kstack);
    assert(vam.pa == kstack);
    assert(vam.perm & PTE_W);
}


// check_page_table_ownership
//    Check operating system invariants about ownership and reference
//    counts for page table `pt`. Panic if any of the invariants are false.

static void check_page_table_ownership_level(x86_64_pagetable* pt, int level,
                                             int owner, int refcount);

void check_page_table_ownership(x86_64_pagetable* pt, pid_t pid) {
    // calculate expected reference count for page tables
    int owner = pid;
    int expected_refcount = 1;
    if (pt == kernel_pagetable) {
        owner = PO_KERNEL;
        for (int xpid = 0; xpid < NPROC; ++xpid) {
            if (processes[xpid].p_state != P_FREE
                && processes[xpid].p_pagetable == kernel_pagetable) {
                ++expected_refcount;
            }
        }
    }
    check_page_table_ownership_level(pt, 0, owner, expected_refcount);
}

static void check_page_table_ownership_level(x86_64_pagetable* pt, int level,
                                             int owner, int refcount) {
    assert(PAGENUMBER(pt) < NPAGES);
    assert(pageinfo[PAGENUMBER(pt)].owner == owner);
    assert(pageinfo[PAGENUMBER(pt)].refcount == refcount);

    if (level < 3) {
        for (int index = 0; index < NPAGETABLEENTRIES; ++index) {
            if (pt->entry[index]) {
                x86_64_pagetable* nextpt =
                    (x86_64_pagetable*) PTE_ADDR(pt->entry[index]);
                check_page_table_ownership_level(nextpt, level + 1, owner, 1);
            }
        }
    }
}


// check_virtual_memory
//    Check operating system invariants about virtual memory. Panic if any
//    of the invariants are false.

void check_virtual_memory(void) {
    // Process 0 must never be used.
    assert(processes[0].p_state == P_FREE);

    // The kernel page table should be owned by the kernel;
    // its reference count should equal 1, plus the number of processes
    // that don't have their own page tables.
    // Active processes have their own page tables. A process page table
    // should be owned by that process and have reference count 1.
    // All level-2-4 page tables must have reference count 1.

    check_page_table_mappings(kernel_pagetable);
    check_page_table_ownership(kernel_pagetable, -1);

    for (int pid = 0; pid < NPROC; ++pid) {
        if (processes[pid].p_state != P_FREE
            && processes[pid].p_pagetable != kernel_pagetable) {
            check_page_table_mappings(processes[pid].p_pagetable);
            check_page_table_ownership(processes[pid].p_pagetable, pid);
        }
    }

    // Check that all referenced pages refer to active processes
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
        if (pageinfo[pn].refcount > 0 && pageinfo[pn].owner >= 0) {
            assert(processes[pageinfo[pn].owner].p_state != P_FREE);
        }
    }
}

// memshow_physical
//    Draw a picture of physical memory on the CGA console.

static const uint16_t memstate_colors[] = {
    'K' | 0x0D00, 'R' | 0x0700, '.' | 0x0700, '1' | 0x0C00,
    '2' | 0x0A00, '3' | 0x0900, '4' | 0x0E00, '5' | 0x0F00,
    '6' | 0x0C00, '7' | 0x0A00, '8' | 0x0900, '9' | 0x0E00,
    'A' | 0x0F00, 'B' | 0x0C00, 'C' | 0x0A00, 'D' | 0x0900,
    'E' | 0x0E00, 'F' | 0x0F00, 'S'
};
#define SHARED_COLOR memstate_colors[18]
#define SHARED

void memshow_physical(void) {
    console_printf(CPOS(0, 32), 0x0F00, "PHYSICAL MEMORY");
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
        if (pn % 64 == 0) {
            console_printf(CPOS(1 + pn / 64, 3), 0x0F00, "0x%06X ", pn << 12);
        }

        int owner = pageinfo[pn].owner;
        if (pageinfo[pn].refcount == 0) {
            owner = PO_FREE;
        }
        uint16_t color = memstate_colors[owner - PO_KERNEL];
        // darker color for shared pages
        if (pageinfo[pn].refcount > 1 && pn != PAGENUMBER(CONSOLE_ADDR)){
#ifdef SHARED
            color = SHARED_COLOR | 0x0F00;
#else
            color &= 0x77FF;
#endif
        }

        console[CPOS(1 + pn / 64, 12 + pn % 64)] = color;
    }
}


// memshow_virtual(pagetable, name)
//    Draw a picture of the virtual memory map `pagetable` (named `name`) on
//    the CGA console.

void memshow_virtual(x86_64_pagetable* pagetable, const char* name) {
    assert((uintptr_t) pagetable == PTE_ADDR(pagetable));

    console_printf(CPOS(10, 26), 0x0F00, "VIRTUAL ADDRESS SPACE FOR %s", name);
    for (uintptr_t va = 0; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
        vamapping vam = virtual_memory_lookup(pagetable, va);
        uint16_t color;
        if (vam.pn < 0) {
            color = ' ';
        } else {
            assert(vam.pa < MEMSIZE_PHYSICAL);
            int owner = pageinfo[vam.pn].owner;
            if (pageinfo[vam.pn].refcount == 0) {
                owner = PO_FREE;
            }
            color = memstate_colors[owner - PO_KERNEL];
            // reverse video for user-accessible pages
            if (vam.perm & PTE_U) {
                color = ((color & 0x0F00) << 4) | ((color & 0xF000) >> 4)
                    | (color & 0x00FF);
            }
            // darker color for shared pages
            if (pageinfo[vam.pn].refcount > 1 && va != CONSOLE_ADDR) {
#ifdef SHARED
                color = (SHARED_COLOR | (color & 0xF000));
                if(! (vam.perm & PTE_U))
                    color = color | 0x0F00;

#else
                color &= 0x77FF;
#endif
            }
        }
        uint32_t pn = PAGENUMBER(va);
        if (pn % 64 == 0) {
            console_printf(CPOS(11 + pn / 64, 3), 0x0F00, "0x%06X ", va);
        }
        console[CPOS(11 + pn / 64, 12 + pn % 64)] = color;
    }
}


// memshow_virtual_animate
//    Draw a picture of process virtual memory maps on the CGA console.
//    Starts with process 1, then switches to a new process every 0.25 sec.

void memshow_virtual_animate(void) {
    static unsigned last_ticks = 0;
    static int showing = 1;

    // switch to a new process every 0.25 sec
    if (last_ticks == 0 || ticks - last_ticks >= HZ / 2) {
        last_ticks = ticks;
        ++showing;
    }

    // the current process may have died -- don't display it if so
    while (showing <= 2*NPROC
           && processes[showing % NPROC].p_state == P_FREE) {
        ++showing;
    }
    showing = showing % NPROC;

    if (processes[showing].p_state != P_FREE) {
        char s[4];
        snprintf(s, 4, "%d ", showing);
        memshow_virtual(processes[showing].p_pagetable, s);
    }
}
