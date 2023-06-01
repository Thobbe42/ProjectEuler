.data
format_string: .asciz "Result: %d\n"
max_val: .word 4000000

.global main
.extern printf
main:

	ldr r2, max_val /* load pre-defined max value to r0 */
	mov r3, #0 /* r3 = index for the loop */
	mov r1, #0 /* r1 = return value */

	loop:
	push {lr} /* push link register on the stack */
	push {r3} /* push r3 to the stack as parameter for fib */
	bl fib
	pop {lr} /* get lr from the stack */

	mov r1, r0
	ldr r0, =format_string
	b printf

	mov r0, #0

	bx lr





fib:
	pop {r4} /* get the parameter from the stack */
	cmp r4, #1 /* r4==1? */
	beq return
	cmp r4, #2 /* r4 ==2? */
	beq return


	/* save registers 4-6 on the stack before the funktion calls */
	push {r6}
	push {r4}
	push {r5}

	/* first recursive call */
	sub r5, r4, #1 /* r5 = current index - 1 */
	push {lr} /* push link register on the stack */
	push {r5} /* push r5 to the stack as parameter for the recursive call */
	bl fib


	/* move return of first call to r6 */
	pop {lr} /* get lr from the stack */
	mov r6, r0 /* save return of call in r6 */

	/* update r4 and r5 after the recursive call to regain correct values */
	pop {r5}
	pop {r4}
	push {r4}
	push {r5}

	/* second recursive call */
	sub r5, r4, #2 /* r5 = current index -2 */
	push {lr} /* push link register on the stack */
	push {r5} /* push r5 to the stack as parameter for the recursive call */
	bl fib
	pop {lr} /* get the link register from the stack */

	/* restore r4 and r5 from the stack */
	pop {r5}
	pop {r4}

	add r4, r0, r6 /* add the first recursion value onto the second */
	pop {r6} /* restore r6 from the stack */

	return:
	mov r0, r4 /* move return value from r4 to r0 */

	mov pc, lr
