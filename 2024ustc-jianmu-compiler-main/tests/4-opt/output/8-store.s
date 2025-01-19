	.text
	.globl store
	.type store, @function
store:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -48
	st.d $a0, $fp, -24
	st.w $a1, $fp, -28
	st.w $a2, $fp, -32
.store_label_entry:
# %op8 = icmp slt i32 %arg1, 0
	ld.w $t0, $fp, -28
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -33
# br i1 %op8, label %label9, label %label10
	ld.b $t0, $fp, -33
	bnez $t0, .store_label9
	beqz $t0, .store_label10
.store_label9:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 48
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.store_label10:
# %op12 = getelementptr i32, i32* %arg0, i32 %arg1
	ld.d $t0, $fp, -24
	ld.w $t2, $fp, -28
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -41
# store i32 %arg2, i32* %op12
	ld.d $t0, $fp, -41
	ld.w $t1, $fp, -32
	st.w $t1, $t0, 0
# ret i32 %arg2
	ld.w $a0, $fp, -32
	addi.d $sp, $sp, 48
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 48
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
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
# br label %label3
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -68
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -68
	b .main_label3
.main_label3:
# %op35 = phi i32 [ 0, %label_entry ], [ %op15, %label8 ]
# %op5 = icmp slt i32 %op35, 10
	ld.w $t0, $fp, -68
	addi.w $t1, $zero, 10
	slt $t2, $t0, $t1
	st.b $t2, $fp, -69
# %op6 = zext i1 %op5 to i32
	ld.b $t0, $fp, -69
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -73
# %op7 = icmp ne i32 %op6, 0
	ld.w $t0, $fp, -73
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -74
# br i1 %op7, label %label8, label %label16
	ld.b $t0, $fp, -74
	bnez $t0, .main_label8
	beqz $t0, .main_label16
.main_label8:
# %op9 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 0
	ld.d $t0, $fp, -24
	addi.w $t2, $zero, 0
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -82
# %op12 = mul i32 %op35, 2
	ld.w $t0, $fp, -68
	addi.w $t1, $zero, 2
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -86
# %op13 = call i32 @store(i32* %op9, i32 %op35, i32 %op12)
	ld.d $a0, $fp, -82
	ld.w $a1, $fp, -68
	ld.w $a2, $fp, -86
	bl store
	st.w $a0, $fp, -90
# %op15 = add i32 %op35, 1
	ld.w $t0, $fp, -68
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -94
# br label %label3
	ld.w $a0, $fp, -94
	st.w $a0, $fp, -68
	ld.w $a0, $fp, -94
	st.w $a0, $fp, -68
	b .main_label3
.main_label16:
# br label %label17
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -98
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -102
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -98
	addi.w $a0, $zero, 0
	st.w $a0, $fp, -102
	b .main_label17
.main_label17:
# %op36 = phi i32 [ 0, %label16 ], [ %op32, %label29 ]
# %op37 = phi i32 [ 0, %label16 ], [ %op34, %label29 ]
# %op19 = icmp slt i32 %op37, 10
	ld.w $t0, $fp, -102
	addi.w $t1, $zero, 10
	slt $t2, $t0, $t1
	st.b $t2, $fp, -103
# %op20 = zext i1 %op19 to i32
	ld.b $t0, $fp, -103
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -107
# %op21 = icmp ne i32 %op20, 0
	ld.w $t0, $fp, -107
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	add.w $t2, $t2, $t3
	st.b $t2, $fp, -108
# br i1 %op21, label %label22, label %label26
	ld.b $t0, $fp, -108
	bnez $t0, .main_label22
	beqz $t0, .main_label26
.main_label22:
# %op25 = icmp slt i32 %op37, 0
	ld.w $t0, $fp, -102
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	st.b $t2, $fp, -109
# br i1 %op25, label %label28, label %label29
	ld.b $t0, $fp, -109
	bnez $t0, .main_label28
	beqz $t0, .main_label29
.main_label26:
# call void @output(i32 %op36)
	ld.w $a0, $fp, -98
	bl output
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label28:
# call void @neg_idx_except()
	bl neg_idx_except
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label29:
# %op30 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 %op37
	ld.d $t0, $fp, -24
	ld.w $t2, $fp, -102
	addi.d $t1, $zero, 4
	mul.d $t1, $t2, $t1
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -117
# %op31 = load i32, i32* %op30
	ld.d $t0, $fp, -117
	ld.w $t1, $t0, 0
	st.w $t1, $fp, -121
# %op32 = add i32 %op36, %op31
	ld.w $t0, $fp, -98
	ld.w $t1, $fp, -121
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -125
# %op34 = add i32 %op37, 1
	ld.w $t0, $fp, -102
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -129
# br label %label17
	ld.w $a0, $fp, -125
	st.w $a0, $fp, -98
	ld.w $a0, $fp, -129
	st.w $a0, $fp, -102
	ld.w $a0, $fp, -125
	st.w $a0, $fp, -98
	ld.w $a0, $fp, -129
	st.w $a0, $fp, -102
	b .main_label17
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
