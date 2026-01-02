`timescale 1ns / 1ps

module pipeline_mem_stage(
    input           clock,

    input           dmem_enable,
    input           dmem_write_enable,
    input   [1:0]   dmem_type,

    input   [31:0]  rs_data,
    input   [31:0]  rt_data,
    input   [4:0]   rd_write_address,
    input           rd_select,
    input           rd_write_enable,

    input   [31:0]  alu_result_in,

    output  [4:0]   rd_write_address_out,
    output          rd_select_out,
    output          rd_write_enable_out,

    output  [31:0]  alu_result_out,
    output  [31:0]  dmem_data_out
    );
    
    wire [31:0] memory_address = (alu_result_in - 32'h10010000) / 4;

    assign rd_write_address_out = rd_write_address;
    assign rd_select_out        = rd_select;
    assign rd_write_enable_out  = rd_write_enable;
    
    assign alu_result_out       = alu_result_in;
    
    dmem dmem_inst(
        .clk(clock),
        .ena(dmem_enable),
        .wena(dmem_write_enable),
        .addr(memory_address),
        .dmem_type(dmem_type),
        .data_in(rt_data),
        .data_out(dmem_data_out)
    );

endmodule
