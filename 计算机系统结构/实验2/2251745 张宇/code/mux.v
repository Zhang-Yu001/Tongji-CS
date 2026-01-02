`timescale 1ns / 1ps

module mux2_5bit (
    input [4:0]         input0,
    input [4:0]         input1,
    input               select,
    output reg [4:0]    output_data
);
	
    always @(*) 
    begin
        case (select)
            1'b0: output_data <= input0;
            1'b1: output_data <= input1;
        endcase
    end
	
endmodule

module mux2_32bit (
    input [31:0]        input0,
    input [31:0]        input1,
    input               select,
    output reg [31:0]   output_data
);
	
    always @(*) 
    begin
        case (select)
            1'b0: output_data <= input0;
            1'b1: output_data <= input1;
        endcase
    end
	
endmodule

module mux4_32bit (
    input   [31:0]      input0,
    input   [31:0]      input1,
    input   [31:0]      input2,
    input   [31:0]      input3,
    input   [1:0]       select,
    output reg [31:0]   output_data
);
	
    always @(*) 
    begin
        case (select)
            2'b00: output_data <= input0;
            2'b01: output_data <= input1;
            2'b10: output_data <= input2;
            2'b11: output_data <= input3;
        endcase
    end

endmodule

module mux8_32bit (
    input   [31:0]      input0,
    input   [31:0]      input1,
    input   [31:0]      input2,
    input   [31:0]      input3,
    input   [31:0]      input4,
    input   [31:0]      input5,
    input   [31:0]      input6,
    input   [31:0]      input7,
    input   [2:0]       select,
    output reg [31:0]   output_data
); 
	
    always @(*) 
    begin
        case (select)
            3'b000: output_data <= input0;
            3'b001: output_data <= input1;
            3'b010: output_data <= input2;
            3'b011: output_data <= input3;
            3'b100: output_data <= input4;
            3'b101: output_data <= input5;
            3'b110: output_data <= input6;
            3'b111: output_data <= input7;
        endcase
    end
	
endmodule
