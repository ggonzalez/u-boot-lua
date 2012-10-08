/*
 * Same license as uClibc
 *
 * Code contributed by Gabriel Gonzalez <gabriel.gonzalez.garcia@gmail.com>
 */ 
.globl strchr
.align 4
strchr:
	stmfd	sp!, { v1, v2, v3, v4, v5, v6, v7, lr }

	# a1 : src
	# a2 : char

	#
	# Fill the register with the chars valuea
	#
	orr	a2, a2, a2, LSL #8
	orr	a2, a2, a2, LSL #16
	ldr	v5, =0x80808080
	mov	v6, #255

	# When src pointer is un-aligned go Byte by Byte
	# till we reach an aligned address
1:	and	v1, a1, #3
	beq	1f
	ldrb	v1, [a1], #1
	cmp	v1, #0
	cmpne	v1, a2
	beq	exit
	bal	1b

	# Aligned mode
	# 1. Read Word
	# 2. Check whether we got a \0 and keep the shifted data for later use
	# 3. Find char
	# 4. If any of the above is true, break
1:	ldmfd	a1!, { v1, v2, v3, v4 }
	sub	v6, v1, v5, LSR #7
	and	v6, v6, v5
	bic	v6, v6, v1
	eor	v1, v1, a2
	sub	v7, v1, v5, LSR #7
	and	v7, v7, v5
	bic	v7, v7, v1
	cmn	v6, v7
	bne	3f
	sub	v6, v2, v5, LSR #7
	and	v6, v6, v5
	bic	v6, v6, v2
	eor	v2, v2, a2
	sub	v7, v2, v5, LSR #7
	and	v7, v7, v5
	bic	v7, v7, v2
	cmn	v6, v7
	bne	2f
	sub	v6, v3, v5, LSR #7
	and	v6, v6, v5
	bic	v6, v6, v3
	eor	v3, v3, a2
	sub	v7, v3, v5, LSR #7
	and	v7, v7, v5
	bic	v7, v7, v3
	cmn	v6, v7
	bne	1f
	sub	v6, v4, v5, LSR #7
	and	v6, v6, v5
	bic	v6, v6, v4
	eor	v4, v4, a2
	sub	v7, v4, v5, LSR #7
	and	v7, v7, v5
	bic	v7, v7, v4
	cmn	v6, v7
	bne	0f
	bal	1b


	# put the addr pointer in the right position to test for the char

3:	sub	a1, a1, #4
2:	sub	a1, a1, #4
1:	sub	a1, a1, #4

	# Char Found?
	# Check for 0x0 and reduce src pointer to the matched char
0: 	tst	v6, #0x00000080
	bne	error
	tst	v7, #0x00000080
	subne	a1, a1, #4
	bne	ret
	tst	v6, #0x00008000
	bne	error
	tst	v7, #0x00008000
	subne	a1, a1, #3
	bne	ret
	tst	v6, #0x00800000
	bne	error
	tst	v7, #0x00800000
	subne	a1, a1, #2
	bne	ret
	tst	v6, #0x80000000
	bne	error
	tst	v7, #0x80000000
	subne	a1, a1, #1
	bne	ret
/* BIG ENDIAN
0: 	tst	v6, #0x80000000
	bne	error
	tst	v7, #0x80000000
	subne	a1, a1, #4
	be	ret
	tst	v6, #0x00800000
	bne	error
	tst	v7, #0x00800000
	subne	a1, a1, #3
	bne	ret
	tst	v6, #0x00008000
	bne	error
	tst	v7, #0x00008000
	subne	a1, a1, #2
	bne	ret
	tst	v6, #0x00000080
	bne	error
	tst	v7, #0x00000080
	subne	a1, a1, #1
	bne	ret
*/
	# We shouldn't reach here, but just in case return NULL
	mov	a1, #0

	# If we leave with 0 do not substract	
exit:	cmp	v1, #0
	subne	a1, a1, #1
error:	moveq	a1, #0

ret:	ldmfd	sp!, { v1, v2, v3, v4, v5, v6, v7, pc }

