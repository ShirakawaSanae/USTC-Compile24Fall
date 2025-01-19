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
    //int a[10];
    ArrayType *a = ArrayType::get(Int32Type, 10); // 定义a[10]的类型
    auto a_array_Alloca = builder -> create_alloca(a); // 在内存中分配a[10]

    //a[0]=10;
    auto a0GEP = builder -> create_gep(a_array_Alloca, {CONST_INT(0), CONST_INT(0)}); // 得到a[0]在内存中的指针
    builder -> create_store(CONST_INT(10), a0GEP); // 在内存中赋值为10

    //a[1]=a[0]*2;
    auto a1GEP = builder -> create_gep(a_array_Alloca, {CONST_INT(0), CONST_INT(1)}); // 得到a[1]在内存中的指针
    auto a0Load = builder -> create_load(a0GEP); // load a[0] 
    auto a0_mul_2 = builder -> create_imul(a0Load, CONST_INT(2)); // 计算a[0]*2
    builder -> create_store(a0_mul_2, a1GEP); // 将a[0]*2的结果存入a[1]

    //return a[1]
    auto a1Load = builder -> create_load(a1GEP); // load a[1]
    builder -> create_store(a1Load, retAlloca); // store a[1] to retAlloca
    auto retLoad = builder -> create_load(retAlloca); // load retLoad
    builder -> create_ret(retLoad); //return retLoad

    // 输出 module 中的所有 IR 指令
    std::cout << module->print();
    delete module;
    return 0;
}



