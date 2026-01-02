`timescale 1ns / 1ps

module pipeline_mem_to_wb_register(
    input               clock,
    input               reset,

    input       [4:0]   rd_write_address_in,
    input               rd_select_in,
    input               rd_write_enable_in,

    input       [31:0]  alu_result_in,
    input       [31:0]  dmem_data_in,

    output reg  [4:0]   rd_write_address_out,
    output reg          rd_write_enable_out,
    output reg          rd_select_out,

    output reg  [31:0]  alu_result_out,
    output reg  [31:0]  dmem_data_out
    );

    always @(posedge clock or posedge reset) 
    begin
        if(reset == 1'b1) 
        begin
            rd_write_address_out    <= 5'b0;
            rd_select_out           <= 1'b0;
            rd_write_enable_out     <= 1'b0;

            alu_result_out          <= 32'b0;
            dmem_data_out           <= 32'b0;
        end
        else 
        begin
            rd_write_address_out    <= rd_write_address_in;
            rd_select_out           <= rd_select_in;
            rd_write_enable_out     <= rd_write_enable_in;

            alu_result_out          <= alu_result_in;
            dmem_data_out           <= dmem_data_in;
        end
    end 
endmodule
