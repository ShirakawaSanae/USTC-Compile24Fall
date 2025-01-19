# Global variables
	.text
	.section .bss, "aw", @nobits
	.globl seed
	.type seed, @object
	.size seed, 4
seed:
	.space 4
	.text
	.globl randomLCG
	.type randomLCG, @function
randomLCG:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -32
.randomLCG_label_entry:
# %op0 = load i32, i32* @seed
	la.local $t0, seed
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -20
# %op1 = mul i32 %op0, 1103515245
	ld.w $t0, $fp, -20
	lu12i.w $t1, 269412
	ori $t1, $t1, 3693
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -24
# %op2 = add i32 %op1, 12345
	ld.w $t0, $fp, -24
	lu12i.w $t1, 3
	ori $t1, $t1, 57
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -28
# store i32 %op2, i32* @seed
	la.local $t0, seed
	ld.w $t1, $fp, -28
	st.w $t1, $t0, 0
# %op3 = load i32, i32* @seed
	la.local $t0, seed
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -32
# ret i32 %op3
	ld.w $a0, $fp, -32
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl randBin
	.type randBin, @function
randBin:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -32
.randBin_label_entry:
# %op0 = call i32 @randomLCG()
	bl randomLCG
	st.w $a0, $fp, -20
# %op1 = icmp sgt i32 %op0, 0
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	st.b $t2, $fp, -21
# %op2 = zext i1 %op1 to i32
	ld.b $t0, $fp, -21
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -25
# %op3 = icmp ne i32 %op2, 0
	ld.w $t0, $fp, -25
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -26
# br i1 %op3, label %label4, label %label5
	ld.b $t0, $fp, -26
	bnez $t0, .randBin_label4
	beqz $t0, .randBin_label5
.randBin_label4:
# ret i32 1
	addi.w $a0, $zero, 1
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.randBin_label5:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl returnToZeroSteps
	.type returnToZeroSteps, @function
returnToZeroSteps:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -64
.returnToZeroSteps_label_entry:
# br label %label2
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -20
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -24
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -20
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -24
	b .returnToZeroSteps_label2
.returnToZeroSteps_label2:
# %op27 = phi i32 [ 0, %label_entry ], [ %op19, %label26 ]
# %op28 = phi i32 [ 0, %label_entry ], [ %op29, %label26 ]
# %op4 = icmp slt i32 %op27, 20
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 20
	slt $t2, $t0, $t1
	st.b $t2, $fp, -25
# %op5 = zext i1 %op4 to i32
	ld.b $t0, $fp, -25
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -29
# %op6 = icmp ne i32 %op5, 0
	ld.w $t0, $fp, -29
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -30
# br i1 %op6, label %label7, label %label10
	ld.b $t0, $fp, -30
	bnez $t0, .returnToZeroSteps_label7
	beqz $t0, .returnToZeroSteps_label10
.returnToZeroSteps_label7:
# %op8 = call i32 @randBin()
	bl randBin
	st.w $a0, $fp, -34
# %op9 = icmp ne i32 %op8, 0
	ld.w $t0, $fp, -34
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -35
# br i1 %op9, label %label11, label %label14
	ld.b $t0, $fp, -35
	bnez $t0, .returnToZeroSteps_label11
	beqz $t0, .returnToZeroSteps_label14
.returnToZeroSteps_label10:
# ret i32 20
	addi.w $a0, $zero, 20
	addi.d $sp, $sp, 64
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.returnToZeroSteps_label11:
# %op13 = add i32 %op28, 1
	ld.w $t0, $fp, -24
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -39
# br label %label17
	ld.w $a0, $fp, -39
	st.w $a0, $fp, -47
	ld.w $a0, $fp, -39
	st.w $a0, $fp, -47
	b .returnToZeroSteps_label17
.returnToZeroSteps_label14:
# %op16 = sub i32 %op28, 1
	ld.w $t0, $fp, -24
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -43
# br label %label17
	ld.w $a0, $fp, -43
	st.w $a0, $fp, -47
	ld.w $a0, $fp, -43
	st.w $a0, $fp, -47
	b .returnToZeroSteps_label17
.returnToZeroSteps_label17:
# %op29 = phi i32 [ %op13, %label11 ], [ %op16, %label14 ]
# %op19 = add i32 %op27, 1
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -51
# %op21 = icmp eq i32 %op29, 0
	ld.w $t0, $fp, -47
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	xori $t2, $t2, 1
	st.b $t2, $fp, -52
# %op22 = zext i1 %op21 to i32
	ld.b $t0, $fp, -52
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -56
# %op23 = icmp ne i32 %op22, 0
	ld.w $t0, $fp, -56
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -57
# br i1 %op23, label %label24, label %label26
	ld.b $t0, $fp, -57
	bnez $t0, .returnToZeroSteps_label24
	beqz $t0, .returnToZeroSteps_label26
.returnToZeroSteps_label24:
# ret i32 %op19
	ld.w $a0, $fp, -51
	addi.d $sp, $sp, 64
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.returnToZeroSteps_label26:
# br label %label2
	ld.w $a0, $fp, -51
	st.w $a0, $fp, -20
	ld.w $a0, $fp, -47
	st.w $a0, $fp, -24
	ld.w $a0, $fp, -51
	st.w $a0, $fp, -20
	ld.w $a0, $fp, -47
	st.w $a0, $fp, -24
	b .returnToZeroSteps_label2
	addi.d $sp, $sp, 64
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -48
.main_label_entry:
# store i32 3407, i32* @seed
	la.local $t0, seed
	lu12i.w $t1, 0
	ori $t1, $t1, 3407
	st.w $t1, $t0, 0
# br label %label1
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -20
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -20
	b .main_label1
.main_label1:
# %op11 = phi i32 [ 0, %label_entry ], [ %op9, %label6 ]
# %op3 = icmp slt i32 %op11, 20
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 20
	slt $t2, $t0, $t1
	st.b $t2, $fp, -21
# %op4 = zext i1 %op3 to i32
	ld.b $t0, $fp, -21
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -25
# %op5 = icmp ne i32 %op4, 0
	ld.w $t0, $fp, -25
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -26
# br i1 %op5, label %label6, label %label10
	ld.b $t0, $fp, -26
	bnez $t0, .main_label6
	beqz $t0, .main_label10
.main_label6:
# %op7 = call i32 @returnToZeroSteps()
	bl returnToZeroSteps
	st.w $a0, $fp, -30
# call void @output(i32 %op7)
	ld.w $a0, $fp, -30
	bl output
# %op9 = add i32 %op11, 1
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -34
# br label %label1
	ld.w $a0, $fp, -34
	st.w $a0, $fp, -20
	ld.w $a0, $fp, -34
	st.w $a0, $fp, -20
	b .main_label1
.main_label10:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 48
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 48
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
