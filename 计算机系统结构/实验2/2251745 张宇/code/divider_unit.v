`timescale 1ns / 1ps

module divider_unit (
    input           reset_signal,
    input           enable_signal,
    input           signed_division,
    input [31:0]    dividend_input,
    input [31:0]    divisor_input,
    output [31:0]   quotient_output,
    output [31:0]   remainder_output
);

    reg negative_flag;
    reg division_negative_flag;
    reg [63:0] dividend_temp;
    reg [63:0] divisor_temp;

    integer idx;

    always @(*) 
    begin
        if (reset_signal) 
        begin
            dividend_temp    <= 64'b0;
            divisor_temp     <= 64'b0;
            negative_flag    <= 1'b0;
            division_negative_flag <= 1'b0;
        end 
        else if (enable_signal) 
        begin
            if (signed_division) 
            begin
                dividend_temp = dividend_input;
                divisor_temp = { divisor_input, 32'b0 }; 
                for (idx = 0; idx < 32; idx = idx + 1)
                begin
                    dividend_temp = dividend_temp << 1;
                    if (dividend_temp >= divisor_temp)
                    begin
                        dividend_temp = dividend_temp - divisor_temp;
                        dividend_temp = dividend_temp + 1;
                    end
                end
                idx = 0;
            end 
            else 
            begin
                dividend_temp    <= dividend_input;
                divisor_temp     <= { divisor_input, 32'b0 };
                negative_flag    <= dividend_input[31] ^ divisor_input[31];
                division_negative_flag <= dividend_input[31];
                
                if (dividend_input[31]) 
                begin
                    dividend_temp = dividend_input ^ 32'hFFFFFFFF;
                    dividend_temp = dividend_temp + 1;
                end
                if (divisor_input[31]) 
                begin
                    divisor_temp = {divisor_input ^ 32'hFFFFFFFF, 32'b0};
                    divisor_temp = divisor_temp + 64'h0000000100000000;
                end 
                for (idx = 0; idx < 32; idx = idx + 1) 
                begin
                    dividend_temp = dividend_temp << 1;
                    if (dividend_temp >= divisor_temp) 
                    begin
                        dividend_temp = dividend_temp - divisor_temp;
                        dividend_temp = dividend_temp + 1;
                    end
                end
                if (division_negative_flag) 
                begin
                    dividend_temp = dividend_temp ^ 64'hFFFFFFFF00000000;
                    dividend_temp = dividend_temp + 64'h0000000100000000;
                end          
                if (negative_flag) 
                begin
                    dividend_temp = dividend_temp ^ 64'h00000000FFFFFFFF;
                    dividend_temp = dividend_temp + 64'h0000000000000001;
                    if (dividend_temp[31:0] == 32'b0) 
                        dividend_temp = dividend_temp - 64'h0000000100000000;
                end
            end
        end
    end

    assign quotient_output = enable_signal ? dividend_temp[31:0] : 32'b0;
    assign remainder_output = enable_signal ? dividend_temp[63:32] : 32'b0;

endmodule
