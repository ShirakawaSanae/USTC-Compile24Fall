	.text
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -32
.main_label_entry:
# br label %label2
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -20
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -20
	b .main_label2
.main_label2:
# %op13 = phi i32 [ 0, %label_entry ], [ %op11, %label8 ]
# %op5 = icmp slt i32 %op13, 10
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 10
	slt $t2, $t0, $t1
	st.b $t2, $fp, -21
# %op6 = zext i1 %op5 to i32
	ld.b $t0, $fp, -21
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -25
# %op7 = icmp ne i32 %op6, 0
	ld.w $t0, $fp, -25
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -26
# br i1 %op7, label %label8, label %label12
	ld.b $t0, $fp, -26
	bnez $t0, .main_label8
	beqz $t0, .main_label12
.main_label8:
# call void @output(i32 %op13)
	ld.w $a0, $fp, -20
	bl output
# %op11 = add i32 %op13, 1
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -30
# br label %label2
	ld.w $a0, $fp, -30
	st.w $a0, $fp, -20
	ld.w $a0, $fp, -30
	st.w $a0, $fp, -20
	b .main_label2
.main_label12:
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
