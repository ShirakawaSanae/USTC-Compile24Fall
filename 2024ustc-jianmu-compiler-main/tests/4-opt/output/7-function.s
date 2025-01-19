	.text
	.globl min
	.type min, @function
min:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -32
	st.w $a0, $fp, -20
	st.w $a1, $fp, -24
.min_label_entry:
# %op6 = icmp sle i32 %arg0, %arg1
	ld.w $t0, $fp, -20
	ld.w $t1, $fp, -24
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
# br i1 %op8, label %label9, label %label11
	ld.b $t0, $fp, -30
	bnez $t0, .min_label9
	beqz $t0, .min_label11
.min_label9:
# ret i32 %arg0
	ld.w $a0, $fp, -20
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.min_label11:
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
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -32
.main_label_entry:
# %op5 = call i32 @min(i32 11, i32 22)
	addi.w $a0, $zero, 11
	addi.w $a1, $zero, 22
	bl min
	st.w $a0, $fp, -20
# call void @output(i32 %op5)
	ld.w $a0, $fp, -20
	bl output
# %op8 = call i32 @min(i32 22, i32 33)
	addi.w $a0, $zero, 22
	addi.w $a1, $zero, 33
	bl min
	st.w $a0, $fp, -24
# call void @output(i32 %op8)
	ld.w $a0, $fp, -24
	bl output
# %op11 = call i32 @min(i32 33, i32 11)
	addi.w $a0, $zero, 33
	addi.w $a1, $zero, 11
	bl min
	st.w $a0, $fp, -28
# call void @output(i32 %op11)
	ld.w $a0, $fp, -28
	bl output
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
