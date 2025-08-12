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
	.file	"modular_exponentiation.c"
	.text
	.global	__aeabi_uidivmod
	.global	__aeabi_uldivmod
	.align	2
	.global	mod_exp
	.arch armv7-a
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	mod_exp, %function
mod_exp:
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #40
	str	r0, [fp, #-32]
	str	r1, [fp, #-36]
	str	r2, [fp, #-40]
	ldr	r3, [fp, #-36]
	cmp	r3, #0
	bne	.L2
	mov	r3, #1
	b	.L3
.L2:
	mov	r2, #1
	mov	r3, #0
	strd	r2, [fp, #-12]
	ldr	r3, [fp, #-32]
	ldr	r1, [fp, #-40]
	mov	r0, r3
	bl	__aeabi_uidivmod
	mov	r3, r1
	mov	r2, r3
	mov	r3, #0
	strd	r2, [fp, #-28]
	mov	r3, #0
	str	r3, [fp, #-16]
	b	.L4
.L5:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-28]
	mul	r2, r2, r3
	ldr	r3, [fp, #-24]
	ldr	r1, [fp, #-12]
	mul	r3, r1, r3
	add	r3, r2, r3
	ldr	r1, [fp, #-12]
	ldr	r2, [fp, #-28]
	umull	r0, r1, r1, r2
	add	r3, r3, r1
	mov	r1, r3
	ldr	r3, [fp, #-40]
	mov	r2, r3
	mov	r3, #0
	bl	__aeabi_uldivmod
	strd	r2, [fp, #-12]
	ldr	r3, [fp, #-16]
	add	r3, r3, #1
	str	r3, [fp, #-16]
.L4:
	ldr	r2, [fp, #-16]
	ldr	r3, [fp, #-36]
	cmp	r2, r3
	bcc	.L5
	ldr	r3, [fp, #-12]
.L3:
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	mod_exp, .-mod_exp
	.align	2
	.global	rsa_modexp_encrypt
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	rsa_modexp_encrypt, %function
rsa_modexp_encrypt:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	str	r0, [fp, #-8]
	str	r1, [fp, #-12]
	str	r2, [fp, #-16]
	ldr	r2, [fp, #-12]
	ldr	r1, [fp, #-16]
	ldr	r0, [fp, #-8]
	bl	mod_exp
	mov	r3, r0
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	rsa_modexp_encrypt, .-rsa_modexp_encrypt
	.align	2
	.global	rsa_modexp_decrypt
	.syntax unified
	.arm
	.fpu vfpv3-d16
	.type	rsa_modexp_decrypt, %function
rsa_modexp_decrypt:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	str	r0, [fp, #-8]
	str	r1, [fp, #-12]
	str	r2, [fp, #-16]
	ldr	r2, [fp, #-12]
	ldr	r1, [fp, #-16]
	ldr	r0, [fp, #-8]
	bl	mod_exp
	mov	r3, r0
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	rsa_modexp_decrypt, .-rsa_modexp_decrypt
	.ident	"GCC: (GNU) 8.2.1 20180801 (Red Hat 8.2.1-2)"
	.section	.note.GNU-stack,"",%progbits
