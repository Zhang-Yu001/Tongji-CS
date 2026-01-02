`timescale 1ns / 1ps

module arithmetic_logic_unit (
    input [31:0]    operand1,    
    input [31:0]    operand2, 
    input [3:0]     operation_code,
    output [31:0]   result,
    output          is_zero,
    output          carry_out, 
    output          is_negative, 
    output          overflow_flag
    );

    wire signed [31:0] signed_operand1, signed_operand2;
    reg [32:0] computation_result;
    
    assign signed_operand1 = operand1;
    assign signed_operand2 = operand2;

    always@(*) 
    begin
        case(operation_code)
            4'b0000: computation_result = operand1 + operand2;
            4'b0010: computation_result = signed_operand1 + signed_operand2;
            4'b0001: computation_result = operand1 - operand2;
            4'b0011: computation_result = signed_operand1 - signed_operand2;
            4'b0100: computation_result = operand1 & operand2;
            4'b0101: computation_result = operand1 | operand2;
            4'b0110: computation_result = operand1 ^ operand2;
            4'b0111: computation_result = ~(operand1 | operand2);
            4'b1000: computation_result = { operand2[15:0], 16'b0 };
            4'b1001: computation_result = { operand2[15:0], 16'b0 };
            4'b1011: computation_result = (signed_operand1 < signed_operand2);
            4'b1010: computation_result = (operand1 < operand2);
            4'b1100:
            begin
                if(operand1 == 0) 
                    { computation_result[31:0], computation_result[32] } = { signed_operand2, 1'b0 };
                else
                    { computation_result[31:0], computation_result[32] } = signed_operand2 >>> (operand1 - 1);
            end
            4'b1110: computation_result = operand2 << operand1;
            4'b1111: computation_result = operand2 << operand1;
            4'b1101:
            begin
                if(operand1 == 0) 
                    { computation_result[31:0], computation_result[32] } = { operand2, 1'b0 };
                else
                    { computation_result[31:0], computation_result[32] } = operand2 >> (operand1 - 1);
            end
        endcase
    end
    
    assign result        = computation_result[31:0];

    assign is_zero       = (computation_result == 32'b0) ? 1'b1 : 1'b0;
    assign carry_out     = computation_result[32];
    assign overflow_flag = computation_result[32] ^ computation_result[31];
    assign is_negative   = computation_result[31];
    
endmodule
