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
	.file	"/root/Bela/projects/I2C_Input_Test/build/Trill.bc"
	.globl	_ZN5TrillC2Ev
	.p2align	2
	.type	_ZN5TrillC2Ev,%function
_ZN5TrillC2Ev:                          @ @_ZN5TrillC2Ev
	.fnstart
@ BB#0:
	movw	r1, :lower16:_ZTV5Trill
	movt	r1, :upper16:_ZTV5Trill
	add	r1, r1, #8
	str	r1, [r0]
	movw	r1, #10000
	strh	r1, [r0, #80]
	bx	lr
.Lfunc_end0:
	.size	_ZN5TrillC2Ev, .Lfunc_end0-_ZN5TrillC2Ev
	.fnend

	.globl	_ZN5TrillC2Eii
	.p2align	2
	.type	_ZN5TrillC2Eii,%function
_ZN5TrillC2Eii:                         @ @_ZN5TrillC2Eii
	.fnstart
@ BB#0:
	.save	{r4, r10, r11, lr}
	push	{r4, r10, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r4, r0
	movw	r0, :lower16:_ZTV5Trill
	movt	r0, :upper16:_ZTV5Trill
	add	r0, r0, #8
	str	r0, [r4]
	movw	r0, #10000
	strh	r0, [r4, #80]
	mov	r0, r4
	bl	_ZN5Trill5setupEii
	mov	r0, r4
	pop	{r4, r10, r11, pc}
.Lfunc_end1:
	.size	_ZN5TrillC2Eii, .Lfunc_end1-_ZN5TrillC2Eii
	.fnend

	.globl	_ZN5Trill5setupEii
	.p2align	2
	.type	_ZN5Trill5setupEii,%function
_ZN5Trill5setupEii:                     @ @_ZN5Trill5setupEii
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	.pad	#8
	sub	sp, sp, #8
	mvn	r3, #0
	mov	r4, r0
	bl	_ZN3I2c10initI2C_RWEiii
	cmp	r0, #0
	bne	.LBB2_6
@ BB#1:
	mov	r0, #256
	add	r1, sp, #1
	strh	r0, [sp, #1]
	mov	r0, #3
	strb	r0, [sp, #3]
	mov	r2, #3
	ldr	r0, [r4, #12]
	bl	write
	cmp	r0, #3
	bne	.LBB2_7
@ BB#2:
	ldrh	r0, [r4, #80]
	bl	usleep
	mov	r0, #1536
	add	r1, sp, #4
	strh	r0, [sp, #4]
	mov	r2, #2
	ldr	r0, [r4, #12]
	bl	write
	cmp	r0, #2
	bne	.LBB2_8
@ BB#3:
	ldrh	r0, [r4, #80]
	bl	usleep
	mov	r5, #4
	add	r1, sp, #7
	strb	r5, [sp, #7]
	mov	r2, #1
	ldr	r0, [r4, #12]
	mov	r6, #1
	bl	write
	cmp	r0, #1
	bne	.LBB2_9
@ BB#4:
	ldrh	r0, [r4, #80]
	bl	usleep
	mov	r5, #0
	strb	r6, [r4, #16]
.LBB2_5:
	mov	r0, r5
	sub	sp, r11, #16
	pop	{r4, r5, r6, r10, r11, pc}
.LBB2_6:
	movw	r0, :lower16:stderr
	mov	r5, #1
	movt	r0, :upper16:stderr
	mov	r1, #39
	ldr	r3, [r0]
	movw	r0, :lower16:.L.str
	movt	r0, :upper16:.L.str
	b	.LBB2_10
.LBB2_7:
	movw	r4, :lower16:stderr
	movw	r0, :lower16:.L.str.5
	movt	r4, :upper16:stderr
	movt	r0, :upper16:.L.str.5
	ldr	r3, [r4]
	mov	r1, #28
	mov	r2, #1
	bl	fwrite
	ldr	r0, [r4]
	movw	r1, :lower16:.L.str.6
	movt	r1, :upper16:.L.str.6
	mov	r2, #1
	bl	fprintf
	ldr	r3, [r4]
	movw	r0, :lower16:.L.str.1
	movt	r0, :upper16:.L.str.1
	mov	r1, #19
	mov	r2, #1
	bl	fwrite
	mov	r5, #2
	b	.LBB2_5
.LBB2_8:
	movw	r4, :lower16:stderr
	movw	r0, :lower16:.L.str.11
	movt	r4, :upper16:stderr
	movt	r0, :upper16:.L.str.11
	ldr	r3, [r4]
	mov	r1, #32
	mov	r2, #1
	bl	fwrite
	ldr	r0, [r4]
	movw	r1, :lower16:.L.str.6
	movt	r1, :upper16:.L.str.6
	mov	r2, #1
	bl	fprintf
	ldr	r3, [r4]
	movw	r0, :lower16:.L.str.2
	movt	r0, :upper16:.L.str.2
	mov	r1, #26
	mov	r2, #1
	bl	fwrite
	mov	r5, #3
	b	.LBB2_5
.LBB2_9:
	movw	r4, :lower16:stderr
	movw	r0, :lower16:.L.str.12
	movt	r4, :upper16:stderr
	movt	r0, :upper16:.L.str.12
	ldr	r3, [r4]
	mov	r1, #40
	mov	r2, #1
	bl	fwrite
	movw	r0, :lower16:.L.str.3
	ldr	r3, [r4]
	movt	r0, :upper16:.L.str.3
	mov	r1, #35
.LBB2_10:
	mov	r2, #1
	bl	fwrite
	b	.LBB2_5
.Lfunc_end2:
	.size	_ZN5Trill5setupEii, .Lfunc_end2-_ZN5Trill5setupEii
	.fnend

	.section	.text._ZN3I2c10initI2C_RWEiii,"axG",%progbits,_ZN3I2c10initI2C_RWEiii,comdat
	.weak	_ZN3I2c10initI2C_RWEiii
	.p2align	2
	.type	_ZN3I2c10initI2C_RWEiii,%function
_ZN3I2c10initI2C_RWEiii:                @ @_ZN3I2c10initI2C_RWEiii
	.fnstart
@ BB#0:
	.save	{r4, r5, r6, r10, r11, lr}
	push	{r4, r5, r6, r10, r11, lr}
	.setfp	r11, sp, #16
	add	r11, sp, #16
	.pad	#64
	sub	sp, sp, #64
	mov	r5, r1
	mov	r4, r0
	str	r5, [r4, #4]
	mov	r6, sp
	str	r2, [r4, #8]
	movw	r2, :lower16:.L.str.14
	str	r3, [r4, #12]
	movt	r2, :upper16:.L.str.14
	mov	r0, r6
	mov	r1, #64
	mov	r3, r5
	bl	snprintf
	mov	r0, r6
	mov	r1, #2
	bl	open
	str	r0, [r4, #12]
	cmp	r0, #0
	blt	.LBB3_5
@ BB#1:
	ldr	r2, [r4, #8]
	movw	r1, #1795
	bl	ioctl
	mov	r1, r0
	mov	r0, #0
	cmp	r1, #0
	bge	.LBB3_12
@ BB#2:
	movw	r5, :lower16:_ZSt4cout
	movw	r1, :lower16:.L.str.17
	movt	r5, :upper16:_ZSt4cout
	movt	r1, :upper16:.L.str.17
	mov	r0, r5
	mov	r2, #18
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_i
	ldr	r1, [r4, #8]
	mov	r0, r5
	bl	_ZNSolsEi
	movw	r1, :lower16:.L.str.18
	mov	r2, #10
	movt	r1, :upper16:.L.str.18
	mov	r4, r0
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_i
	ldr	r0, [r4]
	ldr	r0, [r0, #-12]
	add	r0, r4, r0
	ldr	r5, [r0, #124]
	cmp	r5, #0
	beq	.LBB3_13
@ BB#3:                                 @ %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit6
	ldrb	r0, [r5, #28]
	cmp	r0, #0
	beq	.LBB3_10
@ BB#4:
	ldrb	r1, [r5, #39]
	b	.LBB3_11
.LBB3_5:
	movw	r4, :lower16:_ZSt4cout
	movw	r1, :lower16:.L.str.15
	movt	r4, :upper16:_ZSt4cout
	movt	r1, :upper16:.L.str.15
	mov	r0, r4
	mov	r2, #15
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_i
	mov	r5, sp
	mov	r0, r5
	bl	strlen
	mov	r2, r0
	mov	r0, r4
	mov	r1, r5
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_i
	movw	r1, :lower16:.L.str.16
	mov	r0, r4
	movt	r1, :upper16:.L.str.16
	mov	r2, #8
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_i
	ldr	r0, [r4]
	ldr	r0, [r0, #-12]
	add	r0, r4, r0
	ldr	r4, [r0, #124]
	cmp	r4, #0
	beq	.LBB3_13
@ BB#6:                                 @ %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit
	ldrb	r0, [r4, #28]
	cmp	r0, #0
	beq	.LBB3_8
@ BB#7:
	ldrb	r1, [r4, #39]
	b	.LBB3_9
.LBB3_8:
	mov	r0, r4
	bl	_ZNKSt5ctypeIcE13_M_widen_initEv
	ldr	r0, [r4]
	mov	r1, #10
	ldr	r2, [r0, #24]
	mov	r0, r4
	blx	r2
	mov	r1, r0
.LBB3_9:                                @ %_ZNKSt5ctypeIcE5widenEc.exit
	movw	r0, :lower16:_ZSt4cout
	movt	r0, :upper16:_ZSt4cout
	bl	_ZNSo3putEc
	bl	_ZNSo5flushEv
	mov	r0, #1
	sub	sp, r11, #16
	pop	{r4, r5, r6, r10, r11, pc}
.LBB3_10:
	mov	r0, r5
	bl	_ZNKSt5ctypeIcE13_M_widen_initEv
	ldr	r0, [r5]
	mov	r1, #10
	ldr	r2, [r0, #24]
	mov	r0, r5
	blx	r2
	mov	r1, r0
.LBB3_11:                               @ %_ZNKSt5ctypeIcE5widenEc.exit5
	mov	r0, r4
	bl	_ZNSo3putEc
	bl	_ZNSo5flushEv
	mov	r0, #2
.LBB3_12:
	sub	sp, r11, #16
	pop	{r4, r5, r6, r10, r11, pc}
.LBB3_13:
	mov	lr, pc
	b	_ZSt16__throw_bad_castv
.Lfunc_end3:
	.size	_ZN3I2c10initI2C_RWEiii, .Lfunc_end3-_ZN3I2c10initI2C_RWEiii
	.fnend

	.text
	.globl	_ZN5Trill7setModeEh
	.p2align	2
	.type	_ZN5Trill7setModeEh,%function
_ZN5Trill7setModeEh:                    @ @_ZN5Trill7setModeEh
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	.pad	#8
	sub	sp, sp, #8
	mov	r5, r0
	mov	r0, #0
	mov	r4, #1
	strb	r0, [sp, #5]
	strb	r4, [sp, #6]
	mov	r2, #3
	strb	r1, [sp, #7]
	add	r1, sp, #5
	ldr	r0, [r5, #12]
	bl	write
	cmp	r0, #3
	bne	.LBB4_3
@ BB#1:
	ldrh	r0, [r5, #80]
	bl	usleep
	mov	r4, #0
.LBB4_2:
	mov	r0, r4
	sub	sp, r11, #8
	pop	{r4, r5, r11, pc}
.LBB4_3:                                @ %.critedge
	movw	r5, :lower16:stderr
	movw	r0, :lower16:.L.str.5
	movt	r5, :upper16:stderr
	movt	r0, :upper16:.L.str.5
	ldr	r3, [r5]
	mov	r1, #28
	mov	r2, #1
	bl	fwrite
	ldr	r0, [r5]
	movw	r1, :lower16:.L.str.6
	movt	r1, :upper16:.L.str.6
	mov	r2, #1
	bl	fprintf
	b	.LBB4_2
.Lfunc_end4:
	.size	_ZN5Trill7setModeEh, .Lfunc_end4-_ZN5Trill7setModeEh
	.fnend

	.globl	_ZN5Trill14updateBaseLineEv
	.p2align	2
	.type	_ZN5Trill14updateBaseLineEv,%function
_ZN5Trill14updateBaseLineEv:            @ @_ZN5Trill14updateBaseLineEv
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	.pad	#8
	sub	sp, sp, #8
	mov	r4, r0
	mov	r0, #1536
	strh	r0, [sp, #6]
	add	r1, sp, #6
	ldr	r0, [r4, #12]
	mov	r2, #2
	bl	write
	cmp	r0, #2
	bne	.LBB5_3
@ BB#1:
	ldrh	r0, [r4, #80]
	bl	usleep
	mov	r4, #0
.LBB5_2:
	mov	r0, r4
	sub	sp, r11, #8
	pop	{r4, r5, r11, pc}
.LBB5_3:                                @ %.critedge
	movw	r5, :lower16:stderr
	movw	r0, :lower16:.L.str.11
	movt	r5, :upper16:stderr
	movt	r0, :upper16:.L.str.11
	ldr	r3, [r5]
	mov	r1, #32
	mov	r2, #1
	mov	r4, #1
	bl	fwrite
	ldr	r0, [r5]
	movw	r1, :lower16:.L.str.6
	movt	r1, :upper16:.L.str.6
	mov	r2, #1
	bl	fprintf
	b	.LBB5_2
.Lfunc_end5:
	.size	_ZN5Trill14updateBaseLineEv, .Lfunc_end5-_ZN5Trill14updateBaseLineEv
	.fnend

	.globl	_ZN5Trill18prepareForDataReadEv
	.p2align	2
	.type	_ZN5Trill18prepareForDataReadEv,%function
_ZN5Trill18prepareForDataReadEv:        @ @_ZN5Trill18prepareForDataReadEv
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	.pad	#8
	sub	sp, sp, #8
	mov	r5, r0
	mov	r0, #4
	strb	r0, [sp, #7]
	add	r1, sp, #7
	ldr	r0, [r5, #12]
	mov	r2, #1
	mov	r4, #1
	bl	write
	cmp	r0, #1
	bne	.LBB6_3
@ BB#1:
	ldrh	r0, [r5, #80]
	bl	usleep
	mov	r4, #0
.LBB6_2:
	mov	r0, r4
	sub	sp, r11, #8
	pop	{r4, r5, r11, pc}
.LBB6_3:
	movw	r0, :lower16:stderr
	mov	r1, #40
	movt	r0, :upper16:stderr
	mov	r2, #1
	ldr	r3, [r0]
	movw	r0, :lower16:.L.str.12
	movt	r0, :upper16:.L.str.12
	bl	fwrite
	b	.LBB6_2
.Lfunc_end6:
	.size	_ZN5Trill18prepareForDataReadEv, .Lfunc_end6-_ZN5Trill18prepareForDataReadEv
	.fnend

	.globl	_ZN5Trill7cleanupEv
	.p2align	2
	.type	_ZN5Trill7cleanupEv,%function
_ZN5Trill7cleanupEv:                    @ @_ZN5Trill7cleanupEv
	.fnstart
@ BB#0:
	b	_ZN3I2c8closeI2CEv
.Lfunc_end7:
	.size	_ZN5Trill7cleanupEv, .Lfunc_end7-_ZN5Trill7cleanupEv
	.fnend

	.section	.text._ZN3I2c8closeI2CEv,"axG",%progbits,_ZN3I2c8closeI2CEv,comdat
	.weak	_ZN3I2c8closeI2CEv
	.p2align	2
	.type	_ZN3I2c8closeI2CEv,%function
_ZN3I2c8closeI2CEv:                     @ @_ZN3I2c8closeI2CEv
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r4, r0
	ldr	r0, [r4, #12]
	bl	close
	mov	r1, r0
	mov	r0, #0
	cmp	r1, #1
	poplt	{r4, r5, r11, pc}
	movw	r5, :lower16:_ZSt4cout
	movw	r1, :lower16:.L.str.19
	movt	r5, :upper16:_ZSt4cout
	movt	r1, :upper16:.L.str.19
	mov	r0, r5
	mov	r2, #22
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_i
	ldr	r1, [r4, #12]
	mov	r0, r5
	bl	_ZNSolsEi
	mov	r4, r0
	ldr	r0, [r4]
	ldr	r0, [r0, #-12]
	add	r0, r4, r0
	ldr	r5, [r0, #124]
	cmp	r5, #0
	beq	.LBB8_5
@ BB#1:                                 @ %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit
	ldrb	r0, [r5, #28]
	cmp	r0, #0
	beq	.LBB8_3
@ BB#2:
	ldrb	r1, [r5, #39]
	b	.LBB8_4
.LBB8_3:
	mov	r0, r5
	bl	_ZNKSt5ctypeIcE13_M_widen_initEv
	ldr	r0, [r5]
	mov	r1, #10
	ldr	r2, [r0, #24]
	mov	r0, r5
	blx	r2
	mov	r1, r0
.LBB8_4:                                @ %_ZNKSt5ctypeIcE5widenEc.exit
	mov	r0, r4
	bl	_ZNSo3putEc
	bl	_ZNSo5flushEv
	mov	r0, #1
	pop	{r4, r5, r11, pc}
.LBB8_5:
	mov	lr, pc
	b	_ZSt16__throw_bad_castv
.Lfunc_end8:
	.size	_ZN3I2c8closeI2CEv, .Lfunc_end8-_ZN3I2c8closeI2CEv
	.fnend

	.text
	.globl	_ZN5TrillD2Ev
	.p2align	2
	.type	_ZN5TrillD2Ev,%function
_ZN5TrillD2Ev:                          @ @_ZN5TrillD2Ev
.Lfunc_begin0:
	.fnstart
@ BB#0:
	.save	{r4, r10, r11, lr}
	push	{r4, r10, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r4, r0
	movw	r0, :lower16:_ZTV5Trill
	movt	r0, :upper16:_ZTV5Trill
	add	r0, r0, #8
	str	r0, [r4]
.Ltmp0:
	mov	r0, r4
	bl	_ZN3I2c8closeI2CEv
.Ltmp1:
@ BB#1:                                 @ %_ZN5Trill7cleanupEv.exit
	mov	r0, r4
	pop	{r4, r10, r11, pc}
.LBB9_2:
.Ltmp2:
	mov	lr, pc
	b	__clang_call_terminate
.Lfunc_end9:
	.size	_ZN5TrillD2Ev, .Lfunc_end9-_ZN5TrillD2Ev
	.globl	__gxx_personality_v0
	.personality __gxx_personality_v0
	.handlerdata
	.p2align	2
GCC_except_table9:
.Lexception0:
	.byte	255                     @ @LPStart Encoding = omit
	.byte	0                       @ @TType Encoding = absptr
	.byte	21                      @ @TType base offset
	.byte	3                       @ Call site Encoding = udata4
	.byte	13                      @ Call site table length
	.long	.Ltmp0-.Lfunc_begin0    @ >> Call Site 1 <<
	.long	.Ltmp1-.Ltmp0           @   Call between .Ltmp0 and .Ltmp1
	.long	.Ltmp2-.Lfunc_begin0    @     jumps to .Ltmp2
	.byte	1                       @   On action: 1
	.byte	1                       @ >> Action Record 1 <<
                                        @   Catch TypeInfo 1
	.byte	0                       @   No further actions
                                        @ >> Catch TypeInfos <<
	.long	0                       @ TypeInfo 1
	.p2align	2
	.fnend

	.section	.text.__clang_call_terminate,"axG",%progbits,__clang_call_terminate,comdat
	.hidden	__clang_call_terminate
	.weak	__clang_call_terminate
	.p2align	2
	.type	__clang_call_terminate,%function
__clang_call_terminate:                 @ @__clang_call_terminate
	.fnstart
@ BB#0:
	.save	{r11, lr}
	push	{r11, lr}
	bl	__cxa_begin_catch
	mov	lr, pc
	b	_ZSt9terminatev
.Lfunc_end10:
	.size	__clang_call_terminate, .Lfunc_end10-__clang_call_terminate
	.cantunwind
	.fnend

	.text
	.globl	_ZN5TrillD0Ev
	.p2align	2
	.type	_ZN5TrillD0Ev,%function
_ZN5TrillD0Ev:                          @ @_ZN5TrillD0Ev
.Lfunc_begin1:
	.fnstart
@ BB#0:
	.save	{r4, r10, r11, lr}
	push	{r4, r10, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r4, r0
	movw	r0, :lower16:_ZTV5Trill
	movt	r0, :upper16:_ZTV5Trill
	add	r0, r0, #8
	str	r0, [r4]
.Ltmp3:
	mov	r0, r4
	bl	_ZN3I2c8closeI2CEv
.Ltmp4:
@ BB#1:                                 @ %_ZN5TrillD2Ev.exit
	mov	r0, r4
	pop	{r4, r10, r11, lr}
	b	_ZdlPv
.LBB11_2:
.Ltmp5:
	mov	lr, pc
	b	__clang_call_terminate
.Lfunc_end11:
	.size	_ZN5TrillD0Ev, .Lfunc_end11-_ZN5TrillD0Ev
	.globl	__gxx_personality_v0
	.personality __gxx_personality_v0
	.handlerdata
	.p2align	2
GCC_except_table11:
.Lexception1:
	.byte	255                     @ @LPStart Encoding = omit
	.byte	0                       @ @TType Encoding = absptr
	.byte	21                      @ @TType base offset
	.byte	3                       @ Call site Encoding = udata4
	.byte	13                      @ Call site table length
	.long	.Ltmp3-.Lfunc_begin1    @ >> Call Site 1 <<
	.long	.Ltmp4-.Ltmp3           @   Call between .Ltmp3 and .Ltmp4
	.long	.Ltmp5-.Lfunc_begin1    @     jumps to .Ltmp5
	.byte	1                       @   On action: 1
	.byte	1                       @ >> Action Record 1 <<
                                        @   Catch TypeInfo 1
	.byte	0                       @   No further actions
                                        @ >> Catch TypeInfos <<
	.long	0                       @ TypeInfo 1
	.p2align	2
	.fnend

	.globl	_ZN5Trill8identifyEv
	.p2align	2
	.type	_ZN5Trill8identifyEv,%function
_ZN5Trill8identifyEv:                   @ @_ZN5Trill8identifyEv
	.fnstart
@ BB#0:
	.save	{r4, r10, r11, lr}
	push	{r4, r10, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r4, r0
	add	r1, r4, #19
	ldr	r0, [r4, #12]
	mov	r2, #2
	bl	read
	cmp	r0, #2
	bne	.LBB12_3
@ BB#1:
	ldrb	r0, [r4, #19]
	ldrb	r1, [r4, #20]
.LBB12_2:
	strb	r0, [r4, #17]
	strb	r1, [r4, #18]
	pop	{r4, r10, r11, pc}
.LBB12_3:
	movw	r0, :lower16:stderr
	mov	r1, #55
	movt	r0, :upper16:stderr
	mov	r2, #1
	ldr	r3, [r0]
	movw	r0, :lower16:.L.str.4
	movt	r0, :upper16:.L.str.4
	bl	fwrite
	mov	r0, #0
	mov	r1, #0
	b	.LBB12_2
.Lfunc_end12:
	.size	_ZN5Trill8identifyEv, .Lfunc_end12-_ZN5Trill8identifyEv
	.fnend

	.globl	_ZN5Trill15setScanSettingsEhh
	.p2align	2
	.type	_ZN5Trill15setScanSettingsEhh,%function
_ZN5Trill15setScanSettingsEhh:          @ @_ZN5Trill15setScanSettingsEhh
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	.pad	#8
	sub	sp, sp, #8
	mov	r5, r0
	mov	r4, #0
	mov	r0, #2
	strb	r4, [sp, #4]
	strb	r0, [sp, #5]
	strb	r1, [sp, #6]
	add	r1, sp, #4
	strb	r2, [sp, #7]
	mov	r2, #4
	ldr	r0, [r5, #12]
	bl	write
	cmp	r0, #4
	bne	.LBB13_3
@ BB#1:
	ldrh	r0, [r5, #80]
	bl	usleep
.LBB13_2:
	mov	r0, r4
	sub	sp, r11, #8
	pop	{r4, r5, r11, pc}
.LBB13_3:                               @ %.critedge
	movw	r5, :lower16:stderr
	movw	r0, :lower16:.L.str.7
	movt	r5, :upper16:stderr
	movt	r0, :upper16:.L.str.7
	ldr	r3, [r5]
	mov	r1, #37
	mov	r2, #1
	mov	r4, #1
	bl	fwrite
	ldr	r0, [r5]
	movw	r1, :lower16:.L.str.6
	movt	r1, :upper16:.L.str.6
	mov	r2, #1
	bl	fprintf
	b	.LBB13_2
.Lfunc_end13:
	.size	_ZN5Trill15setScanSettingsEhh, .Lfunc_end13-_ZN5Trill15setScanSettingsEhh
	.fnend

	.globl	_ZN5Trill12setPrescalerEh
	.p2align	2
	.type	_ZN5Trill12setPrescalerEh,%function
_ZN5Trill12setPrescalerEh:              @ @_ZN5Trill12setPrescalerEh
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	.pad	#8
	sub	sp, sp, #8
	mov	r5, r0
	mov	r4, #0
	mov	r0, #3
	strb	r4, [sp, #5]
	strb	r0, [sp, #6]
	mov	r2, #3
	strb	r1, [sp, #7]
	add	r1, sp, #5
	ldr	r0, [r5, #12]
	bl	write
	cmp	r0, #3
	bne	.LBB14_3
@ BB#1:
	ldrh	r0, [r5, #80]
	bl	usleep
.LBB14_2:
	mov	r0, r4
	sub	sp, r11, #8
	pop	{r4, r5, r11, pc}
.LBB14_3:                               @ %.critedge
	movw	r5, :lower16:stderr
	movw	r0, :lower16:.L.str.8
	movt	r5, :upper16:stderr
	movt	r0, :upper16:.L.str.8
	ldr	r3, [r5]
	mov	r1, #33
	mov	r2, #1
	mov	r4, #1
	bl	fwrite
	ldr	r0, [r5]
	movw	r1, :lower16:.L.str.6
	movt	r1, :upper16:.L.str.6
	mov	r2, #1
	bl	fprintf
	b	.LBB14_2
.Lfunc_end14:
	.size	_ZN5Trill12setPrescalerEh, .Lfunc_end14-_ZN5Trill12setPrescalerEh
	.fnend

	.globl	_ZN5Trill17setNoiseThresholdEh
	.p2align	2
	.type	_ZN5Trill17setNoiseThresholdEh,%function
_ZN5Trill17setNoiseThresholdEh:         @ @_ZN5Trill17setNoiseThresholdEh
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	.pad	#8
	sub	sp, sp, #8
	mov	r5, r0
	mov	r4, #0
	mov	r0, #4
	strb	r4, [sp, #5]
	strb	r0, [sp, #6]
	mov	r2, #3
	strb	r1, [sp, #7]
	add	r1, sp, #5
	ldr	r0, [r5, #12]
	bl	write
	cmp	r0, #3
	bne	.LBB15_3
@ BB#1:
	ldrh	r0, [r5, #80]
	bl	usleep
.LBB15_2:
	mov	r0, r4
	sub	sp, r11, #8
	pop	{r4, r5, r11, pc}
.LBB15_3:                               @ %.critedge
	movw	r5, :lower16:stderr
	movw	r0, :lower16:.L.str.9
	movt	r5, :upper16:stderr
	movt	r0, :upper16:.L.str.9
	ldr	r3, [r5]
	mov	r1, #33
	mov	r2, #1
	mov	r4, #1
	bl	fwrite
	ldr	r0, [r5]
	movw	r1, :lower16:.L.str.6
	movt	r1, :upper16:.L.str.6
	mov	r2, #1
	bl	fprintf
	b	.LBB15_2
.Lfunc_end15:
	.size	_ZN5Trill17setNoiseThresholdEh, .Lfunc_end15-_ZN5Trill17setNoiseThresholdEh
	.fnend

	.globl	_ZN5Trill12setIDACValueEh
	.p2align	2
	.type	_ZN5Trill12setIDACValueEh,%function
_ZN5Trill12setIDACValueEh:              @ @_ZN5Trill12setIDACValueEh
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	.pad	#8
	sub	sp, sp, #8
	mov	r5, r0
	mov	r4, #0
	mov	r0, #5
	strb	r4, [sp, #5]
	strb	r0, [sp, #6]
	mov	r2, #3
	strb	r1, [sp, #7]
	add	r1, sp, #5
	ldr	r0, [r5, #12]
	bl	write
	cmp	r0, #3
	bne	.LBB16_3
@ BB#1:
	ldrh	r0, [r5, #80]
	bl	usleep
.LBB16_2:
	mov	r0, r4
	sub	sp, r11, #8
	pop	{r4, r5, r11, pc}
.LBB16_3:                               @ %.critedge
	movw	r5, :lower16:stderr
	movw	r0, :lower16:.L.str.10
	movt	r5, :upper16:stderr
	movt	r0, :upper16:.L.str.10
	ldr	r3, [r5]
	mov	r1, #34
	mov	r2, #1
	mov	r4, #1
	bl	fwrite
	ldr	r0, [r5]
	movw	r1, :lower16:.L.str.6
	movt	r1, :upper16:.L.str.6
	mov	r2, #1
	bl	fprintf
	b	.LBB16_2
.Lfunc_end16:
	.size	_ZN5Trill12setIDACValueEh, .Lfunc_end16-_ZN5Trill12setIDACValueEh
	.fnend

	.globl	_ZN5Trill7readI2CEv
	.p2align	2
	.type	_ZN5Trill7readI2CEv,%function
_ZN5Trill7readI2CEv:                    @ @_ZN5Trill7readI2CEv
	.fnstart
@ BB#0:
	.save	{r4, r5, r11, lr}
	push	{r4, r5, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	mov	r4, r0
	add	r1, r4, #19
	ldr	r0, [r4, #12]
	mov	r2, #60
	bl	read
	cmp	r0, #60
	bne	.LBB17_4
@ BB#1:                                 @ %.preheader.preheader
	mov	r5, #0
	mov	r0, #0
.LBB17_2:                               @ %.preheader
                                        @ =>This Inner Loop Header: Depth=1
	add	r1, r4, r0
	add	r3, r4, r0, lsl #1
	add	r0, r0, #2
	ldrb	r2, [r1, #19]
	cmp	r0, #52
	ldrb	r1, [r1, #20]
	bfi	r1, r2, #8, #4
	str	r1, [r3, #84]
	bne	.LBB17_2
@ BB#3:                                 @ %.loopexit
	mov	r0, r5
	pop	{r4, r5, r11, pc}
.LBB17_4:
	movw	r0, :lower16:stderr
	mov	r1, #28
	movt	r0, :upper16:stderr
	mov	r2, #1
	ldr	r3, [r0]
	movw	r0, :lower16:.L.str.13
	movt	r0, :upper16:.L.str.13
	mov	r5, #1
	bl	fwrite
	mov	r0, r5
	pop	{r4, r5, r11, pc}
.Lfunc_end17:
	.size	_ZN5Trill7readI2CEv, .Lfunc_end17-_ZN5Trill7readI2CEv
	.fnend

	.section	.text.startup,"ax",%progbits
	.p2align	2
	.type	_GLOBAL__sub_I_Trill.ii,%function
_GLOBAL__sub_I_Trill.ii:                @ @_GLOBAL__sub_I_Trill.ii
	.fnstart
@ BB#0:
	.save	{r4, r10, r11, lr}
	push	{r4, r10, r11, lr}
	.setfp	r11, sp, #8
	add	r11, sp, #8
	movw	r4, :lower16:_ZStL8__ioinit
	movt	r4, :upper16:_ZStL8__ioinit
	mov	r0, r4
	bl	_ZNSt8ios_base4InitC1Ev
	movw	r0, :lower16:_ZNSt8ios_base4InitD1Ev
	movw	r2, :lower16:__dso_handle
	movt	r0, :upper16:_ZNSt8ios_base4InitD1Ev
	movt	r2, :upper16:__dso_handle
	mov	r1, r4
	pop	{r4, r10, r11, lr}
	b	__cxa_atexit
.Lfunc_end18:
	.size	_GLOBAL__sub_I_Trill.ii, .Lfunc_end18-_GLOBAL__sub_I_Trill.ii
	.fnend

	.type	_ZStL8__ioinit,%object  @ @_ZStL8__ioinit
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.type	_ZTV5Trill,%object      @ @_ZTV5Trill
	.section	.rodata,"a",%progbits
	.globl	_ZTV5Trill
	.p2align	2
_ZTV5Trill:
	.long	0
	.long	_ZTI5Trill
	.long	_ZN5Trill7readI2CEv
	.long	_ZN5TrillD2Ev
	.long	_ZN5TrillD0Ev
	.size	_ZTV5Trill, 20

	.type	.L.str,%object          @ @.str
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str:
	.asciz	"Unable to initialise I2C communication\n"
	.size	.L.str, 40

	.type	.L.str.1,%object        @ @.str.1
.L.str.1:
	.asciz	"Unable to set mode\n"
	.size	.L.str.1, 20

	.type	.L.str.2,%object        @ @.str.2
.L.str.2:
	.asciz	"Unable to update baseline\n"
	.size	.L.str.2, 27

	.type	.L.str.3,%object        @ @.str.3
.L.str.3:
	.asciz	"Unable to prepare for reading data\n"
	.size	.L.str.3, 36

	.type	.L.str.4,%object        @ @.str.4
.L.str.4:
	.asciz	"Unexpected or no response.\n No valid device connected.\n"
	.size	.L.str.4, 56

	.type	.L.str.5,%object        @ @.str.5
.L.str.5:
	.asciz	"Failed to set Trill's mode.\n"
	.size	.L.str.5, 29

	.type	.L.str.6,%object        @ @.str.6
.L.str.6:
	.asciz	"%d\n"
	.size	.L.str.6, 4

	.type	.L.str.7,%object        @ @.str.7
.L.str.7:
	.asciz	"Failed to set Trill's scan settings.\n"
	.size	.L.str.7, 38

	.type	.L.str.8,%object        @ @.str.8
.L.str.8:
	.asciz	"Failed to set Trill's prescaler.\n"
	.size	.L.str.8, 34

	.type	.L.str.9,%object        @ @.str.9
.L.str.9:
	.asciz	"Failed to set Trill's threshold.\n"
	.size	.L.str.9, 34

	.type	.L.str.10,%object       @ @.str.10
.L.str.10:
	.asciz	"Failed to set Trill's IDAC value.\n"
	.size	.L.str.10, 35

	.type	.L.str.11,%object       @ @.str.11
.L.str.11:
	.asciz	"Failed to set Trill's baseline.\n"
	.size	.L.str.11, 33

	.type	.L.str.12,%object       @ @.str.12
.L.str.12:
	.asciz	"Failed to prepare Trill data collection\n"
	.size	.L.str.12, 41

	.type	.L.str.13,%object       @ @.str.13
.L.str.13:
	.asciz	"Failure to read Byte Stream\n"
	.size	.L.str.13, 29

	.type	_ZTS5Trill,%object      @ @_ZTS5Trill
	.section	.rodata,"a",%progbits
	.globl	_ZTS5Trill
_ZTS5Trill:
	.asciz	"5Trill"
	.size	_ZTS5Trill, 7

	.type	_ZTS3I2c,%object        @ @_ZTS3I2c
	.section	.rodata._ZTS3I2c,"aG",%progbits,_ZTS3I2c,comdat
	.weak	_ZTS3I2c
_ZTS3I2c:
	.asciz	"3I2c"
	.size	_ZTS3I2c, 5

	.type	_ZTI3I2c,%object        @ @_ZTI3I2c
	.section	.rodata._ZTI3I2c,"aG",%progbits,_ZTI3I2c,comdat
	.weak	_ZTI3I2c
	.p2align	2
_ZTI3I2c:
	.long	_ZTVN10__cxxabiv117__class_type_infoE+8
	.long	_ZTS3I2c
	.size	_ZTI3I2c, 8

	.type	_ZTI5Trill,%object      @ @_ZTI5Trill
	.section	.rodata,"a",%progbits
	.globl	_ZTI5Trill
	.p2align	2
_ZTI5Trill:
	.long	_ZTVN10__cxxabiv120__si_class_type_infoE+8
	.long	_ZTS5Trill
	.long	_ZTI3I2c
	.size	_ZTI5Trill, 12

	.type	.L.str.14,%object       @ @.str.14
	.section	.rodata.str1.1,"aMS",%progbits,1
.L.str.14:
	.asciz	"/dev/i2c-%d"
	.size	.L.str.14, 12

	.type	.L.str.15,%object       @ @.str.15
.L.str.15:
	.asciz	"Failed to open "
	.size	.L.str.15, 16

	.type	.L.str.16,%object       @ @.str.16
.L.str.16:
	.asciz	" I2C Bus"
	.size	.L.str.16, 9

	.type	.L.str.17,%object       @ @.str.17
.L.str.17:
	.asciz	"I2C_SLAVE address "
	.size	.L.str.17, 19

	.type	.L.str.18,%object       @ @.str.18
.L.str.18:
	.asciz	" failed..."
	.size	.L.str.18, 11

	.type	.L.str.19,%object       @ @.str.19
.L.str.19:
	.asciz	"Failed to close  file "
	.size	.L.str.19, 23

	.section	.init_array,"aw",%init_array
	.p2align	2
	.long	_GLOBAL__sub_I_Trill.ii(target1)

	.globl	_ZN5TrillC1Ev
	.type	_ZN5TrillC1Ev,%function
_ZN5TrillC1Ev = _ZN5TrillC2Ev
	.globl	_ZN5TrillC1Eii
	.type	_ZN5TrillC1Eii,%function
_ZN5TrillC1Eii = _ZN5TrillC2Eii
	.globl	_ZN5TrillD1Ev
	.type	_ZN5TrillD1Ev,%function
_ZN5TrillD1Ev = _ZN5TrillD2Ev
	.ident	"clang version 3.9.1-9 (tags/RELEASE_391/rc2)"
	.section	".note.GNU-stack","",%progbits
	.eabi_attribute	30, 2	@ Tag_ABI_optimization_goals
