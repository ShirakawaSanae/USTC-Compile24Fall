	.text
	.globl fibonacci
	.type fibonacci, @function
fibonacci:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -64
	st.w $a0, $fp, -20
.fibonacci_label_entry:
# %op3 = icmp eq i32 %arg0, 0
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	xori $t2, $t2, 1
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
# br i1 %op5, label %label6, label %label7
	ld.b $t0, $fp, -26
	bnez $t0, .fibonacci_label6
	beqz $t0, .fibonacci_label7
.fibonacci_label6:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 64
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.fibonacci_label7:
# %op9 = icmp eq i32 %arg0, 1
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 1
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	xori $t2, $t2, 1
	st.b $t2, $fp, -27
# %op10 = zext i1 %op9 to i32
	ld.b $t0, $fp, -27
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -31
# %op11 = icmp ne i32 %op10, 0
	ld.w $t0, $fp, -31
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -32
# br i1 %op11, label %label13, label %label14
	ld.b $t0, $fp, -32
	bnez $t0, .fibonacci_label13
	beqz $t0, .fibonacci_label14
.fibonacci_label13:
# ret i32 1
	addi.w $a0, $zero, 1
	addi.d $sp, $sp, 64
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.fibonacci_label14:
# %op16 = sub i32 %arg0, 1
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -36
# %op17 = call i32 @fibonacci(i32 %op16)
	ld.w $a0, $fp, -36
	bl fibonacci
	st.w $a0, $fp, -40
# %op19 = sub i32 %arg0, 2
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 2
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -44
# %op20 = call i32 @fibonacci(i32 %op19)
	ld.w $a0, $fp, -44
	bl fibonacci
	st.w $a0, $fp, -48
# %op21 = add i32 %op17, %op20
	ld.w $t0, $fp, -40
	ld.w $t1, $fp, -48
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -52
# ret i32 %op21
	ld.w $a0, $fp, -52
	addi.d $sp, $sp, 64
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
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
# br label %label2
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -20
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -20
	b .main_label2
.main_label2:
# %op14 = phi i32 [ 0, %label_entry ], [ %op12, %label8 ]
# %op5 = icmp slt i32 %op14, 10
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
# br i1 %op7, label %label8, label %label13
	ld.b $t0, $fp, -26
	bnez $t0, .main_label8
	beqz $t0, .main_label13
.main_label8:
# %op10 = call i32 @fibonacci(i32 %op14)
	ld.w $a0, $fp, -20
	bl fibonacci
	st.w $a0, $fp, -30
# call void @output(i32 %op10)
	ld.w $a0, $fp, -30
	bl output
# %op12 = add i32 %op14, 1
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -34
# br label %label2
	ld.w $a0, $fp, -34
	st.w $a0, $fp, -20
	ld.w $a0, $fp, -34
	st.w $a0, $fp, -20
	b .main_label2
.main_label13:
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
