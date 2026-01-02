`timescale 1ns / 1ps

module multiplier_unit (
    input           reset_signal,
    input           enable_signal,     
    input           signed_multiplication, 
    input [31:0]    multiplicand,
    input [31:0]    multiplier,
    output [31:0]   high_output,
    output [31:0]   low_output
);

    reg [31:0] multiplicand_temp;
    reg [31:0] multiplier_temp;
    reg [63:0] product_temp;
    reg [63:0] product_result;
    reg negative_flag;

    integer idx;
	
    always @(*) 
    begin
        if (reset_signal) 
        begin
            multiplicand_temp   <= 32'b0;
            multiplier_temp     <= 32'b0;
            product_result      <= 64'b0;
            negative_flag       <= 1'b0;
        end 
        else if (enable_signal) 
        begin
            if (multiplicand == 0 || multiplier == 0) 
            begin
                product_result <= 64'b0;
            end 
            else if (~signed_multiplication) 
            begin
                product_result = 64'b0;
                for (idx = 0; idx < 32; idx = idx + 1) 
                begin
                    product_temp = multiplier[idx] ? ({32'b0, multiplicand} << idx) : 64'b0;
                    product_result = product_result + product_temp;       
                end
            end 
            else 
            begin
                product_result = 64'b0;
                negative_flag = multiplicand[31] ^ multiplier[31];
                multiplicand_temp = multiplicand;
                multiplier_temp = multiplier;
                if (multiplicand[31]) 
                begin
                    multiplicand_temp = ~multiplicand + 1;
                end
                if (multiplier[31]) 
                begin
                    multiplier_temp = ~multiplier + 1;
                end
                for (idx = 0; idx < 32; idx = idx + 1) 
                begin
                    product_temp = multiplier_temp[idx] ? ({32'b0, multiplicand_temp} << idx) : 64'b0;
                    product_result = product_result + product_temp;       
                end
                if (negative_flag) 
                begin
                    product_result = ~product_result + 1;
                end
            end
        end
    end

    assign low_output = enable_signal ? product_result[31:0]  : 32'b0;
    assign high_output = enable_signal ? product_result[63:32] : 32'b0;
    
endmodule
