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
	.file	"main.c"
	.text
	.global	__aeabi_uidivmod
	.align	2
	.global	gcd
	.arch armv7-a
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	gcd, %function
gcd:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	b	.L2
.L3:
	ldr	r3, [fp, #-20]
	str	r3, [fp, #-8]
	ldr	r3, [fp, #-16]
	ldr	r1, [fp, #-20]
	mov	r0, r3
	bl	__aeabi_uidivmod
	mov	r3, r1
	str	r3, [fp, #-20]
	ldr	r3, [fp, #-8]
	str	r3, [fp, #-16]
.L2:
	ldr	r3, [fp, #-20]
	cmp	r3, #0
	bne	.L3
	ldr	r3, [fp, #-16]
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	gcd, .-gcd
	.align	2
	.global	get_public_exponent
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	get_public_exponent, %function
get_public_exponent:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	ldr	r3, [fp, #-16]
	sub	r3, r3, #1
	ldr	r2, [fp, #-20]
	sub	r2, r2, #1
	mul	r3, r2, r3
	str	r3, [fp, #-12]
	mov	r3, #3
	str	r3, [fp, #-8]
	b	.L6
.L9:
	ldr	r1, [fp, #-12]
	ldr	r0, [fp, #-8]
	bl	gcd
	mov	r3, r0
	cmp	r3, #1
	bne	.L7
	ldr	r3, [fp, #-8]
	b	.L8
.L7:
	ldr	r3, [fp, #-8]
	add	r3, r3, #2
	str	r3, [fp, #-8]
.L6:
	ldr	r2, [fp, #-8]
	ldr	r3, [fp, #-12]
	cmp	r2, r3
	bcc	.L9
	mov	r3, #1
.L8:
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	get_public_exponent, .-get_public_exponent
	.global	__aeabi_uldivmod
	.align	2
	.global	find_d
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	find_d, %function
find_d:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, fp, lr}
	add	fp, sp, #28
	sub	sp, sp, #32
	str	r0, [fp, #-48]
	str	r1, [fp, #-52]
	str	r2, [fp, #-56]
	ldr	r3, [fp, #-48]
	sub	r3, r3, #1
	mov	r0, r3
	mov	r1, #0
	ldr	r3, [fp, #-52]
	sub	r3, r3, #1
	mov	r2, r3
	mov	r3, #0
	mul	lr, r2, r1
	mul	ip, r0, r3
	add	ip, lr, ip
	umull	r2, r3, r0, r2
	add	r1, ip, r3
	mov	r3, r1
	strd	r2, [fp, #-44]
	strd	r2, [fp, #-44]
	mov	r2, #1
	mov	r3, #0
	strd	r2, [fp, #-36]
.L13:
	ldr	r3, [fp, #-32]
	ldr	r2, [fp, #-44]
	mul	r2, r2, r3
	ldr	r3, [fp, #-40]
	ldr	r1, [fp, #-36]
	mul	r3, r1, r3
	add	r1, r2, r3
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-44]
	umull	r2, r3, r2, r3
	add	r1, r1, r3
	mov	r3, r1
	adds	r6, r2, #1
	adc	r7, r3, #0
	ldr	r3, [fp, #-56]
	mov	r2, r3
	mov	r3, #0
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_uldivmod
	orrs	r3, r2, r3
	bne	.L11
	ldr	r3, [fp, #-32]
	ldr	r2, [fp, #-44]
	mul	r2, r2, r3
	ldr	r3, [fp, #-40]
	ldr	r1, [fp, #-36]
	mul	r3, r1, r3
	add	r1, r2, r3
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-44]
	umull	r2, r3, r2, r3
	add	r1, r1, r3
	mov	r3, r1
	adds	r8, r2, #1
	adc	r9, r3, #0
	ldr	r3, [fp, #-56]
	mov	r2, r3
	mov	r3, #0
	mov	r0, r8
	mov	r1, r9
	bl	__aeabi_uldivmod
	mov	r2, r0
	mov	r3, r1
	mov	r3, r2
	b	.L14
.L11:
	ldrd	r2, [fp, #-36]
	adds	r4, r2, #1
	adc	r5, r3, #0
	strd	r4, [fp, #-36]
	b	.L13
.L14:
	mov	r0, r3
	sub	sp, fp, #28
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, fp, pc}
	.size	find_d, .-find_d
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #48
	str	r0, [fp, #-48]
	str	r1, [fp, #-52]
	ldr	r3, [fp, #-48]
	cmp	r3, #2
	bne	.L16
	ldr	r3, [fp, #-52]
	add	r3, r3, #4
	ldr	r3, [r3]
	mov	r0, r3
	bl	atoi
	mov	r3, r0
	b	.L17
.L16:
	movw	r3, #16960
	movt	r3, 15
.L17:
	str	r3, [fp, #-12]
	movw	r3, #7919
	str	r3, [fp, #-16]
	movw	r3, #6287
	str	r3, [fp, #-20]
	mov	r3, #788
	str	r3, [fp, #-24]
	ldr	r3, [fp, #-16]
	ldr	r2, [fp, #-20]
	mul	r3, r2, r3
	str	r3, [fp, #-28]
	ldr	r1, [fp, #-20]
	ldr	r0, [fp, #-16]
	bl	get_public_exponent
	str	r0, [fp, #-32]
	ldr	r2, [fp, #-32]
	ldr	r1, [fp, #-20]
	ldr	r0, [fp, #-16]
	bl	find_d
	str	r0, [fp, #-36]
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L18
.L19:
	ldr	r2, [fp, #-32]
	ldr	r1, [fp, #-28]
	ldr	r0, [fp, #-24]
	bl	rsa_montgomery_encrypt
	str	r0, [fp, #-40]
	ldr	r2, [fp, #-36]
	ldr	r1, [fp, #-28]
	ldr	r0, [fp, #-40]
	bl	rsa_montgomery_decrypt
	str	r0, [fp, #-44]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L18:
	ldr	r2, [fp, #-8]
	ldr	r3, [fp, #-12]
	cmp	r2, r3
	blt	.L19
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	main, .-main
	.ident	"GCC: (GNU) 8.2.1 20180801 (Red Hat 8.2.1-2)"
	.section	.note.GNU-stack,"",%progbits
