	.text
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -96
.main_label_entry:
# %op0 = alloca i32
	addi.d $t0, $fp, -28
	st.d $t0, $fp, -24
# %op1 = alloca i32
	addi.d $t0, $fp, -40
	st.d $t0, $fp, -36
# store i32 10, i32* %op0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 10
	st.w $t1, $t0, 0
# br label %label2
	b .main_label2
.main_label2:
# %op3 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -44
# %op4 = icmp ne i32 %op3, 0
	ld.w $t0, $fp, -44
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -45
# br i1 %op4, label %label5, label %label9
	ld.b $t0, $fp, -45
	bnez $t0, .main_label5
	beqz $t0, .main_label9
.main_label5:
# %op6 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -49
# %op7 = sub i32 %op6, 1
	ld.w $t0, $fp, -49
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -53
# store i32 %op7, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $fp, -53
	st.w $t1, $t0, 0
# %op8 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -57
# store i32 %op8, i32* %op1
	ld.d $t0, $fp, -36
	ld.w $t1, $fp, -57
	st.w $t1, $t0, 0
# br label %label13
	b .main_label13
.main_label9:
# %op10 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -61
# %op11 = load i32, i32* %op1
	ld.d $t0, $fp, -36
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -65
# %op12 = add i32 %op10, %op11
	ld.w $t0, $fp, -61
	ld.w $t1, $fp, -65
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -69
# ret i32 %op12
	ld.w $a0, $fp, -69
	addi.d $sp, $sp, 96
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label13:
# %op14 = load i32, i32* %op1
	ld.d $t0, $fp, -36
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -73
# %op15 = icmp ne i32 %op14, 0
	ld.w $t0, $fp, -73
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -74
# br i1 %op15, label %label16, label %label19
	ld.b $t0, $fp, -74
	bnez $t0, .main_label16
	beqz $t0, .main_label19
.main_label16:
# %op17 = load i32, i32* %op1
	ld.d $t0, $fp, -36
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -78
# %op18 = sub i32 %op17, 1
	ld.w $t0, $fp, -78
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -82
# store i32 %op18, i32* %op1
	ld.d $t0, $fp, -36
	ld.w $t1, $fp, -82
	st.w $t1, $t0, 0
# br label %label13
	b .main_label13
.main_label19:
# br label %label2
	b .main_label2
	addi.d $sp, $sp, 96
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
