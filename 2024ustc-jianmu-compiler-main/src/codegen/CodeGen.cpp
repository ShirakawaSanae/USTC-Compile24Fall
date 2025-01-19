#include "CodeGen.hpp"

#include "CodeGenUtil.hpp"

void CodeGen::allocate() {
    // 备份 $ra $fp
    unsigned offset = PROLOGUE_OFFSET_BASE;

    // 为每个参数分配栈空间
    for (auto &arg : context.func->get_args()) {
        auto size = arg.get_type()->get_size();
        offset = offset + size;
        context.offset_map[&arg] = -static_cast<int>(offset);
    }

    // 为指令结果分配栈空间
    for (auto &bb : context.func->get_basic_blocks()) {
        for (auto &instr : bb.get_instructions()) {
            // 每个非 void 的定值都分配栈空间
            if (not instr.is_void()) {
                auto size = instr.get_type()->get_size();
                offset = offset + size;
                context.offset_map[&instr] = -static_cast<int>(offset);
            }
            // alloca 的副作用：分配额外空间
            if (instr.is_alloca()) {
                auto *alloca_inst = static_cast<AllocaInst *>(&instr);
                auto alloc_size = alloca_inst->get_alloca_type()->get_size();
                offset += alloc_size;
            }
        }
    }

    // 分配栈空间，需要是 16 的整数倍
    context.frame_size = ALIGN(offset, PROLOGUE_ALIGN);
}

void CodeGen::copy_stmt() {
    for (auto &succ : context.bb->get_succ_basic_blocks()) {
        for (auto &inst : succ->get_instructions()) {
            if (inst.is_phi()) {
                // 遍历后继块中 phi 的定值 bb
                for (unsigned i = 1; i < inst.get_operands().size(); i += 2) {
                    // phi 的定值 bb 是当前翻译块
                    if (inst.get_operand(i) == context.bb) {
                        auto *lvalue = inst.get_operand(i - 1);
                        if (lvalue->get_type()->is_float_type()) {
                            load_to_freg(lvalue, FReg::fa(0));
                            store_from_freg(&inst, FReg::fa(0));
                        } else {
                            load_to_greg(lvalue, Reg::a(0));
                            store_from_greg(&inst, Reg::a(0));
                        }
                        break;
                    }
                    // 如果没有找到当前翻译块，说明是 undef，无事可做
                }
            } else {
                break;
            }
        }
    }
}

void CodeGen::load_to_greg(Value *val, const Reg &reg) {
    assert(val->get_type()->is_integer_type() ||
           val->get_type()->is_pointer_type());

    if (auto *constant = dynamic_cast<ConstantInt *>(val)) {
        int32_t val = constant->get_value();
        if (IS_IMM_12(val)) {
            append_inst(ADDI WORD, {reg.print(), "$zero", std::to_string(val)});
        } else {
            load_large_int32(val, reg);
        }
    } else if (auto *global = dynamic_cast<GlobalVariable *>(val)) {
        append_inst(LOAD_ADDR, {reg.print(), global->get_name()});
    } else {
        load_from_stack_to_greg(val, reg);
    }
}

void CodeGen::load_large_int32(int32_t val, const Reg &reg) {
    int32_t high_20 = val >> 12; // si20
    uint32_t low_12 = val & LOW_12_MASK;
    append_inst(LU12I_W, {reg.print(), std::to_string(high_20)});
    append_inst(ORI, {reg.print(), reg.print(), std::to_string(low_12)});
}

void CodeGen::load_large_int64(int64_t val, const Reg &reg) {
    auto low_32 = static_cast<int32_t>(val & LOW_32_MASK);
    load_large_int32(low_32, reg);

    auto high_32 = static_cast<int32_t>(val >> 32);
    int32_t high_32_low_20 = (high_32 << 12) >> 12; // si20
    int32_t high_32_high_12 = high_32 >> 20;        // si12
    append_inst(LU32I_D, {reg.print(), std::to_string(high_32_low_20)});
    append_inst(LU52I_D,
                {reg.print(), reg.print(), std::to_string(high_32_high_12)});
}

void CodeGen::load_from_stack_to_greg(Value *val, const Reg &reg) {
    auto offset = context.offset_map.at(val);
    auto offset_str = std::to_string(offset);
    auto *type = val->get_type();
    if (IS_IMM_12(offset)) {
        if (type->is_int1_type()) {
            append_inst(LOAD BYTE, {reg.print(), "$fp", offset_str});
        } else if (type->is_int32_type()) {
            append_inst(LOAD WORD, {reg.print(), "$fp", offset_str});
        } else { // Pointer
            append_inst(LOAD DOUBLE, {reg.print(), "$fp", offset_str});
        }
    } else {
        load_large_int64(offset, reg);
        append_inst(ADD DOUBLE, {reg.print(), "$fp", reg.print()});
        if (type->is_int1_type()) {
            append_inst(LOAD BYTE, {reg.print(), reg.print(), "0"});
        } else if (type->is_int32_type()) {
            append_inst(LOAD WORD, {reg.print(), reg.print(), "0"});
        } else { // Pointer
            append_inst(LOAD DOUBLE, {reg.print(), reg.print(), "0"});
        }
    }
}

void CodeGen::store_from_greg(Value *val, const Reg &reg) {
    auto offset = context.offset_map.at(val);
    auto offset_str = std::to_string(offset);
    auto *type = val->get_type();
    if (IS_IMM_12(offset)) {
        if (type->is_int1_type()) {
            append_inst(STORE BYTE, {reg.print(), "$fp", offset_str});
        } else if (type->is_int32_type()) {
            append_inst(STORE WORD, {reg.print(), "$fp", offset_str});
        } else { // Pointer
            append_inst(STORE DOUBLE, {reg.print(), "$fp", offset_str});
        }
    } else {
        auto addr = Reg::t(8);
        load_large_int64(offset, addr);
        append_inst(ADD DOUBLE, {addr.print(), "$fp", addr.print()});
        if (type->is_int1_type()) {
            append_inst(STORE BYTE, {reg.print(), addr.print(), "0"});
        } else if (type->is_int32_type()) {
            append_inst(STORE WORD, {reg.print(), addr.print(), "0"});
        } else { // Pointer
            append_inst(STORE DOUBLE, {reg.print(), addr.print(), "0"});
        }
    }
}

void CodeGen::load_to_freg(Value *val, const FReg &freg) {
    assert(val->get_type()->is_float_type());
    if (auto *constant = dynamic_cast<ConstantFP *>(val)) {
        float val = constant->get_value();
        load_float_imm(val, freg);
    } else {
        auto offset = context.offset_map.at(val);
        auto offset_str = std::to_string(offset);
        if (IS_IMM_12(offset)) {
            append_inst(FLOAD SINGLE, {freg.print(), "$fp", offset_str});
        } else {
            auto addr = Reg::t(8);
            load_large_int64(offset, addr);
            append_inst(ADD DOUBLE, {addr.print(), "$fp", addr.print()});
            append_inst(FLOAD SINGLE, {freg.print(), addr.print(), "0"});
        }
    }
}

void CodeGen::load_float_imm(float val, const FReg &r) {
    int32_t bytes = *reinterpret_cast<int32_t *>(&val);
    load_large_int32(bytes, Reg::t(8));
    append_inst(GR2FR WORD, {r.print(), Reg::t(8).print()});
}

void CodeGen::store_from_freg(Value *val, const FReg &r) {
    auto offset = context.offset_map.at(val);
    if (IS_IMM_12(offset)) {
        auto offset_str = std::to_string(offset);
        append_inst(FSTORE SINGLE, {r.print(), "$fp", offset_str});
    } else {
        auto addr = Reg::t(8);
        load_large_int64(offset, addr);
        append_inst(ADD DOUBLE, {addr.print(), "$fp", addr.print()});
        append_inst(FSTORE SINGLE, {r.print(), addr.print(), "0"});
    }
}

void CodeGen::gen_prologue() {
    if (IS_IMM_12(-static_cast<int>(context.frame_size))) {
        append_inst("st.d $ra, $sp, -8");
        append_inst("st.d $fp, $sp, -16");
        append_inst("addi.d $fp, $sp, 0");
        append_inst("addi.d $sp, $sp, " +
                    std::to_string(-static_cast<int>(context.frame_size)));
    } else {
        load_large_int64(context.frame_size, Reg::t(0));
        append_inst("st.d $ra, $sp, -8");
        append_inst("st.d $fp, $sp, -16");
        append_inst("sub.d $sp, $sp, $t0");
        append_inst("add.d $fp, $sp, $t0");
    }

    int garg_cnt = 0;
    int farg_cnt = 0;
    for (auto &arg : context.func->get_args()) {
        if (arg.get_type()->is_float_type()) {
            store_from_freg(&arg, FReg::fa(farg_cnt++));
        } else { // int or pointer
            store_from_greg(&arg, Reg::a(garg_cnt++));
        }
    }
}

void CodeGen::gen_epilogue() {
    // TODO: 根据你的理解设定函数的 epilogue
    // main_exit:
    // # epilogue
    // addi.d $sp, $sp, 32
    // ld.d $ra, $sp, -8
    // ld.d $fp, $sp, -16
    // jr $ra
    if (IS_IMM_12(-static_cast<int>(context.frame_size))) {
        append_inst("addi.d $sp, $sp, " +
                    std::to_string(static_cast<int>(context.frame_size)));
        append_inst("ld.d $ra, $sp, -8");
        append_inst("ld.d $fp, $sp, -16");
        append_inst("jr $ra");
    } else {
        load_large_int64(context.frame_size, Reg::t(0));
        append_inst("add.d $fp, $sp, $t0");
        append_inst("ld.d $ra, $sp, -8");
        append_inst("ld.d $fp, $sp, -16");
        append_inst("jr $ra");
    }
}


void CodeGen::gen_ret() {
    // TODO: 函数返回，思考如何处理返回值、寄存器备份，如何返回调用者地址
    // 如果返回值类型时整数类型（指针或者整型），则返回值放入 $a0 中
    // 如果返回值类型时浮点数类型，则返回值放入 $fa0 中
    /*phase1 : translate callee:
        / ret i32 %op3 
        codegen->append_inst("ret i32 %op3", ASMInstruction::Comment);
        // 将 %op3 的值写入 $a0 中
        codegen->append_inst("ld.w",
                            {"$a0", "$fp", std::to_string(offset_map["%op3"])});
        codegen->append_inst("b callee_exit");

        / callee 函数的 Epilogue (收尾) 
        codegen->append_inst("callee_exit", ASMInstruction::Label);
        // 释放栈帧空间
        codegen->append_inst("addi.d $sp, $sp, 48");
        // 恢复 ra
        codegen->append_inst("ld.d $ra, $sp, -8");
        // 恢复 fp
        codegen->append_inst("ld.d $fp, $sp, -16");
        // 返回
        codegen->append_inst("jr $ra");
    */
    auto ret_type = context.func -> get_return_type();
    if(ret_type -> is_float_type()) {
        auto *ret_val = context.inst -> get_operand(0);
        load_to_freg(ret_val, FReg::fa(0));
    }
    else if(ret_type -> is_int32_type()) {
        auto *ret_val = context.inst -> get_operand(0);
        load_to_greg(ret_val, Reg::a(0));
    }
    else  append_inst("addi.w $a0, $zero, 0");

    gen_epilogue();
}
/*
    bool is_cond_br() const { return get_num_operand() == 3; }
       Value *get_condition() const { return get_operand(0); }

    beqz：对通用寄存器 $rj 的值进行判断，如果等于 0 则跳转到目标地址，否则不跳转
    bnez：对通用寄存器 $rj 的值进行判断，如果不等于 0 则跳转到目标地址，否则不跳转
*/
void CodeGen::gen_br() {
    copy_stmt();
    auto *branchInst = static_cast<BranchInst *>(context.inst);
    if (branchInst->is_cond_br()) { // conditional
        // TODO: 补全条件跳转的情况
        if(context.func -> get_return_type() -> is_float_type()){
            auto *ptr = branchInst -> get_condition();
            load_to_greg(ptr, Reg::t(0));

            auto *truebb = static_cast<BasicBlock *>(branchInst -> get_operand(1));
            auto *falsebb = static_cast<BasicBlock *>(branchInst -> get_operand(2));

            //auto *type = context.inst -> get_instr_type();
            append_inst("bcnez $fcc0, " + label_name(truebb));
            append_inst("bceqz $fcc0, " + label_name(falsebb));

        }
        else {
            auto *ptr = branchInst -> get_condition();
            load_to_greg(ptr, Reg::t(0));

            auto *truebb = static_cast<BasicBlock *>(branchInst -> get_operand(1));
            auto *falsebb = static_cast<BasicBlock *>(branchInst -> get_operand(2));

            //auto *type = context.inst -> get_instr_type();
            append_inst("bnez $t0, " + label_name(truebb));
            append_inst("beqz $t0, " + label_name(falsebb));
        }
        
    } else { // unconditional
        auto *branchbb = static_cast<BasicBlock *>(branchInst->get_operand(0));
        append_inst("b " + label_name(branchbb));
    }
}

void CodeGen::gen_binary() {
    load_to_greg(context.inst->get_operand(0), Reg::t(0));
    load_to_greg(context.inst->get_operand(1), Reg::t(1));
    switch (context.inst->get_instr_type()) {
    case Instruction::add:
        output.emplace_back("add.w $t2, $t0, $t1");
        break;
    case Instruction::sub:
        output.emplace_back("sub.w $t2, $t0, $t1");
        break;
    case Instruction::mul:
        output.emplace_back("mul.w $t2, $t0, $t1");
        break;
    case Instruction::sdiv:
        output.emplace_back("div.w $t2, $t0, $t1");
        break;
    default:
        assert(false);
    }
    store_from_greg(context.inst, Reg::t(2));
}
/*
        bool isBinary() const {
        return (is_add() || is_sub() || is_mul() || is_div() || is_fadd() ||
                is_fsub() || is_fmul() || is_fdiv()) &&
               (get_num_operand() == 2);
    }
*/
void CodeGen::gen_float_binary() {
    // TODO: 浮点类型的二元指令
    load_to_freg(context.inst -> get_operand(0), FReg::ft(0));
    load_to_freg(context.inst -> get_operand(1), FReg::ft(1));
    switch(context.inst -> get_instr_type()){
        case Instruction::fadd:
            output.emplace_back("fadd.s $ft2, $ft0, $ft1");
            break;
        case Instruction::fsub:
            output.emplace_back("fsub.s $ft2, $ft0, $ft1");
            break;
        case Instruction::fmul:
            output.emplace_back("fmul.s $ft2, $ft0, $ft1");
            break;
        case Instruction::fdiv:
            output.emplace_back("fdiv.s $ft2, $ft0, $ft1");
            break;
        default:
            assert(false);
        }
    store_from_freg(context.inst, FReg::ft(2));
    // 貌似 store 都是 context.inst
}

void CodeGen::gen_alloca() {
    /* 我们已经为 alloca 的内容分配空间，在此我们还需保存 alloca
     * 指令自身产生的定值，即指向 alloca 空间起始地址的指针
     */
    // TODO: 将 alloca 出空间的起始地址保存在栈帧上
    // 参考 CodeGen::allocate()
    auto offset = context.offset_map[context.inst];
    auto *alloca_inst = static_cast<AllocaInst *>(context.inst);
    auto alloc_size = alloca_inst -> get_alloca_type() -> get_size();
    offset = static_cast<int>(offset - alloc_size);
    append_inst("addi.d $t0, $fp, " + std::to_string(offset));
    store_from_greg(context.inst, Reg::t(0));
}
/*
ld.b $rd, $rj, si12 --1byte
ld.h $rd, $rj, si12 --2bytes
ld.w $rd, $rj, si12 --4bytes
ld.d $rd, $rj, si12 --8bytes
从内存加载到寄存器
*/
void CodeGen::gen_load() {
    auto *ptr = context.inst->get_operand(0);
    auto *type = context.inst->get_type();
    load_to_greg(ptr, Reg::t(0));

    if (type->is_float_type()) { // 因为没有 double 所以不用 fld.d 吗。。。hhx //
        append_inst("fld.s $ft0, $t0, 0");
        store_from_freg(context.inst, FReg::ft(0));
    } else {
        // TODO: load 整数类型的数据
        //if(type -> is_integer_type()) append_inst("ld.w, $t1, $t0, 0"); 
        if(type -> is_int32_type()) append_inst("ld.w $t1, $t0, 0");
        else if(type -> is_int1_type()) append_inst("ld.b $t1, $t0, 0");
        else append_inst("ld.d $t1, $t0, 0");
        store_from_greg(context.inst, Reg::t(1));
    }
}
/*
st.b $rd, $rj, si12
st.h $rd, $rj, si12
st.w $rd, $rj, si12
st.d $rd, $rj, si12

  问题：是否需要zext?
从寄存器写到内存
*/
void CodeGen::gen_store() {
    // TODO: 翻译 store 指令
    auto *ptr = context.inst -> get_operand(1); 
    auto *dst = context.inst -> get_operand(0);
    auto *type = dst -> get_type();
    load_to_greg(ptr, Reg::t(0));
    if(type -> is_float_type()){
        load_to_freg(dst, FReg::ft(0));
        append_inst("fst.s $ft0, $t0, 0");
    }
    else {
        load_to_greg(dst, Reg::t(1));
        if(type -> is_int32_type()) append_inst("st.w $t1, $t0, 0");
        else if(type -> is_int1_type()) append_inst("st.b $t1, $t0, 0");
        else append_inst("st.d $t1, $t0, 0");
    }
}

/*
slt  $rd, $rj, $rk   前者小于后者：1 否则：0
sltu $rd, $rj, $rk
slti  $rd, $rj, si12
sltui $rd, $rj, si12

    示例 2
*/
void CodeGen::gen_icmp() {
    // TODO: 处理各种整数比较的情况
    // 1 比较成立，0 比较不成立（trueBB falseBB）， 在 gen_br 有用
    auto *ptr0 = context.inst->get_operand(0);
    auto *ptr1 = context.inst->get_operand(1);
    load_to_greg(ptr0, Reg::t(0));
    load_to_greg(ptr1, Reg::t(1));
    switch (context.inst->get_instr_type())
    {
        case Instruction::ge: // bge：slt 0 xori 1, t0 >= t1
        {
            append_inst("slt $t2, $t0, $t1");
            append_inst("xori $t2, $t2, 1");
            store_from_greg(context.inst, Reg::t(2));
            break;
        }
        case Instruction::gt: // bgt: 交换位置然后 slt 1, t0 > t1
        {
            append_inst("slt $t2, $t1, $t0");
            store_from_greg(context.inst, Reg::t(2));
            break;
        }
        case Instruction::le: // ble: 交换位置然后 slt, 0, xori 1, t0 <= t1
        {
            append_inst("slt $t2, $t1, $t0");
            append_inst("xori $t2, $t2, 1");
            store_from_greg(context.inst, Reg::t(2));
            break;
        }
        case Instruction::lt: // blt: slt 1 
        {
            append_inst("slt $t2, $t0, $t1");
            store_from_greg(context.inst, Reg::t(2));
            break;
        }
        case Instruction::eq: // 两个方向计算都是 0
        {
            append_inst("slt $t2, $t0, $t1");
            append_inst("slt $t3, $t1, $t0");
            append_inst("add.w $t2, $t2, $t3");
            append_inst("xori $t2, $t2, 1");
            store_from_greg(context.inst, Reg::t(2));
            break;
        }
        case Instruction::ne: // 两个方向计算加起来是 1
        {
            append_inst("slt $t2, $t0, $t1");
            append_inst("slt $t3, $t1, $t0");
            append_inst("add.w $t2, $t2, $t3");
            store_from_greg(context.inst, Reg::t(2));
            break;
        }
        default:
            break;
    }
}
/*
                    case Instruction::fge:
                    case Instruction::fgt:
                    case Instruction::fle:
                    case Instruction::flt:
                    case Instruction::feq:
                    case Instruction::fne:
    seq 0x5	相等	$fj == $fk
    sne 0x11不等	$fj > $fk 或 $fj < $fk
    slt 0x3	小于	$fj < $fk
    sle 0x7	小于等于	$fj <= $fk

    先比较，比较结果对应的 cond 值存入 $fccd?
    示例 4

    fcmp.slt.s $fcc0, $ft0, $ft1 # $fcc0 = ($ft0 < $ft1) ? 1 : 0
    bceqz   $fcc0, .L1           # 如果 $fcc0 等于 0, 则跳转到 .L1 处
    addi.w  $t2, $zero, 1        # $t2 = 1
    b   .L2
*/
void CodeGen::gen_fcmp() {
    // TODO: 处理各种浮点数比较的情况
    auto *ptr0 = context.inst -> get_operand(0);
    auto *ptr1 = context.inst -> get_operand(1);
    load_to_freg(ptr0, FReg::ft(0));
    load_to_freg(ptr1, FReg::ft(1));
    switch(context.inst -> get_instr_type()){
        case Instruction::fge: // ge = swap + sle
        {
            append_inst("fcmp.sle.s $fcc0, $ft1, $ft0");
            // fccd 无法直接传到 gen_br，这里要手动跳转？
            //append_inst("bcnez $fcc0, 0"); // 非零则跳转
            break;
        }
        case Instruction::fgt: // gt = swap + slt
        {
            append_inst("fcmp.slt.s $fcc0, $ft1, $ft0");
            break;
        }
        case Instruction::fle: // le
        {
            append_inst("fcmp.sle.s $fcc0, $ft0, $ft1");
            break;
        }
        case Instruction::flt: // lt
        {
            append_inst("fcmp.slt.s $fcc0, $ft0, $ft1");
            break;
        }
        case Instruction::feq: // eq
        {
            append_inst("fcmp.seq.s $fcc0, $ft0, $ft1");
            break;
        }
        case Instruction::fne: // ne
        {
            append_inst("fcmp.sne.s $fcc0, $ft0, $ft1");
            break;
        }
        default:
            break;
    }
    
    store_from_greg(context.inst, Reg::t(0));
}
/*
bstrpick.w $rd, $rj, msbw, lsbw
bstrpick.d $rd, $rj, msbd, lsbd
bstrpick.w：提取通用寄存器 $rj 中 [msbw:lsbw] 位零扩展至 32 位，所形成 32 位中间结果符号扩展后写入通用寄存器 $rd 中
*/
void CodeGen::gen_zext() {
    // TODO: 将窄位宽的整数数据进行零扩展
    auto *ptr = context.inst -> get_operand(0);
    auto *type_j = ptr -> get_type();
    auto *type_d = context.inst -> get_type();
    load_to_greg(ptr, Reg::t(0));

    if(type_d -> is_int32_type()){
        append_inst("bstrpick.w $t0, $t0, 0, 0");
        store_from_greg(context.inst, Reg::t(0));
    }
    else{
        if (type_j -> is_int1_type()){
            append_inst("bstrpick.d $t0, $t0, 3, 0");
            store_from_greg(context.inst, Reg::t(0));
        }
        else if (type_j -> is_int32_type()){
            append_inst("bstrpick.d $t0, $t0, 31, 0");
            store_from_greg(context.inst, Reg::t(0));
        }
    }
}

/*
    以例子 3 的 c = add(1, 2) 为例：
    addi.w  $a0, $zero, 1   # 设置第一个参数
    addi.w  $a1, $zero, 2   # 设置第二个参数
    bl  add                 # 调用 add 函数
    bl  output              # 输出结果
*/
void CodeGen::gen_call() {
    // TODO: 函数调用，注意我们只需要通过寄存器传递参数，即不需考虑栈上传参的情况
    int arg_num = context.inst->get_num_operand();
    // append_inst("addi.w $zero, $zero, "+std::to_string(num));
    int garg_cnt = 0;
    int farg_cnt = 0;
    for(unsigned int i = 1; i < arg_num; i++){
        // 设置参数
        auto *ptr = context.inst->get_operand(i);
        if(ptr->get_type()->is_float_type()){
            load_to_freg(ptr, FReg::fa(farg_cnt++));
        }
        else{
            load_to_greg(ptr, Reg::a(garg_cnt++));
        }
    }
    auto *func = context.inst->get_operand(0);
    append_inst("bl " + func->get_name());

    // 储存返回值到默认寄存器
    if(context.inst->get_type()->is_float_type()){
        store_from_freg(context.inst, FReg::fa(0));
    }
    else if(context.inst->get_type()->is_integer_type()){
        store_from_greg(context.inst, Reg::a(0));
    }
}

/*
 * %op = getelementptr [10 x i32], [10 x i32]* %op, i32 0, i32 %op
 * %op = getelementptr        i32,        i32* %op, i32 %op
 *
 * Memory layout
 *       -            ^
 * +-----------+      | Smaller address
 * |  arg ptr  |---+  |
 * +-----------+   |  |
 * |           |   |  |
 * +-----------+   /  |
 * |           |<--   |
 * |           |   \  |
 * |           |   |  |
 * |   Array   |   |  |
 * |           |   |  |
 * |           |   |  |
 * |           |   |  |
 * +-----------+   |  |
 * |  Pointer  |---+  |
 * +-----------+      |
 * |           |      |
 * +-----------+      |
 * |           |      |
 * +-----------+      |
 * |           |      |
 * +-----------+      | Larger address
 *       +
 *
    
    如果按照 op0 op2 操作，会报错：
    ==========./testcases/8-store.cminus==========
    terminate called after throwing an instance of 'std::out_of_range'
    what():  vector::_M_range_check: __n (which is 2) >= this->size() (which is 2)


*/
void CodeGen::gen_gep() {
    // TODO: 计算内存地址
    auto siz = context.inst -> get_num_operand();
   
   // printf("op num = %d\n", siz);
   
    if(siz == 3){
        auto *ptr = context.inst->get_operand(0);
        load_to_greg(ptr, Reg::t(0));
        // auto *src = context.inst->get_operand(1);
        // load_to_greg(src, Reg::t(1));
        auto *num = context.inst->get_operand(2);
        load_to_greg(num, Reg::t(2));
    }
    else if(siz == 2){
        auto *ptr = context.inst->get_operand(0);
        load_to_greg(ptr, Reg::t(0));
        auto *num = context.inst->get_operand(1);
        // load_to_greg(src, Reg::t(1));
        //auto *num = context.inst->get_operand(2);
        load_to_greg(num, Reg::t(2));
    }
    
    append_inst("addi.d $t1, $zero, 4");
    append_inst("mul.d $t1, $t2, $t1");
    append_inst("add.d $t0, $t0, $t1");
    
    store_from_greg(context.inst, Reg::t(0));
}
/*
    使用 movgr2fr.w 指令后，浮点寄存器 $fd 的 [63:32] 位值不确定??
*/
void CodeGen::gen_sitofp() {
    // TODO: 整数转向浮点数
    auto *ptr = context.inst->get_operand(0);
    load_to_greg(ptr, Reg::t(0));
    append_inst("movgr2fr.w $ft1, $t0"); // zext 不能用，浮点型寄存器
    append_inst("ffint.s.w $ft0, $ft1");
    store_from_freg(context.inst, FReg::ft(0));
}
/*
    # 这里省略了一系列伪指令
    a:
        .space 4 # 申请 4 字节空间存储 a 的值
    # ...
        la.local    $t1, a       # 将 a 的地址载入 $t1
        fld.s       $ft0, $t1, 0 # 将 a 的值载入 $ft0
        ftintrz.w.s $ft1, $ft0   # $ft1 = (int)a
        movfr2gr.s  $t0, $ft1    # 将 $ft1 的数据载入 $t0 中
*/
void CodeGen::gen_fptosi()
{
    // TODO: 浮点数转向整数，注意向下取整(round to zero)
    auto *ptr = context.inst->get_operand(0);
    load_to_freg(ptr, FReg::ft(0));
    append_inst("ftintrz.w.s $ft1, $ft0");
    append_inst("movfr2gr.s $t0, $ft1");
    store_from_greg(context.inst, Reg::t(0));
}

void CodeGen::run() {
    // 确保每个函数中基本块的名字都被设置好
    m->set_print_name();

    /* 使用 GNU 伪指令为全局变量分配空间
     * 你可以使用 `la.local` 指令将标签 (全局变量) 的地址载入寄存器中, 比如
     * 要将 `a` 的地址载入 $t0, 只需要 `la.local $t0, a`
     */
    if (!m->get_global_variable().empty()) {
        append_inst("Global variables", ASMInstruction::Comment);
        /* 虽然下面两条伪指令可以简化为一条 `.bss` 伪指令, 但是我们还是选择使用
         * `.section` 将全局变量放到可执行文件的 BSS 段, 原因如下:
         * - 尽可能对齐交叉编译器 loongarch64-unknown-linux-gnu-gcc 的行为
         * - 支持更旧版本的 GNU 汇编器, 因为 `.bss` 伪指令是应该相对较新的指令,
         *   GNU 汇编器在 2023 年 2 月的 2.37 版本才将其引入
         */
        append_inst(".text", ASMInstruction::Atrribute);
        append_inst(".section", {".bss", "\"aw\"", "@nobits"},
                    ASMInstruction::Atrribute);
        for (auto &global : m->get_global_variable()) {
            auto size =
                global.get_type()->get_pointer_element_type()->get_size();
            append_inst(".globl", {global.get_name()},
                        ASMInstruction::Atrribute);
            append_inst(".type", {global.get_name(), "@object"},
                        ASMInstruction::Atrribute);
            append_inst(".size", {global.get_name(), std::to_string(size)},
                        ASMInstruction::Atrribute);
            append_inst(global.get_name(), ASMInstruction::Label);
            append_inst(".space", {std::to_string(size)},
                        ASMInstruction::Atrribute);
        }
    }

    // 函数代码段
    output.emplace_back(".text", ASMInstruction::Atrribute);
    for (auto &func : m->get_functions()) {
        if (not func.is_declaration()) {
            // 更新 context
            context.clear();
            context.func = &func;

            // 函数信息
            append_inst(".globl", {func.get_name()}, ASMInstruction::Atrribute);
            append_inst(".type", {func.get_name(), "@function"},
                        ASMInstruction::Atrribute);
            append_inst(func.get_name(), ASMInstruction::Label);

            // 分配函数栈帧
            allocate();
            // 生成 prologue
            gen_prologue();

            for (auto &bb : func.get_basic_blocks()) {
                context.bb = &bb;
                append_inst(label_name(context.bb), ASMInstruction::Label);
                for (auto &instr : bb.get_instructions()) {
                    // For debug
                    append_inst(instr.print(), ASMInstruction::Comment);
                    context.inst = &instr; // 更新 context
                    switch (instr.get_instr_type()) {
                    case Instruction::ret:
                        gen_ret();
                        break;
                    case Instruction::br:
                        copy_stmt();
                        gen_br();
                        break;
                    case Instruction::add:
                    case Instruction::sub:
                    case Instruction::mul:
                    case Instruction::sdiv:
                        gen_binary();
                        break;
                    case Instruction::fadd:
                    case Instruction::fsub:
                    case Instruction::fmul:
                    case Instruction::fdiv:
                        gen_float_binary();
                        break;
                    case Instruction::alloca:
                        /* 对于 alloca 指令，我们已经为 alloca
                         * 的内容分配空间，在此我们还需保存 alloca
                         * 指令自身产生的定值，即指向 alloca 空间起始地址的指针
                         */
                        gen_alloca();
                        break;
                    case Instruction::load:
                        gen_load();
                        break;
                    case Instruction::store:
                        gen_store();
                        break;
                    case Instruction::ge:
                    case Instruction::gt:
                    case Instruction::le:
                    case Instruction::lt:
                    case Instruction::eq:
                    case Instruction::ne:
                        gen_icmp();
                        break;
                    case Instruction::fge:
                    case Instruction::fgt:
                    case Instruction::fle:
                    case Instruction::flt:
                    case Instruction::feq:
                    case Instruction::fne:
                        gen_fcmp();
                        break;
                    case Instruction::phi:
                        /* for phi, just convert to a series of
                         * copy-stmts */
                        /* we can collect all phi and deal them at
                         * the end */
                        {
                           ;   
                        }
                        break;
                    case Instruction::call:
                        gen_call();
                        break;
                    case Instruction::getelementptr:
                        gen_gep();
                        break;
                    case Instruction::zext:
                        gen_zext();
                        break;
                    case Instruction::fptosi:
                        gen_fptosi();
                        break;
                    case Instruction::sitofp:
                        gen_sitofp();
                        break;
                    }
                }
            }
            // 生成 epilogue
            gen_epilogue();
        }
    }
}

std::string CodeGen::print() const {
    std::string result;
    for (const auto &inst : output) {
        result += inst.format();
    }
    return result;
}
