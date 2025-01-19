#include "BasicBlock.hpp"
#include "Constant.hpp"
#include "Function.hpp"
#include "IRBuilder.hpp"
#include "Module.hpp"
#include "Type.hpp"

#include <iostream>
#include <memory>

// 定义一个从常数值获取/创建 ConstantInt 类实例化的宏，方便多次调用
#define CONST_INT(num) ConstantInt::get(num, module)

// 定义一个从常数值获取/创建 ConstantFP 类实例化的宏，方便多次调用
#define CONST_FP(num) ConstantFP::get(num, module)

int main() {
    // 创建一个 Module 实例
    auto module = new Module();
    // 创建一个 IRBuilder 实例（后续创建指令均使用此实例操作）
    auto builder = new IRBuilder(nullptr, module);
    // 从 Module 处取出 32 位整形 type 的实例
    Type *Int32Type = module->get_int32_type();
    // 使用取出的 32 位整形与数组长度 1，创建数组类型 [1 x i32]
    auto *arrayType = ArrayType::get(Int32Type, 1);
    // 创建 0 常数类实例化，用于全局变量的初始化（目前全局变量仅支持初始化为 0）
    auto initializer = ConstantZero::get(Int32Type, module);
    
    //

    // 接下来创建 main 函数
    auto mainFun = Function::create(FunctionType::get(Int32Type, {}), "main", module);
    // 创建 main 函数的起始 bb
    auto bb = BasicBlock::create(module, "entry", mainFun);
    // 将 builder 插入指令的位置调整至 main 函数起始 bb 上
    builder->set_insert_point(bb);
    // 用 builder 创建 alloca 指令，为函数返回值分配空间
    auto retAlloca = builder->create_alloca(Int32Type);
    // main 函数默认 ret 0
    builder->create_store(CONST_INT(0), retAlloca);
    // 创建 retLoad 使得每个分支都能成功 return
    auto retLoad = builder->create_load(retAlloca); 

    //

    auto aAlloca = builder -> create_alloca(module -> get_float_type()); 
    builder -> create_store(CONST_FP(5.555), aAlloca); 

    auto trueBB = BasicBlock::create(module, "trueBB", mainFun); 
    auto falseBB = BasicBlock::create(module, "falseBB", mainFun); 

    auto aLoad = builder -> create_load(aAlloca); 
    auto fcmp = builder -> create_fcmp_gt(aLoad, CONST_FP(1));
    auto br = builder -> create_cond_br(fcmp, trueBB, falseBB);

    //return 233
    builder -> set_insert_point(trueBB); 
    builder -> create_store(CONST_INT(233), retAlloca); 
    retLoad = builder->create_load(retAlloca); 
    builder -> create_ret(retLoad); 

    //return 0
    builder -> set_insert_point(falseBB); // falseBB分支
    retLoad = builder -> create_load(retAlloca);
    builder -> create_ret(retLoad); 

    // 输出 module 中的所有 IR 指令
    std::cout << module->print();
    delete module;
    return 0;
}



