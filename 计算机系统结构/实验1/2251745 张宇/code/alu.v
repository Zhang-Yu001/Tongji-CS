`timescale 1ns / 1ps

    module alu_block(
        input   [31:0]  input_a,
        input   [31:0]  input_b,
        output  [31:0]  result,
        input   [3:0]   alu_control,
        output          is_zero,
        output          is_carry,
        output          is_negative,
        output          is_overflow
        );
    
    wire signed [31:0] signed_a, signed_b;
    reg [32:0] alu_result;
    
    assign signed_a = input_a;
    assign signed_b = input_b;
    
    parameter ADD   =   4'b0000;
    parameter ADDU  =   4'b0001;
    parameter SUB   =   4'b0010;
    parameter SUBU  =   4'b0011;
    parameter AND   =   4'b0100;
    parameter OR    =   4'b0101;
    parameter XOR   =   4'b0110;
    parameter NOR   =   4'b0111;
    parameter SLT   =   4'b1000;
    parameter SLTU  =   4'b1001;
    parameter SLL   =   4'b1010;
    parameter SRL   =   4'b1011;
    parameter SRA   =   4'b1100;
    parameter LUI   =   4'b1101;
    
    always@ (*)
    begin
        case(alu_control)
            ADD:
            begin
                alu_result = signed_a + signed_b;
            end
            ADDU:
            begin
                alu_result = input_a + input_b;
            end
            SUB:
            begin
                alu_result = signed_a - signed_b;
            end
            SUBU: 
            begin
                alu_result = input_a - input_b;
            end
            AND:
            begin
                alu_result = input_a & input_b;
            end
            OR:
            begin
                alu_result = input_a | input_b;
            end
            XOR:
            begin
                alu_result = input_a ^ input_b;
            end
            NOR:
            begin
                alu_result = ~(input_a | input_b);
            end
            SLT: 
            begin
                alu_result = (signed_a < signed_b);
            end
            SLTU:
            begin
                alu_result = (input_a < input_b);
            end
            SLL:
            begin
                alu_result = (input_b << input_a);
            end
            SRL:
            begin
                if(input_a == 0) 
                    { alu_result[31:0], alu_result[32] } = { input_b, 1'b0 };
                else
                    { alu_result[31:0], alu_result[32] } = input_b >> (input_a - 1);
            end
            SRA:
            begin
                if(input_a == 0) 
                    { alu_result[31:0], alu_result[32] } = { signed_b, 1'b0 };
                else
                    { alu_result[31:0], alu_result[32] } = signed_b >>> (input_a - 1);
            end
            LUI:
            begin
                alu_result = { input_b[15:0], 16'b0 };
            end
        endcase
    end
    
    assign result        = alu_result[31:0];
    assign is_zero       = (alu_result == 32'b0) ? 1'b1 : 1'b0;
    assign is_carry      = alu_result[32];
    assign is_overflow   = alu_result[32] ^ alu_result[31];
    assign is_negative   = alu_result[31];
    
endmodule
