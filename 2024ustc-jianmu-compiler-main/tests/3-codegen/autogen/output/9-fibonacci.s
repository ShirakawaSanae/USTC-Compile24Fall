	.text
	.globl fibonacci
	.type fibonacci, @function
fibonacci:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -80
	st.w $a0, $fp, -20
.fibonacci_label_entry:
# %op1 = alloca i32
	addi.d $t0, $fp, -32
	st.d $t0, $fp, -28
# store i32 %arg0, i32* %op1
	ld.d $t0, $fp, -28
	ld.w $t1, $fp, -20
	st.w $t1, $t0, 0
# %op2 = load i32, i32* %op1
	ld.d $t0, $fp, -28
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -36
# %op3 = icmp eq i32 %op2, 0
	ld.w $t0, $fp, -36
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	xori $t2, $t2, 1
	st.b $t2, $fp, -37
# %op4 = zext i1 %op3 to i32
	ld.b $t0, $fp, -37
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -41
# %op5 = icmp ne i32 %op4, 0
	ld.w $t0, $fp, -41
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -42
# br i1 %op5, label %label6, label %label7
	ld.b $t0, $fp, -42
	bnez $t0, .fibonacci_label6
	beqz $t0, .fibonacci_label7
.fibonacci_label6:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.fibonacci_label7:
# %op8 = load i32, i32* %op1
	ld.d $t0, $fp, -28
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -46
# %op9 = icmp eq i32 %op8, 1
	ld.w $t0, $fp, -46
	addi.w $t1, $zero, 1
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	xori $t2, $t2, 1
	st.b $t2, $fp, -47
# %op10 = zext i1 %op9 to i32
	ld.b $t0, $fp, -47
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -51
# %op11 = icmp ne i32 %op10, 0
	ld.w $t0, $fp, -51
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -52
# br i1 %op11, label %label13, label %label14
	ld.b $t0, $fp, -52
	bnez $t0, .fibonacci_label13
	beqz $t0, .fibonacci_label14
.fibonacci_label12:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.fibonacci_label13:
# ret i32 1
	addi.w $a0, $zero, 1
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.fibonacci_label14:
# %op15 = load i32, i32* %op1
	ld.d $t0, $fp, -28
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -56
# %op16 = sub i32 %op15, 1
	ld.w $t0, $fp, -56
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -60
# %op17 = call i32 @fibonacci(i32 %op16)
	ld.w $a0, $fp, -60
	bl fibonacci
	st.w $a0, $fp, -64
# %op18 = load i32, i32* %op1
	ld.d $t0, $fp, -28
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -68
# %op19 = sub i32 %op18, 2
	ld.w $t0, $fp, -68
	addi.w $t1, $zero, 2
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -72
# %op20 = call i32 @fibonacci(i32 %op19)
	ld.w $a0, $fp, -72
	bl fibonacci
	st.w $a0, $fp, -76
# %op21 = add i32 %op17, %op20
	ld.w $t0, $fp, -64
	ld.w $t1, $fp, -76
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -80
# ret i32 %op21
	ld.w $a0, $fp, -80
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.fibonacci_label22:
# br label %label12
	b .fibonacci_label12
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -80
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
# store i32 0, i32* %op1
	ld.d $t0, $fp, -36
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# br label %label2
	b .main_label2
.main_label2:
# %op3 = load i32, i32* %op1
	ld.d $t0, $fp, -36
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -44
# %op4 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -48
# %op5 = icmp slt i32 %op3, %op4
	ld.w $t0, $fp, -44
	ld.w $t1, $fp, -48
	slt $t2, $t0, $t1
	st.b $t2, $fp, -49
# %op6 = zext i1 %op5 to i32
	ld.b $t0, $fp, -49
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -53
# %op7 = icmp ne i32 %op6, 0
	ld.w $t0, $fp, -53
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -54
# br i1 %op7, label %label8, label %label13
	ld.b $t0, $fp, -54
	bnez $t0, .main_label8
	beqz $t0, .main_label13
.main_label8:
# %op9 = load i32, i32* %op1
	ld.d $t0, $fp, -36
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -58
# %op10 = call i32 @fibonacci(i32 %op9)
	ld.w $a0, $fp, -58
	bl fibonacci
	st.w $a0, $fp, -62
# call void @output(i32 %op10)
	ld.w $a0, $fp, -62
	bl output
# %op11 = load i32, i32* %op1
	ld.d $t0, $fp, -36
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -66
# %op12 = add i32 %op11, 1
	ld.w $t0, $fp, -66
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -70
# store i32 %op12, i32* %op1
	ld.d $t0, $fp, -36
	ld.w $t1, $fp, -70
	st.w $t1, $t0, 0
# br label %label2
	b .main_label2
.main_label13:
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
