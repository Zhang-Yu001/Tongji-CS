`timescale 1ns / 1ps

module data_register (
    input               clock, 
    input               reset, 
    input               write_enable, 
    input [31:0]        input_data, 
    output reg [31:0]   output_data 
);

    always @(negedge clock or posedge reset)
    begin
        if (reset) 
            output_data <= 32'b0;
        else if (write_enable) 
            output_data <= input_data;
    end

endmodule
