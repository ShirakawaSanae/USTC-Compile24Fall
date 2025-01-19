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
    // callee()
    std::vector<Type *> Ints(1, Int32Type);
    auto calleeFun = Function::create(FunctionType::get(Int32Type, Ints), "callee", module);
    auto bb = BasicBlock::create(module, "entry", calleeFun);
    builder -> set_insert_point(bb);

    auto retAlloca = builder -> create_alloca(Int32Type); 
    builder -> create_store(CONST_INT(0), retAlloca); // 返回值默认为0

    std::vector<Value *> args;  // 获取callee函数的形参,通过Function中的iterator
    for (auto &arg: calleeFun -> get_args()) {
        args.push_back(&arg);
    }

    auto aAlloca = builder -> create_alloca(Int32Type); // 为a分配内存
    builder -> create_store(args[0], aAlloca); // 将参数a的值读取到aAlloca中
    auto aLoad = builder -> create_load(aAlloca); // load a
    auto mul = builder -> create_imul(aLoad, CONST_INT(2)); // 计算a*2
    builder -> create_store(mul, retAlloca); //将乘积存在a2Alloca中
    
    auto retLoad = builder -> create_load(retAlloca); 
    builder -> create_ret(retLoad);
    
    // main()
    auto mainFun = Function::create(FunctionType::get(Int32Type, {}), "main", module);
    bb = BasicBlock::create(module, "entry", mainFun); 
    builder -> set_insert_point(bb);

    retAlloca = builder -> create_alloca(Int32Type); 
    builder -> create_store(CONST_INT(0), retAlloca); // 返回值默认为0

    auto retMain = builder -> create_call(calleeFun, {CONST_INT(110)});
    builder -> create_ret(retMain);
    
    // 输出 module 中的所有 IR 指令
    std::cout << module->print();
    delete module;
    return 0;
}



