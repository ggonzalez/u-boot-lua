.globl setjmp
setjmp:
	stmia	a1!, { v1-v7, fp, ip, sp, lr }
	mov	a1, #0
	mov	pc, lr

.globl longjmp
longjmp:
	ldmfd	a1!, { v1-v7, fp, ip, sp, lr }
	movs	a1, a2

	moveq	a1, #0

	mov	pc, lr
