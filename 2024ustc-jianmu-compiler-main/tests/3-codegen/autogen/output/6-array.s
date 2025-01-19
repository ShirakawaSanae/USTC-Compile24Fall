	.text
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -144
.main_label_entry:
# %op0 = alloca [10 x i32]
	addi.d $t0, $fp, -64
	st.d $t0, $fp, -24
# %op1 = alloca i32
	addi.d $t0, $fp, -76
	st.d $t0, $fp, -72
# store i32 0, i32* %op1
	ld.d $t0, $fp, -72
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# %op2 = icmp slt i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -77
# br i1 %op2, label %label3, label %label4
	ld.b $t0, $fp, -77
	bnez $t0, .main_label3
	beqz $t0, .main_label4
.main_label3:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label4:
# %op5 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 0
	ld.d $t0, $fp, -24
	addi.w $t2, $zero, 0
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -85
# store i32 11, i32* %op5
	ld.d $t0, $fp, -85
	addi.w $t1, $zero, 11
	st.w $t1, $t0, 0
# %op6 = icmp slt i32 4, 0
	addi.w $t0, $zero, 4
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -86
# br i1 %op6, label %label7, label %label8
	ld.b $t0, $fp, -86
	bnez $t0, .main_label7
	beqz $t0, .main_label8
.main_label7:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label8:
# %op9 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 4
	ld.d $t0, $fp, -24
	addi.w $t2, $zero, 4
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -94
# store i32 22, i32* %op9
	ld.d $t0, $fp, -94
	addi.w $t1, $zero, 22
	st.w $t1, $t0, 0
# %op10 = icmp slt i32 9, 0
	addi.w $t0, $zero, 9
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -95
# br i1 %op10, label %label11, label %label12
	ld.b $t0, $fp, -95
	bnez $t0, .main_label11
	beqz $t0, .main_label12
.main_label11:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label12:
# %op13 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 9
	ld.d $t0, $fp, -24
	addi.w $t2, $zero, 9
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -103
# store i32 33, i32* %op13
	ld.d $t0, $fp, -103
	addi.w $t1, $zero, 33
	st.w $t1, $t0, 0
# %op14 = icmp slt i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -104
# br i1 %op14, label %label15, label %label16
	ld.b $t0, $fp, -104
	bnez $t0, .main_label15
	beqz $t0, .main_label16
.main_label15:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label16:
# %op17 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 0
	ld.d $t0, $fp, -24
	addi.w $t2, $zero, 0
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -112
# %op18 = load i32, i32* %op17
	ld.d $t0, $fp, -112
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -116
# call void @output(i32 %op18)
	ld.w $a0, $fp, -116
	bl output
# %op19 = icmp slt i32 4, 0
	addi.w $t0, $zero, 4
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -117
# br i1 %op19, label %label20, label %label21
	ld.b $t0, $fp, -117
	bnez $t0, .main_label20
	beqz $t0, .main_label21
.main_label20:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label21:
# %op22 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 4
	ld.d $t0, $fp, -24
	addi.w $t2, $zero, 4
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -125
# %op23 = load i32, i32* %op22
	ld.d $t0, $fp, -125
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -129
# call void @output(i32 %op23)
	ld.w $a0, $fp, -129
	bl output
# %op24 = icmp slt i32 9, 0
	addi.w $t0, $zero, 9
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -130
# br i1 %op24, label %label25, label %label26
	ld.b $t0, $fp, -130
	bnez $t0, .main_label25
	beqz $t0, .main_label26
.main_label25:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label26:
# %op27 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 9
	ld.d $t0, $fp, -24
	addi.w $t2, $zero, 9
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -138
# %op28 = load i32, i32* %op27
	ld.d $t0, $fp, -138
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -142
# call void @output(i32 %op28)
	ld.w $a0, $fp, -142
	bl output
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
