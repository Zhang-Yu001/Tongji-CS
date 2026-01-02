from ir_generator import IRGenerator, IRInstr
from parser import *

class CodeGenerator:
    def __init__(self, ir_instructions):
        self.ir = ir_instructions
        self.asm = []
    def generate(self):
        for instr in self.ir:
            op = instr.op
            args = instr.args
            if op == 'FUNC':
                self.asm.append(f'FUNC {args[0]}:')
            elif op == 'ENDFUNC':
                self.asm.append(f'ENDFUNC {args[0]}')
            elif op == 'VAR':
                self.asm.append(f'MOV {args[0]}, {args[1]}')
            elif op == 'ASSIGN':
                self.asm.append(f'MOV {args[0]}, {args[1]}')
            elif op in ('+', '-', '*', '/', '==', '!=', '<', '>', '<=', '>='):
                # 假设所有操作都为二元操作，结果存入第一个参数
                self.asm.append(f'{self._op_map(op)} {args[0]}, {args[1]}, {args[2]}')
            elif op == 'IFZ':
                self.asm.append(f'JZ {args[0]}, {args[1]}')
            elif op == 'GOTO':
                self.asm.append(f'JMP {args[0]}')
            elif op == 'LABEL':
                self.asm.append(f'{args[0]}:')
            elif op == 'RETURN':
                if args:
                    self.asm.append(f'RET {args[0]}')
                else:
                    self.asm.append('RET')
            elif op == 'CALL':
                # CALL t, func, arg1, arg2...  => CALL func, arg1, arg2; MOV t, RETVAL
                func = args[1]
                call_args = ', '.join(map(str, args[2:]))
                self.asm.append(f'CALL {func}, {call_args}' if call_args else f'CALL {func}')
                self.asm.append(f'MOV {args[0]}, RETVAL')
            else:
                self.asm.append(f'# 未知指令: {instr}')
        return self.asm
    def _op_map(self, op):
        return {
            '+': 'ADD',
            '-': 'SUB',
            '*': 'MUL',
            '/': 'DIV',
            '==': 'EQ',
            '!=': 'NEQ',
            '<': 'LT',
            '>': 'GT',
            '<=': 'LE',
            '>=': 'GE',
        }[op] 