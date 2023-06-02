.data

format_string: .asciz "Result: %d\n"
val: .word 117

.global main
.extern printf

main:
	ldr r1, val /* load predefined value into r1 */

	/* call is_prime with r1 as parameter, selut stored in r0 */
	push {lr}
	push {r1}
	bl is_prime
	pop {lr}

	mov r1, r0 /* move result to r1 */
	ldr r0, =format_string /* load format string into r0 */
	b printf 

	bx lr




is_prime:
	pop {r4} /* get parameter from the stack */

	/* check edge cases */
	cmp r4, #3
	bgt skip
	mov r0, #1 /* return 1 if value if smaller than 3 */
	b end

	skip:
	push {lr}
	mov r6, #2
	/* push value and 2 on the stack as parameters for mod */
	push {r6}
	push {r4}
	bl mod /* call mod with r4 and 2 */
	pop {r5} /* r5 = r4 % 2 */
	pop {lr}

	cmp r5, #0 /* r5 = r4 % 2 = 0 ? */
	bgt skip_2
	mov r0, #0 /* return 0 */
	b end

	skip_2:
	push {lr}
	mov r6, #3
	/* push value and 3 on the stack as parameters for mod */
	push {r6}
	push {r4}
	bl mod /* call mod with r4 and 3 */
	pop {r5} /* r5 = r4 % 3 */
	pop {lr}

	cmp r5, #0 /* r5 = r4 % 3 = 0 ? */
	bgt skip_3
	mov r0, #0 /* return 0 */
	b end

	skip_3:
	mov r5, #5 /* move loop index to r5 */

	loop:
	mul r6, r5, r5 /* r6 = i + i */
	cmp r6, r4 /* compare r6 to val */
	mov r0, #1
	bgt end /* end and return true if i * i > val */

	push {lr}
	/* push val and currentindex i onto the stack as parameters for mod */
	push {r5}
	push {r4}
	bl mod /* call mod with val and index */
	pop {r7} /* r7 = val % i */
	pop {lr}

	cmp r7, #0 /* r7 = val % i = 0 ? */
	mov r0, #0 /* return 0 */
	bgt end

	add r7, r5, #2 /* r7 = index +2 */
	push {lr}
	/* push val and i+2 onto the stack as parameters for mod */
	push {r7}
	push {r4}
	bl mod /* call mod with val and index +2 */
	pop {r7} /* r7 = val % i+2 */
	pop {lr}

	cmp r7, #0 /* r7 = val % i+2 = 0 ? */
	bgt end

	add r5, r5, #6 /* add 6 to the loop index */
	b loop /* jump back to beginning of the loop */

	end:
	mov pc, lr



mod:
	pop {r7} /* r7 = val */
	pop {r8} /* r8 = div */

	udiv r9, r7, r8 /* r9 = val / div */
	mul r8, r9, r8 /* r8 = r9 * div */
	sub r7, r7, r8 /* r7 = val % div */

	push {r7} /* push result on the stack */

	mov pc, lr
