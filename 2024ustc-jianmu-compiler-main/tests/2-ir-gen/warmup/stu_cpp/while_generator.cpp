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

    //

    auto aAlloca = builder -> create_alloca(Int32Type); // 在内存中分配 a
    auto iAlloca = builder -> create_alloca(Int32Type); // 在内存中分配 i
    builder -> create_store(CONST_INT(10), aAlloca); // a 赋值为 10
    builder -> create_store(CONST_INT(0), iAlloca); // i 赋值为 0

    auto trueBB = BasicBlock::create(module, "trueBB", mainFun); // true 分支
    auto falseBB = BasicBlock::create(module, "falseBB", mainFun); // false 分支
    auto iLoad = builder -> create_load(iAlloca); // load i
    auto icmp = builder -> create_icmp_lt(iLoad, CONST_INT(10)); // compare 
    auto br = builder -> create_cond_br(icmp, trueBB, falseBB); // jump

    builder -> set_insert_point(trueBB); // trueBB 分支
    iLoad = builder -> create_load(iAlloca); // load i
    auto addRes = builder -> create_iadd(iLoad, CONST_INT(1)); // res = i+1
    builder -> create_store(addRes, iAlloca); // i = i+1

    auto aLoad = builder -> create_load(aAlloca); // load a
    iLoad = builder -> create_load(iAlloca); //load i
    addRes = builder -> create_iadd(aLoad, iLoad); // a+i
    builder -> create_store(addRes, aAlloca); // a = a+i

    iLoad = builder -> create_load(iAlloca); // load i
    icmp = builder -> create_icmp_lt(iLoad, CONST_INT(10)); // compare 
    br = builder -> create_cond_br(icmp, trueBB, falseBB); // jump

    builder->set_insert_point(falseBB); // falseBB分支
    aLoad = builder -> create_load(aAlloca); // load aLoad
    builder -> create_store(aLoad, retAlloca); // store aLoad in retAlloca
    auto retLoad = builder -> create_load(retAlloca); // load retAlloca
    builder -> create_ret(retLoad); // return retLoad


    // 输出 module 中的所有 IR 指令
    std::cout << module->print();
    delete module;
    return 0;
}



