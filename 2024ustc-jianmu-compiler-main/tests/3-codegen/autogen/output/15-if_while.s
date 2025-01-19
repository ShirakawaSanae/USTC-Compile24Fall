	.text
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -112
.main_label_entry:
# %op0 = alloca i32
	addi.d $t0, $fp, -28
	st.d $t0, $fp, -24
# %op1 = alloca i32
	addi.d $t0, $fp, -40
	st.d $t0, $fp, -36
# %op2 = alloca i32
	addi.d $t0, $fp, -52
	st.d $t0, $fp, -48
# store i32 0, i32* %op1
	ld.d $t0, $fp, -36
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# store i32 0, i32* %op2
	ld.d $t0, $fp, -48
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# store i32 10, i32* %op0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 10
	st.w $t1, $t0, 0
# br label %label3
	b .main_label3
.main_label3:
# %op4 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -56
# %op5 = icmp ne i32 %op4, 0
	ld.w $t0, $fp, -56
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -57
# br i1 %op5, label %label6, label %label13
	ld.b $t0, $fp, -57
	bnez $t0, .main_label6
	beqz $t0, .main_label13
.main_label6:
# %op7 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -61
# %op8 = sub i32 %op7, 1
	ld.w $t0, $fp, -61
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -65
# store i32 %op8, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $fp, -65
	st.w $t1, $t0, 0
# %op9 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -69
# %op10 = icmp slt i32 %op9, 5
	ld.w $t0, $fp, -69
	addi.w $t1, $zero, 5
	slt $t2, $t0, $t1
	st.b $t2, $fp, -70
# %op11 = zext i1 %op10 to i32
	ld.b $t0, $fp, -70
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -74
# %op12 = icmp ne i32 %op11, 0
	ld.w $t0, $fp, -74
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -75
# br i1 %op12, label %label17, label %label21
	ld.b $t0, $fp, -75
	bnez $t0, .main_label17
	beqz $t0, .main_label21
.main_label13:
# %op14 = load i32, i32* %op1
	ld.d $t0, $fp, -36
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -79
# %op15 = load i32, i32* %op2
	ld.d $t0, $fp, -48
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -83
# %op16 = add i32 %op14, %op15
	ld.w $t0, $fp, -79
	ld.w $t1, $fp, -83
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -87
# ret i32 %op16
	ld.w $a0, $fp, -87
	addi.d $sp, $sp, 112
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label17:
# %op18 = load i32, i32* %op1
	ld.d $t0, $fp, -36
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -91
# %op19 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -95
# %op20 = add i32 %op18, %op19
	ld.w $t0, $fp, -91
	ld.w $t1, $fp, -95
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -99
# store i32 %op20, i32* %op1
	ld.d $t0, $fp, -36
	ld.w $t1, $fp, -99
	st.w $t1, $t0, 0
# br label %label25
	b .main_label25
.main_label21:
# %op22 = load i32, i32* %op2
	ld.d $t0, $fp, -48
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -103
# %op23 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -107
# %op24 = add i32 %op22, %op23
	ld.w $t0, $fp, -103
	ld.w $t1, $fp, -107
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -111
# store i32 %op24, i32* %op2
	ld.d $t0, $fp, -48
	ld.w $t1, $fp, -111
	st.w $t1, $t0, 0
# br label %label25
	b .main_label25
.main_label25:
# br label %label3
	b .main_label3
	addi.d $sp, $sp, 112
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
