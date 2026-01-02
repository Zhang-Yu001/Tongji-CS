import sys
import os
from lexer import Lexer
from parser import Parser
from ir_generator import IRGenerator
from code_generator import CodeGenerator
from file_io import read_source, write_ir, write_asm

def default_test_code():
    return '''
fn square(mut x:i32) -> i32 {
    return x * x;
}

fn check(mut x:i32) {
    if x > 0 {
        return;
    } else {
        x = x + 1;
    }
}

fn main() {
    let mut a:i32;
    a = 2 + 3 * (4 - 1);
    let mut b = square(a);
    if b >= 20 {
        b = b - 1;
    } else {
        b = b + 1;
    }
    let mut i:i32;
    i = 0;
    while i < 3 {
        i = i + 1;
    }
    check(i);
}
'''

def main():
    # 优先使用命令行参数
    if len(sys.argv) >= 2:
        src_file = sys.argv[1]
        if not os.path.exists(src_file):
            print(f'未找到 {src_file}，将使用默认测试代码并生成 test.rs')
            with open('test.rs', 'w', encoding='utf-8') as f:
                f.write(default_test_code())
            src_file = 'test.rs'
    else:
        # 没有参数，优先找 test.rs
        if os.path.exists('test.rs'):
            src_file = 'test.rs'
        else:
            print('未找到 test.rs，将使用默认测试代码并生成 test.rs')
            with open('test.rs', 'w', encoding='utf-8') as f:
                f.write(default_test_code())
            src_file = 'test.rs'
    code = read_source(src_file)
    print('【1】词法分析...')
    lexer = Lexer(code)
    print('【2】语法分析...')
    parser = Parser(lexer)
    ast = parser.parse()
    print('【3】中间代码生成...')
    irgen = IRGenerator()
    irgen.gen(ast)
    print('【4】目标代码生成...')
    codegen = CodeGenerator(irgen.instructions)
    asm = codegen.generate()
    ir_file = 'test.ir'
    asm_file = 'test.asm'
    print(f'【5】输出中间代码到 {ir_file}')
    write_ir(ir_file, irgen.instructions)
    print(f'【6】输出目标代码到 {asm_file}')
    write_asm(asm_file, asm)
    print('编译完成！')

if __name__ == '__main__':
    main() 