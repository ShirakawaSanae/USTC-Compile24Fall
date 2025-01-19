#include "cminusf_builder.hpp"

#define CONST_FP(num) ConstantFP::get((float)num, module.get())
#define CONST_INT(num) ConstantInt::get(num, module.get())

// types
Type *VOID_T;
Type *INT1_T;
Type *INT32_T;
Type *INT32PTR_T;
Type *FLOAT_T;
Type *FLOATPTR_T;

/*
 * use CMinusfBuilder::Scope to construct scopes
 * scope.enter: enter a new scope
 * scope.exit: exit current scope
 * scope.push: add a new binding to current scope
 * scope.find: find and return the value bound to the name
 大概就是像 stu_cpp 里面那些构造方式一样，只不过增加了 scope 和 visit 类的调用？
 scope 是一个“符号表” ？
 */

Value* CminusfBuilder::visit(ASTProgram &node) {
    VOID_T = module->get_void_type();
    INT1_T = module->get_int1_type();
    INT32_T = module->get_int32_type();
    INT32PTR_T = module->get_int32_ptr_type();
    FLOAT_T = module->get_float_type();
    FLOATPTR_T = module->get_float_ptr_type();

    Value *ret_val = nullptr;
    for (auto &decl : node.declarations) {
        ret_val = decl->accept(*this);
    }
    return ret_val;
}
/*
Cminusf 的基础类型只有整型 (int)、浮点型 (float) 和 void。而在变量声明中，只有整型和浮点型可以使用，void 仅用于函数声明。
*/
Value* CminusfBuilder::visit(ASTNum &node) {
    // TODO: This function is empty now.
    // Add some code here.
    Value *num_val = nullptr;
    if(node.type == TYPE_INT){
        num_val = CONST_INT(node.i_val);
    }
    else num_val = CONST_FP(node.f_val);
    context.global_val = num_val;
    return nullptr;
}
/*
一个变量声明定义一个整型或者浮点型的变量，或者一个整型或浮点型的数组变量（这里整型指的是 32 位有符号整型，浮点数是指 32 位浮点数）。
var_declaration -> type_spicifier ID ; | type_spicifier ID [ INTEGER ] ;
数组变量在声明时，INTEGER 应当大于 0。
一次只能声明一个变量。
*/
Value* CminusfBuilder::visit(ASTVarDeclaration &node) {
    // TODO: This function is empty now.
    // Add some code here.
    // ID
    Type *var_type;
    if(node.type == TYPE_INT){
        var_type = INT32_T;
    }
    else var_type = FLOAT_T;
    // 还没 push 没法 find ？？ 
    // in_global
    // var or array
    if(node.num == nullptr){
        if(scope.in_global()){
            // 用实验文档的方法初始化为0
            auto initializer = ConstantZero::get(var_type, module.get());
            // push
            auto var = GlobalVariable::create(node.id, module.get(), var_type, false, initializer);
            scope.push(node.id, var);
        }
        else{
            // 直接分配一个空间
            auto var = builder -> create_alloca(var_type);
            scope.push(node.id, var);
        }
    }
    else{
        // 创建一个数组变量
        auto *array_type = ArrayType::get(var_type, node.num -> i_val);
        if(scope.in_global()){
            auto initializer = ConstantZero::get(array_type, module.get());
            auto var = GlobalVariable::create(node.id, module.get(), array_type, false, initializer);
            scope.push(node.id, var);
        }
        else{
            auto var = builder -> create_alloca(array_type);
            scope.push(node.id, var);
        }
    }
    return nullptr;
}

/*
函数声明包含了返回类型，标识符，由逗号分隔的形参列表，还有一个复合语句。
当函数的返回类型是 void 时，函数不返回任何值。
函数的参数可以是 void ，也可以是一个列表。当函数的形参是 void 时，调用该函数时不用传入任何参数。
形参中跟着中括号代表数组参数，它们可以有不同长度。
fun_declaration -> type_specifier ID ( params ) compound_stmt
*/
Value* CminusfBuilder::visit(ASTFunDeclaration &node) {
    FunctionType *fun_type;
    Type *ret_type;
    std::vector<Type *> param_types;
    // 这部分是 ID 可以直接套用到其他的 type_spycifier (注意 void)
    if (node.type == TYPE_INT)
        ret_type = INT32_T;
    else if (node.type == TYPE_FLOAT)
        ret_type = FLOAT_T;
    else
        ret_type = VOID_T;
    //

    /* params：
       params -> param-list | void
       param_list -> param-list , param | param
       param -> type-specifier ID | type-specifier ID [  ]

        :::::::::::::::::::::::::::::::::::::::::::::::::from ast.hpp:::::::::::::::::::::::::::::::::::::::::::::::::::::
        struct ASTFunDeclaration : ASTDeclaration {
            virtual Value* accept(ASTVisitor &) override final;
            std::vector<std::shared_ptr<ASTParam>> params;
            std::shared_ptr<ASTCompoundStmt> compound_stmt;
        };

        struct ASTParam : ASTNode {
            virtual Value* accept(ASTVisitor &) override final;
            CminusType type;
            std::string id;
            // true if it is array param
            bool isarray;
};
    */
    for (auto &param : node.params) {
        // TODO: Please accomplish param_types.
        // 这里只是为了获得 param_types, 不是 param 的语义
        if (param -> type == TYPE_INT){
            if(param -> isarray) param_types.push_back(INT32PTR_T);
            else param_types.push_back(INT32_T);
        }
        else{
            if(param -> isarray) param_types.push_back(FLOATPTR_T);
            else param_types.push_back(FLOAT_T);
        }
    }

    fun_type = FunctionType::get(ret_type, param_types);
    auto func = Function::create(fun_type, node.id, module.get());
    scope.push(node.id, func);
    context.global_func = func;
    auto funBB = BasicBlock::create(module.get(), "entry", func);
    builder -> set_insert_point(funBB);
    scope.enter();
    std::vector<Value *> args;
    for (auto &arg : func->get_args()) {
        args.push_back(&arg);
    }
    for (unsigned int i = 0; i < node.params.size(); ++i) { // 依次解析 params
        // TODO: You need to deal with params and store them in the scope.
        if(node.params[i] -> isarray){
            Value *array_alloc;
            if(node.params[i] -> type == TYPE_INT)
                array_alloc = builder -> create_alloca(INT32PTR_T);
            else
                array_alloc = builder -> create_alloca(FLOATPTR_T);
            builder -> create_store(args[i], array_alloc);
            scope.push(node.params[i] -> id, array_alloc);
        }
        else {
            Value *para_alloc;
            if(node.params[i] -> type == TYPE_INT)
                para_alloc = builder -> create_alloca(INT32_T);
            else 
                para_alloc = builder -> create_alloca(FLOAT_T);
            builder -> create_store(args[i], para_alloc);
            scope.push(node.params[i] -> id, para_alloc);
        }

        
    }

    // 复合语句，不用修改
    node.compound_stmt->accept(*this);
    //if (builder->get_insert_block()->get_terminator() == nullptr) 
    if (not builder->get_insert_block()->is_terminated()) 
    {
        if (context.global_func->get_return_type()->is_void_type())
            builder->create_void_ret();
        else if (context.global_func->get_return_type()->is_float_type())
            builder->create_ret(CONST_FP(0.));
        else
            builder->create_ret(CONST_INT(0));
    }
    scope.exit();
    return nullptr;
}

Value *CminusfBuilder::visit(ASTParam &node)
{
    // TODO: This function is empty now.
    // Add some code here.
    return nullptr;
}

/*

struct ASTCompoundStmt : ASTStatement {
    virtual Value* accept(ASTVisitor &) override final;
    std::vector<std::shared_ptr<ASTVarDeclaration>> local_declarations;
    std::vector<std::shared_ptr<ASTStatement>> statement_list;
};

*/
Value* CminusfBuilder::visit(ASTCompoundStmt &node) {
    // TODO: This function is not complete.
    // You may need to add some code here
    // to deal with complex statements. 
    // ASTSCompoundStmt 里面俩容器你都写完了，我写啥啊
    
    bool need_exit_scope = !context.pre_enter_scope;
    if(context.pre_enter_scope) context.pre_enter_scope = false;
    else scope.enter();


    for (auto &decl : node.local_declarations) {
        decl->accept(*this);
    }

    for (auto &stmt : node.statement_list) {
        stmt->accept(*this);
        //if (builder->get_insert_block()->get_terminator() == nullptr)
        if (builder->get_insert_block()->is_terminated())
            break;
    }

    if(need_exit_scope) scope.exit();
    return nullptr;
}
/*

struct ASTExpressionStmt : ASTStatement {
    virtual Value* accept(ASTVisitor &) override final;
    std::shared_ptr<ASTExpression> expression;
};
    expression-statement 里面只有 expression

*/
Value* CminusfBuilder::visit(ASTExpressionStmt &node) {
    // TODO: This function is empty now.
    // Add some code here.
    if(node.expression != nullptr) node.expression -> accept(*this);
    return nullptr;
}
/*

struct ASTSelectionStmt : ASTStatement {
    virtual Value* accept(ASTVisitor &) override final;
    std::shared_ptr<ASTExpression> expression;
    std::shared_ptr<ASTStatement> if_statement;
    // should be nullptr if no else structure exists
    std::shared_ptr<ASTStatement> else_statement;
};

    if 语句中的表达式将被求值，若结果的值等于 0，则第二个语句执行（如果存在的话），否则第一个语句会执行。

*/
Value* CminusfBuilder::visit(ASTSelectionStmt &node) {
    // TODO: This function is empty now.
    // Add some code here.
    node.expression -> accept(*this);
    auto ret_val = context.global_val;
    auto trueBB = BasicBlock::create(module.get(), "", context.global_func);
    BasicBlock *falseBB;
    auto contBB = BasicBlock::create(module.get(), "", context.global_func);
    Value *cond_val;
    if(ret_val -> get_type() -> is_integer_type())
        cond_val = builder -> create_icmp_ne(ret_val, CONST_INT(0));
    else
        cond_val = builder -> create_fcmp_ne(ret_val, CONST_FP(0.));

    
    if(node.else_statement == nullptr) // no branch, just continue
        builder -> create_cond_br(cond_val, trueBB, contBB);
    else{
        falseBB = BasicBlock::create(module.get(), "", context.global_func);
        builder -> create_cond_br(cond_val, trueBB, falseBB);
    }
    builder -> set_insert_point(trueBB);
    node.if_statement->accept(*this); // insert 之后 accept

    // if (builder->get_insert_block()->get_terminator() == nullptr)
    if (not builder->get_insert_block()->is_terminated())
        builder->create_br(contBB); // 循环表达式结束
    // 
    if(node.else_statement != nullptr){
        builder -> set_insert_point(falseBB);
        node.else_statement -> accept(*this); 
        // if (builder->get_insert_block()->get_terminator() == nullptr)
        if (not builder->get_insert_block()->is_terminated())
            builder -> create_br(contBB); // else 结束
    }
    builder -> set_insert_point(contBB);// 哎，画图...
    return nullptr;
}
/*

struct ASTIterationStmt : ASTStatement {
    virtual Value* accept(ASTVisitor &) override final;
    std::shared_ptr<ASTExpression> expression;
    std::shared_ptr<ASTStatement> statement;
};

    while 语句是 Cminusf 中唯一的迭代语句。它执行时，会不断对表达式进行求值，
    并且在对表达式的求值结果等于 0 前，循环执行下面的语句。

*/
Value* CminusfBuilder::visit(ASTIterationStmt &node) {
    // TODO: This function is empty now.
    // Add some code here.
    auto exprBB = BasicBlock::create(module.get(), "", context.global_func);
    // if (builder->get_insert_block()->get_terminator() == nullptr)
    if (not builder -> get_insert_block() -> is_terminated())
        builder -> create_br(exprBB);
    builder -> set_insert_point(exprBB);
    node.expression -> accept(*this);

    auto ret_val = context.global_val;
    auto trueBB = BasicBlock::create(module.get(), "", context.global_func);
    auto contBB = BasicBlock::create(module.get(), "", context.global_func);
    Value *cond_val;
    if (ret_val -> get_type() -> is_integer_type())
        cond_val = builder -> create_icmp_ne(ret_val, CONST_INT(0));
    else
        cond_val = builder -> create_fcmp_ne(ret_val, CONST_FP(0.));

    builder -> create_cond_br(cond_val, trueBB, contBB);
    builder -> set_insert_point(trueBB);
    node.statement -> accept(*this);
    // if (builder->get_insert_block()->get_terminator() == nullptr)
    if (not builder -> get_insert_block() -> is_terminated())
        builder -> create_br(exprBB);
    builder -> set_insert_point(contBB);
    return nullptr;
}
/*

struct ASTReturnStmt : ASTStatement {
    virtual Value* accept(ASTVisitor &) override final;
    // should be nullptr if return void
    std::shared_ptr<ASTExpression> expression;
};

*/
Value* CminusfBuilder::visit(ASTReturnStmt &node) { // FunDeclaration 里面可以借鉴
    if (node.expression == nullptr) {
        builder -> create_void_ret();
        return nullptr;
    } 
    else {
        // TODO: The given code is incomplete.
        // You need to solve other return cases (e.g. return an integer).
        auto ret_type = context.global_func -> get_function_type() -> get_return_type();
        node.expression -> accept(*this);
        if(ret_type != context.global_val -> get_type()){ 
            // 类型转换
            if (ret_type -> is_integer_type())
                context.global_val = builder -> create_fptosi(context.global_val, INT32_T);
            else
                context.global_val = builder -> create_sitofp(context.global_val, FLOAT_T);
        }
        builder -> create_ret(context.global_val);
    }
    return nullptr;
}
/*

    var 可以是一个整型变量、浮点变量，或者一个取了下标的数组变量。
    数组的下标值为整型，作为数组下标值的表达式计算结果可能需要类型转换变成整型值。
    一个负的下标会导致程序终止，需要调用框架中的内置函数 neg_idx_except
    （该内部函数会主动退出程序，只需要调用该函数即可），但是对于上界并不做检查。
    赋值语义为：先找到 var 代表的变量地址（如果是数组，需要先对下标表达式求值），
    然后对右侧的表达式进行求值，求值结果将在转换成变量类型后存储在先前找到的地址中。
    同时，存储在 var 中的值将作为赋值表达式的求值结果。

    struct ASTVar : ASTFactor {
        virtual Value* accept(ASTVisitor &) override final;
        std::string id;
        // nullptr if var is of int type
        std::shared_ptr<ASTExpression> expression;
    };
    ASTFactor : ASTNode
    ASTExpression : ASTFactor
    (这特么啥啊)

    expression -> var = expression | simple-expression
    var -> ID | ID [ expression ]
    simple-expression -> additive-expression relop additive-expression | additive-expression
    additive-expression -> additive-expression addop term | term
    term -> term mulop factor | factor
    factor -> ( expression ) | var | call | integer | float
    call -> ID ( args )
    args -> arglist | empty
    arglist -> arglist , expression | expression

*/


bool check_type(std::unique_ptr<IRBuilder> &builder, Value **l_val_p, Value **r_val_p)
{
    bool is_int;
    auto &l_val = *l_val_p;
    auto &r_val = *r_val_p;
    //auto l_val_type = l_val -> get_type();
    //auto r_val_type = l_val -> get_type(); // 这里很奇怪，为什么不能加中间变量呢
    if(l_val -> get_type() == r_val -> get_type()){
        is_int = l_val -> get_type() -> is_integer_type();
        // 
    }
    else{
        is_int = false;
        if(l_val -> get_type() -> is_integer_type()) // 精度。。。是随float
            l_val = builder -> create_sitofp(l_val, FLOAT_T);
        else
            r_val = builder -> create_sitofp(r_val, FLOAT_T);
    }
    return is_int;
}

Value* CminusfBuilder::visit(ASTVar &node) {
    // TODO: This function is empty now.
    // Add some code here.
    // var = ID | ID [ ... ]
    auto var_ = scope.find(node.id);
    assert(var_ != nullptr);
    auto is_integer = var_ -> get_type() -> get_pointer_element_type() -> is_integer_type();
    auto is_float = var_ -> get_type() -> get_pointer_element_type() -> is_float_type();
    auto is_pointer = var_ -> get_type() -> get_pointer_element_type() -> is_pointer_type();
    bool should_return_lvalue = context.require_lvalue;
    context.require_lvalue = false;
    // ... = expression ...
    if(node.expression == nullptr){
        if(should_return_lvalue){
            context.global_val = var_;
            context.require_lvalue = false;
        }
        else{
            if(is_integer || is_float || is_pointer)
                context.global_val = builder -> create_load(var_);
            else
                context.global_val = builder -> create_gep(var_, {CONST_INT(0), CONST_INT(0)});
        }
    }
    else{
        node.expression -> accept(*this);
        auto val = context.global_val;
        Value *is_neg;
        auto exceptBB = BasicBlock::create(module.get(), "", context.global_func);
        auto contBB = BasicBlock::create(module.get(), "", context.global_func);
        if(val -> get_type() -> is_float_type())
            val = builder -> create_fptosi(val, INT32_T);

        is_neg = builder -> create_icmp_lt(val, CONST_INT(0));

        builder -> create_cond_br(is_neg, exceptBB, contBB);
        builder -> set_insert_point(exceptBB);
        auto neg_idx_except_fun = scope.find("neg_idx_except");
        builder -> create_call(static_cast<Function *>(neg_idx_except_fun), {});


        if (context.global_func -> get_return_type() -> is_void_type())
            builder->create_void_ret();
        else if (context.global_func -> get_return_type() -> is_float_type())
            builder -> create_ret(CONST_FP(0.));
        else
            builder -> create_ret(CONST_INT(0));

        builder -> set_insert_point(contBB);
        Value *tmp_ptr;
        if (is_integer || is_float)
            tmp_ptr = builder -> create_gep(var_, {val});
        else if (is_pointer){
            auto array_load = builder -> create_load(var_);
            tmp_ptr = builder -> create_gep(array_load, {val});
        }
        else
            tmp_ptr = builder -> create_gep(var_, {CONST_INT(0), val});
        if (should_return_lvalue){
            context.global_val = tmp_ptr;
            context.require_lvalue = false;
        }
        else{
            context.global_val = builder -> create_load(tmp_ptr);
        }
    }
    return nullptr;
}
/*

struct ASTAssignExpression : ASTExpression {
    virtual Value* accept(ASTVisitor &) override final;
    std::shared_ptr<ASTVar> var;
    std::shared_ptr<ASTExpression> expression;
};

*/
Value* CminusfBuilder::visit(ASTAssignExpression &node) {
    // TODO: This function is empty now.
    // Add some code here.
    node.expression -> accept(*this);
    auto expr_result = context.global_val;
    context.require_lvalue = true;
    node.var -> accept(*this);
    auto var_addr = context.global_val;
    if (var_addr -> get_type() -> get_pointer_element_type() != expr_result -> get_type()){
        // 赋值时类型转换
        if (expr_result -> get_type() == INT32_T)
            expr_result = builder -> create_sitofp(expr_result, FLOAT_T);
        else expr_result = builder -> create_fptosi(expr_result, INT32_T);
    }
    builder -> create_store(expr_result, var_addr);
    context.global_val = expr_result;
    return nullptr;
}
/*

struct ASTAdditiveExpression : ASTNode {
    virtual Value* accept(ASTVisitor &) override final;
    std::shared_ptr<ASTAdditiveExpression> additive_expression;
    AddOp op;
    std::shared_ptr<ASTTerm> term;
};

simple-expression 是 左右各一个 additive 中间 Relop

*/
Value* CminusfBuilder::visit(ASTSimpleExpression &node) {
    // TODO: This function is empty now.
    // Add some code here.
    if (node.additive_expression_r == nullptr){
        node.additive_expression_l -> accept(*this);
    }
    else{
        node.additive_expression_l -> accept(*this);
        auto l_val = context.global_val;
        node.additive_expression_r -> accept(*this);
        auto r_val = context.global_val;
        bool is_int = check_type(builder, &l_val, &r_val);
        Value *cmp;

        switch(node.op){
            case OP_LT:
                if (is_int)
                    cmp = builder->create_icmp_lt(l_val, r_val);
                else
                    cmp = builder->create_fcmp_lt(l_val, r_val);
                break;
            case OP_LE:
                if (is_int)
                    cmp = builder->create_icmp_le(l_val, r_val);
                else
                    cmp = builder->create_fcmp_le(l_val, r_val);
                break;
            case OP_GE:
                if (is_int)
                    cmp = builder->create_icmp_ge(l_val, r_val);
                else
                    cmp = builder->create_fcmp_ge(l_val, r_val);
                break;
            case OP_GT:
                if (is_int)
                    cmp = builder->create_icmp_gt(l_val, r_val);
                else
                    cmp = builder->create_fcmp_gt(l_val, r_val);
                break;
            case OP_EQ:
                if (is_int)
                    cmp = builder->create_icmp_eq(l_val, r_val);
                else
                    cmp = builder->create_fcmp_eq(l_val, r_val);
                break;
            case OP_NEQ:
                if (is_int)
                    cmp = builder->create_icmp_ne(l_val, r_val);
                else
                    cmp = builder->create_fcmp_ne(l_val, r_val);
                break;
        }

        context.global_val = builder -> create_zext(cmp, INT32_T);
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTAdditiveExpression &node) {
    // TODO: This function is empty now.
    // Add some code here.
    if (node.additive_expression == nullptr) node.term -> accept(*this);
    
    else{
        node.additive_expression -> accept(*this);
        auto l_val = context.global_val;
        node.term -> accept(*this);
        auto r_val = context.global_val;
        bool is_int = check_type(builder, &l_val, &r_val);
        Value *cmp;
        switch (node.op){
            case OP_PLUS:
                if (is_int)
                    cmp = builder->create_iadd(l_val, r_val);
                else
                    cmp = builder->create_fadd(l_val, r_val);
                break;
            case OP_MINUS:
                if (is_int)
                    cmp = builder->create_isub(l_val, r_val);
                else
                    cmp = builder->create_fsub(l_val, r_val);
                break;
        }
        context.global_val = cmp;
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTTerm &node) {
    // TODO: This function is empty now.
    // Add some code here.
    if(node.term == nullptr) node.factor -> accept(*this); // 只有 factor
    else{
        node.term -> accept(*this);
        auto l_val = context.global_val;
        node.factor -> accept(*this);
        auto r_val = context.global_val;
        bool is_int = check_type(builder, &l_val, &r_val);
        if(node.op == OP_MUL){
            if(is_int) context.global_val = builder -> create_imul(l_val, r_val);
            else context.global_val = builder -> create_fmul(l_val, r_val);
        }
        if(node.op == OP_DIV){
            if(is_int) context.global_val = builder -> create_isdiv(l_val, r_val);
            else context.global_val = builder -> create_fdiv(l_val, r_val);
        }
        
    }
    return nullptr;
}
/*

struct ASTCall : ASTFactor {
    virtual Value* accept(ASTVisitor &) override final;
    std::string id;
    std::vector<std::shared_ptr<ASTExpression>> args;
};
    函数调用由一个函数的标识符与一组括号包围的实参组成。实参可以为空，
    也可以是由逗号分隔的的表达式组成的列表，这些表达式代表着函数调用时，
    传给形参的值。函数调用时的实参数量和类型必须与函数声明中的形参一致，必要时需要进行类型转换。
*/
Value* CminusfBuilder::visit(ASTCall &node) { // 调用函数，应当都是声明过的函数
    // TODO: This function is empty now.
    // Add some code here.
    // ID
    auto fun = static_cast<Function *>(scope.find(node.id));
    //args
    std::vector<Value *> args;
    auto param_type = fun -> get_function_type() -> param_begin();
    for (auto &arg : node.args)
    {
        arg -> accept(*this);
        if (!context.global_val -> get_type() -> is_pointer_type() &&
            *param_type != context.global_val -> get_type()) // 必要时类型转换
        {
            if (context.global_val -> get_type() -> is_integer_type())
                context.global_val = builder -> create_sitofp(context.global_val, FLOAT_T);
            else
                context.global_val = builder -> create_fptosi(context.global_val, INT32_T);
        }
        args.push_back(context.global_val);
        param_type++;
    }

    context.global_val = builder->create_call(static_cast<Function *>(fun), args);

    return nullptr;
    
}

