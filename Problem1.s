.data
max: .word 1000

preset: .asciz "Max. Value: %d\n"
out: .asciz "Result: %d\n"

/* -- Problem1.s */
.global main
.extern printf

main:
	ldr r1, max /* load max to r1 */
	ldr r0, =preset
	push {lr}
	push {r1}
	bl printf
	pop {r1}
	pop {lr}
	mov r2, #1
	mov r3, #0 /* r3 = return value */
	loop:
	cmp r2, r1 /* compare r2 and r1 for terminating the loop */
	bge end /* end condition: r2 >= max */

	push {lr}
	bl check_divisor
	pop {lr}
	add r2, #1 /* increment loop counter by one */
	b loop
	end:
	ldr r0, =out
	mov r1, r3
	b printf
	mov r0, r3 /* move calculated value to return register */
	bx lr

check_divisor:
	mov r4, r2 /* move current value to r4 */
	lsl r4, r4, #1 /* multiply by 2 */
	mov r7, #3
	udiv r5, r4, r7
	mul r6, r5, r7
	sub r4, r4, r6
	cmp r4, #0 /* check if r4 dividable by 3 */
	bne continue
	add r3, r2 /* equal: add current value to result */
	bx lr
	continue:
	mov r4, r2 /* move current value to r4 */
	lsl r4, r4, #2 /* multiply by 4 */
	mov r7, #5
	udiv r5, r4, r7
	mul r6, r5, r7
	sub r4, r4, r6
	cmp r4, #0 /* check if r4 dividable by 5 */
	bne exit
	add r3, r2 /* equal: add current value to result */
	exit:
	bx lr
