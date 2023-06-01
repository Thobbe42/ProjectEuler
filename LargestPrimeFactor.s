.data

format_string: .asciz "Result: %d\n"
val: .word 5

.global main
.extern printf

main:
	ldr r1, val /* load predefined value into r1 */
	push {lr}
	push {r1}
	bl is_prime
	pop {lr}

	mov r1, r0
	ldr r0, val
	b printf

	bx lr




is_prime:
	pop {r4} /* get parameter from the stack */

	/* check edge cases */
	cmp r4, #3
	bge skip
	mov r0, #1
	b end

	skip:
	push {lr}
	mov r6, #2
	push {r6}
	push {r4}
	bl mod /* call mod with r4 and 2 */
	pop {r5} /* r5 = r4 % 2 */
	pop {lr}

	cmp r5, #0
	bgt skip_2
	mov r0, #0
	b end

	skip_2:
	push {lr}
	mov r6, #3
	push {r6}
	push {r4}
	bl mod /* call mod with r4 and 3 */
	pop {r5} /* r5 = r4 % 3 */
	pop {lr}

	cmp r5, #3
	bgt skip_3
	mov r0, #0
	b end

	skip_3:
	mov r5, #5 /* mmove loop index to r5 */

	loop:
	mul r6, r5, r5
	cmp r6, r4
	mov r0, #1
	bgt end /* end and return true id i * i > val */

	push {lr}
	push {r5}
	push {r4}
	bl mod /* call mod with val and index */
	pop {r7}
	pop {lr}

	cmp r7, #0
	mov r0, #0
	bgt end

	add r7, r5, #1
	push {lr}
	push {r7}
	push {r4}
	bl mod /* call mod with val and index +2 */
	pop {r7}
	pop {lr}

	cmp r7, #0
	bgt end

	add r5, r5, #6 /* add 6 to the loop index */
	b loop /* jump back to beginning of the loop */

	end:
	mov pc, lr



mod:
	pop {r7} /* r7 = val */
	pop {r8} /* r8 = div */

	udiv r9, r7, r8 /* r9 = val / div */
	mul r8, r9, r7 /* r8 = r9 * val */
	sub r7, r7, r8 /* r7 = val % div */

	push {r7} /* push result on the stack */

	mov pc, lr
