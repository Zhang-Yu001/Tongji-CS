import re
from enum import Enum, auto
from typing import List, Optional

class TokenType(Enum):
    # 关键字
    FN = auto()
    LET = auto()
    MUT = auto()
    RETURN = auto()
    IF = auto()
    ELSE = auto()
    WHILE = auto()
    # 类型
    I32 = auto()
    # 标识符和常量
    IDENT = auto()
    NUMBER = auto()
    # 运算符
    PLUS = auto()
    MINUS = auto()
    MUL = auto()
    DIV = auto()
    ASSIGN = auto()
    EQ = auto()
    NEQ = auto()
    LT = auto()
    GT = auto()
    LE = auto()
    GE = auto()
    # 分隔符
    LPAREN = auto()
    RPAREN = auto()
    LBRACE = auto()
    RBRACE = auto()
    SEMICOLON = auto()
    COMMA = auto()
    COLON = auto()
    ARROW = auto()
    # 文件结束
    EOF = auto()

class Token:
    def __init__(self, type: TokenType, value: Optional[str] = None, line: int = 0, column: int = 0):
        self.type = type
        self.value = value
        self.line = line
        self.column = column
    def __repr__(self):
        return f"Token({self.type}, {repr(self.value)}, line={self.line}, col={self.column})"

class Lexer:
    KEYWORDS = {
        'fn': TokenType.FN,
        'let': TokenType.LET,
        'mut': TokenType.MUT,
        'return': TokenType.RETURN,
        'if': TokenType.IF,
        'else': TokenType.ELSE,
        'while': TokenType.WHILE,
        'i32': TokenType.I32,
    }
    TOKEN_SPEC = [
        ('NUMBER',   r'\d+'),
        ('IDENT',    r'[a-zA-Z_][a-zA-Z0-9_]*'),
        ('COLON',    r':'),
        ('ARROW',    r'->'),
        ('PLUS',     r'\+'),
        ('MINUS',    r'-'),
        ('MUL',      r'\*'),
        ('DIV',      r'/'),
        ('EQ',       r'=='),
        ('NEQ',      r'!='),
        ('LE',       r'<='),
        ('GE',       r'>='),
        ('LT',       r'<'),
        ('GT',       r'>'),
        ('ASSIGN',   r'='),
        ('LPAREN',   r'\('),
        ('RPAREN',   r'\)'),
        ('LBRACE',   r'\{'),
        ('RBRACE',   r'\}'),
        ('SEMICOLON',r';'),
        ('COMMA',    r','),
        ('SKIP',     r'[ \t]+'),
        ('NEWLINE',  r'\n'),
        ('MISMATCH', r'.'),
    ]
    def __init__(self, code: str):
        self.code = code
        self.tokens: List[Token] = []
        self.current = 0
        self.line = 1
        self.column = 1
        self._tokenize()
    def _tokenize(self):
        tok_regex = '|'.join(f'(?P<{name}>{pattern})' for name, pattern in self.TOKEN_SPEC)
        get_token = re.compile(tok_regex).match
        pos = 0
        code = self.code
        line = 1
        col = 1
        mo = get_token(code, pos)
        while mo:
            kind = mo.lastgroup
            value = mo.group()
            if kind == 'NUMBER':
                self.tokens.append(Token(TokenType.NUMBER, value, line, col))
            elif kind == 'IDENT':
                token_type = self.KEYWORDS.get(value, TokenType.IDENT)
                self.tokens.append(Token(token_type, value, line, col))
            elif kind in TokenType.__members__:
                self.tokens.append(Token(TokenType[kind], value, line, col))
            elif kind == 'NEWLINE':
                line += 1
                col = 0
            elif kind == 'SKIP':
                pass
            elif kind == 'MISMATCH':
                raise RuntimeError(f'非法字符 {value!r} 在第{line}行, 第{col}列')
            pos = mo.end()
            col += len(value)
            mo = get_token(code, pos)
        self.tokens.append(Token(TokenType.EOF, None, line, col))
    def next_token(self) -> Token:
        if self.current < len(self.tokens):
            tok = self.tokens[self.current]
            self.current += 1
            return tok
        return Token(TokenType.EOF)
    def peek_token(self) -> Token:
        if self.current < len(self.tokens):
            return self.tokens[self.current]
        return Token(TokenType.EOF) 