	.file	"program.c"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$992, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -976(%rbp)
	movl	$1, -736(%rbp)
	movl	$1, -980(%rbp)
	jmp	.L2
.L3:
	movl	-980(%rbp), %eax
	subl	$1, %eax
	cltq
	movl	-976(%rbp,%rax,4), %edx
	movl	-980(%rbp), %eax
	addl	%eax, %edx
	movl	-980(%rbp), %eax
	cltq
	movl	%edx, -976(%rbp,%rax,4)
	movl	-980(%rbp), %eax
	subl	$1, %eax
	cltq
	movl	-736(%rbp,%rax,4), %ecx
	movl	-980(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	leal	(%rcx,%rax), %edx
	movl	-980(%rbp), %eax
	cltq
	movl	%edx, -736(%rbp,%rax,4)
	addl	$1, -980(%rbp)
.L2:
	cmpl	$19, -980(%rbp)
	jle	.L3
	movl	$20, -980(%rbp)
	jmp	.L4
.L5:
	movl	-980(%rbp), %eax
	cltq
	movl	-976(%rbp,%rax,4), %edx
	movl	-980(%rbp), %eax
	cltq
	movl	-736(%rbp,%rax,4), %eax
	addl	%eax, %edx
	movl	-980(%rbp), %eax
	cltq
	movl	%edx, -496(%rbp,%rax,4)
	addl	$1, -980(%rbp)
.L4:
	cmpl	$39, -980(%rbp)
	jle	.L5
	movl	$40, -980(%rbp)
	jmp	.L6
.L7:
	movl	-980(%rbp), %eax
	cltq
	movl	-976(%rbp,%rax,4), %edx
	movl	-980(%rbp), %eax
	cltq
	movl	-736(%rbp,%rax,4), %eax
	imull	%eax, %edx
	movl	-980(%rbp), %eax
	cltq
	movl	%edx, -256(%rbp,%rax,4)
	addl	$1, -980(%rbp)
.L6:
	cmpl	$59, -980(%rbp)
	jle	.L7
	movl	$0, -980(%rbp)
	jmp	.L8
.L9:
	movl	-980(%rbp), %eax
	cltq
	movl	-736(%rbp,%rax,4), %edx
	movl	-980(%rbp), %eax
	cltq
	movl	%edx, -736(%rbp,%rax,4)
	addl	$1, -980(%rbp)
.L8:
	cmpl	$19, -980(%rbp)
	jle	.L9
	movl	$20, -980(%rbp)
	jmp	.L10
.L11:
	movl	-980(%rbp), %eax
	cltq
	movl	-976(%rbp,%rax,4), %edx
	movl	-980(%rbp), %eax
	cltq
	movl	-496(%rbp,%rax,4), %eax
	imull	%eax, %edx
	movl	-980(%rbp), %eax
	cltq
	movl	%edx, -256(%rbp,%rax,4)
	addl	$1, -980(%rbp)
.L10:
	cmpl	$39, -980(%rbp)
	jle	.L11
	movl	$40, -980(%rbp)
	jmp	.L12
.L13:
	movl	-980(%rbp), %eax
	cltq
	movl	-496(%rbp,%rax,4), %edx
	movl	-980(%rbp), %eax
	cltq
	movl	-736(%rbp,%rax,4), %eax
	imull	%eax, %edx
	movl	-980(%rbp), %eax
	cltq
	movl	%edx, -256(%rbp,%rax,4)
	addl	$1, -980(%rbp)
.L12:
	cmpl	$59, -980(%rbp)
	jle	.L13
	movl	$0, %eax
	movq	-8(%rbp), %rsi
	xorq	%fs:40, %rsi
	je	.L15
	call	__stack_chk_fail@PLT
.L15:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
