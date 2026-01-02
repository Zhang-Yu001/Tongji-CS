`timescale 1ns / 1ps

module pipeline_wb_stage(
    input   [4:0]   rd_write_address_in,
    input           rd_write_enable_in,
    input           rd_select_in,

    input   [31:0]  alu_result_in,
    input   [31:0]  dmem_data_in,

    output  [4:0]   rd_write_address_out,
    output          rd_write_enable_out,
    output  [31:0]  rd_write_data_out
    );

    assign rd_write_address_out = rd_write_address_in;
    assign rd_write_enable_out  = rd_write_enable_in;
    assign rd_write_data_out    = ~rd_select_in ? dmem_data_in : alu_result_in;

endmodule
