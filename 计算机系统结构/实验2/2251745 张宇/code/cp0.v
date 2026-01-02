`include "mips_def.vh"
`timescale 1ns / 1ps

module coprocessor0 (
    input           clk_in,
    input           reset_in,
    input           read_cp0,
    input           write_cp0,
    input   [31:0]  program_counter,
    input   [4:0]   destination_reg,
    input   [31:0]  write_data,
    input           exception_signal,
    input           eret_signal,
    input   [4:0]   cause_code,
    output  [31:0]  read_data_out,
    output  [31:0]  status_out,
    output  [31:0]  exception_address_out
);

    reg [31:0] reg_array [31:0]; // Coprocessor 0 Registers
    integer i;

    always@(posedge clk_in or posedge reset_in)
    begin
        if(reset_in)
        begin
            for(i = 0; i < 32; i = i + 1)
                reg_array[i] <= 32'b0;
        end
        else if(write_cp0)
        begin
            reg_array[destination_reg] <= write_data;
        end
        else if(exception_signal)
        begin
            reg_array[`STATUS] <= { reg_array[`STATUS][26:0], 5'b0 };
            reg_array[`CAUSE]  <= { 25'd0, cause_code, 2'd0 };
            reg_array[`EPC]    <= program_counter;
        end
        else if(eret_signal)
        begin
            reg_array[`STATUS] <= { 5'b0, reg_array[`STATUS][31:5] };
        end    
    end
   
    assign status_out            = reg_array[`STATUS];
    assign exception_address_out = eret_signal ? reg_array[`EPC] : 32'h00400004;  
    assign read_data_out         = read_cp0 ? reg_array[destination_reg] : 32'bz;

endmodule
