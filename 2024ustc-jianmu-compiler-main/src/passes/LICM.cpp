#include "BasicBlock.hpp"
#include "Constant.hpp"
#include "Function.hpp"
#include "GlobalVariable.hpp"
#include "Instruction.hpp"
#include "LICM.hpp"
#include "PassManager.hpp"
#include <cstddef>
#include <memory>
#include <vector>

/**
 * @brief 循环不变式外提Pass的主入口函数
 * 
 */
void LoopInvariantCodeMotion::run() {

    loop_detection_ = std::make_unique<LoopDetection>(m_);
    loop_detection_->run();
    func_info_ = std::make_unique<FuncInfo>(m_);
    func_info_->run();
    for (auto &loop : loop_detection_->get_loops()) {
        is_loop_done_[loop] = false;
    }

    for (auto &loop : loop_detection_->get_loops()) {
        traverse_loop(loop);
    }
}

/**
 * @brief 遍历循环及其子循环
 * @param loop 当前要处理的循环
 * 
 */
void LoopInvariantCodeMotion::traverse_loop(std::shared_ptr<Loop> loop) {
    if (is_loop_done_[loop]) {
        return;
    }
    is_loop_done_[loop] = true;
    for (auto &sub_loop : loop->get_sub_loops()) {
        traverse_loop(sub_loop);
    }
    run_on_loop(loop);
}

// TODO: 实现collect_loop_info函数
// 1. 遍历当前循环及其子循环的所有指令
// 2. 收集所有指令到loop_instructions中
// 3. 检查store指令是否修改了全局变量，如果是则添加到updated_global中
// 4. 检查是否包含非纯函数调用，如果有则设置contains_impure_call为true
void LoopInvariantCodeMotion::collect_loop_info(
    std::shared_ptr<Loop> loop,
    std::set<Value *> &loop_instructions,
    std::set<Value *> &updated_global,
    bool &contains_impure_call) {
    
    for(auto loop_bb : loop -> get_blocks()){
        for(auto &loop_inst : loop_bb -> get_instructions()){
            auto instr = &loop_inst;
            loop_instructions.insert(instr);

            if(instr -> is_store()){
                // auto rval = static_cast<StoreInst *>(instr) -> get_rval();
                // if(FuncInfo::is_local_store(dynamic_cast<StoreInst *>(instr)))
                
                /*auto addr = dynamic_cast<Instruction *>(get_first_addr(store_instr -> get_lval()));
                if (addr and addr->is_alloca())
                    return true;
                return false;*/
                auto store_instr = dynamic_cast<StoreInst *>(instr);
                auto store_lval = store_instr -> get_lval();
                if(dynamic_cast<GlobalVariable *>(store_lval) != nullptr){ // mem2reg.hpp
                    updated_global.insert(store_lval);
                }
            }

            // 检查是否包含非纯函数调用
            if(instr -> is_call()) {
                auto call_inst = dynamic_cast<CallInst *>(instr); // deadcode.cpp
                auto callee = dynamic_cast<Function *>(call_inst -> get_operand(0));
                if(func_info_ -> is_pure_function(callee)) continue;
                contains_impure_call = true;
            }
        }
    }

    // recursion
     for(auto &sub_loop : loop -> get_sub_loops()){
        collect_loop_info(sub_loop, loop_instructions, updated_global, contains_impure_call);
    }
}

/**
 * @brief 对单个循环执行不变式外提优化
 * @param loop 要优化的循环
 * 
 */
void LoopInvariantCodeMotion::run_on_loop(std::shared_ptr<Loop> loop) {
    std::set<Value *> loop_instructions;
    std::set<Value *> updated_global;
    bool contains_impure_call = false;
    collect_loop_info(loop, loop_instructions, updated_global, contains_impure_call);

    std::vector<Value *> loop_invariant;


    // TODO: 识别循环不变式指令
    //
    // - 如果指令已被标记为不变式则跳过
    // - 跳过 store、ret、br、phi 等指令与非纯函数调用
    // - 特殊处理全局变量的 load 指令
    // - 检查指令的所有操作数是否都是循环不变的
    // - 如果有新的不变式被添加则注意更新 changed 标志，继续迭代

    bool changed;
    do {
        changed = false;

        for(auto instr : loop_instructions){
            if(std::find(loop_invariant.begin(), loop_invariant.end(), instr) != loop_invariant.end()){
                continue;
            }
            auto p1_instr = dynamic_cast<Instruction *>(instr);
            if(p1_instr -> is_store() || p1_instr -> is_ret() || p1_instr -> is_br() || 
                p1_instr -> is_phi()) continue;
            else if(contains_impure_call ){
                continue;
            }

            // 全局变量的 load
            if(p1_instr -> is_load()){
                auto p2_instr = dynamic_cast<LoadInst *>(instr);
                auto p2_lval = p2_instr -> get_lval();
                if(dynamic_cast<GlobalVariable *>(p2_lval) != nullptr){ // mem2reg.hpp
                    updated_global.insert(p2_lval);
                }
            }

            bool op_are_invariant = true;
            unsigned int op_num = p1_instr -> get_num_operand();
            for(unsigned int i = 0; i < op_num; i++){
                auto op_ = p1_instr -> get_operand(i); 
                if(loop_instructions.find(op_) != loop_instructions.end() && 
                       std::find(loop_invariant.begin(),loop_invariant.end(),op_) == loop_invariant.end()){
                    op_are_invariant = false;
                    break;
                }
            }
            if(op_are_invariant) {
                loop_invariant.push_back(instr);
                changed = true;
            }
        }
    } while (changed);

    if (loop->get_preheader() == nullptr) {
        loop->set_preheader(
            BasicBlock::create(m_, "", loop->get_header()->get_parent()));
    }

    if (loop_invariant.empty())
        return;

    // insert preheader
    auto preheader = loop->get_preheader();

    // TODO: 更新 phi 指令
    for (auto &phi_inst_ : loop->get_header()->get_instructions()) {
        if (phi_inst_.get_instr_type() != Instruction::phi)
            break;
        
        /*unsigned int op_num = phi_inst_.get_num_operand();
        for(unsigned int i = 0; i < op_num; i += 2){
            auto op_ = phi_inst_.get_operand(i);
            auto phi_bb = dynamic_cast<BasicBlock *>(phi_inst_.get_operand(i+1));
            if(!phi_bb) continue;
            // latches : backedge to header, cannot be moved out
            if(loop -> get_latches().find(phi_bb) == loop -> get_latches().end()){
                //?
                phi_inst_.set_operand(i+1, preheader);
            }
        }*/
        
        // PHINode should have one entry for each predecessor of its parent basic block!
        auto phi_inst = dynamic_cast<PhiInst *>(&phi_inst_);
        auto phi_pairs = phi_inst -> get_phi_pairs();
        for(auto &pair : phi_pairs){
            BasicBlock *phi_bb = pair.second;
            if(loop -> get_latches().find(phi_bb) == loop -> get_latches().end()){
                        phi_inst -> remove_phi_operand(phi_bb);
                        phi_inst -> add_phi_pair_operand(pair.first, preheader);
                        break;
                    }
        }
    }

    

    // TODO: 用跳转指令重构控制流图 
    // 将所有非 latch 的 header 前驱块的跳转指向 preheader
    // 并将 preheader 的跳转指向 header
    // 注意这里需要更新前驱块的后继和后继的前驱
    std::vector<BasicBlock *> pred_to_remove;
    for (auto &pred : loop->get_header()->get_pre_basic_blocks()) {
        auto latches_ = loop -> get_latches();
        if(latches_.find(pred) == latches_.end()){
            pred -> remove_succ_basic_block(loop -> get_header());
            pred -> add_succ_basic_block(preheader);
            preheader -> add_pre_basic_block(pred); 
            pred_to_remove.push_back(pred);
        }
    }
    preheader -> add_succ_basic_block(loop -> get_header());
    
    for(auto &pred : preheader -> get_pre_basic_blocks()){
        //if(pred -> get_name() == "lable_entry"){
            for(auto &inst : pred -> get_instructions()){
                if(inst.is_br()) inst.set_operand(0, static_cast<Value *>(preheader));
            }
        //}
    }
    

    for (auto &pred : pred_to_remove) {
        loop->get_header()->remove_pre_basic_block(pred);
    }

    // TODO: 外提循环不变指令
    for(auto val : loop_invariant){
        auto instr = dynamic_cast<Instruction *>(val);
        instr -> get_parent() -> remove_instr(instr);
        preheader -> add_instruction(instr);

    }

    // insert preheader br to header
    BranchInst::create_br(loop->get_header(), preheader);

    // insert preheader to parent loop
    if (loop->get_parent() != nullptr) {
        loop->get_parent()->add_block(preheader);
    }
}

