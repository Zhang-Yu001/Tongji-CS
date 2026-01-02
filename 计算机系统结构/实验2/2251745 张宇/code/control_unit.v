`include "mips_def.vh"
`timescale 1ns / 1ps

module control_unit (
    input           branch_taken,
    input [31:0]    processor_status,
    input [31:0]    instruction,

    output [2:0]    pc_select,
    output          immediate_sign,
    output          ext5_select,
    output          rs_read_enable,
    output          rt_read_enable,
    output          alu_a_select,
    output [1:0]    alu_b_select,
    output [3:0]    alu_control,
    output          mul_enable,
    output          div_enable,
    output          clz_enable,
    output          mul_signed,
    output          div_signed,
    output          memory_cutter_sign,
    output          cutter_addr_select,
    output [2:0]    cutter_control,
    output          dmem_enable,
    output          dmem_write_enable,
    output [1:0]    dmem_write_select,
    output [1:0]    dmem_read_select,
    output          eret_signal,
    output [4:0]    cause_output,
    output          exception_flag,
    output [4:0]    cp0_address,
    output          move_from_cp0,
    output          move_to_cp0,
    output          hi_write_enable,
    output          lo_write_enable,
    output          rd_write_enable,
    output [1:0]    hi_select,
    output [1:0]    lo_select,
    output [2:0]    rd_select,
    output [4:0]    destination_register
    );

    wire [5:0] opcode = instruction[31:26];
    wire [5:0] function_code = instruction[5:0];

    wire AddImmediate       = (opcode == 6'b001000);
    wire AddImmediateUnsigned = (opcode == 6'b001001);
    wire AndImmediate       = (opcode == 6'b001100);
    wire OrImmediate        = (opcode == 6'b001101);
    wire SetLessThanImmediateUnsigned = (opcode == 6'b001011);
    wire LoadUpperImmediate = (opcode == 6'b001111);
    wire XorImmediate       = (opcode == 6'b001110);
    wire SetLessThanImmediate = (opcode == 6'b001010);
    wire AddUnsigned        = (opcode == 6'b000000 && function_code == 6'b100001);
    wire AndOperation       = (opcode == 6'b000000 && function_code == 6'b100100);
    wire BranchEqual        = (opcode == 6'b000100);
    wire BranchNotEqual     = (opcode == 6'b000101);
    wire Jump               = (opcode == 6'b000010);
    wire JumpAndLink        = (opcode == 6'b000011);
    wire JumpRegister       = (opcode == 6'b000000 && function_code == 6'b001000);
    wire LoadWord           = (opcode == 6'b100011);
    wire XorOperation       = (opcode == 6'b000000 && function_code == 6'b100110);
    wire NorOperation       = (opcode == 6'b000000 && function_code == 6'b100111);
    wire OrOperation        = (opcode == 6'b000000 && function_code == 6'b100101);
    wire ShiftLeftLogical   = (opcode == 6'b000000 && function_code == 6'b000000);
    wire ShiftLeftLogicalVariable = (opcode == 6'b000000 && function_code == 6'b000100);
    wire SetLessThanUnsigned = (opcode == 6'b000000 && function_code == 6'b101011);
    wire ShiftRightArithmetic = (opcode == 6'b000000 && function_code == 6'b000011);
    wire ShiftRightLogical  = (opcode == 6'b000000 && function_code == 6'b000010);
    wire SubtractUnsigned   = (opcode == 6'b000000 && function_code == 6'b100011);
    wire StoreWord          = (opcode == 6'b101011);
    wire AddOperation       = (opcode == 6'b000000 && function_code == 6'b100000);
    wire SubtractOperation  = (opcode == 6'b000000 && function_code == 6'b100010);
    wire SetLessThan        = (opcode == 6'b000000 && function_code == 6'b101010);
    wire ShiftRightLogicalVariable = (opcode == 6'b000000 && function_code == 6'b000110);
    wire ShiftRightArithmeticVariable = (opcode == 6'b000000 && function_code == 6'b000111);
    wire CountLeadingZeros  = (opcode == 6'b011100 && function_code == 6'b100000);
    wire DivideUnsigned     = (opcode == 6'b000000 && function_code == 6'b011011);
    wire ExceptionReturn    = (opcode == 6'b010000 && function_code == 6'b011000);
    wire JumpAndLinkRegister = (opcode == 6'b000000 && function_code == 6'b001001);
    wire LoadByte           = (opcode == 6'b100000);
    wire LoadByteUnsigned   = (opcode == 6'b100100);
    wire LoadHalfword       = (opcode == 6'b100101);
    wire StoreByte          = (opcode == 6'b101000);
    wire StoreHalfword      = (opcode == 6'b101001);
    wire MoveFromHi         = (opcode == 6'b000000 && function_code == 6'b010000);
    wire MoveFromLo         = (opcode == 6'b000000 && function_code == 6'b010010);
    wire MoveToHi           = (opcode == 6'b000000 && function_code == 6'b010001);
    wire MoveToLo           = (opcode == 6'b000000 && function_code == 6'b010011);
    wire Multiply           = (opcode == 6'b011100 && function_code == 6'b000010);
    wire MultiplyUnsigned   = (opcode == 6'b000000 && function_code == 6'b011001);
    wire SystemCall         = (opcode == 6'b000000 && function_code == 6'b001100);
    wire DivideOperation    = (opcode == 6'b000000 && function_code == 6'b011010);
    wire TrapEqual          = (opcode == 6'b000000 && function_code == 6'b110100);
    wire BranchGreaterEqualZero = (opcode == 6'b000001);
    wire BreakInstruction   = (opcode == 6'b000000 && function_code == 6'b001101);

    assign pc_select[2] = (BranchEqual & branch_taken) | (BranchNotEqual & branch_taken) | (BranchGreaterEqualZero & branch_taken) | ExceptionReturn;
    assign pc_select[1] = ~(Jump | JumpRegister | JumpAndLink | JumpAndLinkRegister | (BranchEqual & branch_taken) | (BranchNotEqual & branch_taken) | (BranchGreaterEqualZero & branch_taken) | ExceptionReturn);
    assign pc_select[0] = ExceptionReturn | exception_flag | JumpRegister | JumpAndLinkRegister;

    assign ext5_select     = ShiftLeftLogicalVariable | ShiftRightArithmeticVariable | ShiftRightLogicalVariable;
    assign immediate_sign  = AddImmediate | AddImmediateUnsigned | SetLessThanImmediateUnsigned | SetLessThanImmediate;

    assign alu_control[3]  = LoadUpperImmediate | ShiftRightLogical | SetLessThan | SetLessThanUnsigned | ShiftLeftLogicalVariable | ShiftRightLogicalVariable | ShiftRightArithmeticVariable | ShiftRightArithmetic | SetLessThanImmediate | SetLessThanImmediateUnsigned | ShiftLeftLogical;
    assign alu_control[2]  = AndOperation | OrOperation | XorOperation | NorOperation | ShiftLeftLogical | ShiftRightLogical | ShiftRightArithmetic | ShiftLeftLogicalVariable | ShiftRightLogicalVariable | ShiftRightArithmeticVariable | AndImmediate | OrImmediate | XorImmediate;
    assign alu_control[1]  = AddOperation | SubtractOperation | XorOperation | NorOperation | SetLessThan | SetLessThanUnsigned | ShiftLeftLogical | ShiftLeftLogicalVariable | AddImmediate | XorImmediate | BranchEqual | BranchNotEqual | SetLessThanImmediate | SetLessThanImmediateUnsigned | BranchGreaterEqualZero | TrapEqual;
    assign alu_control[0]  = SubtractUnsigned | SubtractOperation | OrOperation | NorOperation | SetLessThan | ShiftLeftLogicalVariable | ShiftRightLogicalVariable | ShiftLeftLogical | ShiftRightLogical | SetLessThanImmediate | OrImmediate | BranchEqual | BranchNotEqual | BranchGreaterEqualZero | TrapEqual;

    assign alu_a_select    = ~(ShiftLeftLogical | ShiftRightLogical | ShiftRightArithmetic | DivideOperation | DivideUnsigned | Multiply | MultiplyUnsigned | Jump | JumpRegister | JumpAndLink | JumpAndLinkRegister | MoveFromHi | MoveFromLo | MoveToHi | MoveToLo | CountLeadingZeros | ExceptionReturn | SystemCall | BreakInstruction);
    assign alu_b_select[1] = BranchGreaterEqualZero;
    assign alu_b_select[0] = AddImmediate | AddImmediateUnsigned | AndImmediate | OrImmediate | XorImmediate | SetLessThanImmediate | SetLessThanImmediateUnsigned | LoadByte | LoadByteUnsigned | LoadHalfword | LoadWord | StoreByte | StoreHalfword | StoreWord | LoadUpperImmediate;

    assign mul_enable       = Multiply | MultiplyUnsigned;
    assign div_enable       = DivideOperation | DivideUnsigned;
    assign mul_signed       = Multiply;
    assign div_signed       = DivideOperation;
    assign clz_enable       = CountLeadingZeros;

    assign dmem_enable      = LoadWord | StoreWord | LoadHalfword | StoreHalfword | LoadByte | StoreByte | LoadByteUnsigned | LoadHalfwordUnsigned;
    assign dmem_write_enable = StoreWord | StoreHalfword | StoreByte;
    assign dmem_write_select[1] = StoreHalfword | StoreByte;
    assign dmem_write_select[0] = StoreWord | StoreByte;
    assign dmem_read_select[1] = LoadHalfword | LoadByte | LoadHalfwordUnsigned | LoadByteUnsigned;
    assign dmem_read_select[0] = LoadWord | LoadByte | LoadByteUnsigned;

    assign memory_cutter_sign = LoadHalfword | LoadByte;

    assign cutter_addr_select = ~(StoreByte | StoreHalfword | StoreWord);
    assign cutter_control[2]  = StoreHalfword;
    assign cutter_control[1]  = LoadByte | LoadByteUnsigned | StoreByte;
    assign cutter_control[0]  = LoadHalfword | LoadHalfwordUnsigned | StoreByte;

    assign rs_read_enable   = AddImmediate | AddImmediateUnsigned | AndImmediate | OrImmediate | SetLessThanImmediateUnsigned | XorImmediate | SetLessThanImmediate | AddUnsigned | AndOperation | BranchEqual | BranchNotEqual | JumpRegister | LoadWord | XorOperation | NorOperation | OrOperation | ShiftLeftLogicalVariable | SetLessThanUnsigned | SubtractUnsigned | StoreWord | AddOperation | SubtractOperation | SetLessThan | ShiftRightLogicalVariable | ShiftRightArithmeticVariable | CountLeadingZeros | DivideUnsigned | JumpAndLinkRegister | LoadByte | LoadByteUnsigned | LoadHalfword | StoreByte | StoreHalfword | LoadHalfword | Multiply | MultiplyUnsigned | TrapEqual | DivideOperation;
    assign rt_read_enable   = AddUnsigned | AndOperation | BranchEqual | BranchNotEqual | XorOperation | NorOperation | OrOperation | ShiftLeftLogical | ShiftLeftLogicalVariable | SetLessThanUnsigned | ShiftRightArithmetic | ShiftRightLogical | SubtractUnsigned | StoreWord | AddOperation | SubtractOperation | SetLessThan | ShiftRightLogicalVariable | ShiftRightArithmeticVariable | DivideUnsigned | StoreByte | StoreHalfword | MoveToHi | Multiply | MultiplyUnsigned | TrapEqual | DivideOperation;
    assign rd_write_enable  = AddImmediate | AddImmediateUnsigned | AndImmediate | OrImmediate | SetLessThanImmediateUnsigned | LoadUpperImmediate | XorImmediate | SetLessThanImmediate | AddUnsigned | AndOperation | XorOperation | NorOperation | OrOperation | ShiftLeftLogical | ShiftLeftLogicalVariable | SetLessThanUnsigned | ShiftRightArithmetic | ShiftRightLogical | SubtractUnsigned | AddOperation | SubtractOperation | SetLessThan | ShiftRightLogicalVariable | ShiftRightArithmeticVariable | LoadByte | LoadByteUnsigned | LoadHalfword | LoadHalfwordUnsigned | LoadWord | MoveFromHi | MoveFromLo | CountLeadingZeros | JumpAndLink | JumpAndLinkRegister | MoveFromHi | MoveFromLo | Multiply;

    assign destination_register = (AddOperation | AddUnsigned | SubtractOperation | SubtractUnsigned | AndOperation | OrOperation | XorOperation | NorOperation | SetLessThan | SetLessThanUnsigned | ShiftLeftLogical | ShiftRightLogical | ShiftRightArithmetic | ShiftLeftLogicalVariable | ShiftRightLogicalVariable | ShiftRightArithmeticVariable | CountLeadingZeros | JumpAndLinkRegister | MoveFromHi | MoveFromLo | Multiply) ? 
                                  instruction[15:11] : ((AddImmediate | AddImmediateUnsigned | AndImmediate | OrImmediate | XorImmediate | LoadByte | LoadByteUnsigned | LoadHalfword | LoadHalfwordUnsigned | LoadWord | SetLessThanImmediate | SetLessThanImmediateUnsigned | LoadUpperImmediate | MoveFromHi) ? 
                                  instruction[20:16] : (JumpAndLink ? 5'd31 : 5'b0));

    assign rd_select[2] = ~(BranchEqual | BranchNotEqual | BranchGreaterEqualZero | DivideOperation | DivideUnsigned | StoreByte | MultiplyUnsigned | StoreHalfword | StoreWord | Jump | JumpRegister | JumpAndLink | JumpAndLinkRegister | MoveFromHi | MoveFromLo | MoveToHi | MoveToLo | CountLeadingZeros | ExceptionReturn | SystemCall | TrapEqual | BreakInstruction);
    assign rd_select[1] = Multiply | MoveFromHi | MoveToHi | CountLeadingZeros | MoveFromHi;
    assign rd_select[0] = ~(BranchEqual | BranchNotEqual | BranchGreaterEqualZero | DivideOperation | DivideUnsigned | MultiplyUnsigned | LoadByte | LoadByteUnsigned | LoadHalfword | LoadHalfwordUnsigned | LoadWord | StoreByte | StoreHalfword | StoreWord | Jump | MoveToHi | MoveFromHi | MoveFromLo | MoveToHi | MoveToLo | CountLeadingZeros | ExceptionReturn | SystemCall | TrapEqual | BreakInstruction);

    assign hi_write_enable   = Multiply | MultiplyUnsigned | DivideOperation | DivideUnsigned | MoveToHi;
    assign hi_select[1]      = MoveToHi;
    assign hi_select[0]      = Multiply | MultiplyUnsigned;
    assign lo_write_enable   = Multiply | MultiplyUnsigned | DivideOperation | DivideUnsigned | MoveToLo; 
    assign lo_select[1]      = MoveToLo;
    assign lo_select[0]      = Multiply | MultiplyUnsigned;
    
    assign move_from_cp0     = MoveFromHi;
    assign move_to_cp0       = MoveToHi;

    assign cause_output      = BreakInstruction ? `CAUSE_BREAK : (SystemCall ? `CAUSE_SYSCALL : (TrapEqual ? `CAUSE_TEQ : 5'bz));
    assign eret_signal       = ExceptionReturn; 
    assign cp0_address       = instruction[15:11];
    assign exception_flag    = processor_status[0] && ((SystemCall && processor_status[1]) || (BreakInstruction && processor_status[2]) || (TrapEqual && processor_status[3]));

endmodule
