
from dataclasses import dataclass
from typing import Optional, Dict, List, Any

@dataclass
class Symbol:
    name: str
    type: Optional[str] = None     # 'i32' or None (unknown yet)
    is_mut: bool = False
    is_func: bool = False
    params: Optional[List[str]] = None  # param types (e.g., ['i32', 'i32'])
    ret_type: Optional[str] = None
    assigned: bool = False          # whether an immutable var has been assigned once

class SymbolTable:
    def __init__(self, parent: Optional['SymbolTable']=None):
        self.parent = parent
        self.symbols: Dict[str, Symbol] = {}

    # ---- scope ops ----
    def enter_scope(self) -> 'SymbolTable':
        return SymbolTable(parent=self)

    def exit_scope(self) -> 'SymbolTable':
        if not self.parent:
            return self
        return self.parent

    # ---- definitions ----
    def define_var(self, name: str, typ: Optional[str], is_mut: bool, allow_shadow: bool=True):
        # allow shadowing: always put in current scope
        self.symbols[name] = Symbol(name=name, type=typ, is_mut=is_mut, is_func=False)

    def define_func(self, name: str, params: List[str], ret_type: Optional[str]):
        self.symbols[name] = Symbol(name=name, is_func=True, params=params or [], ret_type=ret_type)

    # ---- lookups ----
    def lookup(self, name: str) -> Optional[Symbol]:
        table = self
        while table is not None:
            if name in table.symbols:
                return table.symbols[name]
            table = table.parent
        return None

    def lookup_current(self, name: str) -> Optional[Symbol]:
        return self.symbols.get(name)

    # ---- checks ----
    def check_declared(self, name: str):
        if not self.lookup(name):
            raise Exception(f"变量 {name} 未声明")

    def check_var_assignable(self, name: str):
        sym = self.lookup(name)
        if not sym:
            raise Exception(f"变量 {name} 未声明")
        if sym.is_func:
            raise Exception(f"{name} 是函数名，不能赋值")
        if not sym.is_mut and sym.assigned:
            raise Exception(f"变量 {name} 不可变，已赋值后不能再次赋值")

    def set_assigned(self, name: str):
        sym = self.lookup(name)
        if sym:
            sym.assigned = True

    def check_param_arity(self, fname: str, given: int):
        sym = self.lookup(fname)
        if not sym or not sym.is_func:
            raise Exception(f"函数 {fname} 未声明")
        expect = len(sym.params or [])
        if given != expect:
            raise Exception(f"函数 {fname} 实参数量 {given} 与形参数量 {expect} 不一致")

    def get_function_ret(self, fname: str) -> Optional[str]:
        sym = self.lookup(fname)
        if not sym or not sym.is_func:
            raise Exception(f"函数 {fname} 未声明")
        return sym.ret_type
