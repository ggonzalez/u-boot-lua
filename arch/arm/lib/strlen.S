.globl strlen
strlen:
	stmfd	sp!, {v1, v2, v3, v4, v5, v6, v7, lr}

	mov	v7, a1
	ldr	v6,  =0x80808080

	##
	## un-aligned address till we get aligned
	##
1:	tst	v7, #3
	beq	0f
	ldrb	v1, [v7], #1
	tst	v1, #0xFF
	beq	4f
	bal	1b


	## un-rolling strings
	## as few instructions in the loop
	## as possible
	## - Check whether any position equals 0
0:	ldmfd	v7!, {v1, v2, v3, v4}
	sub	v5, v1, v6, LSR #7
	and	v5, v5, v6
	bics	v5, v5, v1
	bne	1f
	sub	v5, v2, v6, LSR #7
	and	v5, v5, v6
	bics	v5, v5, v2
	bne	2f
	sub	v5, v3, v6, LSR #7
	and	v5, v5, v6
	bics	v5, v5, v3
	bne	3f
	sub	v5, v4, v6, LSR #7
	and	v5, v5, v6
	bics	v5, v5, v4
	bne	4f
	beq	0b

4:	mov	v1, v4
	bal	0f
3:	mov	v1, v3
	sub	v7, v7, #4
	bal	0f
2:	mov	v1, v2
	sub	v7, v7, #8
	bal	0f
1:	sub	v7, v7, #12
	## After the loop we calculate the diff
	## between the end and the begining of the str
	##
0:	tst	v1, #0xFF 
	subeq	v7, v7, #1
	tst	v1, #0xFF00
	subeq	v7, v7, #1
	tst	v1, #0xFF0000
	subeq	v7, v7, #1
	tst	v1, #0xFF000000
4:	subeq	v7, v7, #1

	sub	a1, v7, a1
	ldmfd	sp!, {v1, v2, v3, v4, v5, v6, v7, pc}
