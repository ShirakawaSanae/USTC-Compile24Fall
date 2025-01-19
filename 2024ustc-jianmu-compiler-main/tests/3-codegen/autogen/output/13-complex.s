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
	addi.d $sp, $sp, -80
	st.w $a0, $fp, -20
	st.w $a1, $fp, -24
.max_label_entry:
# %op2 = alloca i32
	addi.d $t0, $fp, -36
	st.d $t0, $fp, -32
# store i32 %arg0, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $fp, -20
	st.w $t1, $t0, 0
# %op3 = alloca i32
	addi.d $t0, $fp, -48
	st.d $t0, $fp, -44
# store i32 %arg1, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $fp, -24
	st.w $t1, $t0, 0
# %op4 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -52
# %op5 = load i32, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -56
# %op6 = icmp sgt i32 %op4, %op5
	ld.w $t0, $fp, -52
	ld.w $t1, $fp, -56
	slt $t2, $t1, $t0
	st.b $t2, $fp, -57
# %op7 = zext i1 %op6 to i32
	ld.b $t0, $fp, -57
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -61
# %op8 = icmp ne i32 %op7, 0
	ld.w $t0, $fp, -61
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -62
# br i1 %op8, label %label9, label %label11
	ld.b $t0, $fp, -62
	bnez $t0, .max_label9
	beqz $t0, .max_label11
.max_label9:
# %op10 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -66
# ret i32 %op10
	ld.w $a0, $fp, -66
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.max_label11:
# %op12 = load i32, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -70
# ret i32 %op12
	ld.w $a0, $fp, -70
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.max_label13:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl knapsack
	.type knapsack, @function
knapsack:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -320
	st.w $a0, $fp, -20
	st.w $a1, $fp, -24
.knapsack_label_entry:
# %op2 = alloca i32
	addi.d $t0, $fp, -36
	st.d $t0, $fp, -32
# store i32 %arg0, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $fp, -20
	st.w $t1, $t0, 0
# %op3 = alloca i32
	addi.d $t0, $fp, -48
	st.d $t0, $fp, -44
# store i32 %arg1, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $fp, -24
	st.w $t1, $t0, 0
# %op4 = alloca i32
	addi.d $t0, $fp, -60
	st.d $t0, $fp, -56
# %op5 = load i32, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -64
# %op6 = icmp sle i32 %op5, 0
	ld.w $t0, $fp, -64
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	xori $t2, $t2, 1
	st.b $t2, $fp, -65
# %op7 = zext i1 %op6 to i32
	ld.b $t0, $fp, -65
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -69
# %op8 = icmp ne i32 %op7, 0
	ld.w $t0, $fp, -69
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -70
# br i1 %op8, label %label9, label %label10
	ld.b $t0, $fp, -70
	bnez $t0, .knapsack_label9
	beqz $t0, .knapsack_label10
.knapsack_label9:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 320
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label10:
# %op11 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -74
# %op12 = icmp eq i32 %op11, 0
	ld.w $t0, $fp, -74
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	xori $t2, $t2, 1
	st.b $t2, $fp, -75
# %op13 = zext i1 %op12 to i32
	ld.b $t0, $fp, -75
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -79
# %op14 = icmp ne i32 %op13, 0
	ld.w $t0, $fp, -79
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -80
# br i1 %op14, label %label15, label %label16
	ld.b $t0, $fp, -80
	bnez $t0, .knapsack_label15
	beqz $t0, .knapsack_label16
.knapsack_label15:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 320
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label16:
# %op17 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -84
# %op18 = mul i32 %op17, 11
	ld.w $t0, $fp, -84
	addi.w $t1, $zero, 11
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -88
# %op19 = load i32, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -92
# %op20 = add i32 %op18, %op19
	ld.w $t0, $fp, -88
	ld.w $t1, $fp, -92
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -96
# %op21 = icmp slt i32 %op20, 0
	ld.w $t0, $fp, -96
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -97
# br i1 %op21, label %label22, label %label23
	ld.b $t0, $fp, -97
	bnez $t0, .knapsack_label22
	beqz $t0, .knapsack_label23
.knapsack_label22:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 320
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label23:
# %op24 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op20
	la.local $t0, dp
	ld.w $t2, $fp, -96
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -105
# %op25 = load i32, i32* %op24
	ld.d $t0, $fp, -105
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -109
# %op26 = icmp sge i32 %op25, 0
	ld.w $t0, $fp, -109
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	xori $t2, $t2, 1
	st.b $t2, $fp, -110
# %op27 = zext i1 %op26 to i32
	ld.b $t0, $fp, -110
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -114
# %op28 = icmp ne i32 %op27, 0
	ld.w $t0, $fp, -114
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -115
# br i1 %op28, label %label29, label %label35
	ld.b $t0, $fp, -115
	bnez $t0, .knapsack_label29
	beqz $t0, .knapsack_label35
.knapsack_label29:
# %op30 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -119
# %op31 = mul i32 %op30, 11
	ld.w $t0, $fp, -119
	addi.w $t1, $zero, 11
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -123
# %op32 = load i32, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -127
# %op33 = add i32 %op31, %op32
	ld.w $t0, $fp, -123
	ld.w $t1, $fp, -127
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -131
# %op34 = icmp slt i32 %op33, 0
	ld.w $t0, $fp, -131
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -132
# br i1 %op34, label %label40, label %label41
	ld.b $t0, $fp, -132
	bnez $t0, .knapsack_label40
	beqz $t0, .knapsack_label41
.knapsack_label35:
# %op36 = load i32, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -136
# %op37 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -140
# %op38 = sub i32 %op37, 1
	ld.w $t0, $fp, -140
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -144
# %op39 = icmp slt i32 %op38, 0
	ld.w $t0, $fp, -144
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -145
# br i1 %op39, label %label44, label %label45
	ld.b $t0, $fp, -145
	bnez $t0, .knapsack_label44
	beqz $t0, .knapsack_label45
.knapsack_label40:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 320
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label41:
# %op42 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op33
	la.local $t0, dp
	ld.w $t2, $fp, -131
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -153
# %op43 = load i32, i32* %op42
	ld.d $t0, $fp, -153
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -157
# ret i32 %op43
	ld.w $a0, $fp, -157
	addi.d $sp, $sp, 320
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label44:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 320
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label45:
# %op46 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 %op38
	la.local $t0, w
	ld.w $t2, $fp, -144
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -165
# %op47 = load i32, i32* %op46
	ld.d $t0, $fp, -165
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -169
# %op48 = icmp slt i32 %op36, %op47
	ld.w $t0, $fp, -136
	ld.w $t1, $fp, -169
	slt $t2, $t0, $t1
	st.b $t2, $fp, -170
# %op49 = zext i1 %op48 to i32
	ld.b $t0, $fp, -170
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -174
# %op50 = icmp ne i32 %op49, 0
	ld.w $t0, $fp, -174
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -175
# br i1 %op50, label %label51, label %label56
	ld.b $t0, $fp, -175
	bnez $t0, .knapsack_label51
	beqz $t0, .knapsack_label56
.knapsack_label51:
# %op52 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -179
# %op53 = sub i32 %op52, 1
	ld.w $t0, $fp, -179
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -183
# %op54 = load i32, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -187
# %op55 = call i32 @knapsack(i32 %op53, i32 %op54)
	ld.w $a0, $fp, -183
	ld.w $a1, $fp, -187
	bl knapsack
	st.w $a0, $fp, -191
# store i32 %op55, i32* %op4
	ld.d $t0, $fp, -56
	ld.w $t1, $fp, -191
	st.w $t1, $t0, 0
# br label %label67
	b .knapsack_label67
.knapsack_label56:
# %op57 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -195
# %op58 = sub i32 %op57, 1
	ld.w $t0, $fp, -195
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -199
# %op59 = load i32, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -203
# %op60 = call i32 @knapsack(i32 %op58, i32 %op59)
	ld.w $a0, $fp, -199
	ld.w $a1, $fp, -203
	bl knapsack
	st.w $a0, $fp, -207
# %op61 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -211
# %op62 = sub i32 %op61, 1
	ld.w $t0, $fp, -211
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -215
# %op63 = load i32, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -219
# %op64 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -223
# %op65 = sub i32 %op64, 1
	ld.w $t0, $fp, -223
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -227
# %op66 = icmp slt i32 %op65, 0
	ld.w $t0, $fp, -227
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -228
# br i1 %op66, label %label74, label %label75
	ld.b $t0, $fp, -228
	bnez $t0, .knapsack_label74
	beqz $t0, .knapsack_label75
.knapsack_label67:
# %op68 = load i32, i32* %op4
	ld.d $t0, $fp, -56
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -232
# %op69 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -236
# %op70 = mul i32 %op69, 11
	ld.w $t0, $fp, -236
	addi.w $t1, $zero, 11
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -240
# %op71 = load i32, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -244
# %op72 = add i32 %op70, %op71
	ld.w $t0, $fp, -240
	ld.w $t1, $fp, -244
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -248
# %op73 = icmp slt i32 %op72, 0
	ld.w $t0, $fp, -248
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -249
# br i1 %op73, label %label89, label %label90
	ld.b $t0, $fp, -249
	bnez $t0, .knapsack_label89
	beqz $t0, .knapsack_label90
.knapsack_label74:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 320
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label75:
# %op76 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 %op65
	la.local $t0, w
	ld.w $t2, $fp, -227
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -257
# %op77 = load i32, i32* %op76
	ld.d $t0, $fp, -257
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -261
# %op78 = sub i32 %op63, %op77
	ld.w $t0, $fp, -219
	ld.w $t1, $fp, -261
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -265
# %op79 = call i32 @knapsack(i32 %op62, i32 %op78)
	ld.w $a0, $fp, -215
	ld.w $a1, $fp, -265
	bl knapsack
	st.w $a0, $fp, -269
# %op80 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -273
# %op81 = sub i32 %op80, 1
	ld.w $t0, $fp, -273
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -277
# %op82 = icmp slt i32 %op81, 0
	ld.w $t0, $fp, -277
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -278
# br i1 %op82, label %label83, label %label84
	ld.b $t0, $fp, -278
	bnez $t0, .knapsack_label83
	beqz $t0, .knapsack_label84
.knapsack_label83:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 320
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label84:
# %op85 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 %op81
	la.local $t0, v
	ld.w $t2, $fp, -277
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -286
# %op86 = load i32, i32* %op85
	ld.d $t0, $fp, -286
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -290
# %op87 = add i32 %op79, %op86
	ld.w $t0, $fp, -269
	ld.w $t1, $fp, -290
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -294
# %op88 = call i32 @max(i32 %op60, i32 %op87)
	ld.w $a0, $fp, -207
	ld.w $a1, $fp, -294
	bl max
	st.w $a0, $fp, -298
# store i32 %op88, i32* %op4
	ld.d $t0, $fp, -56
	ld.w $t1, $fp, -298
	st.w $t1, $t0, 0
# br label %label67
	b .knapsack_label67
.knapsack_label89:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 320
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label90:
# %op91 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op72
	la.local $t0, dp
	ld.w $t2, $fp, -248
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -306
# store i32 %op68, i32* %op91
	ld.d $t0, $fp, -306
	ld.w $t1, $fp, -232
	st.w $t1, $t0, 0
# %op92 = load i32, i32* %op4
	ld.d $t0, $fp, -56
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -310
# ret i32 %op92
	ld.w $a0, $fp, -310
	addi.d $sp, $sp, 320
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 320
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -176
.main_label_entry:
# %op0 = alloca i32
	addi.d $t0, $fp, -28
	st.d $t0, $fp, -24
# store i32 0, i32* %op0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
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
	st.b $t2, $fp, -29
# br i1 %op1, label %label2, label %label3
	ld.b $t0, $fp, -29
	bnez $t0, .main_label2
	beqz $t0, .main_label3
.main_label2:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 176
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
	st.d $t0, $fp, -37
# store i32 2, i32* %op4
	ld.d $t0, $fp, -37
	addi.w $t1, $zero, 2
	st.w $t1, $t0, 0
# %op5 = icmp slt i32 1, 0
	addi.w $t0, $zero, 1
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -38
# br i1 %op5, label %label6, label %label7
	ld.b $t0, $fp, -38
	bnez $t0, .main_label6
	beqz $t0, .main_label7
.main_label6:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 176
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
	st.d $t0, $fp, -46
# store i32 2, i32* %op8
	ld.d $t0, $fp, -46
	addi.w $t1, $zero, 2
	st.w $t1, $t0, 0
# %op9 = icmp slt i32 2, 0
	addi.w $t0, $zero, 2
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -47
# br i1 %op9, label %label10, label %label11
	ld.b $t0, $fp, -47
	bnez $t0, .main_label10
	beqz $t0, .main_label11
.main_label10:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 176
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
	st.d $t0, $fp, -55
# store i32 6, i32* %op12
	ld.d $t0, $fp, -55
	addi.w $t1, $zero, 6
	st.w $t1, $t0, 0
# %op13 = icmp slt i32 3, 0
	addi.w $t0, $zero, 3
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -56
# br i1 %op13, label %label14, label %label15
	ld.b $t0, $fp, -56
	bnez $t0, .main_label14
	beqz $t0, .main_label15
.main_label14:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 176
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
	st.d $t0, $fp, -64
# store i32 5, i32* %op16
	ld.d $t0, $fp, -64
	addi.w $t1, $zero, 5
	st.w $t1, $t0, 0
# %op17 = icmp slt i32 4, 0
	addi.w $t0, $zero, 4
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -65
# br i1 %op17, label %label18, label %label19
	ld.b $t0, $fp, -65
	bnez $t0, .main_label18
	beqz $t0, .main_label19
.main_label18:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 176
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
	st.d $t0, $fp, -73
# store i32 4, i32* %op20
	ld.d $t0, $fp, -73
	addi.w $t1, $zero, 4
	st.w $t1, $t0, 0
# %op21 = icmp slt i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -74
# br i1 %op21, label %label22, label %label23
	ld.b $t0, $fp, -74
	bnez $t0, .main_label22
	beqz $t0, .main_label23
.main_label22:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 176
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
	st.d $t0, $fp, -82
# store i32 6, i32* %op24
	ld.d $t0, $fp, -82
	addi.w $t1, $zero, 6
	st.w $t1, $t0, 0
# %op25 = icmp slt i32 1, 0
	addi.w $t0, $zero, 1
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -83
# br i1 %op25, label %label26, label %label27
	ld.b $t0, $fp, -83
	bnez $t0, .main_label26
	beqz $t0, .main_label27
.main_label26:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 176
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
	st.d $t0, $fp, -91
# store i32 3, i32* %op28
	ld.d $t0, $fp, -91
	addi.w $t1, $zero, 3
	st.w $t1, $t0, 0
# %op29 = icmp slt i32 2, 0
	addi.w $t0, $zero, 2
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -92
# br i1 %op29, label %label30, label %label31
	ld.b $t0, $fp, -92
	bnez $t0, .main_label30
	beqz $t0, .main_label31
.main_label30:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 176
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
	st.d $t0, $fp, -100
# store i32 5, i32* %op32
	ld.d $t0, $fp, -100
	addi.w $t1, $zero, 5
	st.w $t1, $t0, 0
# %op33 = icmp slt i32 3, 0
	addi.w $t0, $zero, 3
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -101
# br i1 %op33, label %label34, label %label35
	ld.b $t0, $fp, -101
	bnez $t0, .main_label34
	beqz $t0, .main_label35
.main_label34:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 176
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
	st.d $t0, $fp, -109
# store i32 4, i32* %op36
	ld.d $t0, $fp, -109
	addi.w $t1, $zero, 4
	st.w $t1, $t0, 0
# %op37 = icmp slt i32 4, 0
	addi.w $t0, $zero, 4
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -110
# br i1 %op37, label %label38, label %label39
	ld.b $t0, $fp, -110
	bnez $t0, .main_label38
	beqz $t0, .main_label39
.main_label38:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 176
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
	st.d $t0, $fp, -118
# store i32 6, i32* %op40
	ld.d $t0, $fp, -118
	addi.w $t1, $zero, 6
	st.w $t1, $t0, 0
# br label %label41
	b .main_label41
.main_label41:
# %op42 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -122
# %op43 = icmp slt i32 %op42, 66
	ld.w $t0, $fp, -122
	addi.w $t1, $zero, 66
	slt $t2, $t0, $t1
	st.b $t2, $fp, -123
# %op44 = zext i1 %op43 to i32
	ld.b $t0, $fp, -123
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -127
# %op45 = icmp ne i32 %op44, 0
	ld.w $t0, $fp, -127
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -128
# br i1 %op45, label %label46, label %label50
	ld.b $t0, $fp, -128
	bnez $t0, .main_label46
	beqz $t0, .main_label50
.main_label46:
# %op47 = sub i32 0, 1
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -132
# %op48 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -136
# %op49 = icmp slt i32 %op48, 0
	ld.w $t0, $fp, -136
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -137
# br i1 %op49, label %label54, label %label55
	ld.b $t0, $fp, -137
	bnez $t0, .main_label54
	beqz $t0, .main_label55
.main_label50:
# %op51 = load i32, i32* @n
	la.local $t0, n
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -141
# %op52 = load i32, i32* @m
	la.local $t0, m
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -145
# %op53 = call i32 @knapsack(i32 %op51, i32 %op52)
	ld.w $a0, $fp, -141
	ld.w $a1, $fp, -145
	bl knapsack
	st.w $a0, $fp, -149
# call void @output(i32 %op53)
	ld.w $a0, $fp, -149
	bl output
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 176
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label54:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 176
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label55:
# %op56 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op48
	la.local $t0, dp
	ld.w $t2, $fp, -136
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -157
# store i32 %op47, i32* %op56
	ld.d $t0, $fp, -157
	ld.w $t1, $fp, -132
	st.w $t1, $t0, 0
# %op57 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -161
# %op58 = add i32 %op57, 1
	ld.w $t0, $fp, -161
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -165
# store i32 %op58, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $fp, -165
	st.w $t1, $t0, 0
# br label %label41
	b .main_label41
	addi.d $sp, $sp, 176
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
