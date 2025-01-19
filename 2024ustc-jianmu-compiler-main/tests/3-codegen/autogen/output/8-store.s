	.text
	.globl store
	.type store, @function
store:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -112
	st.d $a0, $fp, -24
	st.w $a1, $fp, -28
	st.w $a2, $fp, -32
.store_label_entry:
# %op3 = alloca i32*
	addi.d $t0, $fp, -48
	st.d $t0, $fp, -40
# store i32* %arg0, i32** %op3
	ld.d $t0, $fp, -40
	ld.d $t1, $fp, -24
	st.d $t1, $t0, 0
# %op4 = alloca i32
	addi.d $t0, $fp, -60
	st.d $t0, $fp, -56
# store i32 %arg1, i32* %op4
	ld.d $t0, $fp, -56
	ld.w $t1, $fp, -28
	st.w $t1, $t0, 0
# %op5 = alloca i32
	addi.d $t0, $fp, -72
	st.d $t0, $fp, -68
# store i32 %arg2, i32* %op5
	ld.d $t0, $fp, -68
	ld.w $t1, $fp, -32
	st.w $t1, $t0, 0
# %op6 = load i32, i32* %op5
	ld.d $t0, $fp, -68
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -76
# %op7 = load i32, i32* %op4
	ld.d $t0, $fp, -56
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -80
# %op8 = icmp slt i32 %op7, 0
	ld.w $t0, $fp, -80
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -81
# br i1 %op8, label %label9, label %label10
	ld.b $t0, $fp, -81
	bnez $t0, .store_label9
	beqz $t0, .store_label10
.store_label9:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 112
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.store_label10:
# %op11 = load i32*, i32** %op3
	ld.d $t0, $fp, -40
	ld.d $t1, $t0, 0
	st.d $t1, $fp, -89
# %op12 = getelementptr i32, i32* %op11, i32 %op7
	ld.d $t0, $fp, -89
	ld.w $t2, $fp, -80
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -97
# store i32 %op6, i32* %op12
	ld.d $t0, $fp, -97
	ld.w $t1, $fp, -76
	st.w $t1, $t0, 0
# %op13 = load i32, i32* %op5
	ld.d $t0, $fp, -68
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -101
# ret i32 %op13
	ld.w $a0, $fp, -101
	addi.d $sp, $sp, 112
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 112
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -192
.main_label_entry:
# %op0 = alloca [10 x i32]
	addi.d $t0, $fp, -64
	st.d $t0, $fp, -24
# %op1 = alloca i32
	addi.d $t0, $fp, -76
	st.d $t0, $fp, -72
# %op2 = alloca i32
	addi.d $t0, $fp, -88
	st.d $t0, $fp, -84
# store i32 0, i32* %op1
	ld.d $t0, $fp, -72
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# br label %label3
	b .main_label3
.main_label3:
# %op4 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -92
# %op5 = icmp slt i32 %op4, 10
	ld.w $t0, $fp, -92
	addi.w $t1, $zero, 10
	slt $t2, $t0, $t1
	st.b $t2, $fp, -93
# %op6 = zext i1 %op5 to i32
	ld.b $t0, $fp, -93
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -97
# %op7 = icmp ne i32 %op6, 0
	ld.w $t0, $fp, -97
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -98
# br i1 %op7, label %label8, label %label16
	ld.b $t0, $fp, -98
	bnez $t0, .main_label8
	beqz $t0, .main_label16
.main_label8:
# %op9 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 0
	ld.d $t0, $fp, -24
	addi.w $t2, $zero, 0
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -106
# %op10 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -110
# %op11 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -114
# %op12 = mul i32 %op11, 2
	ld.w $t0, $fp, -114
	addi.w $t1, $zero, 2
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -118
# %op13 = call i32 @store(i32* %op9, i32 %op10, i32 %op12)
	ld.d $a0, $fp, -106
	ld.w $a1, $fp, -110
	ld.w $a2, $fp, -118
	bl store
	st.w $a0, $fp, -122
# %op14 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -126
# %op15 = add i32 %op14, 1
	ld.w $t0, $fp, -126
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -130
# store i32 %op15, i32* %op1
	ld.d $t0, $fp, -72
	ld.w $t1, $fp, -130
	st.w $t1, $t0, 0
# br label %label3
	b .main_label3
.main_label16:
# store i32 0, i32* %op2
	ld.d $t0, $fp, -84
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# store i32 0, i32* %op1
	ld.d $t0, $fp, -72
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# br label %label17
	b .main_label17
.main_label17:
# %op18 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -134
# %op19 = icmp slt i32 %op18, 10
	ld.w $t0, $fp, -134
	addi.w $t1, $zero, 10
	slt $t2, $t0, $t1
	st.b $t2, $fp, -135
# %op20 = zext i1 %op19 to i32
	ld.b $t0, $fp, -135
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -139
# %op21 = icmp ne i32 %op20, 0
	ld.w $t0, $fp, -139
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -140
# br i1 %op21, label %label22, label %label26
	ld.b $t0, $fp, -140
	bnez $t0, .main_label22
	beqz $t0, .main_label26
.main_label22:
# %op23 = load i32, i32* %op2
	ld.d $t0, $fp, -84
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -144
# %op24 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -148
# %op25 = icmp slt i32 %op24, 0
	ld.w $t0, $fp, -148
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -149
# br i1 %op25, label %label28, label %label29
	ld.b $t0, $fp, -149
	bnez $t0, .main_label28
	beqz $t0, .main_label29
.main_label26:
# %op27 = load i32, i32* %op2
	ld.d $t0, $fp, -84
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -153
# call void @output(i32 %op27)
	ld.w $a0, $fp, -153
	bl output
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 192
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label28:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 192
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label29:
# %op30 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 %op24
	ld.d $t0, $fp, -24
	ld.w $t2, $fp, -148
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -161
# %op31 = load i32, i32* %op30
	ld.d $t0, $fp, -161
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -165
# %op32 = add i32 %op23, %op31
	ld.w $t0, $fp, -144
	ld.w $t1, $fp, -165
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -169
# store i32 %op32, i32* %op2
	ld.d $t0, $fp, -84
	ld.w $t1, $fp, -169
	st.w $t1, $t0, 0
# %op33 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -173
# %op34 = add i32 %op33, 1
	ld.w $t0, $fp, -173
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -177
# store i32 %op34, i32* %op1
	ld.d $t0, $fp, -72
	ld.w $t1, $fp, -177
	st.w $t1, $t0, 0
# br label %label17
	b .main_label17
	addi.d $sp, $sp, 192
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
