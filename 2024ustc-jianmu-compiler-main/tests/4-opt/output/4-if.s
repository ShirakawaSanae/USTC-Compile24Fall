	.text
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -48
.main_label_entry:
# %op5 = icmp sgt i32 11, 22
	addi.w $t0, $zero, 11
	addi.w $t1, $zero, 22
	slt $t2, $t1, $t0
	st.b $t2, $fp, -17
# %op6 = zext i1 %op5 to i32
	ld.b $t0, $fp, -17
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -21
# %op7 = icmp ne i32 %op6, 0
	ld.w $t0, $fp, -21
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -22
# br i1 %op7, label %label8, label %label14
	ld.b $t0, $fp, -22
	bnez $t0, .main_label8
	beqz $t0, .main_label14
.main_label8:
# %op11 = icmp sgt i32 11, 33
	addi.w $t0, $zero, 11
	addi.w $t1, $zero, 33
	slt $t2, $t1, $t0
	st.b $t2, $fp, -23
# %op12 = zext i1 %op11 to i32
	ld.b $t0, $fp, -23
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -27
# %op13 = icmp ne i32 %op12, 0
	ld.w $t0, $fp, -27
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -28
# br i1 %op13, label %label21, label %label23
	ld.b $t0, $fp, -28
	bnez $t0, .main_label21
	beqz $t0, .main_label23
.main_label14:
# %op17 = icmp slt i32 33, 22
	addi.w $t0, $zero, 33
	addi.w $t1, $zero, 22
	slt $t2, $t0, $t1
	st.b $t2, $fp, -29
# %op18 = zext i1 %op17 to i32
	ld.b $t0, $fp, -29
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -33
# %op19 = icmp ne i32 %op18, 0
	ld.w $t0, $fp, -33
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -34
# br i1 %op19, label %label26, label %label28
	ld.b $t0, $fp, -34
	bnez $t0, .main_label26
	beqz $t0, .main_label28
.main_label20:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 48
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label21:
# call void @output(i32 11)
	addi.w $a0, $zero, 11
	bl output
# br label %label25
	b .main_label25
.main_label23:
# call void @output(i32 33)
	addi.w $a0, $zero, 33
	bl output
# br label %label25
	b .main_label25
.main_label25:
# br label %label20
	b .main_label20
.main_label26:
# call void @output(i32 22)
	addi.w $a0, $zero, 22
	bl output
# br label %label30
	b .main_label30
.main_label28:
# call void @output(i32 33)
	addi.w $a0, $zero, 33
	bl output
# br label %label30
	b .main_label30
.main_label30:
# br label %label20
	b .main_label20
	addi.d $sp, $sp, 48
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
