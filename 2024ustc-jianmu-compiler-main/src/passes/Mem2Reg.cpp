

#include "Mem2Reg.hpp"
#include "IRBuilder.hpp"
#include "Value.hpp"
#include "logging.hpp"
#include <memory>

/**
 * @brief Mem2Reg Pass的主入口函数
 * 
 * 该函数执行内存到寄存器的提升过程，将栈上的局部变量提升到SSA格式。
 * 主要步骤：
 * 1. 创建并运行支配树分析
 * 2. 对每个非声明函数：
 *    - 清空相关数据结构
 *    - 插入必要的phi指令
 *    - 执行变量重命名
 * 
 * 注意：函数执行后，冗余的局部变量分配指令将由后续的死代码删除Pass处理
 */
void Mem2Reg::run() {
   //  LOG(DEBUG) << "mem2reg run\n";
    // 创建支配树分析 Pass 的实例
    dominators_ = std::make_unique<Dominators>(m_);
    // 建立支配树
    dominators_->run();
   //  LOG(DEBUG) << "dom_tree ok, back to mem2reg\n";
    // 以函数为单元遍历实现 Mem2Reg 算法
    for (auto &f : m_->get_functions()) {
        if (f.is_declaration())
            continue;
        func_ = &f;
        // notice these stacks in hpp //
        var_val_stack.clear();
        phi_lval.clear();
        if (func_->get_basic_blocks().size() >= 1) {
            // 对应伪代码中 phi 指令插入的阶段
            generate_phi();
            // 对应伪代码中重命名阶段
            rename(func_->get_entry_block());
        }
        // 后续 DeadCode 将移除冗余的局部变量的分配空间
    }
}

/**
 * @brief 在必要的位置插入phi指令
 * 
 * 该函数实现了经典的phi节点插入算法：
 * 1. 收集全局活跃变量：
 *    - 扫描所有store指令
 *    - 识别在多个基本块中被赋值的变量
 * 
 * 2. 插入phi指令：
 *    - 对每个全局活跃变量
 *    - 在其定值点的支配边界处插入phi指令
 *    - 使用工作表法处理迭代式的phi插入
 * 
 * phi指令的插入遵循最小化原则，只在必要的位置插入phi节点
 */
void Mem2Reg::generate_phi() {
  //   LOG(DEBUG) << "mem2reg gen_phi\n";
    // global_live_var_name 是全局名字集合，以 alloca 出的局部变量来统计。
    // 步骤一：找到活跃在多个 block 的全局名字集合，以及它们所属的 bb 块
    std::set<Value *> global_live_var_name;
    std::map<Value *, std::set<BasicBlock *>> live_var_2blocks;
    for (auto &bb : func_->get_basic_blocks()) {
        std::set<Value *> var_is_killed; // useless? //
        for (auto &instr : bb.get_instructions()) {
            if (instr.is_store()) {
                // store i32 a, i32 *b
                // a is r_val, b is l_val
                auto l_val = static_cast<StoreInst *>(&instr)->get_lval();
                if (is_valid_ptr(l_val)) {
                    global_live_var_name.insert(l_val);
                    live_var_2blocks[l_val].insert(&bb);
                }
            }
        }
    }

    // 步骤二：从支配树获取支配边界信息，并在对应位置插入 phi 指令
    std::map<std::pair<BasicBlock *, Value *>, bool>
        bb_has_var_phi; // bb has phi for var
    for (auto var : global_live_var_name) {
        std::vector<BasicBlock *> work_list;
        work_list.assign(live_var_2blocks[var].begin(),
                         live_var_2blocks[var].end());
        for (unsigned i = 0; i < work_list.size(); i++) {
            auto bb = work_list[i];
            for (auto bb_dominance_frontier_bb :
                 dominators_->get_dominance_frontier(bb)) {
                    // 获取支配边界信息
                if (bb_has_var_phi.find({bb_dominance_frontier_bb, var}) ==
                    bb_has_var_phi.end()) {
                    // generate phi for bb_dominance_frontier_bb & add
                    // bb_dominance_frontier_bb to work list
                    auto phi = PhiInst::create_phi(
                        var->get_type()->get_pointer_element_type(),
                        bb_dominance_frontier_bb);
                        // 对应位置插入 phi 指令 -- sample!!!
                    phi_lval.emplace(phi, var);
                    bb_dominance_frontier_bb->add_instr_begin(phi);
                    work_list.push_back(bb_dominance_frontier_bb);
                    bb_has_var_phi[{bb_dominance_frontier_bb, var}] = true;
                }
            }
        }
    }
}

void Mem2Reg::rename(BasicBlock *bb) {
    std::vector<Instruction *> wait_delete;
    // TODO:
    /*
        对于涉及%op0的store指令，则直接将对应store值推入对应的栈中。
        对于涉及%op0的load指令，则直接使用栈顶的元素进行代替。
        步骤一：将 phi 指令作为 lval 的最新定值，
        lval 即是为局部变量 alloca 出的地址空间
    */ 
    // LOG(DEBUG) << "mem2reg rename\n";
    Value *lval;
    for(auto &instr : bb -> get_instructions()){
        auto inst = &instr;
       
        if(inst -> is_phi()){
            auto phi = static_cast<PhiInst *>(inst);
            if(is_valid_ptr(phi) && phi_lval.find(phi) != phi_lval.end()){
                lval = phi_lval[phi];
                var_val_stack[lval].push_back(phi);
            }
        }
        // 步骤二：用 lval 最新的定值替代对应的load指令
        else if(inst -> is_load()){
            lval = static_cast<LoadInst *>(inst) -> get_lval();
            if(is_valid_ptr(lval) ){ //&& !var_val_stack[lval].empty()){
                inst -> replace_all_use_with(var_val_stack[lval].back());
                // wait_delete.push_back(inst);
            }
        }
        // 步骤三：将 store 指令的 rval，也即被存入内存的值，作为 lval 的最新定值
        else if(inst -> is_store()){
            lval = static_cast<StoreInst *>(inst) -> get_lval();
            if(is_valid_ptr(lval) ){ //&& !var_val_stack[lval].empty()){
                auto store_rval = static_cast<StoreInst *>(inst) -> get_rval();
                var_val_stack[lval].push_back(store_rval);
                // wait_delete.push_back(inst);
            }
        }
        
    }

    // 步骤四：为 lval 对应的 phi 指令参数补充完整
    // hui tian //
    for(auto &suc_bb : bb -> get_succ_basic_blocks()){
        for(auto &instr : suc_bb -> get_instructions()){
            auto inst = &instr;
            if(inst -> is_phi()){
                auto phi = static_cast<PhiInst *>(inst);
                if(phi_lval.find(phi) != phi_lval.end()){
                    auto phi_arg = phi_lval[phi];
                    if(!var_val_stack[phi_arg].empty() && var_val_stack.find(phi_arg) != var_val_stack.end()){
                        Value *val = var_val_stack[phi_arg].back();
                        phi -> add_phi_pair_operand(val, bb);
                    }
                }
            }
        }
    }
    /*--------------------------------------------------------------------------------------------------*/
    // 步骤五：对 bb 在支配树上的所有后继节点，递归执行 re_name 操作
    /*
        const BBSet &get_dom_tree_succ_blocks(BasicBlock *bb) {
            return dom_tree_succ_blocks_.at(bb);
        }
    */
    bb_rename.insert(std::make_pair(bb, true));
    std::set<BasicBlock *> suc_doms = dominators_ -> get_dom_tree_succ_blocks(bb);
    for(auto suc_bb : suc_doms){
        if(bb_rename.find(suc_bb) == bb_rename.end()){
            rename(suc_bb);
        }
    }
    // 步骤六：pop出 lval 的最新定值
    for(auto &instr : bb -> get_instructions()){
        auto inst = &instr;
        if(inst -> is_store()){
            lval = static_cast<StoreInst *>(inst) -> get_lval();
            if(is_valid_ptr(lval) && var_val_stack.find(lval) != var_val_stack.end()){
                var_val_stack[lval].pop_back();
            }
        }
        else if(inst -> is_phi()){
            auto phi_inst = static_cast<PhiInst *>(inst);
            lval = phi_lval[phi_inst];
            if(is_valid_ptr(lval) && var_val_stack.find(lval) != var_val_stack.end()){
                var_val_stack[lval].pop_back();
            }
        }
    }


    // 步骤七：清除冗余的指令
    // DeadCode :: sweep()
    for(auto it = bb -> get_instructions().begin(); 
          it != bb -> get_instructions().end(); it++) {
        auto inst = &*it;
        if(inst -> is_store()){
            lval = static_cast<StoreInst *>(inst) -> get_lval();
            if(is_valid_ptr(lval)) wait_delete.push_back(inst);
        }
        // LOG(DEBUG) << "sweep";
    }
    for(auto inst : wait_delete)
        inst->remove_all_operands();
    for(auto inst : wait_delete)
        inst->get_parent()->get_instructions().erase(inst);
    
}