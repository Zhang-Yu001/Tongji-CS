
from typing import List, Optional
from lexer import Lexer, TokenType, Token
from symbol_table import SymbolTable

# ---- AST nodes (minimal needed for IR stage) ----
class ASTNode: ...
class Program(ASTNode):
    def __init__(self, functions: List['FunctionDef']):
        self.functions = functions
class FunctionDef(ASTNode):
    def __init__(self, name: str, params: List['Param'], body: List[ASTNode], ret_type: Optional[str]):
        self.name, self.params, self.body, self.ret_type = name, params, body, ret_type
class Param(ASTNode):
    def __init__(self, name: str, typ: Optional[str], is_mut: bool):
        self.name, self.typ, self.is_mut = name, typ, is_mut
class VarDecl(ASTNode):
    def __init__(self, name: str, typ: Optional[str], value: Optional[ASTNode], is_mut: bool):
        self.name, self.typ, self.value, self.is_mut = name, typ, value, is_mut
class Assign(ASTNode):
    def __init__(self, name: str, value: ASTNode):
        self.name, self.value = name, value
class Return(ASTNode):
    def __init__(self, value: Optional[ASTNode]):
        self.value = value
class If(ASTNode):
    def __init__(self, cond: ASTNode, then_body: List[ASTNode], else_body: Optional[List[ASTNode]]):
        self.cond, self.then_body, self.else_body = cond, then_body, else_body
class While(ASTNode):
    def __init__(self, cond: ASTNode, body: List[ASTNode]):
        self.cond, self.body = cond, body
class Empty(ASTNode): pass
# expressions
class Number(ASTNode):
    def __init__(self, value: int): self.value = value
class Var(ASTNode):
    def __init__(self, name: str): self.name = name
class BinOp(ASTNode):
    def __init__(self, left: ASTNode, op: str, right: ASTNode):
        self.left, self.op, self.right = left, op, right
class FuncCall(ASTNode):
    def __init__(self, name: str, args: List[ASTNode]):
        self.name, self.args = name, args

class Parser:
    def __init__(self, lexer: Lexer):
        self.lexer = lexer
        self.current_token: Token = self.lexer.next_token()
        self.symtab = SymbolTable()
        self.func_ret_stack: List[Optional[str]] = []

    def eat(self, t: TokenType):
        if self.current_token.type == t:
            self.current_token = self.lexer.next_token()
        else:
            raise SyntaxError(f"期望 {t}, 但得到 {self.current_token.type} at line {self.current_token.line}")

    def parse(self) -> Program:
        funcs = []
        while self.current_token.type != TokenType.EOF:
            funcs.append(self.parse_function())
        return Program(funcs)

    def parse_function(self) -> FunctionDef:
        self.eat(TokenType.FN)
        name = self.current_token.value
        self.eat(TokenType.IDENT)
        self.eat(TokenType.LPAREN)
        params = self.parse_params()
        self.eat(TokenType.RPAREN)
        ret_type = None
        if self.current_token.type == TokenType.ARROW:
            self.eat(TokenType.ARROW)
            if self.current_token.type not in (TokenType.I32, TokenType.IDENT):
                raise SyntaxError(f"期望返回类型, 但得到 {self.current_token.type}")
            ret_type = self.current_token.value
            self.eat(self.current_token.type)
        # define function symbol before parsing body (allow recursion)
        self.symtab.define_func(name, [p.typ or 'i32' for p in params], ret_type)
        # enter function scope; define params
        self.symtab = self.symtab.enter_scope()
        for p in params:
            self.symtab.define_var(p.name, p.typ or 'i32', p.is_mut)
            # consider params as already assigned
            self.symtab.set_assigned(p.name)
        # push function ret for return checking
        self.func_ret_stack.append(ret_type)
        self.eat(TokenType.LBRACE)
        body = self.parse_block()
        self.eat(TokenType.RBRACE)
        self.func_ret_stack.pop()
        # leave function scope
        self.symtab = self.symtab.exit_scope()
        return FunctionDef(name, params, body, ret_type)

    def parse_params(self) -> List[Param]:
        params: List[Param] = []
        if self.current_token.type != TokenType.RPAREN:
            params.append(self.parse_param())
            while self.current_token.type == TokenType.COMMA:
                self.eat(TokenType.COMMA)
                params.append(self.parse_param())
        return params

    def parse_param(self) -> Param:
        is_mut = False
        if self.current_token.type == TokenType.MUT:
            is_mut = True
            self.eat(TokenType.MUT)
        name = self.current_token.value
        self.eat(TokenType.IDENT)
        self.eat(TokenType.COLON)
        # base stage: only i32 is supported
        if self.current_token.type != TokenType.I32:
            raise SyntaxError("仅支持 i32 参数类型")
        typ = self.current_token.value
        self.eat(TokenType.I32)
        return Param(name, typ, is_mut)

    def parse_block(self) -> List[ASTNode]:
        # enter block scope (for shadowing)
        self.symtab = self.symtab.enter_scope()
        stmts: List[ASTNode] = []
        while self.current_token.type != TokenType.RBRACE:
            stmts.append(self.parse_statement())
        # exit scope
        self.symtab = self.symtab.exit_scope()
        return stmts

    def parse_statement(self) -> ASTNode:
        t = self.current_token.type
        if t == TokenType.SEMICOLON:  # empty statement
            self.eat(TokenType.SEMICOLON)
            return Empty()
        if t == TokenType.LET:
            return self.parse_vardecl()
        if t == TokenType.RETURN:
            return self.parse_return()
        if t == TokenType.IF:
            return self.parse_if()
        if t == TokenType.WHILE:
            return self.parse_while()
        if t == TokenType.IDENT:
            # could be assign or call
            name = self.current_token.value
            self.eat(TokenType.IDENT)
            if self.current_token.type == TokenType.ASSIGN:
                # assignment checks
                self.symtab.check_var_assignable(name)
                self.eat(TokenType.ASSIGN)
                value = self.parse_expr()
                # after successful parse, mark assigned
                self.symtab.set_assigned(name)
                self.eat(TokenType.SEMICOLON)
                return Assign(name, value)
            elif self.current_token.type == TokenType.LPAREN:
                args = self.parse_args()
                # function call arity check
                self.symtab.check_param_arity(name, len(args))
                self.eat(TokenType.SEMICOLON)
                return FuncCall(name, args)
            else:
                raise SyntaxError(f"未知语句: {name} at line {self.current_token.line}")
        # fallback: expression statement
        expr = self.parse_expr()
        self.eat(TokenType.SEMICOLON)
        return expr

    def parse_vardecl(self) -> VarDecl:
        self.eat(TokenType.LET)
        is_mut = False
        if self.current_token.type == TokenType.MUT:
            is_mut = True
            self.eat(TokenType.MUT)
        name = self.current_token.value
        self.eat(TokenType.IDENT)
        typ: Optional[str] = None
        if self.current_token.type == TokenType.COLON:
            self.eat(TokenType.COLON)
            if self.current_token.type != TokenType.I32:
                raise SyntaxError("仅支持 i32 类型")
            typ = self.current_token.value
            self.eat(TokenType.I32)
        value: Optional[ASTNode] = None
        if self.current_token.type == TokenType.ASSIGN:
            self.eat(TokenType.ASSIGN)
            value = self.parse_expr()
            # mark assigned once for immut var
            # (declare first to allow self-reference in init in future extensions)
        self.eat(TokenType.SEMICOLON)
        # define variable (allows shadowing)
        self.symtab.define_var(name, typ or 'i32', is_mut)
        if value is not None:
            self.symtab.set_assigned(name)
        return VarDecl(name, typ, value, is_mut)

    def parse_return(self) -> Return:
        self.eat(TokenType.RETURN)
        if self.current_token.type == TokenType.SEMICOLON:
            # return;
            # if function expects value -> error
            if self.func_ret_stack and self.func_ret_stack[-1]:
                raise Exception("返回类型是非空，但遇到空 return;")
            self.eat(TokenType.SEMICOLON)
            return Return(None)
        # return expr;
        value = self.parse_expr()
        if self.func_ret_stack and not self.func_ret_stack[-1]:
            raise Exception("函数无返回类型，不能 return 表达式")
        self.eat(TokenType.SEMICOLON)
        return Return(value)

    def parse_if(self) -> If:
        self.eat(TokenType.IF)
        cond = self.parse_expr()
        self.eat(TokenType.LBRACE)
        then_body = self.parse_block()
        self.eat(TokenType.RBRACE)
        else_body = None
        if self.current_token.type == TokenType.ELSE:
            self.eat(TokenType.ELSE)
            self.eat(TokenType.LBRACE)
            else_body = self.parse_block()
            self.eat(TokenType.RBRACE)
        return If(cond, then_body, else_body)

    def parse_while(self) -> While:
        self.eat(TokenType.WHILE)
        cond = self.parse_expr()
        self.eat(TokenType.LBRACE)
        body = self.parse_block()
        self.eat(TokenType.RBRACE)
        return While(cond, body)

    def parse_args(self) -> List[ASTNode]:
        args: List[ASTNode] = []
        self.eat(TokenType.LPAREN)
        if self.current_token.type != TokenType.RPAREN:
            args.append(self.parse_expr())
            while self.current_token.type == TokenType.COMMA:
                self.eat(TokenType.COMMA)
                args.append(self.parse_expr())
        self.eat(TokenType.RPAREN)
        return args

    # precedence: * /   >   + -   >  comparisons
    def parse_expr(self) -> ASTNode:
        return self.parse_cmp()
    def parse_cmp(self) -> ASTNode:
        node = self.parse_addsub()
        while self.current_token.type in (TokenType.EQ, TokenType.NEQ, TokenType.LT, TokenType.GT, TokenType.LE, TokenType.GE):
            op = self.current_token.value
            self.eat(self.current_token.type)
            right = self.parse_addsub()
            node = BinOp(node, op, right)
        return node
    def parse_addsub(self) -> ASTNode:
        node = self.parse_muldiv()
        while self.current_token.type in (TokenType.PLUS, TokenType.MINUS):
            op = self.current_token.value
            self.eat(self.current_token.type)
            right = self.parse_muldiv()
            node = BinOp(node, op, right)
        return node
    def parse_muldiv(self) -> ASTNode:
        node = self.parse_factor()
        while self.current_token.type in (TokenType.MUL, TokenType.DIV):
            op = self.current_token.value
            self.eat(self.current_token.type)
            right = self.parse_factor()
            node = BinOp(node, op, right)
        return node
    def parse_factor(self) -> ASTNode:
        tok = self.current_token
        if tok.type == TokenType.NUMBER:
            self.eat(TokenType.NUMBER)
            return Number(int(tok.value))
        if tok.type == TokenType.IDENT:
            name = tok.value
            self.eat(TokenType.IDENT)
            if self.current_token.type == TokenType.LPAREN:
                args = self.parse_args()
                # arity check was done earlier on call as stmt; also check here for call as expr
                self.symtab.check_param_arity(name, len(args))
                # check: function used as expr must have a return type
                ret = self.symtab.get_function_ret(name)
                if ret is None:
                    raise Exception("无返回值函数不能作为右值")
                return FuncCall(name, args)
            # variable usage: must be declared
            self.symtab.check_declared(name)
            return Var(name)
        if tok.type == TokenType.LPAREN:
            self.eat(TokenType.LPAREN)
            node = self.parse_expr()
            self.eat(TokenType.RPAREN)
            return node
        raise SyntaxError(f"未知表达式 at line {tok.line}")
