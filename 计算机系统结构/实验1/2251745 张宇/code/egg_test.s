	.file	1 "1.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	fp=xx
	.module	nooddspreg
	.abicalls
	.text
	.align	2
	.globl	calculate_cost
	.set	nomips16
	.set	nomicromips
	.ent	calculate_cost
	.type	calculate_cost, @function
calculate_cost:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-8
	sw	$fp,4($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	sw	$5,12($fp)
	sw	$6,16($fp)
	sw	$7,20($fp)
	lw	$3,8($fp)
	lw	$2,20($fp)
	mul	$3,$3,$2
	lw	$4,12($fp)
	lw	$2,24($fp)
	mul	$2,$4,$2
	addu	$3,$3,$2
	lw	$4,16($fp)
	lw	$2,28($fp)
	mul	$2,$4,$2
	addu	$2,$3,$2
	move	$sp,$fp
	lw	$fp,4($sp)
	addiu	$sp,$sp,8
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	calculate_cost
	.size	calculate_cost, .-calculate_cost
	.rdata
	.align	2
$LC0:
	.ascii	"\350\257\267\350\276\223\345\205\245\346\257\224\350\220"
	.ascii	"\250\345\241\224\347\232\204\346\200\273\346\245\274\345"
	.ascii	"\261\202\346\225\260\357\274\232\000"
	.align	2
$LC1:
	.ascii	"%d\000"
	.align	2
$LC2:
	.ascii	"\350\257\267\350\276\223\345\205\245\351\270\241\350\233"
	.ascii	"\213\347\232\204\350\200\220\346\221\224\345\200\274\346"
	.ascii	"\245\274\345\261\202\357\274\210\345\234\250\350\257\245"
	.ascii	"\346\245\274\345\261\202\345\217\212\344\273\245\344\270"
	.ascii	"\213\344\270\215\346\221\224\347\240\264\357\274\211\357"
	.ascii	"\274\232\000"
	.align	2
$LC3:
	.ascii	"\346\221\224\347\240\264\000"
	.align	2
$LC4:
	.ascii	"\346\262\241\347\240\264\000"
	.align	2
$LC5:
	.ascii	"\347\254\254 %d \346\254\241\345\260\235\350\257\225\357"
	.ascii	"\274\232\345\234\250\347\254\254 %d \345\261\202\346\211"
	.ascii	"\224\351\270\241\350\233\213\357\274\214\351\270\241\350"
	.ascii	"\233\213%s\012\000"
	.align	2
$LC6:
	.ascii	"\346\200\273\345\260\235\350\257\225\346\254\241\346\225"
	.ascii	"\260\357\274\232%d\012\000"
	.align	2
$LC7:
	.ascii	"\346\221\224\347\240\264\347\232\204\351\270\241\350\233"
	.ascii	"\213\346\225\260\357\274\232%d\012\000"
	.align	2
$LC8:
	.ascii	"\346\234\200\345\220\216\344\270\200\346\254\241\351\270"
	.ascii	"\241\350\233\213%s\012\000"
	.align	2
$LC9:
	.ascii	"\012\345\234\250\347\211\251\350\264\250\345\214\256\344"
	.ascii	"\271\217\346\227\266\346\234\237\347\232\204\346\200\273"
	.ascii	"\346\210\220\346\234\254\357\274\232%d\012\000"
	.align	2
$LC10:
	.ascii	"\345\234\250\344\272\272\345\212\233\346\210\220\346\234"
	.ascii	"\254\345\242\236\351\225\277\346\227\266\346\234\237\347"
	.ascii	"\232\204\346\200\273\346\210\220\346\234\254\357\274\232"
	.ascii	"%d\012\000"
	.text
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$fp,96,$31		# vars= 56, regs= 2/0, args= 24, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-96
	sw	$31,92($sp)
	sw	$fp,88($sp)
	move	$fp,$sp
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	24
	lw	$2,%got(__stack_chk_guard)($28)
	lw	$2,0($2)
	sw	$2,84($fp)
	lui	$2,%hi($LC0)
	addiu	$4,$2,%lo($LC0)
	lw	$2,%call16(printf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	addiu	$2,$fp,32
	move	$5,$2
	lui	$2,%hi($LC1)
	addiu	$4,$2,%lo($LC1)
	lw	$2,%call16(__isoc99_scanf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,__isoc99_scanf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	lui	$2,%hi($LC2)
	addiu	$4,$2,%lo($LC2)
	lw	$2,%call16(printf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	addiu	$2,$fp,36
	move	$5,$2
	lui	$2,%hi($LC1)
	addiu	$4,$2,%lo($LC1)
	lw	$2,%call16(__isoc99_scanf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,__isoc99_scanf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	sw	$0,40($fp)
	sw	$0,44($fp)
	sw	$0,48($fp)
	li	$2,1			# 0x1
	sw	$2,52($fp)
	lw	$2,32($fp)
	sw	$2,56($fp)
	.option	pic0
	b	$L4
	nop

	.option	pic2
$L9:
	lw	$2,40($fp)
	addiu	$2,$2,1
	sw	$2,40($fp)
	lw	$3,52($fp)
	lw	$2,56($fp)
	addu	$2,$3,$2
	addiu	$2,$2,1
	srl	$3,$2,31
	addu	$2,$3,$2
	sra	$2,$2,1
	sw	$2,80($fp)
	lw	$2,36($fp)
	lw	$3,80($fp)
	slt	$2,$2,$3
	beq	$2,$0,$L5
	nop

	lw	$2,44($fp)
	addiu	$2,$2,1
	sw	$2,44($fp)
	li	$2,1			# 0x1
	sw	$2,48($fp)
	lw	$2,80($fp)
	addiu	$2,$2,-1
	sw	$2,56($fp)
	.option	pic0
	b	$L6
	nop

	.option	pic2
$L5:
	sw	$0,48($fp)
	lw	$2,80($fp)
	sw	$2,52($fp)
$L6:
	lw	$2,48($fp)
	beq	$2,$0,$L7
	nop

	lui	$2,%hi($LC3)
	addiu	$2,$2,%lo($LC3)
	.option	pic0
	b	$L8
	nop

	.option	pic2
$L7:
	lui	$2,%hi($LC4)
	addiu	$2,$2,%lo($LC4)
$L8:
	move	$7,$2
	lw	$6,80($fp)
	lw	$5,40($fp)
	lui	$2,%hi($LC5)
	addiu	$4,$2,%lo($LC5)
	lw	$2,%call16(printf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,24($fp)
$L4:
	lw	$3,52($fp)
	lw	$2,56($fp)
	slt	$2,$3,$2
	bne	$2,$0,$L9
	nop

	lw	$2,36($fp)
	sw	$2,60($fp)
	lw	$3,32($fp)
	lw	$2,36($fp)
	subu	$2,$3,$2
	sw	$2,64($fp)
	lw	$2,44($fp)
	sw	$2,68($fp)
	li	$2,4			# 0x4
	sw	$2,20($sp)
	li	$2,1			# 0x1
	sw	$2,16($sp)
	li	$7,2			# 0x2
	lw	$6,68($fp)
	lw	$5,64($fp)
	lw	$4,60($fp)
	.option	pic0
	jal	calculate_cost
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,72($fp)
	li	$2,2			# 0x2
	sw	$2,20($sp)
	li	$2,1			# 0x1
	sw	$2,16($sp)
	li	$7,4			# 0x4
	lw	$6,68($fp)
	lw	$5,64($fp)
	lw	$4,60($fp)
	.option	pic0
	jal	calculate_cost
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,76($fp)
	lw	$5,40($fp)
	lui	$2,%hi($LC6)
	addiu	$4,$2,%lo($LC6)
	lw	$2,%call16(printf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	lw	$5,44($fp)
	lui	$2,%hi($LC7)
	addiu	$4,$2,%lo($LC7)
	lw	$2,%call16(printf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	lw	$2,48($fp)
	beq	$2,$0,$L10
	nop

	lui	$2,%hi($LC3)
	addiu	$2,$2,%lo($LC3)
	.option	pic0
	b	$L11
	nop

	.option	pic2
$L10:
	lui	$2,%hi($LC4)
	addiu	$2,$2,%lo($LC4)
$L11:
	move	$5,$2
	lui	$2,%hi($LC8)
	addiu	$4,$2,%lo($LC8)
	lw	$2,%call16(printf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	lw	$5,72($fp)
	lui	$2,%hi($LC9)
	addiu	$4,$2,%lo($LC9)
	lw	$2,%call16(printf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	lw	$5,76($fp)
	lui	$2,%hi($LC10)
	addiu	$4,$2,%lo($LC10)
	lw	$2,%call16(printf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	move	$2,$0
	move	$4,$2
	lw	$2,%got(__stack_chk_guard)($28)
	lw	$3,84($fp)
	lw	$2,0($2)
	beq	$3,$2,$L13
	nop

	lw	$2,%call16(__stack_chk_fail)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,__stack_chk_fail
1:	jalr	$25
	nop

$L13:
	move	$2,$4
	move	$sp,$fp
	lw	$31,92($sp)
	lw	$fp,88($sp)
	addiu	$sp,$sp,96
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04) 9.4.0"
