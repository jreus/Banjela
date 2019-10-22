	.text
	.syntax unified
	.eabi_attribute	67, "2.09"	@ Tag_conformance
	.cpu	cortex-a8
	.eabi_attribute	6, 10	@ Tag_CPU_arch
	.eabi_attribute	7, 65	@ Tag_CPU_arch_profile
	.eabi_attribute	8, 1	@ Tag_ARM_ISA_use
	.eabi_attribute	9, 2	@ Tag_THUMB_ISA_use
	.fpu	neon
	.eabi_attribute	17, 1	@ Tag_ABI_PCS_GOT_use
	.eabi_attribute	20, 2	@ Tag_ABI_FP_denormal
	.eabi_attribute	23, 1	@ Tag_ABI_FP_number_model
	.eabi_attribute	34, 1	@ Tag_CPU_unaligned_access
	.eabi_attribute	24, 1	@ Tag_ABI_align_needed
	.eabi_attribute	25, 1	@ Tag_ABI_align_preserved
	.eabi_attribute	28, 1	@ Tag_ABI_VFP_args
	.eabi_attribute	38, 1	@ Tag_ABI_FP_16bit_format
	.eabi_attribute	18, 4	@ Tag_ABI_PCS_wchar_t
	.eabi_attribute	26, 2	@ Tag_ABI_enum_size
	.eabi_attribute	14, 0	@ Tag_ABI_PCS_R9_use
	.eabi_attribute	68, 1	@ Tag_Virtualization_use
	.file	"/root/Bela/projects/I2C_Input_Test/build/render.bc"
	.globl	_Z9readTouchPv
	.p2align	2
	.type	_Z9readTouchPv,%function
_Z9readTouchPv:                         @ @_Z9readTouchPv
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	movw	r4, :lower16:ts
	movt	r4, :upper16:ts
	ldrb	r0, [r4, #16]
	cmp	r0, #0
	popeq	{r4, r5, r6, r10, r11, pc}
	mov	r0, r4
	bl	_ZN5Trill7readI2CEv
	movw	r5, :lower16:.L.str
	mov	r6, #0
	movt	r5, :upper16:.L.str
.LBB0_1:                                @ =>This Inner Loop Header: Depth=1
	sub	r0, r4, r6, lsl #2
	ldr	r1, [r0, #84]
	mov	r0, r5
	bl	printf
	sub	r6, r6, #1
	cmn	r6, #26
	bne	.LBB0_1
@ BB#2:
	mov	r0, #10
	pop	{r4, r5, r6, r10, r11, lr}
	b	putchar
.Lfunc_end0:
	.size	_Z9readTouchPv, .Lfunc_end0-_Z9readTouchPv
	.fnend

	.globl	setup
	.p2align	2
	.type	setup,%function
setup:                                  @ @setup
	.fnstart
@ BB#0:
	.save	{r4, r10, r11, lr}
	push	{r4, r10, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r4, r0
	movw	r0, :lower16:ts
	movt	r0, :upper16:ts
	mov	r1, #1
	mov	r2, #24
	bl	_ZN5Trill5setupEii
	movw	r0, :lower16:_Z9readTouchPv
	movw	r2, :lower16:.L.str.3
	movt	r0, :upper16:_Z9readTouchPv
	movt	r2, :upper16:.L.str.3
	mov	r1, #50
	mov	r3, #0
	bl	Bela_createAuxiliaryTask
	movw	r1, :lower16:.L_MergedGlobals
	movw	r2, #19923
	movt	r1, :upper16:.L_MergedGlobals
	movt	r2, #4194
	str	r0, [r1]
	ldr	r0, [r1, #4]
	vldr	s0, [r4, #32]
	smmul	r0, r0, r2
	asr	r2, r0, #6
	add	r0, r2, r0, lsr #31
	vmov	s2, r0
	vcvt.f32.s32	d16, d1
	vmul.f32	d16, d16, d0
	vcvt.s32.f32	d0, d16
	vmov	r0, s0
	str	r0, [r1, #8]
	mov	r0, #1
	pop	{r4, r10, r11, pc}
.Lfunc_end1:
	.size	setup, .Lfunc_end1-setup
	.fnend

	.globl	render
	.p2align	2
	.type	render,%function
render:                                 @ @render
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r7, r8, r10, r11, lr}
	push	{r4, r5, r6, r7, r8, r10, r11, lr}
	.setfp	r11, sp, #24
	add	r11, sp, #24
	mov	r4, r0
	ldr	r0, [r4, #20]
	cmp	r0, #0
	beq	.LBB2_5
@ BB#1:                                 @ %.lr.ph.preheader
	movw	r6, :lower16:_ZZ6renderE9readCount
	movw	r7, :lower16:.L_MergedGlobals
	mov	r8, #0
	movt	r6, :upper16:_ZZ6renderE9readCount
	movt	r7, :upper16:.L_MergedGlobals
	mov	r5, #0
.LBB2_2:                                @ %.lr.ph
                                        @ =>This Inner Loop Header: Depth=1
	ldr	r1, [r6]
	ldr	r2, [r7, #8]
	add	r1, r1, #1
	str	r1, [r6]
	cmp	r1, r2
	blt	.LBB2_4
@ BB#3:                                 @   in Loop: Header=BB2_2 Depth=1
	ldr	r0, [r7]
	str	r8, [r6]
	bl	Bela_scheduleAuxiliaryTask
	ldr	r0, [r4, #20]
.LBB2_4:                                @   in Loop: Header=BB2_2 Depth=1
	add	r5, r5, #1
	cmp	r5, r0
	blo	.LBB2_2
.LBB2_5:                                @ %._crit_edge
	pop	{r4, r5, r6, r7, r8, r10, r11, pc}
.Lfunc_end2:
	.size	render, .Lfunc_end2-render
	.fnend

	.globl	cleanup
	.p2align	2
	.type	cleanup,%function
cleanup:                                @ @cleanup
	.fnstart
@ BB#0:
	movw	r0, :lower16:ts
	movt	r0, :upper16:ts
	b	_ZN5Trill7cleanupEv
.Lfunc_end3:
	.size	cleanup, .Lfunc_end3-cleanup
	.fnend

	.section	.text.startup,"ax",%progbits
	.p2align	2
	.type	_GLOBAL__sub_I_render.ii,%function
_GLOBAL__sub_I_render.ii:               @ @_GLOBAL__sub_I_render.ii
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	movw	r4, :lower16:_ZStL8__ioinit
	movt	r4, :upper16:_ZStL8__ioinit
	mov	r0, r4
	bl	_ZNSt8ios_base4InitC1Ev
	movw	r5, :lower16:__dso_handle
	movw	r0, :lower16:_ZNSt8ios_base4InitD1Ev
	movt	r5, :upper16:__dso_handle
	movt	r0, :upper16:_ZNSt8ios_base4InitD1Ev
	mov	r1, r4
	mov	r2, r5
	bl	__cxa_atexit
	movw	r4, :lower16:ts
	movt	r4, :upper16:ts
	mov	r0, r4
	bl	_ZN5TrillC1Ev
	movw	r0, :lower16:_ZN5TrillD1Ev
	mov	r1, r4
	movt	r0, :upper16:_ZN5TrillD1Ev
	mov	r2, r5
	pop	{r4, r5, r11, lr}
	b	__cxa_atexit
.Lfunc_end4:
	.size	_GLOBAL__sub_I_render.ii, .Lfunc_end4-_GLOBAL__sub_I_render.ii
	.fnend

	.type	_ZStL8__ioinit,%object  @ @_ZStL8__ioinit
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.type	ts,%object              @ @ts
	.bss
	.globl	ts
	.p2align	2
ts:
	.zero	188
	.size	ts, 188

	.type	.L.str,%object          @ @.str
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str:
	.asciz	"%5d "
	.size	.L.str, 5

	.type	.L.str.3,%object        @ @.str.3
.L.str.3:
	.asciz	"I2C-read"
	.size	.L.str.3, 9

	.type	_ZZ6renderE9readCount,%object @ @_ZZ6renderE9readCount
	.local	_ZZ6renderE9readCount
	.comm	_ZZ6renderE9readCount,4,4
	.section	.init_array,"aw",%init_array
	.p2align	2
	.long	_GLOBAL__sub_I_render.ii(target1)
	.type	.L_MergedGlobals,%object @ @_MergedGlobals
	.data
	.p2align	2
.L_MergedGlobals:
	.long	0
	.long	500                     @ 0x1f4
	.long	0                       @ 0x0
	.size	.L_MergedGlobals, 12


	.globl	i2cReadTask
i2cReadTask = .L_MergedGlobals
	.size	i2cReadTask, 4
	.globl	readInterval
readInterval = .L_MergedGlobals+4
	.size	readInterval, 4
	.globl	readIntervalSamples
readIntervalSamples = .L_MergedGlobals+8
	.size	readIntervalSamples, 4
	.ident	"clang version 3.9.1-9 (tags/RELEASE_391/rc2)"
	.section	".note.GNU-stack","",%progbits
	.eabi_attribute	30, 2	@ Tag_ABI_optimization_goals
