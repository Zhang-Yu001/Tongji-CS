`include "mips_def.vh"
`timescale 1ns / 1ps

module branch_evaluator(
    input           clk_in,
    input           reset_in,
    input   [31:0]  operand_a, 
    input   [31:0]  operand_b,
    input   [5:0]   operation_code,
    input   [5:0]   function_code,
    input           exception_flag,
    output reg      branch_decision
    );
    
    always@(*) 
    begin
        if(reset_in)
            branch_decision <= 1'b0;
        else if(operation_code == `OP_BEQ) 
            branch_decision <= (operand_a == operand_b);
        else if(operation_code == `OP_BNE) 
            branch_decision <= (operand_a != operand_b);
        else if(operation_code == `OP_BGEZ) 
            branch_decision <= (operand_a >= 0);
        else if(operation_code == `OP_J)
            branch_decision <= 1'b1;
        else if(operation_code == `OP_JR && function_code == `FUNC_JR)
            branch_decision <= 1'b1;
        else if(operation_code == `OP_JAL)
            branch_decision <= 1'b1;
        else if(operation_code == `OP_JALR && function_code == `FUNC_JALR)
            branch_decision <= 1'b1;
        else if(operation_code == `OP_TEQ && function_code == `FUNC_TEQ)
            branch_decision <= (operand_a == operand_b);
        else if(exception_flag)
            branch_decision <= 1'b1;
        else
            branch_decision <= 1'b0;
    end
    
endmodule
