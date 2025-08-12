	.arch armv7-a
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"montgomery.c"
	.text
	.global	__aeabi_uldivmod
	.align	2
	.arch armv7-a
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	montgomery_transform, %function
montgomery_transform:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	ldr	r3, [fp, #-16]
	mov	r0, r3
	mov	r1, #0
	mov	r2, #0
	mov	r3, #0
	mov	r3, r0
	mov	r2, #0
	strd	r2, [fp, #-12]
	ldr	r3, [fp, #-20]
	mov	r2, r3
	mov	r3, #0
	ldrd	r0, [fp, #-12]
	bl	__aeabi_uldivmod
	mov	r3, r2
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	montgomery_transform, .-montgomery_transform
	.align	2
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	find_n_prime, %function
find_n_prime:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	add	fp, sp, #32
	sub	sp, sp, #20
	str	r0, [fp, #-48]
	.syntax divided
@ 21 "montgomery.h" 1
	# find_n_prime start
@ 0 "" 2
	.arm
	.syntax unified
	mov	r1, #1
	str	r1, [fp, #-40]
	mov	r1, #2
	str	r1, [fp, #-44]
	b	.L4
.L6:
	ldr	r1, [fp, #-48]
	mov	r4, r1
	mov	r5, #0
	ldr	r1, [fp, #-40]
	mov	r0, r1
	mov	r1, #0
	mul	lr, r0, r5
	mul	ip, r4, r1
	add	ip, lr, ip
	umull	r4, r5, r4, r0
	add	r1, ip, r5
	mov	r5, r1
	mvn	r0, #0
	mvn	r1, #0
	ldr	ip, [fp, #-44]
	sub	r10, ip, #32
	rsb	lr, ip, #32
	lsl	r3, r1, ip
	orr	r3, r3, r0, lsl r10
	orr	r3, r3, r0, lsr lr
	lsl	r2, r0, ip
	mvn	r6, r2
	mvn	r7, r3
	and	r8, r4, r6
	and	r9, r5, r7
	cmp	r9, #0
	cmpeq	r8, #1
	beq	.L5
	ldr	r1, [fp, #-44]
	sub	r1, r1, #1
	mov	r0, #1
	lsl	r1, r0, r1
	ldr	r0, [fp, #-40]
	add	r1, r0, r1
	str	r1, [fp, #-40]
.L5:
	ldr	r1, [fp, #-44]
	add	r1, r1, #1
	str	r1, [fp, #-44]
.L4:
	ldr	r1, [fp, #-44]
	cmp	r1, #32
	ble	.L6
	.syntax divided
@ 29 "montgomery.h" 1
	# find_n_prime end
@ 0 "" 2
	.arm
	.syntax unified
	ldr	r3, [fp, #-40]
	rsb	r3, r3, #0
	mov	r0, r3
	sub	sp, fp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
	.size	find_n_prime, .-find_n_prime
	.align	2
	.global	fill_LUT
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	fill_LUT, %function
fill_LUT:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #32
	str	r0, [fp, #-24]
	str	r1, [fp, #-28]
	str	r2, [fp, #-32]
	ldr	r1, [fp, #-32]
	ldr	r0, [fp, #-28]
	bl	montgomery_transform
	str	r0, [fp, #-8]
	ldr	r0, [fp, #-32]
	bl	find_n_prime
	str	r0, [fp, #-16]
	mov	r3, #0
	str	r3, [fp, #-12]
	b	.L9
.L10:
	ldr	r3, [fp, #-12]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-24]
	add	r3, r2, r3
	ldr	r2, [fp, #-8]
	str	r2, [r3]
	ldr	r3, [fp, #-8]
	mov	r0, r3
	mov	r1, #0
	ldr	r3, [fp, #-8]
	mov	r2, r3
	mov	r3, #0
	mul	lr, r2, r1
	mul	ip, r0, r3
	add	ip, lr, ip
	umull	r0, r1, r0, r2
	add	r3, ip, r1
	mov	r1, r3
	ldr	r3, [fp, #-32]
	ldr	r2, [fp, #-16]
	bl	montgomery_reduce
	str	r0, [fp, #-8]
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	str	r3, [fp, #-12]
.L9:
	ldr	r3, [fp, #-12]
	cmp	r3, #31
	ble	.L10
	nop
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	fill_LUT, .-fill_LUT
	.align	2
	.global	montgomery_reduce
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	montgomery_reduce, %function
montgomery_reduce:
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, fp, lr}
	add	fp, sp, #12
	sub	sp, sp, #40
	strd	r0, [fp, #-44]
	str	r2, [fp, #-48]
	str	r3, [fp, #-52]
	.syntax divided
@ 17 "montgomery.c" 1
	# reduce start
@ 0 "" 2
	.arm
	.syntax unified
	ldr	r2, [fp, #-44]
	ldr	r3, [fp, #-48]
	mul	r3, r2, r3
	str	r3, [fp, #-16]
	ldr	r3, [fp, #-16]
	mov	r0, r3
	mov	r1, #0
	ldr	r3, [fp, #-52]
	mov	r2, r3
	mov	r3, #0
	mul	lr, r2, r1
	mul	ip, r0, r3
	add	ip, lr, ip
	umull	r2, r3, r0, r2
	add	r1, ip, r3
	mov	r3, r1
	strd	r2, [fp, #-28]
	strd	r2, [fp, #-28]
	ldrd	r0, [fp, #-44]
	ldrd	r2, [fp, #-28]
	adds	r4, r0, r2
	adc	r5, r1, r3
	mov	r2, #0
	mov	r3, #0
	mov	r2, r5
	mov	r3, #0
	mov	r3, r2
	str	r3, [fp, #-32]
	.syntax divided
@ 25 "montgomery.c" 1
	# reduce end
@ 0 "" 2
	.arm
	.syntax unified
	ldr	r3, [fp, #-32]
	mov	r0, r3
	sub	sp, fp, #12
	@ sp needed
	pop	{r4, r5, fp, pc}
	.size	montgomery_reduce, .-montgomery_reduce
	.align	2
	.global	montgomery_exp
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	montgomery_exp, %function
montgomery_exp:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r6, fp, lr}
	add	fp, sp, #16
	sub	sp, sp, #20
	mov	r5, r0
	mov	r4, r1
	str	r2, [fp, #-32]
	mov	r6, r3
	mov	r1, r6
	mov	r0, #1
	bl	montgomery_transform
	str	r0, [fp, #-24]
	b	.L14
.L16:
	and	r3, r4, #1
	cmp	r3, #0
	beq	.L15
	mov	r0, r5
	mov	r1, #0
	ldr	r3, [fp, #-24]
	mov	r2, r3
	mov	r3, #0
	mul	lr, r2, r1
	mul	ip, r0, r3
	add	ip, lr, ip
	umull	r0, r1, r0, r2
	add	r3, ip, r1
	mov	r1, r3
	mov	r3, r6
	ldr	r2, [fp, #-32]
	bl	montgomery_reduce
	str	r0, [fp, #-24]
.L15:
	mov	r0, r5
	mov	r1, #0
	mov	r2, r5
	mov	r3, #0
	mul	lr, r2, r1
	mul	ip, r0, r3
	add	ip, lr, ip
	umull	r0, r1, r0, r2
	add	r3, ip, r1
	mov	r1, r3
	mov	r3, r6
	ldr	r2, [fp, #-32]
	bl	montgomery_reduce
	mov	r5, r0
	lsr	r4, r4, #1
.L14:
	cmp	r4, #0
	bne	.L16
	ldr	r3, [fp, #-24]
	mov	r0, r3
	sub	sp, fp, #16
	@ sp needed
	pop	{r4, r5, r6, fp, pc}
	.size	montgomery_exp, .-montgomery_exp
	.align	2
	.global	montgomery_exp_lut_optimized
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	montgomery_exp_lut_optimized, %function
montgomery_exp_lut_optimized:
	@ args = 4, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, fp, lr}
	add	fp, sp, #12
	sub	sp, sp, #16
	mov	r4, r1
	str	r2, [fp, #-24]
	str	r3, [fp, #-28]
	mov	r5, #0
	ldr	r1, [fp, #-28]
	mov	r0, #1
	bl	montgomery_transform
	str	r0, [fp, #-16]
	b	.L19
.L21:
	and	r3, r4, #1
	cmp	r3, #0
	beq	.L20
	lsl	r3, r5, #2
	ldr	r2, [fp, #4]
	add	r3, r2, r3
	ldr	r3, [r3]
	mov	r0, r3
	mov	r1, #0
	ldr	r3, [fp, #-16]
	mov	r2, r3
	mov	r3, #0
	mul	lr, r2, r1
	mul	ip, r0, r3
	add	ip, lr, ip
	umull	r0, r1, r0, r2
	add	r3, ip, r1
	mov	r1, r3
	ldr	r3, [fp, #-28]
	ldr	r2, [fp, #-24]
	bl	montgomery_reduce
	str	r0, [fp, #-16]
.L20:
	add	r5, r5, #1
	lsr	r4, r4, #1
.L19:
	cmp	r4, #0
	bne	.L21
	ldr	r3, [fp, #-16]
	mov	r0, r3
	sub	sp, fp, #12
	@ sp needed
	pop	{r4, r5, fp, pc}
	.size	montgomery_exp_lut_optimized, .-montgomery_exp_lut_optimized
	.align	2
	.global	rsa_montgomery_encrypt
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	rsa_montgomery_encrypt, %function
rsa_montgomery_encrypt:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #32
	str	r0, [fp, #-24]
	str	r1, [fp, #-28]
	str	r2, [fp, #-32]
	ldr	r1, [fp, #-28]
	ldr	r0, [fp, #-24]
	bl	montgomery_transform
	str	r0, [fp, #-8]
	ldr	r0, [fp, #-28]
	bl	find_n_prime
	str	r0, [fp, #-12]
	ldr	r3, [fp, #-28]
	ldr	r2, [fp, #-12]
	ldr	r1, [fp, #-32]
	ldr	r0, [fp, #-8]
	bl	montgomery_exp
	str	r0, [fp, #-16]
	ldr	r3, [fp, #-16]
	mov	r0, r3
	mov	r1, #0
	ldr	r3, [fp, #-28]
	ldr	r2, [fp, #-12]
	bl	montgomery_reduce
	str	r0, [fp, #-20]
	.syntax divided
@ 99 "montgomery.c" 1
	# reduce end
@ 0 "" 2
	.arm
	.syntax unified
	ldr	r3, [fp, #-20]
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	rsa_montgomery_encrypt, .-rsa_montgomery_encrypt
	.align	2
	.global	rsa_montgomery_decrypt
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	rsa_montgomery_decrypt, %function
rsa_montgomery_decrypt:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #32
	str	r0, [fp, #-24]
	str	r1, [fp, #-28]
	str	r2, [fp, #-32]
	ldr	r1, [fp, #-28]
	ldr	r0, [fp, #-24]
	bl	montgomery_transform
	str	r0, [fp, #-8]
	ldr	r0, [fp, #-28]
	bl	find_n_prime
	str	r0, [fp, #-12]
	ldr	r3, [fp, #-28]
	ldr	r2, [fp, #-12]
	ldr	r1, [fp, #-32]
	ldr	r0, [fp, #-8]
	bl	montgomery_exp
	str	r0, [fp, #-16]
	ldr	r3, [fp, #-16]
	mov	r0, r3
	mov	r1, #0
	ldr	r3, [fp, #-28]
	ldr	r2, [fp, #-12]
	bl	montgomery_reduce
	str	r0, [fp, #-20]
	ldr	r3, [fp, #-20]
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	rsa_montgomery_decrypt, .-rsa_montgomery_decrypt
	.ident	"GCC: (GNU) 8.2.1 20180801 (Red Hat 8.2.1-2)"
	.section	.note.GNU-stack,"",%progbits
