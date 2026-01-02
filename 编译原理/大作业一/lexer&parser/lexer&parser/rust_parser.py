import sys

# --------------------------
# 词法分析
# --------------------------
KEYWORDS = {
    'i32', 'let', 'if', 'else', 'while', 'return',
    'mut', 'fn', 'for', 'in', 'loop', 'break', 'continue'
}
TWO_CHAR_OPS = {'==', '>=', '<=', '!=', '->', '..'}
SINGLE_CHAR_SYMS = {
    '+', '-', '*', '/', '=', '<', '>', '(', ')',
    '{', '}', '[', ']', ';', ':', ',', '.', 
}

class Token:
    def __init__(self, type_, value, line, col):
        self.type = type_
        self.value = value
        self.line = line
        self.col = col
    def __repr__(self):
        return f"{self.type}({self.value!r}) at {self.line}:{self.col}"

class Lexer:
    def __init__(self, text):
        self.text = text
        self.pos = 0
        self.line = 1
        self.col = 1
        self.current_char = text[0] if text else None

    def advance(self):
        if self.current_char == '\n':
            self.line += 1
            self.col = 1
        else:
            self.col += 1
        self.pos += 1
        self.current_char = self.text[self.pos] if self.pos < len(self.text) else None

    def peek(self):
        nxt = self.pos + 1
        return self.text[nxt] if nxt < len(self.text) else None

    def skip_whitespace(self):
        while self.current_char and self.current_char.isspace():
            self.advance()

    def skip_comment(self):
        if self.current_char == '/' and self.peek() == '/':
            while self.current_char and self.current_char != '\n':
                self.advance()
        elif self.current_char == '/' and self.peek() == '*':
            self.advance(); self.advance()
            while self.current_char and not (self.current_char=='*' and self.peek()=='/'):
                self.advance()
            if self.current_char:
                self.advance(); self.advance()

    def lex_identifier_or_keyword(self):
        line, col = self.line, self.col
        result = ''
        while self.current_char and (self.current_char.isalnum() or self.current_char == '_'):
            result += self.current_char
            self.advance()
        typ = 'KEYWORD' if result in KEYWORDS else 'IDENT'
        return Token(typ, result, line, col)

    def lex_number(self):
        line, col = self.line, self.col
        num = ''
        while self.current_char and self.current_char.isdigit():
            num += self.current_char
            self.advance()
        return Token('NUMBER', num, line, col)

    def lex(self):
        tokens = []
        while self.current_char:
            if self.current_char.isspace():
                self.skip_whitespace()
                continue
            if self.current_char == '/':
                if self.peek() in {'/','*'}:
                    self.skip_comment()
                    continue
            if self.current_char.isalpha() or self.current_char == '_':
                tokens.append(self.lex_identifier_or_keyword())
                continue
            if self.current_char.isdigit():
                tokens.append(self.lex_number())
                continue
            two = self.current_char + (self.peek() or '')
            if two in TWO_CHAR_OPS:
                line, col = self.line, self.col
                tokens.append(Token('SYMBOL', two, line, col))
                self.advance(); self.advance()
                continue
            if self.current_char in SINGLE_CHAR_SYMS:
                line, col = self.line, self.col
                ch = self.current_char
                tokens.append(Token('SYMBOL', ch, line, col))
                self.advance()
                continue
            raise SyntaxError(f"Unknown char {self.current_char!r} at {self.line}:{self.col}")
        tokens.append(Token('EOF', '', self.line, self.col))
        return tokens

# --------------------------
# AST 节点定义
# --------------------------
class ASTNode: pass

class Program(ASTNode):
    def __init__(self, funcs):
        self.funcs = funcs
    def __repr__(self):
        return f"Program({self.funcs})"

class FuncDecl(ASTNode):
    def __init__(self, head, block):
        self.head = head
        self.block = block
    def __repr__(self):
        return f"FuncDecl({self.head}, {self.block})"

class FuncHead(ASTNode):
    def __init__(self, name, params, rettype):
        self.name = name
        self.params = params
        self.rettype = rettype
    def __repr__(self):
        return f"FuncHead({self.name}, params={self.params}, ret={self.rettype})"

class Param(ASTNode):
    def __init__(self, name, typ):
        self.name = name
        self.typ = typ
    def __repr__(self):
        return f"Param({self.name}:{self.typ})"

class Type(ASTNode):
    def __init__(self, name):
        self.name = name
    def __repr__(self):
        return f"Type({self.name})"

class Block(ASTNode):
    def __init__(self, stmts):
        self.stmts = stmts
    def __repr__(self):
        return f"Block({self.stmts})"

class Stmt(ASTNode): pass
class EmptyStmt(Stmt):
    def __repr__(self):
        return "EmptyStmt()"
class ReturnStmt(Stmt):
    def __init__(self, expr):
        self.expr = expr
    def __repr__(self):
        return f"ReturnStmt({self.expr})"
class VarDeclStmt(Stmt):
    def __init__(self, name, typ):
        self.name = name
        self.typ = typ
    def __repr__(self):
        return f"VarDecl({self.name}:{self.typ})"
class AssignStmt(Stmt):
    def __init__(self, name, expr):
        self.name = name
        self.expr = expr
    def __repr__(self):
        return f"Assign({self.name},{self.expr})"
class IfStmt(Stmt):
    def __init__(self, cond, then_b, else_b):
        self.cond, self.then_b, self.else_b = cond, then_b, else_b
    def __repr__(self):
        return f"If({self.cond}, {self.then_b}, {self.else_b})"
class WhileStmt(Stmt):
    def __init__(self, cond, block):
        self.cond, self.block = cond, block
    def __repr__(self):
        return f"While({self.cond}, {self.block})"
class ExprStmt(Stmt):
    def __init__(self, expr):
        self.expr = expr
    def __repr__(self):
        return f"ExprStmt({self.expr})"

class Expr(ASTNode): pass
class Number(Expr):
    def __init__(self, value):
        self.value = int(value)
    def __repr__(self):
        return f"Num({self.value})"
class Variable(Expr):
    def __init__(self, name):
        self.name = name
    def __repr__(self):
        return f"Var({self.name})"
class BinaryOp(Expr):
    def __init__(self, left, op, right):
        self.left, self.op, self.right = left, op, right
    def __repr__(self):
        return f"BinOp({self.left},{self.op},{self.right})"
class FuncCall(Expr):
    def __init__(self, name, args):
        self.name, self.args = name, args
    def __repr__(self):
        return f"Call({self.name},{self.args})"

# --------------------------
# 语法分析
# --------------------------
class Parser:
    def __init__(self, tokens):
        self.tokens = tokens
        self.pos = 0
        self.current = tokens[0]

    def error(self, msg="Syntax error"):
        t = self.current
        raise SyntaxError(f"{msg} at {t.line}:{t.col}, got {t}")

    def eat(self, type_, val=None):
        if self.current.type == type_ and (val is None or self.current.value == val):
            self.pos += 1
            self.current = self.tokens[self.pos]
        else:
            self.error(f"Expected {type_} {val}")

    def parse_program(self):
        funcs = []
        while self.current.type != 'EOF':
            funcs.append(self.parse_declaration())
        return Program(funcs)

    def parse_declaration(self):
        head = self.parse_func_head()
        block = self.parse_block()
        return FuncDecl(head, block)

    def parse_func_head(self):
        self.eat('KEYWORD','fn')
        name = self.current.value; self.eat('IDENT')
        self.eat('SYMBOL','(')
        params = self.parse_param_list()
        self.eat('SYMBOL',')')
        rettype = None
        if self.current.value == '->':
            self.eat('SYMBOL','->')
            rettype = self.parse_type()
        return FuncHead(name, params, rettype)

    def parse_param_list(self):
        if self.current.value == ')':
            return []
        params = [self.parse_param()]
        while self.current.value == ',':
            self.eat('SYMBOL',',')
            params.append(self.parse_param())
        return params

    def parse_param(self):
        self.eat('KEYWORD','mut')
        name = self.current.value; self.eat('IDENT')
        self.eat('SYMBOL',':')
        typ = self.parse_type()
        return Param(name, typ)

    def parse_type(self):
        if self.current.type=='KEYWORD' and self.current.value=='i32':
            self.eat('KEYWORD','i32')
            return Type('i32')
        self.error("Expected type i32")

    def parse_block(self):
        self.eat('SYMBOL','{')
        stmts = []
        while self.current.value != '}':
            stmts.append(self.parse_statement())
        self.eat('SYMBOL','}')
        return Block(stmts)

    def parse_statement(self):
        # 赋值语句
        if self.current.type=='IDENT' and self.tokens[self.pos+1].value=='=':
            return self.parse_assignment()
        if self.current.value == ';':
            self.eat('SYMBOL',';')
            return EmptyStmt()
        if self.current.type=='KEYWORD' and self.current.value=='return':
            return self.parse_return()
        if self.current.type=='KEYWORD' and self.current.value=='let':
            return self.parse_var_decl()
        if self.current.type=='KEYWORD' and self.current.value=='if':
            return self.parse_if()
        if self.current.type=='KEYWORD' and self.current.value=='while':
            return self.parse_while()
        expr = self.parse_expression()
        self.eat('SYMBOL',';')
        return ExprStmt(expr)

    def parse_assignment(self):
        name = self.current.value
        self.eat('IDENT')
        self.eat('SYMBOL','=')
        expr = self.parse_expression()
        self.eat('SYMBOL',';')
        return AssignStmt(name, expr)

    def parse_return(self):
        self.eat('KEYWORD','return')
        if self.current.value == ';':
            self.eat('SYMBOL',';')
            return ReturnStmt(None)
        expr = self.parse_expression()
        self.eat('SYMBOL',';')
        return ReturnStmt(expr)

    def parse_var_decl(self):
        self.eat('KEYWORD','let')
        self.eat('KEYWORD','mut')
        name = self.current.value; self.eat('IDENT')
        typ = None
        if self.current.value == ':':
            self.eat('SYMBOL',':')
            typ = self.parse_type()
        self.eat('SYMBOL',';')
        return VarDeclStmt(name, typ)

    def parse_if(self):
        self.eat('KEYWORD','if')
        cond = self.parse_expression()
        then_b = self.parse_block()
        else_b = None
        if self.current.type=='KEYWORD' and self.current.value=='else':
            self.eat('KEYWORD','else')
            else_b = self.parse_block()
        return IfStmt(cond, then_b, else_b)

    def parse_while(self):
        self.eat('KEYWORD','while')
        cond = self.parse_expression()
        block = self.parse_block()
        return WhileStmt(cond, block)

    def parse_expression(self):
        return self.parse_comp()

    def parse_comp(self):
        left = self.parse_add()
        if self.current.value in ('<','<=','>','>=','==','!='):
            op = self.current.value; self.eat('SYMBOL',op)
            right = self.parse_add()
            return BinaryOp(left, op, right)
        return left

    def parse_add(self):
        left = self.parse_mul()
        while self.current.value in ('+','-'):
            op = self.current.value; self.eat('SYMBOL',op)
            right = self.parse_mul()
            left = BinaryOp(left, op, right)
        return left

    def parse_mul(self):
        left = self.parse_factor()
        while self.current.value in ('*','/'):
            op = self.current.value; self.eat('SYMBOL',op)
            right = self.parse_factor()
            left = BinaryOp(left, op, right)
        return left

    def parse_factor(self):
        tok = self.current
        if tok.type=='NUMBER':
            self.eat('NUMBER')
            return Number(tok.value)
        if tok.type=='IDENT':
            name = tok.value; self.eat('IDENT')
            if self.current.value == '(':
                args = self.parse_args()
                return FuncCall(name, args)
            return Variable(name)
        if tok.value == '(':
            self.eat('SYMBOL','(')
            expr = self.parse_expression()
            self.eat('SYMBOL',')')
            return expr
        self.error("Invalid factor")

    def parse_args(self):
        self.eat('SYMBOL','(')
        args = []
        if self.current.value != ')':
            args.append(self.parse_expression())
            while self.current.value == ',':
                self.eat('SYMBOL',',')
                args.append(self.parse_expression())
        self.eat('SYMBOL',')')
        return args

if __name__ == '__main__':
    if len(sys.argv) >= 2:
        data = open(sys.argv[1], encoding='utf-8').read()
    else:
        data = sys.stdin.read()
    tokens = Lexer(data).lex()
    ast = Parser(tokens).parse_program()

    with open('tokens.txt', 'w', encoding='utf-8') as f:
        for t in tokens:
            f.write(f"{t}\n")

    with open('ast.txt', 'w', encoding='utf-8') as f:
        f.write(repr(ast))
