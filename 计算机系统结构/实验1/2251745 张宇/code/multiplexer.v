`timescale 1ns / 1ps

module mux4to1_5bit(
    input [4:0] data0,
    input [4:0] data1,
    input [4:0] data2,
    input [4:0] data3,
    input [1:0] select,
    output reg [4:0] out_data
    );

    always@(*)
    begin
        case(select)
            2'b00:  out_data <= data0;
            2'b01:  out_data <= data1;   
            2'b10:  out_data <= data2;
            2'b11:  out_data <= data3;
        endcase
    end

endmodule

module mux4to1_32bit(
    input [31:0] data0,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] data3,
    input [1:0] select,
    output reg [31:0] out_data
    );

    always@(*)
    begin
        case(select)
            2'b00:  out_data <= data0;
            2'b01:  out_data <= data1;   
            2'b10:  out_data <= data2;
            2'b11:  out_data <= data3;
        endcase
    end

endmodule
