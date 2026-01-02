def read_source(filename: str) -> str:
    with open(filename, 'r', encoding='utf-8') as f:
        return f.read()

def write_ir(filename: str, ir_instructions) -> None:
    with open(filename, 'w', encoding='utf-8') as f:
        for instr in ir_instructions:
            f.write(str(instr) + '\n')

def write_asm(filename: str, asm_lines) -> None:
    with open(filename, 'w', encoding='utf-8') as f:
        for line in asm_lines:
            f.write(str(line) + '\n') 