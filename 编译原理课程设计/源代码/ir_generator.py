from parser import *
from typing import List, Optional, Union

class IRInstr:
    def __init__(self, op: str, args: List[Union[str, int]]):
        self.op = op
        self.args = args
    def __repr__(self):
        return f'{self.op} {", ".join(map(str, self.args))}'

class IRGenerator:
    def __init__(self):
        self.instructions: List[IRInstr] = []
        self.temp_count = 0
        self.label_count = 0
    def new_temp(self) -> str:
        t = f't{self.temp_count}'
        self.temp_count += 1
        return t
    def new_label(self) -> str:
        l = f'L{self.label_count}'
        self.label_count += 1
        return l
    def gen(self, node: ASTNode) -> Optional[str]:
        method = f'gen_{type(node).__name__}'
        if hasattr(self, method):
            return getattr(self, method)(node)
        else:
            raise NotImplementedError(f'IR 生成未实现: {type(node).__name__}')
    def gen_Program(self, node: Program):
        for func in node.functions:
            self.gen(func)
    def gen_FunctionDef(self, node: FunctionDef):
        self.instructions.append(IRInstr('FUNC', [node.name]))
        for stmt in node.body:
            self.gen(stmt)
        self.instructions.append(IRInstr('ENDFUNC', [node.name]))
    def gen_VarDecl(self, node: VarDecl):
        if node.value:
            val = self.gen(node.value)
            self.instructions.append(IRInstr('VAR', [node.name, val]))
        else:
            self.instructions.append(IRInstr('VAR', [node.name, 0]))
    def gen_Assign(self, node: Assign):
        val = self.gen(node.value)
        self.instructions.append(IRInstr('ASSIGN', [node.name, val]))
    def gen_Return(self, node: Return):
        if node.value:
            val = self.gen(node.value)
            self.instructions.append(IRInstr('RETURN', [val]))
        else:
            self.instructions.append(IRInstr('RETURN', []))
    def gen_If(self, node: If):
        cond = self.gen(node.cond)
        label_else = self.new_label()
        label_end = self.new_label() if node.else_body else label_else
        self.instructions.append(IRInstr('IFZ', [cond, label_else]))
        for stmt in node.then_body:
            self.gen(stmt)
        if node.else_body:
            self.instructions.append(IRInstr('GOTO', [label_end]))
        self.instructions.append(IRInstr('LABEL', [label_else]))
        if node.else_body:
            for stmt in node.else_body:
                self.gen(stmt)
            self.instructions.append(IRInstr('LABEL', [label_end]))
    def gen_While(self, node: While):
        label_begin = self.new_label()
        label_end = self.new_label()
        self.instructions.append(IRInstr('LABEL', [label_begin]))
        cond = self.gen(node.cond)
        self.instructions.append(IRInstr('IFZ', [cond, label_end]))
        for stmt in node.body:
            self.gen(stmt)
        self.instructions.append(IRInstr('GOTO', [label_begin]))
        self.instructions.append(IRInstr('LABEL', [label_end]))
    def gen_BinOp(self, node: BinOp) -> str:
        left = self.gen(node.left)
        right = self.gen(node.right)
        temp = self.new_temp()
        self.instructions.append(IRInstr(node.op, [temp, left, right]))
        return temp
    def gen_Number(self, node: Number) -> str:
        return str(node.value)
    def gen_Var(self, node: Var) -> str:
        return node.name
    def gen_FuncCall(self, node: FuncCall) -> str:
        args = [self.gen(arg) for arg in node.args]
        temp = self.new_temp()
        self.instructions.append(IRInstr('CALL', [temp, node.name] + args))
        return temp 