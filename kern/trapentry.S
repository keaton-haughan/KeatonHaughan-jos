/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

// HINT 1 : TRAPHANDLER_NOEC(t_divide, T_DIVIDE);
//          Do something like this if there is no error code for the trap
// HINT 2 : TRAPHANDLER(t_dblflt, T_DBLFLT);
//          Do something like this if the trap includes an error code..
// HINT 3 : READ Intel's manual to check if the trap includes an error code
//          or not...
TRAPHANDLER_NOEC(t_divide, T_DIVIDE)    // 0  - no error code
TRAPHANDLER_NOEC(t_debug, T_DEBUG)      // 1  - no error code
TRAPHANDLER_NOEC(t_nmi, T_NMI)          // 2  - no error code
TRAPHANDLER_NOEC(t_brkpt, T_BRKPT)      // 3  - no error code
TRAPHANDLER_NOEC(t_oflow, T_OFLOW)      // 4  - no error code
TRAPHANDLER_NOEC(t_bound, T_BOUND)      // 5  - no error code
TRAPHANDLER_NOEC(t_illop, T_ILLOP)      // 6  - no error code
TRAPHANDLER_NOEC(t_device, T_DEVICE)    // 7  - no error code
TRAPHANDLER(t_dblflt, T_DBLFLT)         // 8  - has error code (zero)
TRAPHANDLER(t_tss, T_TSS)               // 10 - has error code
TRAPHANDLER(t_segnp, T_SEGNP)           // 11 - has error code
TRAPHANDLER(t_stack, T_STACK)           // 12 - has error code
TRAPHANDLER(t_gpflt, T_GPFLT)           // 13 - has error code
TRAPHANDLER(t_pgflt, T_PGFLT)           // 14 - has error code
TRAPHANDLER_NOEC(t_fperr, T_FPERR)      // 16 - no error code
TRAPHANDLER(t_align, T_ALIGN)           // 17 - has error code (zero)
TRAPHANDLER_NOEC(t_mchk, T_MCHK)        // 18 - no error code
TRAPHANDLER_NOEC(t_simderr, T_SIMDERR)  // 19 - no error code

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
    pushl %ds
    pushl %es
    pushal                        // push all general purpose registers

    movw $(GD_KD), %ax            // load kernel data segment into ds and es
    movw %ax, %ds
    movw %ax, %es

    pushl %esp                    // pass pointer to Trapframe as argument to trap()
    call trap

