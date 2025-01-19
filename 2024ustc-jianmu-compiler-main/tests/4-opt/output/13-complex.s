# Global variables
	.text
	.section .bss, "aw", @nobits
	.globl n
	.type n, @object
	.size n, 4
n:
	.space 4
	.globl m
	.type m, @object
	.size m, 4
m:
	.space 4
	.globl w
	.type w, @object
	.size w, 20
w:
	.space 20
	.globl v
	.type v, @object
	.size v, 20
v:
	.space 20
	.globl dp
	.type dp, @object
	.size dp, 264
dp:
	.space 264
	.text
	.globl max
	.type max, @function
max:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -32
	st.w $a0, $fp, -20
	st.w $a1, $fp, -24
.max_label_entry:
# %op6 = icmp sgt i32 %arg0, %arg1
	ld.w $t0, $fp, -20
	ld.w $t1, $fp, -24
	slt $t2, $t1, $t0
	st.b $t2, $fp, -25
# %op7 = zext i1 %op6 to i32
	ld.b $t0, $fp, -25
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -29
# %op8 = icmp ne i32 %op7, 0
	ld.w $t0, $fp, -29
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -30
# br i1 %op8, label %label9, label %label11
	ld.b $t0, $fp, -30
	bnez $t0, .max_label9
	beqz $t0, .max_label11
.max_label9:
# ret i32 %arg0
	ld.w $a0, $fp, -20
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.max_label11:
# ret i32 %arg1
	ld.w $a0, $fp, -24
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl knapsack
	.type knapsack, @function
knapsack:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -208
	st.w $a0, $fp, -20
	st.w $a1, $fp, -24
.knapsack_label_entry:
# %op6 = icmp sle i32 %arg1, 0
	ld.w $t0, $fp, -24
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	xori $t2, $t2, 1
	st.b $t2, $fp, -25
# %op7 = zext i1 %op6 to i32
	ld.b $t0, $fp, -25
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -29
# %op8 = icmp ne i32 %op7, 0
	ld.w $t0, $fp, -29
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -30
# br i1 %op8, label %label9, label %label10
	ld.b $t0, $fp, -30
	bnez $t0, .knapsack_label9
	beqz $t0, .knapsack_label10
.knapsack_label9:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 208
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label10:
# %op12 = icmp eq i32 %arg0, 0
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	xori $t2, $t2, 1
	st.b $t2, $fp, -31
# %op13 = zext i1 %op12 to i32
	ld.b $t0, $fp, -31
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -35
# %op14 = icmp ne i32 %op13, 0
	ld.w $t0, $fp, -35
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -36
# br i1 %op14, label %label15, label %label16
	ld.b $t0, $fp, -36
	bnez $t0, .knapsack_label15
	beqz $t0, .knapsack_label16
.knapsack_label15:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 208
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label16:
# %op18 = mul i32 %arg0, 11
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 11
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -40
# %op20 = add i32 %op18, %arg1
	ld.w $t0, $fp, -40
	ld.w $t1, $fp, -24
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -44
# %op21 = icmp slt i32 %op20, 0
	ld.w $t0, $fp, -44
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -45
# br i1 %op21, label %label22, label %label23
	ld.b $t0, $fp, -45
	bnez $t0, .knapsack_label22
	beqz $t0, .knapsack_label23
.knapsack_label22:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 208
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label23:
# %op24 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op20
	la.local $t0, dp
	ld.w $t2, $fp, -44
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -53
# %op25 = load i32, i32* %op24
	ld.d $t0, $fp, -53
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -57
# %op26 = icmp sge i32 %op25, 0
	ld.w $t0, $fp, -57
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	xori $t2, $t2, 1
	st.b $t2, $fp, -58
# %op27 = zext i1 %op26 to i32
	ld.b $t0, $fp, -58
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -62
# %op28 = icmp ne i32 %op27, 0
	ld.w $t0, $fp, -62
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -63
# br i1 %op28, label %label29, label %label35
	ld.b $t0, $fp, -63
	bnez $t0, .knapsack_label29
	beqz $t0, .knapsack_label35
.knapsack_label29:
# %op31 = mul i32 %arg0, 11
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 11
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -67
# %op33 = add i32 %op31, %arg1
	ld.w $t0, $fp, -67
	ld.w $t1, $fp, -24
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -71
# %op34 = icmp slt i32 %op33, 0
	ld.w $t0, $fp, -71
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -72
# br i1 %op34, label %label40, label %label41
	ld.b $t0, $fp, -72
	bnez $t0, .knapsack_label40
	beqz $t0, .knapsack_label41
.knapsack_label35:
# %op38 = sub i32 %arg0, 1
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -76
# %op39 = icmp slt i32 %op38, 0
	ld.w $t0, $fp, -76
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -77
# br i1 %op39, label %label44, label %label45
	ld.b $t0, $fp, -77
	bnez $t0, .knapsack_label44
	beqz $t0, .knapsack_label45
.knapsack_label40:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 208
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label41:
# %op42 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op33
	la.local $t0, dp
	ld.w $t2, $fp, -71
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -85
# %op43 = load i32, i32* %op42
	ld.d $t0, $fp, -85
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -89
# ret i32 %op43
	ld.w $a0, $fp, -89
	addi.d $sp, $sp, 208
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label44:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 208
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label45:
# %op46 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 %op38
	la.local $t0, w
	ld.w $t2, $fp, -76
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -97
# %op47 = load i32, i32* %op46
	ld.d $t0, $fp, -97
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -101
# %op48 = icmp slt i32 %arg1, %op47
	ld.w $t0, $fp, -24
	ld.w $t1, $fp, -101
	slt $t2, $t0, $t1
	st.b $t2, $fp, -102
# %op49 = zext i1 %op48 to i32
	ld.b $t0, $fp, -102
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -106
# %op50 = icmp ne i32 %op49, 0
	ld.w $t0, $fp, -106
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -107
# br i1 %op50, label %label51, label %label56
	ld.b $t0, $fp, -107
	bnez $t0, .knapsack_label51
	beqz $t0, .knapsack_label56
.knapsack_label51:
# %op53 = sub i32 %arg0, 1
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -111
# %op55 = call i32 @knapsack(i32 %op53, i32 %arg1)
	ld.w $a0, $fp, -111
	ld.w $a1, $fp, -24
	bl knapsack
	st.w $a0, $fp, -115
# br label %label67
	ld.w $a0, $fp, -115
	st.w $a0, $fp, -136
	ld.w $a0, $fp, -115
	st.w $a0, $fp, -136
	b .knapsack_label67
.knapsack_label56:
# %op58 = sub i32 %arg0, 1
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -119
# %op60 = call i32 @knapsack(i32 %op58, i32 %arg1)
	ld.w $a0, $fp, -119
	ld.w $a1, $fp, -24
	bl knapsack
	st.w $a0, $fp, -123
# %op62 = sub i32 %arg0, 1
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -127
# %op65 = sub i32 %arg0, 1
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -131
# %op66 = icmp slt i32 %op65, 0
	ld.w $t0, $fp, -131
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -132
# br i1 %op66, label %label74, label %label75
	ld.b $t0, $fp, -132
	bnez $t0, .knapsack_label74
	beqz $t0, .knapsack_label75
.knapsack_label67:
# %op93 = phi i32 [ %op55, %label51 ], [ %op88, %label84 ]
# %op70 = mul i32 %arg0, 11
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 11
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -140
# %op72 = add i32 %op70, %arg1
	ld.w $t0, $fp, -140
	ld.w $t1, $fp, -24
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -144
# %op73 = icmp slt i32 %op72, 0
	ld.w $t0, $fp, -144
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -145
# br i1 %op73, label %label89, label %label90
	ld.b $t0, $fp, -145
	bnez $t0, .knapsack_label89
	beqz $t0, .knapsack_label90
.knapsack_label74:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 208
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label75:
# %op76 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 %op65
	la.local $t0, w
	ld.w $t2, $fp, -131
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -153
# %op77 = load i32, i32* %op76
	ld.d $t0, $fp, -153
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -157
# %op78 = sub i32 %arg1, %op77
	ld.w $t0, $fp, -24
	ld.w $t1, $fp, -157
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -161
# %op79 = call i32 @knapsack(i32 %op62, i32 %op78)
	ld.w $a0, $fp, -127
	ld.w $a1, $fp, -161
	bl knapsack
	st.w $a0, $fp, -165
# %op81 = sub i32 %arg0, 1
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -169
# %op82 = icmp slt i32 %op81, 0
	ld.w $t0, $fp, -169
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -170
# br i1 %op82, label %label83, label %label84
	ld.b $t0, $fp, -170
	bnez $t0, .knapsack_label83
	beqz $t0, .knapsack_label84
.knapsack_label83:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 208
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label84:
# %op85 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 %op81
	la.local $t0, v
	ld.w $t2, $fp, -169
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -178
# %op86 = load i32, i32* %op85
	ld.d $t0, $fp, -178
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -182
# %op87 = add i32 %op79, %op86
	ld.w $t0, $fp, -165
	ld.w $t1, $fp, -182
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -186
# %op88 = call i32 @max(i32 %op60, i32 %op87)
	ld.w $a0, $fp, -123
	ld.w $a1, $fp, -186
	bl max
	st.w $a0, $fp, -190
# br label %label67
	ld.w $a0, $fp, -190
	st.w $a0, $fp, -136
	ld.w $a0, $fp, -190
	st.w $a0, $fp, -136
	b .knapsack_label67
.knapsack_label89:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 208
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label90:
# %op91 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op72
	la.local $t0, dp
	ld.w $t2, $fp, -144
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -198
# store i32 %op93, i32* %op91
	ld.d $t0, $fp, -198
	ld.w $t1, $fp, -136
	st.w $t1, $t0, 0
# ret i32 %op93
	ld.w $a0, $fp, -136
	addi.d $sp, $sp, 208
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 208
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -160
.main_label_entry:
# store i32 5, i32* @n
	la.local $t0, n
	addi.w $t1, $zero, 5
	st.w $t1, $t0, 0
# store i32 10, i32* @m
	la.local $t0, m
	addi.w $t1, $zero, 10
	st.w $t1, $t0, 0
# %op1 = icmp slt i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -17
# br i1 %op1, label %label2, label %label3
	ld.b $t0, $fp, -17
	bnez $t0, .main_label2
	beqz $t0, .main_label3
.main_label2:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 160
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label3:
# %op4 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 0
	la.local $t0, w
	addi.w $t2, $zero, 0
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -25
# store i32 2, i32* %op4
	ld.d $t0, $fp, -25
	addi.w $t1, $zero, 2
	st.w $t1, $t0, 0
# %op5 = icmp slt i32 1, 0
	addi.w $t0, $zero, 1
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -26
# br i1 %op5, label %label6, label %label7
	ld.b $t0, $fp, -26
	bnez $t0, .main_label6
	beqz $t0, .main_label7
.main_label6:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 160
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label7:
# %op8 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 1
	la.local $t0, w
	addi.w $t2, $zero, 1
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -34
# store i32 2, i32* %op8
	ld.d $t0, $fp, -34
	addi.w $t1, $zero, 2
	st.w $t1, $t0, 0
# %op9 = icmp slt i32 2, 0
	addi.w $t0, $zero, 2
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -35
# br i1 %op9, label %label10, label %label11
	ld.b $t0, $fp, -35
	bnez $t0, .main_label10
	beqz $t0, .main_label11
.main_label10:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 160
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label11:
# %op12 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 2
	la.local $t0, w
	addi.w $t2, $zero, 2
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -43
# store i32 6, i32* %op12
	ld.d $t0, $fp, -43
	addi.w $t1, $zero, 6
	st.w $t1, $t0, 0
# %op13 = icmp slt i32 3, 0
	addi.w $t0, $zero, 3
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -44
# br i1 %op13, label %label14, label %label15
	ld.b $t0, $fp, -44
	bnez $t0, .main_label14
	beqz $t0, .main_label15
.main_label14:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 160
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label15:
# %op16 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 3
	la.local $t0, w
	addi.w $t2, $zero, 3
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -52
# store i32 5, i32* %op16
	ld.d $t0, $fp, -52
	addi.w $t1, $zero, 5
	st.w $t1, $t0, 0
# %op17 = icmp slt i32 4, 0
	addi.w $t0, $zero, 4
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -53
# br i1 %op17, label %label18, label %label19
	ld.b $t0, $fp, -53
	bnez $t0, .main_label18
	beqz $t0, .main_label19
.main_label18:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 160
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label19:
# %op20 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 4
	la.local $t0, w
	addi.w $t2, $zero, 4
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -61
# store i32 4, i32* %op20
	ld.d $t0, $fp, -61
	addi.w $t1, $zero, 4
	st.w $t1, $t0, 0
# %op21 = icmp slt i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -62
# br i1 %op21, label %label22, label %label23
	ld.b $t0, $fp, -62
	bnez $t0, .main_label22
	beqz $t0, .main_label23
.main_label22:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 160
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label23:
# %op24 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 0
	la.local $t0, v
	addi.w $t2, $zero, 0
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -70
# store i32 6, i32* %op24
	ld.d $t0, $fp, -70
	addi.w $t1, $zero, 6
	st.w $t1, $t0, 0
# %op25 = icmp slt i32 1, 0
	addi.w $t0, $zero, 1
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -71
# br i1 %op25, label %label26, label %label27
	ld.b $t0, $fp, -71
	bnez $t0, .main_label26
	beqz $t0, .main_label27
.main_label26:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 160
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label27:
# %op28 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 1
	la.local $t0, v
	addi.w $t2, $zero, 1
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -79
# store i32 3, i32* %op28
	ld.d $t0, $fp, -79
	addi.w $t1, $zero, 3
	st.w $t1, $t0, 0
# %op29 = icmp slt i32 2, 0
	addi.w $t0, $zero, 2
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -80
# br i1 %op29, label %label30, label %label31
	ld.b $t0, $fp, -80
	bnez $t0, .main_label30
	beqz $t0, .main_label31
.main_label30:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 160
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label31:
# %op32 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 2
	la.local $t0, v
	addi.w $t2, $zero, 2
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -88
# store i32 5, i32* %op32
	ld.d $t0, $fp, -88
	addi.w $t1, $zero, 5
	st.w $t1, $t0, 0
# %op33 = icmp slt i32 3, 0
	addi.w $t0, $zero, 3
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -89
# br i1 %op33, label %label34, label %label35
	ld.b $t0, $fp, -89
	bnez $t0, .main_label34
	beqz $t0, .main_label35
.main_label34:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 160
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label35:
# %op36 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 3
	la.local $t0, v
	addi.w $t2, $zero, 3
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -97
# store i32 4, i32* %op36
	ld.d $t0, $fp, -97
	addi.w $t1, $zero, 4
	st.w $t1, $t0, 0
# %op37 = icmp slt i32 4, 0
	addi.w $t0, $zero, 4
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -98
# br i1 %op37, label %label38, label %label39
	ld.b $t0, $fp, -98
	bnez $t0, .main_label38
	beqz $t0, .main_label39
.main_label38:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 160
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label39:
# %op40 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 4
	la.local $t0, v
	addi.w $t2, $zero, 4
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -106
# store i32 6, i32* %op40
	ld.d $t0, $fp, -106
	addi.w $t1, $zero, 6
	st.w $t1, $t0, 0
# br label %label60
	b .main_label60
.main_label41:
# %op59 = phi i32 [ %op58, %label55 ], [ 0, %label60 ]
# %op43 = icmp slt i32 %op59, 66
	ld.w $t0, $fp, -110
	addi.w $t1, $zero, 66
	slt $t2, $t0, $t1
	st.b $t2, $fp, -111
# %op44 = zext i1 %op43 to i32
	ld.b $t0, $fp, -111
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -115
# %op45 = icmp ne i32 %op44, 0
	ld.w $t0, $fp, -115
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -116
# br i1 %op45, label %label46, label %label50
	ld.b $t0, $fp, -116
	bnez $t0, .main_label46
	beqz $t0, .main_label50
.main_label46:
# %op49 = icmp slt i32 %op59, 0
	ld.w $t0, $fp, -110
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -117
# br i1 %op49, label %label54, label %label55
	ld.b $t0, $fp, -117
	bnez $t0, .main_label54
	beqz $t0, .main_label55
.main_label50:
# %op51 = load i32, i32* @n
	la.local $t0, n
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -121
# %op52 = load i32, i32* @m
	la.local $t0, m
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -125
# %op53 = call i32 @knapsack(i32 %op51, i32 %op52)
	ld.w $a0, $fp, -121
	ld.w $a1, $fp, -125
	bl knapsack
	st.w $a0, $fp, -129
# call void @output(i32 %op53)
	ld.w $a0, $fp, -129
	bl output
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 160
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label54:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 160
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label55:
# %op56 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op59
	la.local $t0, dp
	ld.w $t2, $fp, -110
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -137
# store i32 %op47, i32* %op56
	ld.d $t0, $fp, -137
	ld.w $t1, $fp, -145
	st.w $t1, $t0, 0
# %op58 = add i32 %op59, 1
	ld.w $t0, $fp, -110
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -141
# br label %label41
	ld.w $a0, $fp, -141
	st.w $a0, $fp, -110
	ld.w $a0, $fp, -141
	st.w $a0, $fp, -110
	b .main_label41
.main_label60:
# %op47 = sub i32 0, 1
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -145
# br label %label41
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -110
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -110
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -110
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -110
	b .main_label41
	addi.d $sp, $sp, 160
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
