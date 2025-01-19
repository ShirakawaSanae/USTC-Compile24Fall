# Global variables
	.text
	.section .bss, "aw", @nobits
	.globl x
	.type x, @object
	.size x, 4
x:
	.space 4
	.globl y
	.type y, @object
	.size y, 4
y:
	.space 4
	.text
	.globl gcd
	.type gcd, @function
gcd:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -112
	st.w $a0, $fp, -20
	st.w $a1, $fp, -24
.gcd_label_entry:
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
# %op4 = load i32, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -52
# %op5 = icmp eq i32 %op4, 0
	ld.w $t0, $fp, -52
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	xori $t2, $t2, 1
	st.b $t2, $fp, -53
# %op6 = zext i1 %op5 to i32
	ld.b $t0, $fp, -53
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -57
# %op7 = icmp ne i32 %op6, 0
	ld.w $t0, $fp, -57
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -58
# br i1 %op7, label %label8, label %label10
	ld.b $t0, $fp, -58
	bnez $t0, .gcd_label8
	beqz $t0, .gcd_label10
.gcd_label8:
# %op9 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -62
# ret i32 %op9
	ld.w $a0, $fp, -62
	addi.d $sp, $sp, 112
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.gcd_label10:
# %op11 = load i32, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -66
# %op12 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -70
# %op13 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -74
# %op14 = load i32, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -78
# %op15 = sdiv i32 %op13, %op14
	ld.w $t0, $fp, -74
	ld.w $t1, $fp, -78
	div.w $t2, $t0, $t1
	st.w $t2, $fp, -82
# %op16 = load i32, i32* %op3
	ld.d $t0, $fp, -44
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -86
# %op17 = mul i32 %op15, %op16
	ld.w $t0, $fp, -82
	ld.w $t1, $fp, -86
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -90
# %op18 = sub i32 %op12, %op17
	ld.w $t0, $fp, -70
	ld.w $t1, $fp, -90
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -94
# %op19 = call i32 @gcd(i32 %op11, i32 %op18)
	ld.w $a0, $fp, -66
	ld.w $a1, $fp, -94
	bl gcd
	st.w $a0, $fp, -98
# ret i32 %op19
	ld.w $a0, $fp, -98
	addi.d $sp, $sp, 112
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.gcd_label20:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 112
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 112
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl funArray
	.type funArray, @function
funArray:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -192
	st.d $a0, $fp, -24
	st.d $a1, $fp, -32
.funArray_label_entry:
# %op2 = alloca i32*
	addi.d $t0, $fp, -48
	st.d $t0, $fp, -40
# store i32* %arg0, i32** %op2
	ld.d $t0, $fp, -40
	ld.d $t1, $fp, -24
	st.d $t1, $t0, 0
# %op3 = alloca i32*
	addi.d $t0, $fp, -64
	st.d $t0, $fp, -56
# store i32* %arg1, i32** %op3
	ld.d $t0, $fp, -56
	ld.d $t1, $fp, -32
	st.d $t1, $t0, 0
# %op4 = alloca i32
	addi.d $t0, $fp, -76
	st.d $t0, $fp, -72
# %op5 = alloca i32
	addi.d $t0, $fp, -88
	st.d $t0, $fp, -84
# %op6 = alloca i32
	addi.d $t0, $fp, -100
	st.d $t0, $fp, -96
# %op7 = icmp slt i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -101
# br i1 %op7, label %label8, label %label9
	ld.b $t0, $fp, -101
	bnez $t0, .funArray_label8
	beqz $t0, .funArray_label9
.funArray_label8:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 192
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.funArray_label9:
# %op10 = load i32*, i32** %op2
	ld.d $t0, $fp, -40
	ld.d $t1, $t0, 0
	st.d $t1, $fp, -109
# %op11 = getelementptr i32, i32* %op10, i32 0
	ld.d $t0, $fp, -109
	addi.w $t2, $zero, 0
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -117
# %op12 = load i32, i32* %op11
	ld.d $t0, $fp, -117
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -121
# store i32 %op12, i32* %op4
	ld.d $t0, $fp, -72
	ld.w $t1, $fp, -121
	st.w $t1, $t0, 0
# %op13 = icmp slt i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -122
# br i1 %op13, label %label14, label %label15
	ld.b $t0, $fp, -122
	bnez $t0, .funArray_label14
	beqz $t0, .funArray_label15
.funArray_label14:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 192
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.funArray_label15:
# %op16 = load i32*, i32** %op3
	ld.d $t0, $fp, -56
	ld.d $t1, $t0, 0
	st.d $t1, $fp, -130
# %op17 = getelementptr i32, i32* %op16, i32 0
	ld.d $t0, $fp, -130
	addi.w $t2, $zero, 0
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -138
# %op18 = load i32, i32* %op17
	ld.d $t0, $fp, -138
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -142
# store i32 %op18, i32* %op5
	ld.d $t0, $fp, -84
	ld.w $t1, $fp, -142
	st.w $t1, $t0, 0
# %op19 = load i32, i32* %op4
	ld.d $t0, $fp, -72
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -146
# %op20 = load i32, i32* %op5
	ld.d $t0, $fp, -84
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -150
# %op21 = icmp slt i32 %op19, %op20
	ld.w $t0, $fp, -146
	ld.w $t1, $fp, -150
	slt $t2, $t0, $t1
	st.b $t2, $fp, -151
# %op22 = zext i1 %op21 to i32
	ld.b $t0, $fp, -151
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -155
# %op23 = icmp ne i32 %op22, 0
	ld.w $t0, $fp, -155
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -156
# br i1 %op23, label %label24, label %label28
	ld.b $t0, $fp, -156
	bnez $t0, .funArray_label24
	beqz $t0, .funArray_label28
.funArray_label24:
# %op25 = load i32, i32* %op4
	ld.d $t0, $fp, -72
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -160
# store i32 %op25, i32* %op6
	ld.d $t0, $fp, -96
	ld.w $t1, $fp, -160
	st.w $t1, $t0, 0
# %op26 = load i32, i32* %op5
	ld.d $t0, $fp, -84
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -164
# store i32 %op26, i32* %op4
	ld.d $t0, $fp, -72
	ld.w $t1, $fp, -164
	st.w $t1, $t0, 0
# %op27 = load i32, i32* %op6
	ld.d $t0, $fp, -96
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -168
# store i32 %op27, i32* %op5
	ld.d $t0, $fp, -84
	ld.w $t1, $fp, -168
	st.w $t1, $t0, 0
# br label %label28
	b .funArray_label28
.funArray_label28:
# %op29 = load i32, i32* %op4
	ld.d $t0, $fp, -72
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -172
# %op30 = load i32, i32* %op5
	ld.d $t0, $fp, -84
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -176
# %op31 = call i32 @gcd(i32 %op29, i32 %op30)
	ld.w $a0, $fp, -172
	ld.w $a1, $fp, -176
	bl gcd
	st.w $a0, $fp, -180
# ret i32 %op31
	ld.w $a0, $fp, -180
	addi.d $sp, $sp, 192
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 192
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -64
.main_label_entry:
# %op0 = icmp slt i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -17
# br i1 %op0, label %label1, label %label2
	ld.b $t0, $fp, -17
	bnez $t0, .main_label1
	beqz $t0, .main_label2
.main_label1:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 64
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label2:
# %op3 = getelementptr [1 x i32], [1 x i32]* @x, i32 0, i32 0
	la.local $t0, x
	addi.w $t2, $zero, 0
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -25
# store i32 90, i32* %op3
	ld.d $t0, $fp, -25
	addi.w $t1, $zero, 90
	st.w $t1, $t0, 0
# %op4 = icmp slt i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -26
# br i1 %op4, label %label5, label %label6
	ld.b $t0, $fp, -26
	bnez $t0, .main_label5
	beqz $t0, .main_label6
.main_label5:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 64
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label6:
# %op7 = getelementptr [1 x i32], [1 x i32]* @y, i32 0, i32 0
	la.local $t0, y
	addi.w $t2, $zero, 0
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -34
# store i32 18, i32* %op7
	ld.d $t0, $fp, -34
	addi.w $t1, $zero, 18
	st.w $t1, $t0, 0
# %op8 = getelementptr [1 x i32], [1 x i32]* @x, i32 0, i32 0
	la.local $t0, x
	addi.w $t2, $zero, 0
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -42
# %op9 = getelementptr [1 x i32], [1 x i32]* @y, i32 0, i32 0
	la.local $t0, y
	addi.w $t2, $zero, 0
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -50
# %op10 = call i32 @funArray(i32* %op8, i32* %op9)
	ld.d $a0, $fp, -42
	ld.d $a1, $fp, -50
	bl funArray
	st.w $a0, $fp, -54
# ret i32 %op10
	ld.w $a0, $fp, -54
	addi.d $sp, $sp, 64
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 64
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
