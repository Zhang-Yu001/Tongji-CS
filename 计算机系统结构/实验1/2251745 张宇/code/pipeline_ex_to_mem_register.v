`timescale 1ns / 1ps

module pipeline_ex_mem_register(
    input               clock,
    input               reset,

    input               dmem_enable_in,
    input               dmem_write_enable_in,
    input   [1:0]       dmem_type_in,

    input   [31:0]      rs_data_in,
    input   [31:0]      rt_data_in,
    input   [4:0]       rd_write_address_in,
    input               rd_select_in,
    input               rd_write_enable_in,

    input   [31:0]      alu_result_in,

    output reg          dmem_enable_out,
    output reg          dmem_write_enable_out,
    output reg [1:0]    dmem_type_out,

    output reg [31:0]   rs_data_out,
    output reg [31:0]   rt_data_out,
    output reg [4:0]    rd_write_address_out,
    output reg          rd_select_out, 
    output reg          rd_write_enable_out,

    output reg [31:0]   alu_result_out
    );

    always@ (posedge clock or posedge reset) 
    begin
        if(reset) 
        begin
            dmem_enable_out    <= 1'b0;
            dmem_write_enable_out   <= 1'b0;
            dmem_type_out   <= 2'b0;

            rs_data_out     <= 32'b0;
            rt_data_out     <= 32'b0;
            rd_write_address_out    <= 5'b0;
            rd_select_out      <= 1'b0;
            rd_write_enable_out     <= 1'b0;

            alu_result_out  <= 32'b0;
        end
        else 
        begin
            dmem_enable_out    <= dmem_enable_in;
            dmem_write_enable_out   <= dmem_write_enable_in;
            dmem_type_out   <= dmem_type_in;

            rs_data_out     <= rs_data_in;
            rt_data_out     <= rt_data_in;
            rd_write_address_out    <= rd_write_address_in;
            rd_select_out      <= rd_select_in;
            rd_write_enable_out     <= rd_write_enable_in;

            alu_result_out  <= alu_result_in;
        end
    end 

endmodule
